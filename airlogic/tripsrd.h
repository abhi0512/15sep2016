//
//  tripsrd.h
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
@interface tripsrd : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn ,*tripconn,*newconn,*canconn;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory ,*arritem;
    IBOutlet UILabel *lbltripname, *lblfrom ,*lblflightname, *lblto,*lblvolume,*lblweight ,*lblvolweight,*lblsubcommercial,*lbldate, *lblmonth,*lblpolicy,*lblid,*lbltime,*lblrating;
    IBOutlet UITextView *txtdesc;
    NSString *tripid ,*tripuser ,*tripdate ,*fromairport,*toairport,*fromcityid,*tocityid,*vid,*cat,*catid,*vprice;
    IBOutlet UIImageView *imgview,*imgstar;
    NSMutableDictionary *userdata;
    IBOutlet UIView *viewdetail, *viewservice, *viewweight, *viewpolicy;
    IBOutlet UILabel *lblservice, *lblw, *lblcarryitem , *lblcancellationpolicy ,*lbcdesc;
    IBOutlet UIButton *btncommercial, *btnmutual,*btnpolicy;
    HMSegmentedControl *segmentedControl3;
    IBOutlet UITableView *tblview;
    NSMutableArray *arrtrip;

    
}
@property (nonatomic, strong) NSString * strcommercial;
@property (nonatomic, strong) NSString * strmutual;
@property (nonatomic, strong) NSString * tripid;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * requestid;
@property (nonatomic, strong) NSString * pagefrom;
@property (nonatomic, strong) NSString * isexpired;
@property (nonatomic, strong) NSString * touserid;
-(IBAction)onbtnchoosetripclick:(id)sender;
-(IBAction)onbtnacceptclick:(id)sender;
-(IBAction)onbtndelcineclick:(id)sender;
-(IBAction)onbtninfoclick:(id)sender;
@end


