//
//  OscillatorOBJC.m
//  Swift Synth
//
//  Created by Nestor Garcia on 16/06/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "OscillatorOBJC.h"
#import <UIKit/UIKit.h>

@implementation OscillatorOBJC


static float amplitude = 1;
static float frequency = 440;

+ (float)amplitude { return amplitude; }
+ (float)frequency { return frequency; }

+ (Signal)sine {
    return ^(float time) {
        return (float)([OscillatorOBJC amplitude] * sin(2.0 * M_PI * [OscillatorOBJC frequency] * time));
    };
}

+ (Signal)triangle {
    return ^(float time) {
        double period = 1.0 / (double)[OscillatorOBJC amplitude];
        double currentTime = fmod((double)time, period);
        
        double value = currentTime / period;
        
        double result = 0.0;
        
        if (value < 0.25) {
            result = value * 4;
        } else if (value < 0.75) {
            result = 2.0 - (value * 4.0);
        } else {
            result = value * 4 - 4.0;
        }
        
        return [OscillatorOBJC amplitude] * (float)result;
    };
}

+ (Signal)sawtooth {
    return ^(float time) {
        float period = 1.0 / [OscillatorOBJC frequency];
        double currentTime = fmod((double)time, period);
        
        return [OscillatorOBJC amplitude] * (((float)currentTime / period) * 2 - (float)1.0);
    };
}

+ (Signal)square {
    return ^(float time) {
        double period = 1.0 / (double)[OscillatorOBJC frequency];
        double currentTime = fmod((double)time, period);
        
        return ((currentTime / period) < (float)0.5) ? [OscillatorOBJC amplitude] : (float)-1.0 * [OscillatorOBJC amplitude];
    };
}

+ (Signal)whiteNoise {
    return ^(float time) {
        return [OscillatorOBJC amplitude] * [OscillatorOBJC randomFloatBetween:-1 and:1];
    };
}

+ (float)randomFloatBetween:(float)min and:(float)max {
    float diff = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + min;
}

@end
