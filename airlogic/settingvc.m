//
//  settingvc.m
//  airlogic
//
//  Created by APPLE on 21/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "settingvc.h"
#import "UIViewController+MJPopupViewController.h"
#import "logoutvc.h"
#import "switchvc.h"
#import "intialview.h"
#import "AppDelegate.h"
#import "DbHandler.h"
#import "SCLAlertView.h"
#import "notificationsetting.h"


@interface settingvc ()

@end

@implementation settingvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Setting";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    lblusertype.text=delegate.strusertype;
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        lblusertype.textColor= [UIColor purpleColor];
    }
    else
    {
        lblusertype.textColor =[UIColor orangeColor];
    }
    
}


-(void)switchaccount:(id)controller didFinishEnteringItem:(NSString *)item
{
    lblusertype.text=item;
}
-(IBAction)onbtnnotificationclick:(id)sender
{
    notificationsetting *notify= [[notificationsetting alloc]initWithNibName:@"notificationsetting" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:notify animated:NO];
}

-(void)logoutaccount:(id)controller didFinishEnteringItem:(NSString *)item
{
    
    if([item isEqualToString:@"logout"])
    {
    [DbHandler deleteDatafromtable:@"delete from usermaster"];
    delegate.struserid=@"";
    delegate.username=@"";
    intialview *view = [[intialview alloc]initWithNibName:@"intialview" bundle:nil];
    [self.navigationController pushViewController:view animated:NO];
    }
}
- (void)back {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtnlogoutclick:(id)sender
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundViewColor=[UIColor whiteColor];
    [alert addButton:@"Logout" target:self selector:@selector(logout)];
    [alert showCustom:self image:[UIImage imageNamed:@"logout"] color:[UIColor orangeColor] title:@"Logout" subTitle:@"Are you sure you want to Logout ?" closeButtonTitle:@"Cancel" duration:0.0f];
}

- (void)logout
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    intialview *view =[[intialview alloc]initWithNibName:@"intialview" bundle:nil];
    [self.navigationController pushViewController:view animated:NO];
    
}
-(IBAction)onbtnsettingclick:(id)sender
{
    switchvc *switchv= [[switchvc alloc]initWithNibName:@"switchvc" bundle:nil];
    switchv.accountdelegate=self;
    [self presentPopupViewController:switchv animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissEverywhere];

}
-(void)dismissPopup
{
    logoutvc *select= [[logoutvc alloc]initWithNibName:@"logoutvc" bundle:nil];
    [self dismissPopupViewController:select animationType:MJPopupViewAnimationFade];
}

-(void)dismissvolPopup
{
    switchvc *swv= [[switchvc alloc]initWithNibName:@"switchvc" bundle:nil];
    [self dismissPopupViewController:swv animationType:MJPopupViewAnimationFade];

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
