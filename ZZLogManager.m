/**
 * @ author zzl
 */

#import "ZZLogManager.h"
#import <CoreMotion/CoreMotion.h>

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface ZZLogManager ()<UIAccelerometerDelegate>
@property (nonatomic, strong) UITextView *logView;
@property (nonatomic, strong) CMMotionManager *motionManger;
@property (nonatomic, assign) BOOL logIsShow;
@end
@implementation ZZLogManager
+ (instancetype)sharedInstance {
    static  ZZLogManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZZLogManager alloc] init];
        manager.frame = [UIScreen mainScreen].bounds;
        
        manager.logView = [[UITextView alloc] initWithFrame:manager.bounds];
        manager.logView.textColor = [UIColor whiteColor];
        manager.logView.backgroundColor = [UIColor blackColor];
        manager.logView.font = [UIFont systemFontOfSize:13];
        manager.logView.layoutManager.allowsNonContiguousLayout = NO;
        manager.logView.editable = NO;
        [manager addSubview:manager.logView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:manager action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [manager.logView addGestureRecognizer:doubleTap];
        
        manager.motionManger = [[CMMotionManager alloc] init];
        
        if ([manager.motionManger isAccelerometerAvailable]) {
            manager.motionManger.accelerometerUpdateInterval = 0.1;
            NSLog(@"加速计可用");
            [manager.motionManger startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                // 获取加速计信息
                CMAcceleration acceleration = accelerometerData.acceleration;
                
                if (acceleration.x > 1.0 || acceleration.y > 1.0 || acceleration.z > 1.0) {
                    
                    [manager showZZLogView];
                }
            }];
        }else {
            NSLog(@"摇晃启动不可用");
        }
        
        [manager logRelocation];
        
        [[NSNotificationCenter defaultCenter]addObserver:manager selector:@selector(changeRotate) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    });
    return manager;
}
- (void)doubleTapAction:(id)tap {
    
    self.logIsShow = NO;
    [self removeFromSuperview];
}
#pragma 监测屏幕方向
- (void)changeRotate {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.logView.frame = [UIScreen mainScreen].bounds;
}
#pragma mark - 日志重定位
- (void)logRelocation {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [path objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];
    NSString *logPath = [document stringByAppendingPathComponent:fileName];
    
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    [defaulManager removeItemAtPath:logPath error:nil];
    
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
#pragma mark - 开启
- (void)showZZLogView {
    
    if (self.logIsShow) {
        return;
    }
    self.logIsShow = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:[ZZLogManager sharedInstance]];
    
    [ZZLogManager sharedInstance].logView.text = [self getLogContent];
    [[ZZLogManager sharedInstance].logView scrollRangeToVisible:NSMakeRange([ZZLogManager sharedInstance].logView.text.length, 1)];
}
#pragma 获取log内容
- (NSString *)getLogContent {
    
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"dr.log"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    return result;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
@end
