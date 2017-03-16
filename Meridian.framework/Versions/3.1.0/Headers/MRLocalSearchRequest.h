//
//  MRLocalSearchRequest.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Meridian/MRLocation.h>
#import <Meridian/MREditorKey.h>

/**
 * Describes a search to be performed on Meridian servers.
 */

@interface MRLocalSearchRequest : NSObject
NS_ASSUME_NONNULL_BEGIN

/// The search term to use when filtering results.
@property (nonatomic, copy, nullable) NSString *naturalLanguageQuery;

/// The location to use when filtering results.
@property (nonatomic, strong) MRLocation *location;

/// The mode of transport if directions were calculated for a result of this search. Used for including distance in results.
@property (nonatomic, assign) MRDirectionsTransportType transportType;

/// The Meridian app whose data should be searched.
@property (nonatomic, copy) MREditorKey *app;

NS_ASSUME_NONNULL_END
@end
