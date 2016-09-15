//
//  viewidimage.h
//  airlogic
//
//  Created by APPLE on 29/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"
@interface viewidimage : GAITrackedViewController
{
    IBOutlet UIImageView *picture;;
}
@property(nonatomic,strong)NSString *strurl;
@end
