//
//  profilevc.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "emailverification.h"
#import "mobileverification.h"

#import "GAITrackedViewController.h"

@class  AppDelegate,MBProgressHUD;

@interface profilevc : GAITrackedViewController<UITextFieldDelegate,SWRevealViewControllerDelegate,emailAccountDelegate,mobileAccountDelegate>
{
    IBOutlet UIView *profileview ,*viewverify,*viewbankdetail;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UITextField *txtphone, *txtemail, *txtzipcode, *txtbank, *txtaccountno,*txtroutinno;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UILabel *lblusername, *lblcountry,*lblid,*lblbankdetail,*lblcity,*lblpointearn,*lblcurrency;
   SWRevealViewController *revealController;
    IBOutlet UIImageView *imgprofile;
    IBOutlet UIButton *btnflybee, *btnsender ,*btnemail,*btneicon,*btnphone,*btnpicon,*btnlinkedin,*btnlogout;
    IBOutlet UIView *viewflybee, *viewsender;
    NSString *usertype,*strusertype,*mobileverified,*emailverified,*uploadid,*linkverified,*strphoneno,*strcodeno,*govtid,*lnkurl;
    IBOutlet UIButton *btncamera ,*btnicon,*btnlnk;
    IBOutlet UIImageView *imgemail, *imgmobile ,*imgline,*imguploadid,*imglinkin,*imgstar1,*imgstar2,*imgstar3,*imgstar4,*imgstar5;
    NSURLConnection *profileconn, *updconn,*verifyconn;
}
@property(nonatomic,strong)NSString *ismy;
@property(nonatomic,strong)NSString *userid;
-(IBAction)onbtnmobileverclick:(id)sender;
-(IBAction)onbtnemailverclick:(id)sender;
-(IBAction)onbtnlogoutclick:(id)sender;
-(IBAction)btncameraclcik:(id)sender;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleSenderTap:(UITapGestureRecognizer *)recognizer;
-(void)dismissPopup;
-(void)dismissemailPopup;
-(IBAction)onbtnflybeeclick:(id)sender;
-(IBAction)onbtnsenderclick:(id)sender;
-(IBAction)onbtnlinkedinclick:(id)sender;
@end
