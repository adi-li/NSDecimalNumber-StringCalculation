//
//  NSDecimalNumber+CalculatingByString.m
//  NSDecimalNumber+StringCalculation
//
//  Created by Adi Li on 11/5/14.
//  Copyright (c) 2014 Adi Li. All rights reserved.
//

#import "NSDecimalNumber+CalculatingByString.h"

typedef enum {
    tokenTypeFirstLoop = -1,
    tokenTypeNumber = 1,
    tokenTypeText,
    tokenTypeOperator,
    tokenTypeUnknown,
} tokenType;

tokenType typeForCharacter (const unichar character)
{
    if ((character >= '0' && character <= '9') || character == '.') {
        return tokenTypeNumber;
        
    } else if ((character >= 'A' && character <= 'z') || character == '_') {
        return tokenTypeText;
        
    } else if (character == '+' || character == '-' || character == '*' || character == '/' ||
               character == '(' || character == ')' || character == '^')
    {
        return tokenTypeOperator;
    }
    return tokenTypeUnknown;
}

int precedenceForOperator (const unichar operator)
{
    switch (operator) {
        case '+':
        case '-':
            return 2;
            
        case '*':
        case '/':
            return 3;
            
        case '^':
            return 4;
            
        default:
            return 0;
    }
}


@implementation NSDecimalNumber (CalculatingByString)

+ (NSMutableArray *)tokenBasedStackFromEquation:(NSString *)equation decimalNumbers:(NSDictionary *)numbers
{
    unichar equationChars[equation.length + 1], tempChars[equation.length + 1];
    
    tokenType lastTokenType = tokenTypeFirstLoop, currentTokenType = tokenTypeFirstLoop;
    
    NSUInteger tempCharsLength = 0;
    
    NSMutableArray *equationStack = [@[] mutableCopy];
    
    equation = [equation stringByReplacingOccurrencesOfString:@" " withString:@""];
    [equation getCharacters:equationChars];
    
    for (long i=0; i <= equation.length; i++) {
        unichar character = equationChars[i];
        currentTokenType = typeForCharacter(character);
        
        if (character == '-' && lastTokenType != tokenTypeNumber && lastTokenType != tokenTypeText) {
            currentTokenType = tokenTypeNumber;
        }
        
        if (lastTokenType == tokenTypeFirstLoop) {
            lastTokenType = currentTokenType;
        }
        
        if (currentTokenType != lastTokenType || lastTokenType == tokenTypeOperator) {
            
            NSString *string = [NSString stringWithCharacters:tempChars length:tempCharsLength];
            
            if (lastTokenType == tokenTypeText) {
                id object = [numbers objectForKey:string];
                
                if ([object isKindOfClass:[NSString class]]) {
                    string = object;
                } else {
                    string = [object stringValue];
                }
            }
            
            [equationStack addObject:string];
            
            tempCharsLength = 0;
        }
        
        tempChars[tempCharsLength++] = character;
        
        lastTokenType = currentTokenType;
    }
    
    return equationStack;
}

+ (NSMutableArray *)RPNFromStack:(NSArray *)stack
{
    NSMutableArray *output = [@[] mutableCopy];
    NSMutableArray *operatorStack = [@[] mutableCopy];
    NSString *operator;
    
    static NSArray *operators;
    if (operators == nil) {
        operators = @[@"+", @"-", @"*", @"/", @"^"];
    }
    
    for (NSString *token in stack) {
        
        if ([@"(" isEqualToString:token]) {
            [operatorStack addObject:token];
            continue;
        }
        
        operator = nil;
        
        if ([@")" isEqualToString:token]) {
            
            do {
                operator = [operatorStack lastObject];
                [operatorStack removeLastObject];
                
                if (![@"(" isEqualToString:operator]) {
                    [output addObject:operator];
                }
                
            } while (![@"(" isEqualToString:operator]);
            
            continue;
        }
        
        
        if ([operators indexOfObject:token] != NSNotFound) {
            operator = [operatorStack lastObject];
            
            int precedence = precedenceForOperator(token.UTF8String[0]);
            int lastPrecedence = -1;
            
            if (operator) {
                lastPrecedence = precedenceForOperator(operator.UTF8String[0]);
            }
            
            if (precedence > lastPrecedence) {
                [operatorStack addObject:token];
                continue;
            }
            
            do {
                operator = [operatorStack lastObject];
                if (operator && ![@"(" isEqualToString:operator]) {
                    [output addObject:operator];
                    
                    [operatorStack removeLastObject];
                }
                
            } while (operator && precedence <= lastPrecedence && ![@"(" isEqualToString:operator]);
            
            [operatorStack addObject:token];
            continue;
        }
        
        [output addObject:token];
    }
    
    [output addObjectsFromArray:[[operatorStack reverseObjectEnumerator] allObjects]];
    
    return output;
}

+ (NSDecimalNumber *)decimalNumberWithEquation:(NSString *)equation decimalNumbers:(NSDictionary *)numbers
{
    NSDecimalNumber *left, *right;
    
    NSMutableArray *equationStack = [self tokenBasedStackFromEquation:equation decimalNumbers:numbers];
    equationStack = [self RPNFromStack:equationStack];
    
    NSMutableArray *resultArray = [@[] mutableCopy];
    
    NSString *token;
    do {
        token = [equationStack firstObject];
        if ([@"+" isEqualToString:token] || [@"-" isEqualToString:token] || [@"*" isEqualToString:token] || [@"/" isEqualToString:token] || [@"^" isEqualToString:token]) {
            right = [NSDecimalNumber decimalNumberWithString:[resultArray lastObject]];
            [resultArray removeLastObject];
            left = [NSDecimalNumber decimalNumberWithString:[resultArray lastObject]];
            [resultArray removeLastObject];
            
            if ([@"+" isEqualToString:token]) {
                token = [[left decimalNumberByAdding:right] stringValue];
                
            } else if ([@"-" isEqualToString:token]) {
                token = [[left decimalNumberBySubtracting:right] stringValue];
                
            } else if ([@"*" isEqualToString:token]) {
                token = [[left decimalNumberByMultiplyingBy:right] stringValue];
                
            } else if ([@"/" isEqualToString:token]) {
                token = [[left decimalNumberByDividingBy:right] stringValue];
                
            } else if ([@"^" isEqualToString:token]) {
                token = [[left decimalNumberByRaisingToPower:right.integerValue] stringValue];
                
            }
        }
        [resultArray addObject:token];
        
        [equationStack removeObjectAtIndex:0];
        
    } while (equationStack.count > 0);

    
    return [NSDecimalNumber decimalNumberWithString:[resultArray objectAtIndex:0]];
}

@end
