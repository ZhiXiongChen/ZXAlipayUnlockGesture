//
//  ViewController.m
//  ZXAlipayUnlockGesture
//
//  Created by zhixiongchen on 2017/8/1.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "ViewController.h"
#import "ZXView.h"
#import "ZXViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZXView *passWordView;
@property (weak, nonatomic) IBOutlet UIImageView *TopImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置控制器的背景为一张图片，用的是平铺的方法
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    //NSLog(@"-----");
    //第一次加载的时候是不会执行这个方法的，在ZXView中调用了该方法才会去执行这下面的代码
    _passWordView.passWordBlock=^(NSString * str)
    {
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
        //获取当前的上下文
        CGContextRef ctx=UIGraphicsGetCurrentContext();
        //截图得到当前view的图片
        [self.passWordView.layer renderInContext:ctx];
        //得到获取到的图片
        UIImage * image=UIGraphicsGetImageFromCurrentImageContext();
        //关闭图形上下文
        UIGraphicsEndImageContext();
        self.TopImageView.image=image;
        self.TopImageView.contentMode=UIViewContentModeScaleToFill;
         UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
      if([str isEqualToString:@"013"])
      {
          NSLog(@"正确");
          ZXViewController * vc=[[ZXViewController alloc]init];
          [self presentViewController:vc animated:YES completion:nil];
          return YES;
      }
      else
      {
          NSLog(@"错误");
          return NO;
      }
       
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
