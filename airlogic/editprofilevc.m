//
//  editprofilevc.m
//  airlogic
//
//  Created by APPLE on 01/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import "editprofilevc.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"
#import "DbHandler.h"
#import "mobileverification.h"
#import "emailverification.h"
#import "UIViewController+MJPopupViewController.h"
#import  "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DbHandler.h"
#import "SCLAlertView.h"
#import "uploadgovtidvc.h"
#import "tripitemsvc.h"


#define ACCEPTABLE_CHARECTERS @"0123456789."
@interface editprofilevc ()

@end

@implementation editprofilevc
@synthesize phoneno,pagefrom,tripid,phonecode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Edit Profile";
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    arrcountry=[[NSMutableArray alloc]init];
    arrstate=[[NSMutableArray alloc]init];
    arrcity= [[ NSMutableArray alloc]init];
    arrcode=[[NSMutableArray alloc]initWithObjects:@"India +91",@"United States +1", nil];
    isuploaded=@"N";
    
    UIToolbar* priceToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    priceToolbar.barStyle = UIBarStyleBlackOpaque;
    priceToolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad)],
                          nil];
    [priceToolbar sizeToFit];
    txtphone.inputAccessoryView = priceToolbar;
    
    
    UIToolbar* bankno = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    bankno.barStyle = UIBarStyleBlackOpaque;
    bankno.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearnopad)],
                          nil];
    [bankno sizeToFit];
    txtaccountno.inputAccessoryView = bankno;

    
    UIToolbar* ziptoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    ziptoolbar.barStyle = UIBarStyleBlackOpaque;
    ziptoolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearzipcodepad)],
                          nil];
    [ziptoolbar sizeToFit];
    txtzipcode.inputAccessoryView = ziptoolbar;
    
    UIToolbar* desctoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    desctoolbar.barStyle = UIBarStyleBlackOpaque;
    desctoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                         nil];
    [desctoolbar sizeToFit];
    txtdesc.inputAccessoryView = desctoolbar;
    
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)isValidURL
{
    BOOL isValidURL = NO;
    NSURL *candidateURL = [NSURL URLWithString:self];
    if (candidateURL && candidateURL.scheme && candidateURL.host)
        isValidURL = YES;
    return isValidURL;
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Edit Profile Screen";
    [super viewDidAppear:animated];
}
-(void)clearzipcodepad
{
    [txtzipcode resignFirstResponder];
}
-(void)clearpricepad
{
    [txtphone resignFirstResponder];
}
-(void)clearnopad
{
    [txtaccountno resignFirstResponder];
}
-(void)cleardescpad
{
    [txtdesc resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIImage *filterimg = [UIImage imageNamed:@"tick.png"];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addbtn setBackgroundImage:filterimg forState:UIControlStateNormal];
    
    addbtn.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:addbtn];
    
    [addbtn addTarget:self action:@selector(onbtnupdatelcick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem2];
    
    
    txtdesc.backgroundColor= [UIColor clearColor];
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, txtdesc.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Write something about yourself upto 160 characters"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    imgprofile.userInteractionEnabled=YES;
    
    
    imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
    imgprofile.clipsToBounds=YES;
    imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgprofile.layer.borderWidth = 2.0;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [viewflybee addGestureRecognizer:singleFingerTap];
    
    
    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSenderTap:)];
    [viewsender addGestureRecognizer:singleFingerTap1];
    
    
    UITapGestureRecognizer *imgtap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(imageclick:)];
    [imgprofile addGestureRecognizer:imgtap];

    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem ;
    
    // scrlview.frame= CGRectMake(0, 0, 320, 480);
    
    arrcountry = [DbHandler FetchCountry];
    
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, 1170);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,1110);
    [scrlview addSubview:profileview];
    
        
    if([isuploaded isEqualToString:@"N"])
    {
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getprofiledata?userid="];
    strurl=[strurl stringByAppendingString:delegate.struserid];
    
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
    //Do stuff here...
}

- (void)handleSenderTap:(UITapGestureRecognizer *)recognizer {
   // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if(![delegate.strusertype isEqualToString:@"Sender"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"Confirm" target:self selector:@selector(setsender)];
        alert.backgroundViewColor=[UIColor whiteColor];
        
        [alert showCustom:self image:[UIImage imageNamed:@"changemode.png"] color:[UIColor purpleColor] title:@"Change Account" subTitle:@"Do you want to be in Sender mode?" closeButtonTitle:@"Cancel" duration:0.0f];
    }
    
    //Do stuff here...
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
    
    //abhi rathi
    //
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

-(IBAction)onbtnflybeeclick:(id)sender
{
    strusertype=@"0";

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
    strusertype=@"1";
    
    if(![delegate.strusertype isEqualToString:@"Sender"])
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"Confirm" target:self selector:@selector(setsender)];
        alert.backgroundViewColor=[UIColor whiteColor];
        
        [alert showCustom:self image:[UIImage imageNamed:@"changemode.png"] color:[UIColor purpleColor] title:@"Custom" subTitle:@"Do you want to be in Sender mode?" closeButtonTitle:@"Cancel" duration:0.0f];
    }
}


- (void)imageclick:(UITapGestureRecognizer *)recognizer {
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    //Do stuff here...
}

-(IBAction)onbtneditclick:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        //controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    imgprofile.image=image;
    isuploaded=@"Y";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(IBAction)onbtnupdatelcick:(id)sender
{
   
    if(![txtfname.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"First name is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtlname.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Last name is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtcountry.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Country" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    if(![txtstate.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select State" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    if(![txtcity.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select City" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtzipcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Zip code is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    NSInteger length = [txtzipcode.text length];
    
    if([txtcountry.text isEqualToString:@"United States"])
    {
        if(length < 5 )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Zipcode must be of 5 digits." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
    }
    else if([txtcountry.text isEqualToString:@"India"])
    {
        if(length < 6 )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Zipcode must be of 6 digits." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
    }
    if(![txtcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Country Code" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if ([txtphone.text length]< 10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter 10 digit mobile no." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if([txtlinkedin.text length] > 0)
    {
    NSString *urlString = [NSString stringWithFormat:txtlinkedin.text];
    NSRange rangeValue = [urlString rangeOfString:@"https://www.linkedin.com/in/" options:NSCaseInsensitiveSearch];
        NSRange rangeValue1 = [urlString rangeOfString:@"https://in.linkedin.com/in/" options:NSCaseInsensitiveSearch];
    NSRange rangeValue3 = [urlString rangeOfString:@"http://www.linkedin.com/in/" options:NSCaseInsensitiveSearch];
         NSRange rangeValue2 = [urlString rangeOfString:@"http://in.linkedin.com/in/" options:NSCaseInsensitiveSearch];
        if (rangeValue.length > 0 || rangeValue1.length > 0 || rangeValue2.length > 0  || rangeValue3.length > 0 )
        {
            NSLog(@"string contains bla!");
            
         }
        else
        {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid LinkedIn URL" message:@"URL must https://www.linkedin.com/in/ or https://in.linkedin.com/in/" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
            
        }
        
        NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlPredic = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL isValidURL = [urlPredic evaluateWithObject:urlString];
    
    if(!isValidURL)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid LinkedIn URL." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    }
    
    
    if([strusertype length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Flybee or Sender." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    if([txtroutinno.text length] > 0)
    {
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([txtroutinno.text rangeOfCharacterFromSet:set].location == NSNotFound)
    {
        NSLog(@"NO SPECIAL CHARACTER");
    }
    else
    {
        NSLog(@"HAS SPECIAL CHARACTER");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Routine No. Must be alphanumeric without any special characters." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    }
    
    [txtfname resignFirstResponder];
    [txtlname resignFirstResponder];
    [txtcountry resignFirstResponder];
    [txtstate resignFirstResponder];
    [txtcity resignFirstResponder];
    [txtphone resignFirstResponder];
    [txtzipcode resignFirstResponder];
    [txtemail resignFirstResponder];
    [txtbank resignFirstResponder];
    [txtaccountno resignFirstResponder];
    [txtroutinno resignFirstResponder];
    [txtphone resignFirstResponder];
    [txtcode resignFirstResponder];
    
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"updateprofile"];
    
      strstateid= [DbHandler GetId: [NSString stringWithFormat:@"select state_id from statemaster where state_name='%@'",txtstate.text]];
     strcntryid= [DbHandler GetId: [NSString stringWithFormat:@"select country_id from countrymaster where country_name='%@'",txtcountry.text]];
    // strcityid=[DbHandler GetId: [NSString stringWithFormat:@"select city_id from citymaster where city_name='%@'",txtcity.text]];
    
    strcityid= txtcity.text;
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:txtfname.text forKey:@"firstname"];
    [postdata setObject:txtlname.text forKey:@"lastname"];
    [postdata setObject:strcntryid forKey:@"country"];
    [postdata setObject:strstateid forKey:@"state"];
    [postdata setObject:strcityid forKey:@"city"];
    [postdata setObject:txtdesc.text forKey:@"abtme"];
    [postdata setObject:strusertype forKey:@"usermode"];
    [postdata setObject:txtphone.text forKey:@"phoneno"];
    [postdata setObject:txtcode.text forKey:@"cntrycode"];
    [postdata setObject:txtlinkedin.text forKey:@"lnkinlink"];
    
    if([phoneno length ] > 0)
    {
    if(![txtphone.text isEqualToString:phoneno])
    {
        [postdata setObject:@"No" forKey:@"mobileverify"];
    }
else if(![txtcode.text isEqualToString:phonecode])
        {
            [postdata setObject:@"No" forKey:@"mobileverify"];
        }
    else
    {
        [postdata setObject:mobileverified forKey:@"mobileverify"];
    }
    }
    else
    {
        [postdata setObject:@"No" forKey:@"mobileverify"];
    }
    if([phonecode length ] > 0)
    {
        
    }
    else
    {
        [postdata setObject:@"No" forKey:@"mobileverify"];
    }
    [postdata setObject:txtemail.text forKey:@"email"];
    [postdata setObject:txtzipcode.text forKey:@"zipcode"];
    [postdata setObject:txtbank.text forKey:@"bankname"];
    [postdata setObject:txtaccountno.text forKey:@"accountno"];
    [postdata setObject:txtroutinno.text forKey:@"routingno"];
    
    if([isuploaded isEqualToString:@"Y"])
    {
        UIImage *profile=[self resizeImage:imgprofile.image resizeSize:CGSizeMake(800,800)];
        //UIImage *profile=imgprofile.image;

        [postdata setObject:profile forKey:@"profilepic"];
    }
    else
    {
     [postdata setObject:@"" forKey:@"profilepic"];
    }
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField  == txtphone)
    {
        NSInteger length = [txtphone.text length];
        if (length>9 && ![string isEqualToString:@""]) {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>10) {
                textField.text = [textField.text substringToIndex:10];
                
            }
        });
    }
    if(textField  == txtzipcode)
    {
        NSInteger length = [txtzipcode.text length];
        
         if([txtcountry.text isEqualToString:@"United States"])
         {
        if (length >5 && ![string isEqualToString:@""]) {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>5) {
                textField.text = [textField.text substringToIndex:5];
                
            }
        });
         }
       else  if([txtcountry.text isEqualToString:@"India"])
        {
            if (length >6 && ![string isEqualToString:@""]) {
                return NO;
            }
            // This code will provide protection if user copy and paste more then 10 digit text
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([textField.text length]>6) {
                    textField.text = [textField.text substringToIndex:6];
                    
                }
            });
        }
    }
    
    if(textField == txtzipcode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField == txtphone)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField == txtaccountno)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField  == txtcountry)
    {
        return NO;
    }
    if(textField  == txtstate)
    {
        return NO;
    }
//    if(textField  == txtcity)
//    {
//        return NO;
//    }
    if(textField  == txtcode)
    {
        return NO;
    }
    return YES;
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
        
        arrcountry= [DbHandler FetchCountry];
        
        NSDictionary *userdetail = [deserializedData objectForKey:@"data"];
        txtemail.text = [userdetail valueForKey:@"email"];
        txtzipcode.text= [userdetail valueForKey:@"zip"];
        txtcode.text=[userdetail valueForKey:@"countrycode"];
        txtphone.text=  [NSString stringWithFormat:@"%@",[userdetail valueForKey:@"phone"]];
        if([txtphone.text length] >0)
        {
            phoneno=[userdetail valueForKey:@"phone"];
            phonecode=[userdetail valueForKey:@"countrycode"];
        }
        txtbank.text=[userdetail valueForKey:@"bankname"];
        txtroutinno.text= [userdetail valueForKey:@"routing_number"];
        txtaccountno.text=[userdetail valueForKey:@"account_number"];
        txtlinkedin.text=[userdetail valueForKey:@"linkedinlink"];
        txtfname.text=[userdetail valueForKey:@"firstname"];
        txtlname.text=[userdetail valueForKey:@"lastname"];
        txtcountry.text=[userdetail valueForKey:@"country"];
        country=[userdetail valueForKey:@"country"];
        NSString *desc=[userdetail valueForKey:@"description"];
        if([desc length] == 0 || [desc isEqualToString:@""])
        {
           // placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, txtdesc.frame.size.width - 20.0, 34.0)];
            [placeholderLabel setText:@"Write something about yourself upto 160 characters"];
            // placeholderLabel is instance variable retained by view controller
            [placeholderLabel setBackgroundColor:[UIColor clearColor]];
            [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
            [placeholderLabel setTextColor:[UIColor lightGrayColor]];
            // textView is UITextView object you want add placeholder text to
            [txtdesc addSubview:placeholderLabel];
        }
        else
        {
        
        txtdesc.text=[userdetail valueForKey:@"description"];
        }
        userrating= [userdetail valueForKey:@"rating"];
        mobileverified= [userdetail valueForKey:@"mobileverified"];
        emailverified= [userdetail valueForKey:@"emailverified"];
        corpemail= [userdetail valueForKey:@"corpemail"];
        corpemailverified= [userdetail valueForKey:@"corpemailverified"];
        thumbprofilepic= [userdetail valueForKey:@"thumbprofilepic"];
        profilepic=[userdetail valueForKey:@"profilepic"];
        txtcity.text=[userdetail valueForKey:@"city"];
        city= [userdetail valueForKey:@"city"];
        txtstate.text= [userdetail valueForKey:@"state"];
        state= [userdetail valueForKey:@"state"];
        gender=[userdetail valueForKey:@"gender"];
        usertype=[userdetail valueForKey:@"usertype"];
        status=[userdetail valueForKey:@"status"];
        userid=[userdetail valueForKey:@"userid"];
        uploadid=[userdetail valueForKey:@"uploadid"];
        
        if([txtcountry.text length] > 0)
        {
        strcntryid= [DbHandler GetId: [NSString stringWithFormat:@"select country_id from countrymaster where country_name='%@'",txtcountry.text]];
        arrstate= [DbHandler FetchState:strcntryid];
        }
        
        if([txtstate.text length] > 0)
        {
        strstateid= [DbHandler GetId: [NSString stringWithFormat:@"select state_id from statemaster where state_name='%@'",txtstate.text]];
        arrcity= [DbHandler FetchCity:strstateid];
        }
                NSString *img =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",thumbprofilepic];
                
                [imgprofile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        if([usertype isEqualToString:@"Flybee"])
        {
            strusertype=@"0";
            [btnflybee setBackgroundImage:[UIImage imageNamed:@"flybee"] forState:UIControlStateNormal];
            [btnsender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
        else  if([usertype isEqualToString:@"Sender"])
        {
            strusertype=@"1";
            [btnsender setBackgroundImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
            [btnflybee setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
    if(connection == updconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            NSString *strtype =@"";
            
            if([strusertype isEqualToString:@"0"])
            {
                strtype=@"Flybee";
                delegate.strusertype=@"Flybee";
                [btnflybee setBackgroundImage:[UIImage imageNamed:@"flybee"] forState:UIControlStateNormal];
                [btnsender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
            }
            else
            {
                strtype=@"Sender";
                delegate.strusertype=@"Sender";
                [btnflybee setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btnsender setBackgroundImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
            }
            
            bool flg= [DbHandler updateuser:@"" city:@"" country:txtcountry.text emailid:txtemail.text firstname:txtfname.text gender:gender  lastname:txtlname.text phone:txtphone.text  state:txtstate.text status:status usertype:strtype zip:txtzipcode.text  userid:delegate.struserid thumbprofilepic:[deserializedData objectForKey:@"imgpath"]];
            if(flg)
            {
                if(![pagefrom isEqualToString:@"TI"])
                {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.45;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                transition.type = kCATransitionFromLeft;
                [transition setType:kCATransitionPush];
                transition.subtype = kCATransitionFromLeft;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    tripitemsvc *tripi = [[tripitemsvc alloc]initWithNibName:@"tripitemsvc" bundle:nil];
                    tripi.tripid=tripid;
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.45;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                    transition.type = kCATransitionFromLeft;
                    [transition setType:kCATransitionPush];
                    transition.subtype = kCATransitionFromLeft;
                    transition.delegate = self;
                    [self.navigationController.view.layer addAnimation:transition forKey:nil];
                    [self.navigationController pushViewController:tripi animated:NO];
                }
                
            }
        }
        else
        {
            [self removeProgressIndicator];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert showError:@"Error" subTitle:[deserializedData objectForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
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


-(void)pickerDoneClicked:(id)sender
{
    UIBarButtonItem *btn= (UIBarButtonItem*)sender;
    
    if(btn.tag==100)
    {
        if ([txtcountry.text isEqualToString:@""])
        {
            NSInteger row = [pckrcountry selectedRowInComponent:0];
            txtcountry.text = [arrcountry objectAtIndex:(NSUInteger)row];
            strcntryid= [DbHandler GetId: [NSString stringWithFormat:@"select country_id from countrymaster where country_name='%@'",txtcountry.text]];
            arrstate= [DbHandler FetchState:strcntryid];
        }
        if(![txtcountry.text isEqualToString:country])
        {
            txtstate.text=@"";
            txtzipcode.text=@"";
            txtcity.text=@"";
        }
        [txtcountry resignFirstResponder];
    }
    
    if(btn.tag==101)
    {
        if([arrstate count ] > 0)
        {
            if ([txtstate.text isEqualToString:@""])
            {
        NSInteger row = [pckrstate selectedRowInComponent:0];
        txtstate.text = [arrstate objectAtIndex:(NSUInteger)row];
        strstateid= [DbHandler GetId: [NSString stringWithFormat:@"select state_id from statemaster where state_name='%@'",txtstate.text]];
            arrcity= [DbHandler FetchCity:strstateid];
            }
        }
        
        if(![txtstate.text isEqualToString:state])
        {
            txtzipcode.text=@"";
            txtcity.text=@"";
        }
            
        [txtstate resignFirstResponder];
    }
    
//    if(btn.tag==102)
//    {
//        if([arrcity count ] > 0)
//        {
//            if ([txtcity.text isEqualToString:@""])
//            {
//            NSInteger row = [pckrcity selectedRowInComponent:0];
//            txtcity.text = [arrcity objectAtIndex:(NSUInteger)row];
//            strcityid=[DbHandler GetId: [NSString stringWithFormat:@"select city_id from citymaster where city_name='%@'",txtcity.text]];
//            }
//        }
//        if(![txtcity.text isEqualToString:city])
//        {
//            txtzipcode.text=@"";
//         }
//        [txtcity resignFirstResponder];
//    }
    
    if(btn.tag==103)
    {
        if ([txtcode.text isEqualToString:@""])
        {
            NSInteger row = [pckrcode selectedRowInComponent:0];
            txtcode.text = [arrcode objectAtIndex:(NSUInteger)row];
            
            NSString *code=txtcode.text;
            
            if([code isEqualToString:@"India +91"])
            {
                txtcode.text=@"+91";
            }
            else
            {
                txtcode.text=@"+1";
            }
        }
        [txtcode resignFirstResponder];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        return [arrcountry count];
    }
    if(pickerView.tag==101)
    {
        return [arrstate count];
    }
//    if(pickerView.tag==102)
//    {
//        return [arrcity count];
//    }
    if(pickerView.tag==103)
    {
        return [arrcode count];
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        return [arrcountry objectAtIndex:row];
    }
    
    if(pickerView.tag==101)
    {
        return [arrstate objectAtIndex:row];
    }
    
//    if(pickerView.tag==102)
//    {
//        return [arrcity objectAtIndex:row];
//    }
    
    if(pickerView.tag==103)
    {
        return [arrcode objectAtIndex:row];
    }
    return 0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        txtcountry.text = (NSString *)[arrcountry objectAtIndex:row];
        strcntryid= [DbHandler GetId: [NSString stringWithFormat:@"select country_id from countrymaster where country_name='%@'",txtcountry.text]];
        arrstate= [DbHandler FetchState:strcntryid];
    }
    if(pickerView.tag==101)
    {
        txtstate.text = (NSString *)[arrstate objectAtIndex:row];
        strstateid= [DbHandler GetId: [NSString stringWithFormat:@"select state_id from statemaster where state_name='%@'",txtstate.text]];
       // arrcity= [DbHandler FetchCity:strstateid];
    }
//    if(pickerView.tag==102)
//    {
//        txtcity.text = (NSString *)[arrcity objectAtIndex:row];
//        strcityid=[DbHandler GetId: [NSString stringWithFormat:@"select city_id from citymaster where city_name='%@'",txtcity.text]];
//    }
    if(pickerView.tag==103)
    {
        NSString *ccode=(NSString *)[arrcode objectAtIndex:row];
        
        if([ccode isEqualToString:@"India +91"])
        {
            txtcode.text=@"+91";
        }
        else
        {
            txtcode.text=@"+1";
        }

    }
}
-(void)SetPicker:(UIPickerView *)pcker txtfield:(UITextField *)txt tag:(NSInteger *)tagvalue title:(NSString *)lbl
{
    pcker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pcker.delegate = self;
    pcker.dataSource = self;
    [pcker setShowsSelectionIndicator:YES];
    txt.inputView = pcker;
    txt.layer.cornerRadius = 8;
    txt.font=[UIFont fontWithName:@"Roboto-Light" size:14];
    // Create done button in UIPickerView
    pcker.tag =tagvalue;
    
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 56)];
    
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    [mypickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 23)];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = lbl;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Roboto-Light" size:15];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    doneBtn.tag=tagvalue;
    
    
    [barItems addObject:toolBarTitle];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    
    txt.inputAccessoryView = mypickerToolbar;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtcountry)
    {
        [self SetPicker:pckrcountry  txtfield:txtcountry tag:100 title:@"Select Country"];
        if(![txtcountry.text isEqualToString:country])
        {
            txtstate.text=@"";
            txtzipcode.text=@"";
            txtcity.text=@"";
        }
        
        //[self animateTextField: textField up: YES];
    }
    if(textField == txtstate)
    {
        if(![strcntryid length] > 0)
        {
            [txtstate resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Country first to select state." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        else
        {
        [self SetPicker:pckrstate  txtfield:txtstate tag:101 title:@"Select State"];
        }
        //[self animateTextField: textField up: YES];
    }
    if(textField == txtcity)
    {
         [self animateTextField: textField up: YES];
//        if(![strstateid length] > 0)
//        {
//            [txtcity resignFirstResponder];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select State first to select city." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//            [alert show];
//            return;
//        }
//        else
//        {
//        [self SetPicker:pckrcity  txtfield:txtcity tag:102 title:@"Select City"];
//        }
        //[self animateTextField: textField up: YES];
    }
    if(textField == txtcode)
    {
        [self SetPicker:pckrcode  txtfield:txtcode tag:103 title:@"Select Country Code"];
    }
    if(textField == txtroutinno)
    {
        [self animateTextField: textField up: YES];
    }
    if(textField == txtaccountno)
    {
        [self animateTextField: textField up: YES];
    }
}

- (void) textViewDidChange:(UITextView *)theTextView
{
    if(![txtdesc hasText]) {
        [txtdesc addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    } else if ([[txtdesc subviews] containsObject:placeholderLabel]) {
        
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [placeholderLabel removeFromSuperview];
        }];
    }
}


- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![txtdesc hasText]) {
        [txtdesc addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


-(UIImage *) resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
    CGFloat actualHeight = orginalImage.size.height;
    CGFloat actualWidth = orginalImage.size.width;
    //  if(actualWidth <= size.width && actualHeight<=size.height)
    //  {
    //      return orginalImage;
    //  }
    float oldRatio = actualWidth/actualHeight;
    float newRatio = size.width/size.height;
    if(oldRatio < newRatio)
    {
        oldRatio = size.height/actualHeight;
        actualWidth = oldRatio * actualWidth;
        actualHeight = size.height;
    }
    else
    {
        oldRatio = size.width/actualWidth;
        actualHeight = oldRatio * actualHeight;
        actualWidth = size.width;
    }
    
    CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [orginalImage drawInRect:rect];
    orginalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return orginalImage;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 159)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == txtcity)
    {
        [self animateTextField: textField up: NO];
    }
    if(textField == txtaccountno)
    {
        [self animateTextField: textField up: NO];
    }
    
    if(textField == txtroutinno)
    {
        [self animateTextField: textField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(void)viewDidDisappear:(BOOL)animated
{
    pagefrom=@"";
    tripid=@"";
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
