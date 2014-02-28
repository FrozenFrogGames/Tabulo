//
//  fgTabuloLevel.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloLevel.h"
#import "../Control/fgTabuloEdge.h"

@implementation fgTabuloLevel

- (id)init {
    
    self = [super init];

    if (self != nil)
    {
        backgroundRotation = nil;

        indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                        FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    }
    
    return self;
}

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level {
    
    // TODO throw f3Exception
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
        
        [builder push:[f3FloatArray buildHandleForValues:8,
                       FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f),
                       FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
        [builder push:background];
        [builder buildDecorator:4];
        
        [builder push:[f3VectorHandle buildHandleForWidth:16.f height:12.f]];
        [builder buildDecorator:2];
        
        [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.f), nil]];
        [builder buildDecorator:3];
        
        backgroundRotation = (f3RotationDecorator *)[builder top]; // keep reference on decorator to rotate the background
        [backgroundRotation applyAngle:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(90.f), nil]];
        backgroundRotation.Ratio = (orientationIsPortrait ? 1.f : 0.f);
    }
}

- (void)buildPillar:(NSUInteger)_index {
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;

    CGPoint position = [self getPointAt:_index];
    
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
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
}

- (f3ViewAdaptee *)buildHouse:(NSUInteger)_index type:(unsigned int)_type {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *view = (f3ViewAdaptee *)[builder top];

    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f)
                                  atPoint:CGPointMake(128.f +(_type *384.f), 0.f)
                               withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    CGPoint position = [self getPointAt:_index];
    
    [builder push:[f3VectorHandle buildHandleForWidth:3.f height:3.f]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];

    return view;
}

- (f3ViewAdaptee *)buildPawn:(NSUInteger)_index type:(enum f3TabuloPawnType)_type {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;

    CGPoint textureCoordonate, position = [self getPointAt:_index];
    
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
    }
    
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
    
    return result;
}

- (f3ViewAdaptee *)buildSmallPlank:(NSUInteger)_index angle:(float)_angle hole:(int)_hole {
    
    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
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
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3ViewBuilder *builder = director.Builder;
    
    float holeOffset = 176.f +(_hole *256.f);
    
    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.444444444f), // 0
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
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [builder buildDecorator:2];
    
    CGPoint position = [self getPointAt:_index];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    return result;
}

- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index angle:(float)_angle hole:(int)_hole {

    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
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
    
    float holeOffset = (_hole == 0) ? 112.f : 176. +(_hole *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.f), FLOAT_BOX(0.666666667f), // 0
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
    
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [builder buildDecorator:2];
    
    CGPoint position = [self getPointAt:_index];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    return result;
}

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {
    
    f3ControlHeader *translationHeader = [[f3ControlHeader alloc] initForType:2];
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgTabuloEdge *edge = [[fgTabuloEdge alloc] initFromNode:_origin toNode:_target inputNode:_node];
        [edge bindControlHeader:translationHeader];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin flag:pawn value:true]];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:_type value:true]];
        
        switch (pawn) // restrict edge if a hole is present
        {
            case TABULO_PawnOne:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_HoleOne value:false]];
                break;
                
            case TABULO_PawnTwo:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_HoleTwo value:false]];
                break;
                
            case TABULO_PawnThree:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_HoleThree value:false]];
                break;
                
            case TABULO_PawnFive:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_HoleFour value:false]];
                break;
                
            case TABULO_PawnFour:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_HoleFive value:false]];
                break;
        }
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PawnOne value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PawnTwo value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PawnThree value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PawnFive value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PawnFour value:false]];
    }
}

- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {

    float targetAngle = [f3GameScene computeAngleBetween:_target.Position and:_node.Position];
    
    float deltaAngle = targetAngle - [f3GameScene computeAngleBetween:_origin.Position and:_node.Position];
    if (deltaAngle > 180.f)
    {
        deltaAngle -= 360.f;
    }
    else if (deltaAngle < -180.f)
    {
        deltaAngle += 360.f;
    }
    
    float radius;
    switch (_type)
    {
        case TABULO_HaveSmallPlank:
            radius = 1.75f;
            break;
            
        case TABULO_HaveMediumPlank:
            radius = 2.5f;
            break;
            
        case TABULO_HaveLongPlank:
            radius = 4.0f; // TODO compute gameplay for long plank
            break;
    }
    
    f3GraphNode *inputNode = nil;
    
    NSArray *targetEdge = [fgTabuloEdge edgesFromNode:_node withInput:_target];
    if ([targetEdge count] > 0)
    {
        inputNode = ((fgTabuloEdge *)[targetEdge objectAtIndex:0]).Target;
        
        if ([targetEdge count] > 1)
        {
            // TODO test that all the edges have the same target node
        }
    }
    
    f3ControlHeader *transformHeader = [[f3ControlHeader alloc] initForType:3];
    [transformHeader bindModel:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(targetAngle), nil]];
    [transformHeader bindModel:[f3FloatArray buildHandleForValues:2, FLOAT_BOX(deltaAngle), FLOAT_BOX(radius), nil]];
    [transformHeader bindModel:[_node getPositionHandle]];
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgTabuloEdge *edge = [[fgTabuloEdge alloc] initFromNode:_origin toNode:_target inputNode:inputNode];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin flag:_type value:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:pawn value:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:_type value:false]];
        
        [edge bindControlHeader:transformHeader];
    }
}

@end
