//
//  ViewController.m
//  ZYNetworking
//
//  Created by evan on 2020/1/10.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ViewController.h"
#import "reformerTest.h"
#import "ZYServiceProtocol.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Class targetClass = NSClassFromString(@"reformerTest");
//    id <CTAPIManagerDataReformer> reformer = [[targetClass alloc] init];
//    [reformer manager:@"测试" reformData:@"真的行吗"];
//    NSLog(@"dfsdfsfs");
    // Do any additional setup after loading the view.
}


@end
