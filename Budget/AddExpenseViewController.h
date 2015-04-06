//
//  AddExpenseViewController.h
//  Budget
//
//  Created by Kuan Luo on 3/19/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Expense.h"

@class AddExpenseViewController;

@protocol AddExpenseViewControllerDelegate

@required

- (void)addExpenseViewControllerDidCancel:(AddExpenseViewController *)expenseVC;
- (void)addExpenseViewController:(AddExpenseViewController *)expenseVC addedExpense:(Expense *)expense;

@end


@interface AddExpenseViewController : UIViewController

@property (nonatomic, weak) id <AddExpenseViewControllerDelegate> delegate;

@end

