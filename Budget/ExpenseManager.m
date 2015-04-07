//
//  ExpenseManager.m
//  Budget
//
//  Created by Kuan Luo on 3/27/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "ExpenseManager.h"
#import "NSDate+TimeAgo.h"

#define secondsInDay 86400

@interface ExpenseManager ()

@property (nonatomic, strong) NSMutableDictionary *mutableGroupedExpenses;
@property (nonatomic, strong) NSMutableArray *mutableDateNames;
@property (nonatomic, strong) NSMutableArray *mutableExpenses;


@end

@implementation ExpenseManager

+ (instancetype)sharedManager {
    // static means "remember this variable instead
    // of recreating it on future calls."
    static ExpenseManager *sharedManager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ExpenseManager alloc] init];
        [sharedManager loadExpenses];
    });
    
    return sharedManager;
}

#pragma mark - Accessors

- (double)totalBudget {
    return 3000.0;
}

- (double)amountSpent {
    double amountSpent = 0.0;
    for (Expense *expense in self.mutableExpenses) {
        amountSpent += [expense.cost doubleValue];
    }
    
    return amountSpent;
}

- (double)remainingBudget {
    return self.totalBudget - self.amountSpent;
}

- (NSString *)totalBudgetString {
    return [NSString stringWithFormat:@"$%0.2f", self.totalBudget];
}

- (NSString *)amountSpentString {
    return [NSString stringWithFormat:@"$%0.2f", self.amountSpent];
}

- (NSString *)remainingBudgetString {
    return [NSString stringWithFormat:@"$%0.2f", self.remainingBudget];
}

- (NSArray *)expenses {
    return [self.mutableExpenses copy];
}

- (NSDictionary *)groupedExpenses {
    return [self.mutableGroupedExpenses copy];
}

- (NSArray *)dateNames {
    return [self.mutableDateNames copy];
}

#pragma mark - Public

- (void)addExpense:(Expense *)expense {
    [self.mutableExpenses insertObject:expense atIndex:0];
}

- (void)loadExpenses {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"expenses.data"];
    
    self.mutableExpenses = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (!self.mutableExpenses) {
        self.mutableExpenses = [NSMutableArray array];
    }
}

- (void)saveExpenses {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"expenses.data"];
    
    // Archive the array of expenses.
    [NSKeyedArchiver archiveRootObject:self.mutableExpenses
                                toFile:filePath];
    
    // Done :)
    NSLog(@"%d expenses saved.", (int)self.mutableExpenses.count);
}

- (void)groupExpenses {
    // Stores all unique date names
    self.mutableDateNames = [NSMutableArray array];
    // Stores all expenses grouped by date name
    self.mutableGroupedExpenses = [NSMutableDictionary dictionary];
    
    // Sort expenses by most recent
    NSArray *sortedExpenses = [self.mutableExpenses sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    // Enumerate through sorted expenses
    [sortedExpenses enumerateObjectsUsingBlock:^(Expense *expense, NSUInteger idx, BOOL *stop) {
        // Determine the date string
        NSString *dateStr = [expense.date timeAgo];
        // Expenses already grouped by date name
        NSMutableArray *expenses = [self.mutableGroupedExpenses valueForKey:dateStr];
        // If none exist add the first one
        if (!expenses) {
            expenses = [NSMutableArray arrayWithObject:expense];
            // Add the date name
            // NOTE: These are added in order since expenses are already sorted
            [self.mutableDateNames addObject:dateStr];
        } else {
            // Add new expense to existing group
            [expenses addObject:expense];
        }
        // Finally update the group of expenses associated with the date name
        [self.mutableGroupedExpenses setValue:expenses forKey:dateStr];
    }];
}

@end
