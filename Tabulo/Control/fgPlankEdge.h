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
}

@property (readonly) float Angle;

- (void)setPlankType:(unsigned char)_type;

@end
