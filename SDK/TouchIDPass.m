//
//  TouchIDPass.m
//  TouchIDPass
//
//  Created by 1ang7 on 14-10-16.
//  Copyright (c) 2014年 detecyang. All rights reserved.
//

#import "TouchIDPass.h"
#import <CommonCrypto/CommonDigest.h>
@import UIKit;
@import LocalAuthentication;

@interface TouchIDPass ()
{
    NSString * _key;
}
@end




@implementation TouchIDPass

- (id)init
{
    self = [super init];
    if (self) {
        const char data[] = {0x74,0x69,0x64,0x70,0x2e,0x0};
        NSString *pre = [NSString stringWithUTF8String:data];
        _key = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        _key = [pre stringByAppendingString:_key];
    }
    return self;
}

- (BOOL)hasAuthorized
{
    NSString *keyWithMD5 = [self token];
    if (!keyWithMD5 || [keyWithMD5 isEqualToString:@""]) {
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDPass:tokenValid:)]) {
        return [self.delegate touchIDPass:self tokenValid:keyWithMD5];
    }
    else {
        return NO;
    }
}

- (void)authorizeWithKey:(NSString *)key
{
    [self setToken:key];
}

- (void)removeAuthorize
{
    [self setToken:nil];
}

- (void)touch
{
    if ([self canEvaluatePolicy]) {
        [self evaluatePolicy];
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDPass:touchResult:)]) {
            return [self.delegate touchIDPass:self touchResult:TouchIDPassResultUnsupportDevice];
        }
    }
}



#pragma mark - Tests
- (BOOL)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    return success;
}

- (void)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    
    // set text for the localized fallback button
    context.localizedFallbackTitle = @"fallback button";
    
    // show the authentication UI with our reason string
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"localizedReason" reply:
     ^(BOOL success, NSError *authenticationError) {
         TouchIDPassResult result;
         if (success) {
             result = TouchIDPassResultSuccess;
         } else {
             result = TouchIDPassResultFingerFailed;
         }
         if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDPass:touchResult:)]) {
             return [self.delegate touchIDPass:self touchResult:TouchIDPassResultUnsupportDevice];
         }
     }];
    
}


#pragma mark - private methods
- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:_key];
}

- (void)setToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:[self md5:token] forKey:_key];
}

- (NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
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
    return ret;
}

@end
