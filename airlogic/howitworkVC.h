//
//  howitworkVC.h
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface howitworkVC : UIViewController<UIScrollViewDelegate,SWRevealViewControllerDelegate>
{
  SWRevealViewController *revealController;
    IBOutlet UIButton *btnskip;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *btnskip;
@property(nonatomic,strong)IBOutlet UIButton *btnskipicon;
@property (nonatomic, strong) NSArray *imageArray;
@end
