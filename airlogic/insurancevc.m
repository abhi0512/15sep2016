//
//  insurancevc.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "insurancevc.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "DBHandler.h"
#import "insurancecell.h"
#import "itemsummary.h"
#import "myitemvc.h"
#import "AbhiHttpPOSTRequest.h"


@interface insurancevc ()

@end

@implementation insurancevc
 @synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Send Items";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    selectedins=@"0";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arrinsurance = [[NSMutableArray alloc] init];
    
    tblinsurance.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblinsurance.tableFooterView= [[UIView alloc]init];
    tblinsurance.backgroundColor= [UIColor clearColor];
    
    double itemcost  = [[DbHandler GetId:@"select itemcost from createitem"]doubleValue];
    
    if(itemcost > 500)
    {
        lblmsg.textAlignment=NSTextAlignmentLeft;
        tblinsurance.alpha=1;
        lblmsg.text=@"AIRLOGIQ provides the default insurance for 500$. If you need more insurance, please select the following";
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getinsurance"];
    
        NSString *cost =[DbHandler GetId:@"select itemcost from createitem"];
        
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:cost forKey:@"amount"];
        
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
    else
    {
        tblinsurance.alpha=0;
        selectedins=@"";
        insid=@"";
        lblmsg.textAlignment=NSTextAlignmentCenter;
        lblmsg.text=@"We do not take insurance less than 500$.";
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Items Insurance Screen";
    [super viewDidAppear:animated];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrinsurance count ];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    insurancecell *cell = (insurancecell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"insurancecell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdselection"]];
    }
    cell.lblname.text=[NSString stringWithFormat:@"%@",[[arrinsurance objectAtIndex:[indexPath row]]valueForKey:@"name"]];
    cell.lblcoverprice.text=[NSString stringWithFormat:@"Insurance Covered Price ($%@)",[[arrinsurance objectAtIndex:[indexPath row]]valueForKey:@"toprice"]];
     cell.lblpremiumprice.text=[NSString stringWithFormat:@"Insurance Premium Price ($%@)",[[arrinsurance objectAtIndex:[indexPath row]]valueForKey:@"amount"]];

    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do work for checkmark
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        uncheckCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdselection"]];
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
    }
    else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
        self.checkedIndexPath = indexPath;
        
        selectedins=[[arrinsurance objectAtIndex:indexPath.row]valueForKey:@"amount"];
        insid=[[arrinsurance objectAtIndex:indexPath.row]valueForKey:@"id"];
        //NSLog(@"selected is %@",[[arrvolume objectAtIndex:indexPath.row]valueForKey:@"name"]);
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(IBAction)onbtnitemdetailclick:(id)sender
{
    BOOL flg= [DbHandler UpdateItemInsurance:selectedins insid:insid];
    
    if(flg)
    {
        itemsummary *item = [[itemsummary alloc]initWithNibName:@"itemsummary" bundle:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:item animated:NO];
    }

}
-(IBAction)onbtncontinueclick:(id)sender
{
    myitemvc *itemdt = [[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:itemdt animated:NO];
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
            arrinsurance=[deserializedData objectForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if([arrinsurance count] > 0)
        {
            [tblinsurance reloadData];
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
