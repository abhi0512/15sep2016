//
//  selectvolume.m
//  airlogic
//
//  Created by APPLE on 16/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "selectvolume.h"
#import <QuartzCore/QuartzCore.h>
#import "itemdetailvc.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "DBHandler.h"
#import "AbhiHttpPOSTRequest.h"

@interface selectvolume ()

@end

@implementation selectvolume;
 @synthesize checkedIndexPath,categoryid;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arrvolume = [[NSMutableArray alloc] init];
    
    tblvolume.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblvolume.tableFooterView= [[UIView alloc]init];
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getvolumesbycategory"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:categoryid forKey:@"categoryid"];
    if(![categoryid isEqualToString:@""])
    {
    
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

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrvolume count ];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
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
    
    
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Roboto-light" size:14]];
    cell.textLabel.text = [[arrvolume objectAtIndex:indexPath.row]valueForKey:@"name"];
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
        
        selectedvolume=[[arrvolume objectAtIndex:indexPath.row]valueForKey:@"name"];
        delegate.volname=[[arrvolume objectAtIndex:indexPath.row]valueForKey:@"name"];
         delegate.volid=[[arrvolume objectAtIndex:indexPath.row]valueForKey:@"id"];
        delegate.volprice=[[arrvolume objectAtIndex:indexPath.row]valueForKey:@"rate"];
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

-(IBAction)onbtnokclick:(id)sender
{
    itemdetailvc *vc = [[itemdetailvc alloc]init];
    bool flg = [DbHandler UpdateItemvolume:selectedvolume];
    
    [self.delegate addItemViewController:self didFinishEnteringItem:selectedvolume];
    
    if(!selectedvolume.length >0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select   Volume/Weight." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    else
    {
        }
}
-(IBAction)onbtncancelclick:(id)sender
{
    itemdetailvc *vc = [[itemdetailvc alloc]init];
    
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
            arrvolume=[deserializedData objectForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
    }
    if([arrvolume count] > 0)
    {
//        self.view.frame=CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,280,200);
//        tblvolume.frame=CGRectMake(tblvolume.frame.origin.x,tblvolume.frame.origin.y,tblvolume.frame.size.width,self.view.frame.size.height-50);
        
        [tblvolume reloadData];
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
