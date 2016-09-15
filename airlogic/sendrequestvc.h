//
//  sendrequestvc.h
//  airlogic
//
//  Created by APPLE on 14/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface sendrequestvc : GAITrackedViewController<UITextViewDelegate>
{
    IBOutlet UITextView *txtdesc;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
    IBOutlet UILabel *placeholderLabel,*lblcount;


}

-(void)dismissPopup;
@property(nonatomic,strong)NSString *itemid;
@property(nonatomic,strong)NSString *touserid;
@property(nonatomic,strong)NSString *strtripid;
-(IBAction)onbtnsendclick:(id)sender;
@end
