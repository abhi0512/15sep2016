//
//  howitworkVC.m
//  airlogic
//
//  Created by APPLE on 12/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import "howitworkVC.h"
#import "SWRevealViewController.h"
#import "homeViewController.h"

@interface howitworkVC ()

@end

@implementation howitworkVC
@synthesize scrollView;
@synthesize pageControl,btnskip,btnskipicon;
@synthesize imageArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"How It Work";
    revealController=[[SWRevealViewController alloc]init];
    revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.delegate=self;
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    //Put the names of our image files in our array.
    imageArray = [[NSArray alloc] initWithObjects:@"splash1.png", @"splash2.png", @"splash3.png", nil];
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
    
    [self setupScrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    NSLog(@"%ld",(long)index);
    self.pageControl.currentPage = page;
    
}
-(IBAction)onskipclick:(id)sender
{
    
    NSString *valueToSave = @"Y";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"hasSeenTutorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    homeViewController *login = [[homeViewController alloc]initWithNibName:@"homeViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:login animated:NO];
}
-(void) setupScrollView
{
    //add the scrollview to the view
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,58,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height-150)];
    self.scrollView.delegate=self;
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setAlwaysBounceVertical:NO];
    
    //setup internal views
    NSInteger numberOfViews = 3;
    
    for (int i = 0; i < numberOfViews; i++)
    {
        CGFloat xOrigin = i * self.view.frame.size.width;
        
        // add PageControl
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = 3;
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPage = i;
        
        
        btnskip = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnskip addTarget:self
                    action:@selector(onskipclick:)
          forControlEvents:UIControlEventTouchUpInside];
        [btnskip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnskip setTitle:@"Skip" forState:UIControlStateNormal];
        btnskip.titleLabel.font= [UIFont fontWithName:@"Roboto-Light" size:25];
        
        btnskipicon = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnskipicon addTarget:self
                        action:@selector(onskipclick:)
              forControlEvents:UIControlEventTouchUpInside];
        [btnskipicon setBackgroundImage:[UIImage imageNamed:@"skipbtn.png"] forState:UIControlStateNormal];
        
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:
                              CGRectMake(xOrigin,58,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height-150)];
        
        
        
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:i]]];      // imgArray is Array of Images
        image.contentMode = UIViewContentModeScaleToFill;
        image.tag=i;
        
        self.pageControl.frame = CGRectMake(xOrigin+image.frame.size.width/2.5, image.frame.size.height-40, 90, 37);
        btnskip.frame = CGRectMake(xOrigin+image.frame.size.width/2.5, self.view.frame.size.height-70, 60, 50.0);
        btnskipicon.frame=CGRectMake(xOrigin+btnskip.frame.size.width+image.frame.size.width/2.5,self.view.frame.size.height-55, 25, 25);
        
        
        [self.scrollView addSubview:image];
        [self.scrollView addSubview:self.pageControl];
        [self.view addSubview:self.btnskip];
        [self.view addSubview:btnskipicon];
    }
    
    //set the scroll view content size
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *
                                             numberOfViews,
                                             self.view.frame.size.height-150);
    
    [self.view addSubview:self.scrollView];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
    }
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    
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
