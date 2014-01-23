//
//  RPLTorchController.h
//  Morse Code
//
//  Created by Richard Lichkus on 1/22/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+MorseCode.h"


@protocol printFlashDelegate <NSObject>

- (void) willFlashSymbol: (NSString *)symbol;
- (void) willFlashLetter: (NSArray *)letterArray;
- (void) willFinishSending;

@end


@interface RPLTorchController : NSObject

@property (unsafe_unretained) id <printFlashDelegate> delegate;

- (void) torchOn;
- (void) torchOff;

- (NSMutableArray *) getMorseSymbolArrayForMessage: (NSString *)message;

- (void) morseFlashSymbolArray:(NSMutableArray *)symbols;

@end
