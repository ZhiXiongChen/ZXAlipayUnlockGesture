//
//  ZXView.h
//  ZXAlipayUnlockGesture
//
//  Created by zhixiongchen on 2017/8/1.
//  Copyright © 2017年 zhixiongchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXView : UIView
@property (nonatomic,copy)BOOL(^passWordBlock)(NSString *);
@end
