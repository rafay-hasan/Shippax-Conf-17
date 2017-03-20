//
//  InboxTableViewCell.h
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/20/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageDate;

@property (weak, nonatomic) IBOutlet UILabel *messageDetails;
@property (weak, nonatomic) IBOutlet UILabel *messageStatus;

@end
