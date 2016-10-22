//
//  filterVC.m
//  airlogic
//
//  Created by APPLE on 16/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "filterVC.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "categorycell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DbHandler.h"
#import "searchresultvc.h"

#define ACCEPTABLE_CHARECTERS @"0123456789."

@interface filterVC ()

@end
int cheight=50;
@implementation filterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Filter";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    strcommercial=@"";
    strmutual=@"";
    
    
  
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    arSelectedRows = [[NSMutableArray alloc] init];
    
    UIToolbar* ziptoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    ziptoolbar.barStyle = UIBarStyleBlackOpaque;
    ziptoolbar.items = [NSArray arrayWithObjects:
                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearzippad)],
                        nil];
    [ziptoolbar sizeToFit];
    txtfromzipcode.inputAccessoryView = ziptoolbar;
    
    
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
-(void)clearzippad{
    [txtfromzipcode resignFirstResponder];
}

-(void)cleartozippad{
    [txttozipcode resignFirstResponder];
}

- (void)back {
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
    //[profileview removeFromSuperview];
   
    
    UIImage *filterimg = [UIImage imageNamed:@"tick.png"];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addbtn setBackgroundImage:filterimg forState:UIControlStateNormal];
    
    addbtn.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:addbtn];
    
    [addbtn addTarget:self action:@selector(onbtntickclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem2];
    
    
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
    
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory = [[UITableView alloc]init];
    tblcategory.backgroundColor=[UIColor clearColor];
    tblcategory.dataSource=self;
    tblcategory.delegate=self;
    tblcategory.tableFooterView= [[UIView alloc]init];
    tblcategory.separatorColor=[UIColor grayColor];
    tblcategory.frame = self.view.bounds;
    arrcategory = [[NSMutableArray alloc]init];
    
    arrfromcity= [[NSMutableArray alloc]init];
    arrtocity=[[NSMutableArray alloc]init];

    tblcategory.frame= CGRectMake(0, 390, self.view.frame.size.width,cheight);
    
   [profileview addSubview:tblcategory];

    scrlview.userInteractionEnabled = YES;
    scrlview.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tblcategory.frame.size.height+50);
    profileview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+tblcategory.frame.size.height+50);
    
    [scrlview addSubview:profileview];
    
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:1];
    NSDate* tomorrowf = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:+6];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    NSDate *maxDateto = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    
    
    fromdatePicker=[[UIDatePicker alloc]init];
    fromdatePicker.datePickerMode=UIDatePickerModeDate;
    //fromdatePicker.minimumDate = [NSDate date];
    fromdatePicker.minimumDate=tomorrowf;
    [txtfromdate setInputView:fromdatePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowFromDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [txtfromdate setInputAccessoryView:toolBar];
    
    todatePicker=[[UIDatePicker alloc]init];
    todatePicker.datePickerMode=UIDatePickerModeDate;
    todatePicker.maximumDate=maxDateto;
    todatePicker.minimumDate = tomorrowf;
    [txttodate setInputView:todatePicker];
    UIToolbar *timetoolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [timetoolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *timedoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowToDate)];
    UIBarButtonItem *timespace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [timetoolBar setItems:[NSArray arrayWithObjects:timespace,timedoneBtn, nil]];
    [txttodate setInputAccessoryView:timetoolBar];
            
    arrfromcity= [DbHandler FetchCitydata:@""];

    
}

-(void)ShowFromDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    
    txtfromdate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:fromdatePicker.date]];
    [txtfromdate resignFirstResponder];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    startdate=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:fromdatePicker.date]];
}
-(void)ShowToDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    
    txttodate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:todatePicker.date]];
    [txttodate resignFirstResponder];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    enddate=[NSString stringWithFormat:@"%@",[formatter1 stringFromDate:todatePicker.date]];

}


-(IBAction)onbtnresetclick:(id)sender
{
    txtfromcity.text=@"";
    txttocity.text=@"";
    txtfromdate.text=@"";
    txttodate.text=@"";
    txttozipcode.text=@"";
    txtfromzipcode.text=@"";
    
    strcommercial=@"";
    [btncommercial setBackgroundImage:[UIImage imageNamed:@"commercial_grey"] forState:UIControlStateNormal];
    strmutual=@"";
    [btnmutual setBackgroundImage:[UIImage imageNamed:@"mutuallygrey"] forState:UIControlStateNormal];
    
    
    for (int section = 0, sectionCount = tblcategory.numberOfSections; section < sectionCount; ++section) {
        for (int row = 0, rowCount = [tblcategory numberOfRowsInSection:section]; row < rowCount; ++row) {
            UITableViewCell *cell = [tblcategory cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
        }
    }

}
-(void)setupview
{
    
    tblcategory.frame= CGRectMake(0, 390, self.view.frame.size.width,cheight);
    btnresetfilter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnresetfilter setBackgroundImage:[UIImage imageNamed:@"btnorange"] forState:UIControlStateNormal];
    [btnresetfilter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnresetfilter setTitle:@"Reset Filters" forState:UIControlStateNormal];
    btnresetfilter.titleLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:18];
    [btnresetfilter addTarget:self action:@selector(onbtnresetclick:) forControlEvents:UIControlEventTouchUpInside];
    
    float X_Co = (self.view.frame.size.width - 218)/2;
    [btnresetfilter setFrame:CGRectMake(X_Co, tblcategory.frame.origin.y+cheight+10, 218, 34)];
     [profileview addSubview:tblcategory];
    [profileview addSubview:btnresetfilter];
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
            cheight= 3*65;
        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        if([arrcategory count] > 0)
        {
            [tblcategory reloadData];
            
            [self setupview];
            //lbltitle.hidden=false;
        }
        else
        {
            //[self.view addSubview:lbluname];
            //lbltitle.hidden=true;
        }
    }
    
    
}
-(IBAction)onbtntickclick:(id)sender
{
    
//    if(![txtfromcity.text length] > 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"From City is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//        [alert show];
//        return;
//    }
//    if(![txttocity.text length] > 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"To City is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//        [alert show];
//        return;
//    }
//    
      NSArray *selectedparcel = [self getSelections];
//    
//    if(![selectedparcel count]> 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select At least one category." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//        [alert show];
//        return;
//        
//    }

    NSString *fromcityid,*tocityid;
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
        
        if([txtfromcity.text length] > 0)
        {
         fromcityid= [DbHandler GetId: [NSString stringWithFormat:@"select cy.city_id from citymaster cy join statemaster st on st.state_id=cy.state_id join countrymaster cnt on cnt.country_id=st.countryid where (cy.city_name || ' , ' || cnt.country_name)='%@'",txtfromcity.text]];
        }
        else
        {
            fromcityid=@"";
        }
    
        if([txttocity.text length] > 0)
        {

        tocityid= [DbHandler GetId: [NSString stringWithFormat:@"select cy.city_id from citymaster cy join statemaster st on st.state_id=cy.state_id join countrymaster cnt on cnt.country_id=st.countryid where (cy.city_name || ' , ' || cnt.country_name)='%@'",txttocity.text]];
        }
        else
        {
            tocityid=@"";
        }
    }
    else
    {
        if([txtfromcity.text length] > 0)
        {
        fromcityid= [DbHandler GetId: [NSString stringWithFormat:@"select airport_id from airportmaster  where (city_name || ' , ' || country_name)='%@'",txtfromcity.text]];
        }
        else
        {
            fromcityid=@"";
        }
        
        if([txttocity.text length] > 0)
        {
        tocityid= [DbHandler GetId: [NSString stringWithFormat:@"select airport_id from airportmaster  where (city_name || ' , ' || country_name)='%@'",txttocity.text]];
        }
        else
        {
         tocityid=@"";
        }
        
    }
    NSMutableString *catid=[[NSMutableString alloc]init];
    
    for(int i =0; i < [selectedparcel count];i++)
    {
        [catid appendString:[[selectedparcel objectAtIndex:i]valueForKey:@"id"]];
        [catid appendString:[NSString stringWithFormat:@","]];
    }
    
    if(![catid isEqualToString:@""])
    {
        [catid deleteCharactersInRange:NSMakeRange([catid length]-1,1)];
    }

    searchresultvc *search = [[searchresultvc alloc]initWithNibName:@"searchresultvc" bundle:nil];
    search.fromcity=fromcityid;
    search.tocity=tocityid;
    search.fromdt=startdate;
    search.todt=enddate;
    search.fromzipcode=txtfromzipcode.text;
    search.commerical=strcommercial;
    search.mutual=strmutual;
    search.subcommercial=@"1";
    search.category=catid;
    search.tozipcode=txttozipcode.text;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:search animated:NO];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [arrcategory count ];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
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
        
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
        
        if([arSelectedRows containsObject:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickcircle"]];
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
        }
        
    }
    cell.lblcat.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"name"]];
    cell.lbldesc.text= [NSString stringWithFormat:@"%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"description"]];
    NSString *catimg =[NSString stringWithFormat:@"http://airlogiq-prod.us-east-1.elasticbeanstalk.com/%@",[[arrcategory objectAtIndex:[indexPath row]]valueForKey:@"icon"]];
   [cell.imgcat setImageWithURL:[NSURL URLWithString:catimg] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickcircle"]];
        
        [arSelectedRows addObject:indexPath];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tickwithoutcircle"]];
        
        [arSelectedRows removeObject:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSArray *)getSelections {
    NSMutableArray *selections = [[NSMutableArray alloc] init];
    
    for(NSIndexPath *indexPath in arSelectedRows) {
        [selections addObject:[arrcategory objectAtIndex:indexPath.row]];
    }
    
    return selections;
}

-(IBAction)onbtncommercialclick:(id)sender
{
    if([strcommercial isEqualToString:@"Yes"])
    {
        strcommercial=@"No";
        [btncommercial setBackgroundImage:[UIImage imageNamed:@"commercial_grey"] forState:UIControlStateNormal];
    }
    else
    {
        strcommercial=@"Yes";
        strmutual=@"No";
       [btnmutual setBackgroundImage:[UIImage imageNamed:@"mutuallygrey"] forState:UIControlStateNormal];
        [btncommercial setBackgroundImage:[UIImage imageNamed:@"commercial"] forState:UIControlStateNormal];
    }
    
}
-(IBAction)onbtnmutualclick:(id)sender
{
    
    if([strmutual isEqualToString:@"Yes"])
    {
        strmutual=@"No";
         [btnmutual setBackgroundImage:[UIImage imageNamed:@"mutuallygrey"] forState:UIControlStateNormal];
    }
    else
    {
        strmutual=@"Yes";
        strcommercial=@"No";
        [btnmutual setBackgroundImage:[UIImage imageNamed:@"mutually"] forState:UIControlStateNormal];
        [btncommercial setBackgroundImage:[UIImage imageNamed:@"commercial_grey"] forState:UIControlStateNormal];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        if(![txtfromcity.text length] > 0)
        {
            [txttocity resignFirstResponder];
            
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select From City First." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
        else
        {
        [self SetPicker:pckrtocity  txtfield:txttocity tag:101 title:@"Select To City"];
        }
        //[self animateTextField: textField up: YES];
    }
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField  == txtfromzipcode || textField == txttozipcode )
    {
        NSInteger length = [txtfromzipcode.text length];
        if (length>5 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        NSInteger length2 = [txttozipcode.text length];
        if (length2>5 && ![string isEqualToString:@""])
        {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>6) {
                textField.text = [textField.text substringToIndex:6];
                
            }
        });
    }
    if(textField == txtfromzipcode || textField == txttozipcode )
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField  == txtfromcity  || textField == txttocity)
    {
        return NO;
    }
    
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [tblcategory removeFromSuperview];

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
