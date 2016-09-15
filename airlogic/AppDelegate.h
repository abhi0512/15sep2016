//
//  AppDelegate.h
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "ViewController.h"
#import "GAI.h"

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>
{
    MenuViewController *viewController;
    // SWRevealViewController *revealController;
    UINavigationController *rearNavigationController;
    UINavigationController *frontNavigationController;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
}

@property (nonatomic, retain) id googleAnalyticsTracker;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewControllerr;
@property (strong,nonatomic)ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property(strong,nonatomic)NSString *struserid;
@property(strong,nonatomic)NSString *username;
@property(strong,nonatomic)NSString *volprice;
@property(strong,nonatomic)NSString *volname;
@property(strong,nonatomic)NSString *volid;
@property(nonatomic, strong) id<GAITracker> tracker;
@property(strong,nonatomic)NSString *itemfromdt;
@property(strong,nonatomic)NSString *itemtodt;

@property(strong,nonatomic)NSString *strusertype;
@property(strong,nonatomic)NSString *devicetoken;
@property(strong,nonatomic)NSString *airlogiqcost;
@property(strong,nonatomic)NSString *isviatrip;
@property(strong,nonatomic)NSString *viatripid;
@property(strong,nonatomic)NSString *viatuserid;
@property(nonatomic,strong)NSString *fbemail;
@property(nonatomic,strong)NSString *fbfname;
@property(nonatomic,strong)NSString *fblname;
@property(nonatomic,strong)NSString *fbid;
@property(nonatomic,strong)NSString *fbpicture;
@property(nonatomic,strong)NSString *logintype;
@property(nonatomic,strong)NSString *promocode;

+(NSString *)baseurl;
-(BOOL)isConnectedToNetwork;
+(NSString *) randomStringWithLength: (int) len ;
@end

