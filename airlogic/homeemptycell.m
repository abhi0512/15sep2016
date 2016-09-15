//
//  homeemptycell.m
//  airlogic
//
//  Created by APPLE on 05/03/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "homeemptycell.h"

@implementation homeemptycell
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}
@synthesize lblname = _lblname;

@end
