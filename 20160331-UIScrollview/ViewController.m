//
//  ViewController.m
//  20160331-UIScrollview
//
//  Created by mac on 16/3/31.
//  Copyright © 2016年 com. All rights reserved.
//
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height // 主屏幕的高度
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width  // 主屏幕的宽度
#define SCROLLVIEW_HEIGHT _testScrollview.bounds.size.height //testScrollview高度
#define SHOW_IMAGECOUNT  3

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    int _currentImageIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *testScrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *testPageCon;

@property (nonatomic, strong) NSMutableArray *imageData;
@end

@implementation ViewController


/**
 *
 *  加载数据
 *
 */
-(NSMutableArray *)imageData{
    if (!_imageData) {
        _imageData = [NSMutableArray array];
        for (int i = 1; i < 8; i++) {
            [_imageData addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]];
        }
    }
    return _imageData;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setScrollview];
    
    [self setPageCon];
    
    [self addImageViews];
    
    [self loadDefaultImageView];

}

/**
 *
 *  设置scrollview
 *
 */
-(void)setScrollview{
    _testScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * SHOW_IMAGECOUNT, SCROLLVIEW_HEIGHT);
    
    _testScrollview.delegate = self;
    
    [_testScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    
    _testScrollview.pagingEnabled = YES;
    
    _testScrollview.showsHorizontalScrollIndicator=NO;
}

/**
 *
 *  设置分页控件
 *
 */
-(void)setPageCon{
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_testPageCon sizeForNumberOfPages:self.imageData.count];
    //设置颜色
    _testPageCon.bounds=CGRectMake(0, 0, size.width, size.height);
    _testPageCon.center = CGPointMake(SCREEN_WIDTH / 2, _testScrollview.frame.origin.y + SCROLLVIEW_HEIGHT - size.height);
    _testPageCon.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _testPageCon.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _testPageCon.numberOfPages = self.imageData.count;
}

/**
 *
 *  添加图片
 *
 */
-(void)addImageViews{
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, _testScrollview.frame.origin.x, SCREEN_WIDTH, SCROLLVIEW_HEIGHT)];
    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_testScrollview addSubview:_leftImageView];
    
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, _testScrollview.frame.origin.x, SCREEN_WIDTH, SCROLLVIEW_HEIGHT)];
    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_testScrollview addSubview:_centerImageView];
    
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*SCREEN_WIDTH, _testScrollview.frame.origin.x, SCREEN_WIDTH, SCROLLVIEW_HEIGHT)];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_testScrollview addSubview:_rightImageView];
}

/**
 *
 *  加载默认图片
 *
 */
-(void)loadDefaultImageView{
    _leftImageView.image = self.imageData.lastObject;
    _centerImageView.image = self.imageData.firstObject;
    _rightImageView.image = self.imageData[1];
    _currentImageIndex = 0;
    
    _testPageCon.currentPage = _currentImageIndex;
}

/**
 *
 *  更新图片
 *
 */
-(void)updataImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset = [_testScrollview contentOffset];
    if (offset.x > SCREEN_WIDTH) { //向右滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.imageData.count;
    }else if(offset.x < SCREEN_WIDTH){ //向左滑动
        _currentImageIndex = (_currentImageIndex + self.imageData.count - 1) % self.imageData.count;
    }
    _centerImageView.image = self.imageData[_currentImageIndex];
    
    //重新设置左右图片
    leftImageIndex = (_currentImageIndex + self.imageData.count - 1) % self.imageData.count;
    rightImageIndex = (_currentImageIndex + 1) % self.imageData.count;

    _leftImageView.image = self.imageData[leftImageIndex];
    _rightImageView.image = self.imageData[rightImageIndex];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self updataImage];
    //移动到中间
    [_testScrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    //设置分页
    _testPageCon.currentPage=_currentImageIndex;
}

@end
