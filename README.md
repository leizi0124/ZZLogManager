# ZZLogManager
log日志重定向及显示
使用方式：AppDelegate 中引入ZZLogManager.h
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //启动方法
    SHOW_ZZLOG;
    return YES;
}