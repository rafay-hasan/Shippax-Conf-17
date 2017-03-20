//
//  AppDelegate.h
//  Shippax Conf ‘17
//
//  Created by Rafay Hasan on 3/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) UITabBarController *tabBarController;
@property (nonatomic) Reachability *internetReachability;


@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
- (NSInteger) retrieveTotalUnreadMessage;
- (NSArray *) retrieveAllInboxMessages;
- (void) updateMessageStatusWithMessageId:(NSString *)messageId;
- (BOOL) deleteMessageforMessageId: (NSString *) messageId;

@end

