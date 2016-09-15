//
//  flybeehomeviewcellTableViewCell.m
//  airlogic
//
//  Created by APPLE on 15/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "flybeehomeviewcellTableViewCell.h"

@implementation flybeehomeviewcellTableViewCell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.size.height -= 5 * 2;
    [super setFrame:frame];
}

@synthesize lbltripname = _lbltripname;
@synthesize lblto=_lblto;
@synthesize lblrating=_lblrating;
@synthesize lblvolume = _lblvolume;
@synthesize lblitemprice=_lblitemprice;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lblcur1=_lblcur1;
@synthesize lblcur2=_lblcur2;
@synthesize lblid=_lblid;
@synthesize lbltodate=_lbltodate;
@synthesize imgstar=_imgstar;

@end
