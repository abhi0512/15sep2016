//
//  notificationsetting.h
//  airlogic
//
//  Created by APPLE on 06/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AppDelegate,MBProgressHUD;
@interface notificationsetting : UIViewController
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    
    IBOutlet UISwitch *swtchnotification, *swtchsound;
    NSString *notifiation, *sound;
}
- (void)changeSwitch:(id)sender;
@end
