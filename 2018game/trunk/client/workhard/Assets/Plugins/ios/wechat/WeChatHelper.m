//
//  WeChatHelper.m
//  mobileinterface
//
//  Created by chilin on 2017/8/30.
//  Copyright © 2017年 chilin. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "WeChatManager.h"
#import "WXApi.h"

#if defined(__cplusplus)
extern "C" {
#endif
    
    bool isWeChatInstalled()
    {
        return [WXApi isWXAppInstalled];
    }
    
    bool isWXAppSupportApi()
    {
        return [WXApi isWXAppSupportApi];
    }
    
    void LoginWeChat(const char* authState)
    {
        [[WeChatManager sharedInstance] loginWeChat:[Helpers ToNSString:authState]];
    }

    void RegisterToWeChat(const char* appId, const char* appSecret)
    {
        [[WeChatManager sharedInstance] registerToWeChat:[Helpers ToNSString:appId] appSecret:[Helpers ToNSString:appSecret] bEnableMTA:FALSE];
    }
    
    
    void ShareTextMsgToWeChatFriend(const char* desc, const char* content)
    {
        [[WeChatManager sharedInstance] sendTextMsg:[Helpers ToNSString:desc] content:[Helpers ToNSString:content] scene:WXSceneSession];
    }
    
    void ShareTextMsgToWeChatMoments(const char* desc, const char* content)
    {
        [[WeChatManager sharedInstance] sendTextMsg:[Helpers ToNSString:desc] content:[Helpers ToNSString:content] scene:WXSceneTimeline];
    }
    
    void ShareLinkMsgToWeChatFriend(const char* title, const char* desc, const char* url, const char* imagePath)
    {
        [[WeChatManager sharedInstance] sendLinkMsg:[Helpers ToNSString:title ] desc:[Helpers ToNSString:desc] url:[Helpers ToNSString:url] thumbImage:[Helpers ToNSString:imagePath]scene:WXSceneSession];
    }
    
    void ShareLinkMsgToWeChatMoments(const char* title, const char* desc, const char* url, const char* imagePath)
    {
        [[WeChatManager sharedInstance] sendLinkMsg:[Helpers ToNSString:title] desc:[Helpers ToNSString:desc] url:[Helpers ToNSString:url] thumbImage:[Helpers ToNSString:imagePath]scene:WXSceneTimeline];
    }

    void ShareImageMsg(const char* title, const char* desc, const char*imagePath, const char* thumbImage, int scene)
    {
        [[WeChatManager sharedInstance] sendImageMsg:[Helpers ToNSString:title] desc:[Helpers ToNSString:desc] imagePath:[Helpers ToNSString:imagePath] thumbImage:[Helpers ToNSString:thumbImage] scene:(enum WXScene) scene];
    }

    void LogoutWeChat()
    {
        [[WeChatManager sharedInstance] logoutWeChat];
    }

    void BackupAccessToken(const char* token)
    {
        [[WeChatManager sharedInstance] backupAccessToken:[Helpers ToNSString:token]];
    }
    
    const char* GetAccessToken()
    {
        NSString* token = [[WeChatManager sharedInstance] GetAccessToken];
        
        return [token cStringUsingEncoding:NSUTF8StringEncoding];
    }

    const char* GetUserInfo()
    {
        return "";//[[WeChatManager sharedInstance] getus]
    }
#if defined(__cplusplus)
}
#endif
