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

- (void)stripEqualsSign
{
    NSRange equalsSign = [self.summary.text rangeOfString:@" ="];
    if (equalsSign.location != NSNotFound)
    {
        self.summary.text = [self.summary.text stringByReplacingCharactersInRange:equalsSign withString:@""];
    }
}

- (IBAction)enterPressed 
{
    [self stripEqualsSign];
    self.summary.text = [self.summary.text stringByAppendingFormat:@" %@", self.display.text];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber && [@"+ / -" isEqualToString:operation])
    {
        self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
        return;
    }

    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    [self stripEqualsSign];
    self.summary.text = [self.summary.text stringByAppendingFormat:@" %@ =", operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)clearPressed {
    [self.brain clear];
    self.summary.text = @"";
    self.display.text = @"0";
}

- (IBAction)backspacePressed
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if (self.display.text.length == 0)
        {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}
@end
