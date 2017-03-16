//
//  MRPlacemarkRequest.h
//  Meridian
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRPlacemarkResponse, MRQueryFilter;

/**
 * The block to use for processing the result of a placemark request. When results are paginated, you can
 * use the `nextPage` property of the response to start loading the next page of results.
 */
typedef void (^MRPlacemarkRequestCompletionHandler)(MRPlacemarkResponse * _Nullable response, NSError * _Nullable error);

/**
 * Allows the retrieval of placemark objects from Meridian servers.
 */
@interface MRPlacemarkRequest : NSObject

/// The Meridian app whose placemarks will be requested.
@property (nonatomic, copy, nonnull) MREditorKey *app;

/// If set, only the placemark with this identifier will be requested.
@property (nonatomic, copy, nullable) NSString *identifier;

/// If included, results will be restricted to the map indicated.
@property (nonatomic, strong, nullable) MREditorKey *mapKey;

/// A filter for this request. Only placemarks matching the specified field/value will be returned.
@property (nonatomic, strong, nullable) MRQueryFilter *filter;

/// Returns `YES ` if the request is currently being in progress.
@property (nonatomic, readonly) BOOL inProgress;

/**
 * Starts the asynchronous request.
 *
 * Any calls to `startWithCompletionHandler:` while `[MRPlacemarkRequest inProgress]` will fail.
 * The `completionHandler` block will be called on the main queue and takes two parameters:
 *
 *      - `response` contains the results of the request, or `nil` if an error occurred.
 *      - `error` contains the error information if one occured, or `nil` if the request was successful.
 *
 * @param completionHandler  A block to run when the request is complete.
 */
- (void)startWithCompletionHandler:(MRPlacemarkRequestCompletionHandler _Nullable)completionHandler;

/**
 * Cancels the request.
 */
- (void)cancel;

@end
