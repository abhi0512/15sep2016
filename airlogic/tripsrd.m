//
//  tripsrd.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "tripsrd.h"
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
#import "requestcell.h"

#import "emptycell.h"
#import "itemdetailview.h"

@interface tripsrd ()

@end
int cathght_1=65;

int segmentinx=0;
int bin=0;
@implementation tripsrd
@synthesize strcommercial,strmutual,tripid,pagefrom,requestid,itemid,isexpired,touserid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Trip Detail";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    responseData = [NSMutableData data];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[ @"Trip Detail",@"Send Request",@"Rec. Request"]];
    //[segmentedControl3 setFrame:CGRectMake(0, 65,self.view.frame.size.width, 45)];
    segmentedControl3.frame=CGRectMake(0, 64, viewWidth,45);
    segmentedControl3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl3 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl3.selectionIndicatorHeight = 2.0f;
    segmentedControl3.backgroundColor = [UIColor orangeColor];
    segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //segmentedControl3.selectionIndicatorColor =[UIColor colorWithRed:247/255.0f green:88/255.0f blue:14/255.0f alpha:1.0];
    segmentedControl3.selectionIndicatorColor =[UIColor whiteColor];
    segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl3.selectedSegmentIndex = 0;
    segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl3.shouldAnimateUserSelection = NO;
    segmentedControl3.tag = 0;
    
    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont  fontWithName:@"Roboto-Bold" size:14], NSFontAttributeName,
                                 [UIColor whiteColor], NSForegroundColorAttributeName, nil];    
    [segmentedControl3 setTitleTextAttributes:attributes2];
    
    [self.view addSubview:segmentedControl3];

    
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
    lblpolicy.alpha=0;
    btnpolicy.alpha=0;
    // Do any additional setup after loading the view from its nib.
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    arrtrip=[[NSMutableArray alloc]init];
    segmentinx= segmentedControl.selectedSegmentIndex;
    if(segmentinx !=0)
    {
        scrlview.alpha=0;
        [profileview removeFromSuperview];
        [tblview removeFromSuperview];
        [self showrequestlist];
        [self FetchData:segmentinx];
    }
    else
    {
        tblview.alpha=0;
        scrlview.alpha=1;
        [self viewWillAppear:NO];
    }
    
}
-(void)FetchData:(int)index
{
    NSString *strurl= [AppDelegate baseurl];
    tblview.alpha=0;
    if(index==1)
    {
        tblcategory.delegate=nil;
        tblcategory.dataSource=nil;
    
        strurl= [strurl stringByAppendingString:@"getmyitemsrequest"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:tripid forKey:@"tripid"];
        
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }

    }
    
    else if(index==2)
    {
        
        tblcategory.delegate=nil;
        tblcategory.dataSource=nil;
        
        strurl= [strurl stringByAppendingString:@"gettriprequest"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:tripid forKey:@"tripid"];
        
        
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
        NSString *img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
        
        [imgview setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimgclick)];
    singleTap.numberOfTapsRequired = 1;
    [imgview setUserInteractionEnabled:YES];
    [imgview addGestureRecognizer:singleTap];
    imgview.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgview.layer.borderWidth = 2.0;
    
    tblcategory.frame= CGRectMake(0, 522, self.view.frame.size.width,cathght_1);
    [profileview addSubview:tblcategory];
    
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
    lblrating.text=[NSString stringWithFormat:@"%@ Star",[userdata valueForKey:@"rating"]];
    
    NSString *str=[userdata valueForKey:@"rating"];
    if([str isEqualToString:@"0"])
    {
        imgstar.image=[UIImage imageNamed:@"emptystar.png"];
    }
    
    lblfrom.text=[NSString stringWithFormat:@"%@, %@",[userdata valueForKey:@"fromcity"],[userdata valueForKey:@"zipcode"]];
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
    segmentedControl3.selectedSegmentIndex = 0;
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    if(segmentinx == 0)
    {
        scrlview.alpha=1;
        
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
    userdata = [[NSMutableDictionary alloc]init];
    
    tblcategory.frame= CGRectMake(0, 522, self.view.frame.size.width,cathght_1);
    [profileview addSubview:tblcategory];
    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+60);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+60);
    [scrlview addSubview:profileview];
    }
    
}
-(void)showrequestlist
{
    tblview = [[UITableView alloc]init];
    tblview.backgroundColor=[UIColor clearColor];
    tblview.dataSource=self;
    tblview.delegate=self;
    tblview.tableFooterView= [[UIView alloc]init];
    tblview.separatorColor=[UIColor grayColor];
    //tblview.frame = self.view.bounds;
    tblview.alpha=0;
    [tblview setContentInset:UIEdgeInsetsMake(0,0,90,0)];
    tblview.frame= CGRectMake(5,segmentedControl3.frame.origin.y+50,self.view.frame.size.width-10,self.view.frame.size.height-segmentedControl3.frame.size.height);
    [self.view addSubview:tblview];
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
    if(connection == newconn)
    {
        arrtrip= [[NSMutableArray alloc]init];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            arrtrip=[deserializedData valueForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
        }
        
        if(segmentinx !=0)
        {
            tblview.alpha=1;
            [tblview reloadData];
            
        }
        
    }
    if(connection == canconn)
    {
        arrtrip= [[NSMutableArray alloc]init];
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
        
        if(segmentinx !=0)
        {
            tblview.alpha=1;
            [tblview reloadData];
            
        }
        
    }
    

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
        arrcategory = [[NSMutableArray alloc]init];
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            arrcategory=[deserializedData objectForKey:@"data"];
            int x =[arrcategory count];
            cathght_1= x*65;
        }
        else
        {
            
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        
        if([arrcategory count] > 0)
        {
            [self removeProgressIndicator];
            [self setupview];
            [tblcategory reloadData];
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



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblcategory)
    {
        return [arrcategory count ];
    }
    else if(tableView == tblview)
    {
        if(arrtrip.count == 0)
        {
            return 1;
        }
        else
        {
            return arrtrip.count;
        }
    }
    return 0;

}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor= [UIColor clearColor];
    UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 170)];
        
        whiteview.layer.masksToBounds=false;
        whiteview.layer.cornerRadius=2.0;
        whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
        whiteview.layer.shadowOpacity=0.2;
        
        [cell.contentView addSubview:whiteview];
        [cell.contentView sendSubviewToBack:whiteview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int x =80.f;
    if(tableView == tblview)
    {
        if(arrtrip.count>0)
        {
            x=140.0f;
        }
    }
    else if(tableView == tblcategory)
    {
        x= 65.0f;
    }
    return x;

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell;
    
    
    if(tableView == tblcategory)
    {
        
        categorycell *catcell = (categorycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (catcell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categorycell" owner:self options:nil];
            catcell = [nib objectAtIndex:0];
            
        }
        catcell.lbldesc.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"description"]];
        catcell.lblcat.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"]];
        cat=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"];
        NSString *catimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"icon"]];
        NSString *rndstring = [AppDelegate randomStringWithLength:5];
        catimg= [catimg stringByAppendingString:@"?str="];
        catimg= [catimg stringByAppendingString:rndstring];
        NSURL *Imgurl=[NSURL URLWithString:catimg];
        [catcell.imgcat  sd_setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"]];
        
        cell=catcell;
    }
    else if (tableView == tblview)
    {
        if(segmentinx==1)
        {
            if(arrtrip.count> 0)
            {
                requestcell *rcell1 = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell1 == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                    rcell1 = [nib objectAtIndex:0];
                }
                rcell1.lblflydate.hidden=YES;
                rcell1.imgaircraft.hidden=YES;
                rcell1.lbl.text=@"Trip Id:";
                rcell1.lblid.text=[NSString stringWithFormat:@"T%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
                rcell1.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"];
                rcell1.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
                rcell1.txtmesage.editable=NO;
                rcell1.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                rcell1.lblstar.text=[NSString stringWithFormat:@"%@ Star",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
                rcell1.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                rcell1.imgprofile.layer.cornerRadius= rcell1.imgprofile.frame.size.width/2;
                rcell1.imgprofile.clipsToBounds=YES;
                rcell1.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                rcell1.imgprofile.layer.borderWidth = 2.0;
                
                NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
                
                NSString *tripdate1 =[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                NSArray *dates = [tripdate1 componentsSeparatedByString:@"/"];
                rcell1.lbldate.text=[dates objectAtIndex:0];
                rcell1.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
                [rcell1.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                NSString *st=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"status"];
                rcell1.lblstatus.text=st;
                if([st isEqualToString:@"Pending"])
                {
                    rcell1.lblstatus.backgroundColor=[UIColor greenColor];
                    rcell1.lblstatus.textColor= [UIColor whiteColor];
                }
                else if([st isEqualToString:@"Declined"])
                {
                    rcell1.lblstatus.backgroundColor=[UIColor redColor];
                    rcell1.lblstatus.textColor= [UIColor whiteColor];
                    
                }
                
                
                rcell1.imgprofile.userInteractionEnabled = YES;
                rcell1.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
                tapped.numberOfTapsRequired = 1;
                [rcell1.imgprofile addGestureRecognizer:tapped];
                
                cell=rcell1;
                rcell1.btncancel.tag=99;
                [rcell1.btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (ecell == nil)
                {
                    ecell.contentView.backgroundColor = [UIColor whiteColor];
                    ecell.userInteractionEnabled=NO;
                    [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
                }
                ecell.lblmsg.text=@"No Items Request Found.";
                cell=ecell;
            }
            

        }
        
        else if(segmentinx==2)
        {
            if(arrtrip.count> 0)
            {
                requestcell *rcell3 = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell3 == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                    rcell3 = [nib objectAtIndex:0];
                }
                
                rcell3.lblflydate.hidden=YES;
                rcell3.imgaircraft.hidden=YES;
                rcell3.lbl.text=@"Trip Id:";
                rcell3.lblid.text=[NSString stringWithFormat:@"T%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
                rcell3.btncancel.hidden=YES;
                rcell3.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"];
                rcell3.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
                rcell3.lblstar.text=[NSString stringWithFormat:@"%@ Star",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
                
                NSString *tripdate =[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                NSArray *dates = [tripdate componentsSeparatedByString:@"/"];
                rcell3.lbldate.text=[dates objectAtIndex:0];
                rcell3.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
                rcell3.txtmesage.editable=NO;
                
                NSString *st=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"status"];
                rcell3.lblstatus.text=st;
                if([st isEqualToString:@"Pending"])
                {
                    rcell3.lblstatus.backgroundColor=[UIColor greenColor];
                    rcell3.lblstatus.textColor= [UIColor whiteColor];
                }
                else if([st isEqualToString:@"Declined"])
                {
                    rcell3.btncancel.hidden=NO;
                    [rcell3.btncancel setTitle:@"Request Rejected" forState:UIControlStateNormal];
                    [rcell3.btncancel setBackgroundColor:[UIColor grayColor]];
                    
                    rcell3.lblstatus.backgroundColor=[UIColor redColor];
                    rcell3.lblstatus.textColor= [UIColor whiteColor];
                    
                }
                
                rcell3.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                rcell3.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                rcell3.imgprofile.layer.cornerRadius= rcell3.imgprofile.frame.size.width/2;
                rcell3.imgprofile.clipsToBounds=YES;
                rcell3.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                rcell3.imgprofile.layer.borderWidth = 2.0;
                
                NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
                
                [rcell3.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                rcell3.imgprofile.userInteractionEnabled = YES;
                rcell3.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
                tapped.numberOfTapsRequired = 1;
                [rcell3.imgprofile addGestureRecognizer:tapped];
                
                cell=rcell3;
            }
            else
            {
                emptycell *ecell3= (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (ecell3 == nil)
                {
                    ecell3.contentView.backgroundColor = [UIColor whiteColor];
                    ecell3.userInteractionEnabled=NO;
                    [ecell3 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell3 = [nib objectAtIndex:0];
                }
                ecell3.lblmsg.text=@"No Trips Request Found.";
                cell=ecell3;
            }

        }
    }
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblview)
    {
        
        if(segmentinx==1)
        {
            if([arrtrip count] > 0)
            {
                NSString *status=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"status"];
                if([status isEqualToString:@"Pending"])
                {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
            
            itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
            item.pagefrom=@"SR";
            item.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
            [self.navigationController pushViewController:item animated:NO];
            }
            }
            
        }
        else if(segmentinx==2)
        {
            if([arrtrip count] > 0)
            {
                NSString *status=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"status"];
                if([status isEqualToString:@"Pending"])
                {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            
            itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
            item.pagefrom=@"mi";
            item.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
            item.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
            item.requestid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"requestid"];
            [self.navigationController pushViewController:item animated:NO];
            }
            }
        }
    }
}

-(void)imgclick :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int index =gesture.view.tag;
     NSLog(@"%@", [arrtrip objectAtIndex:index]);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    viewprofile *profile= [[viewprofile alloc]initWithNibName:@"viewprofile" bundle:nil];
    profile.userid=[[arrtrip objectAtIndex:index]valueForKey:@"requestorid"];
    [self.navigationController pushViewController:profile animated:NO];
    
}

-(void)cancelclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    bin=btnTemp.tag;
    
    
    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
    NSIndexPath *indexPath = [tblview indexPathForCell:cell];
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"updaterequeststatus"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    [postdata setObject:[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"requestid"] forKey:@"requestid"];
    [postdata setObject:[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"]  forKey:@"tripid"];
    [postdata setObject:@"Cancelled" forKey:@"status"];
    [postdata setObject:[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"] forKey:@"itemid"];
    [postdata setObject:[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"userid"] forKey:@"touserid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        canconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
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
-(void)viewDidDisappear:(BOOL)animated
{
    segmentinx=0;
    [tblview removeFromSuperview];
    bin=0;
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
