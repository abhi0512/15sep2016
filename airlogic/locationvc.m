//
//  locationvc.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "locationvc.h"
#import "DbHandler.h"
#import "AppDelegate.h"
#import "itemdetailvc.h"
#import "myitemvc.h"


#define ACCEPTABLE_CHARECTERS @"0123456789."
@interface locationvc ()

@end

@implementation locationvc
@synthesize fromcityid,tocityid,vol,paymenttype,itemcategory,_volid,_catid,volprice,tripdt,fromzip,tozip;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrfromcity= [[NSMutableArray alloc]init];
    arrtocity=[[NSMutableArray alloc]init];
    self.title=@"Send Items";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:1];
    NSDate* tomorrowf = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:+6];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
     NSDate *maxDateto = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
     NSDate* tomorrowt = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    
    fromdatePicker=[[UIDatePicker alloc]init];
    fromdatePicker.datePickerMode=UIDatePickerModeDate;
    fromdatePicker.minimumDate = tomorrowf;
    fromdatePicker.maximumDate=maxDate;
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
//    [fromdatePicker setLocale:locale];
    
    [fromdatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"US"]];
    [txtfromdt setInputView:fromdatePicker];
    fromdatePicker.tag=101;
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowFromDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [txtfromdt setInputAccessoryView:toolBar];
    
    todatePicker=[[UIDatePicker alloc]init];
    todatePicker.datePickerMode=UIDatePickerModeDate;
    
    todatePicker.minimumDate = tomorrowt;
    todatePicker.maximumDate=maxDateto;

    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    [todatePicker setLocale:locale1];
    [txttodt setInputView:todatePicker];
    UIToolbar *timetoolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [timetoolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *timedoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowToDate)];
    UIBarButtonItem *timespace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [timetoolBar setItems:[NSArray arrayWithObjects:timespace,timedoneBtn, nil]];
    [txttodt setInputAccessoryView:timetoolBar];
    
    
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
    
    txtzipcode.text=[DbHandler GetId:[NSString stringWithFormat:@"select zip from usermaster where id='%@'",delegate.struserid]];

    if([fromcityid length] > 0)
    {
       
        NSString * frmcity=[DbHandler GetId:[NSString stringWithFormat:@"select (ct.city_name || ' , ' || cnt.country_name)as c from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where ct.city_id='%@'",fromcityid]];
        txtfromcity.text=frmcity;
        txtfromcity.userInteractionEnabled=NO;
        txtfromcity.textColor=[UIColor lightGrayColor];
    }
    else
    {
        arrfromcity= [DbHandler FetchCitydata:@""];
        txtfromcity.text=[arrfromcity objectAtIndex:0];

    }
    if([tocityid length] > 0)
    {
   
        NSString * tocity=[DbHandler GetId:[NSString stringWithFormat:@"select (ct.city_name || ' , ' || cnt.country_name)as c from citymaster as ct join statemaster  as s on s.state_id=ct.state_id join countrymaster as cnt on cnt.country_id=s.countryid where ct.city_id='%@'",tocityid]];
        txttocity.text=tocity;
        txttocity.userInteractionEnabled=NO;
        txttocity.textColor=[UIColor lightGrayColor];
    }
    else
    {
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",[arrfromcity objectAtIndex:0]]];
        arrtocity=[DbHandler FetchToCity:fromcntry];
        txttocity.text=[arrtocity objectAtIndex:0];
    }
    
    if([fromzip length] >0)
    {
        txtzipcode.text=fromzip;
        
    }
    else
    {
        txtzipcode.userInteractionEnabled=YES;
    }
    if([tozip length] >0)
    {
        txttozipcode.text=tozip;
    }
    else
    {
        txttozipcode.userInteractionEnabled=YES;
    }
    
    if([tripdt length] > 0)
    {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MMM/yyyy"];
        txtfromdt.text=[formatter stringFromDate: [NSDate date]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *tdate = [dateFormat dateFromString:tripdt];
        
        [dateFormat setDateFormat:@"dd/MMM/yyyy"];
        NSString *output = [dateFormat stringFromDate:tdate];
        txttodt.text=output;
        
        NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd-MM-yyyy"];
        fromdt=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:[NSDate date]]];
        todt=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:tdate]];

        txtfromdt.userInteractionEnabled=NO;
        txttodt.userInteractionEnabled=NO;
        txtfromdt.textColor=[UIColor lightGrayColor];
        txttodt.textColor=[UIColor lightGrayColor];
    }
    else
    {
        txtfromdt.userInteractionEnabled=YES;
        txttodt.userInteractionEnabled=YES;
    }
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    [fromdatePicker addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate=self;
    gestureRecognizer.numberOfTapsRequired=1;
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Item Location Screen";
    [super viewDidAppear:animated];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)recognizer
{
    UIDatePicker *datePicker=(UIDatePicker*)[[recognizer view] viewWithTag:101];
    NSLog(@"datePicker=%@", datePicker.date);
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    txtfromdt.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
}
-(NSDate *)addDaysToDate:(NSNumber *)numOfDaysToAdd {
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:numOfDaysToAdd.integerValue toDate:self options:nil];
    return newDate;
}
-(void)ShowFromDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    txtfromdt.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:fromdatePicker.date]];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"dd-MM-yyyy"];
    fromdt=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:fromdatePicker.date]];
    [txtfromdt resignFirstResponder];
}
-(void)ShowToDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    txttodt.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:todatePicker.date]];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"dd-MM-yyyy"];
    todt=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:todatePicker.date]];
    [txttodt resignFirstResponder];
}
-(void)clearzippad{
    [txtzipcode resignFirstResponder];
}
-(void)cleartozippad{
    [txttozipcode resignFirstResponder];
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

-(NSDate *)convertStringToDate:(NSString *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *nowDate = [[NSDate alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    // NSLog(@"date============================>>>>>>>>>>>>>>> : %@", date);
    date = [date stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    nowDate = [formatter dateFromString:date];
    // NSLog(@"date============================>>>>>>>>>>>>>>> : %@", nowDate);
    return nowDate;
}
-(IBAction)onbtnlocationclick:(id)sender
{
    if(![txtfromcity.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"From city is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttocity.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"To city is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
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
    if(![txtfromdt.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"From date is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txttodt.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"To date is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    NSInteger length = [txtzipcode.text length];
    
    if(length != 5 && length != 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Zipcode." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    NSInteger tolength = [txttozipcode.text length];
    
    if(tolength != 5 && tolength != 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Zipcode." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    if(![tripdt length] > 0)
    {
    
    NSDateFormatter *df= [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *dt1 = [[NSDate alloc] init];
    
    NSDate *dt2 = [[NSDate alloc] init];
    
    dt1=[df dateFromString:fromdt];
    
    dt2=[df dateFromString:todt];
    
    NSComparisonResult result = [dt1 compare:dt2];
    
    if (result == NSOrderedSame  || result == NSOrderedDescending)
    {
        NSLog(@"less");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"To date should be greater than from date." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    }
    [DbHandler deleteDatafromtable:@"delete from createitem"];
    
    bool flg= [DbHandler InsertItem:txtfromcity.text tocity:txttocity.text fromdt:fromdt todate:todt userid:delegate.struserid zipcode:txtzipcode.text charity:@"" tozipcode:txttozipcode.text];
    if(flg)
    {
        delegate.itemfromdt=txtfromdt.text;
        delegate.itemtodt=txttodt.text;
        itemdetailvc *itemdt = [[itemdetailvc alloc]initWithNibName:@"itemdetailvc" bundle:nil];
        itemdt.icat=itemcategory;
        itemdt.ivol=vol;
        itemdt.icatid=_catid;
        itemdt.ivolid=_volid;
        itemdt.ivolprice=volprice;
        itemdt.paymenttype=paymenttype;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:itemdt animated:NO];
    }
}

-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
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
-(void)pickerDoneClicked:(id)sender
{
    UIBarButtonItem *btn= (UIBarButtonItem*)sender;
    
    if(btn.tag==100)
    {
        if([txttocity.text isEqualToString:txtfromcity.text])
        {
            txttocity.text=@"";
        }
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txtfromcity.text]];
         NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txttocity.text]];
        
        if([fromcntry isEqualToString:tocntry])
        {
            txttocity.text=@"";
        }
        if ([txtfromcity.text isEqualToString:@""])
        {
            NSLog(@"%@",arrfromcity);
            NSInteger row = [pckrfromcity selectedRowInComponent:0];
            txtfromcity.text = [arrfromcity objectAtIndex:(NSUInteger)row];
            
            NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txtfromcity.text]];
            arrtocity= [DbHandler FetchToCity:fromcntry];
        }

         [txtfromcity resignFirstResponder];
    }
    if(btn.tag==101)
    {
        if([txtfromcity.text isEqualToString:txttocity.text])
        {
            txtfromcity.text=@"";
        }
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txtfromcity.text]];
        NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txttocity.text]];
        
        if([tocntry isEqualToString:fromcntry])
        {
            txtfromcity.text=@"";
        }

        if ([txttocity.text isEqualToString:@""])
        {
            NSInteger row = [pckrtocity selectedRowInComponent:0];
            txttocity.text = [arrtocity objectAtIndex:(NSUInteger)row];
            NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txttocity.text]];
            
            arrfromcity= [DbHandler FetchCitydata:tocntry];
        }
        [txttocity resignFirstResponder];
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
        return [arrfromcity count];
    }
    if(pickerView.tag==101)
    {
        return [arrtocity count];
    }    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
        return [arrfromcity objectAtIndex:row];
    }
    
    if(pickerView.tag==101)
    {
        return [arrtocity objectAtIndex:row];
    }

    return 0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag==100)
    {
         selectedString = [arrfromcity objectAtIndex:row];
        txtfromcity.text = (NSString *)[arrfromcity objectAtIndex:row];
        NSString *fromcntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txtfromcity.text]];
        
        arrtocity= [DbHandler FetchToCity:fromcntry];
    }
    if(pickerView.tag==101)
    {
        
        txttocity.text = (NSString *)[arrtocity objectAtIndex:row];
      
        NSString *tocntry= [DbHandler GetId: [NSString stringWithFormat:@"select cnt.country_name from countrymaster cnt join statemaster st on st.countryid=cnt.country_id join citymaster cy on cy.state_id=st.state_id  where (cy.city_name || ' , ' || cnt.country_name)='%@'",txttocity.text]];
        
        arrfromcity= [DbHandler FetchCitydata:tocntry];
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
    if(textField == txtfromcity)
    {
        
        [self SetPicker:pckrfromcity  txtfield:txtfromcity tag:100 title:@"Select From City"];
        //[self animateTextField: textField up: YES];
    }
    if(textField == txttocity)
    {
        [self SetPicker:pckrtocity  txtfield:txttocity tag:101 title:@"Select To City"];
        //[self animateTextField: textField up: YES];
    }
    if(textField == txtzipcode)
    {
        [self animateTextField: textField up: YES distance:200];
    }
    if(textField == txttozipcode)
    {
        [self animateTextField: textField up: YES distance:200];
    }
    if(textField == txttodt)
    {
        [self animateTextField: textField up: YES distance:200];
    }
    if(textField == txtfromdt)
    {
        [self animateTextField: textField up: YES distance:200];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtfromdt)
    {
        [self animateTextField: textField up: NO distance:200];
    }
    if(textField == txttodt)
    {
        [self animateTextField: textField up: NO distance:200];
    }
    if(textField == txtzipcode)
    {
        [self animateTextField: textField up: NO distance:200];
    }
    if(textField == txttozipcode)
    {
        [self animateTextField: textField up: NO distance:200];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up distance :(int)movementDistance
{
    // int movementDistance = 120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(IBAction)onbtnfromdt:(id)sender
{
    fromdatePicker=[[UIDatePicker alloc]init];
    fromdatePicker.datePickerMode=UIDatePickerModeDate;
    fromdatePicker.minimumDate = [NSDate date];
    [txtfromdt setInputView:fromdatePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowFromDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [txtfromdt setInputAccessoryView:toolBar];
}
-(IBAction)onbtntodt:(id)sender
{
    todatePicker=[[UIDatePicker alloc]init];
    todatePicker.datePickerMode=UIDatePickerModeDate;
    todatePicker.minimumDate = [NSDate date];
    [txttodt setInputView:todatePicker];
    UIToolbar *timetoolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [timetoolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *timedoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowToDate)];
    UIBarButtonItem *timespace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [timetoolBar setItems:[NSArray arrayWithObjects:timespace,timedoneBtn, nil]];
    [txttodt setInputAccessoryView:timetoolBar];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField  == txtzipcode)
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
    
    if(textField  == txttozipcode)
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
    
    if(textField == txtzipcode || textField == txttozipcode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    if(textField  == txtfromcity  || textField == txttocity)
    {
        return NO;
    }
    if(textField  == txtfromdt  || textField == txttodt)
    {
        return NO;
    }
    return YES;
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
