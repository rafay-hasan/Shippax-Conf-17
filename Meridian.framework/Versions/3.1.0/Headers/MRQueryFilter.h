//
//  MRQueryFilter.h
//  Meridian
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a filter to be applied to a request for data from Meridian servers. Only
 * objects that match the specified criteria will be included in the results.
 */

@interface MRQueryFilter : NSObject

/// The field to filter against.
@property (nonatomic, copy, nonnull) NSString *field;

/// The value to filter for.
@property (nonatomic, copy, nonnull) NSString *value;

/**
 * Constructs a filter on the specified field with the value provided.
 *
 * @param field  The field to use when applying this filter.
 * @param value  The value to filter for.
 */
+ (MRQueryFilter * _Nonnull)filterWithField:(NSString * _Nonnull)field value:(NSString * _Nonnull)value;

@end
