//
//  MRMapView.h
//  Meridian
//
//  Copyright (c) 2016 Aruba Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Meridian/MRMap.h>
#import <Meridian/MRAnnotation.h>
#import <Meridian/MRAnnotationView.h>
#import <Meridian/MRPlacemark.h>
#import <Meridian/MRAssetBeacon.h>
#import <Meridian/MREditorKey.h>
#import <Meridian/MRUserLocation.h>
#import <Meridian/MRDirectionsResponse.h>
#import <Meridian/MRPathOverlay.h>
#import <Meridian/MRPathRenderer.h>

@protocol MRMapViewDelegate;

/**
 * Provides an embeddable map interface, with support for displaying placemarks and routes as well as navigating between maps.
 */

@interface MRMapView : UIView
NS_ASSUME_NONNULL_BEGIN

///--------------------------------------------
/// @name Creating and Configuring the map view
///--------------------------------------------

/// The key that identifies this view's map. Setting this property will cause the map view to load a new map.
@property (nonatomic, copy) MREditorKey *mapKey;

/// The map view's current map.
@property (nonatomic, readonly) MRMap *map;


/**
 * The delegate for this map view.
 *
 * You can set the map view's delegate property to get callbacks when various map events occur. You can also customize map
 * annotations by implementing `mapView:viewForAnnotation:`. The delegate should adopt the `MRMapViewDelegate` protocol.
 */
@property (nullable, nonatomic, weak) id<MRMapViewDelegate> delegate;

/**
 * Sets the loading state.
 *
 * @param loading  If `YES`, the map view will display a visual indication that content is loaded.
 */
- (void)setLoading:(BOOL)loading;

/**
 * If `YES` (the default), the map's placemarks will be displayed.
 *
 * Placemarks are displayed as map annotations, and are revealed and hidden as the user zooms in and out of the map.
 */
@property (nonatomic) BOOL showsPlacemarks;

/**
 * If `YES`, the map's assets will be displayed. The default is `NO`.
 *
 * Assets are displayed as map annotations, and are revealed and hidden as the user zooms in and out of the map.
 */
@property (nonatomic) BOOL showsAssets;

/**
 * If `YES` (the default), the map picker control will be displayed.
 *
 * The map picker control allows users to navigate to other maps.
 */
@property (nonatomic) BOOL showsMapPicker;

/**
 * If `YES`, the single-building level picker will be used in place of the map picker.
 *
 * The default map picker allows selecting any map at a Meridian location. You can use this property
 * to force the use of the level picker, which only allows selecting maps of other levels in the
 * current building.
 */
@property (nonatomic) BOOL usesLevelPicker;

/**
 * If `YES` (the default), the directions control will be displayed when a route is loaded.
 *
 * The directions control allows users to see information about a route and traverse its steps.
 */
@property (nonatomic) BOOL showsDirectionsControl;

/**
 * If `YES` (the default), the map label will be displayed.
 *
 * The map label indicates the map name and building name of the currently loaded map.
 */
@property (nonatomic) BOOL showsMapLabel;

/**
 * If `YES` (the default), the overview button will be displayed.
 *
 * The overview button allows users to navigate to the overview map, if one exists.
 */
@property (nonatomic) BOOL showsOverviewButton;

/**
 * If `YES` (the default), the location button will be displayed.
 *
 * The location button allows the user to navigate to their current location on the map. If their location is on a different map,
 * the map view will switch to the map that contains the user's location.
 */
@property (nonatomic) BOOL showsLocationButton;

/**
 * If `YES` (the default), the accessibility button will be visible when the map is displaying a route.
 *
 * The accessibility button allows the user to toggle a persistent preference to use either the shortest or the
 * most accessible routes. Toggling the preference will cause the map to reload the currently displayed route.
 */
@property (nonatomic) BOOL showsAccessibilityButton;

/**
 * If `YES`, the map will show the users's current location when available. The default is `NO`. This may trigger
 * a request for "when in use" location authorization, which requires certain entries in your app's Info.plist.
 */
@property (nonatomic) BOOL showsUserLocation;

/**
 * If `YES` (the default), the map will show the users's current heading when available.
 */
@property (nonatomic) BOOL showsUserHeading;

///-----------------------
/// @name User annotations
///-----------------------

// Annotations are models used to annotate coordinates on the map.
// Implement mapView:viewForAnnotation: on MRMapViewDelegate to return the annotation view for each annotation.

/// The map's annotations.
@property (nonnull, nonatomic, readonly) NSArray <id<MRAnnotation>> *annotations;

/// Placemark annotations (loaded automatically if showsPlacemark==YES).
@property (nonatomic, readonly, copy) NSArray <id<MRAnnotation>> *placemarks;

/// The annotation representing the user's location.
@property (nonatomic, readonly, strong) MRUserLocation *userLocation;

/// The currently selected annotation.
@property (nullable, nonatomic, readonly) id<MRAnnotation> selectedAnnotation;


/**
 * Adds an annotation to the map.
 *
 * @param annotation  The annotation to add.
 */
- (void)addAnnotation:(id<MRAnnotation>)annotation;

/**
 * Adds the provided annotations to the map.
 *
 * @param annotations  The annotations to add.
 */
- (void)addAnnotations:(NSArray <id<MRAnnotation>>*)annotations;

/**
 * Removes an annotation from the map.
 *
 * @param annotation  The annotation to remove.
 */
- (void)removeAnnotation:(id<MRAnnotation>)annotation;

/**
 * Removes the specified annotations from the map.
 *
 * @param annotations  The annotations to remove.
 */
- (void)removeAnnotations:(NSArray <id<MRAnnotation>>*)annotations;

/**
 * Causes the specified annotation to become selected.
 *
 * @param annotation  The annotation to select.
 * @param animated  If YES, the selection will be animated.
 */
- (void)selectAnnotation:(id<MRAnnotation>)annotation animated:(BOOL)animated;

/**
 * Deselects the currently selected annotation.
 *
 * @param animated  If YES, the deselection will be animated.
 */
- (void)deselectAnnotationAnimated:(BOOL)animated;

/**
 * Returns the view for the currently displayed annotation; returns nil if the view for the annotation isn't being displayed.
 *
 * @param annotation  The annotation to whose view should be returned.
 */
- (MRAnnotationView *)viewForAnnotation:(id<MRAnnotation>)annotation;

/**
 * Creates a new "default" annotation view for the given annotation.
 *
 * Uses the mapping:
 *
 * `MRPlacemark` -> `MRPlacemarkAnnotationView`<br>
 * `MRLocationController` -> `MRAnnotationView` (private subclass)
 *
 * The `dequeueReusableAnnotationViewWithIdentifier:` method will be used internally automatically.
 *
 * @param annotation  The annotation to create a view for.
 */
- (MRAnnotationView *)defaultViewForAnnotation:(id<MRAnnotation>)annotation;

/**
 * Returns a reusable annotation view located by its identifier.
 *
 * @param identifier  A string identifying the annotation view to be reused.
 */
- (MRAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;


///---------------------------------
/// @name Overlays
///---------------------------------

// Overlays are models used to draw shapes on the map.
// Implement mapView:viewForAnnotation: on MRMapViewDelegate to return the annotation view for each annotation.

/// The map's overlays.
- (NSArray <MRPathOverlay *> *)overlays;

/**
 * Adds an overlay to the map.
 *
 * @param overlay  The overlay to add.
 */
- (void)addOverlay:(MRPathOverlay *)overlay;

/**
 * Adds the provided overlays to the map.
 *
 * @param overlays  The overlays to add.
 */
- (void)addOverlays:(NSArray <MRPathOverlay *> *)overlays;

/**
 * Adds the provided overlay to the map.
 *
 * @param overlay   The overlay to add.
 * @param index     The z-index at which to display the overlay
 */
- (void)insertOverlay:(MRPathOverlay *)overlay atIndex:(NSInteger)index;

/**
 * Removes an overlay from the map.
 *
 * @param overlay  The overlay to remove.
 */
- (void)removeOverlay:(MRPathOverlay *)overlay;

/**
 * Removes the specified overlays from the map.
 *
 * @param overlays  The overlays to remove.
 */
- (void)removeOverlays:(NSArray <MRPathOverlay *> *)overlays;

/**
 * Returns the renderer for the currently displayed overlay; returns nil if the renderer for the overlay isn't being displayed.
 *
 * @param overlay  The overlay to whose renderer should be returned.
 */
- (MRPathRenderer *)rendererForOverlay:(MRPathOverlay *)overlay;

///---------------------------------
/// @name Converting Map Coordinates
///---------------------------------

/**
 * Converts a point from the coordinate space of the map to the coordinate space of the specified view.
 *
 * @param point  The point on this map to convert.
 * @param view  The view whose coordinate space the point should be converted to.
 */
- (CGPoint)convertMapPoint:(CGPoint)point toPointToView:(UIView * _Nullable)view;

/**
 * Converts a point from the coordinate space of the specified view to the coordinate space of this map.
 *
 * @param point  The point on this map to convert.
 * @param view  The view whose coordinate space the point should be converted from.
 */
- (CGPoint)convertPoint:(CGPoint)point toMapPointFromView:(UIView * _Nullable)view;

/**
 * Returns a rectangle centered on the specified point and sized according to the specified zoom level.
 *
 * @param center  The point at which to place the rectangle's center.
 * @param zoom  The zoom level to use when determining the rectangle's size.
 */
- (CGRect)rectWithCenter:(CGPoint)center zoomLevel:(MRZoomLevel)zoom;

///----------------------------------------------
/// @name Changing the Visible Portion of the Map
///----------------------------------------------

/// Describes the visible portion of the map. Changing this property will update the map view immediately.
@property(nonatomic) CGRect visibleMapRect;

/**
 * Updates the currently visible portion of the map, optionally animating the change.
 *
 * @param mapRect  The rectangle describing the part of the map that should be visible.
 * @param animated  If `YES`, the change will be animated. Otherwise the change will be instant.
 * @param completion  If animating, the block to call when animation completes.
 */
- (void)setVisibleMapRect:(CGRect)mapRect animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/// Returns the map's current angle of rotation, in radians.
@property (nonatomic, readonly) CGFloat rotationAngle;

/**
 * Updates the currently visible portion of the map, optionally animating the change.
 *
 * @param angle  The angle, in radians, the map's angle will become.
 * @param animated  If `YES`, the change will be animated. Otherwise the change will be instant.
 * @param completion  If animating, the block to call when animation completes.
 */
- (void)setRotationAngle:(CGFloat)angle animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 * Updates the currently visible portion of the map, optionally animating the change.
 *
 * @param visibleRect  The rectangle describing the part of the map that should be visible.
 * @param angle  The angle, in radians, the map's angle will become.
 * @param animated  If `YES`, the change will be animated. Otherwise the change will be instant.
 * @param completion  If animating, the block to call when animation completes.
 */
- (void)setVisibleMapRect:(CGRect)visibleRect rotationAngle:(CGFloat)angle animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

///-------------------------
/// @name Directions support
///-------------------------

/// The current route being displayed.
@property (nullable, nonatomic, strong) MRRoute *route;

/// The step index of the current route.
@property (nonatomic, assign) NSUInteger routeStepIndex;

/**
 * Sets the current route.
 *
 * @param route  The route to display.
 * @param animated  If YES, the transition to this route will be animated.
 */
- (void)setRoute:(MRRoute * _Nullable)route animated:(BOOL)animated;

/**
 * Sets the step index for the current route.
 *
 * @param index  The index of the desired step.
 * @param animated  If YES, the transition to the new step will be animated.
 */
- (void)setRouteStepIndex:(NSUInteger)index animated:(BOOL)animated;

/**
 * Zooms and pans the map so that the whole route for the current map can be seen.
 */
- (void)scrollToOverview;

/**
 * Shows or hides the directions control. Has no effect if `showsDirectionsControl` is set to `NO`.
 *
 * @param visible  Whether or not the directions control should be displayed.
 */
- (void)setDirectionsControlVisible:(BOOL)visible;

/// If `YES` (the default), the route path will be displayed.
@property (nonatomic) BOOL showsRoutePath;

extern NSString *const MRUseAccessiblePathsKey;

@end


/**
 * Delegate methods for `MRMapView`.
 */
@protocol MRMapViewDelegate <NSObject>
@optional

/**
 * Called when the map view is about to load a map.
 *
 * @param mapView  The map view that will start loading.
 */
- (void)mapViewWillStartLoadingMap:(MRMapView *)mapView;

/**
 * Called when the map view finishes loading a map.
 *
 * @param mapView  The map view that finished loading a map.
 */
- (void)mapViewDidFinishLoadingMap:(MRMapView *)mapView;

/**
 * Called when the map view fails to load a map.
 *
 * @param mapView  The map view that failed to load a map.
 * @param error  The error that was generated by the failure.
 */
- (void)mapViewDidFailLoadingMap:(MRMapView *)mapView withError:(NSError * _Nullable)error;

/**
 * Called when the "Use accessible paths" preference was changed.
 *
 * @param mapView  The map view that's reporting the change.
 */
- (void)mapViewDidChangeUseAccessiblePaths:(MRMapView *)mapView;

/**
 * Called when the map view's route changes. Routes may be recalculated to account for location changes.
 *
 * @param mapView  The map view whose route changed.
 * @param route  The new route.
 */
- (void)mapView:(MRMapView *)mapView routeDidChange:(MRRoute *)route;

/**
 * Called when the map view is about scroll to a new step index.
 *
 * @param mapView  The map view that's about to scroll.
 * @param index  The index of the step that will be scrolled to.
 */
- (void)mapView:(MRMapView *)mapView willScrollToStepAtIndex:(NSUInteger)index;

/**
 * Called when the map view is about change its visible rectangle for a route step. You can return a different
 * rectangle if you want to override the default behavior.
 *
 * @param mapView  The map view who's visible rectangle will change.
 * @param rect  The rectangle representing the portion of the map that will be visible.
 * @param step  The route step associated with this map animation.
 */
- (CGRect)mapView:(MRMapView *)mapView willScrollToRect:(CGRect)rect forRouteStep:(MRRouteStep *)step;

/**
 * Called whenever the map view changes either programatically (e.g. setVisibleMapRect:) or through user interaction.
 * Processing performed within this callback should be limited to maintain smooth scrolling.
 *
 * @param mapView   The map view that has finished scrolling.
 * @param animated  If YES, the scroll was animated.
 */
- (void)mapView:(MRMapView *)mapView visibleMapRectDidChange:(BOOL)animated;

/**
 * Provides a view for each annotation. This method may be called for all or some of the added annotations.
 *
 * For Meridian provided annotations (eg. `MRLocationController`, `MRPlacemarkAnnotationView`) return `nil` to use the Meridian-provided annotation view.
 * You may also create the Meridian-provided annotation view yourself by calling `-[MRMapView defaultViewForAnnotation:]`.
 *
 * @param mapView  The map view that's requesting a view.
 * @param annotation  The annotation that the returned view will represent.
 */
- (MRAnnotationView *)mapView:(MRMapView *)mapView viewForAnnotation:(id <MRAnnotation> _Nullable)annotation;

/**
 * Called when one or more annotation views were added to the map.
 *
 * If you want to manipulate visible annotation views, you can use this method to know when the views have been added to the map.
 *
 * @param mapView  The map view that added the annotation views.
 * @param views  An array of `MRAnnotationView` objects representing the views that were added.
 */
- (void)mapView:(MRMapView *)mapView didAddAnnotationViews:(NSArray <MRAnnotationView *> *)views;

/**
 * Provides a overlay renderer for each annotation. This method may be called for all or some of the added overlays.
 *
 * For Meridian provided annotations (eg. `MRLocationController`, `MRPlacemarkAnnotationView`) return `nil` to use the Meridian-provided annotation view.
 * You may also create the Meridian-provided annotation view yourself by calling `-[MRMapView defaultViewForAnnotation:]`.
 *
 * @param mapView  The map view that's requesting a view.
 * @param overlay  The overlay that the returned renderer will display.
 */
- (MRPathRenderer *)mapView:(MRMapView *)mapView rendererForOverlay:(MRPathOverlay *)overlay;

/**
 * Called when one or more overlay renderes were added to the map.
 *
 * If you want to manipulate visible overlay renderers, you can use this method to know when the renderers have been added to the map.
 *
 * @param mapView  The map view that added the annotation views.
 * @param renderers  An array of `MRPathRenderer` objects representing the renderers that were added.
 */
- (void)mapView:(MRMapView *)mapView didAddOverlayRenderers:(NSArray <MRPathRenderer *> *)renderers;

/**
 * Called when a map view finishes loading its placemarks.
 *
 * This method is called as soon as the placemarks are loaded but before they have been used to annotate the map.
 * If you need to change any properties of the placemarks that will affect their visibility on the map, such as
 * `minimumZoomLevel` or `hideOnMap`, this method is a good place to do that.
 *
 * @param mapView  The map view that loaded the placemarks.
 * @param placemarks  An array of `MRPlacemark` objects that were loaded for this map.
 */
- (void)mapView:(MRMapView *)mapView didLoadPlacemarks:(NSArray <MRPlacemark *> *)placemarks;

/**
 * Called when assets have loaded.
 *
 * @param mapView  The map view that loaded the assets.
 * @param assets  An array of `MRAssetBeacon` objects that were loaded for this map.
 */
- (void)mapView:(MRMapView *)mapView didLoadAssets:(NSArray <MRAssetBeacon *> *)assets;

/**
 * Called just before an annotation view becomes selected. You can return a different `MRAnnotationView` to select
 * or `nil` if you don't want the annotation view selected.
 *
 * @param mapView  The map view that's reporting the event.
 * @param view  The annotation view that's about to be selected.
 */
- (MRAnnotationView *)mapView:(MRMapView *)mapView willSelectAnnotationView:(MRAnnotationView *)view;

/**
 * Called when an annotation view becomes selected.
 *
 * @param mapView  The map view that's reporting the event.
 * @param view  The annotation view that was selected.
 */
- (void)mapView:(MRMapView *)mapView didSelectAnnotationView:(MRAnnotationView *)view;

/**
 * Called when an annotation view is deselected.
 *
 * @param mapView  The map view that's reporting the event.
 * @param view  The annotation view that was deselected.
 */
- (void)mapView:(MRMapView *)mapView didDeselectAnnotationView:(MRAnnotationView *)view;

/**
 * Called when an annotation callout is tapped.
 *
 * @param mapView  The map view that's reporting the event.
 * @param view  The annotation view whose callout was tapped.
 */
- (void)mapView:(MRMapView *)mapView didTapCalloutForAnnotationView:(MRAnnotationView *)view;

NS_ASSUME_NONNULL_END
@end
