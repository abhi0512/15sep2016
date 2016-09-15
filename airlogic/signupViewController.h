//
//  signupViewController.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "GAITrackedViewController.h"

@class  AppDelegate,MBProgressHUD;

@interface signupViewController:GAITrackedViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtfname,*txtlname, *txtemail, *txtpwd, *txtcpwd,*txtrefercode;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;
}

-(IBAction)onbtnsignupclick:(id)sender;
@end
