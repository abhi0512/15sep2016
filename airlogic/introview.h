//
//  introview.h
//  airlogic
//
//  Created by abhishek on 12/03/2016.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@interface introview : GAITrackedViewController<UIScrollViewDelegate>
{
    BOOL islast;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *btnskip;
@property(nonatomic,strong)IBOutlet UIButton *btnskipicon;
@property (nonatomic, strong) NSArray *imageArray;

-(IBAction)onskipclick:(id)sender;
@end
