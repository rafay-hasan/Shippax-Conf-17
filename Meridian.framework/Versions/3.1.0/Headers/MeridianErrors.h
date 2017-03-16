//
//  MeridianErrors.h
//  Meridian
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

/// NSError Domain for errors from Meridian
extern NSString *_Nonnull const MeridianErrorDomain;

// 0x4D52 is MR ascii converted to Hex

/// Enum of error codes used in the Meridian SDK
typedef NS_ENUM(NSInteger, MeridianErrorCode) {
    /// Usage description is missing from Info.plist
    MeridianErrorCodeMissingLocationDescription = 0x4D52,
    /// Background location has been denied
    MeridianErrorCodeBackgroundLocationDenied,
    /// Location request is missing from Info.plist
    MeridianErrorCodeLocationRequestMissing,
    /// Access to Location Services have been denied
    MeridianErrorCodeLocationDenied,
    /// Access to Location Services are restricted
    MeridianErrorCodeLocationRestricted,
    /// Error loading Map Placemarks
    MeridianErrorCodePlacemarkLoading,
    /// Multiple Monitoring Managers
    MeridianErrorCodeMultipleMonitoringManagers,
    /// Directions are currently calculating
    MeridianErrorCodeDirectionsCalculating,
    /// No source provided for directions request
    MeridianErrorCodeDirectionsNoSource,
    /// No prefix on location sharing request
    MeridianErrorCodeNoPrefixOnInvite,
    /// Request is already in progress
    MeridianErrorCodeRequestInProgress,
    /// No location providers available
    MeridianErrorCodeNoLocationProvidersAvailable,
    /// Location fetch timout
    MeridianErrorCodeLocationTimeout,
    /// Error loading the map surface
    MeridianErrorCodeMapSurfaceError,
    /// Error loading the map
    MeridianErrorCodeMapLoadError,
    /// Invalid map size provided
    MeridianErrorCodeMapSizeInvalid,
    /// Unable to determine current location
    MeridianErrorCodeUnableToDetermineLocation,
    /// No route found
    MeridianErrorCodeNoRouteFound,
    /// Bluetooth is currently powered off
    MeridianErrorCodeBluetoothTurnedOff,
    /// No token found for location sharing
    MeridianErrorCodeLocationSharingNoToken,
    /// Request operation was cancelled
    MeridianErrorCodeOperationCancelled,
    /// No friend location
    MeridianErrorCodeMissingFriendLocation,
};
