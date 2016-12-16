//
//  ViewController.m
//  RicBannerView
//
//  Created by rice on 2016/12/13.
//  Copyright © 2016年 rice. All rights reserved.
//

#import "ViewController.h"
#import <RicBannerView/RicBannerView.h>

@interface AnyBannerObj : NSObject <RicBannerItem>

@property (nonatomic, strong) NSString *bannerImageUrl;
@property (nonatomic, strong) UIImage *bannerPlaceholderImage;

@property (nonatomic, strong) NSString *bannerLinkUrl;
@property (nonatomic, strong) UIImage *bannerImage;


@end

@implementation AnyBannerObj


@end

@interface ViewController ()<RicBannerViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RicBannerView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *items = [NSMutableArray new];
    NSArray *bannerImageUrls = @[@"http://img05.tooopen.com/images/20140919/sy_71272488121.jpg",
                                 @"http://img04.tooopen.com/images/20130712/tooopen_17270713.jpg",
                                 @"http://img06.tooopen.com/images/20161112/tooopen_sy_185726882764.jpg",
                                 @"http://img06.tooopen.com/images/20161113/tooopen_sy_186542862378.jpg"];
    NSArray *bannerLinkUrls = @[@"http://www.baidu.com/",
                                @"http://www.sina.com.cn/",
                                @"http://www.baidu.com/",
                                @"http://www.sina.com.cn/"];
    for (int i=0; i<4; i++){
        AnyBannerObj *item = [AnyBannerObj new];
        item.bannerImageUrl = bannerImageUrls[i];
        item.bannerLinkUrl = bannerLinkUrls[i];
        [items addObject:item];
    }
    
    self.bannerView = [[RicBannerView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width,100)];
//    self.bannerView.delegate = self;
    self.bannerView.bannerItems = items;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 2*CGRectGetHeight(self.view.bounds));
    [self.scrollView addSubview:self.bannerView];
    [self.view addSubview:self.scrollView];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (UIView *)customBannerViewForBanner:(id<RicBannerItem>)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView{
    if (idx == 2){
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, bannerView.frame.size.height)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 30)];
        btn.backgroundColor = [UIColor yellowColor];
        [btn setTitle:@"click here for alert" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickHere) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:btn];
        return customView;
    }else{
        return nil;
    }
}
- (void)didClickBanner:(id<RicBannerItem>)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView{
    NSLog(@"click banner to link url %@ at index:%ld\n",bannerItem.bannerLinkUrl,idx);
}

- (void)clickHere{
//    [self.bannerView pausePaly];
    [[[UIAlertView alloc] initWithTitle:nil message:@"this is a notice" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // do nothing here.
//    [self.bannerView resumePlay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bannerView startPlay];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.bannerView pausePaly];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
