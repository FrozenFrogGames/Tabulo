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

- (id)initFrom:(NSNumber *)_originKey targetKey:(NSNumber *)_targetKey rotation:(f3GraphNode *)_rotation;

- (void)setPlankType:(unsigned char)_type;

@end
