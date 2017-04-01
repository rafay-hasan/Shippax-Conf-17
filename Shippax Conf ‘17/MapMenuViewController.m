//
//  MapMenuViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/30/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MapMenuViewController.h"
#import "MSNearbyViewController.h"
#import "MSPlacemarkListViewController.h"
@interface MapMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mapMenuTableView;

@end

@implementation MapMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark Tableview data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"moreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapMenu" forIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"Placemarks";
        cell.imageView.image = [[UIImage imageNamed:@"Placemark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Search nearby";
        cell.imageView.image = [[UIImage imageNamed:@"magnifying-glass"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];//[UIColor whiteColor];
    //cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        MSPlacemarkListViewController *vc = [MSPlacemarkListViewController new];
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 1)
    {
        MSNearbyViewController *vc = [MSNearbyViewController new];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.00;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.00;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}



@end
