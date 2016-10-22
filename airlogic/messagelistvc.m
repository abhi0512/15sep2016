//
//  messagelistvc.m
//  airlogic
//
//  Created by APPLE on 25/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "messagelistvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SWRevealViewController.h"
#import "SCLAlertView.h"
#import "messageboxcell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "emptycell.h"
#import "Messagevc.h"


@interface messagelistvc ()

@end

@implementation messagelistvc
@synthesize arrmessage;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Message";
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arrmessage=[[NSMutableArray alloc]init];
    tblmessage.tableFooterView= [[UIView alloc]init];
    tblmessage.backgroundColor=[UIColor clearColor];
    tblmessage.alpha=0;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Message Screen";
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    tblmessage.backgroundColor=[UIColor clearColor];
    tblmessage.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getmessagebox"];
    
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
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
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
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
    if(connection == catconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            //NSArray *arr = [deserializedData objectForKey:@"data"];
           arrmessage=[deserializedData objectForKey:@"data"];
            //[arrmessage addObjectsFromArray:arr];
            
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
            [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
            
        }
        
    }
      if(arrmessage.count  > 0)
      {
          tblmessage.alpha=1;
       [self removeProgressIndicator];
       [tblmessage reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(arrmessage.count == 0)
    {
        return 1;
    }
    else
    {
        return arrmessage.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int x =70.f;
    
    if(arrmessage.count>0)
    {
        x=95.0f;
    }
    return x;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell;
  
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            
            if(arrmessage.count > 0)
            {
                messageboxcell *rcell = (messageboxcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"messageboxcell" owner:self options:nil];
                    rcell = [nib objectAtIndex:0];
                    rcell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                
                NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"tpicture"]];
                rcell.lblname.text=[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"requestid"];
                rcell.lblitemuser.text=[NSString stringWithFormat:@"%@ %@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"itemuserfname"],[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"itemuserlname"]];
                
                rcell.lbltripuser.text=[NSString stringWithFormat:@"%@ %@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"tripuserfname"],[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"tripuserlname"]];
                
                [rcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                rcell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                rcell.imgprofile.layer.borderWidth = 2.0;
                rcell.imgprofile.layer.cornerRadius= rcell.imgprofile.frame.size.width/2;
                rcell.imgprofile.clipsToBounds=YES;
                
                cell=rcell;
            }
            else
            {
                emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (ecell == nil)
                {
                    ecell.contentView.backgroundColor = [UIColor whiteColor];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
                }
                ecell.lblmsg.text=@"No Messages Found.";
                cell=ecell;
            }
        }
        else
        {
            if(arrmessage.count> 0)
            {
                messageboxcell *rcell1 = (messageboxcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell1 == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"messageboxcell" owner:self options:nil];
                    rcell1 = [nib objectAtIndex:0];
                    rcell1.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                
                rcell1.lblname.text=[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"requestid"];
                rcell1.lblitemuser.text=[NSString stringWithFormat:@"%@ %@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"itemuserfname"],[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"itemuserlname"]];
                
                rcell1.lbltripuser.text=[NSString stringWithFormat:@"%@ %@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"tripuserfname"],[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"tripuserlname"]];
                
                rcell1.imgprofile.layer.cornerRadius= rcell1.imgprofile.frame.size.width/2;
                rcell1.imgprofile.clipsToBounds=YES;
                NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrmessage objectAtIndex:[indexPath row]]valueForKey:@"ipicture"]];
                 [rcell1.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                rcell1.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
                rcell1.imgprofile.layer.borderWidth = 2.0;
                rcell1.imgprofile.layer.cornerRadius= rcell1.imgprofile.frame.size.width/2;
                rcell1.imgprofile.clipsToBounds=YES;
                
                cell=rcell1;
            }
            else
            {
                emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (ecell == nil)
                {
                    ecell.contentView.backgroundColor = [UIColor whiteColor];
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
                }
                ecell.lblmsg.text=@"No Messages Found.";
                cell=ecell;
            }
            
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor= [UIColor clearColor];
    
    UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 130)];
    
    whiteview.layer.masksToBounds=false;
    whiteview.layer.cornerRadius=2.0;
    whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
    whiteview.layer.shadowOpacity=0.2;
    
    [cell.contentView addSubview:whiteview];
    [cell.contentView sendSubviewToBack:whiteview];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    Messagevc *msg =[[Messagevc alloc]initWithNibName:@"Messagevc" bundle:nil];
    
   // msglist *msg =[[msglist alloc]initWithNibName:@"msglist" bundle:nil];
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
    msg.itemid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"itemid"];
    msg.tripid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"tripid"];
    msg.touserid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"tripuserid"];
    msg.msgstatus=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"currentstatus"];
    }
    else
    {
        msg.itemid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"itemid"];
        msg.tripid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"tripid"];
        msg.touserid=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"itemuserid"];
        msg.msgstatus=[[arrmessage objectAtIndex:indexPath.row]valueForKey:@"currentstatus"];
        
    }
    [self.navigationController pushViewController:msg animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addspinner
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidden=NO;
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
}
-(void)removespinner
{
    spinner.hidden=YES;
    [spinner stopAnimating];
}

@end
