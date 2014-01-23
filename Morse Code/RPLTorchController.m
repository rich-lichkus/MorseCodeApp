//
//  RPLTorchController.m
//  Morse Code
//
//  Created by Richard Lichkus on 1/22/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//


#define FLASH_UNIT 100000
#define DOT_MULTIPLIER 1
#define DASH_MULTIPLIER 3
#define BETWEEN_SYMBOL_MULTIPLIER 1
#define BETWEEN_WORDS_MULTIPLIER 5

#import "RPLTorchController.h"

@interface RPLTorchController()

@end


@implementation RPLTorchController

#pragma mark - Morse Methods


- (NSMutableArray *) getMorseSymbolArrayForMessage: (NSString *)message
{
    NSMutableArray *allSymbols = [NSMutableArray new];
    if(message.length >0)
    {
        allSymbols = message ? [message wordSymbolsForMessage] : [NSMutableArray arrayWithObject:@"String Was Nil"];
    }
    return allSymbols;
}


- (void) morseFlashSymbolArray:(NSMutableArray *)symbols;
{
    for(NSMutableArray *word in symbols)
    {
        for(NSString *symbolSet in word)
        {
            for(int i=0; i<symbolSet.length; i++)
            {
                
                NSInteger currentBit = [[NSString stringWithString:[symbolSet substringWithRange: NSMakeRange(i, 1)]] integerValue];
                unsigned sleepTime = 0;
                switch(currentBit)
                {
                    case 0:
                        sleepTime = FLASH_UNIT*DOT_MULTIPLIER;
                        break;
                    case 1:
                        sleepTime = FLASH_UNIT*DASH_MULTIPLIER;
                        break;
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.delegate willFlashSymbol:symbolSet];
                    NSArray *allKeys = [[NSString morseCodeDictionary] allKeysForObject:symbolSet];
                    [self.delegate willFlashLetter:allKeys];
                }];
                
                [self torchOn];
                usleep(sleepTime);                               // Duration light on for symbol
                [self torchOff];
                usleep(FLASH_UNIT*BETWEEN_SYMBOL_MULTIPLIER);    // Duration light off between symbol
            }
        }
        usleep(FLASH_UNIT*BETWEEN_WORDS_MULTIPLIER);             // Duration light off between words
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate willFinishSending];
    }];
}

#pragma mark - Torch Methods

- (void)torchOn
{
    AVCaptureDevice *torch = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [torch lockForConfiguration:nil];
    [torch setTorchMode:AVCaptureTorchModeOn];
    [torch setFlashMode:AVCaptureFlashModeOn];
    [torch unlockForConfiguration];
}

- (void) torchOff
{
    AVCaptureDevice *torch = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [torch lockForConfiguration:nil];
    [torch setTorchMode:AVCaptureTorchModeOff];
    [torch setFlashMode:AVCaptureFlashModeOff];
    [torch unlockForConfiguration];
}



@end
