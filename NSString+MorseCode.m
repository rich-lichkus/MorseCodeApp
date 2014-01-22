//
//  NSString+MorseCode.m
//  Morse Code
//
//  Created by Richard Lichkus on 1/20/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import "NSString+MorseCode.h"



@implementation NSString (MorseCode)

+(NSDictionary *)morseCodeDictionary
{
    NSDictionary *morseCodeDictionary = [NSDictionary new];
    morseCodeDictionary = @{@"A": @"01",
                            @"B": @"1000",
                            @"C": @"1010",
                            @"D": @"100",
                            @"E": @"0",
                            @"F": @"0010",
                            @"G": @"110",
                            @"H": @"0000",
                            @"I": @"00",
                            @"J": @"0111",
                            @"K": @"101",
                            @"L": @"0100",
                            @"M": @"11",
                            @"N": @"10",
                            @"O": @"111",
                            @"P": @"0110",
                            @"Q": @"1101",
                            @"R": @"010",
                            @"S": @"000",
                            @"T": @"1",
                            @"U": @"001",
                            @"V": @"0001",
                            @"W": @"011",
                            @"X": @"1001",
                            @"Y": @"1011",
                            @"Z": @"1100",
                            @"0": @"11111",
                            @"1": @"01111",
                            @"2": @"00111",
                            @"3": @"00011",
                            @"4": @"00001",
                            @"5": @"00000",
                            @"6": @"10000",
                            @"7": @"11000",
                            @"8": @"11100",
                            @"9": @"11110"};
    
    
    return morseCodeDictionary;
}


- (NSMutableArray *) wordSymbolsForMessage
{
	NSMutableArray *wordSymbolsForMessage = [NSMutableArray new];       // Array of words as symbols
    NSMutableArray *symbolsForWord= [NSMutableArray new];               // Array of letter as symbols
    
    NSString *upperString = [self uppercaseString];                     // Convert to uppercase - eliminate error and smaller character set
    
    for(int i=0; i<upperString.length; i++)
	{
        NSMutableString *singleCharacter = [NSMutableString stringWithString:[upperString substringWithRange:NSMakeRange(i, 1)]];   // Get single character
        if([singleCharacter isEqualToString:@" "] && symbolsForWord.count > 0)                          // if, Space
        {
            [wordSymbolsForMessage addObject: symbolsForWord];                                          // then, add word to array of words
            symbolsForWord = [NSMutableArray new];                                                      // create new array
        }
        else
        {
            for(NSString *key in [[NSString morseCodeDictionary] allKeys])                              // for each key
            {
                if([singleCharacter isEqualToString:key])                                               // if 
                {
                    [symbolsForWord addObject: [NSString symbolForLetter:singleCharacter]];
                }
            }
        }
    }
    
    [wordSymbolsForMessage addObject: symbolsForWord];
    return wordSymbolsForMessage;
}
                              
+ (NSString *)symbolForLetter:(NSString *)letter
{
    //NSLog(@"%@",letter);
    return [[NSString morseCodeDictionary] objectForKey:letter];
}




@end
