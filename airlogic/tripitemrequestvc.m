//
//  tripitemrequestvc.m
//  airlogic
//
//  Created by APPLE on 24/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "tripitemrequestvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SWRevealViewController.h"
#import "requestcell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "tripdetailvc.h"
#import "SCLAlertView.h"
#import "itemdetailview.h"
#import "emptycell.h"
#import "viewprofile.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

@interface tripitemrequestvc ()

@end

@implementation tripitemrequestvc
int segmentindex=0;
int bindex=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Interests sent/received";
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
     segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Send", @"Receive"]];
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
    [self.view addSubview:segmentedControl3];
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [tblview setBackgroundColor:[UIColor clearColor]];
    tblview.tableFooterView= [[UIView alloc]init];
    
    

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    segmentedControl3.selectedSegmentIndex=0;
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    [self FetchData:segmentindex];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /********** Using the default tracker **********/
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    /**********Manual screen recording**********/
    [tracker set:kGAIScreenName value:@"Trip/Item request"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    arrtrip=[[NSMutableArray alloc]init];

   // NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    //int index = segmentedControl.selectedSegmentIndex;
    segmentindex= segmentedControl.selectedSegmentIndex;
    [self FetchData:segmentindex];
}


-(void)FetchData:(int)index
{
     NSString *strurl= [AppDelegate baseurl];
    tblview.alpha=0;
 if(index==0)
 {
     if([delegate.strusertype isEqualToString:@"Sender"])
     {
         
         strurl= [strurl stringByAppendingString:@"getmytripsrequest"];
         NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
         [postdata setObject:delegate.struserid forKey:@"userid"];
         
         
         AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
         
         
         if([delegate isConnectedToNetwork])
         {
             [self addProgressIndicator];
             newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
             [alert show];
             return;
         }
     }
     else
     {
         strurl= [strurl stringByAppendingString:@"getmyitemsrequest"];
         NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
         [postdata setObject:delegate.struserid forKey:@"userid"];
         
         
         AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
         
         
         if([delegate isConnectedToNetwork])
         {
             [self addProgressIndicator];
             newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
             [alert show];
             return;
         }
     }
 }
    
  else if(index==1)
    {
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            
            strurl= [strurl stringByAppendingString:@"getitemrequest"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:delegate.struserid forKey:@"userid"];
            
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {   [self addProgressIndicator];
                newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                [alert show];
                return;
            }
        }
        else
        {
            strurl= [strurl stringByAppendingString:@"gettriprequest"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:delegate.struserid forKey:@"userid"];
            
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {
                [self addProgressIndicator];
                newconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
            tblview.alpha=1;
            arrtrip=[deserializedData valueForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
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
        
    }

    tblview.alpha=1;
    [tblview reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(arrtrip.count == 0)
    {
        return 1;
    }
    else
    {
        return arrtrip.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
//    {
//        return 200.0; // Expanded height
//    }
//    return 170.0f;
    
       int x =70.f;
 
        if(arrtrip.count>0)
        {
            x=140.0f;
        }
    return x;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
     UITableViewCell *cell;
    
    if(segmentindex==0)
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
                }
            rcell.lbl.text=@"Item Id:";
            rcell.lblid.text=[NSString stringWithFormat:@"I%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"touserid"]];
            rcell.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"];
            rcell.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
            rcell.txtmesage.editable=NO;
            rcell.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
            rcell.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            rcell.imgprofile.layer.cornerRadius= rcell.imgprofile.frame.size.width/2;
            rcell.imgprofile.clipsToBounds=YES;
            rcell.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
            [rcell.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                rcell.imgprofile.userInteractionEnabled = YES;
                rcell.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
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
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
                }
                ecell.lblmsg.text=@"No Trip Request Found.";
                cell=ecell;
            }
        }
        else
        {
            if(arrtrip.count> 0)
            {
                requestcell *rcell1 = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell1 == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                    rcell1 = [nib objectAtIndex:0];
                }
            rcell1.lbl.text=@"Trip Id:";
            rcell1.lblid.text=[NSString stringWithFormat:@"T%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            rcell1.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"];
            rcell1.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
            rcell1.txtmesage.editable=NO;
            rcell1.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                rcell1.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            rcell1.imgprofile.layer.cornerRadius= rcell1.imgprofile.frame.size.width/2;
            rcell1.imgprofile.clipsToBounds=YES;
             NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            rcell1.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
            [rcell1.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                
                rcell1.imgprofile.userInteractionEnabled = YES;
                rcell1.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
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
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
                }
                ecell.lblmsg.text=@"No Items Request Found.";
                cell=ecell;
            }

        }
    }
    
    else if(segmentindex==1)
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
                }
            rcell2.lbl.text=@"Item Id:";
            rcell2.lblid.text=[NSString stringWithFormat:@"I%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            rcell2.btncancel.hidden=YES;
            rcell2.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"itemname"];
            rcell2.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
            rcell2.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
            rcell2.txtmesage.editable=NO;

            rcell2.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                rcell2.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            rcell2.imgprofile.layer.cornerRadius= rcell2.imgprofile.frame.size.width/2;
            rcell2.imgprofile.clipsToBounds=YES;
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
                
            
            [rcell2.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                rcell2.imgprofile.userInteractionEnabled = YES;
                rcell2.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
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
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"emptycell" owner:self options:nil];
                    ecell = [nib objectAtIndex:0];
              }
                ecell.lblmsg.text=@"No Items Request Found.";
                cell=ecell;
            }
           
        }
        else
        {
            if(arrtrip.count> 0)
            {
                requestcell *rcell3 = (requestcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (rcell3 == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"requestcell" owner:self options:nil];
                    rcell3 = [nib objectAtIndex:0];
                }
            rcell3.lbl.text=@"Trip Id:";
            rcell3.lblid.text=[NSString stringWithFormat:@"T%@%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripid"],[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"userid"]];
            rcell3.btncancel.hidden=YES;
            rcell3.lbltripname.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"tripname"];
            rcell3.lblusername.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"username"];
            rcell3.lbldate.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"requestdate"];
            rcell3.txtmesage.editable=NO;

           rcell3.txtmesage.text=[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"message"];
                 rcell3.txtmesage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            rcell3.imgprofile.layer.cornerRadius= rcell3.imgprofile.frame.size.width/2;
            rcell3.imgprofile.clipsToBounds=YES;
            NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrtrip objectAtIndex:[indexPath row]]valueForKey:@"thumbprofilepic"]];
            
            [rcell3.imgprofile setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                rcell3.imgprofile.userInteractionEnabled = YES;
                rcell3.imgprofile.tag = indexPath.row;
                
                UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
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

-(void)myFunction :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSString *userid=@"";
   if(segmentindex==0)
    {
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            userid=[[arrtrip objectAtIndex:gesture.view.tag]valueForKey:@"userid"];
        }
        else
        {
           userid=[[arrtrip objectAtIndex:gesture.view.tag]valueForKey:@"userid"];
        }
    }
   else if(segmentindex == 1)
    {
        if([delegate.strusertype isEqualToString:@"Sender"])
        {
            userid=[[arrtrip objectAtIndex:gesture.view.tag]valueForKey:@"userid"];
        }
        else
        {
             userid=[[arrtrip objectAtIndex:gesture.view.tag]valueForKey:@"requestorid"];
        }
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    viewprofile *view = [[viewprofile alloc]initWithNibName:@"viewprofile" bundle:nil];
    view.userid=userid;
    [self.navigationController pushViewController:view animated:NO];

    
}
-(void)cancelclick:(UIButton *)sender
{
    UIButton *btnTemp = (UIButton *)sender;
    bindex=btnTemp.tag;
    
    
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
}
//code for dynamic cell expansion;
//[tableView beginUpdates]; // tell the table you're about to start making changes
//
//// If the index path of the currently expanded cell is the same as the index that
//// has just been tapped set the expanded index to nil so that there aren't any
//// expanded cells, otherwise, set the expanded index to the index that has just
//// been selected.
//if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
//    self.expandedIndexPath = nil;
//} else {
//    self.expandedIndexPath = indexPath;
//}
//
//[tableView endUpdates];
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
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

    if(segmentindex==1)
    {
        if([delegate.strusertype isEqualToString:@"Flybee"])
        {
            itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
            item.pagefrom=@"mi";
            item.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
            item.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
            item.requestid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"requestid"];
            [self.navigationController pushViewController:item animated:NO];
            
        }
        else
        {
            tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
            trip.pagefrom=@"mt";
            trip.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
            trip.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
            trip.requestid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"requestid"];
            [self.navigationController pushViewController:trip animated:NO];
            
        }
    }
   else if(segmentindex==0)
    {
        if([delegate.strusertype isEqualToString:@"Flybee"])
        {
            itemdetailview *item = [[itemdetailview alloc]initWithNibName:@"itemdetailview" bundle:nil];
            item.pagefrom=@"SR";
            item.itemid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"itemid"];
              [self.navigationController pushViewController:item animated:NO];
            
        }
        else
        {
            tripdetailvc *trip = [[tripdetailvc alloc]initWithNibName:@"tripdetailvc" bundle:nil];
            trip.pagefrom=@"SR";
            trip.tripid=[[arrtrip objectAtIndex:indexPath.row]valueForKey:@"tripid"];
            [self.navigationController pushViewController:trip animated:NO];
            
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    segmentindex=0;
    bindex=0;
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
