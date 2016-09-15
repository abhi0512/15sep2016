//
//  faqvc.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class AppDelegate;
@interface faqvc : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tblfaq;
    NSMutableArray *arrdata;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;}

@end



