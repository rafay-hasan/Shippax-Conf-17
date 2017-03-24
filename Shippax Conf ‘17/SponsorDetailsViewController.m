//
//  SponsorDetailsViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/21/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "SponsorDetailsViewController.h"

@interface SponsorDetailsViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *sponsorWebview;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImageView;

@end

@implementation SponsorDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Main sponsor";
    
    if([self.fileName isEqualToString:@"MainSponsor"])
        self.sponsorImageView.image = [UIImage imageNamed:@"main1"];
    else
        self.sponsorImageView.image = [UIImage imageNamed:@"main2"];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.sponsorWebview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    self.sponsorWebview.opaque = NO;
    self.sponsorWebview.backgroundColor =  [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];
    htmlString = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#FFFFFF;'>%@",htmlString];
    [self.sponsorWebview loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; }</style>%@",htmlString] baseURL:nil];
    self.sponsorWebview.scrollView.scrollEnabled = YES;

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

@end
