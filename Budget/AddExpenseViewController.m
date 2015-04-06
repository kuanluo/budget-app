//
//  AddExpenseViewController.m
//  Budget
//
//  Created by Kuan Luo on 3/19/15.
//  Copyright (c) 2015 Etsy. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "ExpenseManager.h"

#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@interface AddExpenseViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *addCostTextField;
@property (nonatomic, strong) UITextField *addReasonTextField;

@end

@implementation AddExpenseViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Add Expense";
    
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, 140, self.view.bounds.size.width-40, 1)];
    horizontalLine.backgroundColor = [UIColor grayColor];

    [self.view addSubview:horizontalLine];
    [self setupViews];
}

- (void)setupViews {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(cancelButtonWasTapped:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(doneButtonWasTapped:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //
    // Add Cost Button
    //
    
    self.addCostTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width - 40, 60)];
    self.addCostTextField.keyboardType = UIKeyboardTypeNumberPad;
    //self.addCostTextField.borderStyle = 1.0;
    self.addCostTextField.placeholder = @"$0.00";
    
    
    // Add an action so we can hook into when the addCostTextField changes.
    // We want to make sure the dollar sign stays in front of the cost.
    [self.addCostTextField addTarget:self
                              action:@selector(addCostTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    
    // Unfortunately, the "UIKeyboardTypeNumberPad" keyboard doesn't have a "return" button on it.
    // We can add our own "Next" button above the keyboard like this:
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(nextButtonWasTapped:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    // This pushes the nextButton to the right.
    toolbar.items = @[flexibleSpace, nextButton];
    
    // This causes the toolbar to appear above the keyboard ("input").
    self.addCostTextField.inputAccessoryView = toolbar;
    
    //
    // Add Reason Button
    //
    
    self.addReasonTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, self.view.bounds.size.width - 40, 60)];
    //self.addReasonTextField.borderStyle = 1.0;
    self.addReasonTextField.placeholder = @"groceries";
    self.addReasonTextField.delegate = self;
    
    
    [self.view addSubview:self.addCostTextField];
    [self.view addSubview:self.addReasonTextField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // When this screen loads, give focus to the addCostTextField.
    [self.addCostTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // This gets called when the user presses the return button on the keyboard.
    // What this delegate method is actually asking is "should I allow the user to enter
    // a newline?". We will almost always return "NO".
    
    // If we are on the "addReasonTextField" and the user presses enter, we can
    // assume they want to create the new expense. We'll just simulate the "done"
    // button being pressed.
    if (textField == self.addReasonTextField) {
        [self doneButtonWasTapped:self];
    }
    
    return NO;
}

#pragma mark - Actions

- (void)addCostTextFieldDidChange:(id)sender {
    // First, strip out any characters that are illegal (somebody could paste some
    // weird text in here).
    NSCharacterSet *legalCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *illegalCharacters = [legalCharacters invertedSet];
    
    // There is no way to "remove illegal characters" so we have to get clever... Instead
    // of "removing" them we can tell the string to break itself into components using these
    // illegal characters as markers.
    NSArray *validComponents = [self.addCostTextField.text componentsSeparatedByCharactersInSet:illegalCharacters];
    NSString *sanitizedString = [validComponents componentsJoinedByString:@""];
    
    // Now we need to make sure the user doesn't enter something like "10.231".
    // Let's cap the decimal place to 2 places. The logic below reads like this:
    //
    // "If the decimal location is found and it's farther than two spaces away
    // from the end of the string, get rid of stuff at the end of the string until
    // the decimal is only 2 places away."
    NSUInteger decimalLocation = [sanitizedString rangeOfString:@"."].location;
    if (decimalLocation != NSNotFound &&
        decimalLocation < (sanitizedString.length - 3)) {
        NSRange rangeToDelete = NSMakeRange(decimalLocation + 3,
                                            sanitizedString.length - (decimalLocation + 3));
        sanitizedString = [sanitizedString stringByReplacingCharactersInRange:rangeToDelete
                                                                   withString:@""];
    }
    
    // Add the dollar sign back in.
    sanitizedString = [@"$" stringByAppendingString:sanitizedString];
    
    // Set the "sanitized" string back to the text field.
    self.addCostTextField.text = sanitizedString;
}

- (void)nextButtonWasTapped:(id)sender {
    
    // If the "next" button was tapped, move down to the "reason" field.
    [self.addReasonTextField becomeFirstResponder];
    
}

- (void)cancelButtonWasTapped:(id)sender {
    
    // Let the delegate know the user wants to cancel. This is a typical
    // pattern because the delegate is then allowed to decide whether or not
    // we should cancel. For instance, it might not make sense for the user
    // to cancel right now and the method below could return "NO" in which case
    // we would display a message to the user telling them to finish what they
    // are doing.

    [self.delegate addExpenseViewControllerDidCancel:self];
}

- (void)doneButtonWasTapped:(id)sender {

    // Create a new expense
    Expense *newExpense = [[Expense alloc] init];
    newExpense.date = [NSDate date];

    
    
    // Remove the $ sign
    NSString *costString = [self.addCostTextField.text stringByReplacingOccurrencesOfString:@"$"
                                                                       withString:@""];
    newExpense.cost = costString;
    newExpense.reason = self.addReasonTextField.text;
    
    [[ExpenseManager sharedManager] addExpense:newExpense];
    [[ExpenseManager sharedManager] saveExpenses];

    
    // Let the delegate know that a new expense was created.
    // It's the delegate's job to dismiss the controller if it
    // thinks our job is done.
    [self.delegate addExpenseViewController:self
                               addedExpense:newExpense];
    
}

@end
