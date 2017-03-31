//
//  AboutViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/20/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"
#import "ClientInfoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    double currentContentHeight,previousContentHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *aboutTableView;

@property (weak, nonatomic) IBOutlet UIWebView *aboutWebview;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About";
    
    currentContentHeight = 0;
    previousContentHeight = -10;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.aboutTableView.estimatedRowHeight = 50;
    self.aboutTableView.rowHeight = UITableViewAutomaticDimension;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL flag;
    NSError *setCategoryError = nil;
    flag = [audioSession setCategory:AVAudioSessionCategoryPlayback
                               error:&setCategoryError];
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

#pragma mark Tableview data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 3)
    {
        ClientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clientInfoCell" forIndexPath:indexPath];
        
        cell.appVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.clientIdLabel.text = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else
    {
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
        
        if(indexPath.section == 0)
        {
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"firstVideo" ofType:@"html"];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [cell.aboutWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
            cell.aboutWebView.scrollView.scrollEnabled = NO;
            cell.aboutWebViewContentHeight.constant = 176;
            
        }
        else if (indexPath.section == 1)
        {
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"secondVideo" ofType:@"html"];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [cell.aboutWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
            cell.aboutWebView.scrollView.scrollEnabled = NO;
            cell.aboutWebViewContentHeight.constant = 176;
        }
        else if (indexPath.section == 2)
        {
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"html"];
            NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [cell.aboutWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
            cell.aboutWebView.opaque = NO;
            cell.aboutWebView.mediaPlaybackRequiresUserAction = NO;
            cell.aboutWebView.allowsInlineMediaPlayback = YES;
            cell.aboutWebView.backgroundColor =  [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
            htmlString = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",htmlString];
            [cell.aboutWebView loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",htmlString] baseURL:nil];
            cell.aboutWebView.delegate = self;
            cell.aboutWebView.scrollView.scrollEnabled = NO;
            cell.aboutWebViewContentHeight.constant = currentContentHeight;
            
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    
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
    
    currentContentHeight = aWebView.scrollView.contentSize.height;
    
    if(currentContentHeight != previousContentHeight)
    {
        previousContentHeight = currentContentHeight;
        [self.aboutTableView reloadData];
    }
}


@end
