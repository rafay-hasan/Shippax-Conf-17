//
//  MRCampaignManager.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Meridian/MREditorKey.h>

/**
 * Use this block to process the result of a cooldown reset request.
 */
typedef void (^MRCampaignResetHandler)(NSError  * _Nullable error);

@protocol MRCampaignManagerDelegate;

/**
 *  Monitors all of the proximity beacons for a Meridian app identified with `MREditorKey`.
 *  Use of this class prompts end users to opt in to use Location Services.
 *
 *  You must set the message at the opt-in prompt.
 *  To do this, in __Info.plist__, use the `NSLocationAlwaysUsageDescription` key to set the "purpose string".
 *
 *  Use `[CLLocationManager locationServicesEnabled]` and related properties to check whether
 *  the end user has opted in to Location Services.
 */
@interface MRCampaignManager : NSObject

NS_ASSUME_NONNULL_BEGIN
/**
 * A delegate object to handle campaign events.
 * Campaign events are triggered when a device enters or exits a proximity beacon's range.
 */
@property (nullable, nonatomic, weak) id<MRCampaignManagerDelegate> delegate;

/**
 * Initializes a `MRCampaignManager` object with the `MREditorKey` Meridian app identifier.
 *
 * @param appKey  A key representing a Meridian app.
 */
- (instancetype)initWithApp:(MREditorKey *)appKey;

/**
 * Start monitoring regions defined by proximity beacons. Monitoring continues until `stopMonitoring` is called,
 * even if your application is running in the background or terminated. Entry and exit events will trigger any
 * associated campaigns.
 */
- (void)startMonitoring;

/**
 * Stop monitoring proximity beacon regions.
 */
- (void)stopMonitoring;

@property (nonatomic, readonly) BOOL monitoring;

/**
 * The Meridian Editor protects against campaign notifications being triggered repeatedly by
 * establishing a cooldown period for each campaign.
 * For testing purposes, use this method to manually reset the cooldown period.
 *
 * @param campaignId         The campaign to reset
 * @param completionHandler  The completion handler to call when the reset request is complete.
 */
- (void)resetCampaign:(NSString *)campaignId withCompletionHandler:(MRCampaignResetHandler _Nullable)completionHandler;

/**
 * The Meridian Editor protects against campaign notifications being triggered repeatedly by
 * establishing a cooldown period for each campaign.
 * For testing purposes, use this method to manually reset the cooldown period.
 *
 * @param completionHandler  The completion handler to call when the reset request is complete.
 */
- (void)resetAllCampaignsWithCompletionHandler:(MRCampaignResetHandler _Nullable)completionHandler;

@end


/**
 *  Delegate methods for `MRCampaignManager`.
 */
@protocol MRCampaignManagerDelegate <NSObject>

@optional

/**
 * Invoked when a campaign is triggered and a user notification will be generated.
 *
 * @param manager  The campaign manager object that will generate the notification.
 * @param campaignInfo  A dictionary containing the details of the notification that will be sent.
 * Possible keys include: `title`, `message`, and `path`.
 *
 * @returns Should return `YES` if a notification should be generated and `NO` if not.
 */
- (BOOL)campaignManager:(MRCampaignManager *)manager shouldGenerateNotificationForCampaign:(NSDictionary *)campaignInfo;

/**
 * Asks the delegate for data to include when triggering a campaign.
 *
 * When a campaign is triggered, the campaign manager will call this method before sending the request.
 * If you return a dictionary of parameters to include in the request, they will be forwarded to any
 * third-party URL associated with the campaign.
 * All parameter keys and values must be `NSString` instances.
 *
 * @param manager  The campaign manager asking for the data.
 * @param campaignIdentifier  A string identifying the triggered campaign.
 *
 * @returns A dictionary of values to send to the third-party URL.
 */
- (NSDictionary *)campaignManager:(MRCampaignManager *)manager userInfoForCampaign:(NSString *)campaignIdentifier;

/**
 * Asks the delegate for data to include when registering a device.
 *
 * If you registered your app with Apple's push notification service with `setPushToken:`,
 * `MRCampaignManager` can register the device's push token with the Meridian server.
 * If you return a dictionary of parameters to include in the request, they will be forwarded to any
 * third-party URL associated with the campaign triggered on the server.
 *
 * @param manager  The campaign manager asking for the data.
 *
 * @returns A dictionary of values to send to the third-party URL. They must be JSON-encodable.
 */
- (NSDictionary *)campaignManagerDeviceUserInfo:(MRCampaignManager *)manager;

/**
 * Invoked when a campaign manager encounters an error.
 *
 * @param manager  The campaign manager instance that's reporting an error.
 * @param error  The error being reported.
 */
- (void)campaignManager:(MRCampaignManager *)manager didFailWithError:(NSError *)error;

NS_ASSUME_NONNULL_END
@end
