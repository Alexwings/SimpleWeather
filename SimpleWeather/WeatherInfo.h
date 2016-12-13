//
//  WeatherInfo.h
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

//Time properties
@property(nonatomic, strong)NSDate *time;
@property(nonatomic, strong)NSDate *sunrise;
@property(nonatomic, strong)NSDate *sunset;

//summary and status properies
@property(nonatomic, strong)NSString *icon;
@property(nonatomic, strong)NSString *summary;

//temperature properties
@property(nonatomic)double tempMin;
@property(nonatomic)double tempMax;
@property(nonatomic)double currentTemp;

//other status
@property(nonatomic)double visibility;
@property(nonatomic)double humidity;
@property(nonatomic)double windspeed;
@property(nonatomic)double chanceOfSonw;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
