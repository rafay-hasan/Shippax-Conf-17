//
//  SpeakersViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/16/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SpeakersViewController.h"
#import "KASlideShow.h"
#import "RHWebServiceManager.h"
#import "UIImageView+AFNetworking.h"
#import "SpeakersCollectionViewCell.h"
#import "SpeakerWebServiceObject.h"

@interface SpeakersViewController ()<KASlideShowDelegate,KASlideShowDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RHWebServiceDelegate,UIWebViewDelegate>
{
    NSMutableArray * _datasource;
}

@property (weak, nonatomic) IBOutlet KASlideShow *slideShow;
@property (weak, nonatomic) IBOutlet UICollectionView *speakerCollectionView;
@property (weak, nonatomic) IBOutlet UIWebView *speakerDetailWebview;

@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) NSArray *speakersDataArray;
@property (strong,nonatomic) SpeakerWebServiceObject *speakerObject;

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Speakers";
    
    self.speakerObject = [SpeakerWebServiceObject new];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    [self.speakerCollectionView setCollectionViewLayout:flowLayout];
    
    self.slideShow.datasource = self;
    self.slideShow.delegate = self;
    [self.slideShow setDelay:2]; // Delay between transitions
    [self.slideShow setTransitionDuration:1]; // Transition duration
    [self.slideShow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [self.slideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [self.slideShow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
    
    _datasource = [@[[UIImage imageNamed:@"slider1"],
                     [UIImage imageNamed:@"slider2"],
                     [UIImage imageNamed:@"slider3"],
                     [UIImage imageNamed:@"slider4"]] mutableCopy];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.slideShow start];
    [self CallSpeakersWebservice];
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
    return self.speakersDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SpeakerCell";
    
    SpeakersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    self.speakerObject = [self.speakersDataArray objectAtIndex:indexPath.row];
    cell.speakerName.text = self.speakerObject.speakerName;
    //[cell.speakerImageView setImageWithURL:[NSURL URLWithString:self.speakerObject.speakerImageUrlStr]];
    
    cell.speakerNameWebView.opaque = NO;
    cell.speakerNameWebView.backgroundColor =  [UIColor colorWithRed:0.19 green:0.24 blue:0.35 alpha:0.8];
    //htmlString = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",htmlString];
    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",self.speakerObject.speakerName];
    [cell.speakerNameWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    cell.speakerNameWebView.scrollView.scrollEnabled = NO;

    [cell.speakerImageView setImageWithURL:[NSURL URLWithString:self.speakerObject.speakerImageUrlStr] placeholderImage:[UIImage imageNamed:@"SpeakerPlaceholder"]];
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.speakerObject = [self.speakersDataArray objectAtIndex:indexPath.row];
    [self loadDetailsWebview:self.speakerObject.speakerDetails];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(143.0, 143.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}


-(void) CallSpeakersWebservice
{
    self.view.userInteractionEnabled = NO;
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeSpeakers Delegate:self];
    [self.myWebservice getDataFromWebURL:[NSString stringWithFormat:@"%@Speakers",BASE_URL_API]];
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebservice.requestType == HTTPRequestTypeSpeakers)
    {
        NSArray *tempArray = (NSArray *)responseObj;
        self.speakersDataArray = [NSArray arrayWithArray:tempArray];
        self.speakerObject = [self.speakersDataArray objectAtIndex:0];
        [self loadDetailsWebview:self.speakerObject.speakerDetails];

        [self.speakerCollectionView reloadData];
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

-(void) loadDetailsWebview:(NSString *)details
{
    self.speakerDetailWebview.opaque = NO;
    self.speakerDetailWebview.backgroundColor =  [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
    //htmlString = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",htmlString];
    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",details];
    [self.speakerDetailWebview loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    self.speakerDetailWebview.delegate = self;
    self.speakerDetailWebview.scrollView.scrollEnabled = YES;
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
