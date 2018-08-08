//
//  WWLocation.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "WWLocation.h"

@implementation WWLocation

-(BOOL)isEqual:(WWLocation *)location {
    
    if ([self.cityStateString isEqualToString:location.cityStateString] &&
        (self.weatherLoc.coordinate.latitude == location.coordinate.latitude &&
         self.weatherLoc.coordinate.longitude == location.coordinate.longitude)) {
            
            return YES;
        }
    
    return NO;
}

@end
