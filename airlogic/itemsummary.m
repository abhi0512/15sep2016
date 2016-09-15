//
//  itemsummary.m
//  airlogic
//
//  Created by APPLE on 25/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//
#import "itemsummary.h"
#import "DbHandler.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SCLAlertView.h"
#import "myitemvc.h"
#import "sendrequestvc.h"
#import "itempayment.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"




@interface itemsummary ()


@end

@implementation itemsummary
@synthesize serveritemid,transactionid;
double amt=0;
double fee=3;
double safetyfee=1;
double cost=0;
double insurnaceamt=0;
double totalcost=0;
double discountamt=0;
double refercredit=0;
double walletamt=0;

int dis;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Send Items";
    promocode=@"";
    isfirst=@"N";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    lblcredit.text=[NSString stringWithFormat:@"$%.2f",walletamt];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    btnapply.userInteractionEnabled=YES;
    txtpromocode.userInteractionEnabled=YES;
    btnapply.backgroundColor =[UIColor orangeColor];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Item Payment Summary Screen";
    [super viewDidAppear:animated];
}

-(void)showsummary
{
    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width,800);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,750);
    [scrlview addSubview:profileview];
    
    NSMutableArray *arr = [DbHandler Fetchuserdetail:delegate.struserid];
    NSString *thumbprofilepic =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arr objectAtIndex:0]valueForKey:@"thumbprofilepic"]];
    
    NSURL *Imgurl=[NSURL URLWithString:thumbprofilepic];
    if(thumbprofilepic.length != 0 )
    {
        [imgprofile setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
        imgprofile.clipsToBounds=YES;
        
        imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
        imgprofile.layer.borderWidth = 2.0;
    }
    
    
    NSArray *arritem = [DbHandler FetchItemdetail];
    if([arritem count] > 0)
    {
        lblitemname.text=[[arritem objectAtIndex:0]valueForKey:@"itemname"];
        lblvol.text=[[arritem objectAtIndex:0]valueForKey:@"volume"];;
        lblfrom.text=[[arritem objectAtIndex:0]valueForKey:@"fromcity"];
        lblto.text=[[arritem objectAtIndex:0]valueForKey:@"tocity"];
        lbldate.text=[NSString stringWithFormat:@"%@",delegate.itemfromdt];
        lbltodate.text=[NSString stringWithFormat:@"%@",delegate.itemtodt];
        lblzipcode.text=[[arritem objectAtIndex:0]valueForKey:@"zipcode"];
        lbltozipcode.text= [[arritem objectAtIndex:0]valueForKey:@"tozipcode"];
        NSString *commercial =[DbHandler GetId:@"select commercial from createitem"];
        
        if(![commercial isEqualToString:@"Yes"])
            //if([lblins.text isEqualToString:@"0"])
        {
            viewsummary.frame=CGRectMake(0,246,self.view.frame.size.width,200);
            lblt.frame=CGRectMake(self.view.frame.size.width-147, 452, 75, 30);
            lbltotalfee.frame=CGRectMake(self.view.frame.size.width-74, 452, 64, 30);
            lblmsg.frame=CGRectMake(34, 488, self.view.frame.size.width-53, 40);
            imgicon.frame=CGRectMake(8, 490, 25, 25);
            float X_Co = (self.view.frame.size.width - 218)/2;
            [btnnext setFrame:CGRectMake(X_Co, 625, 218, 34)];
            [btncancel setFrame:CGRectMake(X_Co, 665, 218, 34)];
            //btncancel.frame=CGRectMake(self.view.frame.size.width-51, 585, 218, 34);
            lblpaymenttype.text=@"Mutually";
            imgicon.hidden=YES;
            viewpromo.hidden=YES;
            lblmsg.hidden=YES;
            lbldis.hidden=YES;
            lblddesc.hidden=YES;
            lbldiscount.hidden=YES;
            lblcredit.text=@"$ 0.00";
    
            lbltotalfee.text=[NSString stringWithFormat:@"$ 0.00"];
            lblcost.text=[NSString stringWithFormat:@"$ 0.00"];
            lblins.text=[NSString stringWithFormat:@"$ 0.00"];
            lblsafetyfee.text= [NSString stringWithFormat:@"$ 0.00"];
            lblappfee.text=[NSString stringWithFormat:@"$ 0.00"];
            [btnnext setTitle:@"Create Item" forState:UIControlStateNormal];
            [btnnext addTarget:self action:@selector(onbtnitemdetailclick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
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

            
            viewsummary.frame=CGRectMake(0,246,self.view.frame.size.width,200);
            lblt.frame=CGRectMake(self.view.frame.size.width-147, 452, 75, 30);
            lbltotalfee.frame=CGRectMake(self.view.frame.size.width-74, 452, 64, 30);
            lblmsg.frame=CGRectMake(34, 488, self.view.frame.size.width-53, 40);
            imgicon.frame=CGRectMake(8, 490, 25, 25);
            viewpromo.frame=CGRectMake(0, 530, self.view.frame.size.width, 55);
            float X_Co = (self.view.frame.size.width - 218)/2;
            [btnnext setFrame:CGRectMake(X_Co, 625, 218, 34)];
            [btncancel setFrame:CGRectMake(X_Co, 665, 218, 34)];
            lbldis.hidden=YES;
            lblddesc.hidden=YES;
            lbldiscount.hidden=YES;
            lblpaymenttype.text=@"Commercial";
            lblmsg.hidden=NO;
            viewpromo.hidden=NO;
            cost = [delegate.volprice  doubleValue];
            insurnaceamt =[[DbHandler GetId:@"select insurance from createitem"]doubleValue];
            
            if([isfirst isEqualToString:@"Y"])
            {
                safetyfee=0;
                fee=0;
                lblsafetyfee.text= [NSString stringWithFormat:@"$ 0.00"];
                lblappfee.text=[NSString stringWithFormat:@"$ 0.00"];
                totalcost = (cost+insurnaceamt)-(fee+safetyfee+walletamt);
                
            }
            else
            {
                
                safetyfee=1;
                fee=3;
                lblsafetyfee.text= [NSString stringWithFormat:@"$ %.2f",safetyfee];
                lblappfee.text=[NSString stringWithFormat:@"$ %.2f",fee];
                totalcost = (cost+insurnaceamt+fee+safetyfee)-walletamt;
                
            }
            
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:2];
            [formatter setMinimumFractionDigits:2];
            paypalamt = [formatter stringFromNumber:[NSNumber numberWithFloat:totalcost]];
            
            lbltotalfee.text=[NSString stringWithFormat:@"$ %.2f",totalcost];
            lblcost.text=[NSString stringWithFormat:@"$ %@.00",delegate.volprice];
            lblins.text=[NSString stringWithFormat:@"$ %.2f",insurnaceamt];
            lblvprice.text=delegate.volprice;
            
           
            
            NSString *pricelen= [NSString stringWithFormat:@"%@",delegate.volprice];
            if([pricelen length] > 2)
            {
                lblcurrency.frame=CGRectMake(self.view.frame.size.width-67, 5, 10, 21);
                lblvprice.frame=CGRectMake(self.view.frame.size.width-60,3, 54, 35);
            }
            else if([pricelen length] == 2)
            {
                lblcurrency.frame=CGRectMake(self.view.frame.size.width-51, 6, 10, 21);
                lblvprice.frame=CGRectMake(self.view.frame.size.width-45, 3, 37, 35);
            }
            else
            {
                lblcurrency.frame=CGRectMake(self.view.frame.size.width-32, 6, 10, 21);
                lblvprice.frame=CGRectMake(self.view.frame.size.width-23, 3, 15, 35);
            }
            [btnnext setTitle:@"Proceed to Payment" forState:UIControlStateNormal];
            [btnnext addTarget:self action:@selector(onbtnnextclick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
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
    
    
  
}

-(IBAction)onbtnnextclick:(id)sender
{
    ispaypal=@"Y";
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    itempayment *item = [[itempayment alloc]initWithNibName:@"itempayment" bundle:nil];
    item.paypalamt=paypalamt;
    item.disrate= [NSString stringWithFormat:@"%d", dis];
    item.disamt =[NSString stringWithFormat:@"%.2f", discountamt];
    item.totalamt=[NSString stringWithFormat:@"%.2f",totalcost];
    item.refercredit=[NSString stringWithFormat:@"%.2f",walletamt];
    item.appfee=[NSString stringWithFormat:@"%.2f",fee];
    item.safetyfee=[NSString stringWithFormat:@"%.2f",safetyfee];
    item.itemamt=[NSString stringWithFormat:@"%.2f",cost];
    item.insamt=[NSString stringWithFormat:@"%.2f",insurnaceamt];
    item.point=creditpoint;
    item.promocode=promocode;
    [self.navigationController pushViewController:item animated:NO];
    
    
}
-(IBAction)onbtnapplyclick:(id)sender
{
    if(![txtpromocode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Promo Code" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }


    promocode=txtpromocode.text;
    NSString *strurl= [AppDelegate baseurl];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
   
    strurl= [strurl stringByAppendingString:@"verifypromocode"];
    [postdata setObject:txtpromocode.text forKey:@"promocode"];
    
      AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        promoconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
             if(![ispaypal isEqualToString:@"Y"])
            {
            [DbHandler deleteDatafromtable:@"delete from createitem"];
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
                    NSString *strurl= [AppDelegate baseurl];
                    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
                    NSString *email = [DbHandler GetId:[NSString stringWithFormat:@"select emailid from usermaster where id='%@'",delegate.struserid]];
                    strurl= [strurl stringByAppendingString:@"payment"];
                    [postdata setObject:email forKey:@"email"];
                    [postdata setObject:delegate.struserid forKey:@"userid"];
                    [postdata setObject:serveritemid forKey:@"itemid"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",totalcost] forKey:@"amount"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",fee] forKey:@"appfee"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",safetyfee] forKey:@"safetyfee"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",cost] forKey:@"itemamt"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",insurnaceamt] forKey:@"insamt"];
                    [postdata setObject:[NSString stringWithFormat:@"%.2f",discountamt] forKey:@"disamt"];
                    [postdata setObject:[NSString stringWithFormat:@"%d",dis] forKey:@"dis"];
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
    if(connection == promoconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            viewsummary.frame=CGRectMake(0,246,self.view.frame.size.width,250);
            
            lbldis.hidden=NO;
            lblddesc.hidden=NO;
            lbldiscount.hidden=NO;
            
                btnapply.userInteractionEnabled=NO;
                btnapply.backgroundColor =[UIColor grayColor];
                dis=[[deserializedData objectForKey:@"discount"]intValue];
                txtpromocode.userInteractionEnabled=NO;
            
            lblt.frame=CGRectMake(self.view.frame.size.width-147, 502, 75, 30);
            lbltotalfee.frame=CGRectMake(self.view.frame.size.width-74, 502, 64, 30);
            imgicon.frame=CGRectMake(8, 540, 25, 25);
            lblmsg.frame=CGRectMake(34, 538, self.view.frame.size.width-53, 40);
            viewpromo.frame=CGRectMake(0, 580, self.view.frame.size.width, 55);
            float X_Co = (self.view.frame.size.width - 218)/2;
            [btnnext setFrame:CGRectMake(X_Co, 660, 218, 34)];
            [btncancel setFrame:CGRectMake(X_Co, 700, 218, 34)];
           
            scrlview.contentSize=CGSizeMake(self.view.frame.size.width,800);
            profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,750);
            [scrlview addSubview:profileview];
            double netamt=0;
            if([isfirst isEqualToString:@"Y"])
            {  netamt=(cost+insurnaceamt)-(refercredit+safetyfee+fee);
               discountamt= (netamt*dis/100);
               totalcost= netamt-discountamt;
            }
            else
            {
                netamt=(cost+insurnaceamt+safetyfee+fee)-walletamt;
                discountamt= (netamt*dis/100);
                totalcost= netamt-discountamt;
            }
           lbldiscount.text=[NSString stringWithFormat:@"-$ %.2f",discountamt];
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:2];
            [formatter setMinimumFractionDigits:2];
            paypalamt = [formatter stringFromNumber:[NSNumber numberWithFloat:totalcost]];
            lbltotalfee.text=[NSString stringWithFormat:@"$ %.2f",totalcost];
            
          
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
        
    }

    if(connection == connpurchase)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"400"])
        {
            [self removeProgressIndicator];
            NSString *cnt = [deserializedData objectForKey:@"cnt"];
            if([cnt isEqualToString:@"0"])
            {
               isfirst=@"Y";
                
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.backgroundViewColor=[UIColor whiteColor];
                [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:@"You got a Free APP Fees and Safety Fee." closeButtonTitle:@"OK" duration:0.0f];
            }
        }
        else
        {
            [self removeProgressIndicator];
        }
        [self showsummary];
    }
    
    if(connection == connpoint)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
             double point = [[deserializedData objectForKey:@"Point"]doubleValue];
            if(point > 0)
            {
                refercredit=0;
                refercredit=(point/2);
                double totalwithoutrefer =(cost+insurnaceamt+fee+safetyfee);
                double allowedamt = (totalwithoutrefer*20/100);
                int pnt=0;
                if(refercredit > allowedamt)
                {
                     totalcost = (cost+insurnaceamt+fee+safetyfee)-allowedamt;
                     lblcredit.text=[NSString stringWithFormat:@"$ %.2f",allowedamt];
                     walletamt=allowedamt;
                     pnt = (allowedamt*2);
                }
                else if (refercredit == allowedamt)
                {
                    totalcost = (cost+insurnaceamt+fee+safetyfee)-allowedamt;
                    lblcredit.text=[NSString stringWithFormat:@"$ %.2f",allowedamt];
                     pnt = (allowedamt*2);
                    walletamt=allowedamt;
                    
                }
                else if (refercredit < allowedamt)
                {
                    totalcost = (cost+insurnaceamt+fee+safetyfee)-refercredit;
                    lblcredit.text=[NSString stringWithFormat:@"$ %.2f",refercredit];
                     pnt = (refercredit*2);
                    walletamt=refercredit;
                }
                creditpoint= [NSString stringWithFormat:@"%d",pnt];
                NSLog(@"%@",creditpoint);
                lbltotalfee.text=[NSString stringWithFormat:@"$ %.2f",totalcost];
              
            }
            else
            {
                walletamt=0;
                refercredit=0;
                lblcredit.text=@"$ 0.00";
                totalcost = (cost+insurnaceamt+fee+safetyfee)-walletamt;
                lbltotalfee.text=[NSString stringWithFormat:@"$ %.2f",totalcost];
                
            }
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:2];
            [formatter setMinimumFractionDigits:2];
            paypalamt = [formatter stringFromNumber:[NSNumber numberWithFloat:totalcost]];
            
        }
        
        else
        {
            [self removeProgressIndicator];
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
-(IBAction)onbtnitemdetailclick:(id)sender
{
    
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
         [postdata setObject:[[arritem objectAtIndex:0]valueForKey:@"itemdesc"] forKey:@"itemdescription"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtpromocode)
    {
        [self animateTextField: textField up: YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtpromocode)
    {
        [self animateTextField: textField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(IBAction)onbtncontinueclick:(id)sender
{
    myitemvc *itemdt = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:itemdt animated:NO];
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
