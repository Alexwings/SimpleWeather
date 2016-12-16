//
//  HourlyTableViewController.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/15/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "HourlyTableViewController.h"
#import "WeatherCenter.h"
#import "HourlyCell.h"
#import "Utils.h"

@interface HourlyTableViewController ()

@property(nonatomic, strong)WeatherCenter *center;

@end

@implementation HourlyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Next 24 hours";
    self.center = [WeatherCenter sharedCenter];
    self.tableView.allowsSelection = false;
    self.navigationController.navigationBar.barStyle = self.tabBarController.tabBar.barStyle;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.center.hourlyForcasts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HourlyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hourlyCell" forIndexPath:indexPath];
    WeatherInfo *hour = self.center.hourlyForcasts[indexPath.row];
    // Configure the cell...
    cell.timeLabel.text = [Utils convertTime:hour.time hasDate:NO hasTime:YES];
    cell.tempLabel.text = [NSString stringWithFormat:@"%.00f %@", hour.currentTemp, Celsius];
    cell.summaryLabel.text = hour.summary;
    cell.windspeedLabel.text = [NSString stringWithFormat:@"%.0f m/s", hour.windspeed];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
