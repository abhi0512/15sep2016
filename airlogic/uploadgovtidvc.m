//
//  uploadgovtidvc.m
//  airlogic
//
//  Created by APPLE on 08/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "uploadgovtidvc.h"
#import "homeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "AbhiHttpPOSTRequest.h"
#import "profilevc.h"
#import "SCLAlertView.h"

@interface uploadgovtidvc ()

@end

@implementation uploadgovtidvc
@synthesize pagefrom;
- (void)viewDidLoad {
    self.title=@"Upload ID";
    [super viewDidLoad];
   
    responseData = [NSMutableData data];
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    if([pagefrom isEqualToString:@"Y"] || [pagefrom isEqualToString:@"H"])
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
    btncross.alpha=0;
    imgview.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Upload Govt. ID Screen";
    
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    UITapGestureRecognizer *imgtap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(imageclick:)];
    [imgprofile addGestureRecognizer:imgtap];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btncrossclick:(id)sender
{
    btncross.alpha=0;
    btncross.frame=CGRectMake(self.view.frame.size.width-199,self.view.frame.size.width-262,15, 15);
    imgview.hidden=YES;
    imgprofile.hidden=NO;
    isuploaded=@"N";
    imgprofile.image=[UIImage imageNamed:@"camimg.png"];
}
-(IBAction)onbtnverifyclick:(id)sender
{
    
    if(![isuploaded isEqualToString:@"Y"])
    {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Upload Vailid ID." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *strurl= [AppDelegate baseurl];
    strurl= [strurl stringByAppendingString:@"uploaduserid"];
    
    NSMutableDictionary *postdata= [[NSMutableDictionary alloc]init];
    [postdata setObject:delegate.struserid forKey:@"userid"];
    
    if([isuploaded isEqualToString:@"Y"])
    {
        UIImage *profile=[self resizeImage:imgview.image resizeSize:CGSizeMake(800,800)];
        [postdata setObject:profile forKey:@"uploadid"];
    }
    else
    {
        [postdata setObject:@"" forKey:@"uploadid"];
    }
    
    AbhiHttpPOSTRequest *request = [[AbhiHttpPOSTRequest alloc]initWithURL:[NSURL URLWithString:strurl] POSTData:postdata];
        
    if([delegate isConnectedToNetwork])
    {
        [self addProgressIndicator];
        urlconn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet !" message:@"No working Internet connection is found. Try Again." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }

    
}
-(IBAction)onbtnskipclick:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if([delegate.logintype isEqualToString:@"FB"])
    {
        homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
        [self.navigationController pushViewController:home animated:NO];
    }
   else if(![pagefrom isEqualToString:@"Y"])
    {
        homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
        home.logintype=@"";
        delegate.logintype=@"";
        [self.navigationController pushViewController:home animated:NO];
    }
    else
    {
        profilevc *profile= [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
        [self.navigationController pushViewController:profile animated:NO];
        
    }
}
- (void)imageclick:(UITapGestureRecognizer *)recognizer
{
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
    //Do stuff here...
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
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    imgprofile.hidden=YES;
    imgview.hidden=NO;
    btncross.frame=CGRectMake(self.view.frame.size.width-27,self.view.frame.size.width-70,15, 15);
    
    imgview.image=image;
    isuploaded=@"Y";
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    btncross.alpha=1;
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
    
    if(connection == urlconn)
    {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *deserializedData = [responseString objectFromJSONString];
    NSString *string = [deserializedData objectForKey:@"response_code"];
    
    if([string isEqualToString:@"200"])
    {
        [self removeProgressIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundViewColor=[UIColor whiteColor];
        [alert addButton:@"OK" target:self selector:@selector(okclick)];
        [alert showCustom:self image:[UIImage imageNamed:@"thankyou.png"] color:[UIColor orangeColor] title:@"Thank you!" subTitle:@"ADMIN will verify the ID details and approve it.It may take upto 8 hours." closeButtonTitle:nil duration:0.0f];
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

-(void)okclick
{
           CATransition *transition = [CATransition animation];
            transition.duration = 0.45;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.type = kCATransitionFromRight;
            [transition setType:kCATransitionPush];
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            if(![pagefrom isEqualToString:@"Y"])
            {
                homeViewController *home = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
                home.logintype=@"";
                delegate.logintype=@"";
                [self.navigationController pushViewController:home animated:NO];
            }
            else
            {
                profilevc *profile= [[profilevc alloc]initWithNibName:@"profilevc" bundle:nil];
                [self.navigationController pushViewController:profile animated:NO];
                
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
