#import "UnityAppController.h"
#import "WXApi.h"
#import "WeChatManager.h"

@interface TheGodsAPPController : UnityAppController

@end

@implementation TheGodsAPPController

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    //[WXApi registerApp:@"wx730dca9bb5e4dcdc" ];// withDescription:m_desc];
    
    return YES;
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    NSLog(@"TheGodsAPPController::openURL1");
    
    WeChatManager* sharedInstance = [WeChatManager sharedInstance];
    if([sharedInstance isWeChatInited])
    {
        [WXApi handleOpenURL:url delegate:sharedInstance];
    }
    return YES;
}

- (BOOL)application:(UIApplication*)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id>*)options
{

    NSLog(@"TheGodsAPPController::openURL2");
    
    WeChatManager* sharedInstance = [WeChatManager sharedInstance];
    if([sharedInstance isWeChatInited])
    {
        [WXApi handleOpenURL:url delegate:sharedInstance];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"TheGodsAPPController::handlerOpenURL");
    
    WeChatManager* sharedInstance = [WeChatManager sharedInstance];
    if([sharedInstance isWeChatInited])
    {
        [WXApi handleOpenURL:url delegate:sharedInstance];
    }
    return YES;
}
@end
IMPL_APP_CONTROLLER_SUBCLASS (TheGodsAPPController)
