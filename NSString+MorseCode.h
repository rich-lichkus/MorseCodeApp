//
//  NSString+MorseCode.h
//  Morse Code
//
//  Created by Richard Lichkus on 1/20/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MorseCode)

- (NSArray *) symbolsForString;
+ (NSString *)symbolForLetter:(NSString *)letter;
+ (NSDictionary *) morseCodeDictionary;
@end
