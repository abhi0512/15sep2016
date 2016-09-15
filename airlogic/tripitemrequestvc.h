//
//  tripitemrequestvc.h
//  airlogic
//
//  Created by APPLE on 24/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "GAITrackedViewController.h"
#import "SWRevealViewController.h"


@class MBProgressHUD;
@class AppDelegate;
@interface tripitemrequestvc : UIViewController<UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn,*canconn;
    SWRevealViewController *revealController;
    IBOutlet UITableView *tblview;
    NSMutableArray *arrtrip;
    HMSegmentedControl *segmentedControl3;
  }

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@end
