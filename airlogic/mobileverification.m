//
//  mobileverification.m
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import "mobileverification.h"
#import <QuartzCore/QuartzCore.h>
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UIViewController+MJPopupViewController.h"
#import "profilevc.h"
#import "DbHandler.h"


@interface mobileverification ()

@end

@implementation mobileverification
@synthesize strphone,strcode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    
    UIToolbar* desctoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    desctoolbar.barStyle = UIBarStyleBlackOpaque;
    desctoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                         nil];
    [desctoolbar sizeToFit];
    txtphone.inputAccessoryView = desctoolbar;
    
    arrcode=[[NSMutableArray alloc]initWithObjects:@"India +91",@"United States +1", nil];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Mobile Verification Screen";
    [super viewDidAppear:animated];
}

-(void)dismissPopup
{
    profilevc *edit= [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
    [self dismissPopupViewController:edit animationType:MJPopupViewAnimationFade];
}
-(void)viewWillAppear:(BOOL)animated
{
    if([strphone length ] > 0)
    {
        txtphone.text=strphone;
    }
    if([strcode length ] > 0)
    {
        txtcode.text=strcode;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    strphone=@"";
    strcode=@"";
}

-(void)cleardescpad{
    [txtphone resignFirstResponder];
}

-(IBAction)onbtnsendclick:(id)sender
{
    if(![txtcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Country Code." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    if(![txtphone.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Phone no." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if ([txtphone.text length]< 10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter 10 digit mobile no." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
   
    [txtphone resignFirstResponder];
    NSString *strurl= [AppDelegate baseurl];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    
    strurl= [strurl stringByAppendingString:@"verifyusermobileno"];
    [postdata setObject:txtphone.text forKey:@"mobile"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:txtcode.text forKey:@"countrycode"];
        
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        catconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
}
-(void)pickerDoneClicked:(id)sender
{
    UIBarButtonItem *btn= (UIBarButtonItem*)sender;
    
    if(btn.tag==101)
    {
        
        
        if ([txtcode.text isEqualToString:@""])
        {
            NSInteger row = [pckrcountrycode selectedRowInComponent:0];
            txtcode.text = [arrcode objectAtIndex:(NSUInteger)row];
            
            NSString *code=txtcode.text;
            
            if([code isEqualToString:@"India +91"])
            {
                txtcode.text=@"+91";
            }
            else
            {
                txtcode.text=@"+1";
            }
           
        }
        [txtcode resignFirstResponder];
    }
    
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField  == txtphone)
    {
    NSInteger length = [txtphone.text length];
    if (length>9 && ![string isEqualToString:@""]) {
        return NO;
    }
    // This code will provide protection if user copy and paste more then 10 digit text
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([textField.text length]>10) {
            textField.text = [textField.text substringToIndex:10];
            
        }
    });
    }
    
    return YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(pickerView.tag==101)
    {
        return [arrcode count];
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(pickerView.tag==101)
    {
        return [arrcode objectAtIndex:row];
    }
    
    return 0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerView.tag==101)
    {
        NSString *ccode=(NSString *)[arrcode objectAtIndex:row];
        
        if([ccode isEqualToString:@"India +91"])
        {
            txtcode.text=@"+91";
        }
        else
        {
            txtcode.text=@"+1";
        }
        
    }
    
}
-(void)SetPicker:(UIPickerView *)pcker txtfield:(UITextField *)txt tag:(NSInteger *)tagvalue title:(NSString *)lbl
{
    pcker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pcker.delegate = self;
    pcker.dataSource = self;
    [pcker setShowsSelectionIndicator:YES];
    txt.inputView = pcker;
    txt.layer.cornerRadius = 8;
    txt.font=[UIFont fontWithName:@"Roboto-Light" size:14];
    // Create done button in UIPickerView
    pcker.tag =tagvalue;
    
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 56)];
    
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 23)];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = lbl;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Roboto-Light" size:15];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    doneBtn.tag=tagvalue;
    
    
    [barItems addObject:toolBarTitle];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    
    txt.inputAccessoryView = mypickerToolbar;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == txtcode)
    {
        [self SetPicker:pckrcountrycode  txtfield:txtcode tag:101 title:@"Select Country Code"];
        //[self animateTextField: textField up: YES];
    }
    
}

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self removeProgressIndicator];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [responseString objectFromJSONString];
    NSString *string = [deserializedData objectForKey:@"response_code"];
    
    if([string isEqualToString:@"200"])
    {
         [self removeProgressIndicator];
        [self._delegate mobileaccount:self didFinishEnteringItem:@"done"];
        [DbHandler updateusephone:txtphone.text userid:delegate.struserid];
        profilevc *vc = [[profilevc alloc]init];
        [vc dismissPopup];
        
    }
    else
    {
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark - Indicator
-(void)addProgressIndicator
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void)removeProgressIndicator
{
    [progresshud removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
