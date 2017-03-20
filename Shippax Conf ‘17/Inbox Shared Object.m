//
//  Inbox Shared Object.m
//  MCP
//
//  Created by Rafay Hasan on 1/21/16.
//  Copyright © 2016 Nascenia. All rights reserved.
//

#import "Inbox Shared Object.h"

@implementation Inbox_Shared_Object

+ (Inbox_Shared_Object *) sharedInstance
{
    static dispatch_once_t pred;
    static Inbox_Shared_Object *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
    
}


-(id) init
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.totalCountNumber = [NSNumber numberWithInteger:[appDelegate retrieveTotalUnreadMessage]];
    
    return self;
}


@end
