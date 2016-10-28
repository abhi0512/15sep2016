//
//  currency.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "currency.h"
#import <QuartzCore/QuartzCore.h>
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UIViewController+MJPopupViewController.h"
#import "homeViewController.h"


@interface currency ()

@end

@implementation currency
@synthesize dollar,rs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)dismissPopup
{
    homeViewController *home= [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
    [self dismissPopupViewController:home animationType:MJPopupViewAnimationFade];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dollartap)];
    singleTap.numberOfTapsRequired = 1;
    
    [img1 setUserInteractionEnabled:YES];
    
    [img1 addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rsDetected)];
    singleTap1.numberOfTapsRequired = 1;
    
    [img2 setUserInteractionEnabled:YES];
    
    [img2 addGestureRecognizer:singleTap1];

}

-(void)dollartap
{
    istapped=TRUE;
    if([dollar isEqualToString:@"Yes"])
    {
        dollar=@"No";
        [img1 setImage:[UIImage imageNamed:@"dollargrey.png"]];
    }
    else
    {
        dollar=@"Yes";
        rs=@"No";
        [img2 setImage:[UIImage imageNamed:@"rupeegrey.png"]];
        [img1 setImage:[UIImage imageNamed:@"dollar.png"]];
    }
}

-(void)rsDetected
{
    istapped=TRUE;
    if([rs isEqualToString:@"Yes"])
    {
        rs=@"No";
        [img1 setImage:[UIImage imageNamed:@"rupeegrey.png"]];
    }
    else
    {
        rs=@"Yes";
        dollar=@"No";
        [img2 setImage:[UIImage imageNamed:@"rupee.png"]];
        [img1 setImage:[UIImage imageNamed:@"dollargrey.png"]];
    }
}
-(IBAction)onbtnsendclick:(id)sender
{
    if(! istapped)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Currency" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    NSString *strurl= [AppDelegate baseurl];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    
    strurl= [strurl stringByAppendingString:@"updatecurrency"];
    
    if([dollar isEqualToString:@"Yes"])
    {
    [postdata setObject:@"USD" forKey:@"cur"];
    }
    else if([rs isEqualToString:@"Yes"])
    {
    [postdata setObject:@"INR" forKey:@"cur"];
    }
       
    [postdata setObject:delegate.struserid forKey:@"uid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        NSURLConnection *catconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [responseString objectFromJSONString];
    NSString *string = [deserializedData objectForKey:@"response_code"];
    
    if([string isEqualToString:@"200"])
    {
        [self removeProgressIndicator];
        //[self._delegate cur:self didFinishEnteringItem:@"done"];
        [self._delegate currency:self didFinishEnteringItem:@"Done"];
         homeViewController *vc = [[homeViewController alloc]init];
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
