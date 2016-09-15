//
//  itemdetailvc.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itemdetailvc.h"
#import "selectcategory.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"
#import "DbHandler.h"
#import "servicevc.h"
#import "myitemvc.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"


#define ACCEPTABLE_CHARECTERS @"0123456789."

@interface itemdetailvc ()

@end

@implementation itemdetailvc
@synthesize ivol,icat,icatid,ivolid,ivolprice,paymenttype;

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    arritemdetail= [[NSMutableArray alloc]init];
    self.title=@"Send Items";
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    catid=@"";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UIToolbar* priceToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    priceToolbar.barStyle = UIBarStyleBlackOpaque;
    priceToolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad)],
                          nil];
    [priceToolbar sizeToFit];
    txtitemcost.inputAccessoryView = priceToolbar;    
    
    
    UIToolbar* txttoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    txttoolbar.barStyle = UIBarStyleBlackOpaque;
    txttoolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                          nil];
    [txttoolbar sizeToFit];
    txtitemdesc.inputAccessoryView = txttoolbar;
    // Do any additional setup after loading the view from its nib.
}
-(void)clearpricepad{
    [txtitemcost resignFirstResponder];
}
-(void)cleardescpad{
    [txtitemdesc resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Items Detail Screen";
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([ivol length ] >0)
    {
        txtvolume.text=ivol;
        txtvolume.textColor=[UIColor lightGrayColor];
        viewvol.userInteractionEnabled=NO;
        [DbHandler UpdateItemvolume: txtvolume.text];
        delegate.volid=ivolid;
        delegate.volprice=ivolprice;
    }
    else
    {
        viewvol.userInteractionEnabled=YES;
    }
    
    if([icat length ] >0)
    {
        responseData = [NSMutableData data];
        
        lblcategory.text=icat;
        lblcategory.textColor=[UIColor lightGrayColor];
      //  [btncategory setTitle:icat forState:UIControlStateNormal];
        btncategory.userInteractionEnabled=NO;
        [DbHandler UpdateItemCategory:icat categoryid:icatid];
        catid=icatid;
        NSString *strurl= [AppDelegate baseurl];
        strurl= [strurl stringByAppendingString:@"getvolumesbycategory"];
        
        NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
        [postdata setObject:icatid forKey:@"categoryid"];
        
            
            AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
            
            
            if([delegate isConnectedToNetwork])
            {
                [self addProgressIndicator];
                
                connvol=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
       // [btncategory setTitle:@"Select Category" forState:UIControlStateNormal];
        btncategory.userInteractionEnabled=YES;
    }
    
    if(![txtitemdesc.text length] > 0)
    {
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, txtitemdesc.frame.size.width - 10.0, 34.0)];
    [placeholderLabel setText:@"Please specify the details of the product you want to send."];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    // textView is UITextView object you want add placeholder text to
    [txtitemdesc addSubview:placeholderLabel];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [viewvol addGestureRecognizer:singleFingerTap];
    
}
- (void)addcategory:(id)controller didFinishEnteringItem:(NSString *)item _catid:(NSString *)categoryid
{
    txtvolume.text=@"";
    lblcategory.text=item;
    catid=categoryid;
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"getvolumesbycategory"];
    responseData = [NSMutableData data];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:catid forKey:@"categoryid"];
    if(![categoryid isEqualToString:@""])
    {
        
        AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
        
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            
            connvol=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self removeProgressIndicator];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == connvol)
    {
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            arrvolume = [[NSMutableArray alloc] init];
            
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

-(void)dismissPopup
{
    selectcategory *select= [[selectcategory alloc]initWithNibName:@"selectcategory" bundle:nil];
    [self dismissPopupViewController:select animationType:MJPopupViewAnimationFade];
}

-(void)showdata
{
    arritemdetail=[DbHandler FetchItemdetail];
    if(arritemdetail.count  > 0)
    {
     }
}


-(IBAction)onbtnclick:(id)sender
{
    [txtitemcost resignFirstResponder];
    [txtitemdesc resignFirstResponder];
    catid=@"";
    selectcategory *cat= [[selectcategory alloc]initWithNibName:@"selectcategory" bundle:nil];
     cat.catdelegate=self;
    [self presentPopupViewController:cat animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionNone];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (void) textViewDidChange:(UITextView *)theTextView
{
    
    int len = txtitemdesc.text.length;
    lblcount.text=[NSString stringWithFormat:@"%i",300-len];
    
    if(![txtitemdesc hasText]) {
        [txtitemdesc addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    } else if ([[txtitemdesc subviews] containsObject:placeholderLabel]) {
        
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [placeholderLabel removeFromSuperview];
        }];
    }
}


- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![txtitemdesc hasText]) {
        [txtitemdesc addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    }
}

-(IBAction)onbtnitemdetailclick:(id)sender
{
    if([lblcategory.text isEqualToString:@"Select Categories"] ||  [lblcategory.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Category" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtitemdesc.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Description is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtvolume.text length]>0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Select Volume" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if(![txtitemcost.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Item Cost is required" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    double cost =[txtitemcost.text doubleValue];
    
    if(cost  > 2000)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Item Cost should be below $2000" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    
    BOOL flg= [DbHandler UpdateItemdetail:lblcategory.text itemcost:txtitemcost.text itemdesc:txtitemdesc.text];
    
    if(flg)
    {
        [DbHandler UpdateItemvolume:txtvolume.text];
        servicevc *service = [[servicevc alloc]initWithNibName:@"servicevc" bundle:nil];
        service.paytype=paymenttype;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.45;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionFromRight;
        [transition setType:kCATransitionPush];
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:service animated:NO];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtitemcost)
    {
        [self animateTextField: textField up:YES  distance:100];
    }
    if(textField == txtvolume)
    {
        if(![catid length] > 0)
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
    }
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtitemcost)
    {
        [self animateTextField: textField up:NO  distance:100];
    }
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up distance:(int)dist
{
    const int movementDistance = dist; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtitemcost)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    
    return YES;
}


-(void)pickerDoneClicked:(id)sender
{
    UIBarButtonItem *btn= (UIBarButtonItem*)sender;
    
    if(btn.tag==102)
    {
        if ([txtvolume.text isEqualToString:@""])
        {
            if([arrvolume count] > 0)
            {
                NSInteger row = [pckrvloume selectedRowInComponent:0];
                txtvolume.text = [arrvolume objectAtIndex:(NSUInteger)row];
                delegate.volid=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"id"];
                delegate.volprice=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"rate"];
                delegate.volname=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"name"];
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
    if(pickerView.tag==102)
    {
        return [arrvolume count];
    }
    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(pickerView.tag==102)
    {
        return [arrvolume objectAtIndex:row];
    }
    
    return 0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag==102)
    {
        if([arrvolume count] > 0)
        {
            txtvolume.text = (NSString *)[arrvolume objectAtIndex:row];
            delegate.volid=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"id"];
            delegate.volprice=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"rate"];
             delegate.volname=[[mutabledictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]valueForKey:@"name"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
