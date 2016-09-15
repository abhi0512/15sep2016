//
//  intialview.h
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AppDelegate,MBProgressHUD;
@interface intialview : UIViewController
{
    AppDelegate *delegate;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    NSURLConnection *fbconn;
}


-(IBAction)onbtnloginclick:(id)sender;
-(IBAction)onbtnsignupclick:(id)sender;
-(IBAction)onbtfacebookclick:(id)sender;
-(IBAction)btnlinkedinclick:(id)sender;


@end
