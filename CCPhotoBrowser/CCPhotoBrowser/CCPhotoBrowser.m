//
//  CCPhotoBrowser.m
//  CCPhotoBrowser
//
//  Created by Chan on 2017/12/25.
//  Copyright © 2017年 Chan. All rights reserved.
//

#import "CCPhotoBrowser.h"
#import "CCPhotoBrowserCell.h"
#import "CCCollectionViewFlowLayout.h"
#import "UIViewController+CCExtension.h"

#import <MediaPlayer/MediaPlayer.h>

#import "UIColor+HexColor.h"
#import "UIButton+Block.h"
#import "UIButton+TouchAreaInsets.h"
#define  kScreenSize  [UIScreen mainScreen].bounds.size

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kIntToStr(intValue) ([NSString stringWithFormat:@"%@", @(intValue)])
#define kURLWithString(str)  [NSURL URLWithString:str]
#define kFontSize(size) [UIFont systemFontOfSize:size]


/// block self
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif

#define kImage(xxx) [UIImage imageNamed:xxx]
@interface CCPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UILabel *_current;
    UILabel *_total;
}
@property(nonatomic,assign)BOOL hideTopNaviBar;
@property(nonatomic,strong) UICollectionView *collectionView;
//@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)MPMoviePlayerViewController *playerVC;

@end

@implementation CCPhotoBrowser
- (BOOL)fullScreenGestureShouldBegin{
    return NO;
}
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(ios 11.0,*)) {
            /*UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
             */
            
        }else{
            if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
                self.automaticallyAdjustsScrollViewInsets=NO;
            }
        }
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_topView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CCCollectionViewFlowLayout *layout = [[CCCollectionViewFlowLayout alloc] init];
        layout.imgaeGap = 20;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[CCPhotoBrowserCell class] forCellWithReuseIdentifier:@"CCPhotoBrowserCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.dataSource.count, self.view.frame.size.height);
    }
    return _collectionView;
}

// 如果实现了iOS8以后的方法, 则旧版方法会覆盖
//视图发生了大小改变的时候会调用此方法   大小改变 == 横竖切换
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    NSLog(@"size; %@", NSStringFromCGSize(size));
//    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"横屏");
//        self.collectionView.frame = CGRectMake(0, self.topView.bottom,size.width,size.height - 44);
//        /*
//        self.pageControl.frame = CGRectMake(0, size.height-30,size.width,30);
//        self.pageControl.centerX = self.view.centerX;
//         */
//    }else{
//        self.collectionView.frame = CGRectMake(0, self.topView.bottom,size.width,size.height - 44);
//        /*
//        self.pageControl.frame = CGRectMake(0, size.height-30,size.width,30);
//        self.pageControl.centerX = self.view.centerX;
//         */
//    }
//}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.downLoadNeeded) {
       
    }else if(self.deleteNeeded){
    }
//    self.title = self.title?self.title:[NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    self.view.backgroundColor = [UIColor blackColor];
    self.hideTopNaviBar = NO;
    [self.view addSubview:self.collectionView];
#define kAppWindow [UIApplication sharedApplication].keyWindow
    [kAppWindow addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kAppWindow);
        make.top.equalTo(@(kStatusBarHeight));
        make.height.equalTo(@(44));
    }];
    
    if (self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    /*
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.currentPage = self.currentPhotoIndex;
     */
    UIView *indexView = [UIView new];
    indexView.backgroundColor = kColorHex(@"#20232B");
    [self.view addSubview:indexView];
    [indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.right.equalTo(@(-20));
        make.bottom.equalTo(@(-30));
        make.width.equalTo(@(70));
    }];
    kCornerRadius(indexView, 12.0);
    
    _current = [UILabel new];
    _current.text = [NSString stringWithFormat:@"%zd",_currentPhotoIndex];
    _current.textAlignment = 1;
    _current.textColor = [UIColor whiteColor];
    _current.font = [UIFont boldSystemFontOfSize:21];
    [indexView addSubview:_current];
    [_current mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.bottom.equalTo(indexView);
    }];
    
    _total = [UILabel new];
    _total.text = [NSString stringWithFormat:@"/%d",_dataSource.count];
    _total.textAlignment = 0;
    _total.textColor = [UIColor whiteColor];
    _total.font = kFontSize(13);
    [indexView addSubview:_total];
    [_total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_current.mas_right).offset(3);
        make.top.equalTo(@(11));
    }];
}

// MARK: - Lazy Load
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
        UIButton *back = [UIButton new];
        [back setImage:kImage(@"back_icon") forState:UIControlStateNormal];
        back.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_topView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.height.width.equalTo(@(44));
            make.centerY.equalTo(_topView);
        }];
        [back addActionHandler:^(NSInteger tag) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIButton *download = [UIButton new];
        [download setImage:kImage(@"download_thumb") forState:UIControlStateNormal];
        download.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_topView addSubview:download];
        [download mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-20));
            make.width.height.equalTo(@(25));
            make.centerY.equalTo(back);
        }];
        
        [download addActionHandler:^(NSInteger tag) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CCPhotoBrowserCell *currentCell = (CCPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                    UIImageWriteToSavedPhotosAlbum(currentCell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                });
            });
        }];
        
    }
    return _topView;
}
/*
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30)];
        _pageControl.numberOfPages = 5;
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}*/


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    if (error) {
//        iToastText(@"保存失败");
//    } else {
//        iToastText(@"保存成功");
//    }
    if (self.downLoadBlock) {
        self.downLoadBlock(self.dataSource,image,error);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.currentPhotoIndex==0) {
//        scrollView.bounces = NO;
//    }else{
//        scrollView.bounces = YES;
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.title isEqualToString:@"图片预览"]) {
        
    }else{
        CGPoint offSet = scrollView.contentOffset;
        self.currentPhotoIndex = offSet.x / self.view.width;
//        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
//        self.pageControl.currentPage = self.currentPhotoIndex;
        _current.text = [NSString stringWithFormat:@"%zd",(self.currentPhotoIndex+1)];
    }
}


#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}



//设置数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCPhotoBrowserCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    @weakify(cell);
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            @strongify(cell);
            if (cell.videoIcon.hidden) {
                weakSelf.topView.hidden = !weakSelf.hideTopNaviBar;
                weakSelf.hideTopNaviBar = !weakSelf.hideTopNaviBar;
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                 //播放视频
                weakSelf.topView.hidden = NO;
                MPMoviePlayerViewController *VC = [[MPMoviePlayerViewController alloc] initWithContentURL:kURLWithString(self.dataSource[indexPath.row])];
                VC.view.frame = CGRectMake(0, kStatusBarHeight, kScreenSize.width, kScreenSize.height - kStatusBarHeight);
                [self presentMoviePlayerViewControllerAnimated:VC];
            }
        };
    }
    
    if (!cell.longPressGestureBlock) {
        cell.longPressGestureBlock = ^(CCPhotoBrowserCell *cell) {
            UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertAction addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image, weakSelf,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }]];
            
            [alertAction addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }]];
            [weakSelf presentViewController:alertAction animated:YES completion:^{
                
            }];
        };
    }
    cell.currentIndexPath = indexPath;
//    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    _current.text = kIntToStr(self.currentPhotoIndex + 1);
    return cell;
}
@end

