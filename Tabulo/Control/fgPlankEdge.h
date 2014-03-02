//
//  fgPlankEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEdge.h"

@interface fgPlankEdge : fgTabuloEdge {

    float targetAngle, rotationAngle, rotationRadius;
    NSNumber *rotationKey;
}

@property (readonly) float Angle;

- (id)init:(int)_flag origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target rotation:(f3GraphNode *)_rotation;

@end
