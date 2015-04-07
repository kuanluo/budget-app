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

// Called immediately before the user sees this screen
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    // Group expenses
    [[ExpenseManager sharedManager] groupExpenses];
    
    // Reload the table view
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ExpenseManager sharedManager].dateNames.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *dateStr = [ExpenseManager sharedManager].dateNames[section];
    NSMutableArray *expenses = [[ExpenseManager sharedManager].groupedExpenses valueForKey:dateStr];
    return expenses.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *dateStr = [ExpenseManager sharedManager].dateNames[section];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 0, 0)];
    dateLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    dateLabel.text = dateStr;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Step 1: Get the model.
    NSString *dateStr = [ExpenseManager sharedManager].dateNames[indexPath.section];
    NSMutableArray *expenses = [[ExpenseManager sharedManager].groupedExpenses valueForKey:dateStr];
    Expense *expense = expenses[indexPath.row];
    
    // Step 2: Get a reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    // Step 3: Confifure the cell using the model.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor spotColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"$%@ - %@", expense.cost, expense.reason];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.indentationLevel = 3;
    
    // Step 4: Return the cell to be displayed.
    return cell;
}


#pragma mark - UITableViewDelegate



@end
