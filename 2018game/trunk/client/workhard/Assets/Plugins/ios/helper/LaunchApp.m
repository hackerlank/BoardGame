//
//  LaunchApp.m
//  Unity-iPhone
//
//  Created by chilin on 2017/12/6.
//
//

#import <Foundation/Foundation.h>
#import "SendMsgUnity.h"
#if defined(__cplusplus)
extern "C" {
#endif
    BOOL iPhoneLaunchApp(const char* url)
    {
        BOOL bSuccess = false;
        if(url == nil )
        {
            return bSuccess;
        }
        NSString* str = [Helpers ToNSString:url];
        if([str length] <= 0)
        {
            return bSuccess;
        }
        
        NSURL* m_url = [NSURL URLWithString:str];
        
        if(m_url != nil && [UIApplication.sharedApplication canOpenURL:m_url] == true )
        {
            bSuccess = [UIApplication.sharedApplication openURL:m_url];
        }
        
        return bSuccess;
    }
    
#if defined(__cplusplus)
    extern "C" }
#endif
