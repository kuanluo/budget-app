//
//  Expense.h
//  Budget
//
//  Created by Kuan Luo on 3/17/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject <NSCoding>

@property (nonatomic, copy) NSString *cost;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSDate *date;


@end
