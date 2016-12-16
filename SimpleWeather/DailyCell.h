//
//  DailyCell.h
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/15/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinLabel;

@end
