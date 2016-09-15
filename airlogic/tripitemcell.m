//
//  tripitemcell.m
//  airlogic
//
//  Created by APPLE on 29/01/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "tripitemcell.h"

@implementation tripitemcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 2;
    frame.size.height -= 2 * 2;
    [super setFrame:frame];
}

@synthesize lbltripname = _lbltripname;
@synthesize lblvolume = _lblvolume;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lbltodate=_lbltodate;
@synthesize lblairlogiqcost = _lblairlogiqcost;
@synthesize lblcategory = _lblcategory;
@synthesize lblflybeecost = _lblflybeecost;
@synthesize lblservice= _lblservice;
@synthesize lbltripcost=_lbltripcost;
@synthesize lbltripid=_lbltripid;
@synthesize btnapproved = _btnapproved;
@synthesize btndeliver = _btndeliver;
@synthesize btncompleted = _btncompleted;
@synthesize btnpayment= _btnpayment;
@synthesize btnpickup=_btnpickup;
@synthesize btntransporting=_btntransporting;
@synthesize btnshow=_btnshow;
@synthesize lblflightname=_lblflightname;
@synthesize btncancel=_btncancel;
@synthesize lbltrid=_lbltrid;
@synthesize lbl1=_lbl1;
@synthesize lbl2=_lbl2;
@synthesize lbl3=_lbl3;
@synthesize lbl4=_lbl4;
@synthesize lbl5=_lbl5;
@synthesize lbl6=_lbl6;
@synthesize lbl7=_lbl7;

@end
