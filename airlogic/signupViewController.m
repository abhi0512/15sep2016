//
//  signupViewController.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "signupViewController.h"
#import  "homeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"
#import "DbHandler.h"
#import "smsverificationvc.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface signupViewController ()

@end

@implementation signupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.title=@"Sign Up with Email";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Signup Screen";
    
    [super viewDidAppear:animated];
    
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

-(IBAction)onbtnsignupclick:(id)sender
{
    
    if(![txtfname.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Firstname is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtlname.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Lastname is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtemail.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Email is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtpwd.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtcpwd.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Confirm Password is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    if(![txtcpwd.text isEqualToString:txtpwd.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password and Confirm Password Mismatch.Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if([txtemail.text length]!=0)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //NSString *emailRegex=@"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com)\b";
        
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL isValid = [emailTest evaluateWithObject:txtemail.text];
        if(! isValid)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email Address." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        else
        {
            
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"signup"];
            
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:txtfname.text forKey:@"firstname"];
            [postdata setObject:txtlname.text forKey:@"lastname"];
            [postdata setObject:txtemail.text forKey:@"email"];
            [postdata setObject:txtpwd.text forKey:@"password"];
            [postdata setObject:delegate.devicetoken forKey:@"devicetoken"];
            [postdata setObject:txtrefercode.text forKey:@"refercode"];
            
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {
                [self addProgressIndicator];
                NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                [alert show];
                return;
            }

            
        }

    }

}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
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
        
        NSDictionary *userdata = [deserializedData objectForKey:@"data"];
        NSString *userid =[userdata valueForKey:@"lastid"];
        BOOL flg = [DbHandler Insertuser:@"" city:@"" country:@"" emailid:txtemail.text firstname:txtfname.text gender:@"" uid:userid lastname:txtlname.text phone:@"" profilepic:@"" state:@"" status:@"" thumbprofilepic:@"" usertype:@"Sender" zip:@"" push:@"1" sound:@"1" promocode:@"" currency:@""];
        
        if(flg)
        {
            delegate.struserid=userid;
            delegate.username=[NSString stringWithFormat:@"%@ %@",txtfname.text,txtlname.text];
            delegate.strusertype=@"Sender";
            
            smsverificationvc *sms = [[smsverificationvc alloc]initWithNibName:@"smsverificationvc" bundle:nil];
            sms.isfirst=@"Y";
            sms.userid=userid;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:sms animated:NO];
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
