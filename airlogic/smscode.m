//
//  smscode.m
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "smscode.h"
#import "uploadgovtidvc.h"
#import "AbhiHttpPOSTRequest.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "profilevc.h"
#import "DbHandler.h"



@interface smscode ()

@end

@implementation smscode
@synthesize userid,pagefrom,phoneno,code;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Code Verification";
    if([pagefrom isEqualToString:@"Y"]|| [pagefrom isEqualToString:@"H"] || [pagefrom isEqualToString:@"P"])
    {
        UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
    }
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    

    
    UIToolbar* priceToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    priceToolbar.barStyle = UIBarStyleBlackOpaque;
    priceToolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad)],
                          nil];
    [priceToolbar sizeToFit];
    txt1.inputAccessoryView = priceToolbar;
    
    
    
    
    UIToolbar* priceToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    priceToolbar2.barStyle = UIBarStyleBlackOpaque;
    priceToolbar2.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad2)],
                           nil];
    [priceToolbar2 sizeToFit];
    txt2.inputAccessoryView = priceToolbar2;
    
    UIToolbar* priceToolbar3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    priceToolbar3.barStyle = UIBarStyleBlackOpaque;
    priceToolbar3.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad3)],
                           nil];
    [priceToolbar3 sizeToFit];
    txt3.inputAccessoryView = priceToolbar3;
    
    UIToolbar* priceToolbar4 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    priceToolbar4.barStyle = UIBarStyleBlackOpaque;
    priceToolbar4.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clearpricepad4)],
                           nil];
    [priceToolbar4 sizeToFit];
    txt4.inputAccessoryView = priceToolbar4;
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)onbtnverifyclick:(id)sender
{
    if([pagefrom isEqualToString:@"H"] || [pagefrom isEqualToString:@"P"])
    {
        profilevc *profile = [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
        [self.navigationController pushViewController:profile animated:NO];
    }
    else
    {
        uploadgovtidvc *upload = [[uploadgovtidvc alloc]initWithNibName:@"uploadgovtidvc" bundle:nil];
        [self.navigationController pushViewController:upload animated:NO];
    }
}
-(IBAction)onbtnskipclick:(id)sender
{
    uploadgovtidvc *upload = [[uploadgovtidvc alloc]initWithNibName:@"uploadgovtidvc" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:upload animated:NO];
}

-(void)clearpricepad{
    [txt1 resignFirstResponder];
}
-(void)clearpricepad2{
    [txt2 resignFirstResponder];
}
-(void)clearpricepad3{
    [txt3 resignFirstResponder];
}
-(void)clearpricepad4{
    [txt4 resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y / 2; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
