//
//  NearbyViewController.m
//  MeridianSamples
//
//  Copyright (c) 2014 Aruba Networks. All rights reserved.
//

#import "MSNearbyViewController.h"

@interface MSNearbyViewController ()
@property (nonatomic, copy) MREditorKey *appKey;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MRLocalSearch *search;
@property (nonatomic, strong) NSTimer *autoUpdateTimer;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) MRLocationManager *locationManager;
@end

@implementation MSNearbyViewController

- (instancetype)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];

    self.appKey = [MREditorKey keyWithIdentifier:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppId"]];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(updateNearby) forControlEvents:UIControlEventValueChanged];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
    

    
    // create our location manager
    self.locationManager = [[MRLocationManager alloc] initWithApp:self.appKey];
    self.locationManager.delegate = self;
}

#pragma mark - MSExampleViewController

//+ (NSString *)exampleTitle {
//    return @"Local Search";
//}
//
//+ (NSString *)exampleInfo {
//    return @"Example of how to use the MRLocalSearch API to search for Placemarks based on the current location and display the results.";
//}

#pragma mark - Nearby

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start listening for location updates
    [self.locationManager startUpdatingLocation];
    [self updateNearby];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)updateNearby {
    
    // a valid location is required for local search
    if (!self.locationManager.location) {
        [self.refreshControl endRefreshing];
        return;
    }
    
    // kill the auto-update timer if it was running
    [self.autoUpdateTimer invalidate];
    self.autoUpdateTimer = nil;
    
    [self.refreshControl beginRefreshing];
    
    // configure a local search with our current location and a search term if appropriate
    MRLocalSearchRequest *request = [MRLocalSearchRequest new];
    request.app = self.appKey;
    request.location = self.locationManager.location;
    request.transportType = MRDirectionsTransportTypeWalking;
    
    if (self.searchBar.text.length)
        request.naturalLanguageQuery = self.searchBar.text;
    
    self.search = [[MRLocalSearch alloc] initWithRequest:request];
    [self.search startWithCompletionHandler:^(MRPlacemarkResponse *response, NSError *error) {
        if (response) {
            self.searchResults = response.results;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else if (error) {
            NSLog(@"Error loading search results: %@", error.localizedDescription);
        }
    }];
}

- (void)cancelTapped {
    self.searchBar.text = nil;
    [self updateNearby];
    [self.searchBar resignFirstResponder];
}

- (void)locationManager:(MRLocationManager *)manager didUpdateToLocation:(MRLocation *)location {
    if (self.searchResults.count == 0 && !self.search.isSearching)
        [self updateNearby];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    [self.navigationItem setRightBarButtonItem:cancelItem animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self updateNearby];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    if (self.autoUpdateTimer) {
        [self.autoUpdateTimer invalidate];
        self.autoUpdateTimer = nil;
    }
    
    // automatically update search results 1 second after you finish typing, even if you didn't hit the Search button
    self.autoUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNearby) userInfo:nil repeats:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"MRNearbyPlacemarkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    MRPlacemarkResult *result = self.searchResults[indexPath.row];
    cell.textLabel.text = result.placemark.name.length ? result.placemark.name : result.placemark.typeName;
    if (result.expectedTravelTime)
        cell.detailTextLabel.text = [self timeStringForInterval:result.expectedTravelTime];
    else
        cell.detailTextLabel.text = @"";

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MRPlacemarkResult *result = self.searchResults[indexPath.row];
    [self presentDirectionsToPlacemark:result.placemark];
}

- (NSString *)timeStringForInterval:(NSTimeInterval)interval {
    if (interval >= 60) {
        return [NSString stringWithFormat:@"%0.0f min", interval / 60];
    } else {
        return [NSString stringWithFormat:@"%0.0f sec", interval];
    }
}

@end
