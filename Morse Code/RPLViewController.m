//
//  RPLViewController.m
//  Morse Code
//
//  Created by Richard Lichkus on 1/20/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import "RPLViewController.h"


@interface RPLViewController ()
@property (nonatomic, getter = isFlashOn) BOOL flashOn;
@property (weak, nonatomic) IBOutlet UITextView *txtBxMessage;
- (IBAction)pressedSend:(id)sender;
@end

@implementation RPLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)pressedSend:(id)sender
{
    NSOperationQueue *flashQueue = [NSOperationQueue new];
    [flashQueue setMaxConcurrentOperationCount:1];
    
    NSBlockOperation *flashSymbols = [NSBlockOperation blockOperationWithBlock:^{
    
        NSMutableArray *allSymbols = [NSMutableArray new];
        if(self.txtBxMessage.text.length >0)
        {
            allSymbols = self.txtBxMessage.text ? [self.txtBxMessage.text wordSymbolsForMessage] : [NSMutableArray arrayWithObject:@"String Was Nil"];
        }
        
        AVCaptureDevice *torch = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [torch lockForConfiguration:nil];
       
        for(NSMutableArray *word in allSymbols)
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
                            sleepTime = 100000;
                            break;
                        case 1:
                            sleepTime = 300000;
                            break;
                    }
                    [torch setTorchMode:AVCaptureTorchModeOn];
                    [torch setFlashMode:AVCaptureFlashModeOn];
                    usleep(sleepTime);  // Duration Light is on, based on symbol
                    [torch setTorchMode:AVCaptureTorchModeOff];
                    [torch setFlashMode:AVCaptureFlashModeOff];
                    usleep(100000);     // Duration between symbols
                }
            }
            usleep(500000);
        }
        [torch unlockForConfiguration];
    }];
    
    [flashQueue addOperation:flashSymbols];
    
}

@end
