//
//  Expense.m
//  Budget
//
//  Created by Kuan Luo on 3/17/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "Expense.h"

@implementation Expense

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) { return nil; }
    
    _date = [aDecoder decodeObjectForKey:@"date"];
    _cost = [aDecoder decodeObjectForKey:@"cost"];
    _reason = [aDecoder decodeObjectForKey:@"reason"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.cost forKey:@"cost"];
    [aCoder encodeObject:self.reason forKey:@"reason"];
}

@end
