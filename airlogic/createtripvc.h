//
//  createtripvc.h
//  airlogic
//
//  Created by APPLE on 21/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mytriplistvc.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface createtripvc : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    NSString *selectedcategory, *selectedcatid;
    AppDelegate *delegate;
    NSURLConnection *catconn,*volconn,*tripconn;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITableView *tblcategory ,*tblcancelpolicy;
    IBOutlet UIView *viewairport;
    NSMutableArray *arrcategory ,*arrvolume ,*arrcancelpolicy;
    NSMutableArray *arSelectedRows , *arrairport,*arrtoairport,*arrkey;
    IBOutlet UIPickerView *pckrdestination;
    IBOutlet  UIView *volume ,*viewdetail,*viewdesc,*viewairportname,*viewservice,*viewinfo;
    IBOutlet UILabel *lblairport, *lblitem ,*lblpolicy;
    IBOutlet UITextView *txtdesc;
    IBOutlet UITextField *txtvolume;IBOutlet UITextField *txtflightname;
    IBOutlet UITextField *txttripname,*txttripdate, *txttriptime, *txtfromairport, *txttoairport,*txtzipcode,*txttozipcode;
    UIPickerView *pckrfromairport,*pckertoairport,*pckrvloume;
     UIDatePicker *datePicker ,*timepicker;
    UIButton *btnsubmit,*btnserviceinfo,*btnpolciy;
    NSMutableDictionary *mutabledictionary;
    NSMutableString *catstring,*volumeid ;
    IBOutlet UILabel *placeholderLabel;
    UIImageView *img1;
    UIImageView *img2;
    NSIndexPath* checkedIndexPath;
    NSString *tripdt;
    IBOutlet UIButton *checkbox;
    BOOL checkBoxSelected;
}
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (nonatomic, strong) NSString * selectedString;
@property (nonatomic, strong) NSString * strcommercial;
@property (nonatomic, strong) NSString * strmutual;
@property (nonatomic, strong) NSString * selectedpolicy;
@property (nonatomic, strong) NSString *ifromdt;
@property (nonatomic, strong) NSString *itodt;
@property (nonatomic, strong) NSString *_itemid;

@property (nonatomic, strong) NSString * fromcityid;
@property (nonatomic, strong) NSString * tocityid;
@property (nonatomic, strong) NSString * fromzip;
@property (nonatomic, strong) NSString * tozip;
@property (nonatomic, strong) NSString * _volid;
@property (nonatomic, strong) NSString * vol;
@property (nonatomic, strong) NSString * paymenttype;
@property (nonatomic, strong) NSString * itemcategory;


-(IBAction)onbtnsubmitclick:(id)sender;
-(IBAction)onbtncommercialpressed:(id)sender;
-(IBAction)onbtnmutualpressed:(id)sender;
-(IBAction)onbtnserviceclick:(id)sender;
-(void)dismisspolicypopup;
- (void)btninfoclick:(UIButton *)sender;
@end
