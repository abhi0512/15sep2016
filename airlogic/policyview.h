//
//  policyview.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AppDelegate,MBProgressHUD;
@interface policyview : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *mywebview;
    NSString *pagetype;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;
    NSMutableString *html ;
    
    UIView* loadingView;
}
@property(nonatomic,strong)NSString *pagetype;

-(IBAction)onbtncloseclick:(id)sender;

@end
