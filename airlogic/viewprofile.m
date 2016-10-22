
//
//  viewprofile.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "viewprofile.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import  "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "linkedinview.h"

@interface viewprofile ()

@end

@implementation viewprofile
@synthesize userid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Profile";
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Profile Screen";
    
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, 710);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,610);
    [scrlview addSubview:profileview];
    
    
    imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
    imgprofile.clipsToBounds=YES;
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getprofiledata?userid="];
    strurl=[strurl stringByAppendingString:userid];
    
    
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:120];
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        profileconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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

#pragma mark - Connection

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
    if(connection == profileconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSDictionary *userdetail = [deserializedData objectForKey:@"data"];
            
            lblusername.text=[NSString stringWithFormat:@"%@ %@", [userdetail valueForKey:@"firstname"],[userdetail valueForKey:@"lastname"]];
            lblcountry.text=[userdetail valueForKey:@"country"];
            lblzipcode.text= [userdetail valueForKey:@"zip"];
            mobileverified=[userdetail valueForKey:@"mobileverified"];
            emailverified=[userdetail valueForKey:@"emailverified"];
            linkverified=[userdetail valueForKey:@"linkedinverified"];
            lnkurl=[userdetail valueForKey:@"linkedinlink"];
            uploadid=[userdetail valueForKey:@"uploadid"];
            govtid=[userdetail valueForKey:@"govtidverified"];
            lblcity.text=[NSString stringWithFormat:@"%@ %@",[userdetail valueForKey:@"city"],[userdetail valueForKey:@"state"]];
            NSString *thumbprofilepic = [userdetail valueForKey:@"thumbprofilepic"];
            NSString *profilepic = [userdetail valueForKey:@"profilepic"];
            
            NSString *img=@"";
            NSString *logintype=[userdetail valueForKey:@"logintype"];
            img =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",thumbprofilepic];
            
//            if(![logintype isEqualToString:@"Facebook"])
//            {
//                img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
//            }
//            else
//            {
//                img =[NSString stringWithFormat:@"%@",profilepic];
//            }

            [imgprofile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            usertype=[userdetail valueForKey:@"usertype"];
            NSString *rating = [userdetail valueForKey:@"rating"];
            
            if([rating isEqualToString:@"1.0"])
            {
                imgstar1.image= [UIImage imageNamed:@"star.png"];
            }
            if([rating isEqualToString:@"2.0"])
            {
                imgstar1.image= [UIImage imageNamed:@"star.png"];
                imgstar2.image= [UIImage imageNamed:@"star.png"];
            }
            if([rating isEqualToString:@"3.0"])
            {
                imgstar1.image= [UIImage imageNamed:@"star.png"];
                imgstar2.image= [UIImage imageNamed:@"star.png"];
                imgstar3.image= [UIImage imageNamed:@"star.png"];
            }
            if([rating isEqualToString:@"4.0"])
            {
                imgstar1.image= [UIImage imageNamed:@"star.png"];
                imgstar2.image= [UIImage imageNamed:@"star.png"];
                imgstar3.image= [UIImage imageNamed:@"star.png"];
                imgstar4.image= [UIImage imageNamed:@"star.png"];
                
            }
            if([rating isEqualToString:@"5.0"])
            {
                imgstar1.image= [UIImage imageNamed:@"star.png"];
                imgstar2.image= [UIImage imageNamed:@"star.png"];
                imgstar3.image= [UIImage imageNamed:@"star.png"];
                imgstar4.image= [UIImage imageNamed:@"star.png"];
                imgstar5.image= [UIImage imageNamed:@"star.png"];
            }
            
            
            if([emailverified isEqualToString:@"Yes"])
            {
                imgemail.image= [UIImage imageNamed:@"tick"];
               
            }
            else
            {
                imgemail.image= [UIImage imageNamed:@"warning.png"];
            }
            if([mobileverified isEqualToString:@"Yes"])
            {
                imgmobile.alpha=1;
                imgmobile.image= [UIImage imageNamed:@"tick"];
            }
            else
            {
                imgmobile.alpha=1;
                imgmobile.image= [UIImage imageNamed:@"warning.png"];
            }
            if(![lnkurl length ] > 0)
            {
                imglinkin.alpha=0;
            }
            else
            {
                imglinkin.alpha=1;
                imglinkin.image= [UIImage imageNamed:@"tick"];
                [btnlink setTitle:lnkurl forState:UIControlStateNormal];
            }
            
            if([govtid isEqualToString:@"Yes"])
            {
                imguploadid.image= [UIImage imageNamed:@"tick"];
                imguploadid.alpha=1;
            }
            else
            {
                imguploadid.image= [UIImage imageNamed:@"warning.png"];
//                if([uploadid length] > 0)
//                {
//                    [btncamera setTitle:@"Govt. Id" forState:UIControlStateNormal];
//                }
//                else
//                {
//                    [btncamera setTitle:@"Upload Govt. Id" forState:UIControlStateNormal];
//                }
//                
            }
            if([usertype isEqualToString:@"Flybee"])
            {
                [btnusertype setBackgroundImage:[UIImage imageNamed:@"icon_flybee"] forState:UIControlStateNormal];
                lblusertype.text=@"Flybee";
                lbltext.text=@"Person who is flying and carrying the items.";
                lblusertype.textColor= [UIColor colorWithRed:247/255.0f green:148/255.0f blue:29/255.0f alpha:1.0];
                lbltext.textColor= [UIColor colorWithRed:247/255.0f green:148/255.0f blue:29/255.0f alpha:1.0];
            }
            else  if([usertype isEqualToString:@"Sender"])
            {
                [btnusertype setBackgroundImage:[UIImage imageNamed:@"icon_sender"] forState:UIControlStateNormal];
                lblusertype.text=@"Sender";
                lbltext.text=@"Person who want to send the items.";
                lblusertype.textColor= [UIColor colorWithRed:142/255.0f green:68/255.0f blue:173/255.0f alpha:1.0];
                lbltext.textColor= [UIColor colorWithRed:142/255.0f green:68/255.0f blue:173/255.0f alpha:1.0];
            }
            
    
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
}

-(IBAction)onbtnlinkclick:(id)sender
{
     if([lnkurl length ] > 0)
     {
    
    linkedinview *lnkin = [[linkedinview alloc]initWithNibName:@"linkedinview" bundle:nil];
    lnkin.strurl=lnkurl;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:lnkin animated:NO];
     }

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
