//
//  forgotpwdViewController.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AppDelegate,MBProgressHUD;

@interface forgotpwdViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtemail;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSMutableArray *arrairport;
}
@property(nonatomic,strong)NSString *stremail;
-(IBAction)onbtnclick:(id)sender;

@end