//
//  requestcell.m
//  airlogic
//
//  Created by APPLE on 24/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "requestcell.h"

@implementation requestcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}

@synthesize lbldate = _lbldate;
@synthesize lblstatus=_lblstatus;
@synthesize lbltripname = _lbltripname;
@synthesize lblusername= _lblusername;
@synthesize imgprofile=_imgprofile;
@synthesize txtmesage=_txtmesage;
@synthesize btncancel=_btncancel;
@synthesize lblmonth=_lblmonth;
@synthesize lblstar=_lblstar;
@end
