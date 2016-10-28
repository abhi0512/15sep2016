//
//  homeViewController.h
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "L3SDKLazyTableView.h"
#import "GAITrackedViewController.h"
#import "currency.h"

@class MBProgressHUD;
@class AppDelegate;
@interface homeViewController : GAITrackedViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,L3SDKLazyTableViewDelegate,currencyAccountDelegate>
{
   SWRevealViewController *revealController;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UIView *viewnetwork;
    NSURLConnection *catconn,*newconn,*fbconn,*verifyconn,*reviewconn;
    IBOutlet UITableView *tblview;
    NSMutableArray *arrdata;
    NSMutableArray *array;
    UIActivityIndicatorView *spinner;
     NSString *errortype;
}

@property (nonatomic,strong)NSMutableArray *arrdata;
@property (weak, nonatomic) IBOutlet L3SDKLazyTableView *lazyTableView;
@property(nonatomic,strong)NSString *fbemail;
@property(nonatomic,strong)NSString *fbfname;
@property(nonatomic,strong)NSString *fblname;
@property(nonatomic,strong)NSString *fbid;
@property(nonatomic,strong)NSString *fbpicture;
@property(nonatomic,strong)NSString *logintype;
-(void)loaddata:(int)pageno;
-(void)dismissPopup;
-(void)addspinner;
-(void)removespinner;
-(IBAction)onbtnadditemclick:(id)sender;
@end
