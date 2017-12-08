/**
 * @ author zzl
 * 使用：通过摇晃手机唤醒、双击关闭。
 */

#define SHOW_ZZLOG [ZZLogManager sharedInstance]
#import <UIKit/UIKit.h>

@interface ZZLogManager : UIView
+ (instancetype)sharedInstance;
@end
