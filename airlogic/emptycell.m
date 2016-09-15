//
//  emptycell.m
//  airlogic
//
//  Created by APPLE on 20/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "emptycell.h"

@implementation emptycell

-(void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}

@synthesize lblmsg = _lblmsg;
@end
