//
//  moreinfovc.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
@class  AppDelegate;
@interface moreinfovc : UIViewController<SWRevealViewControllerDelegate,MFMessageComposeViewControllerDelegate>

{
    AppDelegate *delegate;
    SWRevealViewController *revealController;

}
-(IBAction)onbtnsettingclick:(id)sender;
-(IBAction)onbtnaboutclick:(id)sender;
-(IBAction)onbtnfaqclick:(id)sender;
-(IBAction)onbtnhelpclick:(id)sender;
-(IBAction)onbtninviteclick:(id)sender;
@end
