//  day23_1_达内微博_weibo开放平台

//登陆页面 步骤
//1.创建webview，显示登陆页面
//2.创建webutils,宏属性+工厂方法
//3.。m 创建神对象
//4.。m 创建上传任务：上传路径，参数
//5..m 返回宏属性

//保存用户 步骤
//创建Account object
//声明属性
//创建单例方法
//创建注销方法
//实现单例方法：路径获取字典，字典分配account属性
//实现注销方法：删除路径的文件，删除account对象
//callback的object保存到本地，plist里
//声明宏路径



/****************保存用户*******************/
#define AccountPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Account.plist"]

#import "LoginViewController.h"
#import "WeiboUtils.h"
@interface LoginViewController ()<UIWebViewDelegate>
@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //页面标题
    self.title = @"登录页面";
    
    //右上角按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
    
    //创建webview
    UIWebView *wv = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    //添加协议
    wv.delegate = self;
    
    //添加到页面
    [self.view addSubview:wv];
    
    //URL *****记得改client_id, （client_id = App Key）******
    //    *****记得去/微博开放平台/应用信息/高级信息/ 设置：授权回调页
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=22467944&redirect_uri=http://www.baidu.com"];
    
    //封装请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //**1.webview发送请求：展示登陆页面
    [wv loadRequest:request];
}

//**2.协议方法：shouldStartLoadWithRequest:用户输入了账号，点击登陆按钮后，webview准备转跳和加载数据的时候跑此方法 （返回的code是重要数据，传给webutils）
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //得到path
    NSString *path = [request.URL description];
    
    NSLog(@"%@",path);
    
    //得到登陆数据：
    //**3.判断path返回值里面是否有code,这个code是用户登陆数据code
    if ([path containsString:@"code"]) {
        
        //1得到=后面的数据
        NSString *code = [[path componentsSeparatedByString:@"="]lastObject];
        
        //2让用户登陆(把这个code发送给utils,进行xxx上传任务xxx)(然后返回值)
        [WeiboUtils requestTokenWithCode:code andCallback:^(id obj) {
            
            /****************保存用户*******************/
            
            //反向调用，uitils的返回值obj,赋值给dic
            NSDictionary *dic = obj;
            //写入plist路径
            [dic writeToFile:AccountPath atomically:YES];
        
            
            NSLog(@"登录成功！");
            
            //3退出登陆页面
            [self dismissViewControllerAnimated:YES completion:nil];
        
        }];
        
        //包含"code"返回no,不需要显示baidu
        return NO;
    }
    
    //不包含"code"就返回yes
    return YES;
    
}

//左上角按钮：返回
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
