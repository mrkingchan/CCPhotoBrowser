//
//  ViewController.m
//  CCPhotoBrowser
//
//  Created by 陈雄 on 2019/6/29.
//  Copyright © 2019 Chan. All rights reserved.
//

#import "ViewController.h"
#import "UIView+CCFrame.h"
#import "CCPhotoBrowser.h"
@interface ViewController () < UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *_collectionView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"景区图集";
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20 - 11)/2.0, 172);
    layout.minimumLineSpacing = 11;
    layout.minimumInteritemSpacing = 11;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.view.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.view addSubview:_collectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"99张" style:0 target:self action:nil];
}

#pragma mark  -- UIColletioncViewDataSource&Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

+ (UIColor *)RandomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor  =[[self class] RandomColor];
    kCornerRadius(cell, 5.0);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //top_banner_placeholder
    CCPhotoBrowser *VC = [CCPhotoBrowser new];
    NSMutableArray *items = [NSMutableArray new];
    for (int i = 0 ; i < 5; i ++) {
        //        [items addObject:kImage(kIntToStr(i+1))];
        [items addObject:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }
    VC.dataSource = items;
    VC.currentPhotoIndex = 1;
    [self.navigationController pushViewController:VC animated:YES];
}

@end


