//
//  StreamingConnection.h
//  SignalR.Client.ObjC Example
//
//  Created by Alex Billingsley on 3/1/16.
//
//

#import "SignalR.h"

#ifdef DEBUG
static NSString * const SRConnectionBaseURL = @"http://shippax-wp.mcp.com:82";
#else
static NSString * const SRConnectionBaseURL = @"http://shippax-wp.mcp.com:82";
#endif

@interface StreamingConnection : SRHubConnection

@property (strong, nonatomic, readwrite) SRHubProxy * hub;

+ (instancetype)sharedConnection;

@end
