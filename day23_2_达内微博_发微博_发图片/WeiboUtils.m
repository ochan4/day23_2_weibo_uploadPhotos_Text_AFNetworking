//  WeiboUtils.m
//  day23_1_达内微博_weibo开放平台


#import "WeiboUtils.h"
#import "Account.h"

@implementation WeiboUtils

//登陆任务
+(void)requestTokenWithCode:(NSString *)code andCallback:(MyCallback)callback{
    //在开放平台得到地址
    NSString *path = @"https://api.weibo.com/oauth2/access_token";
    
    //字典：保存参数（发送登陆请求的时候，发送参数）************修改成自己申请的开放平台id和其他 #app key #app secret
    NSDictionary *params = @{@"client_id":@"22467944",@"client_secret":@"1845de95ebdb828ea1b1603757826c52",@"grant_type":@"authorization_code",@"redirect_uri":@"http://www.baidu.com",@"code":code};
   
    //AF创建manager: 神对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //用神对象manager的responseSerializer方法：序列化：同意服务器返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //任务三个方法：上传任务
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //json文件 转换为 NSDictionary
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        //callback() 是MyCallBack的一个对象，此方法可以给vc调回一个object,通过反调用
        callback(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //error错误对象
        NSLog(@"请求失败：%@",error);
    }];
    
}

//创建工厂方法: 文字上传
+(void)sendWeiboWithText:(NSString *)text andCallback: (MyCallback)callback{
    
    //在开放平台得到地址
    NSString *path = @"https://api.weibo.com/2/statuses/update.json";
    
    //字典：保存参数（发送登陆请求的时候，发送参数）参数1-账号 参数2-文字
    NSDictionary *params = @{@"access_token":[Account shareAccount].token,@"status":text};
    
    //AF创建manager: 神对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //用神对象manager的responseSerializer方法：序列化：同意服务器返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //任务三个方法：上传任务 文字
    [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //json文件 转换为 NSDictionary
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        //callback() 是MyCallBack的一个对象，此方法可以给vc调回一个object,通过反调用
        callback(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}

//创建工厂方法: 文字+图片上传
+(void)sendWeiboWithText:(NSString *)text andImageData: (NSData *) data andCallback:(MyCallback)callback{
    
    //在开放平台得到地址
    NSString *path = @"https://upload.api.weibo.com/2/statuses/upload.json";
    
    //字典：保存参数（发送登陆请求的时候，发送参数）参数1-账号 参数2-文字
    NSDictionary *params = @{@"access_token":[Account shareAccount].token,@"status":text};
    
    //AF创建manager: 神对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //用神对象manager的responseSerializer方法：序列化：同意服务器返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //任务三个方法：上传任务 文字+图片
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //把图片的数据添加到了请求体里面
        [formData appendPartWithFileData:data name:@"pic" fileName:@"asdf.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //json文件 转换为 NSDictionary
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"%@",dic);
        
        //callback() 是MyCallBack的一个对象，此方法可以给vc调回一个object,通过反调用
        callback(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}
@end
