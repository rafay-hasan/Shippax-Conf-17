//
//  HomeTableViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/20/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *titleWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContentHeight;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImageHeight;

@property (weak, nonatomic) IBOutlet UIWebView *detailsWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsContentHeight;


@end
