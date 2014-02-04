//
//  fgTabuloLevel.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/View/f3GameLevel.h"

@interface fgTabuloLevel : f3GameLevel {
    
    f3RotationDecorator *backgroundRotation;
    f3IntegerArray *indicesHandle;
    f3FloatArray *vertexHandle;
}

- (void)buildLevel:(NSUInteger)_index director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

- (void)buildBackground;
- (void)buildPillar:(NSUInteger)_index;
- (void)buildHouse:(NSUInteger)_index Type:(unsigned int)_type;

- (f3ViewAdaptee *)buildPawn:(NSUInteger)_index Type:(enum f3TabuloPawnType)_type;
- (f3ViewAdaptee *)buildSmallPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole;
- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole;

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;
- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;

- (f3RotationDecorator *)getBackgroundRotation;

@end
