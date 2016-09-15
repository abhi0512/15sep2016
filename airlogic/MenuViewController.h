//
//  SideMenuViewController.h
//  TeenSnap
//
//  Created by admin on 17/09/14.
//  Copyright (c) 2014 TaxSmart Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface MenuViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
 
    AppDelegate *delegate;
    NSMutableData *responseData;
    IBOutlet UILabel *lblusermode;
    IBOutlet UIButton *btnsignin;
    IBOutlet UIButton *btnusername;
    IBOutlet UIImageView *imgprofile;
    IBOutlet UIButton *menu2 ,*menuicon;
    //UIButton *overlayView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *sideMenuScrollView;

- (IBAction)btnhomeclick:(id)sender;
- (IBAction)btnmytrickpclick:(id)sender;
- (IBAction)btnprofileclick:(id)sender;
- (IBAction)btnmessageclick:(id)sender;
- (IBAction)btnalertclick:(id)sender;
- (IBAction)btnmoreinfoclick:(id)sender;
- (IBAction)btnhowworkclick:(id)sender;
- (IBAction)btntreuqestclick:(id)sender;
- (IBAction)btninviteclick:(id)sender;
@end
