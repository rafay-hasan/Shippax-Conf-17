//
//  MRAnnotation.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Meridian/MRLocation.h>
#import <Meridian/MRMap.h>

/**
 * The basic MRAnnotation class; defines a location in space and a title/subtitle for the selection UI.
 */

@protocol MRAnnotation <NSObject>

/// Center x and y of the annotation view.
/// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CGPoint point;

@optional

/// Title for use by selection UI.
@property (nullable, nonatomic, readonly, copy) NSString *title;

/// Subtitle for use by selection UI.
@property (nullable, nonatomic, readonly, copy) NSString *subtitle;

/// Gets the minimum zoom level (inclusive) at which this annotation should be displayed.
/// If not implemented, the annotation will be displayed at every zoom level.
/// Return MRZoomLevelWorld to always display when map is zoomed all the way out
@property (nonatomic, readonly) MRZoomLevel minimumZoomLevel;

/// Gets the maximum zoom level (inclusive) at which this annotation should be displayed.
/// If not implemented, the annotation will be displayed at every zoom level.
/// Return MRZoomLevelAtom to always display when map is zoomed all the way in
@property (nonatomic, readonly) MRZoomLevel maximumZoomLevel;

// This property changes the the front-to-back ordering of annotations onscreen.
@property (nonatomic, readonly) CGFloat zPosition;

// Sets whether the annotation collides with other annotations. Default is NO if unimplemented.
@property (nonatomic, readonly) BOOL collides;

/**
 * Deprecated. Use zPosition and collides instead.
 *
 * Implement to support collision detection between annotations when displayed on a map.
 * This method should return NSOrderedAscending if the receiver has "less priority" than
 * the given annotation, NSOrderedDescending if the receiver has "more priority", and
 * NSOrderedSame if the receiver and the annotation are of equal priority. More priority
 * means that given the choice of displaying one of two annotations occupying similar
 * space on the map, the higher priority annotation will be displayed.
 *
 * @param annotation  The annotation with which to compare display priority.
 */
- (NSComparisonResult)compareDisplayPriority:(id<MRAnnotation> _Nonnull)annotation __deprecated;

@end

/// The default zPosition of placemarks will fall between MRZPositionPlacemarkMin and MRZPositionPlacemarkMax.
/// To bring a placemark to the top, a possible implementation is `placemark.zPosition = MRZPositionPlacemarkMax + 1;`.
static const CGFloat MRZPositionPlacemarkMin = -200;
static const CGFloat MRZPositionPlacemarkMax = -100;

/// The default zPosition of the blue dot.
static const CGFloat MRZPositionBlueDot = 100;
