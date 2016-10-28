//
//  itempayment.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itempayment.h"
#import "DbHandler.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SCLAlertView.h"
#import "myitemvc.h"
#import "sendrequestvc.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface itempayment ()

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end

@implementation itempayment
@synthesize serveritemid,transactionid,airlogiqfee,safetyfee,appfee,disamt,disrate,insamt,totalamt,itemamt,promocode,paypalamt,refercredit,point;

- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /********** Using the default tracker **********/
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    /**********Manual screen recording**********/
    [tracker set:kGAIScreenName value:@"Send Items"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title=@"Payment";
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"airlogiq.com";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
      // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
    
}

-(void)timerCalled
{
    NSLog(@"Timer Called");
    [timer invalidate];
    
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:paypalamt];
    
    
    //NSDecimalNumber *total =  (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:amt];
    
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount=total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Item Payment";
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    
    paymentViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    paymentViewController.navigationController.navigationItem.leftBarButtonItem.tintColor= [UIColor whiteColor];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    // Your Code
}
- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    //NSLog(@"PayPal Payment Success!");
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    //  self.resultText = nil;
    //self.successView.hidden = YES;
    lblmsg.text=@"Payment Cancelled.";
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];

}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    NSDictionary *paymentdict = [[NSDictionary alloc]init];
    paymentdict = completedPayment.confirmation;
    img.image=[UIImage imageNamed:@"thankyou.png"];
 //   NSLog(@"response data  >>>%@", [[paymentdict objectForKey:@"response"]valueForKey:@"id"]);
     transactionid=[[paymentdict objectForKey:@"response"]valueForKey:@"id"];
    lblmsg.text= [NSString stringWithFormat:@"Thanks for payment.Your Transaction Id is %@",transactionid];
    NSString *strurl= [AppDelegate baseurl];
    NSArray *arritem = [DbHandler FetchItemdetail];
    
    NSString *fromcityid=[DbHandler GetId:[NSString stringWithFormat:@"select city_id from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where (ct.city_name || ' , ' || cnt.country_name)='%@'",[[arritem objectAtIndex:0]valueForKey:@"fromcity"]]];
    
    NSString *tocityid=[DbHandler GetId:[NSString stringWithFormat:@"select city_id from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where (ct.city_name || ' , ' || cnt.country_name)='%@'",[[arritem objectAtIndex:0]valueForKey:@"tocity"]]];
    
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    strurl= [strurl stringByAppendingString:@"createitem"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:fromcityid forKey:@"fromcity"];
    [postdata setObject:tocityid forKey:@"tocity"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"fromdate"] forKey:@"fromdate"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"todate"] forKey:@"todate"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"catid"] forKey:@"category"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"itemname"] forKey:@"itemname"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"itemdesc"] forKey:@"itemdesc"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"itemcost"] forKey:@"itemcost"];
    [postdata setObject:delegate.volid forKey:@"volume"];
    [postdata setObject:@"1" forKey:@"cancellationpolicy"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"insurance"] forKey:@"insurance"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"commercial"] forKey:@"commercial"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"mutual"] forKey:@"mutually"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"subcommercial"] forKey:@"subcommercial"];
    [postdata setObject:@"0" forKey:@"delivery_address"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"zipcode"] forKey:@"delivery_zipcode"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"tozipcode"] forKey:@"tozipcode"];
    [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"charity"] forKey:@"charity"];
    
    
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
    if(connection == catconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            serveritemid = [deserializedData objectForKey:@"itemid"];
                NSString *strurl= [AppDelegate baseurl];
                NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
                NSString *email = [DbHandler GetId:[NSString stringWithFormat:@"select emailid from usermaster where id='%@'",delegate.struserid]];
                strurl= [strurl stringByAppendingString:@"payment"];
                [postdata setObject:email forKey:@"email"];
                [postdata setObject:delegate.struserid forKey:@"userid"];
                [postdata setObject:serveritemid forKey:@"itemid"];
                [postdata setObject:[NSString stringWithFormat:@"%@",totalamt] forKey:@"amount"];
                [postdata setObject:[NSString stringWithFormat:@"%@",appfee] forKey:@"appfee"];
                [postdata setObject:[NSString stringWithFormat:@"%@",safetyfee] forKey:@"safetyfee"];
                [postdata setObject:[NSString stringWithFormat:@"%@",itemamt] forKey:@"itemamt"];
                [postdata setObject:[NSString stringWithFormat:@"%@",insamt] forKey:@"insamt"];
                [postdata setObject:[NSString stringWithFormat:@"%@",disamt] forKey:@"disamt"];
                [postdata setObject:[NSString stringWithFormat:@"%@",disrate] forKey:@"dis"];
                [postdata setObject:[NSString stringWithFormat:@"%@",refercredit] forKey:@"refcredit"];
                [postdata setObject:[NSString stringWithFormat:@"%@",point] forKey:@"point"];
                [postdata setObject:promocode forKey:@"promocode"];
                [postdata setObject:transactionid forKey:@"transactionid"];
                
                AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
                
                
                if([delegate isConnectedToNetwork])
                {
                    [self addProgressIndicator];
                    payconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    [alert show];
                    return;
                }
                
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
        
    }
    if(connection == payconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            if([delegate.isviatrip isEqualToString:@"Y"])
            {
                sendrequestvc *request = [[sendrequestvc alloc]initWithNibName:@"sendrequestvc" bundle:nil];
                request.itemid =serveritemid;
                request.strtripid=delegate.viatripid;
                request.touserid=delegate.viatuserid;
                [self.navigationController pushViewController:request animated:NO];
            }
            else
            {
                myitemvc *item = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
                [self.navigationController pushViewController:item animated:NO];
            }
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
        
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
