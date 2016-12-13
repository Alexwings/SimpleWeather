//
//  WeatherCenter.h
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfo.h"

//enumeration type of different type of weather information
typedef NS_ENUM(NSInteger, WeatherInfoType){
    WeatherInfoTypeDaily,
    WeatherInfoTypeHourly
};

@interface WeatherCenter : NSObject

//getter for daily forcasts
@property(nonatomic, readonly)NSArray *dailyForcasts;
//getter for hourly forcasts
@property(nonatomic, readonly)NSArray *hourlyForcasts;

//custom initialization
-(instancetype)init;

//singleton instance for the current application
+(instancetype)sharedCenter;

//add the weather information to the specific group of information type
-(BOOL)addWeatherFromDic:(NSDictionary *)dic ofType:(WeatherInfoType)type;

//clear all data in the current type group
-(void)clearData;

//handle downloading process, load downloaded data to groups
//update the targets current info with new current weather information
-(void)downloadWithLocation:(NSString *)latitude Longitude: (NSString *)longitude completionHandler: (void(^)(WeatherInfo *cur))completionHandler;

@end
