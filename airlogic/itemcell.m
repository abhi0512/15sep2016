//
//  itemcell.m
//  airlogic
//
//  Created by APPLE on 01/02/16.
//  Copyright © 2016 airlogic. All rights reserved.
//

#import "itemcell.h"

@implementation itemcell

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 2;
    frame.size.height -= 2 * 2;
    [super setFrame:frame];
}

@synthesize lbltripname = _lbltripname;
@synthesize lblvolume = _lblvolume;
@synthesize lblweight = _lblweight;
@synthesize fromcity= _fromcity;
@synthesize lblstar=_lblstar;
@synthesize lblotp=_lblotp;
@synthesize lbltodate=_lbltodate;
@synthesize tocity=_tocity;
@synthesize imgprofile=_imgprofile;
@synthesize lbldate=_lbldate;
@synthesize lbltripcost=_lbltripcost;
@synthesize lblsenderid=_lblsenderid;
@synthesize btnapproved = _btnapproved;
@synthesize btndeliver = _btndeliver;
@synthesize btncompleted = _btncompleted;
@synthesize btnpayment= _btnpayment;
@synthesize btnpickup=_btnpickup;
@synthesize btntransporting=_btntransporting;
@synthesize btncancel=_btncancel;
@synthesize lblcurrecy=_lblcurrecy;
@synthesize lblpayment=_lblpayment;
@synthesize lblitemid=_lblitemid;
@end
