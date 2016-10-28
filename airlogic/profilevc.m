//
//  profilevc.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "profilevc.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MJPopupViewController.h"
#import "mobileverification.h"
#import "emailverification.h"
#import "SWRevealViewController.h"
#import "DbHandler.h"
#import  "intialview.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "editprofilevc.h"
#import  "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SCLAlertView.h"
#import "uploadgovtidvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "viewidimage.h"
#import "smsverificationvc.h"
#import "linkedinview.h"


@interface profilevc ()

@end

@implementation profilevc
@synthesize ismy,userid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"My Profile";
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];


    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"My Profile Screen";
    [super viewDidAppear:animated];
}
-(IBAction)onbtnlinkedinclick:(id)sender
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
-(void)viewWillAppear:(BOOL)animated
{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
  
    
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSenderTap:)];
    
    
    if(![ismy isEqualToString:@"No"])
    {
        [viewflybee addGestureRecognizer:singleFingerTap];
        [viewsender addGestureRecognizer:singleFingerTap1];
    }

    
    imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
    imgprofile.clipsToBounds=YES;
    imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgprofile.layer.borderWidth = 2.0;
    
    
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    
    
    UIImage *reviewimg = [UIImage imageNamed:@"icon_review.png"];
    
    UIButton *editprofile = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [editprofile setBackgroundImage:reviewimg forState:UIControlStateNormal];
    
    editprofile.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:editprofile];
    
    [editprofile addTarget:self action:@selector(editprofileclick) forControlEvents:UIControlEventTouchUpInside];
    
  
//        btncamera.alpha=1;
//        btnicon.alpha=1;
//        imgline.alpha=1;
        //viewverify.frame=CGRectMake(0, 625, self.view.frame.size.width, 176);
        lblbankdetail.frame=CGRectMake(8, 807, 80, 21);
        viewbankdetail.frame=CGRectMake(0, 835, self.view.frame.size.width, 160);
        
        scrlview.contentSize=CGSizeMake(self.view.frame.size.width, 1250);
        profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,1200);
        [scrlview addSubview:profileview];
   
    
    txtphone.userInteractionEnabled=NO;
    txtaccountno.userInteractionEnabled=NO;
    txtbank.userInteractionEnabled=NO;
    txtemail.userInteractionEnabled=NO;
    txtroutinno.userInteractionEnabled=NO;
    txtzipcode.userInteractionEnabled=NO;

    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getprofiledata?userid="];
    if([ismy isEqualToString:@"No"])
    {
         strurl=[strurl stringByAppendingString:userid];
         btnlogout.alpha=0;
    }
    else
    {
    btnlogout.alpha=1;
    strurl=[strurl stringByAppendingString:delegate.struserid];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem2];

    }
    
    
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
-(IBAction)btncameraclcik:(id)sender
{
     if([govtid isEqualToString:@"No"])
    {
        if([uploadid length] > 0)
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert showCustom:self image:[UIImage imageNamed:@"govt_id.png"] color:[UIColor orangeColor] title:@"Message" subTitle:@"Your Govt. ID is in process of verification." closeButtonTitle:@"OK" duration:0.0f];
        }
        else
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
         uploadgovtidvc *upload = [[uploadgovtidvc alloc]initWithNibName:@"uploadgovtidvc" bundle:nil];
           upload.pagefrom=@"Y";
          [self.navigationController pushViewController:upload animated:NO];
        }
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        viewidimage *vieimg = [[viewidimage alloc]initWithNibName:@"viewidimage" bundle:nil];
        vieimg.strurl=uploadid;
        [self.navigationController pushViewController:vieimg animated:NO];

    }
}

-(void)editprofileclick
{
    editprofilevc *edit = [[editprofilevc alloc]initWithNibName:@"editprofilevc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:edit animated:NO];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
   
    if(![delegate.strusertype isEqualToString:@"Flybee"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"Confirm" target:self selector:@selector(setflybee)];
        alert.backgroundViewColor=[UIColor whiteColor];
        
        [alert showCustom:self image:[UIImage imageNamed:@"changemode.png"] color:[UIColor orangeColor] title:@"Change Account" subTitle:@"Are you sure to change account as flybee." closeButtonTitle:@"Cancel" duration:0.0f];

    }
    
}

- (void)handleSenderTap:(UITapGestureRecognizer *)recognizer {
    
    if(![delegate.strusertype isEqualToString:@"Sender"])
    {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"Confirm" target:self selector:@selector(setsender)];
    alert.backgroundViewColor=[UIColor whiteColor];

    [alert showCustom:self image:[UIImage imageNamed:@"changemode.png"] color:[UIColor purpleColor] title:@"Change Account" subTitle:@"Do you want to be in Sender mode?" closeButtonTitle:@"Cancel" duration:0.0f];
    }
}

-(IBAction)onbtnflybeeclick:(id)sender
{
    if(![delegate.strusertype isEqualToString:@"Flybee"])
    {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"Confirm" target:self selector:@selector(setflybee)];
    alert.backgroundViewColor=[UIColor whiteColor];
    
    [alert showCustom:self image:[UIImage imageNamed:@"changemode.png"] color:[UIColor orangeColor] title:@"Custom" subTitle:@"Are you sure to change usertype as flybee." closeButtonTitle:@"Cancel" duration:0.0f];
    }
}
-(IBAction)onbtnsenderclick:(id)sender
{
    if(![delegate.strusertype isEqualToString:@"Sender"])
    {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"Confirm" target:self selector:@selector(setsender)];
    alert.backgroundViewColor=[UIColor whiteColor];
    
    [alert showCustom:self image:[UIImage imageNamed:@"changemode.mode"] color:[UIColor purpleColor] title:@"Custom" subTitle:@"Do you want to be in Sender mode?" closeButtonTitle:@"Cancel" duration:0.0f];
    }
}

-(IBAction)onbtnmobileverclick:(id)sender
{   
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    smsverificationvc *sms = [[smsverificationvc alloc]initWithNibName:@"smsverificationvc" bundle:nil];
    sms.pagefrom=@"P";
    sms.isfirst=@"N";
    sms.phoneno=strphoneno;
    sms.code=strcodeno;
    sms.userid= delegate.struserid;
    [self.navigationController pushViewController:sms animated:NO];
    
}
-(IBAction)onbtnemailverclick:(id)sender
{
    emailverification *email= [[emailverification alloc]initWithNibName:@"emailverification" bundle:nil];
    email.stremail=txtemail.text;
    email._delegate=self;
    
    [self presentPopupViewController:email animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        lblcity.text=[NSString stringWithFormat:@"%@ %@",[userdetail valueForKey:@"city"],[userdetail valueForKey:@"state"]];
        lblusername.text=[NSString stringWithFormat:@"%@ %@", [userdetail valueForKey:@"firstname"],[userdetail valueForKey:@"lastname"]];
        lblcountry.text=[userdetail valueForKey:@"country"];
        txtemail.text = [userdetail valueForKey:@"email"];
        txtzipcode.text= [userdetail valueForKey:@"zip"];
        txtphone.text= [NSString stringWithFormat:@"%@ %@",[userdetail valueForKey:@"countrycode"],[userdetail valueForKey:@"phone"]];
        strphoneno=[userdetail valueForKey:@"phone"];
        strcodeno=[userdetail valueForKey:@"countrycode"];
        txtbank.text=[userdetail valueForKey:@"bankname"];
        txtroutinno.text= [userdetail valueForKey:@"routing_number"];
        txtaccountno.text=[userdetail valueForKey:@"account_number"];
        mobileverified=[userdetail valueForKey:@"mobileverified"];
        emailverified=[userdetail valueForKey:@"emailverified"];
        linkverified=[userdetail valueForKey:@"linkedinverified"];
        [btnlinkedin setTitle:[userdetail valueForKey:@"linkedinlink"] forState:UIControlStateNormal];
        lnkurl=[userdetail valueForKey:@"linkedinlink"];
        uploadid=[userdetail valueForKey:@"uploadid"];
        govtid=[userdetail valueForKey:@"govtidverified"];
        lblpointearn.text= [NSString stringWithFormat:@"%@ (used)/%@ (total)",[userdetail valueForKey:@"pointredeem"],[userdetail valueForKey:@"pointearn"]];
        lblcurrency.text=[userdetail valueForKey:@"currency"];
        NSString *thumbprofilepic = [userdetail valueForKey:@"thumbprofilepic"];
        NSString *profilepic = [userdetail valueForKey:@"profilepic"];
         
        NSString *img=@"";
        NSString *logintype=[userdetail valueForKey:@"logintype"];
        img =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",thumbprofilepic];
         
//         
//         if(![logintype isEqualToString:@"Facebook"])
//         {
//          img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
//         }
//         else
//         {
//          img =[NSString stringWithFormat:@"%@",profilepic];
//         }
//        
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
        
        if([govtid isEqualToString:@"Yes"])
        {
            imguploadid.image= [UIImage imageNamed:@"tick"];
            imguploadid.alpha=1;
            [btncamera setTitle:@"View Govt. ID" forState:UIControlStateNormal];
            btncamera.userInteractionEnabled=YES;
            btnicon.userInteractionEnabled=YES;
        }
        else if([govtid isEqualToString:@"No"])
        {
            //imguploadid.alpha=0;
            btncamera.userInteractionEnabled=YES;
            btnicon.userInteractionEnabled=YES;
            if([uploadid length] > 0)
            {
                 imguploadid.image= [UIImage imageNamed:@"uploaded.png"];
                [btncamera setTitle:@"Govt. Id" forState:UIControlStateNormal];
            }
            else
            {
             imguploadid.image= [UIImage imageNamed:@"warning"];
            [btncamera setTitle:@"Upload Govt. Id" forState:UIControlStateNormal];
            }
          
        }
        if([usertype isEqualToString:@"Flybee"])
        {
            [btnflybee setBackgroundImage:[UIImage imageNamed:@"flybee"] forState:UIControlStateNormal];
            [btnsender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            
        }
        else  if([usertype isEqualToString:@"Sender"])
        {
          [btnsender setBackgroundImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
            [btnflybee setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if([emailverified isEqualToString:@"Yes"])
        {
            imgemail.alpha=1;
            imgemail.image= [UIImage imageNamed:@"tick"];
            btneicon.userInteractionEnabled=NO;
            btnemail.userInteractionEnabled=NO;
        }
        else
        {
            imgemail.alpha=1;
            imgemail.image= [UIImage imageNamed:@"warning"];
            btneicon.userInteractionEnabled=YES;
            btnemail.userInteractionEnabled=YES;
        }
        if([mobileverified isEqualToString:@"Yes"])
        {
            imgmobile.alpha=1;
            imgmobile.image= [UIImage imageNamed:@"tick"];
            btnphone.userInteractionEnabled=NO;
            btnpicon.userInteractionEnabled=NO;
        }
        else
        {
            imgmobile.alpha=1;
            imgmobile.image= [UIImage imageNamed:@"warning"];
            btnphone.userInteractionEnabled=YES;
            btnpicon.userInteractionEnabled=YES;
        }
        
        if(![lnkurl length ] > 0)
        {
            btnlinkedin.userInteractionEnabled=NO;
            btnlnk.userInteractionEnabled=NO;
            [btnlinkedin setTitle:@"Enter LinkedIn URL" forState:UIControlStateNormal];
            [btnlinkedin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            imglinkin.alpha=1;
            imglinkin.image= [UIImage imageNamed:@"warning"];
           }
        else
        {
            imglinkin.alpha=1;
            imglinkin.image= [UIImage imageNamed:@"tick"];
            btnlinkedin.userInteractionEnabled=YES;
            btnlnk.userInteractionEnabled=YES;
        }
        

        if([ismy isEqualToString:@"No"])
        {
            btneicon.userInteractionEnabled=NO;
            btnemail.userInteractionEnabled=NO;
            btnphone.userInteractionEnabled=NO;
            btnpicon.userInteractionEnabled=NO;
            btnlinkedin.userInteractionEnabled=NO;
            btnlnk.userInteractionEnabled=NO;
            btncamera.userInteractionEnabled=NO;
            btnicon.userInteractionEnabled=NO;
            btnsender.userInteractionEnabled=NO;
            btnflybee.userInteractionEnabled=NO;
        }
        
        //fdfd
    }
    else
    {
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    }
    if(connection == updconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            if([uploadid length] > 0)
            {
                imguploadid.alpha=1;
            }
            else
            {
                imguploadid.alpha=0;
            }

            if([strusertype isEqualToString:@"0"])
            {
                [btnflybee setBackgroundImage:[UIImage imageNamed:@"flybee"] forState:UIControlStateNormal];
                   [btnsender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            delegate.strusertype=@"Flybee";
                
                
                            }
            else
            {
                [btnflybee setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btnsender setBackgroundImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
                imguploadid.alpha=0;
            delegate.strusertype=@"Sender";
            }
            [DbHandler updateusertype:delegate.strusertype userid:delegate.struserid];
            [self removeProgressIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
        }
         else
        {
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        }
    }
    if(connection == verifyconn)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *strurl= [AppDelegate baseurl];
            strurl= [strurl stringByAppendingString:@"switchaccount?userid="];
            strurl=[strurl stringByAppendingString:delegate.struserid];
            strurl=[strurl stringByAppendingString:@"&usermode="];
            strurl=[strurl stringByAppendingString:strusertype];
            
                NSURL *url = [NSURL URLWithString:strurl];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                   timeoutInterval:120];
                if([delegate isConnectedToNetwork])
                {
                    [self addProgressIndicator];
                    updconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            
                [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
}
-(IBAction)onbtnlogoutclick:(id)sender
{
    [DbHandler deleteDatafromtable:@"delete from usermaster"];
    delegate.struserid=@"";
    delegate.username=@"";
    delegate.strusertype=@"";
    intialview *view = [[intialview alloc]initWithNibName:@"intialview" bundle:nil];
    [self.navigationController pushViewController:view animated:NO];
}

-(void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert.tag == 100)
    {
        if(buttonIndex ==1)
        {
            [btnsender setBackgroundImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
            [btnflybee setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];            
        }
        else if (buttonIndex ==0)
        {
        }
    }
    else if(alert.tag == 101)
    {
        if(buttonIndex ==1)
        {
            [btnsender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btnflybee setBackgroundImage:[UIImage imageNamed:@"flybee"] forState:UIControlStateNormal];
        }
        else if (buttonIndex ==0)
        {
        }
    }
}

-(void)setflybee
{
    strusertype=@"0";
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"checkuserverification"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:@"0" forKey:@"type"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        verifyconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }    
}
-(void)setsender
{
    strusertype=@"1";
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"checkuserverification"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:@"1" forKey:@"type"];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        
        verifyconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
}

-(void)mobileaccount:(id)controller didFinishEnteringItem:(NSString *)item
{
//    btnphone.userInteractionEnabled=NO;
//    btnpicon.userInteractionEnabled=NO;
//
    
    
}

- (void)emailaccount:(id)controller didFinishEnteringItem:(NSString *)item
{
    btnemail.userInteractionEnabled=NO;
    btneicon.userInteractionEnabled=NO;
}


-(void)dismissPopup
{
    mobileverification *mobile= [[mobileverification alloc]initWithNibName:@"mobileverification" bundle:nil];
    [self dismissPopupViewController:mobile animationType:MJPopupViewAnimationFade];
    
}
-(void)dismissemailPopup
{
    emailverification *email= [[emailverification alloc]initWithNibName:@"emailverification" bundle:nil];
    [self dismissPopupViewController:email animationType:MJPopupViewAnimationFade];

}
-(void)viewDidDisappear:(BOOL)animated
{
    ismy=@"";
    userid=@"";
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
