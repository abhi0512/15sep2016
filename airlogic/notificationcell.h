//
//  notificationcell.h
//  airlogic
//
//  Created by APPLE on 05/03/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationcell : UITableViewCell
{
    
}
@property(nonatomic, strong) IBOutlet UILabel *lblname;
@property(nonatomic, strong) IBOutlet UILabel *lbldate;
@property(nonatomic, strong) IBOutlet UIImageView *img;
@property(nonatomic, strong) IBOutlet UIButton *btndelete;

@end
