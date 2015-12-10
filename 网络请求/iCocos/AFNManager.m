//
//  AFNManager.m
//  网络请求
//
//  Created by caolipeng on 15/12/10.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import "AFNManager.h"

#import "AFNetworking.h"


@interface AFNManager()
{
    AFHTTPRequestOperation *operation; //创建请求管理（用于上传和下载）
}
@end
static AFNManager *manager = nil;
@implementation AFNManager


/**
 *  创建请求管理者
 *
 *  @return 对应的对象：AFNManager单利
 */
+(AFNManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}


/**
 *  初始化内存
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}


/**
 *  Get请求:代理
 *
 *  @param URLString  url
 *  @param parameters 参数
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            [self.delegate AFNManagerDidSuccess:responseObject];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            [self.delegate AFNManagerDidFaild:error];
        }
    }];
}


/**
 *  Post请求:代理
 *
 *  @param URLString  url
 *  @param parameters 参数
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            [self.delegate AFNManagerDidSuccess:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            [self.delegate AFNManagerDidFaild:error];
        }
    }];
}



/**
 *  上传数据
 *
 *  @param URLString   url
 *  @param parameters  参数
 *  @param uploadParam 上传参数
 */
- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 上传的文件全部拼接到formData
        
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            [self.delegate AFNManagerDidSuccess:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            [self.delegate AFNManagerDidFaild:error];
        }
    }];
    
}



/**
 *  Get请求:Block
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param succeed    成功
 *  @param failure    失败
 */
-(void)GET:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return ;
        }
        succeed(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
}

/**
 *  Post请求:Block
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param succeed    成功
 *  @param failure    失败
 */
-(void)Post:(NSString *)URLString parameters:(id)parameters succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            return ;
        }
        succeed(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
}

/**
 *  上传
 *
 *  @param URLString   url
 *  @param parameters  参数
 *  @param uploadParam 上传参数
 *  @param succeed     成功
 *  @param failure     失败
 */
-(void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(UploadParam *)uploadParam succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    [mgr POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 上传的文件全部拼接到formData
        
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            succeed(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            failure(error);
        }
    }];
    
}

/***********************************断点续传************************************/


/**
 *  开始下载  断点续传
 *
 *  @param URLString 请求接口
 */
-(void)downloadStartWithUrl:(NSString *)URLString fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(), fileName];
    
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    //    可以在此设置进度条
    
    //    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    //
    //    }];
    __weak typeof(self) weakself = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        请求成功做出提示
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            [weakself.delegate AFNManagerDidSuccess:responseObject];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        请求失败做出提示
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            [weakself.delegate AFNManagerDidFaild:error];
        }
    }];
    
    [operation start];
}



/**
 *  开始上传  断点续传
 *
 *  @param URLString 请求接口
 */
- (void)uploadStartWithUrl:(NSString *)URLString fileData:(NSData *)fileData
{
    operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    
    operation.inputStream = [[NSInputStream alloc] initWithData:fileData];
    
    //    设置进度条
    //    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    //
    //    }];
    __weak typeof(self) weakself = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        请求成功做出提示
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(AFNManagerDidSuccess:)]) {
            
            [weakself.delegate AFNManagerDidSuccess:responseObject];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        请求失败做出提示
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(AFNManagerDidFaild:)]) {
            
            [weakself.delegate AFNManagerDidFaild:error];
        }
    }];
    
    [operation start];
}

/**
 *  暂停操作  断点续传
 */
- (void)operationPause
{
    [operation pause];
}

/**
 *  继续操作  断点续传
 */
- (void)operationResume
{
    [operation resume];
}

/**
 *  取消操作
 */
- (void)operationCancel
{
    [operation cancel];
}

//网络监听（用于检测网络是否可以链接。此方法最好放于AppDelegate中，可以使程序打开便开始检测网络）
- (void)reachabilityManager
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //打开网络监听
    [mgr.reachabilityManager startMonitoring];
    
    //监听网络变化
    [mgr.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                
                //当网络不可用（无网络或请求延时）
            case AFNetworkReachabilityStatusNotReachable:
                break;
                
                //当为手机WiFi时
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                
                //当为手机蜂窝数据网
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
                
                //其它情况
            default:
                break;
        }
    }];
    
    //    //停止网络监听（若需要一直检测网络状态，可以不停止，使其一直运行）
    //    [mgr.reachabilityManager stopMonitoring];
}


@end