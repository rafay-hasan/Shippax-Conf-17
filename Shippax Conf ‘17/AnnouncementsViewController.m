//
//  AnnouncementsViewController.m
//  Shippax Conf ‘17
//
//  Created by Rafay Hasan on 3/15/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "InboxTableViewCell.h"
#import "MessageObject.h"
#import "AppDelegate.h"
#import "InboxDetailsViewController.h"

@interface AnnouncementsViewController ()
{
    AppDelegate *appDelegate;
    NSDateFormatter *formatter;
}

@property (weak, nonatomic) IBOutlet UITableView *inboxTabkeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *messageEditButton;
- (IBAction)messageEditAction:(id)sender;

@property (strong,nonatomic) NSArray *allMessageArray;


@end

@implementation AnnouncementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.inboxTabkeView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.inboxTabkeView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.inboxTabkeView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.inboxTabkeView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.inboxTabkeView.allowsMultipleSelectionDuringEditing = NO;
    self.inboxTabkeView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.inboxTabkeView setEditing:NO];
    
    formatter= [[NSDateFormatter alloc] init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMessageReceived) name:@"InboxNotification" object:nil];
    
    self.inboxTabkeView.estimatedRowHeight = 65;
    self.inboxTabkeView.rowHeight = UITableViewAutomaticDimension;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadAllMessageContent];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *index = self.inboxTabkeView.indexPathForSelectedRow;
    InboxDetailsViewController *vc = segue.destinationViewController;
    vc.messageObject = [self.allMessageArray objectAtIndex:index.section];
}


- (void) newMessageReceived
{
    [self loadAllMessageContent];
}


- (void) loadAllMessageContent
{
    self.allMessageArray = [[NSArray alloc]initWithArray:[appDelegate retrieveAllInboxMessages]];
    NSLog(@"MessageArray is %@",self.allMessageArray);
    
    if(self.allMessageArray.count > 0)
    {
        self.messageEditButton.enabled = YES;
        self.messageEditButton.title = @"Edit";
    }
    else
    {
        self.messageEditButton.enabled = NO;
        self.messageEditButton.title = @"";
    }
    [self.inboxTabkeView reloadData];
}

#pragma mark Tableview delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if (self.allMessageArray.count > 0)
    {
        self.inboxTabkeView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections = [self.allMessageArray count];
        self.inboxTabkeView.backgroundView   = nil;
    }
    else
    {
        UILabel *noDataLabel    = [[UILabel alloc] initWithFrame:CGRectMake(self.inboxTabkeView.frame.origin.x, self.inboxTabkeView.frame.origin.y, self.inboxTabkeView.bounds.size.width, self.inboxTabkeView.bounds.size.height)];
        noDataLabel.text  = @"No announcement available";
        noDataLabel.textColor        = [UIColor whiteColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.inboxTabkeView.backgroundView = noDataLabel;
        self.inboxTabkeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxCell" forIndexPath:indexPath];
    
    MessageObject *object = [self.allMessageArray objectAtIndex:indexPath.section];
    cell.messageTitle.text = object.messageTitle;
    
    double unixTimeStamp = [object.time doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MMM d"];
    NSString *dateString = [formatter stringFromDate:date];
    cell.messageDate.text = dateString;
    cell.messageDetails.text = object.messageDetails;
    if([object.messageStatus isEqualToNumber:[NSNumber numberWithBool:YES]])
    {
        cell.messageStatus.hidden = YES;
    }
    else
    {
        cell.messageStatus.hidden = NO;
    }
    
    //cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3.00;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3.00;
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // row should be deleted
        
        MessageObject *object = [self.allMessageArray objectAtIndex:indexPath.section];
        
        if([appDelegate deleteMessageforMessageId:object.messageId])
        {
            self.allMessageArray = [[NSArray alloc]initWithArray:[appDelegate retrieveAllInboxMessages]];
            
            if(self.allMessageArray.count > 0)
            {
                self.messageEditButton.enabled = YES;
                self.messageEditButton.title = @"Done";
            }
            else
            {
                [self.inboxTabkeView setEditing:NO animated:YES];
                self.messageEditButton.enabled = NO;
                self.messageEditButton.title = @"";
            }
            
            [self.inboxTabkeView reloadData];
            
            NSInteger totalUnreadBulletin = [appDelegate retrieveTotalUnreadMessage];
            
            if(totalUnreadBulletin > 0)
            {
                [[[[[self tabBarController] tabBar] items]
                  objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)totalUnreadBulletin]];
            }
            else
            {
                [[[[[self tabBarController] tabBar] items]
                  objectAtIndex:2] setBadgeValue:nil];
            }
            
        }
        
    }
}


- (IBAction)messageEditAction:(id)sender {
    
    if(self.allMessageArray.count > 0)
    {
        if([self.messageEditButton.title isEqualToString:@"Edit"])
        {
            self.messageEditButton.title = @"Done";
            [self.inboxTabkeView setEditing:YES animated:YES];
        }
        else
        {
            self.messageEditButton.title = @"Edit";
            [self.inboxTabkeView setEditing:NO animated:YES];
        }
        
    }

}
@end
