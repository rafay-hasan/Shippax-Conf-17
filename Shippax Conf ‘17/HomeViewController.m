//
//  HomeViewController.m
//  Shippax Conf ‘17
//
//  Created by Rafay Hasan on 3/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "HomeViewController.h"
#import "KASlideShow.h"
#import "RHWebServiceManager.h"
#import "HomeTableViewCell.h"
#import "HomeWebServiceObject.h"
#import "UIImageView+AFNetworking.h"

@interface HomeViewController ()<KASlideShowDelegate,KASlideShowDataSource,RHWebServiceDelegate,UIWebViewDelegate>
{
    NSMutableArray * _datasource;
    double firstTitleCurrentContentHeight,firstTitlePreviousContentHeight,firstDetailsCurrentContentHeight,firstDetailsePreviousContentHeight;
    double secondTitleCurrentContentHeight,secondTitlePreviousContentHeight,secondDetailsCurrentContentHeight,secondDetailsePreviousContentHeight;
    double thirdTitleCurrentContentHeight,thirdTitlePreviousContentHeight,thirdDetailsCurrentContentHeight,thirdDetailsePreviousContentHeight;

}
@property (weak, nonatomic) IBOutlet KASlideShow *slideShow;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

@property (strong,nonatomic) RHWebServiceManager *myWebservice;
@property (strong,nonatomic) NSArray *homeDataArray;
@property (strong,nonatomic) HomeWebServiceObject *homeObject;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    firstTitleCurrentContentHeight = secondTitleCurrentContentHeight = thirdTitleCurrentContentHeight = 0;
    firstTitlePreviousContentHeight = secondTitlePreviousContentHeight = thirdTitlePreviousContentHeight = -10;
    
    firstDetailsCurrentContentHeight = secondDetailsCurrentContentHeight = thirdDetailsCurrentContentHeight = 0;
    firstDetailsePreviousContentHeight = secondDetailsePreviousContentHeight  = thirdTitlePreviousContentHeight = -10;
    
    
    //previousContentHeight = -10;
    //currentContentHeight = 0;

    
    self.homeObject = [HomeWebServiceObject new];
    
    // KASlideshow
    self.slideShow.datasource = self;
    self.slideShow.delegate = self;
    [self.slideShow setDelay:.5]; // Delay between transitions
    [self.slideShow setTransitionDuration:1]; // Transition duration
    [self.slideShow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [self.slideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [self.slideShow addGesture:KASlideShowGestureSwipe]; // Gesture to go previous/next directly on the image
    
    _datasource = [@[[UIImage imageNamed:@"slider1"],
                     [UIImage imageNamed:@"slider2"],
                     [UIImage imageNamed:@"slider3"],
                     [UIImage imageNamed:@"slider4"]] mutableCopy];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.homeTableView.estimatedRowHeight = 50;
    self.homeTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self CallHomeWebservice];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.slideShow start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) CallHomeWebservice
{
    self.view.userInteractionEnabled = NO;
    self.myWebservice = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestTypeHome Delegate:self];
    [self.myWebservice getDataFromWebURL:[NSString stringWithFormat:@"%@HomeItems",BASE_URL_API]];
}


-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    self.view.userInteractionEnabled = YES;
    
    if(self.myWebservice.requestType == HTTPRequestTypeHome)
    {
        NSArray *tempArray = (NSArray *)responseObj;
        self.homeDataArray = [NSArray arrayWithArray:tempArray];
       // self.speakerObject = [self.speakersDataArray objectAtIndex:0];
        //[self loadDetailsWebview:self.speakerObject.speakerDetails];
        
        [self.homeTableView reloadData];
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

#pragma mark Tableview data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.homeDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"homeCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    self.homeObject = [self.homeDataArray objectAtIndex:indexPath.section];
    
    cell.titleWebView.opaque = NO;
    cell.titleWebView.backgroundColor =  [UIColor clearColor];//[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
    NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:HelveticaNeue-Bold;color:#FFFFFF;'>%@",self.homeObject.homeTitle];
    [cell.titleWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    cell.titleWebView.delegate = self;
    cell.titleWebView.scrollView.scrollEnabled = NO;
    cell.titleWebView.tag = 1000 + indexPath.section;
    
    cell.detailsWebView.opaque = NO;
    cell.detailsWebView.backgroundColor =  [UIColor clearColor];//[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
    detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",self.homeObject.homeDescription];
    [cell.detailsWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",detailsWebStrstr] baseURL:nil];
    cell.detailsWebView.delegate = self;
    cell.detailsWebView.scrollView.scrollEnabled = NO;
    cell.detailsWebView.tag = 2000 + indexPath.section;

    
    if(indexPath.section == 0)
    {
        [cell.contentImageView setImageWithURL:[NSURL URLWithString:self.homeObject.homeImageUrlStr]];
        cell.contentImageHeight.constant = 100;
        
        cell.titleContentHeight.constant = firstTitleCurrentContentHeight;
        cell.detailsContentHeight.constant = firstDetailsCurrentContentHeight;
    }
    else if (indexPath.section == 1)
    {
        [cell.contentImageView setImageWithURL:[NSURL URLWithString:self.homeObject.homeImageUrlStr]];
         cell.contentImageHeight.constant = 150;
        
        cell.titleContentHeight.constant = secondTitleCurrentContentHeight;
        cell.detailsContentHeight.constant = secondDetailsCurrentContentHeight;
    }
    else if (indexPath.section == 2)
    {
        cell.contentImageView.image = nil;
        cell.contentImageHeight.constant = 0;
        
        cell.titleContentHeight.constant = thirdTitleCurrentContentHeight;
        cell.detailsContentHeight.constant = thirdDetailsCurrentContentHeight;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.00;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.00;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark Web View Delegate Method


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

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    
    if(aWebView.tag == 1000)
    {
        firstTitleCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(firstTitlePreviousContentHeight != firstTitleCurrentContentHeight)
        {
            firstTitlePreviousContentHeight = firstTitleCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }
    
    if(aWebView.tag == 1001)
    {
        secondTitleCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(secondTitleCurrentContentHeight != secondTitlePreviousContentHeight)
        {
            secondTitlePreviousContentHeight = secondTitleCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }

    
    if(aWebView.tag == 1002)
    {
        thirdTitleCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(thirdTitleCurrentContentHeight != thirdTitlePreviousContentHeight)
        {
            thirdTitlePreviousContentHeight = thirdTitleCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }
    
    if(aWebView.tag == 2000)
    {
        firstDetailsCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(firstDetailsCurrentContentHeight != firstDetailsePreviousContentHeight)
        {
            firstDetailsePreviousContentHeight = firstDetailsCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }
    
    if(aWebView.tag == 2001)
    {
        secondDetailsCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(secondDetailsCurrentContentHeight != secondDetailsePreviousContentHeight)
        {
            secondDetailsePreviousContentHeight = secondDetailsCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }
    
    
    if(aWebView.tag == 2002)
    {
        thirdDetailsCurrentContentHeight = aWebView.scrollView.contentSize.height;
        
        if(thirdDetailsCurrentContentHeight != thirdDetailsePreviousContentHeight)
        {
            thirdDetailsePreviousContentHeight = thirdDetailsCurrentContentHeight;
            [self.homeTableView reloadData];
        }
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    
}


@end
