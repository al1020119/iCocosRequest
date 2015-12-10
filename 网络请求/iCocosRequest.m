//
//  iCocosRequest.m
//  网络请求
//
//  Created by caolipeng on 15/12/10.
//  Copyright © 2015年 caolipeng. All rights reserved.
//

#import "iCocosRequest.h"

#import <AFNetworking.h>


@interface iCocosRequest ()

@end


@implementation iCocosRequest
#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    AFHTTPRequestOperation *op = [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}

#pragma --mark POST请求方式

+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    AFHTTPRequestOperation *op = [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        block(dic);
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}



/******************************************/
// formData: 专门用于拼接需要上传的数据
- (void)upLoadMonitor
{
    // 1.创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.利用网络管理者上传数据
    NSDictionary *dict = @{@"username":@"Syl"};
    // formData: 专门用于拼接需要上传的数据
    [manager POST:@"http://120.25.226.186:32812/upload" parameters:dict constructingBodyWithBlock:
     ^void(id<AFMultipartFormData> formData) {
         
         /*
          Data: 需要上传的数据
          name: 服务器参数的名称
          fileName: 文件名称
          mimeType: 文件的类型
          */
         UIImage *image =[UIImage imageNamed:@"minion_02"];
         NSData *data = UIImagePNGRepresentation(image);
         [formData appendPartWithFileData:data name:@"file" fileName:@"abc.png" mimeType:@"image/png"];
         
         /*
          NSURL *url = [NSURL fileURLWithPath:@"/Users/apple/Desktop/CertificateSigningRequest.certSigningRequest"];
          // 任意的二进制数据MIMEType application/octet-stream
          // [formData appendPartWithFileURL:url name:@"file" fileName:@"abc.cer" mimeType:@"application/octet-stream" error:nil];
          [formData appendPartWithFileURL:url name:@"file" error:nil];
          */
     } success:^void(NSURLSessionDataTask * task, id responseObject) {
         // 请求成功
         NSLog(@"请求成功 %@", responseObject);
     } failure:^void(NSURLSessionDataTask * task, NSError * error) {
         // 请求失败
         NSLog(@"请求失败 %@", error);
     }];
}

/**************************************/
// 执行下载文件的方法,可以监控下载进度
- (void)downLoadMonitor
{
    // 1.创建网络管理者
    // AFHTTPSessionManager 基于NSURLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用网络管理者下载数据
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"]];
    /*
     destination
     - targetPath: 系统给我们自动写入的文件路径
     - block的返回值, 要求返回一个URL, 返回的这个URL就是剪切的位置的路径
     completionHandler
     - url :destination返回的URL == block的返回的路径
     */
    /*
     @property int64_t totalUnitCount;  需要下载文件的总大小
     @property int64_t completedUnitCount; 当前已经下载的大小
     */
    NSProgress *progress = nil;
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",filePath.absoluteString);
        
    }];
    
    /*
     要跟踪进度，需要使用 NSProgress，是在 iOS 7.0 推出的，专门用来跟踪进度的类！
     NSProgress只是一个对象！如何跟踪进度！-> KVO 对属性变化的监听！
     @property int64_t totalUnitCount;        总单位数
     @property int64_t completedUnitCount;    完成单位数
     */
    // 给Progress添加监听 KVO
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:nil];
    
    // 3.启动任务
    [downTask resume];
    
}

// 收到通知调用的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSProgress *)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%f",1.0 * object.completedUnitCount / object.totalUnitCount);
    // 回到主队列刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.progress.progress = 1.0 * object.completedUnitCount / object.totalUnitCount;
    });
}


@end
