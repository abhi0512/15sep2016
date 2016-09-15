//
//  uploadgovtidvc.h
//  airlogic
//
//  Created by APPLE on 08/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class  AppDelegate,MBProgressHUD;
@interface uploadgovtidvc : GAITrackedViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;
    NSString *isuploaded;
    IBOutlet UIButton *btncross;
    NSURLConnection *urlconn;    IBOutlet UIImageView *imgprofile, *imgview;
}
@property(nonatomic,strong)NSString *pagefrom;
-(IBAction)onbtnverifyclick:(id)sender;
-(IBAction)onbtnskipclick:(id)sender;
-(IBAction)btncrossclick:(id)sender;
@end
