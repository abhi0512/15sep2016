//
//  AbhiHttpPOSTRequest.m
//  AbhiHttprequest
//
//  Created by iMac on 1/14/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "AbhiHttpPOSTRequest.h"

@implementation AbhiHttpPOSTRequest

- (id)initWithURL:(NSURL *)url POSTData:(NSMutableDictionary*)dataDict;
{
    NSString *boundary = @"BOUNDARY-ZL27H245XZXd8j2CCGzXzLvS5";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    self = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    
    if (self)
    {
        [self setHTTPMethod:@"POST"];
        [self addValue:contentType forHTTPHeaderField:@"Content-Type"];
        //
        NSMutableData* body = [[NSMutableData alloc] init];
        NSArray* allKeys = [dataDict allKeys];
        for(int i=0; i<[allKeys count]; i++){
            
            id key = [allKeys objectAtIndex:i];
            id value = [dataDict objectForKey:key];
            if([value isKindOfClass:[NSString class]]){
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if([value isKindOfClass:[UIImage class]]){
                NSTimeInterval  nowTime = [[NSDate date] timeIntervalSince1970];
                NSString* imageName = [NSString stringWithFormat:@"%f.png", nowTime];
                NSData* imageData = UIImagePNGRepresentation(value);
                //
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, imageName] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:imageData]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            else if([value isKindOfClass:[NSData class]]){
                NSTimeInterval  nowTime = [[NSDate date] timeIntervalSince1970];
                NSString* imageName = [NSString stringWithFormat:@"%f.png", nowTime];
                NSData* imageData = value;
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, imageName] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:imageData]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if([value isKindOfClass:[NSDate class]]){
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                
                NSString* valueDate = [df stringFromDate:value];
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, valueDate] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else{
                NSAssert(FALSE, @"[addPostValue: forKey:] invalid PostValue:%@, method only accept NSString,NSData or UIImage object as parameters.",[value class]);
            }
            
            if(i == ([allKeys count] - 1)){
                [body appendData:[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [self setHTTPBody:body];
    }
    
    return self;
}

@end
