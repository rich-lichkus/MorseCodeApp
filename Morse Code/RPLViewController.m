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
@property (strong, nonatomic) RPLTorchController *torchController;
@property (weak, nonatomic) IBOutlet UILabel *lblLetter;
@property (weak, nonatomic) IBOutlet UILabel *lblMorse;
//@property (strong, nonatomic) MBProgressHUD *progress;


@end

@implementation RPLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.torchController = [RPLTorchController new];
    self.torchController.delegate = self;
    
    
   //self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self.view addSubview:self.progress];
    //[self.progress setHidden:YES];
    
    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSOperationQueue *flashQueue = [NSOperationQueue new];
    [flashQueue setMaxConcurrentOperationCount:1];
    
    NSBlockOperation *flashSymbols = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *allSymbols = [NSMutableArray arrayWithArray:[self.torchController getMorseSymbolArrayForMessage: self.txtBxMessage.text]];
        [self.torchController morseFlashSymbolArray:allSymbols];
    }];


    [flashQueue addOperation:flashSymbols];
}


#pragma mark - Flash Delegate

- (void) willFlashSymbol: (NSString *)symbol
{
    self.lblMorse.text = symbol;
    
}

-(void) willFlashLetter: (NSArray *)letterArray
{
    self.lblLetter.text = letterArray[0];
}

- (void) willFinishSending{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
