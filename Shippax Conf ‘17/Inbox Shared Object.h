//
//  Inbox Shared Object.h
//  MCP
//
//  Created by Rafay Hasan on 1/21/16.
//  Copyright © 2016 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Inbox_Shared_Object : NSObject

@property (strong,nonatomic) NSNumber *totalCountNumber;



+ (Inbox_Shared_Object *) sharedInstance;



@end
