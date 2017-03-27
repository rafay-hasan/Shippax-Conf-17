//
//  ProgrammeViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/22/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ProgrammeViewController.h"
#import "ProgrammeTableViewCell.h"
#import "ProgrammeHeaderView.h"

@interface ProgrammeViewController ()

@property (strong,nonatomic) NSDictionary *programmeDic;
@property (strong,nonatomic) NSMutableArray *programmeDetailsArray,*programmeNameArray;


- (IBAction)segmentButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *aprilFifthhButton;
@property (weak, nonatomic) IBOutlet UIButton *aprilSixthButton;
@property (weak, nonatomic) IBOutlet UIButton *aprilSeventhButton;

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
    
//    UINib *headerNib = [UINib nibWithNibName:@"ProgrammeHeaderView" bundle:nil];
//    [self.programmeTableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"header"];
//    self.programmeTableView.estimatedSectionHeaderHeight = 110.0;
//    self.programmeTableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    
    [self loadAprilFifthData];
}

- (void)didReceiveMemoryWarning
{
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

-(void) loadAprilFifthData
{
    self.programmeDetailsArray = [NSMutableArray new];
    self.programmeNameArray = [NSMutableArray new];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Check-in opens in the terminal at Civitavecchia"]];
    [self.programmeNameArray addObject:@"Check-in opens in the terminal at Civitavecchia"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Embarkation & check-in to cabins"]];
    [self.programmeNameArray addObject:@"Embarkation & check-in to cabins"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Welcome coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Welcome coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Conference begins at the Theatre, deck 8"]];
    [self.programmeNameArray addObject:@"Conference begins at the Theatre, deck 8"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Where are we now as an industry?"]];
    [self.programmeNameArray addObject:@"Where are we now as an industry?"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Panel debate with ferry top executives"]];
    [self.programmeNameArray addObject:@"Panel debate with ferry top executives"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Lunch in Self Service Restaurant, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Lunch in Self Service Restaurant, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Alternative fuels and energy systems"]];
    [self.programmeNameArray addObject:@"Alternative fuels and energy systems"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Economic and industry/market trends"]];
    [self.programmeNameArray addObject:@"Economic and industry/market trends"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Possible solutions for the industry"]];
    [self.programmeNameArray addObject:@"Possible solutions for the industry"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Fast Ferries; past, present and future"]];
    [self.programmeNameArray addObject:@"Fast Ferries; past, present and future"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"The ro-ro and freight development"]];
    [self.programmeNameArray addObject:@"The ro-ro and freight development"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Shippax Awards 2017"]];
    [self.programmeNameArray addObject:@"Shippax Awards 2017"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Happy Hour in the exhibition area, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Happy Hour in the exhibition area, deck 7, sponsored by ABB Marine & Ports, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Welcome drink at the Veranda Bar, deck 9, sponsored by Brax Shipping, networking"]];
    [self.programmeNameArray addObject:@"Welcome drink at the Veranda Bar, deck 9, sponsored by Brax Shipping, networking"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Departure Civitavecchia"]];
    [self.programmeNameArray addObject:@"Departure Civitavecchia"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Dinner in the à la Carte Restaurant, deck 7, sponsored by DNV GL"]];
    [self.programmeNameArray addObject:@"Dinner in the à la Carte Restaurant, deck 7, sponsored by DNV GL"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Wednesday, April 5"] valueForKey:@"Night cap, sponsored by Port of Ystad, networking"]];
    [self.programmeNameArray addObject:@"Night cap, sponsored by Port of Ystad, networking"];
    

    [self.programmeTableView reloadData];
    [self.programmeTableView setContentOffset:CGPointZero animated:YES];


}

-(void) loadAprilSixthData
{
    self.programmeDetailsArray = [NSMutableArray new];
    self.programmeNameArray = [NSMutableArray new];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Breakfast in the Self Service Restaurant, deck 7, sponsored by Versonix"]];
    [self.programmeNameArray addObject:@"Breakfast in the Self Service Restaurant, deck 7, sponsored by Versonix"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Arrival Palermo"]];
    [self.programmeNameArray addObject:@"Arrival Palermo"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"BOLT Ferry Think Tank. How will we look 2025?"]];
    [self.programmeNameArray addObject:@"BOLT Ferry Think Tank. How will we look 2025?"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Getting the extra passengers to go by ferry?"]];
    [self.programmeNameArray addObject:@"Getting the extra passengers to go by ferry?"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Possible solutions for the industry"]];
    [self.programmeNameArray addObject:@"Possible solutions for the industry"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Lunch in Self Service Restaurant, deck 7, sponsored by Midas, networking & visit exhibitors "]];
    [self.programmeNameArray addObject:@"Lunch in Self Service Restaurant, deck 7, sponsored by Midas, networking & visit exhibitors "];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Optional visit in Palermo"]];
    [self.programmeNameArray addObject:@"Optional visit in Palermo"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Brexit and the ferry industry"]];
    [self.programmeNameArray addObject:@"Brexit and the ferry industry"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors  "]];
    [self.programmeNameArray addObject:@"Coffee in the exhibition area, deck 7, sponsored by Stena RoRo, networking & visit exhibitors  "];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"New ships concept and projects"]];
    [self.programmeNameArray addObject:@"New ships concept and projects"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Interferry"]];
    [self.programmeNameArray addObject:@"Interferry"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"How to attract those over 50?"]];
    [self.programmeNameArray addObject:@"How to attract those over 50?"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Words of farewell"]];
    [self.programmeNameArray addObject:@"Words of farewell"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Happy Hour in the exhibition area, deck 7, sponsored by Wärtsilä, networking & visit exhibitors"]];
    [self.programmeNameArray addObject:@"Happy Hour in the exhibition area, deck 7, sponsored by Wärtsilä, networking & visit exhibitors"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Dinner drink, sponsored by RINA, at the Veranda Bar, deck 9, networking"]];
    [self.programmeNameArray addObject:@"Dinner drink, sponsored by RINA, at the Veranda Bar, deck 9, networking"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Departure Palermo"]];
    [self.programmeNameArray addObject:@"Departure Palermo"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Farewell dinner in the à la Carte Restaurant, deck 7, sponsored by GNV"]];
    [self.programmeNameArray addObject:@"Farewell dinner in the à la Carte Restaurant, deck 7, sponsored by GNV"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Thursday, April 6"] valueForKey:@"Night cap, sponsored by Onorato Armatori, networking"]];
    [self.programmeNameArray addObject:@"Night cap, sponsored by Onorato Armatori, networking"];

    
    [self.programmeTableView reloadData];
     [self.programmeTableView setContentOffset:CGPointZero animated:YES];
    
}


-(void) loadAprilSeventhhData
{
    self.programmeDetailsArray = [NSMutableArray new];
    self.programmeNameArray = [NSMutableArray new];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Friday, April 7"] valueForKey:@"Breakfast in the Self Service Restaurant, deck 7, sponsored by Versonix"]];
    [self.programmeNameArray addObject:@"Breakfast in the Self Service Restaurant, deck 7, sponsored by Versonix"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Friday, April 7"] valueForKey:@"Arrival in Civitavecchia"]];
    [self.programmeNameArray addObject:@"Arrival in Civitavecchia"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Friday, April 7"] valueForKey:@"Disembarkation"]];
    [self.programmeNameArray addObject:@"Disembarkation"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Friday, April 7"] valueForKey:@"Buses to the airport"]];
    [self.programmeNameArray addObject:@"Buses to the airport"];
    
    [self.programmeDetailsArray addObject:[[self.programmeDic valueForKey:@"Friday, April 7"] valueForKey:@"LA SUPERBA departure"]];
    [self.programmeNameArray addObject:@"LA SUPERBA departure"];
    
    

    [self.programmeTableView reloadData];
     [self.programmeTableView setContentOffset:CGPointZero animated:YES];
    
}




#pragma mark Tableview data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.programmeDetailsArray.count;//[[self.programmeDic valueForKey:@"Wednesday, April 5"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"programmeCell";
    ProgrammeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.programmeNameLabel.text = [self.programmeNameArray objectAtIndex:indexPath.row];
    
    if([[self.programmeNameArray objectAtIndex:indexPath.row] length] > 0)
    {
        cell.programmeNameLabel.textInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    }
    else
    {
        cell.programmeNameLabel.textInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }

    
    NSString *subProgramme = [[self.programmeDetailsArray objectAtIndex:indexPath.row] objectAtIndex:1];
    subProgramme = [subProgramme stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    if(subProgramme.length > 0)
    {
        cell.subProgrammeNameLabel.textInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    }
    else
    {
        cell.subProgrammeNameLabel.textInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    
    NSString *speakers = [[self.programmeDetailsArray objectAtIndex:indexPath.row] objectAtIndex:2];
    speakers = [speakers stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    if(speakers.length > 0)
    {
        cell.speakersNameLabel.textInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    }
    else
    {
        cell.speakersNameLabel.textInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }

    
    cell.localTimeLabel.text = [[self.programmeDetailsArray objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.subProgrammeNameLabel.text = subProgramme;
    cell.speakersNameLabel.text =  speakers;

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.00;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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



- (IBAction)segmentButtonAction:(UIButton *)sender
{
    if(sender.tag == 1000)
    {
        self.aprilFifthhButton.backgroundColor = [UIColor colorWithRed:0.00 green:0.57 blue:0.99 alpha:1.0];
        self.aprilSixthButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        self.aprilSeventhButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        
        [self loadAprilFifthData];
    }
    else if (sender.tag == 2000)
    {
        self.aprilFifthhButton.backgroundColor =[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        self.aprilSixthButton.backgroundColor = [UIColor colorWithRed:0.00 green:0.57 blue:0.99 alpha:1.0];
        self.aprilSeventhButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        
        [self loadAprilSixthData];

    }
    else if (sender.tag == 3000)
    {
        self.aprilFifthhButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        self.aprilSixthButton.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6];
        self.aprilSeventhButton.backgroundColor =[UIColor colorWithRed:0.00 green:0.57 blue:0.99 alpha:1.0];
        
        [self loadAprilSeventhhData];

    }
    
}
@end
