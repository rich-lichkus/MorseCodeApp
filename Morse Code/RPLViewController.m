//
//  RPLViewController.m
//  Morse Code
//
//  Created by Richard Lichkus on 1/20/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import "RPLViewController.h"


@interface RPLViewController ()

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

- (IBAction)pressedSend:(id)sender {

    if(self.txtBxMessage.text.length >0)
    {
        NSArray *symbolArray = self.txtBxMessage.text ? [self.txtBxMessage.text symbolsForString] : @[@"String Was Nil"];
        NSLog(@"%@", symbolArray);
    }
}

@end
