//
//  OscillatorOBJC.h
//  Swift Synth
//
//  Created by Nestor Garcia on 16/06/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float (^Signal)(float);

@interface OscillatorOBJC : NSObject

+(float)amplitude;
+(void)setAmplitude:(float)amp;
+(float)frequency;
+(void)setFrequency:(float)freq;

+ (Signal)sine;
+ (Signal)triangle;
+ (Signal)sawtooth;
+ (Signal)square;
+ (Signal)whiteNoise;

@end
