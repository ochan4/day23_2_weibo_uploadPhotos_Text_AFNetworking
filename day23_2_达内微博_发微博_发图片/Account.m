
//保存到plist：因为account的属性都是string，所以可以直接保存到plist里面，沙箱
#define AccountPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Account.plist"]

#import "Account.h"

//单例
static Account *_account;

@implementation Account

//单例方法
+(Account *)shareAccount{
    
    //完整单例方法：不让同时被访问，每次只能让一个进入，其他人等在外面
    @synchronized(self) {
    
        //判断用户是否已创建
        if (!_account) {
            
            //取得保存在plist里面的dictionary
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:AccountPath];
            
            //分配给属性：在dic里获取数据
            if (dic) {
                _account = [[Account alloc]init];
                _account.token = dic[@"access_token"];
                _account.uid = dic[@"uid"];
            }
        }
    }
    
    return _account;
}

-(void)logout{
    
    //删除路径里的用户文件
    [[NSFileManager defaultManager]removeItemAtPath:AccountPath error:nil];
    
    //删除用户对象
    _account = nil;
    
    
}
@end
