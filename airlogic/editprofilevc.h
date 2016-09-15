//
//  editprofilevc.h
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"


@class  AppDelegate,MBProgressHUD;
@interface editprofilevc : GAITrackedViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITextField *txtphone, *txtemail, *txtzipcode, *txtbank, *txtaccountno,*txtroutinno ,*txtcountry, *txtfname,*txtlname,*txtcity,*txtstate ,*txtcode,*txtlinkedin;
    NSString *userrating,*gender, *emailverified,*corpemailverified,*linkedinnlink,*mobileverified,*profilepic,*corpemail,*thumbprofilepic,*usertype,*status,*userid ,*uploadid,*country,*state,*city;
    IBOutlet UITextView *txtdesc;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSMutableArray *arrcountry, *arrcity, *arrstate,*arrcode;
    UIPickerView *pckrcountry,*pckrstate,*pckrcity,*pckrcode;
    NSString *strcntryid, *strstateid, *strcityid , *strusertype;
    IBOutlet UIButton *btnflybee, *btnsender , *btnsubmit ,*btnedit;
    IBOutlet UIView *viewflybee, *viewsender;
    NSURLConnection *updconn,*profileconn,*verifyconn;
    IBOutlet UIImageView *imgprofile;
     NSString *isuploaded;
    IBOutlet UILabel *placeholderLabel;
    IBOutlet UILabel *lblbankdt;
    IBOutlet UIView  *viewbankdetail;
}
@property(nonatomic,strong)NSString *phoneno;
@property(nonatomic,strong)NSString *phonecode;
@property(nonatomic,strong)NSString *pagefrom;
@property(nonatomic,strong)NSString *tripid;
-(IBAction)onbtnupdatelcick:(id)sender;
-(IBAction)onbtnflybeeclick:(id)sender;
-(IBAction)onbtnsenderclick:(id)sender;
-(IBAction)onbtneditclick:(id)sender;
@end
