//
//  MRPlacemarkResponse.h
//  Meridian
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Contains the results of a placemark request.
 */

@interface MRPlacemarkResponse : NSObject

/// An array of `MRPlacemarkResult`. If distances are available, results are sorted by distance in ascending order.
/// Otherwise, results are sorted by placemark name.
@property (nonatomic, strong, nullable) NSArray<MRPlacemarkResult *> *results;

/// When results are paginated, this request can be used to load the next page of results. Will be `nil` if there
/// are no more results.
@property (nonatomic, readonly, nullable) MRPlacemarkRequest *nextPage;

@end
