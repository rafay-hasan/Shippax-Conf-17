//
//  MSPlacemarkListViewController.m
//  MeridianSamples
//
//  Copyright © 2016 Aruba Networks. All rights reserved.
//

#import "MSPlacemarkListViewController.h"

@interface MSPlacemarkListViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) MREditorKey *appKey;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) MRPlacemarkRequest *request;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *placemarkTypes;
@property (nonatomic, strong) NSString *typeFilter;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation MSPlacemarkListViewController

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
    if ((self = [super initWithNibName:name bundle:bundle])) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
//        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonTapped)];
//        self.navigationItem.rightBarButtonItem = filterButton;
//        
//        self.placemarkTypes = @[@"all", @"generic", @"restroom", @"stairs", @"exit"];
//        self.typeFilter = self.placemarkTypes[0];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
   // self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];

    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = self.view.bounds;
    self.spinner.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.spinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.spinner];
    
    [self loadPlacemarks];
}

- (void)loadPlacemarks {
    
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.appKey = [MREditorKey keyWithIdentifier:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppId"]];
    self.results = [NSArray array];
    self.request = [MRPlacemarkRequest new];
    self.request.app = self.appKey;
    
    if ([self.placemarkTypes indexOfObject:self.typeFilter] > 0) {
        self.request.filter = [MRQueryFilter filterWithField:@"type" value:self.typeFilter];
    }
    
    [self.request startWithCompletionHandler:^(MRPlacemarkResponse *response, NSError *error) {
        [self placemarksLoadedWithResponse:response error:error];
    }];
}

- (void)placemarksLoadedWithResponse:(MRPlacemarkResponse *)response error:(NSError *)error {
    if (!error) {
        
        self.results = [self.results arrayByAddingObjectsFromArray:response.results];
        [self.tableView reloadData];
        
        if (response.nextPage) {
            [response.nextPage startWithCompletionHandler:^(MRPlacemarkResponse *nextResponse, NSError *nextError) {
                [self placemarksLoadedWithResponse:nextResponse error:nextError];
            }];
        } else {
            [self.spinner stopAnimating];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
    } else {
        NSLog(@"Error loading placemarks: %@", error.localizedDescription);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"MRPlacemarkListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    MRPlacemarkResult *result = self.results[indexPath.row];
    cell.textLabel.text = result.placemark.name.length ? result.placemark.name : result.placemark.typeName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MRPlacemarkResult *result = self.results[indexPath.row];
    MRMapViewController *controller = [[MRMapViewController alloc] initWithNibName:nil bundle:nil];
    controller.pendingDestination = result.placemark;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UIPickerViewDelegate / UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.placemarkTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.placemarkTypes[row];
}



#pragma mark - Action

- (void)filterButtonTapped {
    
    UIViewController *controller = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    controller.title = @"Placemark Type";
    controller.view.backgroundColor = [UIColor whiteColor];
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissFilters)];
    [controller.view addSubview:self.picker];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)dismissFilters {
    [self dismissViewControllerAnimated:YES completion:^{
        // reload placemarks if our filter changed
        NSUInteger selectedIndex = [self.picker selectedRowInComponent:0];
        NSString *selectedFilter = self.placemarkTypes[selectedIndex];
        if (![self.typeFilter isEqualToString:self.placemarkTypes[selectedIndex]]) {
            self.typeFilter = selectedFilter;
            [self loadPlacemarks];
        }
    }];
}

@end
