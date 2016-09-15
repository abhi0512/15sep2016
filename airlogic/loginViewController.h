//
//  loginViewController.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@class  AppDelegate,MBProgressHUD;
@interface loginViewController : GAITrackedViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtemail, *txtpwd;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;

}
-(IBAction)onbtnloginclick:(id)sender;

@end
