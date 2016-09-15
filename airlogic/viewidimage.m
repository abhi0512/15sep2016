//
//  viewidimage.m
//  airlogic
//
//  Created by APPLE on 29/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "viewidimage.h"
#import  "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface viewidimage ()

@end

@implementation viewidimage
@synthesize strurl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"Govt. ID";
    
        UIImage *buttonImage = [UIImage imageNamed:@"backbtn.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = customBarItem;
   

    NSString *imgpath= @"";

    imgpath=[imgpath stringByAppendingString:@"http://airlogiq.com/temp/uploadids/"];
    imgpath=[imgpath stringByAppendingString:strurl];
    picture.contentMode = UIViewContentModeScaleAspectFit;

    [picture setImageWithURL:[NSURL URLWithString:imgpath] placeholderImage:[UIImage imageNamed:@""] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.screenName = @"Govt ID Screen";
    [super viewDidAppear:animated];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
