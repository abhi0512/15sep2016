//
//  searchresultvc.m
//  airlogic
//
//  Created by APPLE on 20/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "searchresultvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "homeviewcell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "flybeehomeviewcellTableViewCell.h"
#import "tripdetailvc.h"
#import "SCLAlertView.h"
#import "emptycell.h"
#import "homeemptycell.h"
#import "itemdetailview.h"



#define LAZY_LOAD_PAGE_SIZE 5

@interface searchresultvc ()

@end

@implementation searchresultvc
@synthesize fromcity,fromdt,fromzipcode,tocity,todt,tozipcode,category,subcommercial,commerical,mutual,arrdata;

int currentpage=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Search Result";
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arrdata=[[NSMutableArray alloc]init];
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Search Result Screen";
    
    [super viewDidAppear:animated];
    
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
    
    tblview.backgroundColor=[UIColor clearColor];
    tblview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.lazyTableView.delegate=self;
    self.lazyTableView.dataSource=self;
    self.lazyTableView.lazyLoadEnabled=YES;
    self.lazyTableView.lazyLoadPageSize=LAZY_LOAD_PAGE_SIZE;
    self.lazyTableView.backgroundColor= [UIColor clearColor];
    
        NSString *strurl= [AppDelegate baseurl];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        strurl= [strurl stringByAppendingString:@"searchtrip"];
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"searchitems"];
    }
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:[NSString stringWithFormat:@"%d",currentpage] forKey:@"page"];
        [postdata setObject:[NSString stringWithFormat:@"%d",LAZY_LOAD_PAGE_SIZE] forKey:@"limit"];
        [postdata setObject:delegate.struserid forKey:@"userid"];
       if (!fromdt.length)
       {
        [postdata setObject:@"" forKey:@"fromdate"];
       }
       else
       {
           [postdata setObject:fromdt forKey:@"fromdate"];
       }
        if (!todt.length)
        {
         [postdata setObject:@"" forKey:@"todate"];
        }
        else
        {
        [postdata setObject:todt forKey:@"todate"];
        }
    if (!fromcity.length)
    {
        [postdata setObject:@"" forKey:@"fromcity"];
    }
    else
    {
        [postdata setObject:fromcity forKey:@"fromcity"];
    }
    if (!tocity.length)
    {
        [postdata setObject:@"" forKey:@"tocity"];
    }
    else
    {
        [postdata setObject:tocity forKey:@"tocity"];
    }
    
    if (!commerical.length)
    {
        [postdata setObject:@"" forKey:@"commercial"];
    }
    else
    {
        [postdata setObject:commerical forKey:@"commercial"];
    }
    
    if (!mutual.length)
    {
        [postdata setObject:@"" forKey:@"mutually"];
    }
    else
    {
        [postdata setObject:mutual forKey:@"mutually"];
    }
    
    if (!subcommercial.length)
    {
        [postdata setObject:@"" forKey:@"subcommercial"];
    }
    else
    {
        [postdata setObject:subcommercial forKey:@"subcommercial"];
    }

    if (!category.length)
    {
        [postdata setObject:@"" forKey:@"category"];
    }
    else
    {
        [postdata setObject:category forKey:@"category"];
    }
    
    
//       [postdata setObject:fromvol forKey:@"volumefrom"];
//       [postdata setObject:tovol forKey:@"volumeto"];
          
    
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
            NSArray *arr = [deserializedData objectForKey:@"data"];
            
            [arrdata addObjectsFromArray:arr];
            
        }
        else
        {
            [self removeProgressIndicator];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert addButton:@"OK" target:self selector:@selector(back)];
            [alert showCustom:self image:[UIImage imageNamed:@"error.png"] color:[UIColor orangeColor] title:@"Error" subTitle:[deserializedData objectForKey:@"response_message"]  closeButtonTitle:nil duration:0.0f];

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
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    NSLog(@"%@",arrdata);
    [self.lazyTableView reloadData];
    [self removeProgressIndicator];
}

#pragma mark- LazyLoad Table View

- (void)tableView:(UITableView *)tableView lazyLoadNextCursor:(int)cursor{
    //for instance here you can execute webservice request lo load more data
    currentpage++;
    [self addspinner];
    self.lazyTableView.tableFooterView = spinner;
    [self loaddata:currentpage];
    [self.lazyTableView reloadData];
}
#pragma mark- Table View
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrdata count ];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=0;
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        height= 130.0f;
    }
    else
    {
        height= 145.0f;
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
            //homecell.lbltripname.text= [NSString stringWithFormat:@"%@",[[arrdata objectAtIndex:\
            
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
            
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
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
            //NSString *tripdate =[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"tripdate"];
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrdata objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
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
        strurl= [strurl stringByAppendingString:@"searchtrip"];
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"searchitems"];
    }
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:[NSString stringWithFormat:@"%d",currentpage] forKey:@"page"];
    [postdata setObject:[NSString stringWithFormat:@"%d",LAZY_LOAD_PAGE_SIZE] forKey:@"limit"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    if (!fromdt.length)
    {
        [postdata setObject:@"" forKey:@"fromdate"];
    }
    else
    {
        [postdata setObject:fromdt forKey:@"fromdate"];
    }
    if (!todt.length)
    {
        [postdata setObject:@"" forKey:@"todate"];
    }
    else
    {
        [postdata setObject:todt forKey:@"todate"];
    }
    [postdata setObject:fromcity forKey:@"fromcity"];
    [postdata setObject:tocity forKey:@"tocity"];
    
    if (!commerical.length)
    {
        [postdata setObject:@"" forKey:@"commercial"];
    }
    else
    {
        [postdata setObject:commerical forKey:@"commercial"];
    }
    
    if (!mutual.length)
    {
        [postdata setObject:@"" forKey:@"mutually"];
    }
    else
    {
        [postdata setObject:mutual forKey:@"mutually"];
    }
    
    if (!subcommercial.length)
    {
        [postdata setObject:@"" forKey:@"subcommercial"];
    }
    else
    {
        [postdata setObject:subcommercial forKey:@"subcommercial"];
    }
    
    if (!category.length)
    {
        [postdata setObject:@"" forKey:@"category"];
    }
    else
    {
        [postdata setObject:category forKey:@"category"];
    }
    
    
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

-(void)viewDidDisappear:(BOOL)animated
{
    currentpage=1;
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
