//
//  rateuser.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "GAITrackedViewController.h"

@class  AppDelegate,MBProgressHUD;
@interface rateuser : GAITrackedViewController<UITextViewDelegate,EDStarRatingProtocol>
{
    IBOutlet UITextView *txtreview;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UILabel *placeholderLabel,*lblcount,*lbltodate;
    NSString *starrating;
    IBOutlet UILabel *lbltripname;
    IBOutlet UILabel *fromcity;
    IBOutlet UILabel *tocity;
    IBOutlet UILabel *lblvolume ,*lblcurrency;
    IBOutlet UILabel *lbldate;
    IBOutlet UILabel *lblweight;
    IBOutlet UILabel *lblitemprice;
    IBOutlet UIImageView *imgprofile;
    IBOutlet UIView *viewsender, *viewflybee,*viewdetail,*viewreview;
    IBOutlet UIButton *btnrate;
    
    NSURLConnection *connsender,*rateconn,*connflybee;
    
    IBOutlet UILabel *flbltripname;
    IBOutlet UILabel *ffromcity;
    IBOutlet UILabel *ftocity;
    IBOutlet UILabel *flblvolume;
    IBOutlet UILabel *flbldate;
    IBOutlet UILabel *flblweight;
    IBOutlet UILabel *lblmonth;
    IBOutlet UIImageView *fimgprofile;
    IBOutlet UILabel *lblflightname;
    
}
@property(nonatomic,retain)NSString *itemid;
@property(nonatomic,retain)NSString *tripid;
@property(nonatomic,retain)NSString *torateuserid;
-(IBAction)onbtnsubmitclick:(id)sender;


@end
