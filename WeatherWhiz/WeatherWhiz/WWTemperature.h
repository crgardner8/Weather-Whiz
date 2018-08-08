//
//  WWTemperature.h
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WWForcast.h"
#import "WWLocation.h"

@interface WWTemperature : NSObject

@property (strong, nonatomic) WWLocation *weatherLocation;
@property (strong, nonatomic) NSString *timestamp;
@property (assign, nonatomic) NSInteger temperature;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) WWForcast *weatherForcast;

@property (strong, nonatomic) NSArray *futureForcast;

-(instancetype)initWithJson:(NSDictionary *)json;
-(instancetype)initWithJSon:(NSDictionary *)json AndWeatherLocation:(WWLocation *)weatherLocation;

-(void)updateTemperatureWithWeatherLocation:(WWLocation *)weatherLocation;

@end
