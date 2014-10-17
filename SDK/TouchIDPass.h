//
//  TouchIDPass.h
//  TouchIDPass
//
//  Created by 1ang7 on 14-10-16.
//  Copyright (c) 2014年 detecyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TouchIDPassDelegate;

@interface TouchIDPass : NSObject
@property (weak, nonatomic) id<TouchIDPassDelegate> delegate;
@property (assign, nonatomic, getter=hasAuthorized) BOOL hasAuthorized;

- (void)authorizeWithKey:(NSString *)key;
- (void)removeAuthorize;
- (void)touch;
@end




typedef NS_ENUM(NSUInteger, TouchIDPassResult) {
    TouchIDPassResultSuccess = 1,
    TouchIDPassResultFingerFailed,
    TouchIDPassResultUnauthorize,
    TouchIDPassResultUnsupportDevice,
};


@protocol TouchIDPassDelegate <NSObject>

@required
- (BOOL)touchIDPass:(TouchIDPass *)touchIDPass tokenValid:(NSString *)keyWithMD5;
@optional
- (void)touchIDPass:(TouchIDPass *)touchIDPass touchResult:(TouchIDPassResult)code;

@end