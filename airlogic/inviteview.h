//
//  inviteview.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "GAITrackedViewController.h"
#import <MessageUI/MessageUI.h>

@class  AppDelegate;
@interface inviteview : GAITrackedViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SWRevealViewControllerDelegate>
{
    IBOutlet UILabel *lblcode;
    AppDelegate *delegate;
     SWRevealViewController *revealController;
    IBOutlet UIButton *btn1,*btn2,*btn3,*btn4,*btn5,*btn6;
    
}
-(IBAction)onbtnsmsclick:(id)sender;
-(IBAction)onbtnemailclick:(id)sender;
-(IBAction)onbtnwhatsappclick:(id)sender;
@end
