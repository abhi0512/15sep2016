//
//  notificationcell.m
//  airlogic
//
//  Created by APPLE on 05/03/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "notificationcell.h"

@implementation notificationcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}
@synthesize img = _img;
@synthesize lblname = _lblname;
@synthesize lbldate=_lbldate;
@synthesize  btndelete=_btndelete;

@end
