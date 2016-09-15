//
//  smsverificationvc.m
//  airlogic
//
//  Created by APPLE on 09/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "smsverificationvc.h"
#import "uploadgovtidvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "profilevc.h"
#import "DbHandler.h"
#import "smscode.h"



#define ACCEPTABLE_CHARECTERS @"0123456789."
@interface smsverificationvc ()

@end

@implementation smsverificationvc
@synthesize userid,pagefrom,phoneno,code,isfirst;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"SMS Verify";
    delegate.promocode=@"";
    if([pagefrom isEqualToString:@"Y"]|| [pagefrom isEqualToString:@"H"] || [pagefrom isEqualToString:@"P"])
    {
        UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
    }
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    
    
    UIToolbar* phonetoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phonetoolbar.barStyle = UIBarStyleBlackOpaque;
    phonetoolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearmobilepad)],
                          nil];
    [phonetoolbar sizeToFit];
    txtmobile.inputAccessoryView = phonetoolbar;
    
   
    
    arrcode=[[NSMutableArray alloc]initWithObjects:@"India +91",@"United States +1", nil];

}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"SMS Verification Screen";
    
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([phoneno length ] > 0)
    {
        txtmobile.text=phoneno;
    }
    if([code length ] > 0)
    {
        txtcode.text=code;
    }
}

- (void)back {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField  == txtmobile)
    {
        
        NSInteger length = [txtmobile.text length];
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
    if(textField  == txtcode)
    {
        return NO;
    }
    
    if(textField == txtmobile)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];

    if(textField == txtcode)
    {
        [self SetPicker:pckrcountrycode  txtfield:txtcode tag:101 title:@"Select Country Code"];
        //[self animateTextField: textField up: YES];
    }
    
}

-(void)clearmobilepad
{
    [txtmobile resignFirstResponder];
}



-(IBAction)onbtnverifyclick:(id)sender
{
    
    if(![txtcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Country Code." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    if(![txtmobile.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Phone no." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if ([txtmobile.text length]< 10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter 10 digit mobile no." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    [txtmobile resignFirstResponder];
    
    NSString *strurl= [AppDelegate baseurl];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    
    strurl= [strurl stringByAppendingString:@"verifyusermobileno"];
    [postdata setObject:[NSString stringWithFormat:@"%@",txtmobile.text] forKey:@"mobile"];
    [postdata setObject:userid forKey:@"userid"];
    [postdata setObject:txtcode.text forKey:@"countrycode"];
    [postdata setObject:isfirst forKey:@"isfirst"];
    
    
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
-(IBAction)onbtnskipclick:(id)sender
{
    uploadgovtidvc *upload = [[uploadgovtidvc alloc]initWithNibName:@"uploadgovtidvc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:upload animated:NO];
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
        
        if([isfirst isEqualToString:@"Y"])
        {
            [DbHandler updatepromocode:txtmobile.text userid:delegate.struserid promocode:txtmobile.text];
            delegate.promocode=txtmobile.text;
        }
        else
        {
            NSString *statusmsg = [deserializedData objectForKey:@"statusmessage"];
            if([statusmsg isEqualToString:@"Y"])
            {
               [DbHandler updatepromocode:txtmobile.text userid:delegate.struserid promocode:txtmobile.text];
                delegate.promocode=txtmobile.text;
            }
            else
            {
             [DbHandler updateusephone:txtmobile.text userid:delegate.struserid];
            }
        }
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        if([pagefrom isEqualToString:@"H"] || [pagefrom isEqualToString:@"P"])
        {
            smscode *sc=[[smscode alloc]initWithNibName:@"smscode" bundle:nil];
            sc.pagefrom=pagefrom;
            [self.navigationController pushViewController:sc animated:NO];
        }
        else
        {
            smscode *sc=[[smscode alloc]initWithNibName:@"smscode" bundle:nil];
            sc.pagefrom=pagefrom;
            [self.navigationController pushViewController:sc animated:NO];
        }
        
    }
    else
    {
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y / 2; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
-(void)viewDidDisappear:(BOOL)animated{
    pagefrom=@"";
    phoneno=@"";
    code=@"";
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
