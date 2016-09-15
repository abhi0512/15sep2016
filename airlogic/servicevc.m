//
//  servicevc.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "servicevc.h"
#import "DBHandler.h"
#import "itemsummary.h"
#import "insurancevc.h"
#import "infoview.h"
#import "UIViewController+MJPopupViewController.h"
#import "myitemvc.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface servicevc ()

@end

@implementation servicevc
@synthesize strcommercial,strmutual,strsubcommercial,charityname,paytype;

- (void)viewDidLoad {
    [super viewDidLoad]; self.title=@"Send Items";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    
    strmutual=@"No";
    strcommercial=@"Yes";
    strsubcommercial=@"0";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /********** Using the default tracker **********/
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    /**********Manual screen recording**********/
    [tracker set:kGAIScreenName value:@"Send Items"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([paytype length] > 0)
    {
        if([paytype isEqualToString:@"C"])
        {
            btncommercial.userInteractionEnabled=NO;
            btnmutual.userInteractionEnabled=NO;
            viewcommercial.userInteractionEnabled=NO;
            viewmutual.userInteractionEnabled=NO;
            btnco.userInteractionEnabled=NO;
            btnmu.userInteractionEnabled=NO;
            strmutual=@"No";
            strcommercial=@"Yes";
            strsubcommercial=@"0";
            [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
            [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
        }
        else if([paytype isEqualToString:@"M"])
        {
            strmutual=@"Yes";
            strcommercial=@"No";
            strsubcommercial=@"0";
            [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
            [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
            btncommercial.userInteractionEnabled=NO;
            btnmutual.userInteractionEnabled=NO;
            viewcommercial.userInteractionEnabled=NO;
            viewmutual.userInteractionEnabled=NO;
            btnco.userInteractionEnabled=NO;
            btnmu.userInteractionEnabled=NO;
        }
        else
        {
            viewcommercial.userInteractionEnabled=YES;
            viewmutual.userInteractionEnabled=YES;
            btncommercial.userInteractionEnabled=YES;
            btnmutual.userInteractionEnabled=YES;
            btnco.userInteractionEnabled=YES;
            btnmu.userInteractionEnabled=YES;
        }
    }
}

-(IBAction)onbtninfoclick:(id)sender
{
    infoview *info= [[infoview alloc]initWithNibName:@"infoview" bundle:nil];
    [self presentPopupViewController:info animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];

}
- (void)back {
    // [self.navigationController popViewControllerAnimated:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtncommercialclick:(id)sender
{
    strmutual=@"No";
    strcommercial=@"Yes";
    strsubcommercial=@"0";
    
//    viewcommercial.frame=CGRectMake(0, 150, self.view.frame.size.width, 125);
//    viewmutual.frame=CGRectMake(0, 293, self.view.frame.size.width, 40);
//    btnnext.frame=CGRectMake(49, 362, 218, 34);
//    btncancel.frame=CGRectMake(49, 410, 218, 34);
//    btnch1.alpha=0;
//    btnch2.alpha=0;
//    btnch3.alpha=0;
//    btncharity3.alpha=0;
//    btcharity1.alpha=0;
//    btcharity2.alpha=0;

    
    [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
    [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
      //  [btnmoney setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
}
-(IBAction)onbtnmoneyclick:(id)sender
{
    strmutual=@"No";
    strcommercial=@"Yes";
    strsubcommercial=@"1";
    
    
//    viewcommercial.frame=CGRectMake(0, 150, self.view.frame.size.width, 125);
//    viewmutual.frame=CGRectMake(0, 293, self.view.frame.size.width, 40);
//    btnnext.frame=CGRectMake(49, 362, 218, 34);
//    btncancel.frame=CGRectMake(49, 410, 218, 34);
//    btnch1.alpha=0;
//    btnch2.alpha=0;
//    btnch3.alpha=0;
//    btncharity3.alpha=0;
//    btcharity1.alpha=0;
//    btcharity2.alpha=0;

    
     [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
//    [btncharity setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
//    [btnmoney setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
     [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
}
-(IBAction)onbtncharityclick:(id)sender
{
    strmutual=@"No";
    strcommercial=@"Yes";
    strsubcommercial=@"0";
    
//    viewcommercial.frame=CGRectMake(0, 150, self.view.frame.size.width, 180);
//    viewmutual.frame=CGRectMake(0, 340, self.view.frame.size.width, 40);
//    btnnext.frame=CGRectMake(49, 392, 218, 34);
//    btncancel.frame=CGRectMake(49, 432, 218, 34);
//    btnch1.alpha=1;
//    btnch2.alpha=1;
//    btnch3.alpha=1;
//    btncharity3.alpha=1;
//    btcharity1.alpha=1;
//    btcharity2.alpha=1;

     [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
//    [btnmoney setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
//    [btncharity setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
     [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
}
-(IBAction)onbtnmutualclick:(id)sender
{
    strmutual=@"Yes";
    strcommercial=@"No";
    strsubcommercial=@"0";
    
//    viewcommercial.frame=CGRectMake(0, 150, self.view.frame.size.width, 125);
//    viewmutual.frame=CGRectMake(0, 293, self.view.frame.size.width, 40);
//    btnnext.frame=CGRectMake(49, 362, 218, 34);
//    btncancel.frame=CGRectMake(49, 410, 218, 34);
//    btnch1.alpha=0;
//    btnch2.alpha=0;
//    btnch3.alpha=0;
//    btncharity3.alpha=0;
//    btcharity1.alpha=0;
//    btcharity2.alpha=0;

    [btnmutual setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
     [btncommercial setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
//    [btnmoney setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
//    [btncharity setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
//    
}

-(IBAction)onbtnitemdetailclick:(id)sender
{
    BOOL flg = [DbHandler UpdateItemService:strcommercial subcommercial:strsubcommercial mutual:strmutual charity:@""];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    if(flg)
    {
        if([strmutual isEqualToString:@"Yes"])
        {
            BOOL flg= [DbHandler UpdateItemInsurance:@"0" insid:@""];
        itemsummary *item = [[itemsummary alloc]initWithNibName:@"itemsummary" bundle:nil];
        
        [self.navigationController pushViewController:item animated:NO];
        }
        else
        {
            insurancevc *insurance = [[insurancevc alloc]initWithNibName:@"insurancevc" bundle:nil];
            [self.navigationController pushViewController:insurance animated:NO];
        }
    }
    
}


-(IBAction)btncharity1click:(id)sender
{
    charityname=@"charity 1";
    [btcharity1 setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
    [btcharity2 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
    [btncharity3 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
    
}
-(IBAction)btncharity2click:(id)sender
{
     charityname=@"charity 2";
    [btcharity2 setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
    [btcharity1 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
    [btncharity3 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
}
-(IBAction)btncharity3click:(id)sender
{
     charityname=@"charity 3";
    [btncharity3 setBackgroundImage:[UIImage imageNamed:@"rdunselect"] forState:UIControlStateNormal];
    [btcharity2 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
    [btcharity1 setBackgroundImage:[UIImage imageNamed:@"rdselection"] forState:UIControlStateNormal];
}

-(IBAction)onbtncontinueclick:(id)sender
{
    myitemvc *itemdt = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:itemdt animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
