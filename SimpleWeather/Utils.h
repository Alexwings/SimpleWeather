//
//  Utils.h
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/15/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCenter.h"


@interface Utils : NSObject


+(NSString *)convertTime:(NSDate *)time hasDate:(BOOL)day hasTime:(BOOL)hasTime;
+(BOOL)currentIsWinter: (NSInteger)month;

@end
