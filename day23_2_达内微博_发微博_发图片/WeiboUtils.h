//
//  WeiboUtils.h
//  day23_1_达内微博_weibo开放平台

#import "AFNetworking.h"
#import <Foundation/Foundation.h>

//创建宏对象：block方法 用作调用
typedef void (^MyCallback)(id obj);

@interface WeiboUtils : NSObject

//创建工厂方法: 登陆请求
+(void)requestTokenWithCode:(NSString *)code andCallback:(MyCallback)callback;

//创建工厂方法: 文字上传
+(void)sendWeiboWithText:(NSString *)text andCallback: (MyCallback)callback;

//创建工厂方法: 文字+图片上传
+(void)sendWeiboWithText:(NSString *)text andImageData: (NSData *) data andCallback:(MyCallback)callback;
@end
