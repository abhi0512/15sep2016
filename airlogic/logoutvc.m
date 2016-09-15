//
//  logoutvc.m
//  airlogic
//
//  Created by APPLE on 16/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "logoutvc.h"
#import <QuartzCore/QuartzCore.h>
#import  "settingvc.h"
#import "intialview.h"
#import "AppDelegate.h"
#import "DbHandler.h"



@interface logoutvc ()

@end

@implementation logoutvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtnlogoutclick:(id)sender
{
    
    settingvc *vc= [[settingvc alloc]init];
    [vc dismissPopup];
    
}
-(IBAction)onbtncancelclick:(id)sender
{
    settingvc *vc= [[settingvc alloc]init];
    [self.logdelegate logoutaccount:self didFinishEnteringItem:@"logout"];
    [vc dismissPopup];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
