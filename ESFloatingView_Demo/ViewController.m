//
//  ViewController.m
//  ESFloatView_Demo
//
//  Created by ELSS on 2017/3/1.
//  Copyright © 2017年 ELSS. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+ESFloatingView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    
    
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"x"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"x"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.textField isFirstResponder]) {
        [self.textField endEditing:YES];
        return;
    }
    
    self.tableView.ES_floatingView = [tableView cellForRowAtIndexPath:indexPath];
    [self.textField becomeFirstResponder];
    return;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField endEditing:YES];
}

@end
