//
//  WeChatConstant.h
//  mobileinterface
//
//  Created by chilin on 2017/8/30.
//  Copyright © 2017年 chilin. All rights reserved.
//

#ifndef WeChatConstant_h

static const char*  m_CallBackWrapper = "WeChatCallbackWrapper";
static const char* m_onLoginWeChat = "onLoginWeChat";
static const char* m_onWeChatShare = "onWeChatShare";
static const char* m_onWeChatPay = "onWeChatPay";
static const char* m_onWeChatGetUserInfo = "onWeChatGetUserInfo";

//keychain service
static NSString* m_service = @"TheGods";
static NSString* m_authInfo = @"auth_info";

static  NSString* m_accesTokenKey = @"access_token";
static  NSString* m_openIdKey = @"openid";
static  NSString* m_refreshTokenKey = @"refresh_token";
static  NSString* m_unionIdkey = @"unionid";
static  NSString* m_expiredinKey = @"expiredin";


#define WeChatConstant_h


#endif /* WeChatConstant_h */
