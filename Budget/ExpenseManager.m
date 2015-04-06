//
//  ExpenseManager.m
//  Budget
//
//  Created by Kuan Luo on 3/27/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "ExpenseManager.h"

#define secondsInDay 86400

@interface ExpenseManager ()

// expensesDictionary[@"Just Now"] -> @[expense1, expense2, etc.];
// Each key represents a section.
// Each value represents the rows in that section.
@property (nonatomic, strong) NSMutableDictionary *mutableExpensesDictionary;

// @[@"Just Now", @"A moment ago...", @"Last Month", etc.]
@property (nonatomic, strong) NSMutableArray *expenseSectionNames;

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

- (NSArray *)sortedExpenses {
    if (!self.mutableExpensesDictionary) {
        self.mutableExpensesDictionary = [NSMutableDictionary dictionary];
    }
    
//    NSDate *today = [NSDate date];
    
    return nil;
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
    
    if (!self.mutableExpensesDictionary) {
        self.mutableExpensesDictionary = [NSMutableDictionary dictionary];
    }

    for (Expense *expense in self.expenses) {
        
        
        //        NSDate *expenseDate = expense.date;
        NSTimeInterval secondsSinceExpense = [expense.date timeIntervalSinceNow];
        NSUInteger numDays = secondsSinceExpense / secondsInDay;
        NSString *numDaysStr = [[NSString alloc]initWithFormat:@"%li", numDays];
        NSLog(@"numdays = %@", numDaysStr);
        NSLog(@"secondsSinceExpense = %f", secondsSinceExpense);
        
        if (![self.mutableExpensesDictionary valueForKey:numDaysStr]) {
            NSLog(@"if");
            NSDictionary *dayOfExpenses = [[NSDictionary alloc]initWithObjectsAndKeys:@[expense], numDaysStr, nil];
            [self.mutableExpensesDictionary addEntriesFromDictionary:dayOfExpenses];
        }
        
        else {
            NSLog(@"else");
            NSMutableArray *existingExpense = [self.mutableExpensesDictionary[numDaysStr] mutableCopy];
            [existingExpense addObject:expense];
            NSDictionary *dayOfExpenses = [[NSDictionary alloc]initWithObjectsAndKeys:existingExpense, numDaysStr, nil];
            [self.mutableExpensesDictionary removeObjectForKey:numDaysStr];
            [self.mutableExpensesDictionary addEntriesFromDictionary:dayOfExpenses];
        
        }
        NSLog(@"%@", self.mutableExpensesDictionary);
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

@end
