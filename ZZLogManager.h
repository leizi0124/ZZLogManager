/**
 * @ author zzl
 */

#define SHOW_ZZLOG [ZZLogManager sharedInstance]
#import <UIKit/UIKit.h>

@interface ZZLogManager : UIView
+ (instancetype)sharedInstance;
@end
