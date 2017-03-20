//
//  MessageObject.h
//  MCP
//
//  Created by Rafay Hasan on 1/19/16.
//  Copyright © 2016 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (strong,nonatomic) NSString *messageId;

@property (nonatomic) NSNumber *messageStatus;

@property (strong,nonatomic) NSString *messageTitle;

@property (strong,nonatomic) NSString *messageDetails;

@property (nonatomic) NSNumber *time;

@property (strong,nonatomic) NSString *image;

@end
