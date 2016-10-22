//
//  createtripvc.m
//  airlogic
//
//  Created by APPLE on 21/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "createtripvc.h"
#import "categorycell.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DbHandler.h"
#import "infoview.h"
#import "UIViewController+MJPopupViewController.h"
#import "cancelcell.h"
#import "termsvc.h"
#import "cmspagevc.h"
#import "policyview.h"



#define ACCEPTABLE_CHARECTERS @"0123456789."
@interface createtripvc ()

@end
int catheight=65;
int cancelheight=50;
int bindexx=0;
@implementation createtripvc
@synthesize selectedString,strmutual,strcommercial,selectedpolicy;
@synthesize checkedIndexPath,fromcityid,tocityid,vol,paymenttype,itemcategory,_volid,ifromdt,itodt,_itemid,fromzip,tozip;
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Create Trip";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *valueToSave = @"no";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"onclick"];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    arSelectedRows = [[NSMutableArray alloc] init];
    
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, txtdesc.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Description upto 160 characters"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [txtdesc addSubview:placeholderLabel];
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    strcommercial=@"No";
    strmutual=@"No";
    
    UIToolbar* desctoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    desctoolbar.barStyle = UIBarStyleBlackOpaque;
    desctoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                         nil];
    [desctoolbar sizeToFit];
    txtdesc.inputAccessoryView = desctoolbar;
    
    
    UIToolbar* ziptoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    ziptoolbar.barStyle = UIBarStyleBlackOpaque;
    ziptoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearzippad)],
                         nil];
    [ziptoolbar sizeToFit];
    txtzipcode.inputAccessoryView = ziptoolbar;

    
    UIToolbar* toziptoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    toziptoolbar.barStyle = UIBarStyleBlackOpaque;
    toziptoolbar.items = [NSArray arrayWithObjects:
                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleartozippad)],
                        nil];
    [toziptoolbar sizeToFit];
    txttozipcode.inputAccessoryView = toziptoolbar;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Create Trip Screen";
    [super viewDidAppear:animated];
}
-(void)clearzippad{
    [txtzipcode resignFirstResponder];
}

-(void)cleartozippad{
    [txttozipcode resignFirstResponder];
}
-(void)cleardescpad{
    [txtdesc resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
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
-(void)viewWillAppear:(BOOL)animated
{

    
    NSString *strurl= [AppDelegate baseurl];
    
    if([_itemid length] >0)
    {
        strurl= [strurl stringByAppendingString:@"gettripcategory?tripid="];
        strurl=[strurl stringByAppendingString:_itemid];
        strurl= [strurl stringByAppendingString:@"&trip=1"];
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"getcategories"];
        
    }
    
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
    
    
    tblcategory.hidden=YES;
    tblcancelpolicy.hidden=YES;
    
    tblcategory = [[UITableView alloc]init];
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.dataSource=self;
    tblcategory.delegate=self;
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory.separatorColor=[UIColor grayColor];
    tblcategory.frame = self.view.bounds;
    tblcategory.tag=101;
    
    tblcancelpolicy = [[UITableView alloc]init];
    tblcancelpolicy.backgroundColor=[UIColor clearColor];
    tblcancelpolicy.dataSource=self;
    tblcancelpolicy.delegate=self;
    tblcancelpolicy.tableFooterView= [[UIView alloc]init];
    tblcancelpolicy.separatorColor=[UIColor grayColor];
    tblcancelpolicy.frame = self.view.bounds;
    tblcancelpolicy.tag=102;
    
    
    arrcategory = [[NSMutableArray alloc]init];
    arrcancelpolicy=[[NSMutableArray alloc]init];
    arrairport= [[NSMutableArray alloc]init];
    arrtoairport=[[NSMutableArray alloc]init];
    
    tblcategory.frame= CGRectMake(0, 460, self.view.frame.size.width,catheight);
    
    tblcancelpolicy.frame= CGRectMake(0, 555, self.view.frame.size.width,cancelheight);
    
    
    [profileview addSubview:tblcategory];
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:1];
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:+6];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    
    if([ifromdt length] > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *frdate = [dateFormat dateFromString:ifromdt];
        NSDate *tdate = [dateFormat dateFromString:itodt];
        datePicker.minimumDate=frdate;
        datePicker.maximumDate=tdate;
        
    }
    else
    {
        datePicker.minimumDate = tomorrow;
        datePicker.maximumDate=maxDate;
    }
    
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    [datePicker setLocale:locale];
    [txttripdate setInputView:datePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [txttripdate setInputAccessoryView:toolBar];
    
    timepicker=[[UIDatePicker alloc]init];
    timepicker.datePickerMode=UIDatePickerModeTime;
    timepicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    //timepicker.minimumDate = [NSDate date];
    [txttriptime setInputView:timepicker];
    UIToolbar *timetoolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 44)];
    [timetoolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *timedoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedTime)];
    UIBarButtonItem *timespace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [timetoolBar setItems:[NSArray arrayWithObjects:timespace,timedoneBtn, nil]];
    [txttriptime setInputAccessoryView:timetoolBar];
    
    if([fromcityid length] > 0)
    {
        txtfromairport.text= [DbHandler GetId:[NSString stringWithFormat:@"select (city_name ||','|| airport_name)as airport_name FROM airportmaster where city_id='%@'",fromcityid]];
        txtfromairport.userInteractionEnabled=NO;
        txtfromairport.textColor=[UIColor lightGrayColor];
    }
    else
    {
        arrairport= [DbHandler FetchAirport:txttoairport.text];
        txtfromairport.userInteractionEnabled=YES;
        txtfromairport.text=[arrairport objectAtIndex:0];
    }
    
    if([tocityid length] >0)
    {   
      NSString *airportname= [DbHandler GetId:[NSString stringWithFormat:@"select (city_name ||','|| airport_name) FROM airportmaster where city_id='%@'",tocityid]];
        txttoairport.text= [airportname stringByReplacingOccurrencesOfString:@"##" withString:@"'"];
        txttoairport.userInteractionEnabled=NO;
        txttoairport.textColor=[UIColor lightGrayColor];
    }
    else
    {
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where (city_name ||','|| airport_name) ='%@'",[arrairport objectAtIndex:0]]];
        arrtoairport=[DbHandler ToAirport:fromcntry];
        txttoairport.text=[arrtoairport objectAtIndex:0];
        txttoairport.userInteractionEnabled=YES;
        
    }
    
    if([fromzip length] > 0)
    {
        txtzipcode.text=fromzip;
        
    }
    else
    {
        txtzipcode.text=[DbHandler GetId:[NSString stringWithFormat:@"select zip from usermaster where id='%@'",delegate.struserid]];
        txtzipcode.userInteractionEnabled=YES;
    }
    
    if([tozip length] > 0)
    {
        txttozipcode.text=tozip;
        
    }
    else
    {
        txttozipcode.userInteractionEnabled=YES;
    }

}
-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    
    txttripdate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [txttripdate resignFirstResponder];
    
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"dd-MM-yyyy"];
    tripdt=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:datePicker.date]];
}
-(void)ShowSelectedTime
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    txttriptime.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:timepicker.date]];
    [txttriptime resignFirstResponder];    
}

-(void)setupview
{
    arrcancelpolicy=[DbHandler Fetchcancelpolicy];

    tblcategory.frame= CGRectMake(0,460,self.view.frame.size.width,catheight);
    
    volume = [[UIView alloc]initWithFrame:CGRectMake(0,catheight+20+460,self.view.frame.size.width,90)];
    volume.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl= [[UILabel alloc]initWithFrame:CGRectMake(8, 5, self.view.frame.size.width, 20)];
    lbl.text=@"Volumes & Weight";
    lbl.font= [UIFont fontWithName:@"Roboto-Light" size:14];
    lbl.textColor = [UIColor colorWithRed:247/255.0f green:148/255.0f blue:29/255.0f alpha:1.0];
    
    txtvolume= [[UITextField alloc]initWithFrame:CGRectMake(8, lbl.frame.size.height+5, 300, 25)];
    txtvolume.placeholder=@"Select Weight";
    txtvolume.font=[UIFont fontWithName:@"Roboto-Light" size:15];
    txtvolume.delegate=self;
    
    UIImageView *imgsep = [[UIImageView alloc]initWithFrame:CGRectMake(0, txtvolume.frame.origin.y+27, self.view.frame.size.width, 1)];
    imgsep.image=[UIImage imageNamed:@"line"];
    
    txtflightname= [[UITextField alloc]initWithFrame:CGRectMake(8, txtvolume.frame.origin.y+32, 300, 25)];
    txtflightname.userInteractionEnabled = YES;
    txtflightname.placeholder=@"Flight No. ( Ticket Source (optional))";
    txtflightname.font=[UIFont fontWithName:@"Roboto-Light" size:15];
    txtflightname.delegate=self;
    
    [volume addSubview:imgsep];
    [volume addSubview:lbl];
    [volume addSubview:txtvolume];
    [volume addSubview:txtflightname];
    
    UILabel *lblservice= [[UILabel alloc]initWithFrame:CGRectMake(8, volume.frame.origin.y+95,self.view.frame.size.width, 20)];
    lblservice.text=@"Payment Options";
    lblservice.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
    lblservice.textColor = [UIColor whiteColor];
    
   
     btnserviceinfo = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnserviceinfo setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
     btnserviceinfo.frame = CGRectMake(120,volume.frame.origin.y+95, 18, 18.0);
    [btnserviceinfo addTarget:self action:@selector(onbtnserviceclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewservice = [[UIView alloc]initWithFrame:CGRectMake(0,lblservice.frame.origin.y+20,self.view.frame.size.width,50)];
    viewservice.backgroundColor=[UIColor whiteColor];
    
    
    img1 = [[UIImageView alloc]initWithFrame:CGRectMake(10,12,25,25)];
    img1.image=[UIImage imageNamed:@"commercial_grey"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commercialtapDetected)];
    singleTap.numberOfTapsRequired = 1;
    
    [img1 setUserInteractionEnabled:YES];
    
    [img1 addGestureRecognizer:singleTap];
    
    
    UIButton *btncommercial = [UIButton buttonWithType:UIButtonTypeCustom];
    [btncommercial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btncommercial setTitle:@"Commercials" forState:UIControlStateNormal];
    btncommercial.titleLabel.font= [UIFont fontWithName:@"Roboto-Light" size:15];
    btncommercial.frame = CGRectMake(img1.frame.origin.x+2, 5, 150.0, 40.0);
    [btncommercial addTarget:self action:@selector(onbtncommercialpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewservice addSubview:btncommercial];
    
     img2 = [[UIImageView alloc]initWithFrame:CGRectMake(btncommercial.frame.origin.x+155,12,25,25)];
     img2.image=[UIImage imageNamed:@"mutuallygrey"];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mutualtapDetected)];
    singleTap1.numberOfTapsRequired = 1;
    
    [img2 setUserInteractionEnabled:YES];
    
    [img2 addGestureRecognizer:singleTap1];
    
    UIButton *btnmutual = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnmutual setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnmutual setTitle:@"Mutually Agreed" forState:UIControlStateNormal];
    btnmutual.titleLabel.font= [UIFont fontWithName:@"Roboto-Light" size:15];
    btnmutual.frame = CGRectMake(btncommercial.frame.origin.x+165, 5, 150.0, 40.0);
    [btnmutual addTarget:self action:@selector(onbtnmutualpressed:) forControlEvents:UIControlEventTouchUpInside];
    [viewservice addSubview:btnmutual];
    
    [viewservice addSubview:img1];
    [viewservice addSubview:img2];
   
    
  
    
    int cnt = [arrcancelpolicy count];
    cancelheight=cnt*50;
    if(![paymenttype isEqualToString:@"M"])
    {
        lblpolicy= [[UILabel alloc]initWithFrame:CGRectMake(8, viewservice.frame.origin.y+55, self.view.frame.size.width-150,20)];
        lblpolicy.text=@"Cancellation Policy";
        lblpolicy.font= [UIFont fontWithName:@"Roboto-Regular" size:13];
        lblpolicy.textColor = [UIColor whiteColor];
        
        
        btnpolciy = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnpolciy setBackgroundImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
        btnpolciy.frame = CGRectMake(135,viewservice.frame.origin.y+55,18,18.0);
        [btnpolciy addTarget:self action:@selector(btninfoclick:) forControlEvents:UIControlEventTouchUpInside];

    tblcancelpolicy.frame= CGRectMake(0, btnpolciy.frame.origin.y+25, self.view.frame.size.width,cancelheight);
    }
    
    
     checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"tickwithoutcircle"]
                        forState:UIControlStateNormal];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"tickcircle"]
                        forState:UIControlStateSelected];
    [checkbox setBackgroundImage:[UIImage imageNamed:@"tickcircle"]
                        forState:UIControlStateHighlighted];
    checkbox.adjustsImageWhenHighlighted=YES;
    [checkbox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    if(![paymenttype isEqualToString:@"M"])
    {
    checkbox.frame = CGRectMake(8, tblcancelpolicy.frame.origin.y+cancelheight+10, 20, 20);
    }
    else
    {
        checkbox.frame = CGRectMake(8, viewservice.frame.origin.y+55,20,20);
        
    }
    
    UIButton *btnchk1 = [UIButton buttonWithType:UIButtonTypeCustom];
   
    btnchk1.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnchk1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnchk1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnchk1 setTitle:@"I Agree to Terms and Conditions." forState:UIControlStateNormal];
    btnchk1.titleLabel.font= [UIFont fontWithName:@"Roboto-Light" size:13];
    btnchk1.frame = CGRectMake(checkbox.frame.origin.x+25, checkbox.frame.origin.y, 290.0, 20.0);
    [btnchk1 addTarget:self action:@selector(onbtntermsclick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *termsep = [[UIImageView alloc]initWithFrame:CGRectMake(btnchk1.frame.origin.x, btnchk1.frame.origin.y+20, 180, 1)];
    termsep.image=[UIImage imageNamed:@"line"];
    
    viewinfo = [[UIView alloc]initWithFrame:CGRectMake(0,btnchk1.frame.origin.y+30,self.view.frame.size.width,60)];
    viewinfo.backgroundColor=[UIColor colorWithRed:247/255.0f green:148/255.0f blue:29/255.0f alpha:1.0];
    
    UILabel *lblinfo= [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-270)/2,5,270,50)];
    lblinfo.text=@"Please email your tickets on email id:info@airlogiq.com to verify your trip.";
    lblinfo.numberOfLines=2;
    lblinfo.textAlignment=NSTextAlignmentCenter;
    lblinfo.font= [UIFont fontWithName:@"Roboto-Regular" size:15];
    lblinfo.textColor = [UIColor whiteColor];
    [viewinfo addSubview:lblinfo];
    
    
     btnsubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnsubmit setBackgroundImage:[UIImage imageNamed:@"btnorange"] forState:UIControlStateNormal];
    [btnsubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnsubmit setTitle:@"Submit" forState:UIControlStateNormal];
    btnsubmit.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    [btnsubmit addTarget:self action:@selector(onbtnsubmitclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float X_Co = (self.view.frame.size.width - 218)/2;
    [btnsubmit setFrame:CGRectMake(X_Co, viewinfo.frame.origin.y+80, 218, 34)];
    
    
    viewdetail.alpha=1;
    viewdesc.alpha=1;
    viewairport.alpha=1;
    lblairport.alpha=1;
    lblitem.alpha=1;
    [profileview addSubview:volume];
    [profileview addSubview:lblservice];
    [profileview addSubview:btnserviceinfo];
    [profileview addSubview:viewservice];
    [profileview addSubview:viewinfo];
    [profileview addSubview:btnsubmit];
    [profileview addSubview:lblpolicy];
    [profileview addSubview:checkbox];
    [profileview addSubview:btnchk1];
    [profileview addSubview:termsep];
    [profileview addSubview:btnpolciy];
    
    if([vol length] > 0)
    {
        txtvolume.text=vol;
        volumeid=_volid;
        txtvolume.userInteractionEnabled=NO;
        txtvolume.textColor=[UIColor lightGrayColor];
    }
    else
    {
        txtvolume.userInteractionEnabled=YES;
    }
    
    
    if([itemcategory length] >0)
    {
        tblcategory.allowsSelection = NO;
    }
    else
    {
        tblcategory.allowsSelection = YES;
    }
    if([paymenttype isEqualToString:@"C"])
    {
        strcommercial=@"Yes";
        strmutual=@"No";
        [img2 setImage:[UIImage imageNamed:@"mutuallygrey"]];
        [img1 setImage:[UIImage imageNamed:@"commercial"]];
        img2.userInteractionEnabled=NO;
        img1.userInteractionEnabled=NO;
        btncommercial.userInteractionEnabled=NO;
        btnmutual.userInteractionEnabled=NO;
    }
    
    else  if([paymenttype isEqualToString:@"M"])
    {
        strmutual=@"Yes";
        strcommercial=@"No";
        [img1 setImage:[UIImage imageNamed:@"commercial_grey"]];
        [img2 setImage:[UIImage imageNamed:@"mutually"]];
        img2.userInteractionEnabled=NO;
        img1.userInteractionEnabled=NO;
        btncommercial.userInteractionEnabled=NO;
        btnmutual.userInteractionEnabled=NO;
    }
    else
    {
        btncommercial.userInteractionEnabled=YES;
        btnmutual.userInteractionEnabled=YES;
        img1.userInteractionEnabled=YES;
        img2.userInteractionEnabled=YES;
    }

    if(![paymenttype isEqualToString:@"M"])
    {
        [profileview addSubview:tblcancelpolicy];
        
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+tblcancelpolicy.frame.size.height+volume.frame.size.height+viewservice.frame.size.height+viewinfo.frame.size.height+btnsubmit.frame.size.height+140);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+volume.frame.size.height+viewservice.frame.size.height+tblcancelpolicy.frame.size.height+viewinfo.frame.size.height+btnsubmit.frame.size.height+140);
    }
    else
    {
         scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+volume.frame.size.height+viewservice.frame.size.height+viewinfo.frame.size.height+btnsubmit.frame.size.height+140);
        profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+volume.frame.size.height+viewservice.frame.size.height+viewinfo.frame.size.height+btnsubmit.frame.size.height+140);
    }
    [scrlview addSubview:profileview];
}
-(IBAction)onbtntermsclick:(id)sender
{
    termsvc *info= [[termsvc alloc]initWithNibName:@"termsvc" bundle:nil];
    [self presentPopupViewController:info animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];
    
}
-(IBAction)onbtnserviceclick:(id)sender
{
    infoview *info= [[infoview alloc]initWithNibName:@"infoview" bundle:nil];
    [self presentPopupViewController:info animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];

}
-(void)checkboxSelected:(id)sender
{
    checkBoxSelected = !checkBoxSelected;
    [checkbox setSelected:checkBoxSelected];
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
        arrcategory=[deserializedData objectForKey:@"data"];
        int x =[arrcategory count];
          if([_itemid length]> 0)
          {
              catheight= 1*65;
          }
          else
          {
           catheight= 3*65;
          }
      }
      else
      {
        [self removeProgressIndicator];
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       }
       if([arrcategory count] > 0)
        {
        [self setupview];
        tblcategory.hidden=NO;
        tblcancelpolicy.hidden=NO;
        [tblcategory reloadData];
        }
       
      }
    if(connection == volconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        arrvolume=[[NSMutableArray alloc]init];
        txtvolume.text=@"";
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];

            arrkey = [[NSMutableArray alloc]init];
            
            NSArray *dataarray= [deserializedData objectForKey:@"data"];
            mutabledictionary = [[NSMutableDictionary alloc] init];
            
            for(int i=0;i< dataarray.count;i++)
            {
                
                [mutabledictionary setObject:[dataarray objectAtIndex:i]  forKey:[NSString stringWithFormat:@"%d",i]];
            }
            arrkey =[mutabledictionary allKeys];
            
            NSArray *sortedKeys = [mutabledictionary.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
            for (int i=0; i<[sortedKeys count]; i++)
            {
                [arrvolume addObject:[[mutabledictionary valueForKey:[sortedKeys objectAtIndex:i]]valueForKey:@"name"]];
                
            }
            NSLog(@"data for country >> %@",arrvolume);
            
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(connection == tripconn)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            mytriplistvc *mytrip = [[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
             CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:mytrip animated:NO];

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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblcategory)
    {
    return [arrcategory count ];
    }
    else if(tableView == tblcancelpolicy)
    {
        return [arrcancelpolicy count];
    }
    return  0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=0;
    if(tableView == tblcategory)
    {
       height=65.0f;
    }
    else if(tableView == tblcancelpolicy)
    {
        height=50.0f;
    }
    return  height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell;
    if(tableView == tblcategory)
    {
    categorycell *catcell = (categorycell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categorycell" owner:self options:nil];
        catcell = [nib objectAtIndex:0];
        
        NSString *cname=[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"name"];
        
        {
            catcell.accessoryType = UITableViewCellAccessoryCheckmark;
            catcell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
            
           
        }
        
        if([cname isEqualToString:itemcategory])
        {
            catcell.accessoryType = UITableViewCellAccessoryCheckmark;
            catcell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
            selectedcategory=[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"name"];
            selectedcatid=[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"id"];
        }
        else
        {
        
        if([self.checkedIndexPath isEqual:indexPath])
        {
            catcell.accessoryType = UITableViewCellAccessoryCheckmark;
            catcell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
            
        }
        else
        {
            catcell.accessoryType = UITableViewCellAccessoryNone;
            catcell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdselection"]];
        }
        }
       
    }
    
     catcell.lbldesc.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"description"]];
    catcell.lblcat.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"name"]];
    NSString *catimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"icon"]];
    NSURL *Imgurl=[NSURL URLWithString:catimg];
    [catcell.imgcat  sd_setImageWithURL:Imgurl placeholderImage:[UIImage imageNamed:@"nophoto.png"]];
        cell=catcell;
    }
    else if(tableView  == tblcancelpolicy)
    {
        cancelcell *cancell = (cancelcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cancelcell" owner:self options:nil];
            cancell = [nib objectAtIndex:0];
            
            if([self.checkedIndexPath isEqual:indexPath])
            {
                cancell.accessoryType = UITableViewCellAccessoryCheckmark;
                cancell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdunselect"]];
            }
            else
            {
                cancell.accessoryType = UITableViewCellAccessoryNone;
                cancell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rdselection"]];
            }
            
        }
        cancell.lbldesc.text= [NSString stringWithFormat:@"%@",[[arrcancelpolicy objectAtIndex:[indexPath row]]valueForKey:@"description"]];
        cancell.lblname.text= [NSString stringWithFormat:@"%@",[[arrcancelpolicy objectAtIndex:[indexPath row]]valueForKey:@"type"]];
        cell=cancell;

    }
    return  cell;
}

-(void)dismisspolicypopup
{
    policyview *policy= [[policyview alloc]initWithNibName:@"policyview" bundle:nil];
    [self dismissPopupViewController:policy animationType:MJPopupViewAnimationFade];
}


- (void)btninfoclick:(UIButton *)sender
{
    policyview *info= [[policyview alloc]initWithNibName:@"policyview" bundle:nil];
    info.pagetype=@"Cancellation Policy";
    [self presentPopupViewController:info animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionDismissBackgroundOnly];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        if(tableView == tblcategory)
        {
        
        selectedcategory=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"name"];
        selectedcatid=[[arrcategory objectAtIndex:indexPath.row]valueForKey:@"id"];
        
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"getvolumesbycategory"];
        
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:selectedcatid forKey:@"categoryid"];
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            
            volconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        }
        else if(tableView == tblcancelpolicy)
        {
            selectedpolicy=[[arrcancelpolicy objectAtIndex:indexPath.row]valueForKey:@"id"];
            NSLog(@"policy: %@",selectedpolicy);
        }

    }
}
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

-(IBAction)onbtnsubmitclick:(id)sender
{
    if(![txttripname.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Trip name is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttripdate.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Trip date is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttriptime.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Trip Time is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtzipcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"From Zipcode is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttozipcode.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"To Zipcode is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    if(![txtfromairport.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Source Airport" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttoairport.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Destination Airport" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtvolume.text length] > 0)
    {
        if(![selectedcategory length] > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select category first to select volume." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        else
        {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Weight" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
        }
    }
//    if(![txtflightname.text length] > 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Flight name required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//        [alert show];
//        return;
//    }
    NSInteger length = [txtzipcode.text length];
    
    if(length != 5 && length != 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid From Zipcode." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    NSInteger length1 = [txttozipcode.text length];
    
    if(length1 != 5 && length1 != 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid To Zipcode." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    if([txttoairport.text isEqualToString:txtfromairport.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Source and Destination Airport Cannot Be Same" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    NSDateFormatter *df= [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd-MM-yyyy"];
    
   
    NSString *fromdt = [df stringFromDate:[NSDate date]];
    
    NSDate *dt1 = [[NSDate alloc] init];
    
    NSDate *dt2 = [[NSDate alloc] init];
    
    dt1=[df dateFromString:fromdt];
    
    dt2=[df dateFromString:tripdt];
    
    NSComparisonResult result = [dt1 compare:dt2];
    
    if (result == NSOrderedSame  || result == NSOrderedDescending)
    {
        NSLog(@"less");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Trip date should be greater than today date." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    

    NSString *fromcntry,*tocntry;
    
    fromcntry=[DbHandler FetchAirportcountry:txtfromairport.text];
    tocntry=[DbHandler FetchAirportcountry:txttoairport.text];
    
    if([fromcntry isEqualToString:tocntry])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cannot Send Parcel To Same Country. Choose Other Airport." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
    }
    if([tocntry isEqualToString:fromcntry])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cannot Send Parcel To Same Country. Choose Other Country Airport." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    
    if(!selectedcategory.length >0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Category." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![paymenttype isEqualToString:@"M"])
    {
    if(!selectedpolicy.length >0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Cancellation Policy." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    }
    if([strmutual isEqualToString:@"No"] && [strcommercial isEqualToString:@"No"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select At least one payment option." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(!checkBoxSelected)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Agree to Terms of Services." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"createtrip"];
    
    NSString *fromid= [DbHandler GetAirportId:txtfromairport.text];
    NSString *toid= [DbHandler GetAirportId:txttoairport.text];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:txttripname.text forKey:@"tripname"];
    [postdata setObject:txtdesc.text forKey:@"tripdescription"];
    
    NSArray *arrtripdate =[tripdt componentsSeparatedByString: @"-"];
    NSString *tripdate=[arrtripdate objectAtIndex:2];
    tripdate=[tripdate stringByAppendingString:@"-"];
    tripdate=[tripdate stringByAppendingString:[arrtripdate objectAtIndex:1]];
    tripdate=[tripdate stringByAppendingString:@"-"];
    tripdate=[tripdate stringByAppendingString:[arrtripdate objectAtIndex:0]];
    
    [postdata setObject:[NSString stringWithFormat:@"%@ %@" ,tripdate,txttriptime.text] forKey:@"tripdatetime"];
    [postdata setObject:fromid forKey:@"fromairport"];
    [postdata setObject:toid forKey:@"toairport"];
    [postdata setObject:selectedcatid forKey:@"category"];
    [postdata setObject:volumeid forKey:@"volume"];
    [postdata setObject:txtflightname.text forKey:@"flightname"];
    if(![paymenttype isEqualToString:@"M"])
    {
    [postdata setObject:selectedpolicy forKey:@"cancellationpolicy"];
    }
    else
    {
        [postdata setObject:@"0" forKey:@"cancellationpolicy"];
    }
    [postdata setObject:strcommercial forKey:@"commercial"];
    [postdata setObject:strmutual forKey:@"mutually"];
    [postdata setObject:@"1" forKey:@"subcommercial"];
    [postdata setObject:@"test" forKey:@"senditemat"];
    [postdata setObject:txtzipcode.text forKey:@"zipcode"];
    [postdata setObject:txttozipcode.text forKey:@"tozipcode"];
    
    if([_itemid length] > 0)
    {
        [postdata setObject:_itemid forKey:@"itemid"];
    }
    else
    {
        [postdata setObject:@"0" forKey:@"itemid"];
    }
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
         tripconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
}

-(void)pickerDoneClicked:(id)sender
{
    UIBarButtonItem *btn= (UIBarButtonItem*)sender;
    
    if(btn.tag==100)
    {
        if([txttoairport.text isEqualToString:txtfromairport.text])
        {
            txttoairport.text=@"";
        }
         NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name ='%@'",txttoairport.text]];
         NSString *frmcntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name ='%@'",txtfromairport.text]];
        if([frmcntry isEqualToString:tocntry])
        {
            txttoairport.text=@"";
        }
        
        if ([txtfromairport.text isEqualToString:@""])
        {
            NSInteger row = [pckertoairport selectedRowInComponent:0];
            txtfromairport.text = [arrtoairport objectAtIndex:(NSUInteger)row];
            NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name='%@'",txttoairport.text]];
            arrtoairport=[DbHandler FetchAirport:tocntry];
        }
        [txtfromairport resignFirstResponder];
        
        
    }
    
    if(btn.tag==101)
    {
        
        if([txtfromairport.text isEqualToString:txttoairport.text])
        {
            txtfromairport.text=@"";
        }
        NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name ='%@'",txttoairport.text]];
        NSString *frmcntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name ='%@'",txtfromairport.text]];
        if([tocntry isEqualToString:frmcntry])
        {
            txtfromairport.text=@"";
        }
        if ([txttoairport.text isEqualToString:@""])
        {
            NSInteger row = [pckertoairport selectedRowInComponent:0];
            txttoairport.text = [arrtoairport objectAtIndex:(NSUInteger)row];
            NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where city_name||','||airport_name ='%@'",txttoairport.text]];
            arrairport=[DbHandler FetchAirport:tocntry];
        }
        [txttoairport resignFirstResponder];
        
    }
    
    if(btn.tag==102)
    {
        if ([txtvolume.text isEqualToString:@""])
        {
            if([arrvolume count] > 0)
            {
            NSInteger row = [pckrvloume selectedRowInComponent:0];
            txtvolume.text = [arrvolume objectAtIndex:(NSUInteger)row];
            volumeid=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"id"];
            }
        }
        [txtvolume resignFirstResponder];
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
        return [arrairport count];
    }
    if(pickerView.tag==101)
    {
        return [arrtoairport count];
    }
    if(pickerView.tag==102)
    {
        return [arrvolume count];
    }
    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        return [arrairport objectAtIndex:row];
    }
    
    if(pickerView.tag==101)
    {
        return [arrtoairport objectAtIndex:row];
    }
    
    if(pickerView.tag==102)
    {
        return [arrvolume objectAtIndex:row];
    }

    return 0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        
        txtfromairport.text = (NSString *)[arrairport objectAtIndex:row];
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where (city_name||','||airport_name)='%@'",txtfromairport.text]];
        
        NSLog(@"%@",fromcntry);
        arrtoairport=[DbHandler ToAirport:fromcntry];
        
        // strsenderid=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"SID"];
    }
    if(pickerView.tag==101)
    {
        txttoairport.text = (NSString *)[arrtoairport objectAtIndex:row];
         NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select country_name from airportmaster where (city_name||','||airport_name)='%@'",txttoairport.text]];
        arrairport=[DbHandler FetchAirport:tocntry];
        
    }
    if(pickerView.tag==102)
    {
        if([arrvolume count] > 0)
        {
        txtvolume.text = (NSString *)[arrvolume objectAtIndex:row];
        volumeid=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"id"];
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
    if(textField == txtfromairport)
    {
        [self SetPicker:pckrfromairport  txtfield:txtfromairport tag:100 title:@"Select Airport"];
        //[self animateTextField: textField up: YES];
    }
    if(textField == txttoairport)
    {
        [self SetPicker:pckertoairport  txtfield:txttoairport tag:101 title:@"Select Airport"];
        //[self animateTextField: textField up: YES];
    }
    if(textField == txtvolume)
    {
        
        if(![selectedcategory length] > 0)
        {
            [txtvolume resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select category first to select volume." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        else
        {
            [self SetPicker:pckrvloume  txtfield:txtvolume tag:102 title:@"Select Volume"];
            
        }
         //[self animateTextField: textField up: YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
-(void)commercialtapDetected{
    
    
  if([strcommercial isEqualToString:@"Yes"])
    {
        strcommercial=@"No";
    [img1 setImage:[UIImage imageNamed:@"commercial_grey"]];
    }
    else
    {
        strcommercial=@"Yes";
        strmutual=@"No";
        [img2 setImage:[UIImage imageNamed:@"mutuallygrey"]];
        [img1 setImage:[UIImage imageNamed:@"commercial"]];
    }
    
  }

-(void)mutualtapDetected
{
    
    if([strmutual isEqualToString:@"Yes"])
    {
        strmutual=@"No";
        [img2 setImage:[UIImage imageNamed:@"mutuallygrey"]];
    }
    else
    {
        strmutual=@"Yes";
        strcommercial=@"No";
        [img1 setImage:[UIImage imageNamed:@"commercial_grey"]];
        [img2 setImage:[UIImage imageNamed:@"mutually"]];
    }
    
}

-(IBAction)onbtncommercialpressed:(id)sender
{
    if([strcommercial isEqualToString:@"Yes"])
    {
        strcommercial=@"No";
        [img1 setImage:[UIImage imageNamed:@"commercial_grey"]];
    }
    else
    {
        strcommercial=@"Yes";
        strmutual=@"No";
        [img2 setImage:[UIImage imageNamed:@"mutuallygrey"]];
        [img1 setImage:[UIImage imageNamed:@"commercial"]];
    }
}
-(IBAction)onbtnmutualpressed:(id)sender
{
    if([strmutual isEqualToString:@"Yes"])
    {
        strmutual=@"No";
        [img2 setImage:[UIImage imageNamed:@"mutuallygrey"]];
    }
    else
    {
        strmutual=@"Yes";
        strcommercial=@"No";
        [img1 setImage:[UIImage imageNamed:@"commercial_grey"]];
        [img2 setImage:[UIImage imageNamed:@"mutually"]];
    }
    
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
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField  == txtzipcode )
    {
        NSInteger length = [txtzipcode.text length];
        if (length>5 && ![string isEqualToString:@""]) {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>6) {
                textField.text = [textField.text substringToIndex:6];
                
            }
        });
    }
    if(textField  == txttozipcode )
    {
        NSInteger length = [txttozipcode.text length];
        if (length>5 && ![string isEqualToString:@""]) {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>6) {
                textField.text = [textField.text substringToIndex:6];
                
            }
        });
    }
    if(textField == txtzipcode || textField == txttozipcode )
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField  == txtfromairport  || textField == txttoairport)
    {
        return NO;
    }
    if(textField  == txttripdate)
    {
        return NO;
    }
    if(textField  == txttriptime)
    {
        return NO;
    }
    
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    _itemid=@"";
    itemcategory=@"";
//    ifromdt=@"";
//    itodt=@"";
  //  paymenttype=@"";
    //fromcityid=@"";
    //tocityid=@"";
    //vol=@"";
   //_volid=@"";
    
    
   
    
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
