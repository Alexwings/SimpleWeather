//
//  WeatherInfo.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "WeatherInfo.h"
#import "Constant.h"

@implementation WeatherInfo

@synthesize time, sunrise, sunset, icon, summary, tempMax, tempMin, currentTemp, visibility, humidity, windspeed, chanceOfSonw;

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    //times in dic are all represented as the number of seconds since 00:00:00, UTC, Jan.1st,1970
    if(dic[timeKey]){
        time = [NSDate dateWithTimeIntervalSince1970:[dic[timeKey] integerValue]];
    }
    if(dic[sunriseKey] && dic[sunsetKey]){
        sunrise = [NSDate dateWithTimeIntervalSince1970:[dic[sunriseKey] integerValue]];
        sunset = [NSDate dateWithTimeIntervalSince1970:[dic[sunsetKey] integerValue]];
    }
    
    icon = dic[iconKey];
    summary = dic[summaryKey];
    
    if(dic[tempMaxKey] && dic[tempMinKey]){
        tempMax = [dic[tempMaxKey] doubleValue];
        tempMin = [dic[tempMinKey] doubleValue];
    }
    if(dic[currentTempKey]){
        currentTemp = [dic[currentTempKey] doubleValue];
    }
    
    visibility = [dic[visibilityKey] doubleValue];
    if(dic[humidityKey]){
        humidity = [dic[humidityKey] doubleValue];
    }
    windspeed = [dic[windspeedKey] doubleValue];
    chanceOfSonw = [dic[probabilityKey] doubleValue];
    return self;
}


@end
