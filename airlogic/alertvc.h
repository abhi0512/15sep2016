//
//  alertvc.h
//  airlogic
//
//  Created by APPLE on 20/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

@interface alertvc : GAITrackedViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblnotification;
    NSMutableArray *arrdata;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn ,*conndelete;
    SWRevealViewController *revealController;
    UIRefreshControl *refreshControl;
}


@end
