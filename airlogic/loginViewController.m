//
//  loginViewController.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "loginViewController.h"
#import "forgotpwdViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"
#import "homeViewController.h"
#import "DbHandler.h"


@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"Log In with Email";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Login Screen";
    
    [super viewDidAppear:animated];
    
}
-(IBAction)onbtnforgotpwdclick:(id)sender
{
    forgotpwdViewController *forgot = [[forgotpwdViewController alloc]initWithNibName:@"forgotpwdViewController" bundle:nil];
    
    forgot.stremail=txtemail.text;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:forgot animated:NO];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
-(IBAction)onbtnloginclick:(id)sender
{
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
   
    if([txtemail.text length]!=0)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
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
            strurl= [strurl stringByAppendingString:@"login"];
            
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:txtemail.text forKey:@"email"];
            [postdata setObject:txtpwd.text forKey:@"password"];
            [postdata setObject:delegate.devicetoken forKey:@"devicetoken"];
            
            
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
        NSDictionary *userdata = [deserializedData objectForKey:@"data"];
        [DbHandler deleteDatafromtable:@"delete from usermaster"];
        
        BOOL flg = [DbHandler Insertuser:[userdata valueForKey:@"address"] city:[userdata valueForKey:@"city"] country:[userdata valueForKey:@"country"] emailid:[userdata valueForKey:@"emailid"] firstname:[userdata valueForKey:@"firstname"] gender:[userdata valueForKey:@"gender"] uid:[userdata valueForKey:@"id"] lastname:[userdata valueForKey:@"lastname"] phone:[userdata valueForKey:@"phone"] profilepic:[userdata valueForKey:@"profilepic"] state:[userdata valueForKey:@"state"] status:[userdata valueForKey:@"status"] thumbprofilepic:[userdata valueForKey:@"thumbprofilepic"] usertype:[userdata valueForKey:@"usertype"] zip:[userdata valueForKey:@"zip"] push:[userdata valueForKey:@"push_notification"] sound:[userdata valueForKey:@"sound"]promocode:[userdata valueForKey:@"promocode"] currency:[userdata valueForKey:@"currency"]];
    if(flg)
    {
        delegate.struserid=[userdata valueForKey:@"id"];
        delegate.username=[NSString stringWithFormat:@"%@ %@",[userdata valueForKey:@"firstname"],[userdata valueForKey:@"lastname"]];
        delegate.strusertype=[userdata valueForKey:@"usertype"];
        
        homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
        home.logintype=@"";
        delegate.logintype=@"";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:home animated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
