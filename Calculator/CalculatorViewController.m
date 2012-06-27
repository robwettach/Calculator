//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Rob Wettach on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize summary;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = m_brain;

- (CalculatorBrain *)brain
{
    if (!m_brain)
    {
        m_brain = [[CalculatorBrain alloc] init];
    }
    return m_brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        if ([@"." isEqualToString:digit])
        {
            if ([self.display.text rangeOfString:@"."].location != NSNotFound)
            {
                digit = @"";
            }
        }
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else 
    {
        if ([@"." isEqualToString:digit])
        {
            digit = @"0.";
        }
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{
    self.summary.text = [self.summary.text stringByAppendingFormat:@" %@", self.display.text];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    self.summary.text = [self.summary.text stringByAppendingFormat:@" %@", operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)clearPressed {
    [self.brain clear];
    self.summary.text = @"";
    self.display.text = @"0";
}
@end
