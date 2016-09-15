//
//  sendrequestvc.m
//  airlogic
//
//  Created by APPLE on 14/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "sendrequestvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MJPopupViewController.h"
#import "thanksview.h"
#import "SCLAlertView.h"
#import "mytriplistvc.h"
#import "myitemvc.h"


@interface sendrequestvc ()
{
  
}
@end

@implementation sendrequestvc
@synthesize itemid,strtripid,touserid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Send Request";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    
    UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UIToolbar* desctoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    desctoolbar.barStyle = UIBarStyleBlackOpaque;
    desctoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                         nil];
    [desctoolbar sizeToFit];
    txtdesc.inputAccessoryView = desctoolbar;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Send Request Screen";
    [super viewDidAppear:animated];
}
-(void)cleardescpad{
    [txtdesc resignFirstResponder];
}

-(void)dismissPopup
{
    thanksview *thanks= [[thanksview alloc]initWithNibName:@"thanksview" bundle:nil];
    [self dismissPopupViewController:thanks animationType:MJPopupViewAnimationFade];
    
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
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, txtdesc.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Message to request"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [txtdesc addSubview:placeholderLabel];
}

- (void) textViewDidChange:(UITextView *)theTextView
{
    
    int len = txtdesc.text.length;
    lblcount.text=[NSString stringWithFormat:@"%i",160-len];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            txtdesc.text=@"";
            lblcount.text=@"160";
             [self removeProgressIndicator];
//            thanksview *thanks= [[thanksview alloc]initWithNibName:@"thanksview" bundle:nil];
//            
//            [self presentPopupViewController:thanks animationType:MJPopupViewAnimationFade contentInteraction:MJPopupViewContentInteractionNone];
            NSString *msg=@"";
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
             msg =@"Your request is getting processed.";
            }
            else
            {
               msg =@"Your request is getting processed.";
            }
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundViewColor=[UIColor whiteColor];
            [alert addButton:@"OK" target:self selector:@selector(firstButton)];
            [alert showCustom:self image:[UIImage imageNamed:@"thankyou.png"] color:[UIColor orangeColor] title:@"Thank you!" subTitle:msg closeButtonTitle:nil duration:0.0f];
            
        
        }
        else
        {
            [self removeProgressIndicator];
            txtdesc.text=@"";
            lblcount.text=@"160";
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[deserializedData valueForKey:@"response_message"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
//            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            alert.backgroundViewColor=[UIColor whiteColor];
//            
//            [alert showError:@"Error" subTitle:[deserializedData valueForKey:@"response_message"] closeButtonTitle:@"OK" duration:0.0f];
            
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
-(void)doneButtonClickedDismissKeyboard
{
    [txtdesc resignFirstResponder];
}
-(IBAction)onbtnsendclick:(id)sender
{
    if(![txtdesc.text length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Message " delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    if (![self isAcceptableTextLength:txtdesc.text.length]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Message should not be more than 160 characters." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
          [txtdesc resignFirstResponder];
    
     NSString *strurl= [AppDelegate baseurl];
     NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        strurl= [strurl stringByAppendingString:@"sendtriprequest"];
        [postdata setObject:txtdesc.text forKey:@"message"];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:strtripid forKey:@"tripid"];
        [postdata setObject:itemid forKey:@"itemid"];
        
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"senditemrequest"];
        [postdata setObject:txtdesc.text forKey:@"message"];
        [postdata setObject:delegate.struserid forKey:@"userid"];
        [postdata setObject:itemid forKey:@"itemid"];
        [postdata setObject:strtripid forKey:@"tripid"];
    }
        [postdata setObject:touserid forKey:@"touserid"];
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

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if([text length] == 0)
//    {
//        if([textView.text length] != 0)
//        {
//            return YES;
//        }
//    }
//    else if([[textView text] length] > 159)
//    {
//        return NO;
//    }
//    return YES;
//}



- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= 160;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    return [self isAcceptableTextLength:txtdesc.text.length + string.length - range.length];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return YES;
}




- (void)firstButton
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        myitemvc *itemlist =[[myitemvc alloc]initWithNibName:@"myitemvc" bundle:nil];
        [self.navigationController pushViewController:itemlist animated:NO];
    }
    else
    {
        mytriplistvc *triplist =[[mytriplistvc alloc]initWithNibName:@"mytriplistvc" bundle:nil];
        [self.navigationController pushViewController:triplist animated:NO];
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
