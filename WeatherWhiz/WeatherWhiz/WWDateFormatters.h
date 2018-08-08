//
//  WWDateFormatters.h
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWDateFormatters : NSObject

+(NSString *)getFullCalendarDateFromTimestamp:(NSString *)timestamp ForTimezone:(NSString *)timezoneString;
+(NSString *)getDayAbbreviationFromTimestamp:(NSString *)timestamp;

@end
