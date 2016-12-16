//
//  RicBannerView.m
//  RicBannerView
//
//  Created by 张礼焕 on 2016/12/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "RicBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RicPageControl : UIPageControl

@property (nonatomic, strong) UIColor *ricTintColor;
@property (nonatomic, strong) UIColor *ricNormalColor;

@end

@implementation RicPageControl

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updatePageIndicator];
}


- (void)updatePageIndicator
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        dot.layer.cornerRadius = CGRectGetWidth(dot.frame)/2.0f;
        dot.layer.masksToBounds = YES;
        dot.layer.borderWidth = 0.6f;
        dot.layer.borderColor = (self.ricTintColor?:[UIColor lightGrayColor]).CGColor;
        if(i == self.currentPage){
            dot.backgroundColor = self.ricTintColor ?:[UIColor lightGrayColor];
        }else{
            dot.backgroundColor = self.ricNormalColor ?: [UIColor clearColor];
        }
    }
}


@end


@interface RicBannerPlayItemView : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RicBannerPlayItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}


@end



@interface RicBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *bannerPlayView;
@property (nonatomic, strong) NSTimer *timer;
/// record the banner index of the indicator that being show
@property (nonatomic, assign) NSUInteger currentPlayIndex;
@property (nonatomic, strong) RicPageControl *pageControl;
@property (nonatomic, strong) NSArray <id<RicBannerItem>>*originItems;
@end


@implementation RicBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        self.bannerPlayView = [[UICollectionView alloc] initWithFrame:self.bounds  collectionViewLayout:layout];
        self.bannerPlayView.delegate = self;
        self.bannerPlayView.dataSource = self;
        self.bannerPlayView.pagingEnabled = YES;
        self.bannerPlayView.showsVerticalScrollIndicator = false;
        self.bannerPlayView.showsHorizontalScrollIndicator = false;
        [self.bannerPlayView registerClass:[RicBannerPlayItemView class] forCellWithReuseIdentifier:@"RicBannerPlayItemView"];
        [self addSubview:self.bannerPlayView];
        
    }
    
    return self;
}

- (void)setBannerItems:(NSArray<id<RicBannerItem>> *)bannerItems{
    
    self.originItems = bannerItems;
    self.pageControl.numberOfPages = bannerItems.count;
    
    if(bannerItems.count > 1){
        NSMutableArray *fixedBannerItems = [bannerItems mutableCopy];
        
        id<RicBannerItem> firstItem = [fixedBannerItems firstObject];
        id<RicBannerItem> lastItem = [fixedBannerItems lastObject];
        [fixedBannerItems insertObject:lastItem atIndex:0];
        [fixedBannerItems addObject:firstItem];
        _bannerItems = fixedBannerItems;
        self.bannerPlayView.scrollEnabled = YES;
        [self.bannerPlayView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else{
        _bannerItems = bannerItems;
        self.bannerPlayView.scrollEnabled = NO;
    }
}

- (UIPageControl *)pageIndicator{
    return self.pageControl;
}

- (RicPageControl *)pageControl{

    if(!_pageControl){
        _pageControl = [[RicPageControl alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)-25, CGRectGetWidth(self.frame)-20, 15)];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setTintIndicatorColor:(UIColor *)tintIndicatorColor{
    self.pageControl.ricTintColor = tintIndicatorColor;
}

- (void)setNormalIndicatorColor:(UIColor *)normalIndicatorColor{
    self.pageControl.ricNormalColor = normalIndicatorColor;
}

- (void)setShouldIndicator:(BOOL)shouldIndicator{
    self.pageControl.hidden = !shouldIndicator;
}

- (void)beginPlay
{
    NSAssert(_bannerItems.count > 1, @"out of bannerlist range");

        self.bannerDisplayDuration = 3;
        self.currentPlayIndex = 0;
        self.timer = [NSTimer timerWithTimeInterval:self.bannerDisplayDuration target:self selector:@selector(displayNextBanner) userInfo:nil repeats:YES];
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.bannerDisplayDuration];
        //
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopPaly{
    if(self.timer && self.timer.isValid){
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.timer];
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.bannerDisplayDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(((NSInteger)scrollView.contentOffset.x)%((NSInteger)scrollView.frame.size.width) == 0){
        [self figureOutCurrentBanner];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bannerItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RicBannerPlayItemView *bannerPlayItemView = (RicBannerPlayItemView *)[self.bannerPlayView dequeueReusableCellWithReuseIdentifier:@"RicBannerPlayItemView" forIndexPath:indexPath];
    id<RicBannerItem> bannerInfo = self.bannerItems[indexPath.item];
    if(bannerInfo.bannerImageUrl.length > 0){
        [bannerPlayItemView.imageView sd_setImageWithURL:[NSURL URLWithString:bannerInfo.bannerImageUrl]];
    }else if(bannerInfo.bannerImage != nil){
        bannerPlayItemView.imageView.image = bannerInfo.bannerImage;
    }else{
        bannerPlayItemView.imageView.image = bannerInfo.bannerPlaceholderImage;
    }
    
    return bannerPlayItemView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate && [self.delegate conformsToProtocol:@protocol(RicBannerViewDelegate)]&& [self.delegate respondsToSelector:@selector(didClickBanner:atIndex:bannerView:)]){
        id<RicBannerItem>item = self.bannerItems[indexPath.item];
        [self.delegate didClickBanner:item atIndex:[self.originItems indexOfObject:item] bannerView:self];
    }
}

- (void)displayNextBanner
{
    [self showRightBanner];
}

- (void)showRightBanner{
    
    CGFloat bannerViewWidth = CGRectGetWidth(self.bannerPlayView.frame);
    NSInteger page = self.bannerPlayView.contentOffset.x/bannerViewWidth+1;
    
    [self.bannerPlayView setContentOffset:CGPointMake(page*bannerViewWidth, 0) animated:YES];
    
}

/**
     figure the current banner index.
 */
- (void)figureOutCurrentBanner{
    
    CGFloat bannerViewWidth = CGRectGetWidth(self.bannerPlayView.frame);
    NSInteger page = self.bannerPlayView.contentOffset.x/bannerViewWidth;
    
    if(page == self.bannerItems.count-1){
        self.currentPlayIndex = 0;
        [self.bannerPlayView setContentOffset:CGPointMake(bannerViewWidth, 0) animated:NO];
    }else if(page == 0){
        self.currentPlayIndex = self.bannerItems.count - 3;
        [self.bannerPlayView setContentOffset:CGPointMake((self.bannerItems.count - 2)*bannerViewWidth, 0) animated:NO];
    }else{
        self.currentPlayIndex = page-1;
    }
    [self updateIndicator];
}

- (void)updateIndicator{
    self.pageControl.currentPage = self.currentPlayIndex;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.timer];
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.bannerDisplayDuration];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.bannerDisplayDuration];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.bannerDisplayDuration];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
