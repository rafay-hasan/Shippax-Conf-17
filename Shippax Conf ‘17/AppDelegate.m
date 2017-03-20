//
//  AppDelegate.m
//  Shippax Conf ‘17
//
//  Created by Rafay Hasan on 3/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "AppDelegate.h"
#import "StreamingConnection.h"
#import "MessageObject.h"
#import "Inbox Shared Object.h"
#import "AFNetworking.h"
#include <sys/sysctl.h>
#import <Meridian/Meridian.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MRConfig *config = [MRConfig new];
    config.applicationToken = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"DeviceToken"];
    [Meridian configure:config];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    [Inbox_Shared_Object sharedInstance].totalCountNumber = [NSNumber numberWithInteger:[self retrieveTotalUnreadMessage]];
    
    if([Inbox_Shared_Object sharedInstance].totalCountNumber >= [NSNumber numberWithInt:1])
        [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%@",[Inbox_Shared_Object sharedInstance].totalCountNumber];
    else
        [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
    
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    [self establishWebSocketConnection];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[StreamingConnection sharedConnection]stop];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"LastTime"] isKindOfClass:[NSString class]])
    {
        ;
    }
    else
    {
        NSDateFormatter *bulletinDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate date];
        
        [bulletinDateFormatter setTimeZone:timeZone];
        [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[NSUserDefaults standardUserDefaults]setObject:[bulletinDateFormatter stringFromDate:date] forKey:@"LastTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/Schedule/FindQueuedBulletin",SRConnectionBaseURL];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"LastTime"],@"startTime",[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"clientid", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/xml", nil];
    
    [manager POST:requestURL parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSInteger statusCode = operation.response.statusCode;
         
         if(statusCode == 200)
         {
             
             if([responseObject isKindOfClass:[NSArray class]])
             {
                 NSArray *queedArray = (NSArray *)responseObject;
                 for(NSInteger i=0; i < queedArray.count; i++)
                 {
                     
                     NSString *title;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"title"] isKindOfClass:[NSString class]])
                     {
                         title = [[queedArray objectAtIndex:i] valueForKey:@"title"];
                         
                     }
                     else
                         title = @"";
                     
                     
                     
                     NSString *messageDetails;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"description"] isKindOfClass:[NSString class]])
                     {
                         messageDetails = [[queedArray objectAtIndex:i] valueForKey:@"description"];
                         
                     }
                     else
                         messageDetails = @"";
                     
                     NSString *featuredImage;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"image_url"] isKindOfClass:[NSString class]])
                     {
                         featuredImage = [NSString stringWithFormat:@"%@%@",SRConnectionBaseURL,[[queedArray objectAtIndex:i] valueForKey:@"image_url"]];
                     }
                     else
                         featuredImage = @"";
                     
                     
                     [self saveMessageWithId:[self retrieveMessageId] title:title details:messageDetails imageUrl:featuredImage withUnixTime:0.0];
                     
                     
                     [Inbox_Shared_Object sharedInstance].totalCountNumber = [NSNumber numberWithInteger:[self retrieveTotalUnreadMessage]];
                     
                     if([Inbox_Shared_Object sharedInstance].totalCountNumber >= [NSNumber numberWithInt:1])
                         [self.tabBarController.tabBar.items objectAtIndex:1].badgeValue = [NSString stringWithFormat:@"%@",[Inbox_Shared_Object sharedInstance].totalCountNumber];
                     else
                         [self.tabBarController.tabBar.items objectAtIndex:1].badgeValue = nil;
                     
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"InboxNotification" object:nil];
                     
                     
                     UILocalNotification *bulletin = [[UILocalNotification alloc] init];
                     
                     bulletin.alertBody = title;
                     
                     bulletin.soundName = UILocalNotificationDefaultSoundName;
                     
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"bulletin" forKey:@"notificationName"];
                     
                     bulletin.userInfo = userInfo;
                     
                     [[UIApplication sharedApplication] presentLocalNotificationNow:bulletin];
                     
                 }
                 
                 NSDateFormatter *bulletinDateFormatter = [[NSDateFormatter alloc] init];
                 NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                 [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSDate *date = [NSDate date];
                 
                 [bulletinDateFormatter setTimeZone:timeZone];
                 [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 [[NSUserDefaults standardUserDefaults]setObject:[bulletinDateFormatter stringFromDate:date] forKey:@"LastTime"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [self establishWebSocketConnection];
             }
         }
         else
         {
             [self establishWebSocketConnection];
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self establishWebSocketConnection];
     }
     ];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/Schedule/FindQueuedBulletin",SRConnectionBaseURL];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"LastTime"],@"startTime",[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"clientid", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain",@"text/xml", nil];
    
    [manager POST:requestURL parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSInteger statusCode = operation.response.statusCode;
         NSString *messageId = [NSString new];
         
         if(statusCode == 200)
         {
             if([responseObject isKindOfClass:[NSArray class]])
             {
                 NSArray *queedArray = (NSArray *)responseObject;
                 
                 NSLog(@"response is %@",responseObject);
                 
                 for(NSInteger i=0; i < queedArray.count; i++)
                 {
                     NSString *title;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"title"] isKindOfClass:[NSString class]])
                     {
                         title = [[queedArray objectAtIndex:i] valueForKey:@"title"];
                     }
                     else
                         title = @"";
                     
                     
                     NSString *messageDetails;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"description"] isKindOfClass:[NSString class]])
                     {
                         messageDetails = [[queedArray objectAtIndex:i] valueForKey:@"description"];
                         
                     }
                     else
                         messageDetails = @"";
                     
                     NSString *featuredImage;
                     
                     if([[[queedArray objectAtIndex:i] valueForKey:@"image_url"] isKindOfClass:[NSString class]])
                     {
                         featuredImage = [NSString stringWithFormat:@"%@%@",SRConnectionBaseURL,[[queedArray objectAtIndex:i] valueForKey:@"image_url"]];
                     }
                     else
                         featuredImage = @"";
                     
                     if(i == 0)
                         messageId = [[queedArray objectAtIndex:i] valueForKey:@"id"];
                     else
                         messageId = [NSString stringWithFormat:@"%@,%@",messageId,[[queedArray objectAtIndex:i] valueForKey:@"id"]];
                     
                     
                     [self saveMessageWithId:[self retrieveMessageId] title:title details:messageDetails imageUrl:featuredImage withUnixTime:0.0];
                     
                     
                     [Inbox_Shared_Object sharedInstance].totalCountNumber = [NSNumber numberWithInteger:[self retrieveTotalUnreadMessage]];
                     
                     if([Inbox_Shared_Object sharedInstance].totalCountNumber >= [NSNumber numberWithInt:1])
                         [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%@",[Inbox_Shared_Object sharedInstance].totalCountNumber];
                     else
                         [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
                     
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"InboxNotification" object:nil];
                     
                     
                     UILocalNotification *bulletin = [[UILocalNotification alloc] init];
                     
                     bulletin.alertBody = title;
                     
                     bulletin.soundName = UILocalNotificationDefaultSoundName;
                     
                     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"bulletin" forKey:@"notificationName"];
                     
                     bulletin.userInfo = userInfo;
                     
                     [[UIApplication sharedApplication] presentLocalNotificationNow:bulletin];
                     
                 }
                 
                 NSLog(@"Message is is %@",messageId);
                 
                 if(messageId.length > 0)
                 {
                     NSString *requestURL = [NSString stringWithFormat:@"%@/api/Schedule/AckQueuedBulletin?scheduleId=%@&clientId=%@",SRConnectionBaseURL,messageId,[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
                     requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/css", nil];
                     manager.securityPolicy.allowInvalidCertificates = YES;
                     manager.securityPolicy.validatesDomainName = NO;
                     
                     [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                      {
                          ;
                      }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
                      {
                          ;
                      }
                      ];
                     
                     
                 }
                 
                 NSDateFormatter *bulletinDateFormatter = [[NSDateFormatter alloc] init];
                 NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                 [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 NSDate *date = [NSDate date];
                 
                 [bulletinDateFormatter setTimeZone:timeZone];
                 [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                 [[NSUserDefaults standardUserDefaults]setObject:[bulletinDateFormatter stringFromDate:date] forKey:@"LastTime"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 completionHandler(UIBackgroundFetchResultNewData);
                 
             }
             
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error is %@",error.debugDescription);
         completionHandler(UIBackgroundFetchResultFailed);
     }
     ];
}


-(void) establishWebSocketConnection
{
    // __weak typeof(self) weakSelf = self;
    
    [[StreamingConnection sharedConnection] setStarted:^{
        
        NSString *language ;
        NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *subStr = [currentLanguage substringWithRange:NSMakeRange(0, 2)];
        
        if([subStr isEqualToString:@"fo"])
        {
            language = @"fo";
        }
        else if ([subStr isEqualToString:@"de"])
        {
            language = @"de";
        }
        else if ([subStr isEqualToString:@"da"])
        {
            language = @"da";
        }
        else
        {
            language = @"en";
        }
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *phoneType = [self getModel];
        NSString *phoneId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *ageGroup = @"all";
        NSString *gender = @"both";
        
        [[StreamingConnection sharedConnection].hub invoke:@"register" withArgs:[NSArray arrayWithObjects:phoneId,phoneType,appVersion,language,ageGroup,gender, nil] completionHandler:^(id response, NSError *error) {
            NSLog(@"Response is %@ and error is %@",response,error.description);
        }];
        
        [[StreamingConnection sharedConnection].hub on:@"onBulletinSent" perform:self selector:@selector(messageReceived:)];
        [[StreamingConnection sharedConnection].hub on:@"register" perform:self selector:@selector(didRegister)];
        
    }];
    [[StreamingConnection sharedConnection] setReconnecting:^{
        NSLog(@"Connection Reconnecting");
    }];
    [[StreamingConnection sharedConnection] setReconnected:^{
        NSLog(@"Connection Reconnected");
    }];
    [[StreamingConnection sharedConnection] setConnectionSlow:^{
        NSLog(@"Connection Slow");
    }];
    [[StreamingConnection sharedConnection] setReceived:^(NSString * data){
        
        ;
    }];
    [[StreamingConnection sharedConnection] setError:^(NSError *error){
        NSLog(@"%@",[NSString stringWithFormat:@"Connection Error: %@",error.localizedDescription]);
    }];
    [[StreamingConnection sharedConnection] setClosed:^()
     {
         NSLog(@"Connection Closed");
     }];
    [[StreamingConnection sharedConnection] start];
    
}

-(void) didRegister
{
    ;
}


-(void) messageReceived:(id )Message
{
    [[StreamingConnection sharedConnection].hub invoke:@"BulletinAck" withArgs:[NSArray arrayWithObjects:[Message valueForKey:@"id"], [[[UIDevice currentDevice] identifierForVendor] UUIDString], nil] completionHandler:^(id response, NSError *error) {
        NSLog(@"Response is %@ and error is %@",response,error.description);
    }];
    
    
    NSString *title,*messageDetails,*featuredImage;
    
    if([[Message valueForKey:@"title"] isKindOfClass:[NSString class]])
    {
        title = [Message valueForKey:@"title"];
    }
    else
    {
        title = @"";
    }
    
    if([[Message valueForKey:@"description"] isKindOfClass:[NSString class]])
    {
        messageDetails = [Message valueForKey:@"description"];
    }
    else
    {
        messageDetails = @"";
    }
    
    if([[Message valueForKey:@"image_url"] isKindOfClass:[NSString class]])
    {
        featuredImage = [NSString stringWithFormat:@"%@%@",SRConnectionBaseURL,[Message valueForKey:@"image_url"]];
    }
    else
    {
        featuredImage = @"";
    }
    
    [self saveMessageWithId:[self retrieveMessageId] title:title details:messageDetails imageUrl:featuredImage withUnixTime:0.0];
    
    
    [Inbox_Shared_Object sharedInstance].totalCountNumber = [NSNumber numberWithInteger:[self retrieveTotalUnreadMessage]];
    if([Inbox_Shared_Object sharedInstance].totalCountNumber >= [NSNumber numberWithInt:1])
        [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%@",[Inbox_Shared_Object sharedInstance].totalCountNumber];
    else
        [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
    
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"InboxNotification" object:nil];
    dispatch_async(dispatch_get_main_queue(),^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InboxNotification" object:nil];
    });
    
    
    // For queed bulletin receive
    NSDateFormatter *bulletinDateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    
    [bulletinDateFormatter setTimeZone:timeZone];
    [bulletinDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [[NSUserDefaults standardUserDefaults]setObject:[bulletinDateFormatter stringFromDate:date] forKey:@"LastTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UILocalNotification *bulletin = [[UILocalNotification alloc] init];
    bulletin.alertBody = title;
    bulletin.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"bulletin" forKey:@"notificationName"];
    bulletin.userInfo = userInfo;
    [[UIApplication sharedApplication] presentLocalNotificationNow:bulletin];
    
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        [[[UIAlertView alloc]initWithTitle:@"Notification" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
    
}




- (void)addMessage:(NSString *)message {
    // Print the message when it comes in
    NSLog(@"%@",message);
}

- (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    return [self platformType:platform];
}

- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}


- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        [[StreamingConnection sharedConnection]stop];
    }
    else if (netStatus == ReachableViaWiFi)
    {
        //[[StreamingConnection sharedConnection]stop];
        [self establishWebSocketConnection];
    }
    else if (netStatus == ReachableViaWWAN)
    {
        //[[StreamingConnection sharedConnection]stop];
        [self establishWebSocketConnection];
        
    }
}



#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Shippax_Conf__17"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (NSString *) retrieveMessageId
{
    NSInteger idd = 0;
    NSString *messageId;
    NSManagedObjectContext *context = self.persistentContainer.viewContext;;//[self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:context];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    [fetchReq setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchReq error:&error];
    
    if(objects.count > 0)
    {
        for (NSManagedObject *info in objects)
        {
            NSInteger tempId = [[info valueForKey:@"messageId"] integerValue];
            
            if(tempId > idd)
                idd = tempId;
        }
        
        return [NSString stringWithFormat:@"%li",idd + 1];
    }
    else
    {
        return @"1";
    }
    
    return messageId;
}

- (void) saveMessageWithId:(NSString *) messageId title:(NSString *)messageTitle details:(NSString *)messageDetails imageUrl:(NSString *)imageUrlStr withUnixTime:(double )dateTime
{
    
    NSManagedObjectContext *context =  self.persistentContainer.viewContext;//[self managedObjectContext];
    NSManagedObject *newData;
    newData = [NSEntityDescription
               insertNewObjectForEntityForName:@"Inbox"
               inManagedObjectContext:context];
    [newData setValue: messageId forKey:@"messageId"];
    [newData setValue: [NSNumber numberWithBool:NO] forKey:@"status"]; //Status true means read, false means unread
    [newData setValue: messageTitle forKey:@"title"];
    [newData setValue: messageDetails forKey:@"details"];
    [newData setValue: imageUrlStr forKey:@"imageUrlStr"];
    
    if(dateTime > 0.0)
        [newData setValue:[NSNumber numberWithDouble:dateTime] forKey:@"time"];
    else
        [newData setValue:[NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]] forKey:@"time"];
    
    [self saveContext];
    
}

- (NSInteger) retrieveTotalUnreadMessage
{
    NSInteger totalCount = 0;
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:context];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
    [fetchReq setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchReq error:&error];
    
    for (NSManagedObject *info in objects)
    {
        if([[info valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithBool:NO]])
            totalCount = totalCount + 1;
        
    }
    return totalCount;
    
}

- (void) updateMessageStatusWithMessageId:(NSString *)messageId
{
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:context];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    [fetchReq setEntity:entityDes];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(messageId = %@)", messageId];
    [fetchReq setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchReq error:&error];
    
    for(NSManagedObject *info in objects)
    {
        if([messageId isEqualToString:[info valueForKey:@"messageId"]])
        {
            [info setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
        }
    }
    [self saveContext];
    
}

- (NSArray *) retrieveAllInboxMessages
{
    NSMutableArray *allMessagesArray = [NSMutableArray new];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:self.persistentContainer.viewContext];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    [fetchReq setEntity:entityDes];
    NSError *error;
    NSArray *objects = [self.persistentContainer.viewContext executeFetchRequest:fetchReq error:&error];
    
    for(NSManagedObject *info in objects)
    {
        MessageObject *message = [MessageObject new];
        message.messageId = [info valueForKey:@"messageId"];
        
        if([[info valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithBool:YES]])
            message.messageStatus = [NSNumber numberWithBool:YES];
        else
            message.messageStatus = [NSNumber numberWithBool:NO];
        
        message.messageTitle = [info valueForKey:@"title"];
        message.messageDetails = [info valueForKey:@"details"];
        message.time = [info valueForKey:@"time"];
        message.image = [info valueForKey:@"imageUrlStr"];
        [allMessagesArray addObject:message];
        
    }
    NSArray* reversedArray = [[allMessagesArray reverseObjectEnumerator] allObjects];
    return reversedArray;
    
}

- (BOOL) deleteMessageforMessageId: (NSString *) messageId
{
    BOOL status = NO;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Inbox" inManagedObjectContext:self.persistentContainer.viewContext];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    [fetchReq setEntity:entityDesc];
    
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(messageId = %@)", messageId];
    [fetchReq setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.persistentContainer.viewContext executeFetchRequest:fetchReq error:&error];
    for (NSManagedObject *info in objects)
    {
        
        if([[info valueForKey:@"messageId"] isEqualToString:messageId])
        {
            [self.persistentContainer.viewContext deleteObject:info];
            
            status = YES;
        }
    }
    [self saveContext];
    return status;
}


@end
