//
//  filterVC.h
//  airlogic
//
//  Created by APPLE on 16/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;
@class AppDelegate;

@interface filterVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory,*arrkey,*arrfromcity,*arrtocity,*arrkeyto;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*volconn;
    IBOutlet UIButton *btnresetfilter;
    NSMutableArray *arSelectedRows;NSMutableDictionary *mutabledictionary,*mutabledictionaryto;
    UIDatePicker *fromdatePicker ,*todatePicker;
    IBOutlet UITextField *txtfromcity, *txttocity, *txtfromzipcode, *txttozipcode, *txtfromdate, *txttodate;
     NSMutableString *fromvol,*tovol ;
    UIPickerView *pckrfromcity,*pckrtocity,*pckrfromvol ,*pckrtovol;
    IBOutlet UIButton *btncommercial, *btnmutual;
    NSString *strcommercial,*strmutual,*category,*startdate,*enddate;
    
}
-(IBAction)onbtncommercialclick:(id)sender;
-(IBAction)onbtnmutualclick:(id)sender;
-(IBAction)onbtntickclick:(id)sender;
-(IBAction)onbtnresetclick:(id)sender;
@end
