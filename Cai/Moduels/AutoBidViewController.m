//
//  AutoBidViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/5/7.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AutoBidViewController.h"
#import "CailaiAPIClient.h"
@interface AutoBidViewController ()

@end

@implementation AutoBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)openAutoBid:(id)sender {
     NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"autotenderplan.open",@"sname",@"1000.00",@"amount",nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getDataWithBlock:^(id response, NSError *error) {
            
            
        } withParam:param];

    });
    }

- (IBAction)closeAutoBid:(id)sender {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"autotenderplan.close",@"sname",@"1000.00",@"amount",nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getDataWithBlock:^(id response, NSError *error) {
            
            
        } withParam:param];
    });
    
}

- (IBAction)checkAutoBid:(id)sender {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"autotenderplan.view",@"sname",nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getDataWithBlock:^(id response, NSError *error) {
            
            
        } withParam:param];
    });
    

}
- (NSURLSessionDataTask *)getDataWithBlock:(void (^)(id response, NSError *error))block withParam:(NSDictionary *)param{
    
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSString *responseString =  [JSON objectForKey:@"data"];
        
        if (block) {
            block(responseString,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];
    
}

@end
