//
//  ProgrammeTableViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "insetLabel.h"
#import "TTTAttributedLabel.h"
@interface ProgrammeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *programmeNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *subProgrammeNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *speakersNameLabel;


@end
