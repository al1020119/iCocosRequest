//
//  AFNManager.h
//  网络请求
//
//  Created by caolipeng on 15/12/10.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNManagerDelegate.h"


#import "UploadParam.h"


@interface AFNManager : NSObject


@property (nonatomic, weak) id<AFNManagerDelegate> delegate;

/**
 *  AFNManager单利
 */
+(AFNManager *)sharedManager;
#pragma mark --代理的方式传值
/**
 *  get
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters;

/**
 *  post
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters;

/**
 *  upload
 */
- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam;

#pragma mark --block的形式传值
/**
 *  get请求
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/**
 *  post请求
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/**
 *  upload
 */
- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;


#pragma mark --断点续传
/**
 *  开始下载  断点续传
 *
 *  @param URLString 请求接口
 */
- (void)downloadStartWithUrl:(NSString *)URLString fileName:(NSString *)fileName;
/**
 *  开始上传  断点续传
 *
 *  @param URLString 请求接口
 */
- (void)uploadStartWithUrl:(NSString *)URLString fileData:(NSData *)fileData;
/**
 *  暂停操作  断点续传
 */
- (void)operationPause;
/**
 *  继续操作  断点续传
 */
- (void)operationResume;
/**
 *  取消操作
 */
- (void)operationCancel;

@end
