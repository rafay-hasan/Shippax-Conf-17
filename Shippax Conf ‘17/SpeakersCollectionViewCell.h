//
//  SpeakersCollectionViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/16/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakersCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *speakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *speakerName;
@property (weak, nonatomic) IBOutlet UIWebView *speakerNameWebView;
@property (weak, nonatomic) IBOutlet UIImageView *speakerSelectedImageView;


@end
