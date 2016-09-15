//
//  itemslist.m
//  airlogic
//
//  Created by APPLE on 01/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itemslist.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SCLAlertView.h"
#import  "rateuser.h"
#import "Messagevc.h"



@interface itemslist ()

@end

@implementation itemslist
int btindex=0;
@synthesize itemid,lblcredit;

@synthesize lbltripname = _lbltripname;
@synthesize lblvolume = _lblvolume;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize lblstar=_lblstar;
@synthesize lblotp=_lblotp;
@synthesize lbltodate=_lbltodate;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lbltripcost=_lbltripcost;
@synthesize lblsenderid=_lblsenderid;
@synthesize btnapproved = _btnapproved;
@synthesize btndeliver = _btndeliver;
@synthesize btncompleted = _btncompleted;
@synthesize btnpayment= _btnpayment;
@synthesize btnpickup=_btnpickup;
@synthesize btntransporting=_btntransporting;
@synthesize btncancel=_btncancel;
@synthesize lblcurrecy=_lblcurrecy;
@synthesize lblpayment=_lblpayment;
@synthesize lblitemid=_lblitemid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Item Detail";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arritem = [[NSMutableArray alloc]init];
    
    viewdetail.hidden=YES;
    
     // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Item Detail Screen";
    [super viewDidAppear:animated];
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
    strurl= [strurl stringByAppendingString:@"getactivetripdetail"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:itemid forKey:@"itemid"];
    
    
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

-(void)openmessage
{
    Messagevc *msg = [[Messagevc alloc]initWithNibName:@"Messagevc" bundle:nil];
    
    msg.itemid= itemid;
    msg.tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    msg.touserid=[[arritem objectAtIndex:0]valueForKey:@"tripuserid"];
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
            arritem = [deserializedData objectForKey:@"data"];
            [self showtripdetail];
            NSString *curstatus= [[arritem objectAtIndex:0]valueForKey:@"currentstatus"];
            NSString *trpid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
            if([curstatus isEqualToString:@"DeliverItems"])
            {
                NSString *strurl= [AppDelegate baseurl];
                strurl= [strurl stringByAppendingString:@"checkPendingReview"];
                NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
                [postdata setObject:delegate.struserid forKey:@"userid"];
                [postdata setObject:trpid forKey:@"tripid"];
                [postdata setObject:itemid forKey:@"itemid"];
                
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
                rate.torateuserid=[[arritem objectAtIndex:0]valueForKey:@"tripuserid"];
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
                
            }
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }
    [self removeProgressIndicator];

}
-(void)showtripdetail
{
            _lbltripname.text=[[arritem objectAtIndex:0]valueForKey:@"category"];
            _lblsenderid.text=[NSString stringWithFormat:@"R%@",[[arritem objectAtIndex:0]valueForKey:@"requestid"]];
            _fromcity.text=[[arritem objectAtIndex:0]valueForKey:@"fromcity"];
            _tocity.text=[[arritem objectAtIndex:0]valueForKey:@"tocity"];
            _lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arritem objectAtIndex:0]valueForKey:@"volume"]];
            _lblweight.text=[[arritem objectAtIndex:0]valueForKey:@"weight"];
            _lbldate.text= [[arritem objectAtIndex:0]valueForKey:@"fromdate"];
            _lbltodate.text=[[arritem objectAtIndex:0]valueForKey:@"todate"];
            _lbltripcost.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:0]valueForKey:@"amount"]];
    
            NSString *ptype=[[arritem objectAtIndex:0]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
            NSString *pricelen= [NSString stringWithFormat:@"%@",[[arritem objectAtIndex:0]valueForKey:@"amount"]];
            if([pricelen length] > 3)
            {
                _lblcurrecy.frame=CGRectMake(self.view.frame.size
                                             .width-106, 14, 10, 21);
                _lbltripcost.frame=CGRectMake(self.view.frame.size
                                              .width-102,-4, 94, 77);
                [_lbltripcost setFont:[UIFont fontWithName:@"Arial Narrow" size:40.0f]];
                
            }
                else if([pricelen length] > 2)
                {
                    _lblcurrecy.frame=CGRectMake(self.view.frame.size
                                                 .width-106, 14, 10, 21);
                    _lbltripcost.frame=CGRectMake(self.view.frame.size
                                                  .width-102,-4, 94, 77);
                    [_lbltripcost setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
                }
            else if([pricelen length] == 2)
            {
                _lblcurrecy.frame=CGRectMake(self.view.frame.size
                                             .width-77, 14, 10, 21);
                _lbltripcost.frame=CGRectMake(self.view.frame.size
                                              .width-70,-4, 62, 77);
                 [_lbltripcost setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
            }
            else
            {
                _lblcurrecy.frame=CGRectMake(self.view.frame.size
                                             .width-43, 11, 10, 21);
                _lbltripcost.frame=CGRectMake(self.view.frame.size
                                              .width-36,-4, 30, 77);
                 [_lbltripcost setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
            }
                 _lblpayment.text=@"Commercial";
            }
            else
            {
                 _lblpayment.text=@"Mutual";
                _lblcurrecy.frame=CGRectMake(self.view.frame.size
                                             .width-43, 11, 10, 21);
                _lbltripcost.frame=CGRectMake(self.view.frame.size
                                              .width-36, -4, 30, 77);
            }
             _lblotp.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:0]valueForKey:@"delivery_otp"]];
    
             _lblitemid.text=[NSString stringWithFormat:@"I%@%@",[[arritem objectAtIndex:0]valueForKey:@"itemid"],delegate.struserid];
    
             _imgprofile.layer.cornerRadius=  _imgprofile.frame.size.width/2;
             _imgprofile.clipsToBounds=YES;
    
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arritem objectAtIndex:0]valueForKey:@"profilepic"]];
    
            [ _imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
            int userid=[[arritem objectAtIndex:0]valueForKey:@"userid"];
    
             _imgprofile.tag=userid;
             _imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
             _imgprofile.layer.borderWidth = 2.0;
    
    
            NSString *commercial =[[arritem objectAtIndex:0]valueForKey:@"commercial"];
            NSString *mutual =[[arritem objectAtIndex:0]valueForKey:@"mutually_agreed"];
            if(![commercial isEqualToString:@"Yes"])
            {
                viewcredit.alpha=0;
                viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 280);
                viewstatus.frame=CGRectMake(0, 190, self.view.frame.size.width,42);
                _btncancel.frame=CGRectMake(0, 240,self.view.frame.size.width, 40);
                
//                 _btnpickup.frame=CGRectMake(110,206,15,15);
//                 _btntransporting.frame=CGRectMake(195,206,15,15);
                   _btndeliver.frame=CGRectMake(self.view.frame.size.width-39,13,15,15);
//    
//                 _lbl2.frame=CGRectMake(106,220,24,18);
//                 _lbl3.frame=CGRectMake(180,218,44,21);
//                 _lbl4.frame=CGRectMake(273,219,40,21);
//                 _lbl5.alpha=0;
//                 _btnpayment.alpha=0;
            }
    
    else
    {
        double refcredit = [[[arritem objectAtIndex:0]valueForKey:@"refercredit"]doubleValue];
        if(refcredit  > 0)
        {
            viewcredit.alpha=1;
         //   viewcredit.frame=CGRectMake(10, 192, 304, 25);
            viewstatus.frame=CGRectMake(0, 210, self.view.frame.size.width,42);
            lblcredit.text=[NSString stringWithFormat:@"Credits Applied %.2f",refcredit];
            viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 320);
            _btncancel.frame=CGRectMake(0, 280,self.view.frame.size.width, 40);
            
        }
        else
        {
            viewcredit.alpha=0;
            viewstatus.frame=CGRectMake(0, 190, self.view.frame.size.width,42);
            lblcredit.text=[NSString stringWithFormat:@"%.2f",refcredit];
            viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 280);
            _btncancel.frame=CGRectMake(0, 240,self.view.frame.size.width, 40);
            
        }
        
    }
    
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimagetap:)];
            singleTap.numberOfTapsRequired = 1;
    
            [_imgprofile setUserInteractionEnabled:YES];
    
            [_imgprofile addGestureRecognizer:singleTap];
    
            [ _btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
    
    
            NSString *currenstatus=[[arritem objectAtIndex:0]valueForKey:@"currentstatus"];
    
            if([currenstatus isEqualToString:@"PickUp"] )
            {
              [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btncancel.userInteractionEnabled=NO;
                [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
    
            }
            if([currenstatus isEqualToString:@"Transporting"])
            {
                [ _btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [ _btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                 _btncancel.userInteractionEnabled=NO;
               [ _btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
            }
    
            if([currenstatus isEqualToString:@"DeliverItems"])
            {
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                 _btncancel.userInteractionEnabled=NO;
                [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
            }
    
            if([currenstatus isEqualToString:@"PaymentRequest"])
            {
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                 _btncancel.userInteractionEnabled=NO;
                [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
            }
            if([currenstatus isEqualToString:@"Approved"] )
            {
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [ _btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                 _btncancel.userInteractionEnabled=NO;
                 [_btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
            }
            if([currenstatus isEqualToString:@"Completed"])
            {
                viewdetail.frame=CGRectMake(0, 70, self.view.frame.size.width, 260);
                [_btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                [_btncompleted setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
                _btncancel.userInteractionEnabled=NO;
                //[rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
                 _btncancel.hidden=YES;
            }
    
    viewdetail.hidden=NO;
}

//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    
//    UITableViewCell *cell;
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if(arritem.count > 0)
//    {
//        itemcell *rcell = (itemcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        
//        if (rcell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"itemcell" owner:self options:nil];
//            rcell = [nib objectAtIndex:0];
//        }
//        rcell.lbltripname.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"category"];
//        rcell.lblsenderid.text=[NSString stringWithFormat:@"R%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
//        rcell.fromcity.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"fromcity"];
//        rcell.tocity.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"tocity"];
//        rcell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
//        rcell.lblweight.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"weight"];
//        rcell.lbldate.text= [[arritem objectAtIndex:[indexPath row]]valueForKey:@"fromdate"];
//        rcell.lbltodate.text=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"todate"];
//        rcell.lbltripcost.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"amount"]];
//        
//        
//        NSString *ptype=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
//        if(![ptype isEqualToString:@"Yes"])
//        {
//        NSString *pricelen= [NSString stringWithFormat:@"%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"amount"]];
//        if([pricelen length] > 2)
//        {
//            rcell.lblcurrecy.frame=CGRectMake(214, 14, 10, 21);
//            rcell.lbltripcost.frame=CGRectMake(218, -4, 94, 77);
//        }
//        else if([pricelen length] == 2)
//        {
//             rcell.lblcurrecy.frame=CGRectMake(243, 14, 10, 21);
//             rcell.lbltripcost.frame=CGRectMake(250, -4, 62, 77);
//        }
//        else
//        {
//             rcell.lblcurrecy.frame=CGRectMake(277, 11, 10, 21);
//             rcell.lbltripcost.frame=CGRectMake(284, -4, 30, 77);
//        }
//            rcell.lblpayment.text=@"Commercial";
//        }
//        else
//        {
//            rcell.lblpayment.text=@"Mutual";
//            rcell.lblcurrecy.frame=CGRectMake(277, 11, 10, 21);
//            rcell.lbltripcost.frame=CGRectMake(284, -4, 30, 77);
//        }
//        rcell.lblotp.text=[NSString stringWithFormat:@"%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"delivery_otp"]];
//        
//        rcell.lblitemid.text=[NSString stringWithFormat:@"I%@%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"itemid"],delegate.struserid];
//        
//        rcell.imgprofile.layer.cornerRadius= rcell.imgprofile.frame.size.width/2;
//        rcell.imgprofile.clipsToBounds=YES;
//        
//        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arritem objectAtIndex:[indexPath row]]valueForKey:@"profilepic"]];
//        
//        [rcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        
//        int userid=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"userid"];
//        
//        rcell.imgprofile.tag=userid;
//        rcell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
//        rcell.imgprofile.layer.borderWidth = 2.0;
//        
//        
//        NSString *commercial =[[arritem objectAtIndex:[indexPath row]]valueForKey:@"commercial"];
//        NSString *mutual =[[arritem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
//        if(![commercial isEqualToString:@"Yes"])
//        {
//            rcell.btnpickup.frame=CGRectMake(110,206,15,15);
//            rcell.btntransporting.frame=CGRectMake(195,206,15,15);
//            rcell.btndeliver.frame=CGRectMake(281,206,15,15);
//            
//            rcell.lbl2.frame=CGRectMake(106,220,24,18);
//            rcell.lbl3.frame=CGRectMake(180,218,44,21);
//            rcell.lbl4.frame=CGRectMake(273,219,40,21);
//            rcell.lbl5.alpha=0;
//            rcell.btnpayment.alpha=0;
//        }
//        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimagetap:)];
//        singleTap.numberOfTapsRequired = 1;
//        
//        [rcell.imgprofile setUserInteractionEnabled:YES];
//        
//        [rcell.imgprofile addGestureRecognizer:singleTap];
//        
//        [rcell.btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
//
//        
//        NSString *currenstatus=[[arritem objectAtIndex:[indexPath row]]valueForKey:@"currentstatus"];
//        
//        if([currenstatus isEqualToString:@"PickUp"] )
//        {
//          [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//           rcell.btncancel.userInteractionEnabled=NO;
//            [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            
//        }
//        if([currenstatus isEqualToString:@"Transporting"])
//        {
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncancel.userInteractionEnabled=NO;
//           [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            
//            
//        }
//        
//        if([currenstatus isEqualToString:@"DeliverItems"])
//        {
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncancel.userInteractionEnabled=NO;
//            [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//        }
//        
//        if([currenstatus isEqualToString:@"PaymentRequest"])
//        {
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncancel.userInteractionEnabled=NO;
//            [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//        }
//        if([currenstatus isEqualToString:@"Approved"] )
//        {
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncancel.userInteractionEnabled=NO;
//             [rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//        }
//        if([currenstatus isEqualToString:@"Completed"])
//        {
//            [rcell.btntransporting setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpickup setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btndeliver setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnpayment setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btnapproved setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            [rcell.btncompleted setImage:[UIImage imageNamed:@"orangecircle"] forState:UIControlStateNormal];
//            rcell.btncancel.userInteractionEnabled=NO;
//            //[rcell.btncancel setBackgroundColor:[UIColor colorWithRed:182/255.0f green:182/255.0f blue:189/255.0f alpha:1.0]];
//            rcell.btncancel.hidden=YES;
//        }
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
    btindex=btnTemp.tag;
    
    itemid=[[arritem objectAtIndex:0]valueForKey:@"itemid"];
    itemuserid=[[arritem objectAtIndex:0]valueForKey:@"touserid"];
    tripid=[[arritem objectAtIndex:0]valueForKey:@"tripid"];
    status=@"Cancelled";
    
    [self showalert:status];
}

-(void)showalert:(NSString *)_status
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundViewColor=[UIColor whiteColor];
    [alert addButton:@"OK" target:self selector:@selector(btnclick)];
    
    [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[NSString stringWithFormat:@"Are you sure you want to update status to %@",status] closeButtonTitle:@"Cancel" duration:0.0f];
}
-(void)btnclick
{
    [self updateitemstatus:status _itemid:itemid];
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
- (void)profileimagetap:(UIImageView *)sender
{
//    
//    UIImageView *gesture = (UIImageView *) sender;
//    
//    NSString *userid=[NSString stringWithFormat:@"%@", gesture.tag];
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

-(void)viewDidDisappear:(BOOL)animated
{
    status=@"";
   // itemid=@"";
    itemuserid=@"";
    btindex=0;
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
