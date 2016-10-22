//
//  tripdetailvc.m
//  airlogic
//
//  Created by APPLE on 11/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "tripdetailvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "categorycell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "sendrequestvc.h"
#import "SCLAlertView.h"
#import "DbHandler.h"
#import "myitemvc.h"
#import "locationvc.h"
#import "viewprofile.h"
#import "profilevc.h"
#import "cmspagevc.h"


@interface tripdetailvc ()

@end
int cathght=65;
@implementation tripdetailvc
@synthesize strcommercial,strmutual,tripid,pagefrom,requestid,itemid,isexpired,touserid;
- (void)viewDidLoad {
    [super viewDidLoad];
       self.title=@"Trip Detail";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.isviatrip=@"";
    delegate.viatripid=@"";
    delegate.viatuserid=@"";
    responseData = [NSMutableData data];
    imgview.layer.cornerRadius= imgview.frame.size.width/2;
    imgview.clipsToBounds=YES;
    txtdesc.userInteractionEnabled=NO;
    viewdetail.alpha=0;
    viewservice.alpha=0;
    viewweight.alpha=0;
    viewpolicy.alpha=0;
    lblw.alpha=0;
    lblcarryitem.alpha=0;
    lblservice.alpha=0;
    btnaccept.alpha=0;
    btndecline.alpha=0;
    lblpolicy.alpha=0;
    btnpolicy.alpha=0;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Trip Detail Screen";
    [super viewDidAppear:animated];
}
-(void)setupview
{
    viewdetail.alpha=1;
    viewservice.alpha=1;
    viewweight.alpha=1;
    lblw.alpha=1;
    lblpolicy.alpha=1;
    viewpolicy.alpha=1;
    lblcarryitem.alpha=1;
    lblservice.alpha=1;
    btndecline.alpha=0;
    btnaccept.alpha=0;
    btnpolicy.alpha=1;
    [self GetTripData];
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [viewpolicy addGestureRecognizer:singleFingerTap];
    
    strcommercial= [userdata valueForKey:@"commercial"];
    strmutual= [userdata valueForKey:@"mutually_agreed"];
    
    if([strcommercial isEqualToString:@"Yes"])
    {
        [btncommercial setBackgroundImage:[UIImage imageNamed:@"commercial"] forState:UIControlStateNormal];
        lblsubcommercial.text=[userdata valueForKey:@"subcommercial"];
        
    }
    
    if([strmutual isEqualToString:@"Yes"])
    {
        [btnmutual setBackgroundImage:[UIImage imageNamed:@"mutually"] forState:UIControlStateNormal];
    }
    
    NSString *thumbprofilepic= [userdata valueForKey:@"thumbprofilepic"];
    if(thumbprofilepic.length != 0  ||  ![thumbprofilepic isEqual: [NSNull null]])
    {
        NSString *img =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",thumbprofilepic];
        
        [imgview setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimgclick)];
    singleTap.numberOfTapsRequired = 1;
    [imgview setUserInteractionEnabled:YES];
    [imgview addGestureRecognizer:singleTap];
    imgview.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgview.layer.borderWidth = 2.0;
    
    
    tblcategory.frame= CGRectMake(0, 527, self.view.frame.size.width,cathght);
    btnsubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnsubmit setBackgroundImage:[UIImage imageNamed:@"btnorange"] forState:UIControlStateNormal];
    [btnsubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([tripuser isEqualToString:delegate.username])
    {
    [btnsubmit setTitle:@"Cancel This Trip" forState:UIControlStateNormal];
    iscancel=YES;
    }
    else
    {
    [btnsubmit setTitle:@"Choose This Trip" forState:UIControlStateNormal];
    iscancel=NO;
    }

    btnsubmit.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    [btnsubmit addTarget:self action:@selector(onbtnchoosetripclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float X_Co = (self.view.frame.size.width - 218)/2;
    [btnsubmit setFrame:CGRectMake(X_Co,tblcategory.frame.origin.y+cathght+10, 218, 34)];
    
    btnaccept = [UIButton buttonWithType:UIButtonTypeCustom];
    btnaccept.backgroundColor=[UIColor blackColor];
    [btnaccept setBackgroundImage:[UIImage imageNamed:@"btnsmall_orange"] forState:UIControlStateNormal];
    [btnaccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnaccept setTitle:@"Accept" forState:UIControlStateNormal];
    btnaccept.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    //[btnaccept setFrame:CGRectMake(40, tblcategory.frame.origin.y+cathght+10, 142,36)];
    [btnaccept setFrame:CGRectMake((self.view.frame.size.width - 300)/2, tblcategory.frame.origin.y+cathght+10, 142,36)];
    [btnaccept addTarget:self action:@selector(onbtnacceptclick:) forControlEvents:UIControlEventTouchUpInside];
    
    btndecline = [UIButton buttonWithType:UIButtonTypeCustom];
    [btndecline setBackgroundImage:[UIImage imageNamed:@"btnsmall_orange"] forState:UIControlStateNormal];
    [btndecline setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btndecline setTitle:@"Decline" forState:UIControlStateNormal];
    btndecline.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
   // [btndecline setFrame:CGRectMake((self.view.frame.size.width - 110)/2, tblcategory.frame.origin.y+cathght+10, 142,36)];
     [btndecline addTarget:self action:@selector(onbtndelcineclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btndecline setFrame:CGRectMake(btnaccept.frame.origin.x+btnaccept.frame.size.width+5, tblcategory.frame.origin.y+cathght+10, 142,36)];
    
    [profileview addSubview:tblcategory];
    [profileview addSubview:btnsubmit];
    [profileview addSubview:btnaccept];
    [profileview addSubview:btndecline];
    
    if([pagefrom isEqualToString:@"mt"])
    {
        btnaccept.alpha=1;
        btndecline.alpha=1;
        btnsubmit.alpha=0;
        return;
    }
    else if([pagefrom isEqualToString:@"SR"])
    {
        btnaccept.alpha=0;
        btndecline.alpha=0;
        btnsubmit.alpha=0;
        return;
    }

    else
    {
        btnaccept.alpha=0;
        btndecline.alpha=0;
        
        if([isexpired isEqualToString:@"Y"])
        {
            btnsubmit.alpha=0;
        }
        else
        {
        btnsubmit.alpha=1;
        }
    }
   
}

-(void)profileimgclick
{
    NSLog(@"single Tap on imageview");
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if(![delegate.struserid isEqualToString:[userdata valueForKey:@"userid"]])
    {
        viewprofile *profile= [[viewprofile alloc]initWithNibName:@"viewprofile" bundle:nil];
        profile.userid=[userdata valueForKey:@"userid"];
        [self.navigationController pushViewController:profile animated:NO];
    }
    else
    {
        profilevc *profile= [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
        [self.navigationController pushViewController:profile animated:NO];
    }
    
}

-(void)GetTripData
{
    touserid=[userdata valueForKey:@"userid"];
    tripuser=[NSString stringWithFormat:@"%@ %@",[userdata valueForKey:@"firstname"],[userdata valueForKey:@"lastname"]];
    vid=[userdata valueForKey:@"volumeid"];
    vprice=[userdata valueForKey:@"itemprice"];
    lbrating.text=[NSString stringWithFormat:@"%@ Star",[userdata valueForKey:@"rating"]];
    NSString *str=[userdata valueForKey:@"rating"];
    if([str isEqualToString:@"0"])
    {
        imgstar.image=[UIImage imageNamed:@"emptystar.png"];
    }
    
    lblfrom.text=[NSString stringWithFormat:@"%@, %@" ,[userdata valueForKey:@"fromcity"],[userdata valueForKey:@"zipcode"]];
    lbltime.text=[userdata valueForKey:@"triptime"];
    lblid.text=[NSString stringWithFormat:@"T%@%@",tripid,[userdata valueForKey:@"userid"]];
    lblto.text=[NSString stringWithFormat:@"%@, %@",[userdata valueForKey:@"tocity"],[userdata valueForKey:@"tozipcode"]];
    lbltripname.text=[userdata valueForKey:@"tripname"];
    lblvolume.text=[NSString stringWithFormat:@"%@inch",[userdata valueForKey:@"volume"]];
    lblweight.text=[userdata valueForKey:@"weight"];
    lblflightname.text=[userdata valueForKey:@"tripname"];
    tripdate=[userdata valueForKey:@"tdate"];
    fromairport=[userdata valueForKey:@"fromcityid"];
    toairport=[userdata valueForKey:@"tocityid"];
    lblvolweight.text= [NSString stringWithFormat:@"%@inch %@",[userdata valueForKey:@"volume"],[userdata valueForKey:@"weight"]];
    txtdesc.text= [userdata valueForKey:@"tripdescription"];
    NSString *cancelpolicy=[DbHandler GetId:[NSString stringWithFormat:@"select type from cancellation where id='%@'",[userdata valueForKey:@"cancellationpolicy"]]];
     NSString *desc=[DbHandler GetId:[NSString stringWithFormat:@"select description from cancellation where id='%@'",[userdata valueForKey:@"cancellationpolicy"]]];
    lblcancellationpolicy.text=cancelpolicy;
    lbcdesc.text=desc;
    NSString *tripdt =[userdata valueForKey:@"tripdate"];
    NSArray *dates = [tripdt componentsSeparatedByString:@"/"];
    
   lbldate.text=[dates objectAtIndex:0];
   lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];

}

-(void)viewWillAppear:(BOOL)animated
{
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    NSString *strurl= [AppDelegate baseurl];
    
               strurl= [strurl stringByAppendingString:@"getsingletrip?tripid="];
               strurl=[strurl stringByAppendingString:tripid];
               strurl=[strurl stringByAppendingString:@"&userid="];
               strurl=[strurl stringByAppendingString:delegate.struserid];
    
    
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:120];
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        tripconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory = [[UITableView alloc]init];
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.dataSource=self;
    tblcategory.delegate=self;
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory.separatorColor=[UIColor grayColor];
    tblcategory.frame = self.view.bounds;
    arrcategory = [[NSMutableArray alloc]init];
    userdata = [[NSMutableDictionary alloc]init];
    
    tblcategory.frame= CGRectMake(0, 527, self.view.frame.size.width,cathght);
    [profileview addSubview:tblcategory];
    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+110);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+110);
    [scrlview addSubview:profileview];
    
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
    if(connection == tripconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
             userdata = [[deserializedData objectForKey:@"data"]objectAtIndex:0];
             NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"gettripcategory?tripid="];
            strurl=[strurl stringByAppendingString:tripid];
            strurl= [strurl stringByAppendingString:@"&trip=0"];
            
            NSURL *url = [NSURL URLWithString:strurl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:120];
            if([delegate isConnectedToNetwork])
            {
                catconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                SCLAlertView *network = [[SCLAlertView alloc] init];
                network.backgroundViewColor=[UIColor whiteColor];
                [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
                return;
            }

      }
        else
        {
            [self removeProgressIndicator];
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
    if(connection == catconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            arrcategory=[deserializedData objectForKey:@"data"];
            int x =[arrcategory count];
            cathght= x*65;
        }
        else
        {
            
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        if([arrcategory count] > 0)
        {
            [self removeProgressIndicator];
            [self setupview];
            [tblcategory reloadData];
        }
    }
    if(connection == statusconn)
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
            transition.type = kCATransitionFromLeft;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromLeft;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            [self removeProgressIndicator];
            
        }
    }
    if(connection == requestconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            myitemvc *item= [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:item animated:NO];
            
        }
        else
        {
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
    if(connection == chooseconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        arritem =[[NSMutableArray alloc]init];
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            arritem=[deserializedData objectForKey:@"data"];
            if(arritem.count >0)
            {
                
                sendrequestvc *request = [[sendrequestvc alloc]initWithNibName:@"sendrequestvc" bundle:nil];
                request.itemid =[[arritem objectAtIndex:0]valueForKey:@"id"]; 
                request.strtripid=tripid;
                request.touserid=touserid;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromRight;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromRight;
                transition.delegate = self;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:request animated:NO];
            }
            else
            {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.backgroundViewColor=[UIColor whiteColor];
                [alert addButton:@"Create Now" target:self selector:@selector(btnokclick)];
                [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:@"Please log the request for this trip." closeButtonTitle:@"OK" duration:0.0f];
            }
        }
        else
        {
            [self removeProgressIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert addButton:@"Create Now" target:self selector:@selector(btnokclick)];
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:@"Please log the request for this trip." closeButtonTitle:@"OK" duration:0.0f];
        }
    }
    
    if(connection == verifyconn)
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
            
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                locationvc *location = [[locationvc alloc]initWithNibName:@"locationvc" bundle:nil];
                location.fromcityid=fromcityid;
                delegate.isviatrip=@"Y";
                delegate.viatripid=tripid;
                delegate.viatuserid=touserid;
                location.tocityid=tocityid;
                location.vol=lblvolweight.text;
                location.tozip=[userdata valueForKey:@"tozipcode"];
                location.fromzip=[userdata valueForKey:@"zipcode"];
                if([strcommercial isEqualToString:@"Yes"])
                {
                    location.paymenttype=@"C";
                }
                
                if([strmutual isEqualToString:@"Yes"])
                {
                    location.paymenttype=@"M";
                }
                location.itemcategory=cat;
                location._volid=vid;
                location._catid=catid;
                location.itemcategory=cat;
                location.volprice=vprice;
                location.tripdt=tripdate;
                [self.navigationController pushViewController:location animated:NO];
            }
        }
        else
        {
            [self removeProgressIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                //  [alert addButton:@"Do Now" target:self selector:@selector(verifyclick)];
                
                [alert addButton:@"Do Now" target:self selector:@selector(verifyclick)];
                
                [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"Later" duration:0.0f];
            }
        }
    }
}

-(void)verifyclick
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    profilevc *profile = [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
    [self.navigationController pushViewController:profile animated:NO];
    
}

-(IBAction)onbtninfoclick:(id)sender
{
    cmspagevc *cms = [[cmspagevc alloc]initWithNibName:@"cmspagevc" bundle:nil];
    cms.pagetype=@"Cancellation Policy";
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:cms animated:NO];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    cmspagevc *cms = [[cmspagevc alloc]initWithNibName:@"cmspagevc" bundle:nil];
    cms.pagetype=@"Cancellation Policy";
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:cms animated:NO];
}


-(void)btnokclick
{
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"checkuserverification"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        [postdata setObject:@"1" forKey:@"type"];
    }
    else
    {
        [postdata setObject:@"0" forKey:@"type"];
    }
    
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        
        verifyconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
        return;
    }

}
-(IBAction)onbtnchoosetripclick:(id)sender
{
    if(!iscancel)
    {
    if([tripuser isEqualToString:delegate.username])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        NSString *message=@"";
         message=@"You Cannot Choose Trip Created By You.";
        
        [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:message closeButtonTitle:@"OK" duration:0.0f];
        
    }
    else
    {
         fromcityid= [DbHandler GetId:[NSString stringWithFormat:@"select city_id from airportmaster where airport_id='%@'",fromairport]];
          tocityid= [DbHandler GetId:[NSString stringWithFormat:@"select city_id from airportmaster where airport_id='%@'",toairport]];
        
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"checkitemrequest"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:fromcityid forKey:@"fromcityid"];
        [postdata setObject:tocityid forKey:@"tocityid"];
        [postdata setObject:tripdate forKey:@"tripdate"];
        
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            chooseconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
    }
    else
    {
     
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"updatetripstatus"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:tripid forKey:@"tripid"];
        [postdata setObject:@"Cancelled" forKey:@"status"];
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            statusconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
}

-(IBAction)onbtnacceptclick:(id)sender
{
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"updaterequeststatus"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:requestid forKey:@"requestid"];
        [postdata setObject:tripid forKey:@"tripid"];
        [postdata setObject:@"Accepted" forKey:@"status"];
        [postdata setObject:itemid forKey:@"itemid"];
        [postdata setObject:touserid forKey:@"touserid"];
        [postdata setObject:@"1" forKey:@"utype"];
    
        isaccept=YES;
    
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            requestconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
   
}
-(IBAction)onbtndelcineclick:(id)sender
{
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"updaterequeststatus"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:requestid forKey:@"requestid"];
    [postdata setObject:tripid forKey:@"tripid"];
    [postdata setObject:itemid forKey:@"itemid"];
    [postdata setObject:@"Declined" forKey:@"status"];
    [postdata setObject:touserid forKey:@"touserid"];
    [postdata setObject:@"1" forKey:@"utype"];
    
    isaccept=NO;
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        requestconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
        return;
    }

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrcategory count ];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    categorycell *cell = (categorycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categorycell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
       
    }
    cell.lbldesc.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"description"]];
    cell.lblcat.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"]];
    cat=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"];
    catid=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"id"];
    NSString *catimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"icon"]];
    NSString *rndstring = [AppDelegate randomStringWithLength:5];
    catimg= [catimg stringByAppendingString:@"?str="];
    catimg= [catimg stringByAppendingString:rndstring];
    NSURL *Imgurl=[NSURL URLWithString:catimg];
    [cell.imgcat  sd_setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"]];
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
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
