//
//  MRAssetBeacon.h
//  Meridian
//
//  Created by Daniel Miedema on 9/15/16.
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRAssetBeacon : NSObject <MRAnnotation>

/// Name of this asset
@property (nonatomic, nullable, readonly) NSString *name;

/// Image representing this asset
@property (nonatomic, nullable, readonly) NSURL *imageURL;

/// Asset's MAC address
@property (nonatomic, nonnull, readonly) NSString *mac;

/// Asset's Location
@property (nonatomic, nullable, readonly) MRLocation *location;

@end
