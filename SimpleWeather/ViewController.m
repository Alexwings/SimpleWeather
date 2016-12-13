//
//  ViewController.m
//  SimpleWeather
//
//  Created by Xinyuan Wang on 12/12/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCenter.h"

static NSString *latitudeKey = @"latitude";
static NSString *longitudeKey = @"longitude";

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic, strong)WeatherCenter *center;
@property(nonatomic, strong)WeatherInfo *current;

@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UILabel *curTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *curTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainProbLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibiltyLabel;

@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *hourlyButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.center = [WeatherCenter sharedCenter];
    self.title = @"Welcome";
    //add border to buttons
    self.dailyButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.dailyButton.layer.borderWidth = 0.2;
    self.hourlyButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.hourlyButton.layer.borderWidth = 0.2;
    //hide all the view when enter the view;
    self.backgroudImageView.hidden = true;
}
- (IBAction)searchBarButtonClicked:(UIBarButtonItem *)sender {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Location Info" message:@"Please input you latitude and longitude information!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 1;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"latitude";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = 2;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
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
   //TODO: refresh labels and status of buttons for new current weather information
    assert(NO);
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
