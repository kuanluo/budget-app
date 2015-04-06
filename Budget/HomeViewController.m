//
//  ViewController.m
//  Budget
//
//  Created by Christopher Constable on 3/11/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "HomeViewController.h"
#import "ExpenseManager.h"

@interface HomeViewController ()

@property (nonatomic, strong) UILabel *budgetLeftLabel;
@property (nonatomic, strong) UILabel *left;
@property (nonatomic, strong) UILabel *daysLeftLabel;
@property (nonatomic, strong) UILabel *daysToGo;

@property (nonatomic, strong) UIButton *addExpense;

@end

@implementation HomeViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //BUDGETLEFTLABEL
    self.budgetLeftLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0,40, self.view.bounds.size.width - 60, 100))];
    self.budgetLeftLabel.textColor = [UIColor whiteColor];
    self.budgetLeftLabel.text = [[ExpenseManager sharedManager] remainingBudgetString];
    self.budgetLeftLabel.textAlignment = NSTextAlignmentCenter;
    self.budgetLeftLabel.font = [UIFont fontWithName:@"Helvetica" size:80];
    self.budgetLeftLabel.adjustsFontSizeToFitWidth = YES;
    self.budgetLeftLabel.center = CGPointMake(self.view.center.x, self.budgetLeftLabel.center.y);
    [self.view addSubview:self.budgetLeftLabel];
    
    //LEFT
    self.left = [[UILabel alloc] initWithFrame:(CGRectMake(0,130, self.view.bounds.size.width, 60))];
    self.left.textColor = [UIColor whiteColor];
    self.left.textAlignment = NSTextAlignmentCenter;
    self.left.text = @"left";
    self.left.font = [UIFont fontWithName:@"Helvetica" size:40];
    [self.view addSubview:self.left];


    //DAYSLEFTLABEL
    self.daysLeftLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 180, self.view.bounds.size.width - 60, 100))];
    self.daysLeftLabel.textColor = [UIColor whiteColor];
    self.daysLeftLabel.text = @"30";
    self.daysLeftLabel.font = [UIFont fontWithName:@"Helvetica" size:80];
    self.budgetLeftLabel.adjustsFontSizeToFitWidth = YES;
    self.daysLeftLabel.textAlignment = NSTextAlignmentCenter;
    self.daysLeftLabel.center = CGPointMake(self.view.center.x, self.daysLeftLabel.center.y);
    [self.view addSubview:self.daysLeftLabel];
 
    //DAYSTOGO
    self.daysToGo = [[UILabel alloc] initWithFrame:(CGRectMake(0, 240, self.view.bounds.size.width, 100))];
    self.daysToGo.textColor = [UIColor whiteColor];
    self.daysToGo.text = @"days to go";
    self.daysToGo.font = [UIFont fontWithName:@"Helvetica" size:40];
    self.daysToGo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.daysToGo];
    
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
}

@end
