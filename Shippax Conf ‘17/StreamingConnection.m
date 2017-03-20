//
//  StreamingConnection.m
//  SignalR.Client.ObjC Example
//
//  Created by Alex Billingsley on 3/1/16.
//
//

#import "StreamingConnection.h"
#import "AppDelegate.h"

@interface StreamingConnection ()

@end

@implementation StreamingConnection

+ (instancetype)sharedConnection {
    static StreamingConnection *_sharedConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnection = [[StreamingConnection alloc] initWithURLString:[NSString stringWithFormat:@"%@/signalr",SRConnectionBaseURL]];
    });
    
    return _sharedConnection;
}

- (instancetype)initWithURLString:(NSString *)url {
    self = [super initWithURLString:url];
    if (!self) {
        return nil;
    }
    
    self.hub = [self createHubProxy:@"mcp"];
    return self;
}

@end
