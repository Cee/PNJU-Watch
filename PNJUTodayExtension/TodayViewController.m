//
//  TodayViewController.m
//  PNJUTodayExtension
//
//  Created by Cee on 18/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "NetworkManager.h"

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (nonatomic) BOOL isLoggedIn;
@end

@implementation TodayViewController

- (id)init
{
    if (self = [super init]) {
        self.username = @"";    // Your username here
        self.password = @"";    // Your password here
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.preferredContentSize = CGSizeMake(0, 160);
    [self checkStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self checkStatus];
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - IBActions
- (IBAction)btnPressed:(id)sender {
    if (self.isLoggedIn) {
        [[NetworkManager sharedNetworkManager] logout];
        [self.controlBtn setTitle:@"Login" forState:UIControlStateNormal];
        [self.controlBtn setTitle:@"Login" forState:UIControlStateHighlighted];
        [self.remainingLabel setText:@"未登录"];
    } else {
        [[NetworkManager sharedNetworkManager] loginWithUsername:self.username
                                                        password:self.password];
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingLabel setText:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                                 [json objectForKey:@"username"],
                                                 [json objectForKey:@"payamount"],
                                                 [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [self.controlBtn setTitle:@"Logout" forState:UIControlStateHighlighted];
    }
    self.isLoggedIn = !self.isLoggedIn;
}

#pragma mark - Private Method
- (void)checkStatus
{
    if ([[NetworkManager sharedNetworkManager] checkOnline]) {
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingLabel setText:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                          [json objectForKey:@"username"],
                                          [json objectForKey:@"payamount"],
                                          [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [self.controlBtn setTitle:@"Logout" forState:UIControlStateHighlighted];
        self.isLoggedIn = YES;
    } else {
        [self.controlBtn setTitle:@"Login" forState:UIControlStateNormal];
        [self.controlBtn setTitle:@"Login" forState:UIControlStateHighlighted];
        [self.remainingLabel setText:@"未登录"];
        self.isLoggedIn = NO;
    }
}

@end
