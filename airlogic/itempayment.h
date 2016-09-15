//
//  itempayment.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface itempayment : UIViewController<PayPalPaymentDelegate>
{
    MBProgressHUD *progresshud;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*payconn;
    NSTimer *timer;
    NSString *paypalamt;
    IBOutlet UIImageView *img;
   IBOutlet UILabel *lblmsg;
}
@property(nonatomic,strong,readwrite)NSString *appfee;
@property(nonatomic,strong,readwrite)NSString *safetyfee;
@property(nonatomic,strong,readwrite)NSString *airlogiqfee;
@property(nonatomic,strong,readwrite)NSString *insamt;
@property(nonatomic,strong,readwrite)NSString *totalamt;
@property(nonatomic,strong,readwrite)NSString *disamt;
@property(nonatomic,strong,readwrite)NSString *disrate;
@property(nonatomic,strong,readwrite)NSString *promocode;
@property(nonatomic,strong,readwrite)NSString *itemamt;
@property(nonatomic,strong,readwrite)NSString *paypalamt;
@property(nonatomic,strong,readwrite)NSString *refercredit;
@property(nonatomic,strong,readwrite)NSString *point;


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *serveritemid;
@property(nonatomic, strong, readwrite) NSString *transactionid;

@end
