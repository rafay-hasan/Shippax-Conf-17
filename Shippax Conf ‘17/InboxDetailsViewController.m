//
//  InboxDetailsViewController.m
//  Shippax Storyboard
//
//  Created by Rafay Hasan on 2/9/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "InboxDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "Inbox Shared Object.h"
#import <QuartzCore/QuartzCore.h>

@interface InboxDetailsViewController ()
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UITextView *messageDetailsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@end

@implementation InboxDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Notifications";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadDetailsView];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [appDelegate updateMessageStatusWithMessageId:self.messageObject.messageId];
    [Inbox_Shared_Object sharedInstance].totalCountNumber = [NSNumber numberWithInteger:[appDelegate retrieveTotalUnreadMessage]];
    
    if([Inbox_Shared_Object sharedInstance].totalCountNumber >= [NSNumber numberWithInt:1])
        [appDelegate.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%@",[Inbox_Shared_Object sharedInstance].totalCountNumber];
    else
        [appDelegate.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
}


- (void) loadDetailsView
{
    self.messageTitleLabel.text = self.messageObject.messageTitle;
    double unixTimeStamp = [self.messageObject.time doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MMM d, yyyy hh:mm a"];
    NSString *dateString = [formatter stringFromDate:date];
    self.messageDateLabel.text = dateString;
    self.messageDetailsTextView.text = self.messageObject.messageDetails;
    CGSize sizeThatFitsTextView = [self.messageDetailsTextView sizeThatFits:CGSizeMake(self.messageDetailsTextView.frame.size.width, MAXFLOAT)];
    self.textViewHeight.constant = sizeThatFitsTextView.height;
    
    self.scrollContentHeight.constant = self.textViewHeight.constant + self.messageDetailsTextView.frame.origin.y + 30;
    [self.view layoutIfNeeded];

    [self loadFeaturedImage];

}
- (void) loadFeaturedImage
{
    NSURL *url = [NSURL URLWithString:self.messageObject.image];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    [indicator setCenter:self.messageImageView.center];
    [self.messageImageView addSubview:indicator];
    
    [self.messageImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [indicator removeFromSuperview];
        self.messageImageView.image = image;
        self.messageImageView.hidden = NO;
        self.imageHeight.constant = 157;
        
        [self.view layoutIfNeeded];
        [self updateLayoutForView];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [indicator removeFromSuperview];
        self.messageImageView.hidden = YES;
        self.messageImageView.image = nil;
        self.imageHeight.constant = 1;
        
        [self.view layoutIfNeeded];
        [self updateLayoutForView];
    }];
    
}

- (void) updateLayoutForView
{
    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.containerView.bounds];
//    self.containerView.layer.masksToBounds = NO;
//    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.containerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    self.containerView.layer.shadowOpacity = 0.3f;
//    self.containerView.layer.shadowPath = shadowPath.CGPath;
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
