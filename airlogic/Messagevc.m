 //
//  Messagevc.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "Messagevc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SCLAlertView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"



#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f



@interface Messagevc ()

@end

@implementation Messagevc
int msgpageindex=1;
@synthesize inputToolbar,itemid,tripid,touserid,arrdata,msgstatus;
- (void)loadView
{
    [super loadView];
    self.title=@"Message";
    NSLog(@"my item id %@",itemid);
    keyboardIsVisible = NO;
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:screenFrame];
    UIImageView *img =[[UIImageView alloc]init];
    [img setImage:[UIImage imageNamed:@"background.png"]];
    img.frame=CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height);
    [self.view addSubview:img];
    
    
    tblmessage = [[UITableView alloc]init];
    tblmessage.frame = self.view.bounds;
    tblmessage.frame= CGRectMake(5, 65, self.view.frame.size.width-10,self.view.frame.size.height-60);
    [self.view addSubview:tblmessage];
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor whiteColor];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"
                                                                attributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithAttributedString:title];
    
    
    [tblmessage addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //self.view.backgroundColor = [UIColor clearColor];
    /* Create toolbar */
    
   
    
    if([msgstatus isEqualToString:@"Completed"] || [msgstatus isEqualToString:@"Cancelled"])
    {
        
    }
    else
    {
        self.inputToolbar = [[BHInputToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-(kDefaultToolbarHeight-20), screenFrame.size.width, kDefaultToolbarHeight)];
        [self.view addSubview:self.inputToolbar];
        inputToolbar.backgroundColor=[UIColor whiteColor];
        inputToolbar.textView.textColor= [UIColor blackColor];
        inputToolbar.textView.font=[UIFont fontWithName:@"Roboto-Light" size:13];
        inputToolbar.inputDelegate = self;
        inputToolbar.textView.placeholder = @"Write Message";
    }
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
        responseData = [NSMutableData data];
        arrdata=[[NSMutableArray alloc]init];
    
    
        tblmessage.hidden=YES;
        tblmessage.dataSource=self;
        tblmessage.delegate=self;
        tblmessage.tableFooterView= [[UIView alloc]init];
        tblmessage.backgroundColor=[UIColor clearColor];
        tblmessage.allowsSelection = NO;
        tblmessage.separatorStyle=UITableViewCellSeparatorStyleNone;
    
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"getmessageconversation"];
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:touserid forKey:@"fromid"];
        [postdata setObject:delegate.struserid forKey:@"toid"];
        [postdata setObject:tripid forKey:@"tripid"];
        [postdata setObject:itemid forKey:@"itemid"];
    
    
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

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Message Conversation Screen";
    [super viewDidAppear:animated];
}
- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getmessageconversation"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:touserid forKey:@"fromid"];
    [postdata setObject:delegate.struserid forKey:@"toid"];
    [postdata setObject:tripid forKey:@"tripid"];
    [postdata setObject:itemid forKey:@"itemid"];
    
    
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
- (void)viewWillAppear:(BOOL)animated
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
    
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
            arrdata = [deserializedData objectForKey:@"data"];            
        }
        else
        {
            [self removeProgressIndicator];
            
        }
        
    }
    if(connection == sendmsgconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"getmessageconversation"];
            NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
            [postdata setObject:touserid forKey:@"fromid"];
            [postdata setObject:delegate.struserid forKey:@"toid"];
            [postdata setObject:tripid forKey:@"tripid"];
            [postdata setObject:itemid forKey:@"itemid"];
            
            
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
            [self removeProgressIndicator];
            
        }
        
    }
    NSLog(@"%@",arrdata);
    if(arrdata.count > 0)
    {
        viewerror.hidden=YES;
       [viewerror removeFromSuperview];
       tblmessage.hidden=NO;
       [tblmessage reloadData];
    }
    else
    {
        viewerror.frame=CGRectMake(0,self.view.frame.size.height/3, self.view.frame.size.width, viewerror.frame.size.height);
        [self.view addSubview:viewerror];
    }
    [self removeProgressIndicator];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect r = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        r.origin.y = screenFrame.size.height - self.inputToolbar.frame.size.height - kStatusBarHeight+10;
        if (keyboardIsVisible) {
            r.origin.y -= kKeyboardHeightPortrait;
        }
        [self.inputToolbar.textView setMaximumNumberOfLines:13];
    }
    else
    {
        r.origin.y = screenFrame.size.width - self.inputToolbar.frame.size.height - kStatusBarHeight;
        if (keyboardIsVisible) {
            r.origin.y -= kKeyboardHeightLandscape;
        }
        [self.inputToolbar.textView setMaximumNumberOfLines:7];
        [self.inputToolbar.textView sizeToFit];
    }
    self.inputToolbar.frame = r;
}
#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height - kKeyboardHeightPortrait;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight-10;
    }
    
    self.inputToolbar.frame = frame;
    self.inputToolbar.backgroundColor=[UIColor whiteColor];
    self.inputToolbar.textView.textColor= [UIColor blackColor];
    [UIView commitAnimations];
    keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = self.view.frame.size.width - frame.size.height;
    }
    self.inputToolbar.frame = frame;
    self.inputToolbar.backgroundColor=[UIColor whiteColor];
    self.inputToolbar.textView.textColor= [UIColor blackColor];
    [UIView commitAnimations];
    keyboardIsVisible = NO;
}

-(void)inputButtonPressed:(NSString *)inputText
{
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"sendmessage"];
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"fromuserid"];
    [postdata setObject:touserid forKey:@"touserid"];
    [postdata setObject:inputText forKey:@"message"];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
    [postdata setObject:@"1" forKey:@"type"];
    }
    else
    {
         [postdata setObject:@"0" forKey:@"type"];
    }
    [postdata setObject:tripid forKey:@"tripid"];
    [postdata setObject:itemid forKey:@"itemid"];
    
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        
        sendmsgconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    /* Called when toolbar button is pressed */
    NSLog(@"Pressed button with text: '%@'", inputText);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrdata count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
       // cell.backgroundColor =[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
        cell.backgroundColor =[UIColor clearColor];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize messageSize = [PTSMessagingCell messageSize:[[arrdata objectAtIndex:indexPath.row]valueForKey:@"message"]];
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
//    
//    if (indexPath.row % 2 == 0) {
//        ccell.sent = YES;
//        ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
//    } else {
//        ccell.sent = NO;
//        ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
//    }
    
    NSString *fromwho=[[arrdata objectAtIndex:indexPath.row]valueForKey:@"fromwho"];
    if([fromwho isEqualToString:delegate.struserid])
    {
        ccell.sent=YES;
    }
    else
    {
        ccell.sent=NO;
    }
    
    
    NSString *profileimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrdata objectAtIndex:indexPath.row]valueForKey:@"frompic"]];
    
    //ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
    
    [ccell.avatarImageView setImageWithURL:[NSURL URLWithString:profileimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   ccell.avatarImageView.layer.cornerRadius= ccell.avatarImageView.frame.size.width/2;
    ccell.avatarImageView.clipsToBounds=YES;
    
    
    
    NSString *text = [[arrdata objectAtIndex:indexPath.row]valueForKey:@"message"];
    
    ccell.messageLabel.text =text;
    
    
    NSString *dateString= [[arrdata objectAtIndex:indexPath.row]valueForKey:@"createdDate"];
    
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
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* localTime = [dateFormat stringFromDate:destinationDate];
  //  NSLog(@"your local time >> %@",localTime);
    
    
    ccell.timeLabel.text = localTime;
}

-(void)viewDidDisappear:(BOOL)animated
{
    touserid=@"";
    itemid=@"";
    tripid=@"";
}


@end
