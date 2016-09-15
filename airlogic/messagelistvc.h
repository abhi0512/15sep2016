//
//  messagelistvc.h
//  airlogic
//
//  Created by APPLE on 25/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface messagelistvc : GAITrackedViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn;
    SWRevealViewController *revealController;
    IBOutlet UITableView *tblmessage;
    NSMutableArray *arrmessage;
    NSMutableArray *array;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic,strong)NSMutableArray *arrmessage;
@end
