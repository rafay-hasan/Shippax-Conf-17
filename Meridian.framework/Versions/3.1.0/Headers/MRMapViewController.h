//
//  MRMapViewController.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Meridian/MRMapView.h>
#import <Meridian/MREditorKey.h>


/**
 * A view controller implementing `MRMapViewDelegate` that handles all essential `MRMapView` tasks and events.
 */

@interface MRMapViewController : UIViewController <MRMapViewDelegate>

/// The map view this controller is responsible for.
@property (nonnull, nonatomic, strong) MRMapView *mapView;

/// If set, this controller will initiate directions to the specified destination as soon as the map view is displayed.
@property (nullable, nonatomic, strong) MRPlacemark *pendingDestination;

/**
 * Begins directions to the given Placemark from the user's current location.
 *
 * @param placemark  The destination for the route.
 */
- (void)startDirectionsToPlacemark:(MRPlacemark * _Nonnull)placemark;

/**
 * Begins directions to the given friend from the user's current location.
 *
 * @param friend_  The destination for the route.
 */
- (void)startDirectionsToFriend:(MRFriend * _Nonnull)friend_;

/**
 * Begins directions from one given Placemark to another.
 *
 * @param placemark  The destination for the route.
 * @param fromPlacemark  The starting point for the route.
 */
- (void)startDirectionsToPlacemark:(MRPlacemark * _Nonnull)placemark fromPlacemark:(MRPlacemark * _Nullable)fromPlacemark;

@end


/**
 * Convenience methods for presenting directions.
 */
@interface UIViewController (Directions)

/**
 * Presents directions modally.
 *
 * @param placemark  The destination for the route.
 */
- (void)presentDirectionsToPlacemark:(MRPlacemark * _Nonnull)placemark;
@end
