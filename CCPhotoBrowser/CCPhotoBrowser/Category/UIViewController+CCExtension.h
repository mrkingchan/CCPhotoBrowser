//
//  UIViewController+CCExtension.h
//  CCPhotoBrowser
//
//  Created by Chan on 2018/6/14.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PopBlock)(UIBarButtonItem *backItem);

@interface UIViewController (CCExtension)
@property(nonatomic,copy)PopBlock popBlock;
@property (nonatomic, assign) BOOL isHideBackItem;
//右滑返回功能，默认开启（YES）
- (BOOL)fullScreenGestureShouldBegin;
/**
 返回按钮的图片名字，不重写此方法的时候默认为绿色图片名字
 
 @return 图片名字
 */
-(NSString *)backIconName;
@end

@interface UITabBarController (CCExtension)

@end

@interface UINavigationController (CCExtension)<UIGestureRecognizerDelegate>

@end

@interface UIAlertController (CCExtension)

@end
