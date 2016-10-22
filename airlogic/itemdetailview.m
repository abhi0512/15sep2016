//
//  itemdetailview.m
//  airlogic
//
//  Created by APPLE on 26/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itemdetailview.h"
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


@interface itemdetailview ()

@end
int chght=65;
@implementation itemdetailview
@synthesize strcommercial,strmutual,tripid,pagefrom,requestid,itemid,isexpired,touserid;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Item Detail";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    imgview.layer.cornerRadius= imgview.frame.size.width/2;
    imgview.clipsToBounds=YES;
    txtdesc.userInteractionEnabled=NO;
    viewdetail.alpha=0;
    viewservice.alpha=0;
    viewweight.alpha=0;
    lblw.alpha=0;
    lblcarryitem.alpha=0;
    lblservice.alpha=0;
    btnaccept.alpha=0;
    btndecline.alpha=0;
    bntinfo.alpha=0;
    isaccept=NO;
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Item Detail Screen";
    
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
    btndecline.alpha=0;
    btnaccept.alpha=0;
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
        NSString *img =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",thumbprofilepic];
        
    [imgview setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileimgclick)];
    singleTap.numberOfTapsRequired = 1;
    [imgview setUserInteractionEnabled:YES];
    [imgview addGestureRecognizer:singleTap];
    imgview.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgview.layer.borderWidth = 2.0;
    
    tblcategory.frame= CGRectMake(0, 470, self.view.frame.size.width,chght);
    btnsubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnsubmit setBackgroundImage:[UIImage imageNamed:@"btnorange"] forState:UIControlStateNormal];
    [btnsubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([tripuser isEqualToString:delegate.username])
    {
      [btnsubmit setTitle:@"Cancel This Item" forState:UIControlStateNormal];
        iscancel=YES;
    }
    else
    {
    [btnsubmit setTitle:@"Choose This Items" forState:UIControlStateNormal];
        iscancel=NO;

    }
    
    btnsubmit.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    [btnsubmit addTarget:self action:@selector(onbtnchoosetripclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float X_Co = (self.view.frame.size.width - 218)/2;
    [btnsubmit setFrame:CGRectMake(X_Co,tblcategory.frame.origin.y+chght+10, 218, 34)];
    
    btnaccept = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnaccept setBackgroundImage:[UIImage imageNamed:@"btnsmall_orange"] forState:UIControlStateNormal];
    [btnaccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnaccept setTitle:@"Accept" forState:UIControlStateNormal];
    btnaccept.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
      [btnaccept setFrame:CGRectMake((self.view.frame.size.width - 300)/2, tblcategory.frame.origin.y+chght+10, 142,36)];
    
    [btnaccept addTarget:self action:@selector(onbtnacceptclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    CGRect buttonTitleFrame = btnaccept.titleLabel.frame;
//    CGRect convertedRect = [btnaccept convertRect:btnacceptz.titleLabel.frame toView:button.superview];
//    CGFloat xForLabel = convertedRect.origin.x + buttonTitleFrame.size.width;
    btndecline = [UIButton buttonWithType:UIButtonTypeCustom];
    [btndecline setBackgroundImage:[UIImage imageNamed:@"btnsmall_orange"] forState:UIControlStateNormal];
    [btndecline setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btndecline setTitle:@"Decline" forState:UIControlStateNormal];
    btndecline.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    [btndecline setFrame:CGRectMake(btnaccept.frame.origin.x+btnaccept.frame.size.width+5, tblcategory.frame.origin.y+chght+10, 142,36)];
    [btndecline addTarget:self action:@selector(onbtndelcineclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileview addSubview:tblcategory];
    [profileview addSubview:btnsubmit];
    [profileview addSubview:btnaccept];
    [profileview addSubview:btndecline];
    
    
    if([pagefrom isEqualToString:@"mi"])
    {
        btnaccept.alpha=1;
        btndecline.alpha=1;
        btnsubmit.alpha=0;
        return;
    }
    if([pagefrom isEqualToString:@"SR"])
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

-(void)GetItemdata
{
    touserid=[userdata valueForKey:@"userid"];
    lblrating.text=[NSString stringWithFormat:@"%@ Star",[userdata valueForKey:@"rating"]];
    
    NSString *str=[userdata valueForKey:@"rating"];
    if([str isEqualToString:@"0"])
    {
        imgstar.image=[UIImage imageNamed:@"emptystar.png"];
    }
    vid=[userdata valueForKey:@"volumeid"];
    tripuser=[NSString stringWithFormat:@"%@ %@",[userdata valueForKey:@"firstname"],[userdata valueForKey:@"lastname"]];
    lblid.text=[NSString stringWithFormat:@"I%@%@",itemid,[userdata valueForKey:@"userid"]];
    fromcityid=[userdata valueForKey:@"fromcityid"];
    tocityid=[userdata valueForKey:@"tocityid"];
    fromdate=[userdata valueForKey:@"fdate"];
    todate=[userdata valueForKey:@"tdate"];
    
    lblfrom.text=[NSString stringWithFormat:@"%@, %@",[userdata valueForKey:@"fromcity"],[userdata valueForKey:@"delivery_zipcode"]];
    lblto.text=[NSString stringWithFormat:@"%@, %@",[userdata valueForKey:@"tocity"],[userdata valueForKey:@"delivery_zipto"]];
    lbltripname.text=[userdata valueForKey:@"itemname"];
    lblvolweight.text= [NSString stringWithFormat:@"%@inch",[userdata valueForKey:@"volume"]];
    lblweight.text=[userdata valueForKey:@"weight"];
    NSString *ptype=[userdata valueForKey:@"mutually_agreed"];
    if(![ptype isEqualToString:@"Yes"])
    {
        
        NSString *pricelen= [NSString stringWithFormat:@"%@",[userdata valueForKey:@"itemprice"]];
        if([pricelen length] > 3)
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-105, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-98,-4, 92, 77);
            [lblitemprice setFont:[UIFont fontWithName:@"Arial Narrow" size:42.0f]];
        }
        else if([pricelen length] > 2)
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-105, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-98,-4, 92, 77);
            [lblitemprice setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
        }
        else if([pricelen length] == 2)
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-88, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-78, -4, 70, 77);
            [lblitemprice setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
        }
        else
        {
            lblcurrency.frame=CGRectMake(self.view.frame.size.width-51, 14, 10, 21);
            lblitemprice.frame=CGRectMake(self.view.frame.size.width-43, -4, 35, 77);
            [lblitemprice setFont:[UIFont fontWithName:@"Arial Narrow" size:67.0f]];
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
    lbldateto.text=tdate;
    txtdesc.text= [userdata valueForKey:@"description"];
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
    
    tblcategory.frame= CGRectMake(0, 470, self.view.frame.size.width,chght);
    [profileview addSubview:tblcategory];
    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+90);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+90);
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
            chght= x*65;
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
    if(connection == requestconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            mytriplistvc *trip= [[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:trip animated:NO];
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
        
        arrtrips =[[NSMutableArray alloc]init];
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            arrtrips=[deserializedData objectForKey:@"data"];
            if(arrtrips.count >0)
            {
            
                   sendrequestvc *request = [[sendrequestvc alloc]initWithNibName:@"sendrequestvc" bundle:nil];
                    request.itemid =itemid ;
                    request.touserid=touserid;
                    request.strtripid=[[arrtrips objectAtIndex:0]valueForKey:@"id"] ;
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
                [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:@"Please fill out your trip details." closeButtonTitle:@"Cancel" duration:0.0f];
            }
        }
        else
        {
             [self removeProgressIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert addButton:@"Create Now" target:self selector:@selector(btnokclick)];
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:@"Please fill out your trip details." closeButtonTitle:@"OK" duration:0.0f];
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
            [self removeProgressIndicator];
            
        }
        
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

-(IBAction)onbtnchoosetripclick:(id)sender
{
    
    if(!iscancel)
    {
    if([tripuser isEqualToString:delegate.username])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        NSString *message=@"";
        message=@"You can't carry your own items";
        [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:message closeButtonTitle:@"OK" duration:0.0f];
        
    }
    else
    {
        
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"checktriprequest"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:fromcityid forKey:@"fromcityid"];
        [postdata setObject:tocityid forKey:@"tocityid"];
        [postdata setObject:fromdate forKey:@"fromdate"];
        [postdata setObject:todate forKey:@"todate"];
        
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
//
    }
    }
    else
    {
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"updateitemstatus"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:itemid forKey:@"itemid"];
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
    [postdata setObject:@"0" forKey:@"utype"];
    
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
    [postdata setObject:@"Rejected" forKey:@"status"];
    [postdata setObject:itemid forKey:@"itemid"];
    [postdata setObject:touserid forKey:@"touserid"];
    [postdata setObject:@"0" forKey:@"utype"];
    
    
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
