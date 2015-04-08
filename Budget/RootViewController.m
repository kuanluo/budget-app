//
//  RootViewController.m
//  Budget
//
//  Created by Christopher Constable on 3/11/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "AddExpenseViewController.h"
#import "UIColor+BudgetApp.h"
#import "Expense.h"

NS_ENUM(NSUInteger, ChildController) {
    ChildControllerHome,    // 0
    ChildControllerHistory  // 1
};

@interface RootViewController () <AddExpenseViewControllerDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

// Child View Controllers
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) HistoryViewController *historyViewController;

@end

@implementation RootViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor spotColor];
    [self setupViews];
    
    self.homeViewController = [[HomeViewController alloc] init];
    self.historyViewController = [[HistoryViewController alloc] init];

    [self.segmentedControl setSelectedSegmentIndex:ChildControllerHome];
    [self segmentedControlValueChanged:self.segmentedControl];
}

- (void)setupViews {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Home", @"History"]];
    self.segmentedControl.frame = CGRectMake(40, 40, self.view.bounds.size.width - 80, 38);
    
    [self.segmentedControl addTarget:self
                         action:@selector(segmentedControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
    //
    // Add expense button
    //
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 100,
                                                                        self.view.bounds.size.width - 40, 80)];
    
    [bottomButton setTitle:@"+ Add Expense"
                  forState:UIControlStateNormal];
    
    [bottomButton setTitleColor:[UIColor spotColor]
                       forState:UIControlStateNormal];
    
    bottomButton.backgroundColor = [UIColor whiteColor ];
    bottomButton.layer.cornerRadius = 8;
    [self.view addSubview:bottomButton];
    
    CGFloat contentViewYPos = self.segmentedControl.frame.origin.y + self.segmentedControl.frame.size.height + 20;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewYPos,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - contentViewYPos - bottomButton.bounds.size.height - 40)];
    [bottomButton addTarget:self
                     action:@selector(addExpenseButtonWasTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    self.contentView.clipsToBounds = YES;
    [self.view addSubview:self.contentView];
}

#pragma mark - Private 

- (void)showChildViewController:(enum ChildController)childController {
    UIViewController *oldViewController = nil;
    UIViewController *newViewController = nil;
    
    if (childController == ChildControllerHome) {
        newViewController = self.homeViewController;
        oldViewController = self.historyViewController;
    }
    else if (childController == ChildControllerHistory) {
        newViewController = self.historyViewController;
        oldViewController = self.homeViewController;
    }
 
    [self addChildViewController:newViewController];
    newViewController.view.alpha = 0.0;
    [self.contentView addSubview:newViewController.view];
    newViewController.view.frame = self.contentView.bounds; 
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         newViewController.view.alpha = 1.0;
                         oldViewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [newViewController didMoveToParentViewController:self];
                             [oldViewController willMoveToParentViewController:nil];
                             [oldViewController removeFromParentViewController];
                             [oldViewController.view removeFromSuperview];
                         }
                     }];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self showChildViewController:sender.selectedSegmentIndex];
}

#pragma mark - AddExpenseViewControllerDelegate

- (void)addExpenseViewControllerDidCancel:(AddExpenseViewController *)expenseVC {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)addExpenseViewController:(AddExpenseViewController *)expenseVC
                    addedExpense:(Expense *)expense {
    
    // Whenever an expense has been added, close the modal AddExpenseViewController.
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
//                                 [self.expenses addObject:expense];
                                 [self.historyViewController reloadData];
                                 
                                 // TODO: Re-enable this when addExpense is working.
                                 
//                                 // We need to give the table an array of all the new rows it needs
//                                 // to insert. Since we are asking for the "count" of our array, we
//                                 // need to subtract "1" to get the last row number since the rows
//                                 // start at "0" (e.g. if the count is "2" the rows are "0" and "1").
//                                 NSArray *newRows = @[[NSIndexPath indexPathForRow:self.expenses.count - 1 inSection:0]];
////
//                                 // Finally, we tell the tableView to insert those rows with
//                                 // an animation.
//                                 [self.historyViewController.tableView insertRowsAtIndexPaths:newRows
//                                                                             withRowAnimation:UITableViewRowAnimationAutomatic];
//                             }];
        }];
}

#pragma mark - Actions

- (void)addExpenseButtonWasTapped:(id)sender {
    
    // Create the AddExpenseViewController we are going to show and make
    // ourselves it's delegate. This way we receive the "...addedExpense" method
    // when the user enters an expense.
    AddExpenseViewController *addExpenseVC = [[AddExpenseViewController alloc] init];
    addExpenseVC.delegate = self;
    
    UINavigationController *topNavVC = [[UINavigationController alloc] initWithRootViewController:addExpenseVC];
    
    [self presentViewController:topNavVC
                       animated:YES
                     completion:nil];
    
}
    

@end
