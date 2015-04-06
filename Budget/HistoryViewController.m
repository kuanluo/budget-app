//
//  HistoryViewController.m
//  Budget
//
//  Created by Kuan Luo on 3/11/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "HistoryViewController.h"
#import "ExpenseManager.h"
#import "UIColor+BudgetApp.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HistoryViewController

#pragma mark - View Lifecycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = 80;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];

    
}

#pragma mark - UITableViewDataSource


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
//    NSDictionary *obj;
//    NSArray *arr = [obj allValues]
    return [ExpenseManager sharedManager].expenses.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 0, 0)];
    dateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    NSDate *now = [NSDate date];
    dateLabel.text = [now timeAgo];
    dateLabel.textColor = [UIColor darkSpotColor];
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    UIView *headerview = [[UIView alloc] init];
    headerview.backgroundColor = [UIColor spotColor];
    [headerview addSubview:dateLabel];
    
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Step 1: Get the model.
    NSArray *expenses = [ExpenseManager sharedManager].expenses;
    Expense *expense = expenses[indexPath.row];
    
    // Step 2: Get a reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    // Step 3: Confifure the cell using the model.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor spotColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:expense.date];
    
    cell.textLabel.text = [NSString stringWithFormat:@"(%@) $%@ - %@", dateString, expense.cost, expense.reason];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.indentationLevel = 3;
    
    // Step 4: Return the cell to be displayed.
    return cell;
}


#pragma mark - UITableViewDelegate



@end
