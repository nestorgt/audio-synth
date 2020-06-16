//
//  unit_tests.swift
//  unit-tests
//
//  Created by Nestor Garcia on 16/06/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

import XCTest
@testable import Swift_Synth

class oscillatorTests: XCTestCase {

    func testSine() {
        let time: Float = 0.5
        
        let swift = Oscillator.sine(time)
        guard let objc = OscillatorOBJC.sine() else { return }
        
        XCTAssertEqual(swift, objc(time), accuracy: 0.001)
    }
    
    func testTriangle() {
        let time: Float = 0.5
        
        let swift = Oscillator.triangle(time)
        guard let objc = OscillatorOBJC.triangle() else { return }
        
        XCTAssertEqual(swift, objc(time), accuracy: 0.001)
    }

    func testSawtooth() {
        let time: Float = 0.5
        
        let swift = Oscillator.sawtooth(time)
        guard let objc = OscillatorOBJC.sawtooth() else { return }
        
        XCTAssertEqual(swift, objc(time), accuracy: 0.001)
    }
    
    func testSquare() {
        let time: Float = 0.5
        
        let swift = Oscillator.square(time)
        guard let objc = OscillatorOBJC.square() else { return }
        
        XCTAssertEqual(swift, objc(time), accuracy: 0.001)
    }
    
    func testWhiteNoise() {
        let time: Float = 1
        
        let objc = OscillatorOBJC.whiteNoise()
        
        XCTAssertNotNil(objc?(time))
    }
}
