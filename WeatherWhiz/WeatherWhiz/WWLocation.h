//
//  WWLocation.h
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface WWLocation : CLLocation

@property (strong, nonatomic) CLLocation *weatherLoc;

@property (strong, nonatomic) NSString *cityStateString;

@property (strong, nonatomic) NSString *timezoneString;

-(BOOL)isEqual:(WWLocation *)location;

@end
