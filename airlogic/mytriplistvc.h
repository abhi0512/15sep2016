//
//  mytriplistvc.h
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface mytriplistvc : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn;
    SWRevealViewController *revealController;
    IBOutlet UITableView *tblview;
    NSUInteger numberOfItemsToDisplay;
    NSMutableArray *arractivetrip, *arrpendingtrip,*arrexpiredtrip,*arrcompleted,*arrcanceled;
    UIRefreshControl *refreshControl;
}

@property (nonatomic,strong)NSMutableArray *arrdata;
@property(nonatomic,strong)NSString *type;



@end
