//
//  main.m
//  NSDecimalNumber+StringCalculation
//
//  Created by Adi Li on 11/5/14.
//  Copyright (c) 2014 Adi Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDecimalNumber+CalculatingByString.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSDecimalNumber *numberA1 = [NSDecimalNumber decimalNumberWithString:@"10.0"];
        NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:@"12"];
        
        NSString *numberC = @"100";
        NSString *numberD = @"151";
        
        NSString *equation = @"numberA1 + -numberB * (numberD + 30 / numberC)";
        
        NSDictionary *dict = @{@"numberA1": numberA1, @"numberB": numberB,
                               @"numberC": numberC, @"numberD": numberD
                               };
        
        NSDecimalNumber *answer = [NSDecimalNumber decimalNumberWithEquation:equation decimalNumbers:dict];
        
        NSLog(@"equation: %@", equation);
        NSLog(@"numbers: %@", dict);
        NSLog(@"answer: %@", answer);
        
    }
    return 0;
}

