//
//  ProgrammeTableViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgrammeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *programmeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subProgrammeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakersNameLabel;


@end
