//
//  mobileverification.h
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

@protocol mobileAccountDelegate <NSObject>
- (void)mobileaccount:(id)controller didFinishEnteringItem:(NSString *)item;
@end
@interface mobileverification : GAITrackedViewController<UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *txtphone,*txtcode;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
    UIPickerView *pckrcountrycode;
    NSMutableArray *arrcode;
}
@property(nonatomic,strong)NSString *strphone;
@property(nonatomic,strong)NSString *strcode;
@property (nonatomic, weak) id <mobileAccountDelegate>_delegate;
-(void)dismissPopup;
-(IBAction)onbtnsendclick:(id)sender;

@end
