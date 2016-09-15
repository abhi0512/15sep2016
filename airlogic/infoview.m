//
//  infoview.m
//  airlogic
//
//  Created by APPLE on 08/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "infoview.h"
#import <QuartzCore/QuartzCore.h>
@interface infoview ()

@end

@implementation infoview

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
