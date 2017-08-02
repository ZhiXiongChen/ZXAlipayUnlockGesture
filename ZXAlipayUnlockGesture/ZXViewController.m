//
//  ZXViewController.m
//  ZXAlipayUnlockGesture
//
//  Created by zhixiongchen on 2017/8/1.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "ZXViewController.h"

@interface ZXViewController ()

@end

@implementation ZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home"]];
    imageView.frame=self.view.bounds;
    [self.view addSubview:imageView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
