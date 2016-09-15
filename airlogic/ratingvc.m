//
//  ratingvc.m
//  airlogic
//
//  Created by APPLE on 05/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "ratingvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MJPopupViewController.h"
#import "tripitemsvc.h"
#import "EDStarRating.h"

@interface ratingvc ()
@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (weak, nonatomic) IBOutlet UILabel *starRatingLabel;
@end

@implementation ratingvc
@synthesize starRating=_starRating;
@synthesize starRatingLabel = _starRatingLabel;
@synthesize itemid,torateuserid;

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    self.title=@"Rate and Review";
    self.navigationController.navigationItem.hidesBackButton=YES;
    
    // Setup control using iOS7 tint Color
    _starRating.backgroundColor  = [UIColor clearColor];
    _starRating.starImage = [[UIImage imageNamed:@"emptystar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 15.0;
    _starRating.editable=YES;
    _starRating.rating= 0;
    _starRating.tintColor= [UIColor orangeColor];
    _starRating.displayMode=EDStarRatingDisplayFull;
    [_starRating  setNeedsDisplay];
    [self starsSelectionChanged:_starRating rating:0];
    
    UIToolbar* desctoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    desctoolbar.barStyle = UIBarStyleBlackOpaque;
    desctoolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cleardescpad)],
                         nil];
    [desctoolbar sizeToFit];
    txtreview.inputAccessoryView = desctoolbar;
    // Do any additional setup after loading the view from its nib.
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingString = [NSString stringWithFormat:@"%.f", rating];
    if( [control isEqual:_starRating] )
        starrating = ratingString;
    //    else
    //        _starRatingImageLabel.text = ratingString;
}
-(void)viewWillAppear:(BOOL)animated
{
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, txtreview.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Write your review"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [txtreview addSubview:placeholderLabel];

}

- (void) textViewDidChange:(UITextView *)theTextView
{

    if(![txtreview hasText]) {
        [txtreview addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
    } else if ([[txtreview subviews] containsObject:placeholderLabel]) {
        
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [placeholderLabel removeFromSuperview];
        }];
    }
    int len = txtreview.text.length;
    lblcount.text=[NSString stringWithFormat:@"%i",160-len];
    
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
return YES;
}
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![txtreview hasText]) {
        [txtreview addSubview:placeholderLabel];
        [UIView animateWithDuration:0.15 animations:^{
            placeholderLabel.alpha = 1.0;
        }];
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
-(void)cleardescpad{
    [txtreview resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [responseString objectFromJSONString];
    NSString *string = [deserializedData objectForKey:@"response_code"];
    
    if([string isEqualToString:@"200"])
    {
        [self removeProgressIndicator];
    }
    else
    {
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
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

-(IBAction)onbtnsubmitclick:(id)sender
{
    
    if([starrating isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Rating is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"rateitem"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
     [postdata setObject:torateuserid forKey:@"senderid"];
     [postdata setObject:itemid forKey:@"itemid"];
     [postdata setObject:starrating forKey:@"rating"];
     [postdata setObject:txtreview.text forKey:@"review"];
   
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationItem.hidesBackButton=NO;
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
