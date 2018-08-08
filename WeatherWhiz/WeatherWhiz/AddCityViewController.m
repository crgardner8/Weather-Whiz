//
//  AddLocationViewController.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "AddCityViewController.h"

@interface AddCityViewController ()

@property (weak, nonatomic) IBOutlet UITextField *cityStateTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;

@end

@implementation AddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Add City";
    
    if (self.locationsList == nil) {
        self.locationsList = [NSMutableArray new];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCityButtonPressed:(UIButton *)sender {

    if(self.cityStateTextField.text != nil && ![self.cityStateTextField.text isEqualToString:@""]) {
        [self getLocationFromCityAndState:self.cityStateTextField.text];
    }
}

#pragma mark - Tableview Delegate and Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.locationsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cityStateCellIdentifier";
    UITableViewCell *locationCell = [self.locationTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!locationCell) {
        locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WWLocation *location = self.locationsList[indexPath.row];
    
    locationCell.textLabel.text = location.cityStateString;
    locationCell.detailTextLabel.text = [NSString stringWithFormat:@"%f,%f", location.weatherLoc.coordinate.latitude, location.weatherLoc.coordinate.longitude];
    
    return locationCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WWLocation *location = self.locationsList[indexPath.row];
    if([_delegate respondsToSelector:@selector(updateViewForLocation:FromLocations:)]) {
        
        [_delegate updateViewForLocation:location FromLocations:self.locationsList];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private Method

-(void)getLocationFromCityAndState:(NSString *) cityStateString {
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    CLGeocoder *cityStateGeocoder = [CLGeocoder new];
    __weak typeof(self) weakSelf = self;
    [cityStateGeocoder geocodeAddressString:cityStateString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            
            WWLocation *location = [WWLocation new];
            location.cityStateString = cityStateString;
            location.weatherLoc = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            location.timezoneString = placemark.timeZone.abbreviation;
            [weakSelf.locationsList addObject:location];
            weakSelf.cityStateTextField.text = @"";
            [weakSelf.locationTableView reloadData];
            
            dispatch_group_leave(serviceGroup);
        }
    }];
}

@end
