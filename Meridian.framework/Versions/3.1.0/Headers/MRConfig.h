//
//  MRConfig.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Constants for setting logging verbosity.
 */

typedef NS_ENUM(NSUInteger, MRLogLevel) {
    /// Will not log at all
    MRLogLevelOff,
    /// Error Level - Something went very wrong
    MRLogLevelError,
    /// Warning Level - Not fatal but we need to know
    MRLogLevelWarn,
    /// Info Level - Nice to know. For checkpoints
    MRLogLevelInfo,
    /// Debug Level - for fixing potential issues
    MRLogLevelDebug,
    /// Verbose Level - Lots and lots of info going to come out here
    MRLogLevelVerbose,
    /// Info Level - Nice to know
    MRLogLevelNormal = MRLogLevelInfo, //DEPRECATED_MSG_ATTRIBUTE("Please use MRLogLevelInfo instead") = MRLogLevelInfo,
};

/**
 *  Holds Meridian configuration data for your application.
 */

@interface MRConfig : NSObject <NSCopying>
NS_ASSUME_NONNULL_BEGIN

/**
 *  Prefix to the correct location of the Meridian Editor.
 *  This should only be used for internal debugging or as directed by a Meridian engineer.
 */
@property (nonatomic, copy) NSString *editorURL;

/**
 *  Google Analytics tracking code to use for sending events and page views.
 */
@property (nonatomic, copy) NSString *googleAnalyticsTrackingCode;

/**
 *  Flag to override the server specified cache timeout.
 */
@property (nonatomic, assign) BOOL cacheOverrideEnabled;

/**
 *  Duration in milliseconds to hold on to cached requests when overriding the server defaults
 */
@property (nonatomic, assign) long cacheOverrideTimeout;

/**
 *  Flag to enable using simulated location on devices. Defaults to NO.
 */
@property (nonatomic, assign) BOOL useSimulatedLocation;

/**
 *  When using system-provided services for outdoor location, readings will only be considered valid 
 *  with an accuracy of at least this value in meters. Defaults to 5.
 */
@property (nonatomic, assign) CGFloat outdoorLocationAccuracyThreshold;

/**
 *  Distance in meters a user's location must diverge from the route before the route can be recalculated. 
 *  Valid range is 5 - 30 meters. Default value is 10.
 */
@property (nonatomic, assign) CGFloat rerouteDistance;

/**
 *  Time in seconds that a user's location must remain in divergence from the route before the route can be
 *  recalculated. Valid range is 5 - 15 seconds. Default value is 10.
 */
@property (nonatomic, assign) NSTimeInterval rerouteDelay;

/**
 *  Logging level. Defaults to MRLogLevelNormal
 */
@property (nonatomic, assign) MRLogLevel logLevel;

/**
 *  Application Token. Can be generated at edit.meridianapps.com > `your location` > Permissions > Application Token.
 */
@property (nonatomic, strong) NSString *applicationToken;

NS_ASSUME_NONNULL_END
@end
