//
//  MRPlacemark.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Meridian/MRPointAnnotation.h>

/**
 * Represents a Placemark, possibly created by the Meridian Editor.
 */

@interface MRPlacemark : MRPointAnnotation
NS_ASSUME_NONNULL_BEGIN

/// Uniquely identifies this placemark. The parent of this key should identify the map containing this placemark.
@property (nonatomic, copy) MREditorKey *key;

/// If not nil, indicates this placemark leads to another map.
@property (nonatomic, copy) MREditorKey *relatedMapKey;

/// The name given to this placemark.
@property (nullable, nonatomic, copy) NSString *name;

/// The placemark's type, such as "cafe" or "water_fountain".
@property (nullable, nonatomic, copy) NSString *type;

/// A form of the placemark's type intended for display to users, such as "Cafe" or "Water Fountain".
@property (nullable, nonatomic, copy) NSString *typeName;

/// The color to use when drawing this placemark's map annotation. You can set this to override the default color.
@property (nullable, nonatomic, strong) UIColor *color;

/// This placemark's coordinates relative to its parent map.
@property (nonatomic, assign) CGPoint point;

/// If YES, this placemark will not be shown on its map.
@property (nonatomic, assign) BOOL hideOnMap;

/// An image representing this placemark.
@property (nullable, nonatomic, strong) NSURL *imageURL;

/// A path describing the placemark's area, if one was defined.
@property (nonatomic, strong) UIBezierPath *area;

/// This property changes the the front-to-back ordering of annotations onscreen. Default will be some value between MRZPositionPlacemarkMin and MRZPositionPlacemarkMax
@property (nonatomic, assign) CGFloat zPosition;

// If YES this annotation collides with other annotations. Default is YES.
@property (nonatomic, assign) BOOL collides;


/**
 * Programmatically create an MRPlacemark that may not exist in the Meridian Editor, but can be used for other APIs like directions.
 *
 * @param mapKey  The map that this placemark belongs to.
 * @param point  The coordinates of this placemark.
 */
- (instancetype)initWithMap:(MREditorKey *)mapKey point:(CGPoint)point;


/**
 * Deprecated. Use MRPlacemarkRequest instead.
 *
 * Creates and runs an operation to fetch all placemarks for the specified map.
 *
 * @param mapKey  The map to fetch placemarks for.
 * @param success  A block to execute if the operation succeeds. The block has no return value and takes one argument: the array of placemarks returned by the request.
 * @param failure  A block to execute if the operation fails. The block has no return value and takes one argument: the error describing what went wrong.
 */
+ (NSOperation *)getAllPlacemarksForMap:(MREditorKey *)mapKey success:(void(^ _Nullable)(NSArray <MRPlacemark *> *placemarks))success failure:(void(^ _Nullable)(NSError *error))failure __deprecated;

NS_ASSUME_NONNULL_END
@end
