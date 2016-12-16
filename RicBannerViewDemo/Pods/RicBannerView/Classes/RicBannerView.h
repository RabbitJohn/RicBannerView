//
//  RicBannerView.h
//  RicBannerView
//
//  Created by 张礼焕 on 2016/12/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RicBannerItem;
@class RicBannerView;

@protocol RicBannerViewDelegate <NSObject>

@optional

- (void)didClickBanner:(id<RicBannerItem>)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView;

@end

/**
  the banner view that will dispaly
 */
@interface RicBannerView : UIView
/**
  the banner infos will show in the banner view.
 */
@property (nonatomic, strong) NSArray <id<RicBannerItem>> *bannerItems;
/**
 the banner dispaly interval default is 3
 */
@property (nonatomic, assign) NSTimeInterval bannerDisplayDuration;
/**
  delegate
 */
@property (nonatomic, weak) id<RicBannerViewDelegate>delegate;
/**
   the page control for indicate the page of the banners showing currently.
 */
@property (nonatomic, readonly) UIPageControl *pageIndicator;
/**
 whether the page indicator should show on the banner view.
 */
@property (nonatomic, assign) BOOL shouldIndicator;
/**
 the tint color of the page indicator
 */
@property (nonatomic, strong) UIColor *tintIndicatorColor;
/**
 the normal color of the page indicator
 */
@property (nonatomic, strong) UIColor *normalIndicatorColor;

/**
  begin play play for auto scrolling
 */
- (void)beginPlay;
/**
  top play to stop the timer
 */
- (void)stopPaly;

@end

/**
 the item represent a banner info.
 */
@protocol RicBannerItem <NSObject>
@required
@property (nonatomic, strong) NSString *bannerImageUrl;
@property (nonatomic, strong) UIImage *bannerPlaceholderImage;

@optional
@property (nonatomic, strong) NSString *bannerLinkUrl;
@property (nonatomic, strong) UIImage *bannerImage;

@end
