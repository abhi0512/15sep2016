//
//  notificationsetting.m
//  airlogic
//
//  Created by APPLE on 06/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "notificationsetting.h"
#import "DbHandler.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"

@interface notificationsetting ()

@end

@implementation notificationsetting

- (void)viewDidLoad {
    self.title=@"Notification";
    [super viewDidLoad];
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem ;
    
    [swtchnotification addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [swtchsound addTarget:self action:@selector(changesoundSwitch:) forControlEvents:UIControlEventValueChanged];
   
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    notifiation=[DbHandler GetId:[NSString stringWithFormat:@"select pushnotification from usermaster where id='%@'",delegate.struserid]];
    sound=[DbHandler GetId:[NSString stringWithFormat:@"select sound from usermaster where id='%@'",delegate.struserid]];
    
    if([notifiation isEqualToString:@"1"])
    {
    [swtchnotification setOn:YES animated:YES];
    }
    else
    {
       [swtchnotification setOn:NO animated:NO];
    }
    if([sound isEqualToString:@"1"])
    {
        [swtchsound setOn:YES animated:YES];
        
    }
    else
    {
         [swtchsound setOn:NO animated:NO];
    }
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

- (void)changesoundSwitch:(id)sender{
    if([sender isOn])
    {
        sound=@"1";
    }
    else
    {
        sound=@"0";
    }
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"saveusersettings"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:notifiation forKey:@"notification"];
    [postdata setObject:sound forKey:@"sound"];
    
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
- (void)changeSwitch:(id)sender{
    if([sender isOn])
    {
    notifiation=@"1";
    }
    else
    {
    notifiation=@"0";
    }
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"saveusersettings"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:notifiation forKey:@"notification"];
    [postdata setObject:sound forKey:@"sound"];
    
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
            [DbHandler updatenotificationsetting:notifiation sound:sound userid:delegate.struserid];
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
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
-(void)viewDidDisappear:(BOOL)animated
{
    sound=@"0";
    notifiation=@"0";
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
