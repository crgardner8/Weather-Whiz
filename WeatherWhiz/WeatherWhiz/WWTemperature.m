//
//  WWTemperature.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "WWTemperature.h"

@implementation WWTemperature

-(instancetype)initWithJson:(NSDictionary *)json {
    
    self = [super init];
    if (self) {
        
        self.weatherLocation = [WWLocation new];
        self.weatherLocation.weatherLoc = [[CLLocation alloc] initWithLatitude:[json[@"latitude"] floatValue]  longitude:[json[@"longitude"] floatValue]];
        self.weatherLocation.cityStateString = [NSString new];
        
        [self updateTemperatureWeatherDescriptionAndTimestampWithJson:json[@"currently"]];
        
        NSDictionary *dailyForcastJson = json[@"daily"];
        NSArray *dailyForcast = [dailyForcastJson[@"data"] copy];
        [self updateForcastWithJson:dailyForcast];
    }
    
    return self;
}

-(instancetype)initWithJSon:(NSDictionary *)json AndWeatherLocation:(WWLocation *)weatherLocation {
    self = [super init];
    if (self) {
        [self updateTemperatureWithWeatherLocation:weatherLocation];
        [self updateTemperatureWeatherDescriptionAndTimestampWithJson:json[@"currently"]];
        
        NSDictionary *dailyForcastJson = json[@"daily"];
        NSArray *dailyForcast = [dailyForcastJson[@"data"] copy];
        [self updateForcastWithJson:dailyForcast];
    }
    
    return self;
}

-(void)updateTemperatureWithWeatherLocation:(WWLocation *)weatherLocation {
    
    self.weatherLocation = weatherLocation;

}

-(void)updateTemperatureWeatherDescriptionAndTimestampWithJson:(NSDictionary *)json {
    
    self.temperature = nearbyint([json[@"temperature"] floatValue]);
    self.weatherDescription = json[@"summary"];
    self.timestamp = [NSString stringWithFormat:@"%li", [json[@"time"] integerValue]];
    
}

-(void)updateForcastWithJson:(NSArray *)json {
    
    NSMutableArray *dailyForcast = [json mutableCopy];
    NSDictionary *currentTemp = [dailyForcast firstObject];
    
    self.weatherForcast = [[WWForcast alloc] initWithJson:currentTemp];
    
    [dailyForcast removeObject:currentTemp];
    self.futureForcast = [[NSArray alloc] initWithArray:[self getFiveDayForcastFromJson:dailyForcast]];
}

-(NSArray *)getFiveDayForcastFromJson:(NSArray *)json {
    
    NSMutableArray * nextForcasts = [NSMutableArray new];
    
    for (NSDictionary *data in json) {
        WWForcast *newForcast = [[WWForcast alloc] initWithJson:data];
        [nextForcasts addObject:newForcast];
    }
    
    return nextForcasts;
}
@end
