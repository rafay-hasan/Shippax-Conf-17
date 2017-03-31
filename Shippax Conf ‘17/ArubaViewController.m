//
//  ArubaViewController.m
//  Shippax Conf 
//
//  Created by Rafay Hasan on 3/31/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import "ArubaViewController.h"

@interface ArubaViewController ()

@end

@implementation ArubaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.mapKey = [MREditorKey keyForMap:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"MapId"] app:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppId"]];
//    self.view = self.mapView;
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

@end
