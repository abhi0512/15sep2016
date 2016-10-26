//
//  currency.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MBProgressHUD;
@class AppDelegate;
@protocol currencyAccountDelegate <NSObject>
- (void)currency:(id)controller didFinishEnteringItem:(NSString *)item;
@end
@interface currency : UIViewController
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    IBOutlet UIImageView *img1;
   IBOutlet UIImageView *img2;
    BOOL istapped;
}

@property (nonatomic, strong) NSString * dollar;
@property (nonatomic, strong) NSString * rs;
@property (nonatomic, weak) id <currencyAccountDelegate>_delegate;
-(void)dismissPopup;
-(IBAction)onbtnsendclick:(id)sender;
@end
