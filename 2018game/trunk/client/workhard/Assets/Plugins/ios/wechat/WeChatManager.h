//
//  WeChatManager.h
//  mobileinterface
//
//  Created by chilin on 2017/8/30.
//  Copyright © 2017年 chilin. All rights reserved.
//

#ifndef WeChatManager_h
#define WeChatManager_h

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "SendMsgUnity.h"

@protocol WXAuthDelegate <NSObject>

@optional
- (void)wxAuthSucceed:(NSString*)code;
- (void)wxAuthDenied;
- (void)wxAuthCancel;

@end

@interface WeChatManager : NSObject<WXApiDelegate, WXAuthDelegate>

+(instancetype) sharedInstance;

@property (nonatomic, setter=setAppId:, getter=m_appId) NSString* m_appId;

@property (nonatomic, setter=setAppSecret:, getter=getAppSecret) NSString* m_appSecret;

@property (nonatomic, setter=setBEnableMTA:, getter=bEnableMTA) BOOL m_bEnableMTA;

@property (nonatomic) bool m_bInited;


//register appid to wechat
-(void) registerToWeChat:(NSString*)appId appSecret:(NSString*)appSecret bEnableMTA:(BOOL)bEnableMTA;

//login to wechat
-(void) loginWeChat:(NSString*)authState;

//send text msg to wechat
//@param desc a string to descripte this message
//@param content message content
//@param scene timeline or friend
-(void) sendTextMsg:(NSString*)desc content:(NSString*)content scene:( enum WXScene)scene;

//send link msg to wechat
//@param title message title
//@param desc a string to descripte this message
//@param url something will be render when player touch this messge
//@param imagePath the message image
//@scene timeline or friend
-(void) sendLinkMsg:(NSString*)title desc:(NSString*)desc url:(NSString*)url thumbImage :(NSString*)thumbImage scene:(enum WXScene)scene;

//send image message to friend
//@param title message title
//@param desc a string to descripte this message
//@param url something will be render when player touch this messge
//@param imagePath the message image
//@scene timeline or friend
-(void) sendImageMsg:(NSString*)title desc:(NSString*)desc imagePath:(NSString*)imagePath thumbImage:(NSString*) thumbImage scene:(NSInteger)scene;

//send auth req
-(void) sendAuthReq;

-(bool) isWeChatInited;

//get accesstoken
-(void) getAccessToken:(NSString*) code;

//get user info
-(void) getUserInfo:(NSString*) accessToken withOpenId:(NSString*) openId;

//whether the access token has expired
-(void) isAccessTokenExpired:(NSString*) accessToken withOpenId:(NSString*)openId refreshToken:(NSString*)refreshToken;

//refresh access token with oldToken and refreshToken
//if refresh token has expired. so we need to re-auth
-(void) refreshAccesToken:(NSString*) appId withRefreshToken:(NSString*) refreshToken;


//logout wechat; clean up all author information
-(void) logoutWeChat;

//backup wechat access token. update accessToken
-(void) backupAccessToken:(NSString*)accessToken;

-(NSString*) GetAccessToken;
@end



#endif /* WeChatManager_h */
