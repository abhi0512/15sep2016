//
//  smsverificationvc.h
//  airlogic
//
//  Created by APPLE on 09/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class  AppDelegate,MBProgressHUD;
@interface smsverificationvc : GAITrackedViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *txtmobile,*txtcode;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;NSURLConnection *catconn;
    UIPickerView *pckrcountrycode;
    NSMutableArray *arrcode;
}

@property(nonatomic,strong)NSString *pagefrom;

@property(nonatomic,strong)NSString *isfirst;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *phoneno;
@property(nonatomic,strong)NSString *code;
-(IBAction)onbtnverifyclick:(id)sender;
-(IBAction)onbtnskipclick:(id)sender;
@end
