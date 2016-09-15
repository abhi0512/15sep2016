//
//  itemsrd.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itemsrd.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "categorycell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "sendrequestvc.h"
#import "SCLAlertView.h"
#import "mytriplistvc.h"
#import "UIViewController+MJPopupViewController.h"
#import "infoview.h"
#import "createtripvc.h"
#import "myitemvc.h"
#import "profilevc.h"
#import "viewprofile.h"
#import "emptycell.h"
#import "requestcell.h"
#import "tripdetailvc.h"

@interface itemsrd ()

@end
int chght2=65;
int segmentindx=0;
int binx=0;
@implementation itemsrd
@synthesize strcommercial,strmutual,tripid,pagefrom,requestid,itemid,isexpired,touserid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Item Detail";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Item Detail",@"Send Request",@"Rec. Request"]];
    //[segmentedControl3 setFrame:CGRectMake(0, 65,self.view.frame.size.width, 45)];
    segmentedControl3.frame=CGRectMake(0, 65, viewWidth,45);
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
    

    
    imgview.layer.cornerRadius= imgview.frame.size.width/2;
    imgview.clipsToBounds=YES;
    txtdesc.userInteractionEnabled=NO;
    viewdetail.alpha=0;
    viewservice.alpha=0;
    viewweight.alpha=0;
    lblw.alpha=0;
    lblcarryitem.alpha=0;
    lblservice.alpha=0;
    bntinfo.alpha=0;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    arrtrip=[[NSMutableArray alloc]init];
    segmentindx= segmentedControl.selectedSegmentIndex;
    
    segmentedControl3.selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    if(segmentindx !=0)
    {
        scrlview.alpha=0;
        [profileview removeFromSuperview];
        [tblview removeFromSuperview];
        [self showrequestlist];
        [self FetchData:segmentindx];
    }
    else
    {
        [tblview removeFromSuperview];
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
        
        tblcategory.dataSource=nil;
        tblcategory.delegate=nil;
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            strurl= [strurl stringByAppendingString:@"getmytripsrequest"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:delegate.struserid forKey:@"userid"];
            [postdata setObject:itemid forKey:@"itemid"];
            
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
    
    else if(index==2)
    {
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            tblcategory.dataSource=nil;
            tblcategory.delegate=nil;
            
            strurl= [strurl stringByAppendingString:@"getitemrequest"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:delegate.struserid forKey:@"userid"];
            [postdata setObject:itemid forKey:@"itemid"];
            
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {   [self addProgressIndicator];
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
}


-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Items Screen";
    
    [super viewDidAppear:animated];
    
}

-(void)setupview
{
    
    viewdetail.alpha=1;
    viewservice.alpha=1;
    viewweight.alpha=1;
    lblw.alpha=1;
    lblcarryitem.alpha=1;
    lblservice.alpha=1;
    bntinfo.alpha=1;
    
    [self GetItemdata];
    
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
    NSString *img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
    
    [imgview setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimgclick)];
    singleTap.numberOfTapsRequired = 1;
    [imgview setUserInteractionEnabled:YES];
    [imgview addGestureRecognizer:singleTap];
    imgview.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgview.layer.borderWidth = 2.0;
    tblcategory.frame= CGRectMake(0, 470, self.view.frame.size.width,chght2);
    
    [profileview addSubview:tblcategory];
    
}


//-(void)imgclick
//{
//    NSLog(@"single Tap on imageview");
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.45;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    transition.type = kCATransitionFromRight;
//    [transition setType:kCATransitionPush];
//    transition.subtype = kCATransitionFromRight;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    profilevc *profile= [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
//    [self.navigationController pushViewController:profile animated:NO];
//    
//}

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

-(void)GetItemdata
{
    touserid=[userdata valueForKey:@"userid"];
    vid=[userdata valueForKey:@"volumeid"];
    tripuser=[NSString stringWithFormat:@"%@ %@",[userdata valueForKey:@"firstname"],[userdata valueForKey:@"lastname"]];
    lblrating.text=[NSString stringWithFormat:@"%@ Star",[userdata valueForKey:@"rating"]];
    
    NSString *str=[userdata valueForKey:@"rating"];
    if([str isEqualToString:@"0"])
    {
        imgstar.image=[UIImage imageNamed:@"emptystar.png"];
    }
    
    lblid.text=[NSString stringWithFormat:@"I%@%@",itemid,[userdata valueForKey:@"userid"]];
    fromcityid=[userdata valueForKey:@"fromcityid"];
    tocityid=[userdata valueForKey:@"tocityid"];
    fromdate=[userdata valueForKey:@"fdate"];
    todate=[userdata valueForKey:@"tdate"];
    lblfrom.text=[NSString stringWithFormat:@"%@ ,%@",[userdata valueForKey:@"fromcity"],[userdata valueForKey:@"delivery_zipcode"]];
    lblto.text=[NSString stringWithFormat:@"%@ ,%@",[userdata valueForKey:@"tocity"],[userdata valueForKey:@"delivery_zipto"]];
    lbltripname.text=[userdata valueForKey:@"itemname"];
    lblvolweight.text= [NSString stringWithFormat:@"%@inch",[userdata valueForKey:@"volume"]];
    lblweight.text=[userdata valueForKey:@"weight"];
    NSString *ptype=[userdata valueForKey:@"mutually_agreed"];
    if(![ptype isEqualToString:@"Yes"])
    {
        
        NSString *pricelen= [NSString stringWithFormat:@"%@",[userdata valueForKey:@"itemprice"]];
        if([pricelen length] > 2)
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-105, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-98,-4, 92, 77);
        }
        else if([pricelen length] == 2)
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-88, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-78, -4, 70, 77);
        }
        else
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-51, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-43, -4, 35, 77);
        }        
        lblitemprice.text=[userdata valueForKey:@"itemprice"];
    }
    else
    {
        lblcurrency.frame=CGRectMake(self.view.frame.size.width-51, 14, 10, 21);
        lblitemprice.frame=CGRectMake(self.view.frame.size.width-43,-4,35, 77);
        lblitemprice.text=@"0";
    }
    NSString *fdate =[userdata valueForKey:@"fromdate"];
    // fdate=[fdate substringFromIndex:2];
    NSString *tdate =[userdata valueForKey:@"todate"];
    //tdate=[tdate substringFromIndex:2];
    lbldate.text=[NSString stringWithFormat:@"%@",fdate];
    lbltodate.text=tdate;
    txtdesc.text= [userdata valueForKey:@"description"];
}

-(void)viewWillAppear:(BOOL)animated
{
    segmentedControl3.selectedSegmentIndex=0;
    scrlview.alpha=1;
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    if(segmentindx == 0)
    {
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getsingleitem?itemid="];
    strurl=[strurl stringByAppendingString:itemid];
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
    
    tblcategory = [[UITableView alloc]init];
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.dataSource=self;
    tblcategory.delegate=self;
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory.separatorColor=[UIColor grayColor];
    tblcategory.frame = self.view.bounds;
     userdata = [[NSMutableDictionary alloc]init];
    
  //  tblcategory.frame= CGRectMake(0, 470, self.view.frame.size.width,chght2);
    //[profileview addSubview:tblcategory];
    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+chght2);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+chght2);
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
    tblview.frame = self.view.bounds;
    tblview.alpha=0;
    [tblview setContentInset:UIEdgeInsetsMake(0,0,90,0)];
   // tblview.frame= CGRectMake(5,125,self.view.frame.size.width-10,self.view.frame.size.height-215);
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
       
        if(segmentindx !=0)
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
        
        if(segmentindx !=0)
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
            strurl=[strurl stringByAppendingString:itemid];
            strurl= [strurl stringByAppendingString:@"&trip=1"];
            
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
    if(connection == cntconn)
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
        arrcategory = [[NSMutableArray alloc]init];
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            arrcategory=[deserializedData objectForKey:@"data"];
            int x =[arrcategory count];
            chght2= x*65;
        }
        else
        {
            
            SCLAlertView *network = [[SCLAlertView alloc] init];
            network.backgroundViewColor=[UIColor whiteColor];
            [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
    if([arrcategory count] > 0)
    {
        [self removeProgressIndicator];
        [self setupview];
        [tblcategory reloadData];
    }
    
}
-(void)btnokclick
{
    createtripvc *create = [[createtripvc alloc]initWithNibName:@"createtripvc" bundle:nil];
    create.fromcityid=fromcityid;
    create.tocityid=tocityid;
    create.vol=lblvolweight.text;
    create.ifromdt=[userdata valueForKey:@"fdate"];
    create.itodt=[userdata valueForKey:@"tdate"];
    create.fromzip=[userdata valueForKey:@"delivery_zipcode"];
    create.tozip=[userdata valueForKey:@"delivery_zipto"];
    create._itemid=itemid;
    if([strcommercial isEqualToString:@"Yes"])
    {
        create.paymenttype=@"C";
    }
    
    if([strmutual isEqualToString:@"Yes"])
    {
        create.paymenttype=@"M";
    }
    create.itemcategory=cat;
    create._volid=vid;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:create animated:NO];
}

-(IBAction)onbtninfoclick:(id)sender
{
    infoview *info= [[infoview alloc]initWithNibName:@"infoview" bundle:nil];
    [self presentPopupViewController:info animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int x =80.f;
    if(tableView == tblview)
    {
    if(arrtrip.count>0)
    {
        x=180.0f;
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
        if(arrcategory.count > 0)
        {
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
            ecell.lblmsg.text=@"No Category Found.";
            cell=ecell;
        }

        
    }
  else if (tableView == tblview)
  {
      if(segmentindx==1)
      {
          if([delegate.strusertype isEqualToString:@"Sender"])
          {
              if(arrtrip.count > 0)
              {
                  requestcell *rcell = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                  
                  if (rcell == nil)
                  {
                      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                      rcell = [nib objectAtIndex:0];
                      rcell.selectionStyle = UITableViewCellSelectionStyleNone;
                  }
                  rcell.lblflydate.hidden=YES;
                  rcell.imgaircraft.hidden=YES;
                  
                  rcell.lbl.text=@"Item Id:";
                  rcell.lblid.text=[NSString stringWithFormat:@"I%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"touserid"]];
                  rcell.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"];
                  rcell.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
                  rcell.txtmesage.editable=NO;
                  rcell.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                  rcell.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                  rcell.imgprofile.layer.cornerRadius= rcell.imgprofile.frame.size.width/2;
                  rcell.imgprofile.clipsToBounds=YES;
                  rcell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                  rcell.imgprofile.layer.borderWidth = 2.0;
                  
                  rcell.lblstar.text=[NSString stringWithFormat:@"%@ Star",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
                  
                  rcell.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                  
                  NSString *tripdate1 =[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                  NSArray *dates = [tripdate1 componentsSeparatedByString:@"/"];
                  rcell.lbldate.text=[dates objectAtIndex:0];
                  rcell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
                  
                  NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
                  
                  NSString *st=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"status"];
                  rcell.lblstatus.text=st;
                  if([st isEqualToString:@"Pending"])
                  {
                      rcell.lblstatus.backgroundColor=[UIColor greenColor];
                      rcell.lblstatus.textColor= [UIColor whiteColor];
                  }
                  else if([st isEqualToString:@"Declined"])
                  {
                      rcell.lblstatus.backgroundColor=[UIColor redColor];
                      rcell.lblstatus.textColor= [UIColor whiteColor];
                  }
                  [rcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                  
                  rcell.imgprofile.userInteractionEnabled = YES;
                  rcell.imgprofile.tag = indexPath.row;
                  
                  UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
                  tapped.numberOfTapsRequired = 1;
                  [rcell.imgprofile addGestureRecognizer:tapped];
                  cell=rcell;
                  rcell.btncancel.tag=99;
                  [rcell.btncancel addTarget:self action:@selector(cancelclick:)forControlEvents:UIControlEventTouchUpInside];
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
                  ecell.lblmsg.text=@"No Trip Request Found.";
                  cell=ecell;
              }
          }
      }
      
      else if(segmentindx==2)
      {
          if([delegate.strusertype isEqualToString:@"Sender"])
          {
              
              if(arrtrip.count> 0)
              {
                  requestcell *rcell2 = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                  
                  if (rcell2 == nil)
                  {
                      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                      rcell2 = [nib objectAtIndex:0];
                      rcell2.selectionStyle = UITableViewCellSelectionStyleNone;

                  }
                  rcell2.lblflydate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
                  rcell2.lbl.text=@"Item Id:";
                  rcell2.lblid.text=[NSString stringWithFormat:@"I%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
                  rcell2.btncancel.hidden=YES;
                  
                  rcell2.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"];
                  rcell2.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
                  rcell2.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                  rcell2.lblstar.text=[NSString stringWithFormat:@"%@ Star",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
                  
                  
                  NSString *tripdate1 =[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
                  NSArray *dates = [tripdate1 componentsSeparatedByString:@"/"];
                  rcell2.lbldate.text=[dates objectAtIndex:0];
                  rcell2.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
                  
                  rcell2.txtmesage.editable=NO;
                  NSString *st=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"status"];
                  rcell2.lblstatus.text=st;
                  if([st isEqualToString:@"Pending"])
                  {
                      rcell2.lblstatus.backgroundColor=[UIColor greenColor];
                      rcell2.lblstatus.textColor= [UIColor whiteColor];
                  }
                  else if([st isEqualToString:@"Declined"])
                  {
                      rcell2.btncancel.hidden=NO;
                      
                      [rcell2.btncancel setTitle:@"Request Rejected" forState:UIControlStateNormal];
                      [rcell2.btncancel setBackgroundColor:[UIColor grayColor]];
                      rcell2.lblstatus.backgroundColor=[UIColor redColor];
                      rcell2.lblstatus.textColor= [UIColor whiteColor];
                  }
                  rcell2.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                  rcell2.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                  rcell2.imgprofile.layer.cornerRadius= rcell2.imgprofile.frame.size.width/2;
                  rcell2.imgprofile.clipsToBounds=YES;
                  rcell2.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                  rcell2.imgprofile.layer.borderWidth = 2.0;
                  
                  NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
                  [rcell2.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                  
                  rcell2.imgprofile.userInteractionEnabled = YES;
                  rcell2.imgprofile.tag = indexPath.row;
                  
                  UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
                  tapped.numberOfTapsRequired = 1;
                  [rcell2.imgprofile addGestureRecognizer:tapped];
                  
                  cell=rcell2;
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
      }
  }
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblview)
    {
    cell.contentView.backgroundColor= [UIColor clearColor];
    
    UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 120)];
    
    whiteview.layer.masksToBounds=false;
    whiteview.layer.cornerRadius=2.0;
    whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
    whiteview.layer.shadowOpacity=0.2;
    
    [cell.contentView addSubview:whiteview];
    [cell.contentView sendSubviewToBack:whiteview];
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblview)
    {

    
    if(segmentindx==1)
    {
        if([arrtrip count]  > 0)
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
        
        tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
        trip.pagefrom=@"SR";
        trip.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
        [self.navigationController pushViewController:trip animated:NO];
            }
        }
        
    }
    else if(segmentindx==2)
    {
        if([arrtrip count]  > 0)
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
        
        tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
        trip.pagefrom=@"mt";
        trip.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
        trip.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
        trip.requestid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"requestid"];
        [self.navigationController pushViewController:trip animated:NO];
            }
        }
    }
    }
}

-(void)imgclick :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int index =gesture.view.tag;
  // NSLog(@"%@", [arrtrip objectAtIndex:index]);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    viewprofile *profile= [[viewprofile alloc]initWithNibName:@"viewprofile" bundle:nil];
    profile.userid=[[arrtrip objectAtIndex:index]valueForKey:@"userid"];
    [self.navigationController pushViewController:profile animated:NO];
    
}
-(void)cancelclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    binx=btnTemp.tag;
    
    
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
    segmentindx=0;
    binx=0;
    tblview.delegate=nil;
    tblview.dataSource=nil;
    [tblview removeFromSuperview];
    
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
