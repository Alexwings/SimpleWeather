//
//  WeatherCenter.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "WeatherCenter.h"
#import "Constant.h"

static NSString *api_path = @"https://api.darksky.net/forecast";

@implementation WeatherCenter

NSMutableArray *daily;
NSMutableArray *hourly;
NSURLSession *session;

@synthesize dailyForcasts, hourlyForcasts;

//getter for daily forcasts
-(NSArray *)dailyForcasts{
    return daily;
}

//getter for hourly forcasts
-(NSArray *)hourlyForcasts{
    return hourly;
}

//custom initialization
-(instancetype)init{
    if(self = [super init]){
        daily = [[NSMutableArray alloc] init];
        hourly = [[NSMutableArray alloc] init];
    }
    return self;
}

//singleton instance for the current application
+(instancetype)sharedCenter{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeatherCenter alloc] init];
    });
    return instance;
}

//add the weather information to the specific group of information type
-(BOOL)addWeatherFromDic:(NSDictionary *)dic ofType:(WeatherInfoType)type{
    WeatherInfo *weather = [[WeatherInfo alloc] initWithDictionary:dic];
    switch (type) {
        case WeatherInfoTypeDaily:
            [daily addObject:weather];
            return YES;
        case WeatherInfoTypeHourly:
            [hourly addObject:weather];
            return YES;
    }
    return NO;
}

//clear all data in the current type group
-(void)clearData{
    [daily removeAllObjects];
    [hourly removeAllObjects];
}

//handle downloading process, load downloaded data to groups
-(void)downloadWithLocation:(NSString *)latitude Longitude:(NSString *)longitude completionHandler:(void (^)(WeatherInfo *current))completionHandler{
    //clear the old data
    [self clearData];
    //get key from supporting file
    NSString *apiPath = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
    NSString *apiKey = [NSDictionary dictionaryWithContentsOfFile:apiPath][@"apiKey"];
    //construct url from the key, latitude and longitude info
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@,%@?exclude=minutely,alerts,flags&units=si",api_path, apiKey, latitude, longitude]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.description);
            return;
        }
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            if([(NSHTTPURLResponse *)response statusCode] != 200){
                NSLog(@"%ld", [(NSHTTPURLResponse *)response statusCode]);
                return;
            }
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *currentDic = jsonData[currentInfoKey];
            NSArray *dailyInfo = [jsonData[dailyInfoKey] objectForKey:dataInfoKey];
            NSArray *hourlyInfo = [jsonData[hourlyInfoKey] objectForKey:dataInfoKey];
            
            for(NSDictionary *d in dailyInfo){
                [self addWeatherFromDic:d ofType:WeatherInfoTypeDaily];
            }
            for(NSDictionary *d in hourlyInfo){
                [self addWeatherFromDic:d ofType:WeatherInfoTypeHourly];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                WeatherInfo *current = [[WeatherInfo alloc] initWithDictionary:currentDic];
                completionHandler(current);
            });
            [session invalidateAndCancel];
            session = nil;
        }
    }] resume];
}

@end
