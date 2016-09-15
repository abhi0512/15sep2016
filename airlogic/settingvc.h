//
//  settingvc.h
//  airlogic
//
//  Created by APPLE on 21/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "switchvc.h"
#import "logoutvc.h"


@class AppDelegate;
@interface settingvc : UIViewController<SwitchAccountDelegate,logoutdelegate>
{
    IBOutlet UILabel *lblusertype;
    AppDelegate *delegate;
}

-(IBAction)onbtnlogoutclick:(id)sender;
-(IBAction)onbtnsettingclick:(id)sender;
-(IBAction)onbtnnotificationclick:(id)sender;

-(void)dismissPopup;
-(void)dismissvolPopup;
@end
