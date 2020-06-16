//
//  SynthOBJC.h
//  Swift Synth
//
//  Created by Nestor Garcia on 16/06/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "OscillatorOBJC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SynthOBJC : NSObject

+ (SynthOBJC*)shared;

@property (nonatomic) float volume;

- (void)setWaveformTo:(Signal)signal;

@end

NS_ASSUME_NONNULL_END
