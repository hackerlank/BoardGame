//
//  Helper.m
//  Unity-iPhone
//
//  Created by chilin on 2017/12/6.
//
//

#import <Foundation/Foundation.h>
#import "SendMsgUnity.h"
@implementation Helpers

//conver char* to NSString*
+(NSString*) ToNSString:(const char*) str
{
    if(str)
    {
        return [[NSString alloc] initWithUTF8String:str ];
    }
    
    return [NSString stringWithFormat:@""];
}

//conver NSString to const char *
+(const char*) ToChar:(NSString*) str
{
    if(str)
    {
        return [str cStringUsingEncoding:NSUTF8StringEncoding];
    }
    return "";
}

@end
