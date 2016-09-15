//
//  inviteview.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "inviteview.h"
#import "DbHandler.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "homeViewController.h"
#import <MessageUI/MessageUI.h>


@interface inviteview ()

@end

@implementation inviteview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Share & Earn";
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    UIImage *buttonImage1 = [UIImage imageNamed:@"sidemenu.png"];
    
    UIButton *btnsidemenu1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnsidemenu1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    
    btnsidemenu1.frame = CGRectMake(0.0,0.0,25,25);
    
    UIBarButtonItem *aBarButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btnsidemenu1];
    
    [btnsidemenu1 addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:aBarButtonItem1];
    
    NSString *phnno=[DbHandler GetId:[NSString stringWithFormat:@"select promocode from usermaster where id='%@'",delegate.struserid]];
    
    if([phnno length ] > 0)
    {
        btn1.userInteractionEnabled=YES;
        btn2.userInteractionEnabled=YES;
        btn3.userInteractionEnabled=YES;
        btn4.userInteractionEnabled=YES;
        btn5.userInteractionEnabled=YES;
        btn6.userInteractionEnabled=YES;
        lblcode.text=phnno;
    }
    else
    {
        btn1.userInteractionEnabled=NO;
        btn2.userInteractionEnabled=NO;
        btn3.userInteractionEnabled=NO;
        btn4.userInteractionEnabled=NO;
        btn5.userInteractionEnabled=NO;
        btn6.userInteractionEnabled=NO;
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        [alert addButton:@"OK" target:self selector:@selector(okclick)];
        [alert showCustom:self image:[UIImage imageNamed:@"msg.png"] color:[UIColor orangeColor] title:@"Message" subTitle:@"Please enter your mobile number in order to use promotion code." closeButtonTitle:nil duration:0.0f];
        return;
    }

    
    
}
- (void)okclick
{
    homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:home animated:NO];
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Invitation Screen";
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtnsmsclick:(id)sender
{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
   // NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Checkout this app Airlogiq register with my reference code %@ and get benefits on your first order.Airlogiq- http://www.airlogiq.com",lblcode.text];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //[messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];

}
-(IBAction)onbtnemailclick:(id)sender
{
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@airlogiq.com"]];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Airlogiq Benefit"];
        NSString *msg = [NSString stringWithFormat:@"Checkout this app Airlogiq register with my reference code %@ and get benefits on your first order.Airlogiq- http://www.airlogiq.com",lblcode.text];
        [mail setMessageBody:msg isHTML:NO];
        [mail setToRecipients:@[@"testingEmail@example.com"]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
    
}
-(IBAction)onbtnwhatsappclick:(id)sender
{
    NSString *msg = [NSString stringWithFormat:@"Checkout this app Airlogiq register with my reference code %@ and get benefits on your first order.Airlogiq- http://www.airlogiq.com",lblcode.text];
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
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
