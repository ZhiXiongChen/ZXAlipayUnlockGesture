//
//  ZXView.m
//  ZXAlipayUnlockGesture
//
//  Created by zhixiongchen on 2017/8/1.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import "ZXView.h"
#define kButtonCount 9
#import "SVProgressHUD.h"
@interface ZXView()
@property(nonatomic,strong)NSMutableArray * buttons;
@property(nonatomic,strong)NSMutableArray * lineButtons;
@property (nonatomic,assign) CGPoint currentPoint;
@end
@implementation ZXView
-(NSMutableArray *)lineButtons
{
    if(!_lineButtons)
    {
        _lineButtons=[NSMutableArray array];
    }
    return _lineButtons;
}
-(NSMutableArray *)buttons
{
    if(!_buttons)
    {
        _buttons=[NSMutableArray array];
        //创建九个按钮
        for(int i=0;i<kButtonCount;i++)
        {
            UIButton * button=[[UIButton alloc]init];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            //设置被选择的情况下的图片
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            //禁止用户交互
            button.userInteractionEnabled=NO;
            //设置按钮的tag生成密码
            button.tag=i;
            [self addSubview:button];
            //把创建的按钮添加到数组中，方便设置
            [self.buttons addObject:button];
        }

    }
    return _buttons;
}
//无论是从storyboard中加载还是xib加载都会调用
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    //创建九个按钮
//    for(int i=0;i<kButtonCount;i++)
//    {
//        UIButton * button=[[UIButton alloc]init];
//        [self addSubview:button];
//        //把创建的按钮添加到数组中，方便设置
//        [self.arrayM addObject:button];
//    }
//}
//在这里计算九宫格的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width=74;
    CGFloat height=width;
    int rowCount=3;
    CGFloat margin=(self.frame.size.width-3*width)/4;
    for(int i=0;i<self.buttons.count;i++)
    {
        CGFloat buttonx=(i%rowCount)*(width+margin)+margin;
        CGFloat buttony=(i/rowCount)*(height+margin)+margin;
        [self.buttons[i] setFrame:CGRectMake(buttonx, buttony, width, height)];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch * t=touches.anyObject;
    //获取手指所在的位置
    CGPoint p=[t locationInView:t.view];
    
    for(int i=0;i<self.buttons.count;i++)
    {
        UIButton * button=self.buttons[i];
        //看看按钮中包不包含这个我们手指点的那个点
        if(CGRectContainsPoint(button.frame,p))
           {
               button.selected=YES;
               //添加到画线的数组中
               [self.lineButtons addObject:button];
           }
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //修改最好手指的位置为需要连线的按钮的最后一个，这样画出去的那条线就可以移动回来了
    self.currentPoint=[[self.lineButtons lastObject] center];
    //重绘一下
    [self setNeedsDisplay];
    //拼接个密码
    NSString *password=@"";
    for(int i=0;i<self.lineButtons.count;i++)
    {
        //获取button
        UIButton * button=self.lineButtons[i];
       password= [password stringByAppendingString:[NSString stringWithFormat:@"%ld",button.tag]];
    }
    if(self.passWordBlock)
    {
        if(self.passWordBlock(password))
        {
            [SVProgressHUD showSuccessWithStatus:@"成功登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              
                [SVProgressHUD dismiss];
            });

        }
        else
        {
            for(int i=0;i<self.lineButtons.count;i++)
            {
                UIButton * button=self.lineButtons[i];
                button.selected=NO;
                //设置按钮取消不可用的状态
                button.enabled=NO;
            }
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }
    //关闭与用户的交互
    [self setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clear];
        [self setUserInteractionEnabled:YES];
    });
    
}
-(void)clear
{
    //这里就是如果松手的时候就取消选中状态又变回正常的图片
    for(int i=0;i<self.buttons.count;i++)
    {
        UIButton * button=self.buttons[i];
        //取消按钮的选择状态
        button.selected=NO;
        //设置按钮取消不可用的状态
        button.enabled=YES;
    }
    //清空数组也就是说数组没有了线就会没有了
    [self.lineButtons removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch * t=touches.anyObject;
    //获取最新的手指的位置
    CGPoint p=[t locationInView:t.view];
    //最新手指的位置给currentPoint来绘制鼠标移动的时候有一条线跟着
    self.currentPoint=p;
    //遍历所有的button
    for(int i=0;i<self.buttons.count;i++)
    {
        //获取按钮
        UIButton * button =self.buttons[i];
        //判断手指的位置是不是在某个按钮的范围之内
        if(CGRectContainsPoint(button.frame, p))
        {
            button.selected=YES;
            //先判断有没有添加过这个按钮了，添加过了就不用添加了
            if(![self.lineButtons containsObject:button])
            {
            //添加到画线的数组中
            [self.lineButtons addObject:button];
            }
            
        }
    }
    //每次移动的时候重绘下
    [self setNeedsDisplay];
}


//在这里画线
- (void)drawRect:(CGRect)rect {
    //最开始的时候数组没有元素，所以直接返回
    if(!self.lineButtons.count)
    {
        return;
    }
    UIBezierPath * path=[[UIBezierPath alloc]init];
    for(int i=0;i<self.lineButtons.count;i++)
    {
        UIButton * button=self.lineButtons[i];
        if(i==0)
        {
            [path moveToPoint:button.center];
        }
        else
        {
            [path addLineToPoint:button.center];
        }
    }
    //画那条跟着手指的线
    [path addLineToPoint:self.currentPoint];
    //设置要头尾的样式，如果不设置则连接处可能会出问题的
    [path setLineJoinStyle:kCGLineJoinRound];
    //设置下头尾的样式
    [path setLineCapStyle:kCGLineCapRound];
    //设置下颜色
    [[UIColor whiteColor]set];
    //设置线宽
    [path setLineWidth:10];
    //渲染
    [path stroke];
}


@end
