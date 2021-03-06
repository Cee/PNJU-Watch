//
//  InterfaceController.m
//  PNJUForWatch WatchKit Extension
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "InterfaceController.h"

#import "NetworkManager.h"

@interface InterfaceController()
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *controlBtn;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *remainingLabel;
@property (nonatomic) BOOL isLoggedIn;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (id)init
{
    if (self = [super init]) {
        self.username = @"";    // Your username here
        self.password = @"";    // Your password here
    }
    
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if ([[NetworkManager sharedNetworkManager] checkOnline]) {
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingLabel setText:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                                 [json objectForKey:@"username"],
                                                 [json objectForKey:@"payamount"],
                                                 [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout"];
        self.isLoggedIn = YES;
    } else {
        [self.controlBtn setTitle:@"Login"];
        [self.remainingLabel setText:@"未登录"];
        self.isLoggedIn = NO;
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)btnPressed {
    if (self.isLoggedIn) {
        [[NetworkManager sharedNetworkManager] logout];
        [self.controlBtn setTitle:@"Login"];
        [self.remainingLabel setText:@"未登录"];
    } else {
        [[NetworkManager sharedNetworkManager] loginWithUsername:self.username
                                            password:self.password];
        id json = [[NetworkManager sharedNetworkManager] userInfo];
        [self.remainingLabel setText:[NSString stringWithFormat:@"用户名：%@ \n帐号余额：%@ 元\n登录地点：%@",
                                      [json objectForKey:@"username"],
                                      [json objectForKey:@"payamount"],
                                      [json objectForKey:@"area_name"]]];
        [self.controlBtn setTitle:@"Logout"];
    }
    self.isLoggedIn = !self.isLoggedIn;
}



@end



