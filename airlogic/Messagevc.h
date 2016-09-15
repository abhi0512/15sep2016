//
//  Messagevc.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInputToolbar.h"
#import "PTSMessagingCell.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface Messagevc : GAITrackedViewController<BHInputToolbarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BHInputToolbar *inputToolbar;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn,*sendmsgconn;
    IBOutlet UITableView *tblmessage;
    NSMutableArray *arrdata;
    NSMutableArray *array;
    UIActivityIndicatorView *spinner;
    UIRefreshControl *refreshControl;
    IBOutlet UIView *viewerror;
    
@private
    BOOL keyboardIsVisible;
}
@property(nonatomic,strong)NSString *msgstatus;
@property(nonatomic,strong)NSString *itemid;
@property(nonatomic,strong)NSString *tripid;
@property(nonatomic,strong)NSString *touserid;
@property (nonatomic, strong) BHInputToolbar *inputToolbar;
@property (nonatomic,strong)NSMutableArray *arrdata;



@end

