//
//  searchresultvc.h
//  airlogic
//
//  Created by APPLE on 20/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L3SDKLazyTableView.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface searchresultvc : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,L3SDKLazyTableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*newconn,*fbconn;
    IBOutlet UITableView *tblview;
    NSMutableArray *arrdata;
    NSMutableArray *array;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong)NSMutableArray *arrdata;
@property (weak, nonatomic) IBOutlet L3SDKLazyTableView *lazyTableView;
@property(nonatomic,strong)NSString *fromcity;
@property(nonatomic,strong)NSString *tocity;
@property(nonatomic,strong)NSString *fromdt;
@property(nonatomic,strong)NSString *todt;
@property(nonatomic,strong)NSString *fromzipcode;
@property(nonatomic,strong)NSString *tozipcode;
@property(nonatomic,strong)NSString *commerical;
@property(nonatomic,strong)NSString *mutual;
@property(nonatomic,strong)NSString *subcommercial;
@property(nonatomic,strong)NSString *category;

-(void)loaddata:(int)pageno;
-(void)addspinner;
-(void)removespinner;
@end
