//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Michel Deiman on 28/02/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import Foundation

// UI-independent representation of a facial expression 

struct FacialExpression {
	
	enum Eyes: Int {
		case open
		case closed
		case squinting
	}
		
	enum Mouth: Int {
		case frown
		case smirk
		case neutral
		case grin
		case smile
		
        var sadder: Mouth {
			return Mouth(rawValue: rawValue - 1) ?? .frown
		}
		
        var happier: Mouth {
			return Mouth(rawValue: rawValue + 1) ?? .smile
		}
	}
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
	
	var eyes: Eyes
	var mouth: Mouth
}
