//
//  messageboxcell.m
//  airlogic
//
//  Created by APPLE on 04/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "messageboxcell.h"

@implementation messageboxcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}

@synthesize lblitemuser = _lblitemuser;
@synthesize lblname = _lblname;
@synthesize lbltripuser = _lbltripuser;
@synthesize imgprofile=_imgprofile;
@end
