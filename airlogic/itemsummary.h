//
//  itemsummary.h
//  airlogic
//
//  Created by APPLE on 25/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class MBProgressHUD;
@class AppDelegate;
@interface itemsummary : GAITrackedViewController
{
    IBOutlet UILabel *lblcost, *lblins,*lblappfee, *lblsafetyfee,*lbltotalfee,*lblfrom,*lblto,*lblvol,*lblweight,*lbldate,*lblitemname,*lblpaymenttype,*lbldiscount,*lblt,*lbldis,*lblddesc,*lblzipcode,*lbltozipcode,*lbltodate,*lblvprice,*lblcurrency ,*lblcredit;
    IBOutlet UIButton *btnnext,*btncancel,*btnapply;
    IBOutlet UITextField *txtpromocode;
    IBOutlet UIImageView *imgicon;
    MBProgressHUD *progresshud;
    IBOutlet UIImageView *imgprofile;
    NSMutableData *responseData;
    AppDelegate *delegate;
    NSURLConnection *catconn,*payconn,*promoconn,*connpurchase,*connpoint;
    NSString *ispaypal ,*promocode ,*creditpoint;
    IBOutlet UIView *profileview ,*viewpromo,*viewsummary;
    IBOutlet UIScrollView *scrlview;
    IBOutlet UILabel *lblmsg;
    NSString *paypalamt ,*isfirst;
}

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *serveritemid;
@property(nonatomic, strong, readwrite) NSString *transactionid;

-(IBAction)onbtnitemdetailclick:(id)sender;
-(IBAction)onbtncontinueclick:(id)sender;
-(IBAction)onbtnnextclick:(id)sender;
-(IBAction)onbtnapplyclick:(id)sender;
@end
