//
//  Meridian.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//
//  By using the Meridian SDK, you hereby agree to the terms of the Meridian SDK
//  License at https://edit.meridianapps.com/users/sdk_tac
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Meridian/MRConfig.h>
#import <Meridian/MRLocation.h>
#import <Meridian/MRLocationManager.h>
#import <Meridian/MRCampaignManager.h>
#import <Meridian/MREditorKey.h>
#import <Meridian/MRMap.h>
#import <Meridian/MRMapView.h>
#import <Meridian/MRPlacemark.h>
#import <Meridian/MRPlacemarkRequest.h>
#import <Meridian/MRPlacemarkResult.h>
#import <Meridian/MRQueryFilter.h>
#import <Meridian/MRFriend.h>
#import <Meridian/MRSharingSession.h>
#import <Meridian/MRFriendAnnotationView.h>
#import <Meridian/MRInvite.h>
#import <Meridian/MRAssetBeacon.h>
#import <Meridian/MRAnnotation.h>
#import <Meridian/MRPointAnnotation.h>
#import <Meridian/MRUserLocation.h>
#import <Meridian/MRAnnotationView.h>
#import <Meridian/MRPlacemarkAnnotationView.h>
#import <Meridian/MRMapViewController.h>
#import <Meridian/MRDirections.h>
#import <Meridian/MRDirectionsTypes.h>
#import <Meridian/MRDirectionsRequest.h>
#import <Meridian/MRDirectionsResponse.h>
#import <Meridian/MRLocalSearch.h>
#import <Meridian/MRPathOverlay.h>
#import <Meridian/MRPathRenderer.h>
#import <Meridian/MeridianErrors.h>

// Version
#define MERIDIAN_VERSION @"3.1.0"

@interface Meridian : NSObject

/**
 *  You must call this once inside -application:didFinishLaunching. The passed MRConfig object
 *  will be cloned, so making changes to if after this call will have no effect. You can
 *  only call this method once for the lifetime of your application.
 */
+ (void)configure:(nonnull MRConfig *)config;

@end

extern CGFloat MRSnapToRouteDistance; // meters

/// Minimum RSSI value to trigger a campaign.
/// Set to `nil` to remove the minimum threshold.
extern NSNumber *_Nullable MRMinimumRSSIForCampaignTrigger;
