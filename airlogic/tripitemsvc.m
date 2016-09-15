//
//  tripitemsvc.m
//  airlogic
//
//  Created by APPLE on 29/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "tripitemsvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SCLAlertView.h"
#import "rateuser.h"
#import "UIViewController+MJPopupViewController.h"
#import "editprofilevc.h"
#import "Messagevc.h"
#import "viewprofile.h"



@interface tripitemsvc ()

@end

@implementation tripitemsvc
int btnindex=0;
int point=0;
double refcredit;
double afee;
@synthesize tripid,lblcredit,curstatus;
@synthesize lbltripname = _lbltripname;
@synthesize lblvolume = _lblvolume;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lbltodate=_lbltodate;
@synthesize lblairlogiqcost = _lblairlogiqcost;
@synthesize lblcategory = _lblcategory;
@synthesize lblflybeecost = _lblflybeecost;
@synthesize lblservice= _lblservice;
@synthesize lbltripcost=_lbltripcost;
@synthesize lbltripid=_lbltripid;
@synthesize btnapproved = _btnapproved;
@synthesize btndeliver = _btndeliver;
@synthesize btncompleted = _btncompleted;
@synthesize btnpayment= _btnpayment;
@synthesize btnpickup=_btnpickup;
@synthesize btntransporting=_btntransporting;
@synthesize btnshow=_btnshow;
@synthesize lblflightname=_lblflightname;
@synthesize btncancel=_btncancel;
@synthesize lbltrid=_lbltrid;
@synthesize lbl1=_lbl1;
@synthesize lbl2=_lbl2;
@synthesize lbl3=_lbl3;
@synthesize lbl4=_lbl4;
@synthesize lbl5=_lbl5;
@synthesize lbl6=_lbl6;
@synthesize lbl7=_lbl7;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Trip Items";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    isfirst=@"N";
    showview=NO;
    viewdetail.hidden=YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageclick)];
    singleTap.numberOfTapsRequired = 1;
    [imgbg setUserInteractionEnabled:YES];
    [imgbg addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Trip Items Screen";
    [super viewDidAppear:animated];
    
    if(![curstatus isEqualToString:@"AcceptedDeal"])
    {
        imgbg.hidden=YES;
    }
    else{
        imgbg.hidden=NO;
    }
}
-(void)imageclick
{
    imgbg.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    
    UIImage *filterimg = [UIImage imageNamed:@"menu_message.png"];
    
    UIButton *filterbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [filterbtn setBackgroundImage:filterimg forState:UIControlStateNormal];
    
    filterbtn.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:filterbtn];
    
    [filterbtn addTarget:self action:@selector(openmessage) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem2];
    
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"checkuserpurchase"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        connpurchase=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    //[self loaddata];
}

-(void)openmessage
{
    Messagevc *msg = [[Messagevc alloc]initWithNibName:@"Messagevc" bundle:nil];
    
    msg.itemid= [[arritem objectAtIndex:0]valueForKey:@"itemid"];
    msg.tripid=tripid;
    msg.touserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    msg.msgstatus=[[arritem objectAtIndex:0]valueForKey:@"currentstatus"];    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:msg animated:NO];
}


-(void)loaddata
{
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"gettripitems"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:tripid forKey:@"tripid"];
    
    
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
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}
-(void)confirm
{
    NSString *valueToSave = @"Y";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"feeoff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self removeProgressIndicator];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == connpurchase)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *cnt = [deserializedData objectForKey:@"tripcnt"];
            if([cnt isEqualToString:@"1"])
            {
                isfirst=@"Y";
                NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"feeoff"];
                if([savedValue isEqualToString:@"Y"])
                {
                    NSLog(@"already show");
                }
                else
                {
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"OK" target:self selector:@selector(confirm)];
                    alert.backgroundViewColor=[UIColor whiteColor];
                    [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:@"Airlogiq Commission Waived off for first Order." closeButtonTitle:nil duration:0.0f];
                }
            }
        }
        else
        {
            [self removeProgressIndicator];
        }
        NSString *strurl= [AppDelegate baseurl];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        strurl= [strurl stringByAppendingString:@"getuserbalance"];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            connpoint=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }

        
    }
    if(connection == connpoint)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        refcredit=0;
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            double point = [[deserializedData objectForKey:@"Point"]doubleValue];
            refcredit=point/2;
            
        }
        
        else
        {
            [self removeProgressIndicator];
        }
        [self loaddata];
        
        
    }
    if(connection == connredeem)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
        }
        else
        {
            [self removeProgressIndicator];
        }
    }
    if(connection == catconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            arritem = [deserializedData objectForKey:@"data"];
            [self showitemdetail];
            NSString *curstatus= [[arritem objectAtIndex:0]valueForKey:@"currentstatus"];
            NSString *itmid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
            if([curstatus isEqualToString:@"DeliverItems"])
            {
                NSString *strurl= [AppDelegate baseurl];
                strurl= [strurl stringByAppendingString:@"checkPendingReview"];
                NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
                [postdata setObject:delegate.struserid forKey:@"userid"];
                [postdata setObject:tripid forKey:@"tripid"];
                [postdata setObject:itmid forKey:@"itemid"];
                
                AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
                
                if([delegate isConnectedToNetwork])
                {
                    [self addProgressIndicator];
                    reviewconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    [alert show];
                    return;
                }
            }
        }
        else
        {
            [self removeProgressIndicator];
            
        }
         [self removeProgressIndicator];
    }
    
    if(connection == statusconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            if([status isEqualToString:@"DeliverItems"])
            {
                [self removeProgressIndicator];
                
                rateuser *rate= [[rateuser alloc]initWithNibName:@"rateuser" bundle:nil];
                rate.itemid=itemid;
                rate.torateuserid=itemuserid;
                rate.tripid=tripid;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromRight;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromRight;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:rate animated:NO];
                return;
            }
            
            if([isfund isEqualToString:@"Yes"])
            {
                [self removeProgressIndicator];
                
                NSString *strurl= [AppDelegate baseurl];
                strurl= [strurl stringByAppendingString:@"paymentrequest"];
                NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
                [postdata setObject:delegate.struserid forKey:@"flybeeid"];
                [postdata setObject:tripid forKey:@"tripid"];
                [postdata setObject:payid forKey:@"paymentid"];
                [postdata setObject:itemid forKey:@"itemid"];
                [postdata setObject:[NSString stringWithFormat:@"%d",point] forKey:@"point"];
                [postdata setObject:[NSString stringWithFormat:@"%f",afee] forKey:@"fee"];
                [postdata setObject:delegate.struserid forKey:@"userid"];
                [postdata setObject:payid forKey:@"paymentid"];
                
                
                AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
                
                if([delegate isConnectedToNetwork])
                {
                    [self addProgressIndicator];
                    pmtconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    [alert show];
                    return;
                }

            }
            [self loaddata];
        }
        else
        {
            [self removeProgressIndicator];
            
        }
    }
    
    if(connection == reviewconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            NSString *cnt = [deserializedData objectForKey:@"pedingcount"];
            
            if([cnt isEqualToString:@"0"])
            {
                rateuser *rate= [[rateuser alloc]initWithNibName:@"rateuser" bundle:nil];
                rate.itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];;
                rate.torateuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
                rate.tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromRight;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromRight;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:rate animated:NO];
                return;
            }
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

    }
    
    if(connection == fundconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            [self updateitemstatus:status _itemid:itemid];
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert addButton:@"OK" target:self selector:@selector(btnbankok)];
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:nil duration:0.0f];
            
        }
        [self loaddata];
     }
    if(connection == delconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            [self updateitemstatus:status _itemid:itemid];
        }
        else
        {
            [self removeProgressIndicator];
            btnindex=0;
            status=@"";
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
            
        }
        [self loaddata];
    }

    if(connection == pmtconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData objectForKey:@"response_message"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
            
        }
        [self loaddata];
    }
}

-(void)showitemdetail
{
            _lbltripname.text=[[arritem objectAtIndex:0]valueForKey:@"itemname"];
            _lbltripid.text=[NSString stringWithFormat:@"R%@",[[arritem objectAtIndex:0]valueForKey:@"requestid"]];
            _fromcity.text=[[arritem objectAtIndex:0]valueForKey:@"fromcity"];
            _tocity.text=[[arritem objectAtIndex:0]valueForKey:@"tocity"];
            _lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arritem objectAtIndex:0]valueForKey:@"volume"]];
            _lblweight.text=[[arritem objectAtIndex:0]valueForKey:@"weight"];
            _lbldate.text= [NSString stringWithFormat:@"%@",[[arritem objectAtIndex:0]valueForKey:@"fromdate"]];
            _lbltodate.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:0]valueForKey:@"todate"]];
            _lblcategory.text=[[arritem objectAtIndex:0]valueForKey:@"category"];
            _lblflightname.text=[[arritem objectAtIndex:0]valueForKey:@"flightname"];
            _lbltrid.text=[NSString stringWithFormat:@"T%@%@",[[arritem objectAtIndex:0]valueForKey:@"tripid"],delegate.struserid];
    
            NSString *commercial =[[arritem objectAtIndex:0]valueForKey:@"commercial"];
            NSString *mutual =[[arritem objectAtIndex:0]valueForKey:@"mutually_agreed"];
            NSString *currenstatus=[[arritem objectAtIndex:0]valueForKey:@"currentstatus"];
    
             if([commercial isEqualToString:@"Yes"])
             {
              _lblservice.text=@"Commercial";
             _lbltripcost.text=[NSString stringWithFormat:@"$ %@",[[arritem objectAtIndex:0]valueForKey:@"itemamt"]];
    
                 if(![currenstatus isEqualToString:@"PaymentRequest"])
                 {
                 double tripcost =[[[arritem objectAtIndex:0]valueForKey:@"itemamt"]doubleValue];
    
                 int acost = [delegate.airlogiqcost intValue];
                 double airlogiqcost= [[[arritem objectAtIndex:0]valueForKey:@"airlogiqfee"]doubleValue];
                 double flybeecost = tripcost-airlogiqcost;
                 if([isfirst isEqualToString:@"Y"])
                 {
                     flybeecost=tripcost;
                     _lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
                     _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost];
                 }
                 else
                 {
                     if(refcredit > airlogiqcost)
                     {
                         point=(refcredit*2);
                         afee=0;
                        _lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
                        _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+airlogiqcost];
    
                     }
                     else if(refcredit == airlogiqcost)
                     {
                          point=(refcredit*2);
                          afee=0;
                         _lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
                         _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+airlogiqcost];
                     }
                     else
                     {
                         double acost= airlogiqcost-refcredit;
                         afee=acost;
                         point=(refcredit*2);
                         _lblairlogiqcost.text=[NSString stringWithFormat:@"$ %.2f",acost];
                         _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+refcredit];
                     }
                     
                     double refcredit = [[[arritem objectAtIndex:0]valueForKey:@"refercredit"]doubleValue];
                     if(refcredit > 0)
                     {
                     viewcredit.alpha=1;
                     lblcredit.text=[NSString stringWithFormat:@"Credits Applied:$ %.2f",refcredit];
                     viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 360);
                     _lblmsg.frame=CGRectMake(0, 258, self.view.frame.size.width, 15);
                     viewstatus.frame=CGRectMake(0, 270, self.view.frame.size.width, 42);
                     _btncancel.frame=CGRectMake(0, 320, self.view.frame.size.width, 40);
                     }
                     else
                     {
                         _lblairlogiqcost.text=[NSString stringWithFormat:@"$%.2f",airlogiqcost];
                         _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost];
                         viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 340);
                         _lblmsg.frame=CGRectMake(0, 230, self.view.frame.size.width, 15);
                         viewstatus.frame=CGRectMake(0, 245, self.view.frame.size.width, 42);
                         _btncancel.frame=CGRectMake(0, 300, self.view.frame.size.width, 40);
                     }
                 }
                 }
                 else
                 {
                     double tripcost =[[[arritem objectAtIndex:0]valueForKey:@"itemamt"]doubleValue];
                     double airlogiqcost= [[[arritem objectAtIndex:0]valueForKey:@"airlogiqfee"]doubleValue];
                     double flybeecost = tripcost-airlogiqcost;
                     _lblairlogiqcost.text=[NSString stringWithFormat:@"$%.2f",airlogiqcost];
                     _lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost];
                    viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 340);
                     _lblmsg.frame=CGRectMake(0, 230, self.view.frame.size.width, 15);
                     viewstatus.frame=CGRectMake(0, 245, self.view.frame.size.width, 42);
                     _btncancel.frame=CGRectMake(0, 300, self.view.frame.size.width, 40);
                 }
    
             }
             if([mutual isEqualToString:@"Yes"])
              {
                  _lblservice.text=@"Mutual";
                  _lblairlogiqcost.text=[NSString stringWithFormat:@"$0"];
                  _lbltripcost.text=[NSString stringWithFormat:@"$0"];
                  _lblflybeecost.text=[NSString stringWithFormat:@"$0"];
                  
                  _btnpickup.frame=CGRectMake(self.view.frame.size.width-255, 15, 15, 15);
                  _btntransporting.frame=CGRectMake(self.view.frame.size.width-175, 15, 15, 15);
                  _btndeliver.frame=CGRectMake(self.view.frame.size.width-108, 15, 15, 15);
                  _btncompleted.frame=CGRectMake(self.view.frame.size.width-39, 15, 15, 15);
                  
                  _lbl2.frame=CGRectMake(self.view.frame.size.width-260, 25, 24, 18);
                  _lbl3.frame=CGRectMake(self.view.frame.size.width-190, 25, 42, 19);
                  _lbl4.frame=CGRectMake(self.view.frame.size.width-120, 25, 40, 21);
                  _lbl7.frame=CGRectMake(self.view.frame.size.width-53, 25, 50, 21);
                  
                  _btnapproved.alpha=0;
                  _btnpayment.alpha=0;
                  _lbl6.alpha=0;
                  _lbl5.alpha=0;
                  
                  viewcredit.hidden=YES;
                  viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 340);
                  _lblmsg.frame=CGRectMake(0, 230, self.view.frame.size.width, 15);
                  viewstatus.frame=CGRectMake(0, 245, self.view.frame.size.width, 42);
                  _btncancel.frame=CGRectMake(0, 300, self.view.frame.size.width, 40);
                  
    
                  
              }
    
            _imgprofile.layer.cornerRadius= _imgprofile.frame.size.width/2;
            _imgprofile.clipsToBounds=YES;
    
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arritem objectAtIndex:0]valueForKey:@"profilepic"]];
    
            [_imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            _imgprofile.layer.borderWidth = 2.0;
    
    
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
    tapped.numberOfTapsRequired = 1;
    [_imgprofile addGestureRecognizer:tapped];
    
    
            _btnpickup.tag=101;
            [_btnpickup addTarget:self action:@selector(pickclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btncancel.tag=99;
            [_btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btntransporting.tag=102;
            [_btntransporting addTarget:self action:@selector(transportclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btndeliver.tag=103;
            [_btndeliver addTarget:self action:@selector(deliveryclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btnpayment.tag=104;
            [_btnpayment addTarget:self action:@selector(paymentclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btnapproved.tag=105;
            //[rcell.btnapproved addTarget:self action:@selector(approvedclick:)forControlEvents:UIControlEventTouchUpInside];
    
            _btncompleted.tag=106;
            //[rcell.btncompleted addTarget:self action:@selector(completeclick:)forControlEvents:UIControlEventTouchUpInside];
    
    
            if([currenstatus isEqualToString:@"PickUp"] || btnindex== 101)
             {
                _btncancel.userInteractionEnabled=NO;
                _btnpickup.userInteractionEnabled=NO;
                 [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
            }
            if([currenstatus isEqualToString:@"Transporting"] || btnindex==102)
            {
                 _btncancel.userInteractionEnabled=NO;
                [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                _btntransporting.userInteractionEnabled=NO;
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpickup.userInteractionEnabled=NO;
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
            }
    
            if([currenstatus isEqualToString:@"DeliverItems"] || btnindex==103)
            {
                 _btncancel.userInteractionEnabled=NO;
                [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                _btntransporting.userInteractionEnabled=NO;
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpickup.userInteractionEnabled=NO;
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btndeliver.userInteractionEnabled=NO;
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpayment setImage:[UIImage imageNamed:@"blackcircle"] forState:UIControlStateNormal];
            }
    
            if([currenstatus isEqualToString:@"PaymentRequest"]|| btnindex==104)
            {
                 _btncancel.userInteractionEnabled=NO;
                 [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                _btntransporting.userInteractionEnabled=NO;
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpickup.userInteractionEnabled=NO;
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btndeliver.userInteractionEnabled=NO;
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpayment.userInteractionEnabled=NO;
                [_btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
            }
            if([currenstatus isEqualToString:@"Approved"] || btnindex==105)
            {
                 _btncancel.userInteractionEnabled=NO;
               [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                _btntransporting.userInteractionEnabled=NO;
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpickup.userInteractionEnabled=NO;
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btndeliver.userInteractionEnabled=NO;
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpayment.userInteractionEnabled=NO;
                [_btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnapproved.userInteractionEnabled=NO;
                [_btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
            }
            if([currenstatus isEqualToString:@"Completed"] || btnindex==106)
            {
                 _btncancel.userInteractionEnabled=NO;
                _btncancel.hidden=YES;
                viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 310);
                
                _btntransporting.userInteractionEnabled=NO;
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpickup.userInteractionEnabled=NO;
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btndeliver.userInteractionEnabled=NO;
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnpayment.userInteractionEnabled=NO;
                [_btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btnapproved.userInteractionEnabled=NO;
                [_btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btncompleted.userInteractionEnabled=NO;
                [_btncompleted setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
            }
    viewdetail.hidden=NO;

}

-(void)imgclick :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int index =gesture.view.tag;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
   viewprofile *profile= [[viewprofile alloc]initWithNibName:@"viewprofile" bundle:nil];
   profile.userid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    [self.navigationController pushViewController:profile animated:NO];
    
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    int x =70.f;
//    if(arritem.count>0)
//        {
//            
//            
//            NSString *currenstatus=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"currentstatus"];
//            if([currenstatus isEqualToString:@"Completed"])
//            {
//            x=300;
//            }
//            else
//            {
//            x=360;
//            }
//        }
//
//    return x;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    UITableViewCell *cell;
//    
//   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if(arritem.count > 0)
//    {
//        tripitemcell *rcell = (tripitemcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        
//        if (rcell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tripitemcell" owner:self options:nil];
//            rcell = [nib objectAtIndex:0];
//        }
//        rcell.lbltripname.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"itemname"];
//        rcell.lbltripid.text=[NSString stringWithFormat:@"R%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
//        rcell.fromcity.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"fromcity"];
//        rcell.tocity.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"tocity"];
//        rcell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
//        rcell.lblweight.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"weight"];
//        rcell.lbldate.text= [NSString stringWithFormat:@"%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"fromdate"]];
//        rcell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
//        rcell.lblcategory.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"category"];
//        rcell.lblflightname.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"flightname"];
//        rcell.lbltrid.text=[NSString stringWithFormat:@"T%@%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"tripid"],delegate.struserid];
//        
//        NSString *commercial =[[arritem objectAtIndex:[indexPath row]]valueForKey:@"commercial"];
//        NSString *mutual =[[arritem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
//        NSString *currenstatus=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"currentstatus"];
//        
//         if([commercial isEqualToString:@"Yes"])
//         {
//          rcell.lblservice.text=@"Commercial";
//            rcell.lbltripcost.text=[NSString stringWithFormat:@"$ %@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"itemamt"]];
//             
//             if(![currenstatus isEqualToString:@"PaymentRequest"])
//             {
//             double tripcost =[[[arritem objectAtIndex:[indexPath row]]valueForKey:@"itemamt"]doubleValue];
//             
//             int acost = [delegate.airlogiqcost intValue];
//             double airlogiqcost= [[[arritem objectAtIndex:[indexPath row]]valueForKey:@"airlogiqfee"]doubleValue];
//             double flybeecost = tripcost-airlogiqcost;
//             if([isfirst isEqualToString:@"Y"])
//             {
//                 flybeecost=tripcost;
//                 rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
//                 rcell.lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost];
//             }
//             else
//             {
//                 if(refcredit > airlogiqcost)
//                 {
//                     point=(refcredit*2);
//                     afee=0;
//                     rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
//                     rcell.lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+airlogiqcost];
//                     
//                 }
//                 else if(refcredit == airlogiqcost)
//                 {
//                      point=(refcredit*2);
//                      afee=0;
//                     rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$ 0"];
//                     rcell.lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+airlogiqcost];
//                 }
//                 else
//                 {
//                     double acost= airlogiqcost-refcredit;
//                     afee=acost;
//                     point=(refcredit*2);
//                     rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$ %.2f",acost];
//                     rcell.lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost+refcredit];
//                 }
//                 
//             }
//             }
//             else
//             {
//                 double tripcost =[[[arritem objectAtIndex:[indexPath row]]valueForKey:@"itemamt"]doubleValue];
//                 double airlogiqcost= [[[arritem objectAtIndex:[indexPath row]]valueForKey:@"airlogiqfee"]doubleValue];
//                 double flybeecost = tripcost-airlogiqcost;
//                 
//                 rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$%.2f",airlogiqcost];
//                 rcell.lblflybeecost.text=[NSString stringWithFormat:@"$ %.2f",flybeecost];
//                 
//             }
//             
//         }
//         if([mutual isEqualToString:@"Yes"])
//          {
//              rcell.lblservice.text=@"Mutual";
//              rcell.lblairlogiqcost.text=[NSString stringWithFormat:@"$0"];
//              rcell.lbltripcost.text=[NSString stringWithFormat:@"$0"];
//              rcell.lblflybeecost.text=[NSString stringWithFormat:@"$0"];
//              
//              rcell.btnpickup.frame=CGRectMake(82, 350, 15, 15);
//              rcell.btntransporting.frame=CGRectMake(145, 350, 15, 15);
//              rcell.btndeliver.frame=CGRectMake(212, 350, 15, 15);
//              rcell.btncompleted.frame=CGRectMake(281, 350, 15, 15);
//              
//              rcell.lbl2.frame=CGRectMake(76, 365, 24, 18);
//              rcell.lbl3.frame=CGRectMake(130, 364, 42, 19);
//              rcell.lbl4.frame=CGRectMake(200, 364, 40, 21);
//              rcell.lbl7.frame=CGRectMake(267, 364, 50, 21);
//              
//              rcell.btnapproved.alpha=0;
//              rcell.btnpayment.alpha=0;
//              rcell.lbl6.alpha=0;
//              rcell.lbl5.alpha=0;
//              
//          }
//        
//        rcell.imgprofile.layer.cornerRadius= rcell.imgprofile.frame.size.width/2;
//        rcell.imgprofile.clipsToBounds=YES;
//
//        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"profilepic"]];
//        
//        [rcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        rcell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
//        rcell.imgprofile.layer.borderWidth = 2.0;
//        
//        
//        rcell.btnpickup.tag=101;
//        [rcell.btnpickup addTarget:self action:@selector(pickclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//        rcell.btncancel.tag=99;
//        [rcell.btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//        rcell.btntransporting.tag=102;
//        [rcell.btntransporting addTarget:self action:@selector(transportclick:)forControlEvents:UIControlEventTouchUpInside];
//    
//        rcell.btndeliver.tag=103;
//        [rcell.btndeliver addTarget:self action:@selector(deliveryclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//        rcell.btnpayment.tag=104;
//        [rcell.btnpayment addTarget:self action:@selector(paymentclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//        rcell.btnapproved.tag=105;
//        //[rcell.btnapproved addTarget:self action:@selector(approvedclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//        rcell.btncompleted.tag=106;
//        //[rcell.btncompleted addTarget:self action:@selector(completeclick:)forControlEvents:UIControlEventTouchUpInside];
//        
//       
//        if([currenstatus isEqualToString:@"PickUp"] || btnindex== 101)
//         {
//            rcell.btncancel.userInteractionEnabled=NO;
//            rcell.btnpickup.userInteractionEnabled=NO;
//             [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//        }
//        if([currenstatus isEqualToString:@"Transporting"] || btnindex==102)
//        {
//             rcell.btncancel.userInteractionEnabled=NO;
//            [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            rcell.btntransporting.userInteractionEnabled=NO;
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpickup.userInteractionEnabled=NO;
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//        }
//        
//        if([currenstatus isEqualToString:@"DeliverItems"] || btnindex==103)
//        {
//             rcell.btncancel.userInteractionEnabled=NO;
//             [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            
//            rcell.btntransporting.userInteractionEnabled=NO;
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpickup.userInteractionEnabled=NO;
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btndeliver.userInteractionEnabled=NO;
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"blackcircle"] forState:UIControlStateNormal];
//            
//        }
//        
//        if([currenstatus isEqualToString:@"PaymentRequest"]|| btnindex==104)
//        {
//             rcell.btncancel.userInteractionEnabled=NO;
//             [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            rcell.btntransporting.userInteractionEnabled=NO;
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpickup.userInteractionEnabled=NO;
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btndeliver.userInteractionEnabled=NO;
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpayment.userInteractionEnabled=NO;
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//        }
//        if([currenstatus isEqualToString:@"Approved"] || btnindex==105)
//        {
//             rcell.btncancel.userInteractionEnabled=NO;
//           [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            rcell.btntransporting.userInteractionEnabled=NO;
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpickup.userInteractionEnabled=NO;
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btndeliver.userInteractionEnabled=NO;
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpayment.userInteractionEnabled=NO;
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnapproved.userInteractionEnabled=NO;
//            [rcell.btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//        }
//        if([currenstatus isEqualToString:@"Completed"] || btnindex==106)
//        {
//             rcell.btncancel.userInteractionEnabled=NO;
//            //[rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            rcell.btncancel.hidden=YES;
//            rcell.btntransporting.userInteractionEnabled=NO;
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpickup.userInteractionEnabled=NO;
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btndeliver.userInteractionEnabled=NO;
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnpayment.userInteractionEnabled=NO;
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btnapproved.userInteractionEnabled=NO;
//            [rcell.btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncompleted.userInteractionEnabled=NO;
//            [rcell.btncompleted setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//        }
//    
//        cell=rcell;
//    }
//    else
//    {
//        emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        if (ecell == nil)
//        {
//            ecell.contentView.backgroundColor = [UIColor whiteColor];
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
//            ecell = [nib objectAtIndex:0];
//        }
//        ecell.lblmsg.text=@"No Items Found.";
//        cell=ecell;
//    }
//    return cell;
//}


-(void)cancelclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    btnindex=btnTemp.tag;
    isfund=@"No";

//    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
//    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
//    
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    status=@"Cancelled";
    
    [self showalert:status msg:@"Do you want to cancel the request?" title:@"Warn"];
}

- (void)pickclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    btnindex=btnTemp.tag;
    isfund=@"No";

//    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
//    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
//    
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    status=@"PickUp";

    [self showalert:status msg:@"Have you Picked Up Item?" title:@"Message"];
    
}

- (void)transportclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    btnindex=btnTemp.tag;
    isfund=@"No";

    NSLog(@"hi id is >> %d",btnindex);
    
//    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
//    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
//    
    status=@"Transporting";
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    [self showalert:status msg:@"Are you in-transit with item?" title:@"Message"];
    
}

-(void)deliveryclick:(UIButton *)sender
{

    UIButton *btnTemp = (UIButton *)sender;
    btnindex=btnTemp.tag;
    isfund=@"DI";

  
    status=@"DeliverItems";
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    [self showalert:status msg:@"Have you delivered the item(s)?" title:@"Message"];
    
}
-(void)paymentclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    btnindex=btnTemp.tag;
    
    isfund=@"Yes";
    NSLog(@"hi id is >> %d",btnindex);
    
//    
    NSString *currenstatus=[[arritem objectAtIndex:0]valueForKey:@"currentstatus"];
    if(![currenstatus isEqualToString:@"DeliverItems"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        
        [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:@"You cannot send fund request until you deliver item." closeButtonTitle:@"Cancel" duration:0.0f];
        return;
    }
    else
    {
    status=@"PaymentRequest";
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    payid=[[arritem objectAtIndex:0]valueForKey:@"payid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    [self showalert:status msg:@"Are you logging payment request?" title:@"Message"];
    }
}
-(void)approvedclick:(UIButton *)sender
{
//    UIButton *btnTemp = (UIButton *)sender;
//    btnindex=btnTemp.tag;
//    isfund=@"No";
//    NSLog(@"hi id is >> %d",btnindex);
//    
//    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
//    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
//    
//    status=@"Approved";
//    itemid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"itemid"];
//    itemuserid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"touserid"];
//    tripid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"tripid"];
//    [self showalert:status];
//    
}

-(void)completeclick:(UIButton *)sender
{
//    UIButton *btnTemp = (UIButton *)sender;
//    btnindex=btnTemp.tag;
//    isfund=@"No";
//
//    
//    NSLog(@"hi id is >> %d",btnindex);
//    
//    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
//    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
//    
//    status=@"Completed";
//    itemid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"itemid"];
//    itemuserid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"touserid"];
//    tripid=[[arritem objectAtIndex:indexPath.row]valueForKey:@"tripid"];
//    [self showalert:status];
    
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
-(void)updateitemstatus :(NSString *)currstatus _itemid:(NSString *)tripitemid
{
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"updateitemstatus"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:tripitemid forKey:@"itemid"];
    [postdata setObject:currstatus forKey:@"status"];
    [postdata setObject:tripid forKey:@"tripid"];
    [postdata setObject:delegate.struserid forKey:@"fromid"];
    [postdata setObject:itemuserid forKey:@"toid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        statusconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

}

-(void)showalert:(NSString *)_status msg:(NSString *)_msg title:(NSString *)_title
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundViewColor=[UIColor whiteColor];
    [alert addButton:@"OK" target:self selector:@selector(btnclick)];

    [alert showCustom:self image:[UIImage imageNamed:@"status"] color:[UIColor orangeColor] title:@"Status" subTitle:[NSString stringWithFormat:_msg] closeButtonTitle:@"Cancel" duration:0.0f];
}

-(void)btnbankok
{
    editprofilevc *edit = [[editprofilevc alloc]initWithNibName:@"editprofilevc" bundle:nil];
    edit.pagefrom=@"TI";
    edit.tripid=tripid;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:edit animated:NO];
}
-(void)btnclick
{
    if([isfund isEqualToString:@"Yes"])
    {
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"checkbankdetails"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            fundconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }

    }
    else if([isfund isEqualToString:@"DI"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        UITextField *textField = [alert addTextField:@"Enter OTP Code"];
        [alert addButton:@"Verify OTP"  actionBlock:^(void)
        {
            NSLog(@"Text value: %@", textField.text);
            
            if([textField.text length]> 0)
            {
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"checkdeliverycode"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:itemid forKey:@"itemid"];
            [postdata setObject:textField.text forKey:@"otp"];
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            if([delegate isConnectedToNetwork])
            {
                [self addProgressIndicator];
                delconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"ENTER OTP" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                [alert show];
                return;
            }


        }];
        
        [alert showEdit:self image:[UIImage imageNamed:@"OTP.png"] title:@"One Time Password" subTitle:@"To confirm delivery of item enter OTP code."  closeButtonTitle:@"Cancel" duration:0.0f];
        
    }

    else
    {
    [self updateitemstatus:status _itemid:itemid];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    status=@"";
    itemid=@"";
    itemuserid=@"";
    isfund=@"";
    btnindex=0;
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
