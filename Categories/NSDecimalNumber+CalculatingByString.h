//
//  NSDecimalNumber+CalculatingByString.h
//  NSDecimalNumber+StringCalculation
//
//  Created by Adi Li on 11/5/14.
//  Copyright (c) 2014 Adi Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (CalculatingByString)

+ (NSDecimalNumber *)decimalNumberWithEquation:(NSString *)equation decimalNumbers:(NSDictionary *)numbers;

@end
