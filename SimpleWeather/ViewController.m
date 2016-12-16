//
//  ViewController.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCenter.h"
#import "Utils.h"

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)WeatherCenter *center;
@property(nonatomic, strong)WeatherInfo *current;
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UILabel *curTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainProbLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibiltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibilityTitle;
@property (weak, nonatomic) IBOutlet UILabel *windTitle;
@property (weak, nonatomic) IBOutlet UILabel *humidTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

//@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
//@property (weak, nonatomic) IBOutlet UIButton *hourlyButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Welcome";
    self.center = [WeatherCenter sharedCenter];

    //hide all the view when enter the view;
    self.backgroudImageView.hidden = true;
    self.launchImageView.image = [UIImage imageNamed:@"launchPic"];
}
- (IBAction)searchBarButtonClicked:(UIBarButtonItem *)sender {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Location Info" message:@"Please input you latitude and longitude information!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 1;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = @"latitude";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 2;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = @"longitude";
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *latitude = [[NSString alloc] init];
        NSString *longitude = [[NSString alloc] init];
        for(UITextField *t in alert.textFields){
            switch (t.tag) {
                case 1:
                    latitude = t.text;
                    break;
                case 2:
                    longitude = t.text;
                    break;
                default:
                    break;
            }
        }
        // show the daily and hourly button, perform the download process here
        [self loadDataAtLatitude: latitude andLongitude: longitude];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionCancel];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)loadDataAtLatitude:(NSString *)la andLongitude: (NSString *)lo{
    //use NSSession to download weather info from web
    [self.center downloadWithLocation:la Longitude:lo completionHandler:^(WeatherInfo *current) {
        self.current = current;
        NSLog(@"%@", current.summary);
        [self updateLabels];
    }];
}

-(void)updateLabels{
    self.launchImageView.hidden = true;
    self.backgroudImageView.hidden = false;
    self.backgroudImageView.image = [UIImage imageNamed:self.current.icon];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^*night*$" options:NSRegularExpressionCaseInsensitive error:nil];
    if([regex numberOfMatchesInString:self.current.icon options:0 range:NSMakeRange(0, self.current.icon.length)] != 0){
        [self textTintToWhite];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.searchButton.tintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    }
    regex = nil;
    self.navigationItem.title = [Utils convertTime:self.current.time hasDate:YES hasTime:YES];
    self.curTempLabel.text = [NSString stringWithFormat:@"%.0f %@", self.current.currentTemp, Celsius];
    self.summaryLabel.text = self.current.summary;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = self.center.timezone;
    NSInteger month = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self.current.time];
    if([Utils currentIsWinter:month]){
        self.rainProbLabel.text = [NSString stringWithFormat:@"Chance of snow: %d%%", (int)(self.current.chanceOfSonw * 100)];
    }else{
        self.rainProbLabel.text = [NSString stringWithFormat:@"Chance of rain: %d%%", (int)(self.current.chanceOfSonw * 100)];
        [self textTintToWhite];
    }
    self.humidLabel.text = [NSString stringWithFormat:@"%.0f%%", self.current.humidity * 100];
    self.windLabel.text = [NSString stringWithFormat:@"%.00f m/s", self.current.windspeed];
    self.visibiltyLabel.text = [NSString stringWithFormat:@"%.00f km", self.current.visibility];
    
    self.tabBarController.viewControllers[1].tabBarItem.enabled = true;
    self.tabBarController.viewControllers[2].tabBarItem.enabled = true;
}



//change the UI text to white
-(void)textTintToWhite{
    self.curTempLabel.textColor = [UIColor whiteColor];
    self.summaryLabel.textColor = [UIColor whiteColor];
    self.rainProbLabel.textColor = [UIColor whiteColor];
    self.humidLabel.textColor = [UIColor whiteColor];
    self.windLabel.textColor = [UIColor whiteColor];
    self.visibiltyLabel.textColor = [UIColor whiteColor];
    self.visibilityTitle.textColor = [UIColor whiteColor];
    self.humidTitle.textColor = [UIColor whiteColor];
    self.windTitle.textColor = [UIColor whiteColor];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *noDigit = [[NSCharacterSet characterSetWithCharactersInString:@"-0123456789."] invertedSet];
    if([string rangeOfCharacterFromSet:noDigit].location != NSNotFound){
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
