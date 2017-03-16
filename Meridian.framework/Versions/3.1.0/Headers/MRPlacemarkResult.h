//
//  MRPlacemarkResult.h
//  Meridian
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Wraps data about a placemark loaded from Meridian servers.
 */

@interface MRPlacemarkResult : NSObject

/// The placemark that this result represents.
@property (nonatomic, strong) MRPlacemark *placemark;

/// The distance to this result's `placemark` from the location that was used for the request.
@property (nonatomic, assign) CGFloat distance;

/// The estimated time to travel to this result's `placemark` from the location that was used for the request.
@property (nonatomic, assign) NSTimeInterval expectedTravelTime;

@end
