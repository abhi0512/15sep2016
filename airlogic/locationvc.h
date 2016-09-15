//
//  locationvc.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class AppDelegate;
@interface locationvc : GAITrackedViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *txtfromcity, *txttocity, *txtfromdt,*txttodt,*txtzipcode,*txttozipcode;
     UIDatePicker *fromdatePicker ,*todatePicker;
    UIPickerView *pckrfromcity,*pckrtocity;
    NSMutableArray *arrfromcity,*arrtocity;
    AppDelegate *delegate;
    NSString *selectedString,*fromdt,*todt;
}
@property(nonatomic,strong)NSString *fromcityid;
@property(nonatomic,strong)NSString *tripdt;
@property(nonatomic,strong)NSString *tocityid;
@property(nonatomic,strong)NSString *tozip;
@property(nonatomic,strong)NSString *fromzip;
@property (nonatomic, strong) NSString * _catid;
@property (nonatomic, strong) NSString * _volid;
@property (nonatomic, strong) NSString * vol;
@property (nonatomic, strong) NSString * volprice;
@property (nonatomic, strong) NSString * paymenttype;
@property (nonatomic, strong) NSString * itemcategory;
-(IBAction)onbtnlocationclick:(id)sender;
-(IBAction)onbtncontinueclick:(id)sender;

-(IBAction)onbtnfromdt:(id)sender;
-(IBAction)onbtntodt:(id)sender;
@end
