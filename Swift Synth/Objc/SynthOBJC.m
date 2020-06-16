//
//  SynthOBJC.m
//  Swift Synth
//
//  Created by Nestor Garcia on 16/06/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "SynthOBJC.h"

@implementation SynthOBJC

#pragma Variables

AVAudioEngine* audioEngine;
AVAudioSourceNode* sourceNode;

bool _isPlaying = false;
- (bool)isPlaying {
    return _isPlaying;
}

- (float)volume {
    return [[audioEngine mainMixerNode] outputVolume];
}
- (void)setVolume:(float)updateVolume {
    _isPlaying = (updateVolume == 0) ? (false) : (true);
    [[audioEngine mainMixerNode] setOutputVolume: updateVolume];
}

float classTime = 0;
double sampleRate;
float deltaTime;

Signal classSignal;

#pragma Lifecycle

+ (SynthOBJC*)shared {
    static SynthOBJC* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SynthOBJC alloc] initWithSignal: OscillatorOBJC.sine];
    });
    return sharedInstance;
}

- (instancetype)initWithSignal:(Signal)signal {
    self = [super init];
    if (self) {
        sourceNode = [[AVAudioSourceNode alloc] initWithRenderBlock:
                      ^OSStatus(BOOL * _Nonnull isSilence,
                                const AudioTimeStamp * _Nonnull timestamp,
                                AVAudioFrameCount frameCount,
                                AudioBufferList * _Nonnull outputData) {
            for (int frame = 0; frame < frameCount ; frame++){
                float sampleVal = classSignal(classTime);
                classTime += deltaTime;
                
                for (int buffer = 0; buffer < outputData->mNumberBuffers; buffer++){
                    Float32 *buf = (Float32 *)outputData->mBuffers[buffer].mData;
                    buf[frame] = sampleVal;
                }
            }
            return noErr;
        }];
        
        audioEngine = [[AVAudioEngine alloc] init];
        AVAudioMixerNode* mainMixer = audioEngine.mainMixerNode;
        AVAudioOutputNode* outputNode = audioEngine.outputNode;
        AVAudioFormat* format = [outputNode inputFormatForBus:0];
        sampleRate = format.sampleRate;
        deltaTime =  1 / (float)sampleRate;
        classSignal = signal;
        AVAudioFormat * inputFormat = [[AVAudioFormat alloc] initWithCommonFormat: format.commonFormat
                                                                       sampleRate: sampleRate
                                                                         channels: 1
                                                                      interleaved: format.isInterleaved];
        [audioEngine attachNode: sourceNode];
        [audioEngine connect: sourceNode to: mainMixer format: inputFormat];
        [audioEngine connect: mainMixer to: outputNode format: nil];
        mainMixer.outputVolume = 0;
        NSError *error = nil;
        if (![audioEngine startAndReturnError: &error]) {
            NSLog(@"Could not start audioEngine: %@", error.localizedDescription);
        }
        return  self;
    }
    return self;
}

#pragma Methods

- (void)setWaveformTo:(Signal)signal {
    classSignal = signal;
}

@end
