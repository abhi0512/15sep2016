//
//  mytriplistvc.m
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import "mytriplistvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SWRevealViewController.h"
#import "createtripvc.h"
#import "homeviewcell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "tripdetailvc.h"
#import "emptycell.h"
#import "tripitemsvc.h"
#import "tripsrd.h"


@interface mytriplistvc ()


@end

@implementation mytriplistvc
@synthesize arrdata,type;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"My Trip";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [tblview setBackgroundColor:[UIColor clearColor]];
    arractivetrip = [[NSMutableArray alloc]init];
    arrexpiredtrip = [[NSMutableArray alloc]init];
    arrpendingtrip=[[NSMutableArray alloc]init];
    arrcompleted=[[NSMutableArray alloc]init];
    
    tblview.hidden=YES;
    tblview.tableFooterView= [[UIView alloc]init];
    tblview.backgroundColor=[UIColor clearColor];
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor whiteColor];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"
                                                                attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    
    
    [tblview addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
   
        // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"My Trip Screen";
    [super viewDidAppear:animated];
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"mytripsoritems?userid="];
    strurl= [strurl stringByAppendingString:delegate.struserid];
    strurl= [strurl stringByAppendingString:@"&type="];
    strurl= [strurl stringByAppendingString:type];
    
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:120];
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

-(void)viewWillAppear:(BOOL)animated
{
    
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    
    UIImage *filterimg = [UIImage imageNamed:@"addicon.png"];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addbtn setBackgroundImage:filterimg forState:UIControlStateNormal];
    
    addbtn.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:addbtn];
    
    [addbtn addTarget:self action:@selector(addtripclick) forControlEvents:UIControlEventTouchUpInside];
    
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
        type=@"0";
        [self.navigationItem setRightBarButtonItem:aBarButtonItem2];
        
    }
    else
    {
    type=@"1";
    }
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"mytripsoritems?userid="];
    strurl= [strurl stringByAppendingString:delegate.struserid];
    strurl= [strurl stringByAppendingString:@"&type="];
    strurl= [strurl stringByAppendingString:type];
       
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:120];
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

-(void)addtripclick
{
    createtripvc *create = [[createtripvc alloc]initWithNibName:@"createtripvc" bundle:nil];
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
            arractivetrip = [[deserializedData objectForKey:@"data"]valueForKey:@"active"];
            arrpendingtrip=[[deserializedData objectForKey:@"data"]valueForKey:@"pending"];
            arrexpiredtrip=[[deserializedData objectForKey:@"data"]valueForKey:@"expired"];
            arrcompleted= [[deserializedData objectForKey:@"data"]valueForKey:@"completed"];
            arrcanceled=[[deserializedData objectForKey:@"data"]valueForKey:@"cancelled"];
            
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[alert show];
        }
      
    }
    tblview.hidden=NO;
    [tblview reloadData];
    [self removeProgressIndicator];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0)
    {
        if(arractivetrip.count == 0)
        {
            return 1;
        }
        else
        {
            return arractivetrip.count;
        }
    }
    if(section ==1)
    {
        if(arrpendingtrip.count == 0)
        {
          return 1;
        }
        else
        {
            return arrpendingtrip.count;
        }
    }
    if(section ==2)
    {
        if(arrexpiredtrip.count == 0)
        {
            return 1;
        }
        else
        {
            return arrexpiredtrip.count;
        }
    }
    if(section ==3)
    {
        if(arrcompleted.count == 0)
        {
            return 1;
        }
        else
        {
            return arrcompleted.count;
        }
    }
    if(section ==4)
    {
        if(arrcanceled.count == 0)
        {
            return 1;
        }
        else
        {
            return arrcanceled.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title;
    UIView *headerview;
    
    if (section == 0)
    {
       
    title = @"Active Trip";
    
    }
    else if(section == 1)
    {
       
    title = @"Pending Trip";
        
    }
    else if(section == 2)
    {
       
    title = @"Expired Trip";
        
    }
    else if(section == 3)
    {
        
    title = @"Completed Trip";
       
    }
    else if(section == 4)
    {
        
        title = @"Cancelled Trip";
        
    }
    
        headerview=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 18)];
        lbl.text=title;
        lbl.font= [UIFont fontWithName:@"Roboto-Bold" size:14];
        lbl.textAlignment=NSTextAlignmentLeft;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.textColor=[UIColor whiteColor];
        headerview.backgroundColor=[UIColor clearColor];
        [headerview addSubview:lbl];

        return headerview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 22;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int x =80.f;
    if(indexPath.section==0)
    {
        if(arractivetrip.count>0)
        {
            x=130.0f;
        }
    }
    if(indexPath.section==1)
    {
       
        if(arrpendingtrip.count >0)
        {
            x=130.0f;
        }
    }
    if(indexPath.section==2)
    {
        if(arrexpiredtrip.count >0)
        {
            x=130.0f;
        }

    }
    if(indexPath.section==3)
    {
        if(arrcompleted.count >0)
        {
            x=130.0f;
        }
        
    }
    if(indexPath.section==4)
    {
        if(arrcanceled.count >0)
        {
            x=130.0f;
        }
        
    }
    return x;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(arractivetrip.count> 0)
        {
        
        homeviewcell *acell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (acell == nil)
        {
            acell.contentView.backgroundColor = [UIColor whiteColor];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
            acell = [nib objectAtIndex:0];
        }
//       
//            acell.lblticket.frame=CGRectMake(72, 6, 72, 21);
//            acell.lbltripname.frame=CGRectMake(143, 6, 85, 21);
//            
//            acell.lblticket.text=@"Request Id:";
//    acell.lbltripname.text= [NSString stringWithFormat:@"R%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
            
            acell.lblticket.frame=CGRectMake(72, 6, 50, 21);
            acell.lbltripname.frame=CGRectMake(120, 6, 85, 21);
            acell.lblticket.text=@"Trip Id:";
            
             acell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"id"],delegate.struserid];
            
    acell.imgticket.hidden=YES;
    acell.fromcity.text= [NSString stringWithFormat:@"%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
    acell.tocity.text= [NSString stringWithFormat:@"%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
    acell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
    acell.lblweight.text=[NSString stringWithFormat:@"%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
    acell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
    acell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                acell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
            NSString *tripdate =[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSArray *dates = [tripdate componentsSeparatedByString: @" "];
            acell.lbldate.text=[dates objectAtIndex:0];
            acell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
            
        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arractivetrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
       
    [acell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    acell.imgprofile.layer.cornerRadius= acell.imgprofile.frame.size.width/2;
    acell.imgprofile.clipsToBounds=YES;
    acell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
    acell.imgprofile.layer.borderWidth = 2.0;
            
            cell=acell;
        }
        else
        {
            emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (ecell == nil)
            {
                ecell.userInteractionEnabled=NO;
                [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Active Trips Found.";
            cell=ecell;
        }
        
    }
    
    
    if(indexPath.section == 1)
    {
        
        if(arrpendingtrip.count >0)
        {
            
            homeviewcell *pcell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (pcell == nil)
            {
                pcell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
                pcell = [nib objectAtIndex:0];
            }
            if([delegate.strusertype isEqualToString:@"Flybee"])
            {
                
                pcell.lblticket.frame=CGRectMake(72, 6, 50, 21);
                pcell.lbltripname.frame=CGRectMake(120, 6, 85, 21);
              pcell.lblticket.text=@"Trip Id:";
             pcell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"id"],delegate.struserid];
            }
            else
            {
                pcell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"]];
                
            }
            NSString *isticket_verified=[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"isticket_verified"];
            if([isticket_verified isEqualToString:@"Y"])
            {
                pcell.imgticket.image=[UIImage imageNamed:@"btnapproved.png"];
            }
            else
            {
                pcell.imgticket.image=[UIImage imageNamed:@"btnpending.png"];
            }
            
        pcell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
        pcell.tocity.text= [NSString stringWithFormat:@"%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
        pcell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
        pcell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
        pcell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
            NSString *tripdate =[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSArray *dates = [tripdate componentsSeparatedByString: @" "];
            pcell.lbldate.text=[dates objectAtIndex:0];
            pcell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
            pcell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                pcell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
        
        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrpendingtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
        
        [pcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            pcell.imgprofile.layer.cornerRadius= pcell.imgprofile.frame.size.width/2;
            pcell.imgprofile.clipsToBounds=YES;
            pcell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            pcell.imgprofile.layer.borderWidth = 2.0;
            
             cell=pcell;
        }
        else
        {
            emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (ecell == nil)
            {
                ecell.userInteractionEnabled=NO;
                [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Pending Trips Found.";
            cell=ecell;
            
        }
    }
    if(indexPath.section == 2)
    {
        if(arrexpiredtrip.count > 0)
        {
            
            homeviewcell *excell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (excell == nil)
            {
                excell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
                excell = [nib objectAtIndex:0];
            }

            if([delegate.strusertype isEqualToString:@"Flybee"])
            {
                excell.lblticket.frame=CGRectMake(72, 6, 50, 21);
                excell.lbltripname.frame=CGRectMake(120, 6, 85, 21);
               excell.lblticket.text=@"Trip Id:";
              excell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"id"],delegate.struserid];
            }
            else
            {
                excell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"]];
                
            }
            excell.imgticket.hidden=YES;
        excell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
        excell.tocity.text= [NSString stringWithFormat:@"%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
        excell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
        excell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
         excell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
            excell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            
            NSString *str= [[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                excell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            

            
            NSString *tripdate =[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSArray *dates = [tripdate componentsSeparatedByString: @" "];
            excell.lbldate.text=[dates objectAtIndex:0];
            excell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
        
        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrexpiredtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
        
        [excell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        excell.imgprofile.layer.cornerRadius= excell.imgprofile.frame.size.width/2;
        excell.imgprofile.clipsToBounds=YES;
        excell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
        excell.imgprofile.layer.borderWidth = 2.0;
            
             cell=excell;
        }
        else
        {
            emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (ecell == nil)
            {
                ecell.userInteractionEnabled=NO;
                [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Expired Trips Found.";
            cell=ecell;

        }
    }
    if(indexPath.section == 3)
    {
        if(arrcompleted.count > 0)
        {   
            homeviewcell *cocell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cocell == nil)
            {
                cocell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
                cocell = [nib objectAtIndex:0];
            }
            if([delegate.strusertype isEqualToString:@"Flybee"])
            {
//                cocell.lblticket.frame=CGRectMake(72, 6, 72, 21);
//                cocell.lbltripname.frame=CGRectMake(143, 6, 85, 21);
//                
//                 
//                cocell.lblticket.text=@"Request Id:";
//            cocell.lbltripname.text= [NSString stringWithFormat:@"R%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
                
                cocell.lblticket.frame=CGRectMake(72, 6, 50, 21);
                cocell.lbltripname.frame=CGRectMake(120, 6, 85, 21);
                cocell.lblticket.text=@"Trip Id:";
                cocell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"id"],delegate.struserid];

                
            }
            else
            {
                cocell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"itemname"]];
                
            }
            cocell.imgticket.hidden=YES;
        cocell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
        cocell.tocity.text= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
        cocell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
        cocell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
         cocell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
        cocell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            
            NSString *str= [[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                cocell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
        
            NSString *tripdate =[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSArray *dates = [tripdate componentsSeparatedByString: @" "];
            cocell.lbldate.text=[dates objectAtIndex:0];
            cocell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
            
        NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
        
        [cocell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
       
        cocell.imgprofile.layer.cornerRadius= cocell.imgprofile.frame.size.width/2;
        cocell.imgprofile.clipsToBounds=YES;
        cocell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
        cocell.imgprofile.layer.borderWidth = 2.0;
            
            cell=cocell;
        }
        else
        {
            emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (ecell == nil)
            {
                ecell.userInteractionEnabled=NO;
                [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Completed Trips Found.";
            cell=ecell;
        }
    }
    if(indexPath.section == 4)
    {
        if(arrcanceled.count > 0)
        {
            
            homeviewcell *cocell = (homeviewcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cocell == nil)
            {
                cocell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"homeviewcell" owner:self options:nil];
                cocell = [nib objectAtIndex:0];
            }
            if([delegate.strusertype isEqualToString:@"Flybee"])
            {
                cocell.lblticket.frame=CGRectMake(72, 6, 50, 21);
                cocell.lbltripname.frame=CGRectMake(120, 6, 85, 21);
                
                 cocell.lblticket.text=@"Trip Id:";
                cocell.lbltripname.text= [NSString stringWithFormat:@"T%@%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"id"],delegate.struserid];
            }
            else
            {
                cocell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"itemname"]];
                
            }
             cocell.imgticket.hidden=YES;
            cocell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            cocell.tocity.text= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            cocell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            cocell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
            cocell.lblflightname.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"tripname"]];
            cocell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                cocell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
            NSString *tripdate =[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSArray *dates = [tripdate componentsSeparatedByString: @" "];
            cocell.lbldate.text=[dates objectAtIndex:0];
            cocell.lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
            [cocell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cocell.imgprofile.layer.cornerRadius= cocell.imgprofile.frame.size.width/2;
            cocell.imgprofile.clipsToBounds=YES;
            cocell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            cocell.imgprofile.layer.borderWidth = 2.0;
            
            cell=cocell;
        }
        else
        {
            emptycell *ecell = (emptycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (ecell == nil)
            {
                ecell.userInteractionEnabled=NO;
                [ecell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Cancelled Trips Found.";
            cell=ecell;
        }
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section == 0)
    {
        if([arractivetrip count] > 0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
        tripitemsvc *titem=[[tripitemsvc alloc]initWithNibName:@"tripitemsvc" bundle:nil];
        titem.curstatus=[[arractivetrip objectAtIndex:indexPath.row]valueForKey:@"itemstatus"];
        titem.tripid=[[arractivetrip objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:titem animated:NO];
        }
    }
    if(indexPath.section == 1)
    {
        if([arrpendingtrip count] > 0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
        //tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
        tripsrd  *trip = [[tripsrd alloc]initWithNibName:@"tripsrd" bundle:nil];
        trip.pagefrom=@"my";
        trip.isexpired=@"N";
        trip.tripid=[[arrpendingtrip objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:trip animated:NO];
        }

    }
    if(indexPath.section == 2)
    {
        if([arrexpiredtrip count] > 0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
        //tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
        tripsrd  *trip = [[tripsrd alloc]initWithNibName:@"tripsrd" bundle:nil];
        trip.pagefrom=@"my";
        trip.isexpired=@"Y";
        trip.tripid=[[arrexpiredtrip objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:trip animated:NO];
        }
    }
    if(indexPath.section == 3)
    {
        if([arrcompleted count] > 0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
        tripitemsvc *titem=[[tripitemsvc alloc]initWithNibName:@"tripitemsvc" bundle:nil];
        titem.tripid=[[arrcompleted objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:titem animated:NO];
        }
    }
    if(indexPath.section == 4)
    {
        if([arrcanceled count] > 0)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
        //tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
        tripsrd  *trip = [[tripsrd alloc]initWithNibName:@"tripsrd" bundle:nil];        
        trip.pagefrom=@"my";
        trip.isexpired=@"Y";
        trip.tripid=[[arrcanceled objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:trip animated:NO];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
