//
//  homeViewController.m
//  airlogic
//
//  Created by APPLE on 11/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "homeViewController.h"
#import "SWRevealViewController.h"
#import "filterVC.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "homeviewcell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "tripdetailvc.h"
#import "DbHandler.h"
#import "flybeehomeviewcellTableViewCell.h"
#import "locationvc.h"
#import "servicevc.h"
#import "SCLAlertView.h"
#import "itemdetailview.h"
#import "emptycell.h"
#import "createtripvc.h"
#import "profilevc.h"
#import "smsverificationvc.h"
#import "uploadgovtidvc.h"
#import "homeemptycell.h"
#import "rateuser.h"
#import "UIViewController+MJPopupViewController.h"


#define LAZY_LOAD_PAGE_SIZE 5


@interface homeViewController ()

@end

@implementation homeViewController
@synthesize fbemail,fbfname,fblname,arrdata,logintype,fbid,fbpicture;
int currentpageindex=1;
NSString *iletters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Dashboard";
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arrdata=[[NSMutableArray alloc]init];
    tblview.tableFooterView= [[UIView alloc]init];
    tblview.backgroundColor=[UIColor clearColor];
    tblview.hidden=YES;
       // Do any additional setup after loading the view from its nib.
}

- (void)revealController:(SWRevealViewController *)revealController
      willMoveToPosition:(FrontViewPosition)position {
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController
       didMoveToPosition:(FrontViewPosition)position {
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Dashboard Screen";
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if([delegate isConnectedToNetwork])
    {
        [viewnetwork removeFromSuperview];
    }
    else
    {
        viewnetwork.frame=CGRectMake(0,self.view.frame.size.height/3 , self.view.frame.size.width, viewnetwork.frame.size.height);
        [self.view addSubview:viewnetwork];
    }

    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    
    UIImage *filterimg = [UIImage imageNamed:@"icon_filter.png"];
    
    UIButton *filterbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [filterbtn setBackgroundImage:filterimg forState:UIControlStateNormal];
    
    filterbtn.frame = CGRectMake(0.0,0.0,15,15);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:filterbtn];
    
    [filterbtn addTarget:self action:@selector(filterclick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem2];
    
    tblview.backgroundColor=[UIColor clearColor];
    tblview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   

    self.lazyTableView.delegate=self;
    self.lazyTableView.dataSource=self;
    self.lazyTableView.lazyLoadEnabled=YES;
    self.lazyTableView.lazyLoadPageSize=LAZY_LOAD_PAGE_SIZE;
    self.lazyTableView.backgroundColor= [UIColor clearColor];
    self.lazyTableView.hidden=YES;
    
    UIButton *btnitem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnitem setBackgroundImage:[UIImage imageNamed:@"largeplus"] forState:UIControlStateNormal];
    [btnitem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnitem addTarget:self action:@selector(onbtnadditemclick:) forControlEvents:UIControlEventTouchUpInside];
    [btnitem setFrame:CGRectMake(self.view.frame.size.width-75, self.view.frame.size.height-80, 60, 60)];
    [self.view addSubview:btnitem];

    
    if([delegate.logintype isEqualToString:@"FB"])
    {
        [self postdata];
    }
    else
    {
        NSString *strurl= [AppDelegate baseurl];
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            //for sender
         strurl= [strurl stringByAppendingString:@"getalltrips"];
        }
        else
        {
            //for flybee
             strurl= [strurl stringByAppendingString:@"getallitems"];
        }
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:[NSString stringWithFormat:@"%d",currentpageindex] forKey:@"page"];
    [postdata setObject:[NSString stringWithFormat:@"%d",LAZY_LOAD_PAGE_SIZE] forKey:@"limit"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        
        catconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    }
    
   }

-(IBAction)onbtnadditemclick:(id)sender
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
            [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
   }
-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [iletters characterAtIndex: arc4random_uniform([iletters length])]];
    }
    
    return randomString;
}

-(void)filterclick
{
    filterVC *filter = [[filterVC alloc]initWithNibName:@"filterVC" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:filter animated:NO];
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
            NSArray *arr = [deserializedData objectForKey:@"data"];
            [arrdata addObjectsFromArray:arr];
            
        }
        else
        {
            [self removeProgressIndicator];
        }        
    }
    
    if(connection == newconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removespinner];
            NSArray *arr = [deserializedData objectForKey:@"data"];
            [arrdata addObjectsFromArray:arr];
            
        }
        else
        {
            [self removespinner];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
            [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
        
    }
    if(connection == reviewconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            NSString *rateuserid= [deserializedData objectForKey:@"rateuserid"];
            if(![rateuserid length] > 0)
            {
            
            }
            else
            {
                rateuser *rate = [[rateuser alloc]initWithNibName:@"rateuser" bundle:nil];
                rate.tripid=[deserializedData objectForKey:@"tripid"];
                rate.itemid=[deserializedData objectForKey:@"itemid"];
                rate.torateuserid=rateuserid;
                [self.navigationController pushViewController:rate animated:NO];
            }

        }
        else
        {
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                delegate.isviatrip=@"N";
                locationvc *location = [[locationvc alloc]initWithNibName:@"locationvc" bundle:nil];
                [self.navigationController pushViewController:location animated:NO];
            }
            else
            {
                createtripvc *trip = [[createtripvc alloc]initWithNibName:@"createtripvc" bundle:nil];
                [self.navigationController pushViewController:trip animated:NO];
            }
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
            
            
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"checkreview"];
            
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
                
                reviewconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                SCLAlertView *network = [[SCLAlertView alloc] init];
                network.backgroundViewColor=[UIColor whiteColor];
                [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
                return;
            }
        }
        else
        {
            [self removeProgressIndicator];
            errortype=[deserializedData objectForKey:@"error"];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                [alert addButton:@"Do Now" target:self selector:@selector(verifyclick)];
                [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"Later" duration:0.0f];
            }
            else
            {
                [alert addButton:@"Verify" target:self selector:@selector(verifyclick)];
                [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"Cancel" duration:0.0f];
            }
        }
        
    }

    if(connection == fbconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            NSDictionary *userdata = [deserializedData objectForKey:@"data"];
            NSString *userid =[userdata valueForKey:@"lastid"];
            [DbHandler deleteDatafromtable:@"delete from usermaster"];
            
             NSString *pcode=@"";
            if([delegate.promocode length] > 0)
            {
              pcode=delegate.promocode;
            }
            else
            {
                pcode=[userdata valueForKey:@"promocode"];
            }
            
            
            BOOL flg = [DbHandler Insertuser:@"" city:@"" country:@"" emailid:delegate. fbemail firstname:delegate.fbfname gender:@"" uid:userid lastname:delegate.fblname phone:[userdata valueForKey:@"phone"] profilepic:@"" state:@"" status:@"" thumbprofilepic:[userdata valueForKey:@"thumbprofilepic"] usertype:@"Sender" zip:@"" push:@"1" sound:@"1" promocode:pcode currency:[userdata valueForKey:@"currency"]];
            
            if(flg)
            {
            delegate.struserid=userid;
            delegate.username=[NSString stringWithFormat:@"%@ %@",delegate.fbfname,delegate.fblname];
            delegate.strusertype=@"Sender";
            }
            
            NSString *strurl= [AppDelegate baseurl];
            
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                //for sender
                strurl= [strurl stringByAppendingString:@"getalltrips"];
            }
            else
            {
                //for flybee
                strurl= [strurl stringByAppendingString:@"getallitems"];
            }
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:[NSString stringWithFormat:@"%d",currentpageindex] forKey:@"page"];
            [postdata setObject:[NSString stringWithFormat:@"%d",LAZY_LOAD_PAGE_SIZE] forKey:@"limit"];
            [postdata setObject:delegate.struserid forKey:@"userid"];
            
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {
                [self addProgressIndicator];
                
                catconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                SCLAlertView *network = [[SCLAlertView alloc] init];
                network.backgroundViewColor=[UIColor whiteColor];
                [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
                return;
            }

        }
        else
        {
           [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
       
    }
//    NSLog(@"%@",arrdata);
//    if(arrdata.count > 0)
//    {
        self.lazyTableView.hidden=NO;
        [self.lazyTableView reloadData];
    //}
       [self removeProgressIndicator];
}

-(void)verifyclick
{
   
    if([errortype isEqualToString:@"M"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        smsverificationvc *sms = [[smsverificationvc alloc]initWithNibName:@"smsverificationvc" bundle:nil];
        sms.pagefrom=@"H";
        sms.isfirst=@"Y";
        sms.userid= delegate.struserid;
        [self.navigationController pushViewController:sms animated:NO];
        
    }
    if([errortype isEqualToString:@"U"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        uploadgovtidvc *upload = [[uploadgovtidvc alloc]initWithNibName:@"uploadgovtidvc" bundle:nil];
        upload.pagefrom=@"H";
        [self.navigationController pushViewController:upload animated:NO];
    }
    if([errortype isEqualToString:@"C"])
    {
        currency *cur= [[currency alloc]initWithNibName:@"currency" bundle:nil];
        cur._delegate=self;
        
        [self presentPopupViewController:cur animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];
    }
    if([errortype isEqualToString:@"E"])
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
}

-(void)currency:(id)controller didFinishEnteringItem:(NSString *)item
{
    
}

#pragma mark- LazyLoad Table View

- (void)tableView:(UITableView *)tableView lazyLoadNextCursor:(int)cursor{
    //for instance here you can execute webservice request lo load more data
    
    if([arrdata count] >0)
    {
    currentpageindex++;
    [self addspinner];
    self.lazyTableView.tableFooterView = spinner;
    [self loaddata:currentpageindex];
    [self.lazyTableView reloadData];
    }
}
#pragma mark- Table View
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor= [UIColor clearColor];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
    UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 132)];
    
     whiteview.layer.masksToBounds=false;
    whiteview.layer.cornerRadius=2.0;
    whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
    whiteview.layer.shadowOpacity=0.2;
    
    [cell.contentView addSubview:whiteview];
    [cell.contentView sendSubviewToBack:whiteview];
    }
    else
    {
        UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 117)];
        
        whiteview.layer.masksToBounds=false;
        whiteview.layer.cornerRadius=2.0;
        whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
        whiteview.layer.shadowOpacity=0.2;
        
        [cell.contentView addSubview:whiteview];
        [cell.contentView sendSubviewToBack:whiteview];

    }
    
   }

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(arrdata.count == 0)
    {
        return 1;
    }
    else
    {
        return arrdata.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=80;
    if(arrdata.count>0)
    {
      if([delegate.strusertype isEqualToString:@"Sender"])
      {
        height= 130.0f;
       }
        else
       {
        height= 145.0f;
       }
    }
    return  height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell;
    if(arrdata.count > 0)
    {
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
    homeviewcell *homecell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        if (cell == nil)
       {
        homecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
        homecell = [nib objectAtIndex:0];
        }
    homecell.imgticket.hidden=YES;
    //homecell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
    homecell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
    homecell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
    homecell.tocity.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
    homecell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
    homecell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
        homecell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
        
    homecell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
        NSString *str= [[arrdata objectAtIndex:[indexPath row]]valueForKey:@"rating"];
        if([str isEqualToString:@"0"])
        {
            homecell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
        }
        
    NSString *tripdate =[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
    NSArray *dates = [tripdate componentsSeparatedByString:@"/"];
    
    NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
    homecell.lbldate.text=[dates objectAtIndex:0];
    homecell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
   
    [homecell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    homecell.imgprofile.layer.cornerRadius= homecell.imgprofile.frame.size.width/2;
    homecell.imgprofile.clipsToBounds=YES;
    homecell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
    homecell.imgprofile.layer.borderWidth = 2.0;
        
    cell=homecell;
    }
    
    else
    {
        flybeehomeviewcellTableViewCell *flybeecell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            flybeecell.contentView.backgroundColor = [UIColor whiteColor];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
            flybeecell = [nib objectAtIndex:0];
        }
    
        flybeecell.lblid.text=@"Item Id:";
        flybeecell.lblid.frame=CGRectMake(72, 6, 50, 21);
        flybeecell.lbltripname.frame=CGRectMake(116, 6, 80, 21);
        flybeecell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
        flybeecell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
        flybeecell.tocity.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
        flybeecell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
        flybeecell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
        flybeecell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
        NSString *str= [[arrdata objectAtIndex:[indexPath row]]valueForKey:@"rating"];
        if([str isEqualToString:@"0"])
        {
            flybeecell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
        }
        
        NSString *ptype=[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
        if(![ptype isEqualToString:@"Yes"])
        {
            NSString *pricelen= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            if([pricelen length] > 2)
            {
                flybeecell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                flybeecell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
            }
            else if([pricelen length] == 2)
            {
                flybeecell.lblcur2.frame=CGRectMake(232, 14, 10, 21);
                flybeecell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
            }
            else
            {
                flybeecell.lblcur2.frame=CGRectMake(267, 11, 10, 21);
                flybeecell.lblitemprice.frame=CGRectMake(260, -6, 35, 77);
            }
            flybeecell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            
        }
        else
        {
           
            flybeecell.lblitemprice.text=@"0";
            flybeecell.lblcur2.frame=CGRectMake(252, 11, 10, 21);
            flybeecell.lblitemprice.frame=CGRectMake(260, -6, 35, 77);

        }
       NSString *tripdate =[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
       NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
        flybeecell.lbldate.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"fromdate"]];
        flybeecell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
        [flybeecell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        flybeecell.imgprofile.layer.cornerRadius= flybeecell.imgprofile.frame.size.width/2;
        flybeecell.imgprofile.clipsToBounds=YES;
        flybeecell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
        flybeecell.imgprofile.layer.borderWidth = 2.0;
        
        cell=flybeecell;

    }
    }
    else
    {
        homeemptycell *ecell = (homeemptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (ecell == nil)
        {
            ecell.contentView.backgroundColor = [UIColor whiteColor];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeemptycell" owner:self options:nil];
            ecell = [nib objectAtIndex:0];
        }
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            if(![arrdata count] >0)
            {
             ecell.lblname.text=@"No Trips Found.";
            }
            else
            {
                ecell.lblname.text=@"Loading Trips";
            }
        }
        else
        {
            if(![arrdata count] >0)
            {
                ecell.lblname.text=@"No Items Found.";
            }
            else
            {
                ecell.lblname.text=@"Loading Items";
            }
        }
        cell=ecell;

    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(arrdata.count > 0)
    {
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
    tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
    trip.pagefrom=@"";
    trip.tripid=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:trip animated:NO];
   }
    else
    {
        itemdetailview *item =[[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
        item.pagefrom=@"";
        item.itemid=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"id"];
         [self.navigationController pushViewController:item animated:NO];

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - loaddata
-(void)loaddata:(int)pageno
{
    NSString *strurl= [AppDelegate baseurl];
    
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        //for sender
        strurl= [strurl stringByAppendingString:@"getalltrips"];
    }
    else
    {
        //for flybee
        strurl= [strurl stringByAppendingString:@"getallitems"];
    }
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:[NSString stringWithFormat:@"%d",pageno] forKey:@"page"];
    [postdata setObject:@"5" forKey:@"limit"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
       
        newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
        return;
    }

}

//post data in case of social media login via FB

-(void)postdata
{
    NSString *strurl= [AppDelegate baseurl];
     strurl= [strurl stringByAppendingString:@"signupwithsocialmedia"];
    
    NSString *st =fbpicture;
    st=[st   stringByAppendingString:@"?type=large"];
    NSLog(@"%@" ,st);
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];

   [postdata setObject:delegate.fbfname forKey:@"firstname"];
   [postdata setObject:delegate.fblname forKey:@"lastname"];
   [postdata setObject:delegate.fbemail forKey:@"email"];
   [postdata setObject:delegate.fbid forKey:@"logintoken"];
   [postdata setObject:delegate.fbpicture forKey:@"fbpicture"];
   [postdata setObject:delegate.devicetoken forKey:@"devicetoken"];
    
    
                                          AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
                                          if([delegate isConnectedToNetwork])
                                          {
                                              [self addProgressIndicator];
                                            fbconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];

                                          }
                                          else
                                          {
                                              SCLAlertView *network = [[SCLAlertView alloc] init];
                                              network.backgroundViewColor=[UIColor whiteColor];
                                              [network showCustom:self image:[UIImage imageNamed:@"internet.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
                                              return;
                                          }
    
}

-(void)addspinner
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidden=NO;
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
}
-(void)removespinner
{
    spinner.hidden=YES;
    [spinner stopAnimating];
}

-(void)viewDidDisappear:(BOOL)animated
{
    currentpageindex=1;
    delegate.logintype=@"";
    [arrdata removeAllObjects];
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
