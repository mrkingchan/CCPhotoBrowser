//
//  CCPhotoBrowserCell.h
//  CCPhotoBrowser
//
//  Created by Chan on 2017/12/25.
//  Copyright © 2017年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CCFrame.h"

@interface CCPhotoBrowserCell : UICollectionViewCell
@property (nonatomic, copy)NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImageView *imageView;

@property(nonatomic,strong)UIImageView *videoIcon;

@property (nonatomic, retain)id model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^longPressGestureBlock)(CCPhotoBrowserCell *cell);

@end
