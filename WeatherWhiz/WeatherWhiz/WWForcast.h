//
//  WWWeather.h
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWForcast : NSObject

@property (assign, nonatomic) NSInteger weatherHi;
@property (assign, nonatomic) NSInteger weatherLow;
@property (strong, nonatomic) NSString *timestamp;

-(instancetype)initWithJson:(NSDictionary *)json;

@end
