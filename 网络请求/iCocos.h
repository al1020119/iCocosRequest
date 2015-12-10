一、什么是AFN

        全称是AFNetworking，是对NSURLConnection的一层封装
        虽然运行效率没有ASI高，但是使用比ASI简单

        在iOS开发中，使用比较广泛

        AFN的github地址
        https://github.com/pokeb/AFNetworking/AFNetworking

二、AFN结构

NSURLConnection

    AFURLConnectionOperation
    AFHTTPRequestOperation

    AFHTTPRequestOperationManager(封装了常用的 HTTP 方法)

        属性
                baseURL :AFN建议开发者针对 AFHTTPRequestOperationManager 自定义个一个单例子类，设置 baseURL, 所有的网络访问，都只使用相对路径即可
                requestSerializer :请求数据格式/默认是二进制的 HTTP
                responseSerializer :响应的数据格式/默认是 JSON 格式
                operationQueue
                reachabilityManager :网络连接管理器

        方法
                manager :方便创建管理器的类方法
                HTTPRequestOperationWithRequest :在访问服务器时，如果要告诉服务器一些附加信息，都需要在 Request 中设置
                GET
                POST

NSURLSession

    AFURLSessionManager

    AFHTTPSessionManager(封装了常用的 HTTP 方法)
            GET
            POST
            UIKit + AFNetworking 分类
            NSProgress :利用KVO

半自动的序列化&反序列化的功能
            AFURLRequestSerialization :请求的数据格式/默认是二进制的
            AFURLResponseSerialization :响应的数据格式/默认是JSON格式

附加功能

    安全策略
            HTTPS
            AFSecurityPolicy

    网络检测
        对苹果的网络连接检测做了一个封装
        AFNetworkReachabilityManager

/**
 *
 http://www.cnblogs.com/worldtraveler/p/4736643.html
 *
 */

#ifndef iCocos_h
#define iCoocs_h


#endif /* iCocos_h */

/**********************************Get/Post***********************************/

- (void)get
{
    // 1.创建AFN管理者
    // AFHTTPRequestOperationManager内部包装了NSURLConnection
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    [manager GET:@"http://120.25.226.186:32812/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

- (void)post
{
    // 1.创建AFN管理者
    // AFHTTPRequestOperationManager内部包装了NSURLConnection
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    [manager POST:@"http://120.25.226.186:32812/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}


/**********************************Get/Post***********************************/


// GET
- (void)get2
{
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    
    [manager GET:@"http://120.25.226.186:32812/login" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

// POST
- (void)post2
{
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };
    
    [manager POST:@"http://120.25.226.186:32812/login" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败---%@", error);
    }];
}

/**********************************下载***********************************/

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
        
        self.progress.progress = 1.0 * object.completedUnitCount / object.totalUnitCount;
    });
}



/**********************************上传***********************************/

- (void)upLoadMonitor{
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


/**********************************解析数据补充***********************************/

* 默认是JSON数据，接收类型是JSON
* 如果接收的类型和返回的类型不匹配会报错

// 1.创建AFN管理者
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

// 默认请求二进制
// 默认响应是JSON

// 告诉AFN，支持接受 text/xml 的数据
// [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/xml"];

// 告诉AFN如何解析数据
// 告诉AFN客户端, 将返回的数据当做JSON来处理，默认的是以JSON处理
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
// 告诉AFN客户端, 将返回的数据当做XML来处理
//    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
// 告诉AFN客户端, 将返回的数据当做而进行来数据 (服务器返回什么就是什么)
manager.responseSerializer = [AFHTTPResponseSerializer serializer];




/**********************************网络监听***********************************/


------------------AFN监控联网状态
联网状态status

// 2.设置监听
/*
 AFNetworkReachabilityStatusUnknown          = -1,  未识别
 AFNetworkReachabilityStatusNotReachable     = 0,   未连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
 AFNetworkReachabilityStatusReachableViaWiFi = 2,  wifi
 */

示例代码

AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

// 提示：要监控网络连接状态，必须要先调用单例的startMonitoring方法
[manager startMonitoring];

[manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    NSLog(@"%d", status);
}];





------------------Reachability监控联网状态苹果提供,导入这两个类使用

// 1.检测wifi状态
Reachability *wifi = [Reachability reachabilityForLocalWiFi];

// 2.检测手机是否能上网络(WIFI\3G\2.5G)
Reachability *conn = [Reachability reachabilityForInternetConnection];

// 3.判断网络状态
if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
    NSLog(@"有wifi");
    
} else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
    NSLog(@"使用手机自带网络进行上网");
    
} else { // 没有网络
    
    NSLog(@"没有网络");
}

①判断联网状态

// 用WIFI
// [wifi currentReachabilityStatus] != NotReachable
// [conn currentReachabilityStatus] != NotReachable

// 没有用WIFI, 只用了手机网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] != NotReachable

// 没有网络
// [wifi currentReachabilityStatus] == NotReachable
// [conn currentReachabilityStatus] == NotReachable

②实时监听网络状态

#import "ViewController.h"
#import "Reachability.h"

@interface HMViewController ()
@property (nonatomic, strong) Reachability *conn;
@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}

- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        
    } else { // 没有网络
        
        NSLog(@"没有网络");
    }
}
@end



