//
//  selectvolume.h
//  airlogic
//
//  Created by APPLE on 16/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MBProgressHUD;
@class AppDelegate;

@protocol SecondViewControllerDelegate <NSObject>
- (void)addItemViewController:(id)controller didFinishEnteringItem:(NSString *)item;
@end

@interface selectvolume : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblvolume;
    NSMutableArray *arrvolume;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
    NSString *strvolume;
    NSIndexPath* checkedIndexPath;
    NSString *selectedvolume;
}
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property(nonatomic,strong)NSString *categoryid;
@property (nonatomic, weak) id <SecondViewControllerDelegate> delegate;
-(IBAction)onbtnokclick:(id)sender;
-(IBAction)onbtncancelclick:(id)sender;
@end

