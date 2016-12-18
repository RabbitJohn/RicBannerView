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

/**
 operations when click the banner.

 @param bannerItem the banner item value
 @param idx the index of the item value in the bannerItems.
 @param bannerView the banner view.
 */
- (void)didClickBanner:(id<RicBannerItem>)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView;

/**
 customize the banner item view yourself.
 note: the result that you have return should be cached to reduce the alloc operation.
 @param bannerItem: the data that your have implemte the RicBannerItem protocol
 @param idx :the index of the banner item in the array named bannerItems
 @param bannerView: the collection view as the root container
 @return the banner item view that you defined
 
 */
- (UIView *)customBannerViewForBanner:(id<RicBannerItem>)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView;
@end

/**
  the banner view that will dispaly
 */
@interface RicBannerView : UIView
/**
  the banner infos will show in the banner view.
 */
@property (nonatomic, strong) NSArray <id<RicBannerItem>> *bannerItems;
@property (nonatomic, strong) UIImage *bannerPlaceholderImage;
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
/// when you have something other do and will leave/enter the sight of the banner view invoke the methods below to start/stop playing the banner.
/**
  begin to auto scrolling by the timer
 */
- (void)startPlay;

/**
 resume the banner auto scroll
 */
- (void)resumePlay;
/**
  stop playing and stop the timer and set the timer to nil.
 */
- (void)pausePaly;

/**
 quit display and set the timer to nil
 */
- (void)quitPlay;


@end

/**
 the item represent a banner info.
 */
@protocol RicBannerItem <NSObject>
@required
/**
 url for the banner image that will be show.
 */
@property (nonatomic, strong) NSString *bannerImageUrl;

@optional
/**
 the banner link url
 */
@property (nonatomic, strong) NSString *bannerLinkUrl;

@end
