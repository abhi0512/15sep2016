//
//  myitemvc.m
//  airlogic
//
//  Created by APPLE on 26/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "myitemvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SWRevealViewController.h"
#import "createtripvc.h"
#import "flybeehomeviewcellTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "itemdetailview.h"
#import "emptycell.h"
#import "SCLAlertView.h"
#import "itemslist.h"
#import "itemsrd.h"


@interface myitemvc ()

@end

@implementation myitemvc
@synthesize arrdata,type;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"My Items";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [tblview setBackgroundColor:[UIColor clearColor]];
    arractiveitem = [[NSMutableArray alloc]init];
    arrexpireditem = [[NSMutableArray alloc]init];
    arrpendingitem=[[NSMutableArray alloc]init];
    arrcompleted=[[NSMutableArray alloc]init];
    arrcanceled=[[NSMutableArray alloc]init];
    
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
    
    self.screenName = @"My Items Screen";
    
    [super viewDidAppear:animated];
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
        type=@"0";
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
        SCLAlertView *network = [[SCLAlertView alloc] init];
        network.backgroundViewColor=[UIColor whiteColor];
        [network showCustom:self image:[UIImage imageNamed:@"No-Data.png"] color:[UIColor orangeColor] title:@"No Internet !" subTitle:@"No working Internet connection is found.Try Again."  closeButtonTitle:@"OK" duration:0.0f];
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
    
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
        type=@"0";
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
            arractiveitem = [[deserializedData objectForKey:@"data"]valueForKey:@"active"];
            arrpendingitem=[[deserializedData objectForKey:@"data"]valueForKey:@"pending"];
            arrexpireditem=[[deserializedData objectForKey:@"data"]valueForKey:@"expired"];
            arrcompleted= [[deserializedData objectForKey:@"data"]valueForKey:@"completed"];
            arrcanceled=[[deserializedData objectForKey:@"data"]valueForKey:@"cancelled"];
        }
        else
        {
            [self removeProgressIndicator];
//            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            alert.backgroundViewColor=[UIColor whiteColor];
//            
//            [alert showCustom:self image:[UIImage imageNamed:@""] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
        
    }
    tblview.hidden=NO;
    [tblview reloadData];
    [self removeProgressIndicator];
}



- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor= [UIColor clearColor];
    
    UIView *whiteview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 125)];
    
    whiteview.layer.masksToBounds=false;
    whiteview.layer.cornerRadius=2.0;
    whiteview.layer.shadowOffset=CGSizeMake(-1, 1);
    whiteview.layer.shadowOpacity=0.2;
    
    [cell.contentView addSubview:whiteview];
    [cell.contentView sendSubviewToBack:whiteview];
    
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
        if(arractiveitem.count == 0)
        {
            return 1;
        }
        else
        {
            return arractiveitem.count;
        }
    }
    if(section ==1)
    {
        if(arrpendingitem.count == 0)
        {
            return 1;
        }
        else
        {
            return arrpendingitem.count;
        }
    }
    if(section ==2)
    {
        if(arrexpireditem.count == 0)
        {
            return 1;
        }
        else
        {
            return arrexpireditem.count;
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
        
        title = @"Active Item";
        
    }
    else if(section == 1)
    {
        
        title = @"Pending Item";
        
    }
    else if(section == 2)
    {
        
        title = @"Expired Item";
        
    }
    else if(section == 3)
    {
        
        title = @"Completed Item";
        
    }
    
    else if(section == 4)
    {
        
        title = @"Cancelled Item";
        
    }
    
    headerview=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 18)];
    lbl.text=title;
    lbl.font= [UIFont fontWithName:@"Roboto-Bold" size:15];
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
        if(arractiveitem.count>0)
        {
            x=145.0f;
        }
    }
    if(indexPath.section==1)
    {
        
        if(arrpendingitem.count >0)
        {
            x=145.0f;
        }
    }
    if(indexPath.section==2)
    {
        if(arrexpireditem.count >0)
        {
            x=145.0f;
        }
        
    }
    if(indexPath.section==3)
    {
        if(arrcompleted.count >0)
        {
            x=145.0f;
        }
        
    }
    if(indexPath.section==4)
    {
        if(arrcanceled.count >0)
        {
            x=145.0f;
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
        if(arractiveitem.count> 0)
        {
            
            flybeehomeviewcellTableViewCell *acell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (acell == nil)
            {
                acell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
                acell = [nib objectAtIndex:0];
            }
            
            //commented by abhi to not show requestor id 19 aug.
            
            
            //acell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"itemname"]];
//            acell.lblid.text=@"Request Id:";
//            acell.lblid.frame=CGRectMake(72, 6, 67, 21);
//            acell.lbltripname.frame=CGRectMake(136, 6, 80, 21);
            //            // acell.lbltripname.text= [NSString stringWithFormat:@"R%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
            
            
            acell.lblid.frame=CGRectMake(72, 6, 50, 21);
            acell.lbltripname.frame=CGRectMake(117, 6, 80, 21);
            acell.lblid.text=@"Item Id:";
            acell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            
            acell.fromcity.text= [NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            acell.tocity.text= [NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            acell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            acell.lblweight.text=[NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
            acell.lbldate.text=[NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"trpdate"]];
            acell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
            
            //client want to show flybee date only .
            acell.lblto.hidden=YES;
            acell.lbltodate.hidden=YES;
            
            acell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                acell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }

            
            
            NSString *ptype=[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
                NSString *pricelen= [NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
                
                if([pricelen length] > 2)
                {
                    acell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                    acell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
                }
                else if([pricelen length] == 2)
                {
                    acell.lblcur2.frame=CGRectMake(232, 11, 10, 21);
                    acell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
                }
                else
                {
                    acell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                    acell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                }
                
                acell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            }
            else
            {
                acell.lblcur2.frame=CGRectMake(260, 14, 10, 21);
                acell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                acell.lblitemprice.text=@"0";
            }
            acell.lblcur2.hidden=YES;
            acell.lblitemprice.hidden=YES;
            
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arractiveitem objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
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
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Active Items Found.";
            cell=ecell;
        }
        
    }
    if(indexPath.section == 1)
    {
        
        if(arrpendingitem.count >0)
        {
            
            flybeehomeviewcellTableViewCell *pcell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (pcell == nil)
            {
                pcell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
                pcell = [nib objectAtIndex:0];
            }
           
            pcell.lblid.frame=CGRectMake(72, 6, 50, 21);
            pcell.lbltripname.frame=CGRectMake(117, 6, 80, 21);
            pcell.lblid.text=@"Item Id:";
            pcell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            pcell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            pcell.tocity.text= [NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            pcell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            pcell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
            pcell.lbldate.text=[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"fromdate"];
            pcell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
            pcell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            
            NSString *str= [[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                pcell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
            NSString *ptype=[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
                NSString *pricelen= [NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
                
                if([pricelen length] > 2)
                {
                    pcell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                    pcell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
                }
                else if([pricelen length] == 2)
                {
                    pcell.lblcur2.frame=CGRectMake(232, 11, 10, 21);
                    pcell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
                }
                else
                {
                    pcell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                    pcell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                }

                pcell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            }
            else
            {
                pcell.lblcur2.frame=CGRectMake(260, 14, 10, 21);
                pcell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                pcell.lblitemprice.text=@"0";
            }
            
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrpendingitem objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
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
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Pending Items Found.";
            cell=ecell;
            
        }
    }
    if(indexPath.section == 2)
    {
        if(arrexpireditem.count > 0)
        {
            
            flybeehomeviewcellTableViewCell *excell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (excell == nil)
            {
                excell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
                excell = [nib objectAtIndex:0];
            }
            
            excell.lblid.frame=CGRectMake(72, 6, 50, 21);
            excell.lbltripname.frame=CGRectMake(117, 6, 80, 21);
            excell.lblid.text=@"Item Id:";
            excell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            excell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            excell.tocity.text= [NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            excell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            excell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
             excell.lbldate.text=[NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"fromdate"]];
            excell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
            excell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                excell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
            NSString *ptype=[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
                NSString *pricelen= [NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
                if([pricelen length] > 2)
                {
                    excell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                    excell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
                }
                else if([pricelen length] == 2)
                {
                    excell.lblcur2.frame=CGRectMake(232, 11, 10, 21);
                    excell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
                }
                else
                {
                    excell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                    excell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                }

                excell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            }
            else
            {
                excell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                excell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                excell.lblitemprice.text=@"0";
            }
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrexpireditem objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
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
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Expired Items Found.";
            cell=ecell;
            
        }
    }
    if(indexPath.section == 3)
    {
        if(arrcompleted.count > 0)
        {
            
            flybeehomeviewcellTableViewCell *cocell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cocell == nil)
            {
                cocell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
                cocell = [nib objectAtIndex:0];
            }
            
            cocell.lblid.frame=CGRectMake(72, 6, 50, 21);
            cocell.lbltripname.frame=CGRectMake(117, 6, 80, 21);
            cocell.lblid.text=@"Item Id:";
            cocell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            
            
//            cocell.lblid.frame=CGRectMake(72, 6, 67, 21);
//            cocell.lbltripname.frame=CGRectMake(136, 6, 80, 21);
//            
//            cocell.lblid.text=@"Request Id:";
//            cocell.lbltripname.text= [NSString stringWithFormat:@"R%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"requestid"]];
            cocell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            cocell.tocity.text= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            cocell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            cocell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
            cocell.lbldate.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"fromdate"]];
            cocell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
             cocell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
              cocell.lbldate.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"trpdate"]];
            
            cocell.lblto.hidden=YES;
            cocell.lbltodate.hidden=YES;
            
            NSString *str= [[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                cocell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }

            
            NSString *ptype=[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
                NSString *pricelen= [NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
                if([pricelen length] > 2)
                {
                    cocell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                    cocell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
                }
                else if([pricelen length] == 2)
                {
                    cocell.lblcur2.frame=CGRectMake(232, 11, 10, 21);
                    cocell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
                }
                else
                {
                    cocell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                    cocell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                }

                

                cocell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            }
            else
            {
                cocell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                cocell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);

                cocell.lblitemprice.text=@"0";
            }
           
            
            cocell.lblcur2.hidden=YES;
            cocell.lblitemprice.hidden=YES;
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrcompleted objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
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
                ecell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                ecell = [nib objectAtIndex:0];
            }
            ecell.lblmsg.text=@"No Completed Items Found.";
            cell=ecell;
        }
    }
    if(indexPath.section == 4)
    {
        if(arrcanceled.count > 0)
        {
            
            flybeehomeviewcellTableViewCell *cacell = (flybeehomeviewcellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cacell == nil)
            {
                cacell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"flybeehomeviewcellTableViewCell" owner:self options:nil];
                cacell = [nib objectAtIndex:0];
            }
            cacell.lblid.frame=CGRectMake(72, 6, 50, 21);
            cacell.lbltripname.frame=CGRectMake(117, 6, 80, 21);
            cacell.lblid.text=@"Item Id:";
            cacell.lbltripname.text= [NSString stringWithFormat:@"I%@%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"id"],[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            cacell.fromcity.text= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"fromcity"]];
            cacell.tocity.text= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"tocity"]];
            cacell.lblvolume.text=[NSString stringWithFormat:@"%@inch",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"volume"]];
            cacell.lblweight.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"weight"]];
            cacell.lbldate.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"fromdate"]];
            cacell.lbltodate.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"todate"]];
            cacell.lblrating.text=[NSString stringWithFormat:@"%@ Star",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"rating"]];
            
            NSString *str= [[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"rating"];
            if([str isEqualToString:@"0"])
            {
                cacell.imgstar.image=[UIImage imageNamed:@"emptystar.png"];
            }
            
            NSString *ptype=[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"mutually_agreed"];
            if(![ptype isEqualToString:@"Yes"])
            {
                NSString *pricelen= [NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
                if([pricelen length] > 2)
                {
                    cacell.lblcur2.frame=CGRectMake(204, 14, 10, 21);
                    cacell.lblitemprice.frame=CGRectMake(210, -6, 92, 77);
                }
                else if([pricelen length] == 2)
                {
                    cacell.lblcur2.frame=CGRectMake(232, 11, 10, 21);
                    cacell.lblitemprice.frame=CGRectMake(235, -6, 70, 77);
                }
                else
                {
                    cacell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                    cacell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);
                }
                cacell.lblitemprice.text=[NSString stringWithFormat:@"%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"itemprice"]];
            }
            else
            {
                cacell.lblcur2.frame=CGRectMake(260, 11, 10, 21);
                cacell.lblitemprice.frame=CGRectMake(267, -6, 35, 77);

                cacell.lblitemprice.text=@"0";
            }
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrcanceled objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
            [cacell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cacell.imgprofile.layer.cornerRadius= cacell.imgprofile.frame.size.width/2;
            cacell.imgprofile.clipsToBounds=YES;
            cacell.imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            cacell.imgprofile.layer.borderWidth = 2.0;
            cell=cacell;
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
            ecell.lblmsg.text=@"No Cancelled Items Found.";
            cell=ecell;
        }
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    if(indexPath.section == 0)
    {
        if([arractiveitem count] > 0)
        {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        itemslist *ilist = [[itemslist alloc]initWithNibName:@"itemslist" bundle:nil];
        ilist.itemid=[[arractiveitem objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:ilist animated:NO];
        }
    }
    if(indexPath.section == 1)
    {
        if([arrpendingitem count] > 0)
        {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
       // itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
        itemsrd *item = [[itemsrd alloc]initWithNibName:@"itemsrd" bundle:nil];
        item.pagefrom=@"";
        item.isexpired=@"N";
        item.itemid=[[arrpendingitem objectAtIndex:indexPath.row]valueForKey:@"id"];
         [self.navigationController pushViewController:item animated:NO];
        }
    }
    if(indexPath.section == 2)
    {
        if([arrexpireditem count] > 0)
        {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
       // itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
        itemsrd *item = [[itemsrd alloc]initWithNibName:@"itemsrd" bundle:nil];        
        item.pagefrom=@"";
        item.isexpired=@"Y";
        item.itemid=[[arrexpireditem objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:item animated:NO];
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
        
        itemslist *ilist = [[itemslist alloc]initWithNibName:@"itemslist" bundle:nil];
        ilist.itemid=[[arrcompleted objectAtIndex:indexPath.row]valueForKey:@"id"];
        [self.navigationController pushViewController:ilist animated:NO];
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
        
        //itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
        itemsrd *item = [[itemsrd alloc]initWithNibName:@"itemsrd" bundle:nil];
        item.pagefrom=@"";
        item.isexpired=@"Y";
        item.itemid=[[arrcanceled objectAtIndex:indexPath.row]valueForKey:@"id"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
