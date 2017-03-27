//
//  insetLabel.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/27/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface insetLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;
@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end
