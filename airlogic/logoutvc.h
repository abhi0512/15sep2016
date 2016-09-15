//
//  logoutvc.h
//  airlogic
//
//  Created by APPLE on 16/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol logoutdelegate <NSObject>
- (void)logoutaccount:(id)controller didFinishEnteringItem:(NSString *)item;
@end
@class AppDelegate;
@interface logoutvc : UIViewController
{
    AppDelegate *delegate;
}
@property (nonatomic, weak) id <logoutdelegate>logdelegate;
-(IBAction)onbtnlogoutclick:(id)sender;
-(IBAction)onbtncancelclick:(id)sender;
@end
