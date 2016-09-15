//
//  selectcategory.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "selectcategory.h"
#import <QuartzCore/QuartzCore.h>
#import "itemdetailvc.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "categorycell.h"
#import  "DBHandler.h"


@interface selectcategory ()

@end

@implementation selectcategory
 @synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arSelectedRows = [[NSMutableArray alloc] init];
    selectedcategory=@"";
    selectedcatid=@"";
    tblcategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblcategory.tableFooterView= [[UIView alloc]init];
    
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getcategories"];
    
    
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

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Items Category Screen";
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtncancelclick:(id)sender
{
    itemdetailvc *vc = [[itemdetailvc alloc]init];
    [vc dismissPopup];
}

-(IBAction)onbtnokclick:(id)sender
{
    itemdetailvc *vc = [[itemdetailvc alloc]init];
    
    
    if(!selectedcategory.length >0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select   Category." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    else
    {
        bool flg = [DbHandler UpdateItemCategory:selectedcategory categoryid:selectedcatid];
        [self.catdelegate addcategory:self didFinishEnteringItem:selectedcategory _catid:selectedcatid];
        [vc dismissPopup];
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrcategory count ];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
//        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
//        
//        if([arSelectedRows containsObject:indexPath])
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickcircle"]];
//            
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
//        }
    }
    
    cell.lbldesc.text=[NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"description"]];
    cell.lblcat.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"name"]];
    NSString *catimg =[NSString stringWithFormat:@"http://airlogiq.com/%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"icon"]];
    NSURL *Imgurl=[NSURL URLWithString:catimg];
    [cell.imgcat  sd_setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"]];
    
    return cell;

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
        
        selectedcategory=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"];
        selectedcatid=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"id"];
       
    }
}


//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if(cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickcircle"]];
//        
//        [arSelectedRows addObject:indexPath];
//    }
//    else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
//        
//        [arSelectedRows removeObject:indexPath];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

-(NSArray *)getSelections {
    NSMutableArray *selections = [[NSMutableArray alloc] init];
    
    for(NSIndexPath *indexPath in arSelectedRows) {
        [selections addObject:[arrcategory objectAtIndex:indexPath.row]];
    }
    
    return selections;
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
            arrcategory=[deserializedData objectForKey:@"data"];
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if([arrcategory count] > 0)
        {
            [tblcategory reloadData];
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
