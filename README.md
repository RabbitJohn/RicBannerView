# RicBannerView
###Effect
![image](https://github.com/zLihuan/RicBannerView/blob/master/demo.gif) 
###Usage
 
	@interface ViewController ()<RicBannerViewDelegate>
	@property (nonatomic, strong) UIScrollView *scrollView;
	@property (nonatomic, strong) RicBannerView *bannerView;
	@end
	@implementation ViewController
	-(void)viewDidLoad 
	{
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
	        RicBannerItem *item = [RicBannerItem new];
	        item.bannerImageUrl = bannerImageUrls[i];
	        item.bannerLinkUrl = bannerLinkUrls[i];
	        [items addObject:item];
	    }
	    self.bannerView = [[RicBannerView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width,100)];
	    self.bannerView.delegate = self;
	    self.bannerView.bannerItems = items;
	    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 2*CGRectGetHeight(self.view.bounds));
	    [self.scrollView addSubview:self.bannerView];
	    [self.view addSubview:self.scrollView];    
	    // Do any additional setup after loading the view, typically from a nib.
	}
	-(void)didClickBanner:(RicBannerItem *)bannerItem atIndex:(NSUInteger)idx bannerView:(RicBannerView *)bannerView
	{
	NSLog(@"click banner to link url %@ at index:%ld\n",bannerItem.bannerLinkUrl,idx);
	}
	-(void)viewWillAppear:(BOOL)animated{
	    [super viewWillAppear:animated];
	    // start the timer for playing
	    [self.bannerView beginPlay];
	}
	-(void)viewWillDisappear:(BOOL)animated{
	    [super viewWillDisappear:animated];
	    // stop the timer for auto scrolling.
	    [self.bannerView stopPaly];
	}
	@end

###Integration:

To integrate the control use Cocoapods add the line below into your Podfile: 

pod:'RicBannerView'



