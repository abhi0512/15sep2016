//
//  thanksview.m
//  airlogic
//
//  Created by APPLE on 14/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "thanksview.h"
#import <QuartzCore/QuartzCore.h>
#import "sendrequestvc.h"


@interface thanksview ()

@end

@implementation thanksview

- (void)viewDidLoad {
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onbtnokclick:(id)sender
{
    sendrequestvc *vc = [[sendrequestvc alloc]init];
    [vc dismissPopup];
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
