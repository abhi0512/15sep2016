//
//  AbhiHttpPOSTRequest.h
//  AbhiHttprequest
//
//  Created by iMac on 1/14/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AbhiHttpPOSTRequest : NSMutableURLRequest
- (id)initWithURL:(NSURL *)url POSTData:(NSMutableDictionary*)dataDict;
@end
