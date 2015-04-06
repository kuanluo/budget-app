//
//  ExpenseManager.h
//  Budget
//
//  Created by Kuan Luo on 3/27/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"

/**
 *  The ExpenseManager is a singleton.
 */
@interface ExpenseManager : NSObject

@property (nonatomic, readonly) double totalBudget;
@property (nonatomic, readonly) double amountSpent;
@property (nonatomic, readonly) double remainingBudget;

@property (nonatomic, copy, readonly) NSString *totalBudgetString;
@property (nonatomic, copy, readonly) NSString *amountSpentString;
@property (nonatomic, copy, readonly) NSString *remainingBudgetString;

@property (nonatomic, strong, readonly) NSArray *expenses;
@property (nonatomic, strong, readonly) NSArray *sortedExpenses;

+ (instancetype)sharedManager;

- (void)addExpense:(Expense *)expense;
- (void)loadExpenses;
- (void)saveExpenses;

@end
