//
//  WWDateFormatters.m
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "WWDateFormatters.h"

@implementation WWDateFormatters

+(NSString *)getFullCalendarDateFromTimestamp:(NSString *)timestamp ForTimezone:(NSString *)timezoneString {
    
    NSDate *date = [self getDateFromTimestamp:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setCalendar:[NSCalendar autoupdatingCurrentCalendar]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timezoneString]];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEE, MMM d, hh:mm a" options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+(NSString *)getDayAbbreviationFromTimestamp:(NSString *)timestamp {
    
    NSDate *date = [self getDateFromTimestamp:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setCalendar:[NSCalendar autoupdatingCurrentCalendar]];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEE" options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+(NSDate *)getDateFromTimestamp:(NSString *)timestamp {
    
    NSTimeInterval timeInterval=[timestamp integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return date;
}

@end
