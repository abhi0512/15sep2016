//
//  cmspagevc.h
//  airlogic
//
//  Created by APPLE on 23/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AppDelegate,MBProgressHUD;
@interface cmspagevc : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *mywebview;
    NSString *pagetype;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;
    NSMutableString *html ;
}
@property(nonatomic,strong)NSString *pagetype;
@end
