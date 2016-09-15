//
//  insurancevc.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

@interface insurancevc : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblinsurance;
    NSMutableArray *arrinsurance;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
    NSString *selectedins,*insid;
    IBOutlet UILabel *lblmsg;
    NSIndexPath* checkedIndexPath;
}
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

-(IBAction)onbtnitemdetailclick:(id)sender;
-(IBAction)onbtncontinueclick:(id)sender;
@end
