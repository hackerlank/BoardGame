//
//  SendMsgUnity.h
//  mobileinterface
//
//  Created by chilin on 2017/8/30.
//  Copyright © 2017年 chilin. All rights reserved.
//

#ifndef SendMsgUnity_h
#define SendMsgUnity_h
#import <Foundation/Foundation.h>

#pragma mark - Helpers
@interface Helpers : NSObject

//convert char* to NSString*
+(NSString*) ToNSString:(const char*) str;

//conver NSString to const char *
+(const char*) ToChar:(NSString*) str;

@end






#if defined(__cplusplus)
extern "C" {
#endif
    extern void UnitySendMessage(const char* obj, const char* method, const char* msg);
#if defined(__cplusplus)
}
#endif

#endif /* SendMsgUnity_h */
