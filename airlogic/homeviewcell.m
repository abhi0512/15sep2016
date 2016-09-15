//
//  homeviewcell.m
//  airlogic
//
//  Created by APPLE on 02/01/16.
//  Copyright (c) 2016 airlogic. All rights reserved.
//

#import "homeviewcell.h"

@implementation homeviewcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}

@synthesize lbltripname = _lbltripname;
@synthesize lblvolume = _lblvolume;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lblflightname=_lblflightname;
@synthesize lblrating=_lblrating;
@synthesize imgstar=_imgstar;


@end
