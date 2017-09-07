//
//  MPhotoAlbumController.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoAlbumController.h"
#import "MPhotoCollectionViewCell.h"
#import "MPhotoModel.h"
#import "MPhotoAlbumModel.h"
#import <Photos/Photos.h>

static CGFloat kCollectionEdgeWidth = 5.0;
static NSInteger kCollectionNumberRow = 3;

@interface MPhotoAlbumController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MPhotoAlbumModel *albumModel;

@property (nonatomic, assign) BOOL isShowCamera;

@end

@implementation MPhotoAlbumController

- (instancetype)initWithIsShowCamera:(BOOL)isShowCamera {
    if (self = [super init]) {
        self.isShowCamera = isShowCamera;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfCollectionView];
    [self layoutUIOfNavigation];
    [self conformAuthorization];
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfCollectionView {

    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kCollectionEdgeWidth;
    layout.minimumLineSpacing = kCollectionEdgeWidth;
    layout.sectionInset = UIEdgeInsetsMake(kCollectionEdgeWidth, kCollectionEdgeWidth, kCollectionEdgeWidth, kCollectionEdgeWidth);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake([self getItemHeight], [self getItemHeight]);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.sm_width, self.view.sm_height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MPhotoCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
}

- (void)layoutUIOfNavigation {
    
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"camera_nav"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    button.sm_size = CGSizeMake(35, 35);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.albumModel) {
        return [self.albumModel getPictureNumber];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MPhotoCollectionViewCell" forIndexPath:indexPath];
    [self.albumModel getAlbumPhotoIndex:indexPath.row width:[self getItemHeight] flag:NO callBlock:^(MPhotoModel *model) {
        if (!self.isShowCamera) {
            model.type = MPhotoTypeDefault;
        }
        [cell updateWithPhotoModel:model];
    }];
    return cell;
}

#pragma mark - deleagte
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MemoryWeakSelf
    [self.albumModel getOriginPhoto:indexPath.item handle:^(UIImage *image) {
        [weakSelf capturePictureComplete:image];
    }];
}

- (void)capturePictureComplete:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishImagePickerController:image:)]) {
        [self.delegate finishImagePickerController:self image:image];
    }
}

#pragma mark - help item width
- (CGFloat)getItemHeight {
    static CGFloat itemW = 0.0;
    if (itemW == 0) {
        itemW = (WIDTH - kCollectionEdgeWidth * (kCollectionNumberRow + 1)) / kCollectionNumberRow * 1.0;
    }
    return itemW;
}

#pragma mark - private
- (void)conformAuthorization {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized: {
            [self startShowPhotos];
            break;
        }
            
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: {
            
            break;
        }
            
        case PHAuthorizationStatusNotDetermined: {
            MemoryWeakSelf
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [weakSelf startShowPhotos];
                } else {
                    [weakSelf photoAblumDenied];
                }
            }];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)photoAblumDenied {
    //相册不被允许
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)startShowPhotos {
    
    self.albumModel = [MPhotoAlbumModel getPhotoAlbumModel];
    
    if (!self.albumModel) {
        return;
    }
    
    self.navigationItem.title = self.albumModel.albumName;
    [self.collectionView reloadData];
}

- (void)showCamera {
    
}

@end
