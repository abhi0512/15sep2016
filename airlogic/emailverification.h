//
//  emailverification.h
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

@protocol emailAccountDelegate <NSObject>
- (void)emailaccount:(id)controller didFinishEnteringItem:(NSString *)item;
@end
@interface emailverification : GAITrackedViewController<UITextViewDelegate>
{
    IBOutlet UITextField *txtemail;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
}
@property(nonatomic,strong)NSString *stremail;
@property (nonatomic, weak) id <emailAccountDelegate>_delegate;
-(IBAction)onbtnsendclick:(id)sender;

@end
