//
//  MapViewController.m
//  Shippax Conf ‘17
//
//  Created by Rafay Hasan on 3/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MapViewController.h"
#import "ArubaViewController.h"
#import <Meridian/Meridian.h>
@interface MapViewController ()<MRMapViewDelegate>

@property (strong,nonatomic) MRMapView *mapView;
@property (strong,nonatomic) MRLocationManager *locationManager;
@property (nonatomic, strong) MRDirections *directions;

- (IBAction)mapRefreshAction:(id)sender;
- (IBAction)mapDirectionAction:(id)sender;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadMeridianMap];
    
    MRMapViewController *mapController = [MRMapViewController new];
    mapController.mapView.mapKey = [MREditorKey keyForMap:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"MapId"] app:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppId"]];
    self.view = self.mapView;
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

// And you may want to stop getting location updates here
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action

- (void)directionsAction {
    if (!self.mapView.route && self.mapView.selectedAnnotation)
    {
        MRDirectionsRequest *request = [[MRDirectionsRequest alloc] init];
        request.app = self.mapView.mapKey.parent;
        request.destination = [MRDirectionsDestination destinationWithPlacemarkKey:((MRPlacemark *)self.mapView.selectedAnnotation).key];
        request.source = [MRDirectionsSource sourceWithCurrentLocation];
        
        self.mapView.loading = NO;
        __weak typeof(self) weakSelf = self;
        self.directions = [[MRDirections alloc] initWithRequest:request presentingViewController:self];
        [self.directions calculateDirectionsWithCompletionHandler:^(MRDirectionsResponse *response, NSError *error)
         {
             [weakSelf directionsResponseDidLoad:response error:error];
         }];
    } else
    {
        self.mapView.loading = NO;
        [self.directions cancel];
        self.directions = nil;
        [self.mapView setRoute:nil animated:YES];
        self.mapView.showsUserLocation = YES;
    }
}

#pragma mark - Internal

- (void)directionsResponseDidLoad:(MRDirectionsResponse *)response error:(NSError *)error
{
    self.mapView.loading = NO;
    self.directions = nil;
    if (!error && response.routes.count > 0) {
        MRRoute *route = response.routes.firstObject;
        [self.mapView deselectAnnotationAnimated:NO];
        [self.mapView setRoute:route animated:YES];
        self.mapView.showsUserLocation = NO;
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Could not load directions" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) loadMeridianMap
{
    self.mapView = [[MRMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsUserHeading = YES;
    self.mapView.showsAccessibilityButton = YES;
    self.mapView.showsDirectionsControl = YES;
    self.mapView.showsMapPicker = YES;
    self.mapView.mapKey = [MREditorKey keyForMap:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"MapId"] app:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppId"]];
    self.view = self.mapView;
    
}

- (MRAnnotationView *)mapView:(MRMapView *)mapView viewForAnnotation:(id<MRAnnotation>)annotation {
    if ([annotation isKindOfClass:[MRPlacemark class]])
    {
        MRPlacemarkAnnotationView *defaultView = (MRPlacemarkAnnotationView *)[mapView defaultViewForAnnotation:annotation];
        
        defaultView.canTapCallout = YES;
        defaultView.canShowCallout = YES;
        return defaultView;
    }
    return nil;
}


- (IBAction)mapRefreshAction:(id)sender {
    
    [self loadMeridianMap];
}

- (IBAction)mapDirectionAction:(id)sender
{
    
    [self directionsAction];
}


//- (MRAnnotationView *)mapView:(MRMapView *)mapView viewForAnnotation:(id<MRAnnotation>)annotation
//{
//    
//    if ([annotation isKindOfClass:[MRPlacemark class]]) {
//        MRPlacemarkAnnotationView *defaultView = (MRPlacemarkAnnotationView *)[mapView defaultViewForAnnotation:annotation];
//        defaultView.canTapCallout = YES;
//        return defaultView;
//    }
//    return nil;
//}

- (void)mapView:(MRMapView *)mapView didTapCalloutForAnnotationView:(MRAnnotationView *)view {

    [self directionsAction];
}




@end
