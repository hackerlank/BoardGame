//
//  WeChatManager.m
//  mobileinterface
//
//  Created by chilin on 2017/8/30.
//  Copyright © 2017年 chilin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChatManager.h"
#import "SSKeyChain.h"
#import "WeChatConstant.h"

@interface WeChatManager ()<WXAuthDelegate>
@property (nonatomic, strong) NSString* m_authState;
@end

@implementation WeChatManager



+(WeChatManager*)sharedInstance
{
    static WeChatManager* m_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_sharedInstance = [[WeChatManager alloc] init];
    });
    return m_sharedInstance;
}

-(void) registerToWeChat:(NSString *)appId appSecret:(NSString *)appSecret bEnableMTA:(BOOL)bEnableMTA
{
    if(self.m_bInited == true)
        return;
    NSLog(@"registrer to we chat %@", appId);
    if(appId == nil || [appId isEqualToString:@""])
    {
        return;
    }
    
    if(appSecret == nil || [appSecret isEqualToString:@""])
    {
        return;
    }
    
    
    bool m_bSuccess = [WXApi registerApp:appId enableMTA:bEnableMTA];
    
    if(m_bSuccess == false)
    {
        NSLog(@"Failed to register self app to wechat");
        self.m_bInited = false;
    }
    else
    {
        self.m_bInited = true;
    }
    
    //save parameter
    self.m_appSecret = appSecret;
    self.m_appId = appId;
    self.bEnableMTA = bEnableMTA;
}

-(void) loginWeChat:(NSString *)authState
{
    //save the app name as the auth state
    self.m_authState = authState;
    //request auth
    //[self sendAuthReq];
    [SSKeychain deletePasswordForService:m_service account:m_authInfo];
    NSString* m_savedAuthInfo = [SSKeychain passwordForService:m_service account:m_authInfo];
    
    if(m_savedAuthInfo == nil || [m_savedAuthInfo length] <= 0)
    {
        [self sendAuthReq];
    }
    else
    {
        NSError *jsonParseError;
        
        NSData* data = [m_savedAuthInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic_auth = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
        
        if (jsonParseError != NULL)
        {
            NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
            
            UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        else
        {
            NSString* accessToken = [dic_auth objectForKey:m_accesTokenKey];
            NSString* refreshToken = [dic_auth objectForKey:m_refreshTokenKey];
            NSString* openId = [dic_auth objectForKey:m_openIdKey];

            NSString* value_errorcode = @"0";
            NSString* value_tip = @"登录成功";
            [dic_auth setValue:value_errorcode forKey:@"errcode"];
            [dic_auth setValue:value_tip forKey:@"errmsg"];
            NSString* json_str = [WeChatManager dictToJsonStr:dic_auth];
            UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [json_str cStringUsingEncoding:NSUTF8StringEncoding]);
            //[self isAccessTokenExpired:accessToken withOpenId: openId refreshToken:refreshToken];
        }
    }
}

-(void) logoutWeChat
{
    [SSKeychain setPassword:@"" forService:m_service account:m_authInfo];
}

-(void) backupAccessToken:(NSString*) accessToken
{
    [SSKeychain deletePasswordForService:m_service account:m_authInfo];
    NSString* m_savedAuthInfo = [SSKeychain passwordForService:m_service account:m_authInfo];
    NSError *jsonParseError;
        
    NSData* data = [m_savedAuthInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic_auth = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
    
    if (jsonParseError != NULL)
    {
        NSLog(@"Failed to save accessToken");
    }
    else
    {
        [dic_auth setValue:accessToken forKey:m_accesTokenKey];
        NSString* string_auth = [WeChatManager dictToJsonStr:dic_auth];
        [SSKeychain setPassword:string_auth forService:m_service account:m_authInfo];
    }
}

-(void) sendAuthReq
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = self.m_authState;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void) sendLinkMsg:(NSString *)title desc:(NSString *)desc url:(NSString *)url thumbImage:(NSString *)thumbImage scene:( enum WXScene)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = desc;
    [message setThumbImage:[UIImage imageNamed:thumbImage]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_SHARE";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

-(void) sendTextMsg:(NSString *)desc content:(NSString *)content scene:(enum WXScene)scene
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

-(void) sendImageMsg:(NSString*)title desc:(NSString*)desc imagePath:(NSString*)imagePath  thumbImage:(NSString*)thumbImage scene:( enum WXScene)scene
{
    WXImageObject* imgObj = [WXImageObject object];
    imgObj.imageData = [NSData dataWithContentsOfFile:imagePath];
    
    WXMediaMessage* msg = [WXMediaMessage message];
    [msg setThumbImage:[UIImage imageNamed:thumbImage]];
    msg.mediaObject = imgObj;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    req.scene = scene;
    [WXApi sendReq:req];

}


+(NSString *)dictToJsonStr:(NSDictionary *)dict
{
    
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}

-(bool)isWeChatInited
{
    return self.m_bInited;
}

-(void)getAccessToken:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.m_appId,self.m_appSecret,code];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     
     ^(NSURLResponse *response,NSData *data,NSError *connectionError)
     
     {
         
         if (connectionError != NULL)
         {
             NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-101\",\"errmsg\":\"%@\"}", connectionError.description];
             
             //@todo notification unity?
             NSLog(@"[getuserinfo parse json failure with:: %@",jsonStr);
             
             UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
         }
         else
         {
             
             if (data != NULL)
             {
                 
                 NSError *jsonParseError;
                 
                 NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
                 
                 NSString* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 
                 result = [NSString stringWithFormat:@"%@", result];
                 if (jsonParseError != NULL)
                 {
                     NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
                     
                     UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
                 else
                 {
                 
                     NSString *accessToken = [responseData valueForKey:m_accesTokenKey];
                     NSString *openid = [responseData valueForKey:m_openIdKey];
                     NSString *refreshToken = [responseData valueForKey:m_refreshTokenKey];

                     if(result == nil )
                     {
                         result = @"";
                     }
                    
                     [SSKeychain setPassword:result forService:m_service account:m_authInfo];
                     NSString* json_str = nil;
                     if([[responseData allKeys] containsObject:@"errcode"] == false)
                     {
                        NSDictionary* dic = [NSDictionary init];
                        NSString* value_errorcode = @"0";
                        NSString* value_tip = @"登录成功";
                        [dic setValue:accessToken forKey:m_accesTokenKey];
                        [dic setValue:refreshToken forKey:m_refreshTokenKey];
                        [dic setValue:openid forKey:m_openIdKey];
                        [dic setValue:value_errorcode forKey:@"errcode"];
                        [dic setValue:value_tip forKey:@"errmsg"];
                        NSString* json_str = [WeChatManager dictToJsonStr:dic];
                     }
                     else
                     {
                         json_str = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
                     }
                     UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [json_str cStringUsingEncoding:NSUTF8StringEncoding]);
                     //[self getUserInfo:accessToken withOpenId:openid];
                 }
             }  
             
         }  
         
     }];
}

-(void) getUserInfo
{

    [SSKeychain deletePasswordForService:m_service account:m_authInfo];
    NSString* m_savedAuthInfo = [SSKeychain passwordForService:m_service account:m_authInfo];
    
    NSString* accessToken = @"";
    NSString* openId = @"";
    if(m_savedAuthInfo == nil || [m_savedAuthInfo length] <= 0)
    {
        NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-102\",\"errmsg\":\"%无授权信息\"}"];
             
         //@todo notification unity?
         NSLog(@"[getuserinfo parse json failure with:: %@",jsonStr);
         
         UnitySendMessage(m_CallBackWrapper, m_onWeChatGetUserInfo, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
         return;
    }
    else
    {
        NSError *jsonParseError;
        
        NSData* data = [m_savedAuthInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic_auth = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
        
        if (jsonParseError != NULL)
        {
            NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
            
            UnitySendMessage(m_CallBackWrapper, m_onWeChatGetUserInfo, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
            return;
        }
        else
        {
            accessToken = [dic_auth objectForKey:m_accesTokenKey];
            openId = [dic_auth objectForKey:m_openIdKey];
        }
    }

    NSString *path = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     
     ^(NSURLResponse *response,NSData *data,NSError *connectionError) {
         
         if (connectionError != NULL)
         {
             NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-101\",\"errmsg\":\"%@\"}", connectionError.description];
             
             //@todo notification unity?
             NSLog(@"[getuserinfo parse json failure with:: %@",jsonStr);
             
             UnitySendMessage(m_CallBackWrapper, m_onWeChatGetUserInfo, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
         }
         else
         {
             if (data != NULL)
             {
                 NSError *jsonError;
                 NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                
                 if (jsonError != NULL)
                 {
                     //parse json error , should us notificaiton unity?
                     NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
                     
                     UnitySendMessage(m_CallBackWrapper, m_onWeChatGetUserInfo, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
                 else
                 {
                     if([[responseData allKeys] containsObject:@"errcode"] == false)
                     {
                        
                        NSString* value_errorcode = @"0";
                        NSString* value_tip = @"查询用户信息成功";
                        [responseData setValue:value_errorcode forKey:@"errcode"];
                        [responseData setValue:value_tip forKey:@"errmsg"];
                       
                     }
                     NSString* json_str = [WeChatManager dictToJsonStr:responseData];
                     UnitySendMessage(m_CallBackWrapper, m_onWeChatGetUserInfo, [json_str cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
                 
             }  
             
         }  
         
     }];  
    
}

-(void) isAccessTokenExpired:(NSString *)accessToken withOpenId:(NSString *)openId refreshToken:(NSString*)refreshToken
{
    NSString *path = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",accessToken,openId];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     
     ^(NSURLResponse *response,NSData *data,NSError *connectionError)
     {
         
         if (connectionError != NULL)
         {
             
             NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-101\",\"errmsg\":\"%@\"}", connectionError.description];
             
             //@todo notification unity?
             NSLog(@"[isAccessTokenExpired parse json failure with:: %@",jsonStr);
             
             UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
         }
         else
         {
             
             if (data != NULL)
             {
                 
                 NSError *jsonError;
                 
                 NSDictionary *dic_json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                 
               
                 if(jsonError == nil)
                 {
                     NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
                     UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
                 else
                 {
                     //parse json error , should us notificaiton unity?
                     NSInteger errcode = [[dic_json valueForKey:@"errcode"] integerValue];
                     if(errcode == 0)
                     {
                        NSDictionary* dic = [NSDictionary init];
                        NSString* value_errorcode = @"0";
                        NSString* value_tip = @"登录成功";
                        [dic setValue:accessToken forKey:m_accesTokenKey];
                        [dic setValue:refreshToken forKey:m_refreshTokenKey];
                        [dic setValue:openId forKey:m_openIdKey];
                        [dic setValue:value_errorcode forKey:@"errcode"];
                        [dic setValue:value_tip forKey:@"errmsg"];
                        NSString* str = [WeChatManager dictToJsonStr:dic];
                         
                        UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [str cStringUsingEncoding:NSUTF8StringEncoding]);              
                     }
                     else
                     {
                         [self refreshAccesToken:accessToken withRefreshToken:refreshToken];
                     }
                 }
             }
             
         }
         
     }];

    
}

-(void) refreshAccesToken:(NSString *)appId withRefreshToken:(NSString *)refreshToken
{
    NSString *path = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",appId,refreshToken];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     
     ^(NSURLResponse *response,NSData *data,NSError *connectionError)
    {
         
         if (connectionError != NULL)
         {
             
             NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-101\",\"errmsg\":\"%@\"}", connectionError.description];
             
             //@todo notification unity?
             NSLog(@"[refreshAcceseToken parse json failure with:: %@",jsonStr);
             
              UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
         }
         else
         {
             
             if (data != NULL)
             {
                 
                 NSError *jsonError;
                 
                 NSString *jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                 
                 jsonStr = [NSString stringWithFormat:@"%@", jsonStr];
                 if(jsonError == nil)
                 {
                     NSDictionary* dic_json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                     if(dic_json != nil )
                     {
                         if([[dic_json allKeys] containsObject:@"errcode"] == false)
                         {
                             [SSKeychain deletePasswordForService:m_service account:m_authInfo];
                             
                             //save the latest auth info
                             [SSKeychain setPassword:jsonStr forService:m_service account:m_authInfo];


                             NSString *accessToken = [dic_json valueForKey:m_accesTokenKey];
                             NSString *openid = [dic_json valueForKey:m_openIdKey];
                             NSString *refreshToken = [dic_json valueForKey:m_refreshTokenKey];
                             NSDictionary* dic = [NSDictionary init];
                             NSString* value_errorcode = @"0";
                             NSString* value_tip = @"登录成功";
                             [dic setValue:accessToken forKey:m_accesTokenKey];
                             [dic setValue:refreshToken forKey:m_refreshTokenKey];
                             [dic setValue:openid forKey:m_openIdKey];
                             [dic setValue:value_errorcode forKey:@"errcode"];
                             [dic setValue:value_tip forKey:@"errmsg"];
                             jsonStr = [WeChatManager dictToJsonStr:dic];
                         }
                     }
                     UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
                 else
                 {
                     //parse json error , should us notificaiton unity?
                     
                     NSString* jsonStr = [NSString stringWithFormat: @"{\"errcode\":\"-100\",\"errmsg\":\"parse json failure\"}"];
                     
                     UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
                 }
             }
             
         }  
         
     }];  
}

-(NSString*) GetAccessToken
{
    NSString* authInfo = [SSKeychain passwordForService:m_service account:m_authInfo];
    NSString* token = @"";
    if(authInfo == nil || [authInfo length] <= 0)
    {
        return token;
    }
    
    NSError* error = nil;
    
    NSData* data = [authInfo dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* dic_json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(error != nil )
    {
        return token;
    }
    return [dic_json valueForKey:m_accesTokenKey];
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req
{
    // just leave it here, WeChat will not call our app
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        /* Prevent Cross Site Request Forgery */
        if (![authResp.state isEqualToString:self.m_authState]) {
            
            [self wxAuthDenied];
            return;
        }

        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                 
                [self wxAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                [self wxAuthDenied];
                break;
            case WXErrCodeUserCancel:
                [self wxAuthCancel];
            default:
                break;
        }
    }
    else if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp* shareResp = (SendMessageToWXResp*) resp;
     
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        NSNumber *num =[NSNumber numberWithInt:shareResp.errCode];
        [dic setObject:num forKey:@"errcode"];
        NSString *errMsg = @"";
        if(shareResp.errCode == 0)
        {
            errMsg = @"分享成功";
        }
        else
        {
            errMsg = shareResp.errStr;
        }
        [dic setObject:errMsg forKey:@"errmsg"];
                
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString* rsp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        UnitySendMessage(m_CallBackWrapper,m_onWeChatShare, [rsp cStringUsingEncoding:NSUTF8StringEncoding]);
        
    }
}

#pragma mark - WXAuthDelegate
-(void) wxAuthSucceed:(NSString *)code
{
    [self getAccessToken:code];
}

-(void) wxAuthCancel
{
    NSString* jsonStr = [NSString stringWithFormat:@"{\"errcode\":\"-2\",\"errmsg\":\"%@\"}",  @"用户点击取消并返回"];
    UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void) wxAuthDenied
{
    NSString* jsonStr = [NSString stringWithFormat:@"{\"errcode\":\"-4\",\"errmsg\":\"%@\"}",  @"授权失败"];
    UnitySendMessage(m_CallBackWrapper, m_onLoginWeChat, [jsonStr cStringUsingEncoding:NSUTF8StringEncoding]);
}
@end
