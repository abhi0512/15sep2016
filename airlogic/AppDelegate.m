//
//  AppDelegate.m
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "AppDelegate.h"
#import "homeViewController.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "intialview.h"
#import "Reachability.h"
#import "DbHandler.h"
#import "homeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PayPalMobile.h"
#import <linkedin-sdk/LISDK.h>
#import "introview.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"
#import  "profilevc.h"
#include <AudioToolbox/AudioToolbox.h>

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-25568005-2";
static NSString *const kAllowTracking = @"allowTracking";


@interface AppDelegate ()

@end
#define webhost @"http://airlogiq.com/webservices/"

@implementation AppDelegate
@synthesize viewController=_viewController;
@synthesize struserid,username,strusertype,volprice,volid,airlogiqcost,devicetoken,volname,fbemail,fbfname,fblname,logintype,fbid,fbpicture,isviatrip,viatripid,viatuserid,itemfromdt,itemtodt,promocode;

NSString *imgletters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    airlogiqcost=@"20";
    responseData = [NSMutableData data];
    
#warning "Enter your credentials"
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                           PayPalEnvironmentSandbox : @"AXkWT0fvsvwMMtRRY1ESqGfY8IxyinqhGyy7voe4tvDoQFh_KdYs7jIEKM2vNN91lffyBczVgvo0aZUU"}];
    
    [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
    [self logUser];
    
    //This code will work in iOS 8.0 xcode 6.0 or later
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
  
    self.devicetoken=@"123421";
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
  
    
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 10;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-25568005-2"];
    
    [GAI sharedInstance].defaultTracker=tracker;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
    
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    [DbHandler createEditableCopyOfDatabaseIfNeeded];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImage *navimage=[UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navimage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.f green:153/255.f blue:51/255.f alpha:1],NSFontAttributeName:[UIFont fontWithName:@"Roboto-light" size:18]}];
    
    NSString *uid=[DbHandler checkuserexist];
    
    if([uid length]> 0)
    {
        self.struserid=uid;
        self.strusertype=[DbHandler GetId:[NSString stringWithFormat:@"select usertype from usermaster where id='%@'",uid]];
        NSString *fname=[DbHandler GetId:[NSString stringWithFormat:@"select firstname from usermaster where id='%@'",uid]];
        NSString *lname=[DbHandler GetId:[NSString stringWithFormat:@"select lastname from usermaster where id='%@'",uid]];
        
        self.username = [NSString stringWithFormat:@"%@ %@",fname,lname];
        homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
        frontNavigationController = [[UINavigationController alloc] initWithRootViewController:home];
    }
    else
    {
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"hasSeenTutorial"];
        if(![savedValue isEqualToString:@"Y"])
        {
            introview *iview = [[introview alloc] initWithNibName:@"introview" bundle:nil];
            frontNavigationController = [[UINavigationController alloc] initWithRootViewController:iview];
        } else
        {
            intialview *homeview = [[intialview alloc] initWithNibName:@"intialview" bundle:nil];
            frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeview];
        }
    }
    
    MenuViewController *sideMenuVc= [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    
    rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideMenuVc];
    
    SWRevealViewController    *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    self.viewControllerr = revealController;
    
    [self.navController.navigationBar setHidden:YES];
    [rearNavigationController.navigationBar setHidden:YES];
    //[frontNavigationController.navigationBar setHidden:YES];
    self.window.rootViewController = self.viewControllerr;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    // Override point for customization after application launch.
    return YES;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"info@airlogiq.com"];
    [CrashlyticsKit setUserName:@"airlogiq"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
    
    NSLog(@"%s url=%@","app delegate application openURL called ", [url absoluteString]);
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
     return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];

    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (revealController.frontViewPosition == FrontViewPositionRight)
    {
        UIView *lockingView = [UIView new];
        lockingView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
        [lockingView addGestureRecognizer:tap];
        [lockingView addGestureRecognizer:revealController.panGestureRecognizer];
        [lockingView setTag:1000];
        lockingView.backgroundColor=[UIColor redColor];
        [revealController.frontViewController.view addSubview:lockingView];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(lockingView);
        
        [revealController.frontViewController.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"|[lockingView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDictionary]];
        [revealController.frontViewController.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lockingView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDictionary]];
        [lockingView sizeToFit];
    }
    else
        [[revealController.frontViewController.view viewWithTag:1000] removeFromSuperview];
}
+(NSString *)baseurl
{
    NSString *url = webhost;
    return  url;
}

+(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [imgletters characterAtIndex: arc4random_uniform([imgletters length])]];
    }
    
    return randomString;
}
- (BOOL)isConnectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    BOOL isInternet = TRUE;
    if(remoteHostStatus == NotReachable)
    {
        isInternet = NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = TRUE;
    }
    return isInternet;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* pushdeviceToken = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"Device_Token     -----> %@\n",pushdeviceToken);
    self.devicetoken=pushdeviceToken;
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    //self.textView.text = [userInfo description];
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    if (application.applicationState == UIApplicationStateActive)
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        
        
        
        SystemSoundID soundID;
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"sound.mp3", NULL, NULL);
        AudioServicesCreateSystemSoundID(ref, &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AirlogiQ Notification" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alertView show];
    }    
}


@end
