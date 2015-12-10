//
//  iCocosRequest.h
//  网络请求
//
//  Created by caolipeng on 15/12/10.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();


#import <Foundation/Foundation.h>

@interface iCocosRequest : NSObject

#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma POST请求
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;

#pragma GET请求
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;




/**
 *  Put请求
 */
//+ (void)putWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;



/**
 *  Dele请求
 */
//+ (void)deleteWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;



/**
 *  上传头像 post
 */
//+ (void)upLoadAvatarWithUrl:(NSString *)url avatar:(UIImage *)avatarImg fileName:(NSString *)fileName resultClass:(Class)resultClass responseBlock:(responseHandler)responseDataBlock;

/**
 *  put请求上传图片
 */
//+ (void)upLoadImagesWithUrl:(NSString *)url WithFilename:(NSString *)filename data:(NSData *)data parmas:(NSDictionary *)params withHandler:(imgBlock)imgHandler;



/**
 *  断点上传
 */
// formData: 专门用于拼接需要上传的数据

- (void)upLoadMonitor;

/**
 *  下载数据
 */


- (void)downLoadMonitor;

/**
 *  断点下载
 */


@end
