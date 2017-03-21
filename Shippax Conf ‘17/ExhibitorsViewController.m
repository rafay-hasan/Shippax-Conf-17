//
//  ExhibitorsViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/21/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ExhibitorsViewController.h"
#import "KASlideShow.h"
#import "RHWebServiceManager.h"
#import "UIImageView+AFNetworking.h"
#import "ExhibitorCollectionViewCell.h"

@interface ExhibitorsViewController ()<RHWebServiceDelegate,UICollectionViewDelegate,UICollectionViewDataSource,KASlideShowDelegate,KASlideShowDataSource>
{
    NSMutableArray * _datasource;
}

@property (weak, nonatomic) IBOutlet KASlideShow *slideShow;
@property (weak, nonatomic) IBOutlet UICollectionView *exhibitorCollectionView;
@property (weak, nonatomic) IBOutlet UIWebView *mainSponsorWebview;
@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) NSArray *exhibitorsDataArray;

@end

@implementation ExhibitorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Exhibitors";
    
   // self.speakerObject = [SpeakerWebServiceObject new];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    [self.exhibitorCollectionView setCollectionViewLayout:flowLayout];
    
    self.slideShow.datasource = self;
    self.slideShow.delegate = self;
    [self.slideShow setDelay:2]; // Delay between transitions
    [self.slideShow setTransitionDuration:1]; // Transition duration
    [self.slideShow setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
    [self.slideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [self.slideShow addGesture:KASlideShowGestureSwipe]; // Gesture to go previous/next directly on the image
    
    _datasource = [@[[UIImage imageNamed:@"slider1"],
                     [UIImage imageNamed:@"slider2"],
                     [UIImage imageNamed:@"slider3"],
                     [UIImage imageNamed:@"slider4"]] mutableCopy];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.slideShow start];
    [self CallExhibitorWebservice];
    [self loadDetailsWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
}

#pragma mark - Collectionview datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.exhibitorsDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"exhibitorCell";
    
    ExhibitorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if([[[self.exhibitorsDataArray objectAtIndex:indexPath.row]valueForKey:@"imageUrl"] isKindOfClass:[NSString class]])
        [cell.exhibitorImageView setImageWithURL:[NSURL URLWithString:[[self.exhibitorsDataArray objectAtIndex:indexPath.row]valueForKey:@"imageUrl"]]];
    else
        cell.exhibitorImageView.image = nil;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if([[[self.exhibitorsDataArray objectAtIndex:indexPath.row]valueForKey:@"link"] isKindOfClass:[NSString class]])
   {
       NSURL *requestedURL = [NSURL URLWithString:[[self.exhibitorsDataArray objectAtIndex:indexPath.row]valueForKey:@"link"]];
       [[UIApplication sharedApplication] openURL:requestedURL];
   }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(96.0, 96.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}


-(void) CallExhibitorWebservice
{
    self.view.userInteractionEnabled = NO;
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeExhibitor Delegate:self];
    [self.myWebservice getDataFromWebURL:[NSString stringWithFormat:@"%@exhibitors",BASE_URL_API]];
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebservice.requestType == HTTPRequestTypeExhibitor)
    {
        NSArray *tempArray = (NSArray *)responseObj;
        self.exhibitorsDataArray = [NSArray arrayWithArray:tempArray];
        //self.speakerObject = [self.speakersDataArray objectAtIndex:0];
        //[self loadDetailsWebview:self.speakerObject.speakerDetails];
        
        [self.exhibitorCollectionView reloadData];
    }
}


-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) loadDetailsWebview
{
//    self.speakerDetailWebview.opaque = NO;
//    self.speakerDetailWebview.backgroundColor =  [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
//    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='color:#FFFFFF;'>%@",details];
//    [self.speakerDetailWebview loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
//    self.speakerDetailWebview.delegate = self;
//    self.speakerDetailWebview.scrollView.scrollEnabled = YES;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"MainSponsor" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    htmlString =  [NSString stringWithFormat:@"<div style='color:#FFFFFF;'>%@",htmlString];
    htmlString = [NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",htmlString];
    [self.mainSponsorWebview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    self.mainSponsorWebview.scrollView.scrollEnabled = YES;
    self.mainSponsorWebview.backgroundColor =  [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
    
}

#pragma mark Table View Delegate Method ends

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // [self.activityIndicator startAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *requestedURL = [request URL];
        [[UIApplication sharedApplication] openURL:requestedURL];
        return NO;
    }
    return YES;
}



@end
