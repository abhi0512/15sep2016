//
//  moreinfovc.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "moreinfovc.h"
#import "aboutvc.h"
#import "settingvc.h"
#import "helpvc.h"
#import "SWRevealViewController.h"
#import "inviteview.h"
#import "DbHandler.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "faqvc.h"

@interface moreinfovc ()

@end

@implementation moreinfovc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"More Info";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

      // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
}

-(IBAction)onbtnsettingclick:(id)sender
{
    settingvc *setting = [[settingvc alloc]initWithNibName:@"settingvc" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:setting animated:NO];

}
-(IBAction)onbtnaboutclick:(id)sender
{
    aboutvc *about = [[aboutvc alloc]initWithNibName:@"aboutvc" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:about animated:NO];
}
-(IBAction)onbtnfaqclick:(id)sender
{
    faqvc *faq = [[faqvc alloc]initWithNibName:@"faqvc" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:faq animated:NO];
    
}
-(IBAction)onbtnhelpclick:(id)sender
{
    helpvc *help = [[helpvc alloc]initWithNibName:@"helpvc" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:help animated:NO];
    
}
-(IBAction)onbtninviteclick:(id)sender
{
    
    NSString *phnno=[DbHandler GetId:[NSString stringWithFormat:@"select phone from usermaster where id='%@'",delegate.struserid]];
    
    if([phnno length ] > 0)
    {
    inviteview *invite = [[inviteview alloc]initWithNibName:@"inviteview" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:invite animated:NO];
    }
    else
    {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:@"Please enter your mobile number in order to use promition code." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
