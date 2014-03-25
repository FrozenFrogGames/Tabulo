//
//  fgTabuloLevel.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloLevel.h"
#import "../../../Framework/Framework/Control/f3GraphResolver.h"
#import "../Control/fgPawnEdge.h"
#import "../Control/fgPlankEdge.h"
#import "../Control/fgGameState.h"
#import "../fgDataAdapter.h"

@implementation fgTabuloLevel

- (id)init {
    
    self = [super init];

    if (self != nil)
    {
        backgroundRotation = nil;

        indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                        FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    }
    
    return self;
}

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level {

    if (_level < 7)
    {
/*
    NSString *filename = [@"DATA" stringByAppendingString:[NSString stringWithFormat:@"%04d",_level]];
    fgDataAdapter *adapter = [[fgDataAdapter alloc] initWithName:filename];

    if (adapter == nil)
    {
 */
        f3GraphResolver *resolver = [[f3GraphResolver alloc] init:[_state getNodeKeys]];

        while ([resolver computeAllConfig:_state])
        {
            NSLog(@"%@", resolver);
        }

        NSUInteger *solutionIndexes;
        NSUInteger solutionCount = [resolver getSolutionIndexes:&solutionIndexes];
        NSMutableArray *bestSolutions = [NSMutableArray array];
        NSUInteger pathLength, shortestPathLength = 0;

        for (NSUInteger i = 0; i < solutionCount; ++i)
        {
            f3GraphConfig *solution = [resolver resolve:solutionIndexes[i] initial:0];
            
            if (solution != nil)
            {
                pathLength = solution.PathLength;
                
                if (shortestPathLength == 0 || pathLength < shortestPathLength)
                {
                    shortestPathLength = pathLength;

                    [bestSolutions removeAllObjects];
                }
                
                if (pathLength == shortestPathLength)
                {
                    [bestSolutions addObject:solution];
                }
            }
            else
            {
                // TODO throw f3Exception
            }
        }

        if (solutionIndexes != nil)
        {
            free(solutionIndexes);
        }
/*
        adapter = [[fgDataAdapter alloc] init];
        
        f3IntegerArray *countHandle = [f3IntegerArray buildHandleForUInt32:1, [[NSNumber alloc] initWithUnsignedInteger:[bestSolutions count]], nil];
        [countHandle.Data serialize:adapter];
 */
        for (f3GraphConfig *solution in bestSolutions)
        {
            [(fgGameState *)_state bindSolution:solution];

//          [solution serialize:adapter];
        }
    }
/*
        [adapter closeWithName:filename];
    }
    else
    {
        f3IntegerArray *countHandle = [[f3IntegerArray alloc] initWithModel:[[f3ModelData alloc] init:adapter] size:sizeof(unsigned int)];
        unsigned int count = [countHandle uint32ValueAt:0];

        for (NSUInteger i = 0; i < count; ++i)
        {
            f3GraphConfig *solution = [[f3GraphConfig alloc] init:adapter];

            [(fgGameState *)_state bindSolution:solution];
        }
    }
 */
    
    [(fgGameState *)_state buildPauseButtton:_builder atPosition:CGPointMake(-7.f, -5.f) level:_level];
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
}

- (void)deviceOrientationDidChange:(bool)_orientationIsPortrait {

    [super deviceOrientationDidChange:_orientationIsPortrait];
    
    if (backgroundRotation != nil)
    {
        backgroundRotation.Ratio = (_orientationIsPortrait ? 1.f : 0.f);
    }
}

- (void)buildBackground {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    f3IntegerArray *background = [director getResourceIndex:RESOURCE_Background];
    
    if (background != nil)
    {
        f3ViewBuilder *builder = director.Builder;
        
        [builder push:indicesHandle];
        [builder push:vertexHandle];
        [builder buildAdaptee:DRAW_TRIANGLES];
        
        [builder push:[f3FloatArray buildHandleForFloat32:8,
                       FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f),
                       FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
        [builder push:background];
        [builder buildDecorator:4];
        
        [builder push:[f3VectorHandle buildHandleForWidth:16.f height:12.f]];
        [builder buildDecorator:2];
        
        [builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(0.f), nil]];
        [builder buildDecorator:3];
        
        backgroundRotation = (f3AngleDecorator *)[builder top]; // keep reference on decorator to rotate the background
        [backgroundRotation applyRotation:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(90.f), nil]];
        backgroundRotation.Ratio = (orientationIsPortrait ? 1.f : 0.f);
    }
}

- (void)buildPillar:(f3GraphNode *)_node {
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f)
                                  atPoint:CGPointMake(1664.f, 512.f)
                               withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:3.f height:3.f]];
    [builder buildDecorator:2];
    
    CGPoint position = _node.Position;
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
}

- (void)buildHouse:(fgHouseNode *)_node type:(enum f3TabuloPawnType)_type state:(f3GameState *)_state {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;

    f3IntegerArray *houseIndices = [f3IntegerArray buildHandleForUInt16:12, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7), nil];

    f3FloatArray *houseVertex = [f3FloatArray buildHandleForFloat32:16, FLOAT_BOX(-1.5f), FLOAT_BOX(1.5f), // 0
                                 FLOAT_BOX(1.5f), FLOAT_BOX(1.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 2
                                 FLOAT_BOX(1.5f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 4
                                 FLOAT_BOX(1.5f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-1.5f), // 6
                                 FLOAT_BOX(1.5f), FLOAT_BOX(-1.5f), nil];

    float houseX1 = (128.f +(_type *384.f)) /2048.f;
    float houseX2 = (512.f +(_type *384.f)) /2048.f;

    f3FloatArray *houseCoordonate = [f3FloatArray buildHandleForFloat32:16, FLOAT_BOX(houseX1), FLOAT_BOX(0.f), // 0
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.f),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(0.222222222f), // 2
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.222222222f),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(0.222222222f), // 4
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.222222222f),
                                     FLOAT_BOX(houseX1), FLOAT_BOX(0.333333333f), // 6
                                     FLOAT_BOX(houseX2), FLOAT_BOX(0.333333333f), nil];

    [builder push:houseIndices];
    [builder push:houseVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *view = (f3ViewAdaptee *)[builder top];
    
    [builder push:houseCoordonate];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    
    CGPoint position = _node.Position;
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    f3GraphCondition *condition = [[f3GraphCondition alloc] init:_node.Key flag:_type result:true];

    [_state bindCondition:condition]; // each house add its game condition
    
    [_node bindView:view type:_type]; // only used for visual feedback on the house
}

- (f3ViewAdaptee *)buildPawn:(f3GraphNode *)_node type:(enum f3TabuloPawnType)_type {

    CGPoint textureCoordonate, position = _node.Position;
    switch (_type) {
        case TABULO_PawnOne:
            textureCoordonate = CGPointMake(0.f, 0.f);
            break;
            
        case TABULO_PawnTwo:
            textureCoordonate = CGPointMake(0.f, 128.f);
            break;
            
        case TABULO_PawnThree:
            textureCoordonate = CGPointMake(0.f, 256.f);
            break;
            
        case TABULO_PawnFour:
            textureCoordonate = CGPointMake(0.f, 384.f);
            break;
            
        case TABULO_PawnFive:
            textureCoordonate = CGPointMake(0.f, 512.f);
            break;
            
        case TABULO_PAWN_MAX:
            // TODO throw f3Exception
            return nil;
    }
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f)
                                  atPoint:CGPointMake(textureCoordonate.x, textureCoordonate.y)
                               withExtend:CGSizeMake(128.f, 128.f)]];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    [_node setFlag:_type value:true];
    
    return result;
}

- (f3ViewAdaptee *)buildSmallPlank:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole {
    
    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *plankVertex = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(-0.625f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-1.f), // 2
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-0.625f),
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(-0.625f), // 4
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(0.625f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-0.625f), // 6
                                 FLOAT_BOX(0.5f), FLOAT_BOX(0.625f),
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(0.625f), // 8
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(1.f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(0.625f), // 10
                                 FLOAT_BOX(0.5f), FLOAT_BOX(1.f), nil];
    
    float holeOffset = 176.f; // +(_hole *256.f);
    
    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.444444444f), // 0
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.444444444f),
                                     FLOAT_BOX(0.0625f), FLOAT_BOX(0.666666667f), // 2
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.666666667f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.444444444f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.444444444f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.666666667f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.666666667f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.444444444f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.444444444f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.666666667f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.666666667f), nil];
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [builder buildDecorator:2];
    
    CGPoint position = _node.Position;
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    [_node setFlag:TABULO_HaveSmallPlank value:true];

    return result;
}

- (f3ViewAdaptee *)buildMediumPlank:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole {

    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *plankVertex = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(-0.625f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-1.5f), // 2
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-0.625f),
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(-0.625f), // 4
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(0.625f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(-0.625f), // 6
                                 FLOAT_BOX(0.5f), FLOAT_BOX(0.625f),
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(0.625f), // 8
                                 FLOAT_BOX(-0.5f), FLOAT_BOX(1.5f),
                                 FLOAT_BOX(0.5f), FLOAT_BOX(0.625f), // 10
                                 FLOAT_BOX(0.5f), FLOAT_BOX(1.5f), nil];
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;
    
    float holeOffset = 112.f; // (_hole == 0) ? 112.f : 176. +(_hole *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.f), FLOAT_BOX(0.666666667f), // 0
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.666666667f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(0.888888889f), // 2
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.888888889f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.666666667f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.666666667f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.888888889f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.888888889f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.666666667f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.666666667f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.888888889f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.888888889f), nil];
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [builder buildDecorator:2];
    
    CGPoint position = _node.Position;
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    [_node setFlag:TABULO_HaveMediumPlank value:true];

    return result;
}

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPawnEdge *edge = [[fgPawnEdge alloc] init:pawn origin:_origin target:_target input:_node];

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:_type result:true]];

        switch (pawn) // restrict edge if a hole is present
        {
            case TABULO_PawnOne:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleOne result:false]];
                break;
                
            case TABULO_PawnTwo:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleTwo result:false]];
                break;
                
            case TABULO_PawnThree:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleThree result:false]];
                break;
                
            case TABULO_PawnFive:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleFour result:false]];
                break;
                
            case TABULO_PawnFour:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleFive result:false]];
                break;
        }
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnOne result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnTwo result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnThree result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFive result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFour result:false]];
    }
}

- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPlankEdge *edge = [[fgPlankEdge alloc] init:_type origin:_origin target:_target rotation:_node];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:_type result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:_type result:false]];
    }
}

@end
