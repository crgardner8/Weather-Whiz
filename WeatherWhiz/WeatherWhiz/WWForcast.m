//
//  WWWeather.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "WWForcast.h"

@implementation WWForcast  

-(instancetype)initWithJson:(NSDictionary *)json {
    
    self = [super init];
    if (self) {
        self.weatherHi = nearbyint([[json objectForKey:@"temperatureHigh"] floatValue]);
        self.weatherLow = nearbyint([[json objectForKey:@"temperatureLow"] floatValue]);
        self.timestamp = [NSString stringWithFormat:@"%li", [[json objectForKey:@"time"] integerValue]];
    }
    
    return self;
}

@end
