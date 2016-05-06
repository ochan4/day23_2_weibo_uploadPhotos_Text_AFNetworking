//  ViewController.m
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

//发送微博文字，发送微博图片 步骤
//创建imagepickerview选择图片
//添加协议方法
//utils添加工厂方法：参数为string
//utils添加工厂方法：参数为string+data
//vc创建发送图片方法
//通过utils，发送图片+文字数据
//用alertcontroller确定发送完毕
//vc创建发送文字方法
//通过utils,发送文字数据
//用alertcontroller确定发送完毕


#import "Account.h"
#import "WeiboUtils.h"
#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//数据传送到微博.com
@property(nonatomic,strong)NSData *imageData;
@property (weak, nonatomic) IBOutlet UITextField *myTF;

//本地显示图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)clicked:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0: //登陆
            
            if (![Account shareAccount]) { //account不为空
                
                //页面转跳
                LoginViewController *vc = [LoginViewController new];
                
                [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
            }
            break;
            
        case 1: //注销
            
            //用Account里的logout方法
            [[Account shareAccount] logout];
            
            break;
            
        case 2://获取图片
        {
            //创建图片浏览器
            UIImagePickerController *vc = [[UIImagePickerController alloc]init];
            
            //添加协议
            vc.delegate = self;
            
            //跳转页面：present
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
            
        case 3://发送微博
            
            //判断图片数据为不为空
            if (self.imageData) {
                
                //发送图片微博
                [self sendImageWeibo];
                
            }else{
                
                //仅发送微博文字
                [self sendTextWeibo];
            }
            
            break;
    }

}



//发文字微博
-(void)sendTextWeibo{
    
    //用uitil工厂方法，上传文字: 传递文字+返回obj
    [WeiboUtils sendWeiboWithText:self.myTF.text andCallback:^(id obj) {
        
        //创建alert
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送完成！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        //添加action1到alert
        [ac addAction:action1];
        
        //转跳页面alert
        [self presentViewController:ac animated:YES completion:nil];
        
        NSLog(@"上传成功");
    }];
    
}




//发送图片微博
-(void)sendImageWeibo{
    
    //用uitil工厂方法，上传图片：传递文字+图片+返回obj
    [WeiboUtils sendWeiboWithText:self.myTF.text andImageData:self.imageData andCallback:^(id obj) {
        
        //创建alert
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送完成！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //下次发送图片,self.image为空 =nil
            self.imageData = nil;
            self.imageView.image = nil;
            
        }];
        
        //添加action1到alert
        [ac addAction:action1];
        
        //转跳页面alert
        [self presentViewController:ac animated:YES completion:nil];
        
        NSLog(@"上传成功");
    }];
}



//实现imagePickerController协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //用户选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //设置imageView
    self.imageView.image = image;
    
    //把图片转成data：
    //获取图片路径
    NSString *url = [info[UIImagePickerControllerReferenceURL] description];
    
    //jpg png分开转换
    if ([url hasSuffix:@"PNG"]) {
        self.imageData = UIImagePNGRepresentation(image);
        
    }else{//jpg
        self.imageData = UIImageJPEGRepresentation(image, .5);
    }
    
    //执行完以上就退出pickerview
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
