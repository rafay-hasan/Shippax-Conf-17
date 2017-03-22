//
//  ProgrammeViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ProgrammeViewController.h"
#import "ProgrammeTableViewCell.h"

@interface ProgrammeViewController ()

@property (strong,nonatomic) NSDictionary *programmeDic;
@property (strong,nonatomic) NSMutableArray *aprilFifthProgrammeArray,*aprilSixthProgramneArraym,*aprilSeventhProgrammeArray,*programmeNameArray;

@property (weak, nonatomic) IBOutlet UITableView *programmeTableView;

@end

@implementation ProgrammeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *pathOfPlist = [[NSBundle mainBundle] pathForResource:@"Programme" ofType:@"plist"];
    self.programmeDic = [[NSDictionary alloc]initWithContentsOfFile:pathOfPlist];
    
    NSLog(@"dic is %@",self.programmeDic);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.programmeTableView.estimatedRowHeight = 50;
    self.programmeTableView.rowHeight = UITableViewAutomaticDimension;
    [self loadData];
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

-(void) loadData
{
    self.aprilFifthProgrammeArray = [NSMutableArray new];
    self.programmeNameArray = [NSMutableArray new];
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Check-in opens in the terminal at Civitavecchia"]];
    [self.programmeNameArray addObject:@"Check-in opens in the terminal at Civitavecchia"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Embarkation & check-in to cabins"]];
    [self.programmeNameArray addObject:@"Embarkation & check-in to cabins"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Welcome coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Welcome coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Conference begins at the Theatre, deck 8"]];
    [self.programmeNameArray addObject:@"Conference begins at the Theatre, deck 8"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Where are we now as an industry?"]];
    [self.programmeNameArray addObject:@"Where are we now as an industry?"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Panel debate with ferry top executives"]];
    [self.programmeNameArray addObject:@"Panel debate with ferry top executives"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Lunch in Self Service Restaurant, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Lunch in Self Service Restaurant, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Alternative fuels and energy systems"]];
    [self.programmeNameArray addObject:@"Alternative fuels and energy systems"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Economic and industry/market trends"]];
    [self.programmeNameArray addObject:@"Economic and industry/market trends"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Possible solutions for the industry"]];
    [self.programmeNameArray addObject:@"Possible solutions for the industry"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Fast Ferries; past, present and future"]];
    [self.programmeNameArray addObject:@"Fast Ferries; past, present and future"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"The ro-ro and freight development"]];
    [self.programmeNameArray addObject:@"The ro-ro and freight development"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Shippax Awards 2017"]];
    [self.programmeNameArray addObject:@"Shippax Awards 2017"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Happy Hour in the exhibition area, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Happy Hour in the exhibition area, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Welcome drink at the Veranda Bar, deck 9, sponsored by Brax Shipping, networking"]];
    [self.programmeNameArray addObject:@"Welcome drink at the Veranda Bar, deck 9, sponsored by Brax Shipping, networking"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Departure Civitavecchia"]];
    [self.programmeNameArray addObject:@"Departure Civitavecchia"];
    
    [self.aprilFifthProgrammeArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Night cap, sponsored by Port of Ystad, networking"]];
    [self.programmeNameArray addObject:@"Night cap, sponsored by Port of Ystad, networking"];
    
    
    [self.programmeTableView reloadData];

}


#pragma mark Tableview data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aprilFifthProgrammeArray.count;//[[self.programmeDic valueForKey:@"Wednesday, April 5"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"programmeCell";
    ProgrammeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.programmeNameLabel.text = [self.programmeNameArray objectAtIndex:indexPath.row];
    cell.localTimeLabel.text = [[self.aprilFifthProgrammeArray objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.subProgrammeNameLabel.text = [[self.aprilFifthProgrammeArray objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.speakersNameLabel.text = [[self.aprilFifthProgrammeArray objectAtIndex:indexPath.row] objectAtIndex:2];

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
