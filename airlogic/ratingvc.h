//
//  ratingvc.h
//  airlogic
//
//  Created by APPLE on 05/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
@class  AppDelegate,MBProgressHUD;



@interface ratingvc : UIViewController<UITextViewDelegate,EDStarRatingProtocol>
{
    IBOutlet UITextView *txtreview;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UILabel *placeholderLabel,*lblcount;
     NSString *starrating;
}
@property(nonatomic,retain)NSString *itemid;
@property(nonatomic,retain)NSString *torateuserid;
-(IBAction)onbtnsubmitclick:(id)sender;
-(IBAction)onbtncancelclick:(id)sender;




@end

