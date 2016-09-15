//
//  itemsrd.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "HMSegmentedControl.h"

@class MBProgressHUD;
@class AppDelegate;

@interface itemsrd : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn ,*tripconn,*newconn,*canconn,*cntconn;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory;
    IBOutlet UILabel *lbltripname,*lblitemprice, *lblfrom,*lbldate,*lbltodate,*lblto,*lblvolweight,*lblsubcommercial,*lblid,*lblweight,*lblcurrency,*lblrating;
    IBOutlet UITextView *txtdesc;
    NSString *tripid ,*tripuser ,*fromcityid, *tocityid, *fromdate, *todate,*vid,*cat;
    IBOutlet UIImageView *imgview,*imgstar;
    NSMutableDictionary *userdata;
    IBOutlet UIView *viewdetail, *viewservice, *viewweight;
    IBOutlet UILabel *lblservice, *lblw, *lblcarryitem;
    IBOutlet UIButton *btncommercial, *btnmutual,*bntinfo,*btnpolicy;
    NSMutableArray *arrtrips;
    HMSegmentedControl *segmentedControl3;
    IBOutlet UITableView *tblview;
    NSMutableArray *arrtrip;

}
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (nonatomic, strong) NSString * strcommercial;
@property (nonatomic, strong) NSString * strmutual;
@property (nonatomic, strong) NSString * tripid;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * requestid;
@property (nonatomic, strong) NSString * pagefrom;
@property (nonatomic, strong) NSString * touserid;
@property (nonatomic, strong) NSString * isexpired;

-(IBAction)onbtninfoclick:(id)sender;

@end
