//
//  alertvc.m
//  airlogic
//
//  Created by APPLE on 20/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "alertvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SWRevealViewController.h"
#import "notificationcell.h"
#import "emptycell.h"
#import "tripitemrequestvc.h"
#import "messagelistvc.h"
#import "myitemvc.h"
#import "mytriplistvc.h"
#import "itemsrd.h"
#import "tripsrd.h"



@interface alertvc ()

@end

@implementation alertvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Alert";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    [tblnotification setBackgroundColor:[UIColor clearColor]];
    tblnotification.hidden=YES;
    tblnotification.tableFooterView= [[UIView alloc]init];
    tblnotification.backgroundColor=[UIColor clearColor];
    //tblview.allowsSelection=YES;
   // tblnotification.allowsSelection = NO;
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor whiteColor];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"
                                                                attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    
    
    [tblnotification addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];


    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Notification Screen";
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

    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getnotification"];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

}
- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getnotification"];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == catconn)
    {
        arrdata = [[NSMutableArray alloc]init];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            arrdata = [deserializedData objectForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
            
        }
        [tblnotification reloadData];
        tblnotification.hidden=NO;
        
    }
    if(connection == conndelete)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"getnotification"];
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                [alert show];
                return;
            }
        }
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor= [UIColor clearColor];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 75)];
        
        whiteview.layer.masksToBounds=false;
        whiteview.layer.cornerRadius=2.0;
        whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
        whiteview.layer.shadowOpacity=0.2;
        
        [cell.contentView addSubview:whiteview];
        [cell.contentView sendSubviewToBack:whiteview];
    }
    else
    {
        UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 75)];
        
        whiteview.layer.masksToBounds=false;
        whiteview.layer.cornerRadius=2.0;
        whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
        whiteview.layer.shadowOpacity=0.2;
        
        [cell.contentView addSubview:whiteview];
        [cell.contentView sendSubviewToBack:whiteview];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int x =80.f;
    if(arrdata.count>0)
    {
        x=75;
    }
    
    return x;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell;
    
    
    if(arrdata.count > 0)
    {
        notificationcell *acell = (notificationcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (acell == nil)
        {
            acell.contentView.backgroundColor = [UIColor whiteColor];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"notificationcell" owner:self options:nil];
            acell = [nib objectAtIndex:0];
        }
        
         acell.lblname.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"msg"]];
        
        
        NSString *dateString= [[arrdata objectAtIndex:indexPath.row]valueForKey:@"alertdate"];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* sourceDate = [dateFormatter dateFromString:dateString];
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"CEST"];
        // NSLog(@"%@",sourceTimeZone);
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        // NSLog(@"usere >> %@",destinationTimeZone);
        
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* localTime = [dateFormat stringFromDate:destinationDate];
        
        [acell.btndelete addTarget:self action:@selector(deleteclick:)forControlEvents:UIControlEventTouchUpInside];
        

        
        acell.lbldate.text= localTime;
       NSString *ntype= [[arrdata objectAtIndex:[indexPath row]]valueForKey:@"notification_type"];
        if([ntype isEqualToString:@"Message"])
        {
            acell.img.image=[UIImage imageNamed:@"messaging.png"];
        }
        else if([ntype isEqualToString:@"Request"])
        {
            acell.img.image=[UIImage imageNamed:@"requested.png"];
        }
        else if([ntype isEqualToString:@"Request Accepted"])
        {
            acell.img.image=[UIImage imageNamed:@"request-accepted.png"];
        }
        else if([ntype isEqualToString:@"Request Declined"])
        {
            acell.img.image=[UIImage imageNamed:@"request-decline.png"];
        }
        else if([ntype isEqualToString:@"Status"])
        {
            acell.img.image=[UIImage imageNamed:@"item-trip-status.png"];
        }
        else if([ntype isEqualToString:@"Cancelled"])
        {
            acell.img.image=[UIImage imageNamed:@"request-decline.png"];
        }
        cell=acell;
        
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
        ecell.lblmsg.text=@"No Alerts Found.";
        cell=ecell;
    }
    
    return cell;
}

-(void)deleteclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    
    UITableViewCell *cell = (UITableViewCell*)sender.superview.superview; //Since you are adding to cell.contentView, navigate two levels to get cell object
    NSIndexPath *indexPath = [tblnotification indexPathForCell:cell];
    //
    NSString *notid=[[arrdata objectAtIndex:indexPath.row
             ]valueForKey:@"id"];
    
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"deletealert"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:notid forKey:@"id"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        
        conndelete=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    
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
        
        NSString *alerttype=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"notification_type"];
        
        if([alerttype isEqualToString:@"Request"])
        {
           // tripitemrequestvc *request = [[tripitemrequestvc alloc]initWithNibName:@"tripitemrequestvc" bundle:nil];
            
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                itemsrd *itemrequest = [[itemsrd alloc]initWithNibName:@"itemsrd" bundle:nil];
                itemrequest.itemid=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"itemid"];
                [self.navigationController pushViewController:itemrequest animated:NO];
            }
            else
            {
                tripsrd *triprequest = [[tripsrd alloc]initWithNibName:@"tripsrd" bundle:nil];
                triprequest.tripid=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"tripid"];
                [self.navigationController pushViewController:triprequest animated:NO];
            }
        }
        else if([alerttype isEqualToString:@"Message"])
        {
            messagelistvc *msg = [[messagelistvc alloc]initWithNibName:@"messagelistvc" bundle:nil];
            
            [self.navigationController pushViewController:msg animated:NO];
        }
        else if([alerttype isEqualToString:@"Status"])
        {
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                myitemvc *page = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
                [self.navigationController pushViewController:page animated:NO];
            }
            else
            {
               mytriplistvc *page = [[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
                [self.navigationController pushViewController:page animated:NO];
            }
            
        }
        else if([alerttype isEqualToString:@"Request Accepted"] || [alerttype isEqualToString:@"Request Declined"])
        {
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
                myitemvc *page = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
                [self.navigationController pushViewController:page animated:NO];
            }
            else
            {
                mytriplistvc *page = [[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
                [self.navigationController pushViewController:page animated:NO];
            }
            
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
