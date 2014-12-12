//
//  ViewController.m
//  TouchIDPassDemo
//
//  Created by 1ang7 on 14-10-16.
//  Copyright (c) 2014年 detecyang. All rights reserved.
//

#import "ViewController.h"
#import "TouchIDPass.h"
#import <CommonCrypto/CommonDigest.h>

#define MY_KEY  @"test"

@interface ViewController () <TouchIDPassDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender
{
    TouchIDPass *tidp = [[TouchIDPass alloc] init];
    tidp.delegate = self;
    if ([tidp hasAuthorized]) {
        //调用指纹认证界面
        [tidp touch];
    }
    else {
        //去授权
        [self alertWithTitle:@"您未授权在app中使用指纹验证"
                     message:@"在此处调用授权流程，如登录。（这里为了演示简化步骤直接授权，请再次轻触主界面按钮）"];
        [tidp authorizeWithKey:MY_KEY];
    }
}

- (BOOL)touchIDPass:(TouchIDPass *)touchIDPass tokenValid:(NSString *)keyWithMD5
{
    const char *cStr = [MY_KEY UTF8String];
    unsigned char result[32] = {0};
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *ret = [NSString stringWithFormat:
                     @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
                     result[0],result[1],result[2],result[3],
                     result[4],result[5],result[6],result[7],
                     result[8],result[9],result[10],result[11],
                     result[12],result[13],result[14],result[15],
                     result[16], result[17],result[18], result[19],
                     result[20], result[21],result[22], result[23],
                     result[24], result[25],result[26], result[27],
                     result[28], result[29],result[30], result[31]];
    
    if ([ret isEqualToString:keyWithMD5]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)touchIDPass:(TouchIDPass *)touchIDPass touchResult:(TouchIDPassResult)code
{
    NSString *info;
    if (code == TouchIDPassResultSuccess) {
        info = @"在这里显示认证通过后的界面，如主界面。";
    }
    else if (code == TouchIDPassResultFingerFailed) {
        info = @"指纹认证失败。";
    }
    else if (code == TouchIDPassResultUnauthorize) {
        info = @"在你的代码中执行授权流程，如登录操作。";
    }
    else if (code == TouchIDPassResultUnsupportDevice) {
        info = @"您的设备不支持指纹解锁";
    }
    else {
        info = @"未知错误";
    }
    
    [self alertWithTitle:(code == TouchIDPassResultSuccess) ? @"认证成功" : @"认证失败"
                 message:info];
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
