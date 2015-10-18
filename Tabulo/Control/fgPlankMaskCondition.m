//
//  fgPlankMaskCondition.m
//  Tabulo
//
//  Created by Serge Menard on 2015-10-18.
//  Copyright © 2015 Frozenfrog Games. All rights reserved.
//

#import "fgPlankMaskCondition.h"
#import "fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"

@implementation fgPlankMaskCondition

- (bool)evaluate:(f3GraphSchema *)_schema {
    
    if ([super evaluate:_schema])
    {
        return true;
    }
    else if (maskFilter == TABULO_PLANK_ORIENTATION) // tolerance for plank orientation
    {
        f3NodeFlags currentOrientation = [_schema getNodeMask:ownerKey mask:maskFilter] >> 0xB;
        f3NodeFlags expectedOrientation = maskResult >> 0xB;
        
        if (expectedOrientation == (currentOrientation +1) %8)
        {
            return true;
        }
        else if ((expectedOrientation +1) %8 == currentOrientation)
        {
            return true;
        }
    }
    
    return false;
}

@end
