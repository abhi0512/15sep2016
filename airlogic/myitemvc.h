//
//  myitemvc.h
//  airlogic
//
//  Created by APPLE on 26/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

@interface myitemvc : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn;
    SWRevealViewController *revealController;
    IBOutlet UITableView *tblview;
    NSUInteger numberOfItemsToDisplay;
    NSMutableArray *arractiveitem, *arrpendingitem,*arrexpireditem,*arrcompleted,*arrcanceled;
    UIRefreshControl *refreshControl;
}

@property (nonatomic,strong)NSMutableArray *arrdata;
@property(nonatomic,strong)NSString *type;



@end
