//
//  RPLReceiveViewController.m
//  Morse Code
//
//  Created by Richard Lichkus on 1/24/14.
//  Copyright (c) 2014 Codefellows. All rights reserved.
//

#import "RPLReceiveViewController.h"

@interface RPLReceiveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtReceiveMessage;
@property (nonatomic, getter = isReceiving, assign) BOOL receiving;
- (IBAction)pressedReceive:(id)sender;

@end

@implementation RPLReceiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cfMagicEvents  = [[CFMagicEvents alloc] init];
        self.receiving = NO;
    }
    return self;
}

#pragma mark - View Load

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(risingEdge:) name:@"risingEdge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fallingEdge:) name:@"fallingEdge" object:nil];
}

#pragma mark - Notification Center 

-(void)risingEdge:(NSNotification *) notification
{
    // NSLog(@"risingEdge");
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
    
}

-(void)fallingEdge:(NSNotification *) notification
{
    //NSLog(@"fallingEdge");
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
}


#pragma mark - Button Actions

- (IBAction)pressedReceive:(id)sender {
    
    if(!self.isReceiving)
    {
        [self.cfMagicEvents startCapture];
        self.receiving = YES;
        NSLog(@"Start");
    }
    else{
        [self.cfMagicEvents stopCapture];
        self.receiving = NO;
        NSLog(@"Stop");
    }
}

#pragma mark - Receive Methods
- (NSMutableString *)getMessageForDuration:(NSNumber *)lightDuration{

    NSMutableString *message = [NSMutableString new];
    
    if([lightDuration isEqual:@.1])
    {
        [message stringByAppendingString:@"0"];
    }
    else if([lightDuration isEqual:@.3])
    {
        [message stringByAppendingString:@"1"];
    }
    else if ([lightDuration isEqual:@.4]){
        [message stringByAppendingString:@" "];
    }
    return message;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
