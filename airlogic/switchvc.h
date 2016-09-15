//
//  switchvc.h
//  airlogic
//
//  Created by APPLE on 16/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AppDelegate,MBProgressHUD;

//is implemeted to pass data from popup view to parent view .
@protocol SwitchAccountDelegate <NSObject>
- (void)switchaccount:(id)controller didFinishEnteringItem:(NSString *)item;
@end

@interface switchvc : UIViewController
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
}
@property(nonatomic,retain)NSString *strusertype;
@property (nonatomic, weak) id <SwitchAccountDelegate> accountdelegate;
-(IBAction)onbtnsenderclick:(id)sender;
-(IBAction)onbtnflybeeclick:(id)sender;

@end
