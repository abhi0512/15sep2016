//
//  selectcategory.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;

//is implemeted to pass data from popup view to parent view . 
@protocol CategoryControllerDelegate <NSObject>
- (void)addcategory:(id)controller didFinishEnteringItem:(NSString *)item _catid:(NSString *)categoryid;
@end


@interface selectcategory : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblcategory;
    NSMutableArray *arrcategory,*arSelectedRows;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn;
    NSIndexPath* checkedIndexPath;
    NSString *selectedcategory;
    NSString *selectedcatid;
    
}
@property (nonatomic, weak) id <CategoryControllerDelegate> catdelegate;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@end
