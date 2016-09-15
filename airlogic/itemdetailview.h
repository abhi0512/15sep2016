//
//  itemdetailview.h
//  airlogic
//
//  Created by APPLE on 26/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface itemdetailview : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn ,*tripconn ,*requestconn ,*chooseconn,*statusconn;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory;
    IBOutlet UILabel *lbltripname,*lblitemprice,*lblfrom,*lbldate,*lbldateto,*lblto,*lblvolweight,*lblsubcommercial,*lblid,*lblweight,*lblcurrency,*lblrating;
    IBOutlet UITextView *txtdesc;
    UIButton *btnsubmit,*btnaccept,*btndecline;
    NSString *tripid ,*tripuser ,*fromcityid, *tocityid, *fromdate, *todate,*vid,*cat;
    IBOutlet UIImageView *imgview,*imgstar;
    NSMutableDictionary *userdata;
    IBOutlet UIView *viewdetail, *viewservice, *viewweight;
    IBOutlet UILabel *lblservice, *lblw, *lblcarryitem;
    IBOutlet UIButton *btncommercial, *btnmutual,*bntinfo,*btnpolicy;
    NSMutableArray *arrtrips; bool isaccept,iscancel;
}
@property (nonatomic, strong) NSString * strcommercial;
@property (nonatomic, strong) NSString * strmutual;
@property (nonatomic, strong) NSString * tripid;
@property (nonatomic, strong) NSString * itemid;
@property (nonatomic, strong) NSString * requestid;
@property (nonatomic, strong) NSString * pagefrom;
@property (nonatomic, strong) NSString * touserid;
@property (nonatomic, strong) NSString * isexpired;
-(IBAction)onbtnchoosetripclick:(id)sender;
-(IBAction)onbtnacceptclick:(id)sender;
-(IBAction)onbtndelcineclick:(id)sender;
-(IBAction)onbtninfoclick:(id)sender;
@end

