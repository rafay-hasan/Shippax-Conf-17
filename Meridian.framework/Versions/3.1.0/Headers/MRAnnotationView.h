//
//  MRAnnotationView.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Meridian/MRAnnotation.h>


/**
 * A view for visually representing a corresponding `MRAnnotation` instance on a map view.
 */
@interface MRAnnotationView : UIView
NS_ASSUME_NONNULL_BEGIN

/// A string that identifies this annotation view as reusable. (read-only)
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

/// The annotation model object that this view represents.
@property (nonatomic, strong) id <MRAnnotation> annotation;

/// The offset at which to display the view.
/// By default, the center of the annotation view is placed over the point of the annotation.
/// `centerOffset` is the offset in screen points from the center of the annotation view.
@property (nonatomic) CGPoint centerOffset;

/// The offset at which to anchor the annotation callout.
/// `calloutOffset` is the offset in screen points from the top-middle of the annotation view where the anchor of the callout should be shown.
@property (nonatomic) CGPoint calloutOffset;

/// If `YES`, a standard callout bubble will be shown when the annotation is selected.
/// The annotation must have a title for the callout to be shown.
/// The default is `NO`.
@property (nonatomic) BOOL canShowCallout;

/// If `YES`, the callout will respond to taps and its containing `MRMapView` will send `mapView:didTapCalloutForAnnotationView:`
/// to its delegate. The default is `NO`.
@property (nonatomic) BOOL canTapCallout;

/// The left accessory view to be used in the standard callout.
@property (nullable, strong, nonatomic) UIView *leftCalloutAccessoryView;

/// The right accessory view to be used in the standard callout.
@property (nullable, strong, nonatomic) UIView *rightCalloutAccessoryView;

/// A view to use as the content of the callout instead of the standard layout.
@property (nullable, strong, nonatomic) UIView *calloutContentView;

/// A margin value to use for `calloutContentView`. If `calloutContentView` isn't set, this value will be ignored. The default is `12`.
@property (nonatomic) CGFloat calloutContentMargin;

/// The default is `NO`. Becomes `YES` when tapped/clicked in the map view.
@property (nonatomic, readonly, getter=isSelected) BOOL selected;


/**
 * Initializes a new annotation view. Use the same `reuseIdentifier` for annotations that share the same kind of view, so that those
 * views can be recycled.
 *
 * @param annotation  The annotation to associate with this view.
 * @param reuseIdentifier  A string to classify this view for recycling purposes.
 */
- (instancetype)initWithAnnotation:(id <MRAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Sets the selected state for this annotation view, optionally animating the change.
 *
 * @param selected  `YES` if the annotation view should be selected.
 * @param animated  `YES` if the change in selected state should be animated.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

NS_ASSUME_NONNULL_END
@end
