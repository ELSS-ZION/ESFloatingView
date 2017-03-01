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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"x"];
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
    self.tableView.ES_floatingView = [tableView cellForRowAtIndexPath:indexPath];
    [self.textField becomeFirstResponder];
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.ES_isFloating) {
        return;
    }
    
    [self.textField endEditing:YES];
}

@end
