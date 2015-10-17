//
//  fgPlankEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphEdgeWithRotationNode.h"

@interface fgPlankEdge : f3GraphEdgeWithRotationNode {

    float targetAngle, rotationAngle, rotationRadius;
    f3NodeFlags orientationFlag;
}

@property (readonly) float Angle;

+ (float)getOrientationFlag:(float)_angle;

- (id)init:(NSNumber *)_originKey target:(NSNumber *)_targetKey rotation:(NSNumber *)_rotationKey plank:(uint8_t)_plank;

@end
