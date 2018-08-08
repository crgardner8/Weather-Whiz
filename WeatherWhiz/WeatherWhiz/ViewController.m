//
//  ViewController.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "ViewController.h"
#import "AddCityViewController.h"

#import "WWConstants.h"
#import "WWDateFormatters.h"
#import "WWForcast.h"
#import "WWLocation.h"
#import "WWTemperature.h"

@interface ViewController () <CLLocationManagerDelegate, WWLocationDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeCityBarButton;

@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLocTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDayHiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDayLowTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *day1HiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day1LowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day1Label;

@property (weak, nonatomic) IBOutlet UILabel *day2HiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day2LowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day2Label;

@property (weak, nonatomic) IBOutlet UILabel *day3HiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day3LowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day3Label;

@property (weak, nonatomic) IBOutlet UILabel *day4HiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day4LowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day4Label;

@property (weak, nonatomic) IBOutlet UILabel *day5HiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day5LowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *day5Label;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) WWTemperature *temperature;
@property (strong, nonatomic) WWLocation *weatherLoc;
@property (strong, nonatomic) NSMutableArray *locations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Weather Whiz";
    
    [self startedLoadingData];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.locations = [NSMutableArray new];
    [self getWeatherDataFromLocation:self.locationManager.location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - IBAction Method

//Change City Action Method
- (IBAction)changeCityButtonPressed:(UIBarButtonItem *)sender {
    
    AddCityViewController *addCityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCityVC"];
    
    addCityVC.delegate = self;
    addCityVC.locationsList = [NSMutableArray arrayWithArray:self.locations];
    
    [self.navigationController pushViewController:addCityVC animated:YES];
    
}

#pragma mark - WWLocationDelegate Method

-(void)updateViewForLocation:(WWLocation *)weatherLocation FromLocations:(NSArray *)locations{
    
    [self startedLoadingData];
    
    self.weatherLoc = weatherLocation;
    
    self.locations = [locations mutableCopy];
    
    [self getWeatherDataFromLocation:self.weatherLoc.weatherLoc];
}

#pragma mark - Helper Methods

-(void)startedLoadingData {
    self.overlay.alpha = 0.85f;
    [self.activityIndicator startAnimating];
    self.changeCityBarButton.enabled = NO;
}

-(void)dataFinishedLoading {
    
    self.overlay.alpha = 0.0f;
    [self.activityIndicator stopAnimating];
    self.changeCityBarButton.enabled = YES;
}

#pragma mark - Private Methods

//Retrieves weather data from DarkSky
-(void)getWeatherDataFromLocation:(CLLocation *)location {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%f,%f", DSBaseUrl, DSSecretKey,location.coordinate.latitude, location.coordinate.longitude];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (weakSelf.weatherLoc) {
            weakSelf.temperature = [[WWTemperature alloc] initWithJSon:json
                                                    AndWeatherLocation:self.weatherLoc];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateViewForTemperature:weakSelf.temperature];
            });
        } else {
            weakSelf.temperature = [[WWTemperature alloc] initWithJson:json];
            [weakSelf getCityStateFromLocation:weakSelf.temperature.weatherLocation.weatherLoc];
        }
    }];
    [dataTask resume];
}

//Gets the City and State information from location
-(void)getCityStateFromLocation:(CLLocation *)weatherLocation {
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    CLGeocoder *locationGeocoder = [CLGeocoder new];
    __weak typeof(self) weakSelf = self;
    [locationGeocoder reverseGeocodeLocation:weatherLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
        
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            weakSelf.weatherLoc = [WWLocation new];
            weakSelf.weatherLoc.cityStateString = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
            weakSelf.weatherLoc.timezoneString =  placemark.timeZone.abbreviation;
            [weakSelf.temperature updateTemperatureWithWeatherLocation:weakSelf.weatherLoc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateViewForTemperature:weakSelf.temperature];
            });
            
            dispatch_group_leave(serviceGroup);
        }
    }];
}

//Updates View from WWTemperature object
-(void)updateViewForTemperature:(WWTemperature *)temperature {
    
    self.locationLabel.text = temperature.weatherLocation.cityStateString;
    self.dateTimeLabel.text = [WWDateFormatters getFullCalendarDateFromTimestamp:temperature.timestamp ForTimezone:temperature.weatherLocation.timezoneString];
    self.currentLocTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", temperature.temperature];
    self.weatherDescriptionLabel.text = temperature.weatherDescription;
    self.currentDayHiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", temperature.weatherForcast.weatherHi];
    self.currentDayLowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", temperature.weatherForcast.weatherLow];
    
    for (int i = 0; i < 5; i++) {
        
        WWForcast *nextDayForcast = temperature.futureForcast[i];
        
        switch(i) {
            case 0:
                self.day1Label.text = [WWDateFormatters getDayAbbreviationFromTimestamp:nextDayForcast.timestamp];
                self.day1HiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherHi];
                self.day1LowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherLow];
                break;
            case 1:
                self.day2Label.text = [WWDateFormatters getDayAbbreviationFromTimestamp:nextDayForcast.timestamp];
                self.day2HiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherHi];
                self.day2LowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherLow];
                break;
            case 2:
                self.day3Label.text = [WWDateFormatters getDayAbbreviationFromTimestamp:nextDayForcast.timestamp];
                self.day3HiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherHi];
                self.day3LowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherLow];
                break;
            case 3:
                self.day4Label.text = [WWDateFormatters getDayAbbreviationFromTimestamp:nextDayForcast.timestamp];
                self.day4HiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherHi];
                self.day4LowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherLow];
                break;
            case 4:
                self.day5Label.text = [WWDateFormatters getDayAbbreviationFromTimestamp:nextDayForcast.timestamp];
                self.day5HiTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherHi];
                self.day5LowTempLabel.text = [NSString stringWithFormat:@"%li\u00B0", nextDayForcast.weatherLow];
                break;
        }
    }
    
    if (![self.locations containsObject:temperature.weatherLocation]) {
        [self.locations addObject:temperature.weatherLocation];
    }
    [self dataFinishedLoading];
}


@end
