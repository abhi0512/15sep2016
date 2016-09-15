//
//  linkedinview.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface linkedinview : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *mywebview;MBProgressHUD *progresshud;
}
@property(nonatomic,strong)NSString *strurl;
@end
