//
//  ViewController.m
//  登录案例
//
//  Created by 古伟东 on 2017/3/6.
//  Copyright © 2017年 victorgu. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"
@interface ViewController ()
/** 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *PwdTf;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)login:(id)sender {
    
    //添加灰色的背景
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //0.拿到用户的输入
    NSString *userNameStr = self.userNameTF.text;
    NSString *pwdStr = self.PwdTf.text;
    
    //输入校验
    if (userNameStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.userNameTF.placeholder];
        return;
    }
    
    if (pwdStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.PwdTf.placeholder];
        return;
    }
    
    //1.确定URL
    NSURL *url = [ NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.226.186:32812/login?username=%@&pwd=%@&type=JSON", userNameStr, pwdStr] ];
    
    //创建请求对象（get）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [SVProgressHUD showErrorWithStatus:@"小哥哥别急，下一个轮到你"];
    
    //3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //容错处理
        if (connectionError) {
            NSLog(@"%@", connectionError);
            return ;
        }
        
        //4.解析数据
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
        
        //5.截取字符串({"error":"用户名不存在"}|{"success":"登录成功"})
        NSUInteger loc = [result rangeOfString:@":\""].location +2;
        NSUInteger len = [result rangeOfString:@"\"}"].location - loc;
        
        NSString *msg = [result substringWithRange:NSMakeRange(loc, len)];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            if ([result containsString:@"error"]) {
                [SVProgressHUD showErrorWithStatus:msg];
            }else {
                [SVProgressHUD showSuccessWithStatus:msg];
            }
        });
        
        
    }];
}








@end
