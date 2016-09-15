//
//  smscode.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AppDelegate,MBProgressHUD;
@interface smscode : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txt1,*txt2,*txt3,*txt4;
    MBProgressHUD *progresshud;
    NSMutableData *responseData;AppDelegate *delegate;NSURLConnection *catconn;
   
}

@property(nonatomic,strong)NSString *pagefrom;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *phoneno;
@property(nonatomic,strong)NSString *code;
-(IBAction)onbtnskipclick:(id)sender;
-(IBAction)onbtnverifyclick:(id)sender;
@end
