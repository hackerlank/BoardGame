//
//  ClipBoard.m
//  Unity-iPhone
//
//  Created by chilin on 2017/12/6.
//
//

#import <Foundation/Foundation.h>
#import "SendMsgUnity.h"
@interface Clipboard :NSObject

@end

@implementation Clipboard

+(BOOL) SetClipboardMsg:(NSString*) msg
{
    UIPasteboard* board = [UIPasteboard generalPasteboard];
    if(board != NULL)
    {
        [board setString:msg];
        return true;
    }
    
    return false;
}

+(NSString*) GetClipboardMsg
{
    NSString* ss = @"";
    UIPasteboard* board = [UIPasteboard generalPasteboard];
    
    if(board)
    {
        ss = [board string];
    }
    
    return ss;
}
@end
#if defined(__cplusplus)
extern "C" {
#endif
    BOOL SetMsgToClipboard(const char* msg)
    {
        BOOL bSuccess = [Clipboard SetClipboardMsg:[Helpers ToNSString:msg]];
        return bSuccess;
    }
    
    char* GetMsgFromClipboard()
    {
        return strdup([Helpers ToChar:[Clipboard GetClipboardMsg]]);
    }
#if defined(__cplusplus)
    extern "C" }
#endif
