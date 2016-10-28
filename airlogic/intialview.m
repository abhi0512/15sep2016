//
//  intialview.m
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "intialview.h"
#import "loginViewController.h"
#import "signupViewController.h"
#import "smsverificationvc.h"
#import "homeviewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "DbHandler.h"
#import "AbhiHttpPOSTRequest.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DbHandler.h"
#import <QuartzCore/QuartzCore.h>
#import <linkedin-sdk/LISDK.h>
#import "invitation.h"


@interface intialview ()


@end

@implementation intialview



- (void)viewDidLoad {
    [super viewDidLoad];
    
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [DbHandler deleteDatafromtable:@"delete from usermaster"];
    delegate.struserid=@"";
    delegate.username=@"";
    self.navigationItem.hidesBackButton = YES;
    self.title=@"LogIn or SignUp";
    
    
  //  self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)onbtnloginclick:(id)sender
{
    loginViewController *login = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:login animated:NO];
}
-(IBAction)onbtnsignupclick:(id)sender
{
//    
//
    signupViewController *signup = [[signupViewController alloc]initWithNibName:@"signupViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:signup animated:NO];
}
-(IBAction)onbtfacebookclick:(id)sender
{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken])
    {
         [self fetchUserInfo];
    }
    else
    {
        [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Login process error");
             }
             else if (result.isCancelled)
             {
                 NSLog(@"User cancelled login");
             }
             else
             {
                 NSLog(@"Login Success");
                 
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     [DbHandler deleteDatafromtable:@"delete from usermaster"];
                     
                     NSLog(@"result is:%@",result);
                     [self fetchUserInfo];
                 }
                 else
                 {
                     
                 }
             }
         }];
    }

}
-(IBAction)btnlinkedinclick:(id)sender
{
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil];
    
    [LISDKSessionManager createSessionWithAuth:permissions state:@"" showGoToAppStoreDialog:YES successBlock:^(NSString *returnState) {
                                           NSLog(@"returned state %@",returnState);
    } errorBlock:^(NSError *error) {
                                               NSLog(@"%s %@","error called! ", [error description]);
                                            }
     ];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
       // NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,first_name,last_name,id,picture.type(large)" }]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                  
                 NSString *femail = [result objectForKey:@"email"];
                 
                 if (femail.length >0 )
                 {
                      NSLog(@"nyfdsfsd results:%@",result);
                   
                     delegate.fbemail=[result objectForKey:@"email"];
                     delegate.fbfname=[result objectForKey:@"first_name"];
                     delegate.fblname=[result objectForKey:@"last_name"];
                     delegate.fbid=[result objectForKey:@"id"];
                     
                     NSString *fbimagepath=[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",delegate.fbid];
                     NSLog(@"%@",fbimagepath);
                     delegate.fbpicture=[[[result objectForKey:@"picture"]objectForKey:@"data"]valueForKey:@"url"];
                    // delegate.fbpicture=fbimagepath;
                     delegate.logintype=@"FB";
                     
                     [self postdata];
                      }
                 else
                 {
                     NSLog(@"Facebook email is not verified");
                           }
                           }
                           else
                           {
                               NSLog(@"Error %@",error);
                           }
                           }];
                           }
}

-(void)postdata
{
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"signupwithsocialmedia"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    
    [postdata setObject:delegate.fbfname forKey:@"firstname"];
    [postdata setObject:delegate.fblname forKey:@"lastname"];
    [postdata setObject:delegate.fbemail forKey:@"email"];
    [postdata setObject:delegate.fbid forKey:@"logintoken"];
    [postdata setObject:delegate.fbpicture  forKey:@"fbpicture"];
    [postdata setObject:delegate.devicetoken forKey:@"devicetoken"];
    
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        fbconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
}

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
    if(connection == fbconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *Isinvite = [deserializedData objectForKey:@"isinvite"];
            if([Isinvite isEqualToString:@"Y"])
            {
                invitation *inv = [[invitation alloc]initWithNibName:@"invitation" bundle:nil];
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromRight;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:inv animated:NO];
            }
            else
            {
            
            NSDictionary *userdata = [deserializedData objectForKey:@"data"];
            NSString *userid =[userdata valueForKey:@"lastid"];
            NSString *newuser= [userdata valueForKey:@"newuser"];
            
            [DbHandler deleteDatafromtable:@"delete from usermaster"];
            
            BOOL flg = [DbHandler Insertuser:@"" city:@"" country:@"" emailid:delegate. fbemail firstname:delegate.fbfname gender:@"" uid:userid lastname:delegate.fblname phone:@"" profilepic:@"" state:@"" status:@"" thumbprofilepic:[userdata valueForKey:@"thumbprofilepic"] usertype:@"Sender" zip:@"" push:@"1" sound:@"1" promocode:[userdata valueForKey:@"promocode"] currency:[userdata valueForKey:@"currency"]];
            
            if(flg)
            {
                delegate.struserid=userid;
                delegate.username=[NSString stringWithFormat:@"%@ %@",delegate.fbfname,delegate.fblname];
                delegate.strusertype=@"Sender";
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromRight;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                if([newuser isEqualToString:@"1"])
                {
                  smsverificationvc *sms = [[smsverificationvc alloc]initWithNibName:@"smsverificationvc" bundle:nil];
                    sms.userid=userid;
                    sms.isfirst=@"Y";
               
                [self.navigationController pushViewController:sms animated:NO];
                }
                else
                {
                    homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
                     [self.navigationController pushViewController:home animated:NO];
                }
            }
            
        }
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    [self removeProgressIndicator];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
