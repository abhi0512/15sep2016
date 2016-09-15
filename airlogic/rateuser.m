//
//  rateuser.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "rateuser.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MJPopupViewController.h"
#import "tripitemsvc.h"
#import "EDStarRating.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface rateuser ()
@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (weak, nonatomic) IBOutlet UILabel *starRatingLabel;
@end

@implementation rateuser
@synthesize starRating=_starRating;
@synthesize starRatingLabel = _starRatingLabel;
@synthesize itemid,torateuserid,tripid;

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    responseData = [NSMutableData data];
    self.title=@"Rate and Review";
    self.navigationItem.hidesBackButton = YES;
    
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
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Rate to sender";
    [super viewDidAppear:animated];
    
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
    [placeholderLabel setText:@"Write review"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [txtreview addSubview:placeholderLabel];
    
    
        NSString *strurl= [AppDelegate baseurl];
    
    if([delegate.strusertype isEqualToString:@"Sender"])
    {
        
        strurl= [strurl stringByAppendingString:@"getsingletrip?tripid="];
        strurl=[strurl stringByAppendingString:tripid];
        strurl=[strurl stringByAppendingString:@"&userid="];
        strurl=[strurl stringByAppendingString:delegate.struserid];
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"getsingleitem?itemid="];
        strurl=[strurl stringByAppendingString:itemid];
        strurl=[strurl stringByAppendingString:@"&userid="];
        strurl=[strurl stringByAppendingString:delegate.struserid];
    }
    
        NSURL *url = [NSURL URLWithString:strurl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:120];
        if([delegate isConnectedToNetwork])
        {
            [self addProgressIndicator];
            if([delegate.strusertype isEqualToString:@"Sender"])
            {
               connflybee=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
            else
            {
                connsender=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            return;
        }
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
    
    if(connection ==rateconn)
    {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [responseString objectFromJSONString];
    NSString *string = [deserializedData objectForKey:@"response_code"];
    
    if([string isEqualToString:@"200"])
    {
        [self removeProgressIndicator];
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
        [self removeProgressIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    }
    if(connection ==connflybee)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            NSDictionary*userdata = [[deserializedData objectForKey:@"data"]objectAtIndex:0];
            ffromcity.text=[userdata valueForKey:@"fromcity"];
            ftocity.text=[userdata valueForKey:@"tocity"];
            flbltripname.text=[NSString stringWithFormat:@"T%@%@",tripid,[userdata valueForKey:@"userid"]];
            flblvolume.text=[NSString stringWithFormat:@"%@inch",[userdata valueForKey:@"volume"]];
            flblweight.text=[userdata valueForKey:@"weight"];
            lblflightname.text=[userdata valueForKey:@"tripname"];
            NSString *tripdt =[userdata valueForKey:@"tripdate"];
            NSArray *dates = [tripdt componentsSeparatedByString:@"/"];
            flbldate.text=[dates objectAtIndex:0];
            lblmonth.text=[NSString stringWithFormat:@"%@ %@",[dates objectAtIndex:1],[dates objectAtIndex:2]];
            
            NSString *mystr=[userdata valueForKey:@"thumbprofilepic"];
            mystr=[mystr substringToIndex:5];
            NSString *thumbprofilepic =@"";
            NSString *img =@"";
            img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
            
//            NSLog(@"%@",mystr);
//            if(![mystr isEqualToString:@"https"])
//            {
//            thumbprofilepic= [userdata valueForKey:@"thumbprofilepic"];
//            img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
//                
//            }
//            else
//            {
//                thumbprofilepic= [userdata valueForKey:@"thumbprofilepic"];
//                img =[NSString stringWithFormat:@"%@",thumbprofilepic];
//                
//            }
             [fimgprofile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            fimgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            fimgprofile.layer.borderWidth = 2.0;
            fimgprofile.layer.cornerRadius= fimgprofile.frame.size.width/2;
            fimgprofile.clipsToBounds=YES;
            
            
            viewdetail.alpha=1;
            CGRect frameRect = viewflybee.frame;
            frameRect.size.width = viewdetail.frame.size.width;
            viewflybee.frame=frameRect;
            [viewdetail addSubview:viewflybee];
            
            viewreview.alpha=1;
            btnrate.alpha=1;
            _starRating.alpha=1;

        }
        else
        {
            [self removeProgressIndicator];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [deserializedData objectForKey:@"response_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if(connection ==connsender)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *deserializedData = [responseString objectFromJSONString];
        NSString *string = [deserializedData objectForKey:@"response_code"];
        
        if([string isEqualToString:@"200"])
        {
            [self removeProgressIndicator];
            
            NSDictionary*userdata = [[deserializedData objectForKey:@"data"]objectAtIndex:0];
            fromcity.text=[userdata valueForKey:@"fromcity"];
            tocity.text=[userdata valueForKey:@"tocity"];
            lbltripname.text=[userdata valueForKey:@"itemname"];
            lblvolume.text=[userdata valueForKey:@"volume"];
            lblweight.text=[userdata valueForKey:@"weight"];
            
                NSString *ptype=[userdata valueForKey:@"mutually_agreed"];
                if(![ptype isEqualToString:@"Yes"])
                {
                    
                    NSString *pricelen= [NSString stringWithFormat:@"%@",[userdata valueForKey:@"itemprice"]];
                    if([pricelen length] > 2)
                    {
                        lblcurrency.frame=CGRectMake(212, 14, 10, 21);
                        lblitemprice.frame=CGRectMake(220,-4, 92, 77);
                    }
                    else if([pricelen length] == 2)
                    {
                        lblcurrency.frame=CGRectMake(242, 14, 10, 21);
                        lblitemprice.frame=CGRectMake(248,-4,64, 77);
                    }
                    else
                    {
                        lblcurrency.frame=CGRectMake(274, 14, 10, 21);
                        lblitemprice.frame=CGRectMake(280, -4, 32, 77);
                    }
                    lblitemprice.text=[userdata valueForKey:@"itemprice"];
                }
                else
                {
                    lblcurrency.frame=CGRectMake(self.view.frame.size.width-46, 14, 10, 21);
                    lblitemprice.frame=CGRectMake(self.view.frame.size.width-40,-4,32, 77);
                    lblitemprice.text=@"0";
                }
            
            
            NSString *fdate =[userdata valueForKey:@"fromdate"];
            NSString *tdate =[userdata valueForKey:@"todate"];
            lbldate.text=fdate;
            lbltodate.text=tdate;
            NSString *thumbprofilepic= [userdata valueForKey:@"thumbprofilepic"];
            NSString *img =[NSString stringWithFormat:@"http://airlogiq.com/%@",thumbprofilepic];
            [imgprofile setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"nophoto.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            imgprofile.layer.cornerRadius= imgprofile.frame.size.width/2;
            imgprofile.clipsToBounds=YES;
            imgprofile.layer.borderColor = [[UIColor orangeColor] CGColor];
            imgprofile.layer.borderWidth = 2.0;
            
            viewdetail.alpha=1;
            CGRect frameRect = viewsender.frame;
            frameRect.size.width = viewdetail.frame.size.width;
            viewsender.frame=frameRect;
            
            [viewdetail addSubview:viewsender];
            viewreview.alpha=1;
            btnrate.alpha=1;
            _starRating.alpha=1;
            
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
    
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
    strurl= [strurl stringByAppendingString:@"rateitem"];
    }
    else
    {
        strurl= [strurl stringByAppendingString:@"ratetrip"];
    }
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    if([delegate.strusertype isEqualToString:@"Flybee"])
    {
    [postdata setObject:torateuserid forKey:@"senderid"];
    }
    else
    {
    [postdata setObject:torateuserid forKey:@"flybeeid"];
    }
    [postdata setObject:itemid forKey:@"itemid"];
    [postdata setObject:tripid forKey:@"tripid"];
    [postdata setObject:starrating forKey:@"rating"];
    [postdata setObject:txtreview.text forKey:@"review"];
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
    
    
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        rateconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
