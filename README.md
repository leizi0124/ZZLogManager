# ZZLogManager
log日志重定向及显示  
使用方式：AppDelegate 中引入ZZLogManager.h 通过摇晃手机唤醒、双击关闭。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动方法
    SHOW_ZZLOG;
    return YES;
}
