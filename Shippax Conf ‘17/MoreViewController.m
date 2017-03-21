//
//  MoreViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/16/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "MoreViewController.h"
#import "SpeakersViewController.h"
#import "AboutViewController.h"
#import "ExhibitorsViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.mor.estimatedRowHeight = 50;
    //self.homeTableView.rowHeight = UITableViewAutomaticDimension;

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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"moreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"Speakers";
        cell.imageView.image = [[UIImage imageNamed:@"SelectedSpeakerIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Exhibitors";
        cell.imageView.image = [[UIImage imageNamed:@"SelectedExibitorIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"Coupons & Offers";
        cell.imageView.image = [[UIImage imageNamed:@"selectedAboutIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else if (indexPath.section == 3)
    {
        cell.textLabel.text = @"About";
        cell.imageView.image = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.4];//[UIColor whiteColor];
   // cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        SpeakersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Speakers"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 1)
    {
        ExhibitorsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"exhibitor"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 3)
    {
        AboutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if(indexPath.section == 2)
//    {
//        AboutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    //    else if(indexPath.section == 3)
    //    {
    //        AboutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"arubaMap"];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
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
