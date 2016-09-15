//
//  itemdetailvc.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectcategory.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface itemdetailvc : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate,CategoryControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    IBOutlet UILabel *lblcategory;
    AppDelegate *delegate;
    NSMutableArray *arritemdetail,*arrvolume,*arrkey;
    IBOutlet UITextField *txtitemname, *txtitemcost;
    IBOutlet UITextView *txtitemdesc;
    IBOutlet UILabel *placeholderLabel,*lblcount;
    IBOutlet UIView *viewvol;
    IBOutlet UITextField *txtvolume;
    NSString *catid,*itemname ;
    IBOutlet UIButton *btncategory;
    UIPickerView *pckrvloume;
    NSURLConnection *connvol;
    NSMutableDictionary *mutabledictionary;

}

@property (nonatomic, strong) NSString * ivol;
@property (nonatomic, strong) NSString * icat;
@property (nonatomic, strong) NSString * icatid;
@property (nonatomic, strong) NSString * ivolid;
@property (nonatomic, strong) NSString * ivolprice;
@property (nonatomic, strong) NSString * paymenttype;

-(void)dismissPopup;
-(IBAction)onbtnclick:(id)sender;
-(IBAction)onbtnitemdetailclick:(id)sender;
-(IBAction)onbtncontinueclick:(id)sender;
@end
