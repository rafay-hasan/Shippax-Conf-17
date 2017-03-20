//
//  AboutTableViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/20/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutWebViewContentHeight;

@end
