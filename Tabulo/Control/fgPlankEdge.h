//
//  fgPlankEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphEdgeWithNode.h"

@interface fgPlankEdge : f3GraphEdgeWithNode {

    float targetAngle, rotationAngle, rotationRadius;
    f3NodeFlags orientationFlag;
}

@property (readonly) float Angle;

+ (float)getOrientationFlag:(float)_angle;

- (id)init:(f3NodeFlags)_mask origin:(NSNumber *)_originKey target:(NSNumber *)_targetKey node:(NSNumber *)_nodeKey plank:(uint8_t)_plank;

@end
