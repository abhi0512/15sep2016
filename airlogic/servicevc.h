//
//  servicevc.h
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface servicevc : UIViewController
{
    IBOutlet UIButton *btncommercial, *btnmoney, *btncharity, *btnmutual,*btcharity1, *btcharity2, *btncharity3,*btnnext,*btncancel,*btnch1,*btnch2,*btnch3,*btnco,*btnmu;
    IBOutlet UIView *viewcommercial, *viewmutual;
    
}
@property(nonatomic,strong)NSString *strmutual;
@property(nonatomic,strong)NSString *strcommercial;
@property(nonatomic,strong)NSString *strsubcommercial;
@property(nonatomic,strong)NSString *charityname;

@property(nonatomic,strong)NSString *paytype;

-(IBAction)onbtncommercialclick:(id)sender;
-(IBAction)onbtnmoneyclick:(id)sender;
-(IBAction)onbtncharityclick:(id)sender;
-(IBAction)onbtnmutualclick:(id)sender;
-(IBAction)onbtninfoclick:(id)sender;
-(IBAction)onbtnitemdetailclick:(id)sender;
-(IBAction)onbtncontinueclick:(id)sender;

-(IBAction)btncharity1click:(id)sender;
-(IBAction)btncharity2click:(id)sender;
-(IBAction)btncharity3click:(id)sender;
@end
