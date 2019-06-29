//
//  CCPhotoBrowser.h
//  CCPhotoBrowser
//
//  Created by Chan on 2017/12/25.
//  Copyright © 2017年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>


//一款简单的图片浏览器（带视频播放和网络图片预览）

typedef void(^DeleteBlock)(NSMutableArray *dataSource,NSUInteger currentIndex,UICollectionView *collectionView);

typedef void(^DownLoadBlock)(NSMutableArray *dataSource,UIImage *image,NSError *error);

@interface CCPhotoBrowser : UIViewController

/**
 *  需要预览的照片数组
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  需要展示的当前的图片index
 */
@property (nonatomic, assign) NSInteger   currentPhotoIndex;

/**
 *  是否需要下载
 */
@property (assign, nonatomic)   BOOL downLoadNeeded;

/**
 *  是否需要删除
 */
@property (assign, nonatomic)   BOOL deleteNeeded;

/**
 *  下载回调
 */
@property (nonatomic, copy) DownLoadBlock    downLoadBlock;

/**
 *  删除回调
 */
@property (nonatomic, copy) DeleteBlock   deleteBlock;

@end


