//
//  ViewController.m
//  FingerprintVerification_Demo
//
//  Created by admin on 16/6/27.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    [self FingerprintVerification1];
    
    
    [self FingerprintVerification2];
    
    
    

}
//http://www.jianshu.com/p/4b402703d8f0
//iOS中的指纹识别技术Touch ID
-(void)FingerprintVerification2
{
    // 1. 判断iOS8.0及以上版本  从iOS8.0开始才有的指纹识别
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //2. LAContext : 本地验证对象上下文
        LAContext *context = [LAContext new];
        //3. 判断是否可用
        //Evaluate: 评估  Policy: 策略,方针
        //LAPolicyDeviceOwnerAuthenticationWithBiometrics: 允许设备拥有者使用生物识别技术
        if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            NSLog(@"对不起, 指纹识别技术暂时不可用");
        }
        //4. 开始使用指纹识别
        //localizedReason: 指纹识别出现时的提示文字, 一般填写为什么使用指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"开启了指纹识别, 将打开隐藏功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI,弹出提示框
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"指纹识别成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                });
            }
            if (error) {
                // 错误的判断chuli
                if (error.code == -2) {
                    NSLog(@"用户取消了操作");
                    // 取消操作，回主线程更新UI,弹出提示框
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户取消了操作" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                    });
                } else {
                    NSLog(@"错误: %@",error);
                    // 指纹识别出现错误，回主线程更新UI,弹出提示框
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
                
            }
            
        }];
    }else{
        NSLog(@"对不起, 该手机不支持指纹识别");
    }
}
//http://www.jianshu.com/p/904af8308ccf
//iOS 指纹识别
-(void)FingerprintVerification1
{

    // 1. 判断iOS8.0及以上版本  从iOS8.0开始才有的指纹识别
    if (!([UIDevice currentDevice].systemVersion.floatValue >= 8.0)) {
        NSLog(@"当前系统暂不支持指纹识别");
        return;
    }
    
    // 2. 创建LAContext对象 --> 本地验证对象上下文
    LAContext *context = [LAContext new];
    
    // 3.判断用户是否设置了Touch ID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        //4. 开始使用指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹验证登录" reply:^(BOOL success, NSError *error) {
            //4.1 验证成功
            if (success) {
                NSLog(@"验证成功");
            }
            
            //4.2 验证失败
            NSLog(@"error: %ld",error.code);
            
            if (error.code == -2) {
                NSLog(@"用户自己取消");
            }
            
            if (error.code != 0 && error.code != -2) {
                NSLog(@"验证失败");
            }
        }];
    } else {
        NSLog(@"请先设置Touch ID");
    }
}
@end
