//
//  ViewController.m
//  PNJUForWatch
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) BOOL isLoggedIn;
@end

@implementation ViewController

- (id)init
{
    if (self = [super init]) {
        self.usernameTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"kUsername"];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"kPassword"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self checkStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)btnPressed:(id)sender {
    if (self.isLoggedIn) {
        [[NetworkManager sharedNetworkManager] logout];
        [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"Login" forState:UIControlStateHighlighted];
        [self.remainingLabel setText:@"未登录"];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        self.isLoggedIn = !self.isLoggedIn;
    } else {
        if (self.usernameTextField.text != nil && self.passwordTextField.text != nil) {
            [self save];
            [[NetworkManager sharedNetworkManager] loginWithUsername:self.username
                                                            password:self.password];
            id json = [[NetworkManager sharedNetworkManager] userInfo];
            [self.remainingLabel setText:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                          [json objectForKey:@"username"],
                                          [json objectForKey:@"payamount"],
                                          [json objectForKey:@"area_name"]]];
            [self.loginBtn setTitle:@"Logout" forState:UIControlStateNormal];
            [self.loginBtn setTitle:@"Logout" forState:UIControlStateHighlighted];
            self.usernameTextField.enabled = NO;
            self.passwordTextField.enabled = NO;
            self.isLoggedIn = !self.isLoggedIn;
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名密码不为空"
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好的"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)savBtnPressed:(id)sender
{
    [self save];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好的"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
        [self.loginBtn setTitle:@"Logout" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"Logout" forState:UIControlStateHighlighted];
        self.usernameTextField.enabled = NO;
        self.passwordTextField.enabled = NO;
        self.isLoggedIn = YES;
    } else {
        [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginBtn setTitle:@"Login" forState:UIControlStateHighlighted];
        [self.remainingLabel setText:@"未登录"];
        self.usernameTextField.enabled = YES;
        self.passwordTextField.enabled = YES;
        self.isLoggedIn = NO;
    }
}

- (void)save
{
    self.username = self.usernameTextField.text;
    self.password = self.passwordTextField.text;
    [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"kUsername"];
    [[NSUserDefaults standardUserDefaults] setValue:self.password forKey:@"kPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
