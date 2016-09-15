//
//  viewprofile.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class  AppDelegate,MBProgressHUD;

@interface viewprofile : GAITrackedViewController
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UIButton *btnusertype,*btnlink;
    
    IBOutlet UILabel *lblusername, *lblcountry, *lblcity ,*lblzipcode,*lblusertype,*lbltext;
    IBOutlet UIImageView *imgemail, *imgmobile ,*imgprofile,*imguploadid,*imglinkin;
    NSURLConnection *profileconn;
    NSString *usertype,*strusertype,*mobileverified,*emailverified,*uploadid,*linkverified,*govtid,*lnkurl;
    IBOutlet UIView *profileview;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UIImageView *imgstar1,*imgstar2,*imgstar3,*imgstar4,*imgstar5;

}
@property(nonatomic,strong)NSString *userid;

-(IBAction)onbtnlinkclick:(id)sender;
@end
