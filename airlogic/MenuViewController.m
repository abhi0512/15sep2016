//
//  SideMenuViewController.m
//  TeenSnap
//
//  Created by admin on 17/09/14.
//  Copyright (c) 2014 TaxSmart Technologies Pvt. Ltd. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "homeViewController.h"
#import "intialview.h"
#import "messagelistvc.h"
#import "howitworkVC.h"
#import "moreinfovc.h"
#import "profilevc.h"
#import "DbHandler.h"
#import "createtripvc.h"
#import "mytriplistvc.h"
#import  "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "tripitemrequestvc.h"
#import "myitemvc.h"
#import "alertvc.h"
#import "inviteview.h"



@interface MenuViewController ()

@end

@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   }

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
//    overlayView = [UIButton buttonWithType:UIButtonTypeCustom];
//    overlayView.frame = self.revealViewController.frontViewController.view.bounds;
//    overlayView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
//    overlayView.tag = 999;
//    [overlayView addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [overlayView addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchDragOutside];
//    [self.revealViewController.frontViewController.view addSubview:overlayView];
//    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
    imgprofile.clipsToBounds=YES;
    
    self.sideMenuScrollView.contentSize = CGSizeMake(220, self.view.frame.size.height);
    
    NSMutableArray *arr = [DbHandler Fetchuserdetail:delegate.struserid];
    
    delegate.strusertype=[[arr objectAtIndex:0]valueForKey:@"usertype"];
    delegate.username=[NSString stringWithFormat:@"%@ %@",[[arr objectAtIndex:0]valueForKey:@"firstname"],[[arr objectAtIndex:0]valueForKey:@"lastname"]];
    
    lblusermode.text=[NSString stringWithFormat:@"In %@ Mode",delegate.strusertype];
     [btnusername setTitle:@"" forState:UIControlStateNormal];
    [btnusername setTitle:[NSString stringWithFormat:@"Hello, %@",[[arr objectAtIndex:0]valueForKey:@"firstname"]] forState:UIControlStateNormal];
    
    NSString *mystr=[[arr objectAtIndex:0]valueForKey:@"thumbprofilepic"];
    mystr=[mystr substringToIndex:5];
    NSString *thumbprofilepic =@"";
    thumbprofilepic =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arr objectAtIndex:0]valueForKey:@"thumbprofilepic"]];
    
//    NSLog(@"%@",mystr);
//    if(![mystr isEqualToString:@"https"])
//    {
//    thumbprofilepic =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arr objectAtIndex:0]valueForKey:@"thumbprofilepic"]];
//    }
//    else
//    {
//         thumbprofilepic=[[arr objectAtIndex:0]valueForKey:@"thumbprofilepic"];
//    }
    NSURL *Imgurl=[NSURL URLWithString:thumbprofilepic];
    if(thumbprofilepic.length != 0 )
    {
        [imgprofile setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
        imgprofile.layer.borderWidth = 2.0;
    }

    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
        [menu2 setTitle:@"My Trips" forState:UIControlStateNormal];
         [menuicon setBackgroundImage:[UIImage imageNamed:@"menu_mytrip.png"] forState:UIControlStateNormal];
        lblusermode.textColor =[UIColor orangeColor];
        
    }
    else
    {
        [menu2 setTitle:@"My Items" forState:UIControlStateNormal];
        [menuicon setBackgroundImage:[UIImage imageNamed:@"menu_item.png"] forState:UIControlStateNormal];
        lblusermode.textColor =[UIColor purpleColor];
        
    }
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}
//- (void)revealToggleAnimated:(BOOL)animated
//{
//    UIButton *overlayView = (UIButton*)[self.view viewWithTag:999];
//    if (overlayView) {
//        [overlayView removeFromSuperview];
//        overlayView = nil;
//    }
//    // rest of the code...
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnhomeclick:(id)sender
{
    
    NSLog(@"home");
    
    // createtripvc *createtrip;
    
    homeViewController *home;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        home=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:home];
    
    [revealController pushFrontViewController:navigationController animated:YES];
    

}
- (IBAction)btnmytrickpclick:(id)sender
{
    NSLog(@"my trip");
    
   // createtripvc *createtrip;
    
    mytriplistvc *mytrip;
    myitemvc *myitem;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        if([delegate.strusertype isEqualToString:@"Flybee"])
        {
        mytrip=[[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mytrip];
            [revealController pushFrontViewController:navigationController animated:YES];

        }
        else
        {
            myitem=[[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myitem];
            [revealController pushFrontViewController:navigationController animated:YES];

        }
    }
    
}
- (IBAction)btnprofileclick:(id)sender
{
        NSLog(@"profile");
    
        profilevc *profile;
    
        SWRevealViewController *revealController = self.revealViewController;
    
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
        {
    
            profile=[[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
        }
    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profile];
    
        [revealController pushFrontViewController:navigationController animated:YES];
}
- (IBAction)btnmessageclick:(id)sender
{
    NSLog(@"messasge");
    
    messagelistvc *message;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        message=[[messagelistvc alloc]initWithNibName:@"messagelistvc" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:message];
    
    [revealController pushFrontViewController:navigationController animated:YES];

}
- (IBAction)btninviteclick:(id)sender
{
       inviteview *invite;
        
        SWRevealViewController *revealController = self.revealViewController;
        
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
        {
            
            invite=[[inviteview alloc]initWithNibName:@"inviteview" bundle:nil];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:invite];
        
         [revealController pushFrontViewController:navigationController animated:YES];
    


}
- (IBAction)btnalertclick:(id)sender
{
    NSLog(@"alert");
    
    alertvc *alert;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        alert=[[alertvc alloc]initWithNibName:@"alertvc" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:alert];
    
    [revealController pushFrontViewController:navigationController animated:YES];

}
- (IBAction)btnmoreinfoclick:(id)sender
{
    NSLog(@"moreinfo");
    
    moreinfovc *moreinfo;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        moreinfo=[[moreinfovc alloc]initWithNibName:@"moreinfovc" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:moreinfo];
    
    [revealController pushFrontViewController:navigationController animated:YES];

}
- (IBAction)btnhowworkclick:(id)sender
{
    NSLog(@"howitwork");
    
    howitworkVC *howwork;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        howwork=[[howitworkVC alloc]initWithNibName:@"howitworkVC" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:howwork];
    
    [revealController pushFrontViewController:navigationController animated:YES];

}

- (IBAction)btntreuqestclick:(id)sender
{
    NSLog(@"tripitemrequest");
    
    // createtripvc *createtrip;
    
    tripitemrequestvc *trip;
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
    {
        
        trip=[[tripitemrequestvc alloc]initWithNibName:@"tripitemrequestvc" bundle:nil];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:trip];
    
    [revealController pushFrontViewController:navigationController animated:YES];

}


//- (IBAction)btnsearchclick:(id)sender
//{
//    homeViewController *homevc;
//    
//        SWRevealViewController *revealController = self.revealViewController;
//    
//        UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//        {
//    
//            homevc=[[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
//        }
//    
//    
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homevc];
//    
//        [revealController pushFrontViewController:navigationController animated:YES];
// 
//    
//}
//- (IBAction)btnsigninclick:(id)sender
//{
//    if([delegate.islogin isEqualToString:@"Yes"])
//    {
//        delegate.islogin=@"N";
//    }
//        
//     signinViewController *signinvc;
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//    {
//        
//        signinvc=[[signinViewController alloc]initWithNibName:@"signinViewController" bundle:nil];
//    }
//    
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signinvc];
//    
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//}
//- (IBAction)btnsignupclick:(id)sender
//{
//    NSLog(@"signup");
//    signupViewController *signupvc;
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//    {
//        
//        signupvc=[[signupViewController alloc]initWithNibName:@"signupViewController" bundle:nil];
//    }
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signupvc];
//    
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//}
//- (IBAction)btnappointmentclick:(id)sender
//{
//    NSLog(@"appointment");
//
//    app_historyViewController *apphistvc;
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//    {
//        
//        apphistvc=[[app_historyViewController alloc]initWithNibName:@"app_historyViewController" bundle:nil];
//    }
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:apphistvc];
//    
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//    
//}
//- (IBAction)btnfavoriteclick:(id)sender
//{
//    NSLog(@"favorite");
//    favViewController *favvc;
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//    {
//        
//        favvc=[[favViewController alloc]initWithNibName:@"favViewController" bundle:nil];
//    }
//    
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:favvc];
//    
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//}
//- (IBAction)btntermsofuseclick:(id)sender
//{
//    NSLog(@"termsofuser");
//    termsViewController *termsvc;
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
//    
//    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
//    {
//        
//        termsvc=[[termsViewController alloc]initWithNibName:@"termsViewController" bundle:nil];
//    }
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:termsvc];
//    
//    [revealController pushFrontViewController:navigationController animated:YES];
//
//}
//- (IBAction)btnourblogclick:(id)sender
//{
//    NSLog(@"blog");
//   // ourblog *blogvc;
//    
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.boldwrench.com/blog/"]];
//    
////    SWRevealViewController *revealController = self.revealViewController;
////    
////    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
////    
////    if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )
////    {
////        
////        blogvc=[[ourblog alloc]initWithNibName:@"ourblog" bundle:nil];
////    }
////    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:blogvc];
////    
////    [revealController pushFrontViewController:navigationController animated:YES];
//
//}

@end