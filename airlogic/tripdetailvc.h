//
//  tripdetailvc.h
//  airlogic
//
//  Created by APPLE on 11/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface tripdetailvc : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn ,*tripconn ,*requestconn,*chooseconn,*verifyconn,*statusconn;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory ,*arritem;
    IBOutlet UILabel *lbltripname, *lblfrom ,*lblflightname, *lblto,*lblvolume,*lblweight ,*lblvolweight,*lblsubcommercial,*lbldate, *lblmonth,*lblpolicy,*lblid,*lbltime,*lbrating;
    IBOutlet UITextView *txtdesc;
    UIButton *btnsubmit,*btnaccept,*btndecline;
    NSString *tripid ,*tripuser ,*tripdate ,*fromairport,*toairport,*fromcityid,*tocityid,*vid,*cat,*catid,*vprice;
    IBOutlet UIImageView *imgview,*imgstar;
    NSMutableDictionary *userdata;
    IBOutlet UIView *viewdetail, *viewservice, *viewweight, *viewpolicy;
    IBOutlet UILabel *lblservice, *lblw, *lblcarryitem , *lblcancellationpolicy ,*lbcdesc;
    IBOutlet UIButton *btncommercial, *btnmutual,*btnpolicy;
    bool isaccept,iscancel;
    
    
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
