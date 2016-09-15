//
//  categorycell.h
//  airlogic
//
//  Created by APPLE on 29/12/15.
//  Copyright (c) 2015 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categorycell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lblcat;
@property(nonatomic, strong) IBOutlet UILabel *lbldesc;
@property (nonatomic, strong) IBOutlet UIImageView *imgcat;
@property (nonatomic, strong) IBOutlet UIButton *btncircle;
@end
