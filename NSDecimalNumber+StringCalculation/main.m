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
        
        NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:@"10.0"];
        NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:@".214"];
        
        NSString *equation = @"numberA + numberB * (1 + 30.1 / 100)";
        
        NSDictionary *dict = @{@"numberA": numberA, @"numberB": numberB};
        
        NSDecimalNumber *answer = [NSDecimalNumber decimalNumberWithEquation:equation decimalNumbers:dict];
        
        NSLog(@"equation: %@", equation);
        NSLog(@"numbers: %@", dict);
        NSLog(@"answer: %@", answer);
        
    }
    return 0;
}

