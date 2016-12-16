//
//  Utils.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/15/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString *)convertTime:(NSDate *)time hasDate:(BOOL)day hasTime:(BOOL)hasTime{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [WeatherCenter sharedCenter].timezone;
    if(day){
        format.dateStyle = NSDateFormatterMediumStyle;
    }else{
        format.dateStyle = NSDateFormatterNoStyle;
    }
    if(hasTime){
        format.timeStyle = NSDateFormatterShortStyle;
    }else{
        format.timeStyle = NSDateFormatterNoStyle;
    }
    return [format stringFromDate:time];
}
//find out if the season of the current location
+(BOOL)currentIsWinter: (NSInteger)month{
    double la = [WeatherCenter sharedCenter].getLatitude;
    BOOL isNorth = ((month >= 11 || month < 3) && la > 23.5);
    BOOL isSouth = (month <= 9 && month > 6 && la <= -23.5);
    return isNorth || isSouth;
}

@end
