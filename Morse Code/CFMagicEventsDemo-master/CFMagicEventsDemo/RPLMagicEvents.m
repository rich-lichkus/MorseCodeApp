
//  RPLMagicEvents.m
//  Copyright (c) 2013 Cédric Floury
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the
//     purpose of any concept relating to diary/journal keeping.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "RPLMagicEvents.h"
#import <AVFoundation/AVFoundation.h>

#define NUMBER_OF_FRAME_PER_S 30
#define BRIGHTNESS_THRESHOLD 2000
#define MIN_BRIGHTNESS_THRESHOLD 4000



@interface RPLMagicEvents() <AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_captureSession;
    UInt32  _lastTotalBrightnessValue;
    int _brightnessThreshold;
    BOOL _started;
    NSDate *previousDate;
    NSNumber *newNum;
}
@end

@implementation RPLMagicEvents

#pragma mark - init

- (id)init
{
    if ((self = [super init])) {
        
        
        [self initMagicEvents];
        newNum = [NSNumber numberWithUnsignedLong:0];
    }
    
    return self;
}

- (void)initMagicEvents
{
    _started = NO;
    _brightnessThreshold = BRIGHTNESS_THRESHOLD;
    previousDate = [NSDate date];
    [NSThread detachNewThreadSelector:@selector(initCapture) toTarget:self withObject:nil];
}

- (void)initCapture {
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSError *error = nil;
    
    AVCaptureDevice *captureDevice = [self searchForBackCameraIfAvailable];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if ( ! videoInput)
    {
        NSLog(@"Could not get video input: %@", error);
        return;
    }

    
    //  the capture session is where all of the inputs and outputs tie together.
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    //  sessionPreset governs the quality of the capture. we don't need high-resolution images,
    //  so we'll set the session preset to low quality.
    
    _captureSession.sessionPreset = AVCaptureSessionPresetLow;
    
    [_captureSession addInput:videoInput];
    
    //  create the thing which captures the output
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    //  pixel buffer format
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                              kCVPixelBufferPixelFormatTypeKey, nil];
    videoDataOutput.videoSettings = settings;
    //[settings release];
    
    AVCaptureConnection *conn = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (conn.isVideoMinFrameDurationSupported)
        conn.videoMinFrameDuration = CMTimeMake(1, NUMBER_OF_FRAME_PER_S);
    if (conn.isVideoMaxFrameDurationSupported)
        conn.videoMaxFrameDuration = CMTimeMake(1, NUMBER_OF_FRAME_PER_S);
    
    //  we need a serial queue for the video capture delegate callback
    dispatch_queue_t queue = dispatch_queue_create("com.zuckerbreizh.cf", NULL);
    
    [videoDataOutput setSampleBufferDelegate:(id)self queue:queue];
    [_captureSession addOutput:videoDataOutput];
    //[videoDataOutput release];
    
    //dispatch_release(queue);

    [_captureSession startRunning];
    _started = YES;
    
    //[pool release];
    
}

-(void)updateBrightnessThreshold:(int)pValue
{
    _brightnessThreshold = pValue;
}

-(BOOL)startCapture
{
    if(!_started){
        _lastTotalBrightnessValue = 0;
        [_captureSession startRunning];
        _started = YES;
    }
    return _started;
}

-(BOOL)stopCapture
{
    if(_started){
        [_captureSession stopRunning];
         _started = NO;
    }
    return _started;
}

#pragma mark - Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        UInt8 *base = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        
        //  calculate average brightness in a simple way
        
        size_t bytesPerRow      = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width            = CVPixelBufferGetWidth(imageBuffer);
        size_t height           = CVPixelBufferGetHeight(imageBuffer);
        UInt32 totalBrightness  = 0;
        
        for (UInt8 *rowStart = base; height; rowStart += bytesPerRow, height --)
        {
            size_t columnCount = width;
            for (UInt8 *p = rowStart; columnCount; p += 4, columnCount --)
            {
                UInt32 value = (p[0] + p[1] + p[2]);
                totalBrightness += value;
            }
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
        
        if(_lastTotalBrightnessValue==0) _lastTotalBrightnessValue = totalBrightness;
        
        UInt32 currentValue = [self calculateLevelOfBrightness:totalBrightness];
        
        //NSLog(@"%lu, %lu",newNum.unsignedLongValue, currentValue);
        
        // Determine brightness gradient : ambient to bright
        
        //NSNumber *risingEdgeGradient  = [NSNumber numberWithUnsignedLong:(currentValue - newNum.unsignedLongValue)];
        //if(risingEdgeGradient.unsignedLongValue > 800)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"risingEdge" object:nil];
            NSLog(@"rising edge");
        }
    
        // Determine brightness gradient : bright to ambient
        
        //NSNumber *fallingEdgeGradient  = [NSNumber numberWithUnsignedLong:(newNum.unsignedLongValue - currentValue)];
        //if(fallingEdgeGradient.unsignedLongValue > -800)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fallingEdge" object:nil];
            NSLog(@"falling edge");
        }

        // Save previous brightness value, to compare for the next path
        
        //newNum = [NSNumber numberWithUnsignedLong:currentValue];
        //NSLog(@"%lu", newNum.unsignedLongValue);
    }
}

-(int) calculateLevelOfBrightness:(int) pCurrentBrightness
{
    return (pCurrentBrightness*100) /_lastTotalBrightnessValue;
}



#pragma mark - Tools
- (AVCaptureDevice *)searchForBackCameraIfAvailable
{
    //  look at all the video devices and get the first one that's on the front
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            captureDevice = device;
            break;
        }
    }
    
    //  couldn't find one on the front, so just get the default video device.
    if ( ! captureDevice)
    {
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}
@end
