//
//  fgTabuloDirector.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3ViewComposite.h"
#import "../../../Framework/Framework/View/f3TranslationDecorator.h"
#import "../../../Framework/Framework/Control/f3ControlHeader.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3Controller.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../Control/fgPawnController.h"
#import "../Control/fgTabuloEdge.h"
#import "fgTabuloDirector.h"
#import "fgTabuloTutorial.h"
#import "fgTabuloEasy.h"

@implementation fgTabuloDirector

- (id)init:(Class )_adapterType {
    
    self = [super init:_adapterType];
    
    if (self != nil)
    {
        levelIndex = 1;
        
        spritesheet = nil;
        
        background = nil;
        backgroundRotation = nil;
        backgroundIsPortrait = false;
        
        indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                        FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
        
        gameCanvas = nil;
    }
    
    return self;
}

- (void)deviceOrientationDidChange:(bool)_orientationIsPortrait {

    backgroundRotation.Ratio = (_orientationIsPortrait ? 1.f : 0.f);
    backgroundIsPortrait = _orientationIsPortrait;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {

    if (gameCanvas == nil && _canvas != nil)
    {
        gameCanvas = (fgViewCanvas *)_canvas;
    }
    
//  spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-debug.png"]), nil];
//  background = nil;

    spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-sea.png"]), nil];
    background = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"background-sea.png"]), nil];
}

- (void)loadScene:(f3GameAdaptee *)_producer {

    [_producer removeAllComponents];

    fgTabuloController *gameController = [fgTabuloTutorial buildLevel:levelIndex director:self producer:_producer];

    [_producer appendComponent:gameController];
}

- (void)nextScene {

    if (levelIndex < NSUIntegerMax)
    {
        if (levelIndex < 6)
        {
            levelIndex++;
        }
        else
        {
            levelIndex = 1;
        }
 
        [scene removeAllComposites];

        [self loadScene:[f3GameAdaptee Producer]];
    }
}

- (float)computeAbsoluteAngleBetween:(CGPoint)_pointA and:(CGPoint)_pointB {
    
    float deltaY = _pointA.y - _pointB.y, deltaX = _pointA.x - _pointB.x, result = M_PI_2;
    
    if (deltaY > 0.f)
    {
        if (deltaX >= 0.f)
        {
            result = atanf(deltaX / deltaY); // first quadrant
        }
        else
        {
            result = atanf(deltaY / -deltaX) +M_PI +M_PI_2; // fourth quadrant
        }
    }
    else if (deltaY < 0.f)
    {
        if (deltaX <= 0.f)
        {
            result = atanf(fabsf(deltaX) / -deltaY) +M_PI; // third quadrant
        }
        else
        {
            result = atanf(-deltaY / deltaX) +M_PI_2; // second quadrant
        }
    }
    else if (deltaX < 0.f)
    {
        result += M_PI;
    }
    
    return result *180.f /M_PI; // radianToDegree
}

- (f3FloatArray *)getCoordonate:(CGSize)_spritesheet atPoint:(CGPoint)_position withExtend:(CGSize)_extend {
    
    CGPoint lowerRight = CGPointMake(_position.x + _extend.width, _position.y + _extend.height);
    
    return  [f3FloatArray buildHandleForValues:8, FLOAT_BOX(_position.x / _spritesheet.width), FLOAT_BOX(_position.y / _spritesheet.height),
             FLOAT_BOX(lowerRight.x / _spritesheet.width), FLOAT_BOX(_position.y / _spritesheet.height),
             FLOAT_BOX(_position.x / _spritesheet.width), FLOAT_BOX(lowerRight.y / _spritesheet.height),
             FLOAT_BOX(lowerRight.x / _spritesheet.width), FLOAT_BOX(lowerRight.y / _spritesheet.height), nil];
}

- (void)buildBackground {

    if (background != nil)
    {
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
        backgroundRotation.Ratio = (backgroundIsPortrait ? 1.f : 0.f);
    }
}

- (void)buildPillar:(NSUInteger)_index {
    
    CGPoint position = [self getPointAt:_index];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(1664.f, 384.f)
                           withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:spritesheet];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:3.f height:3.f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
}

- (void)buildHouse:(NSUInteger)_index Type:(unsigned int)_type {

    CGPoint position = [self getPointAt:_index];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(128.f +(_type *384.f), 0.f)
                           withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:spritesheet];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:3.f height:3.f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
}

- (f3ViewAdaptee *)buildPawn:(NSUInteger)_index Type:(enum f3TabuloPawnType)_type {

    CGPoint type, position = [self getPointAt:_index];

    switch (_type) {
        case TABULO_PawnOne:
            type = CGPointMake(0.f, 512.f);
            break;

        case TABULO_PawnTwo:
            type = CGPointMake(0.f, 384.f);
            break;

        case TABULO_PawnThree:
            type = CGPointMake(0.f, 256.f);
            break;

        case TABULO_PawnFour:
            type = CGPointMake(0.f, 128.f);
            break;

        case TABULO_PawnFive:
            type = CGPointMake(0.f, 0.f);
            break;
    }

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];

    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(type.x, type.y)
                           withExtend:CGSizeMake(128.f, 128.f)]];
    [builder push:spritesheet];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];

    return result;
}

- (f3ViewAdaptee *)buildSmallPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole {

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

    float holeOffset = 176.f +(_hole *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.42857143f), // 0
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(0.0625f), FLOAT_BOX(0.71428571f), // 2
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.42857143f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.42857143f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.71428571f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f), nil];

    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];

    [builder push:plankCoordonate];
    [builder push:spritesheet];
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

- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole {

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

    float holeOffset = (_hole == 0) ? 112.f : 176. +(_hole *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.f), FLOAT_BOX(0.71428571f), // 0
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f), // 2
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(1.f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(1.f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(1.f), nil];
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:spritesheet];
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

- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole1:(int)_hole1 Hole2:(int)_hole2 {
/*
    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:30, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11),
                                    USHORT_BOX(12), USHORT_BOX(13), USHORT_BOX(14),
                                    USHORT_BOX(14), USHORT_BOX(13), USHORT_BOX(15),
                                    USHORT_BOX(16), USHORT_BOX(17), USHORT_BOX(18),
                                    USHORT_BOX(18), USHORT_BOX(17), USHORT_BOX(19), nil];

    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:40, FLOAT_BOX(-1.5f), FLOAT_BOX(0.5f), // 0
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 2
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f), // 4
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f), // 6
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f), // 8
                                 FLOAT_BOX(1.5f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f), // 10
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 12
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f), // 14
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f), // 16
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f), // 18
                                 FLOAT_BOX(1.5f), FLOAT_BOX(0.5f), nil];

    float holeOneOffset = (_indexOne == 0) ? 112.f : 176. +(_indexOne *256.f);
    float holeTwoOffset = (_indexTwo == 0) ? 112.f : 176. +(_indexTwo *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:40, FLOAT_BOX(0.f), FLOAT_BOX(0.71428571f), // 0
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f), // 2
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(1.f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f), // 10
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f), // 12
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f), // 14
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(1.f), // 16
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(1.f), // 18
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(1.f), nil];
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:spritesheet];
    [builder buildDecorator:4];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];
 */
    return nil;
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

    float targetAngle = [self computeAbsoluteAngleBetween:_target.Position and:_node.Position];

    float deltaAngle = targetAngle - [self computeAbsoluteAngleBetween:_origin.Position and:_node.Position];
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

/* - (void)loadSceneTemplate {

    CGPoint pointA1 = CGPointMake(-7.5f, 5.5f);
    CGPoint pointA2 = CGPointMake(-7.5f, 4.5f);
    CGPoint pointA3 = CGPointMake(-7.5f, 3.5f);
    CGPoint pointA4 = CGPointMake(-7.5f, 2.5f);
    CGPoint pointA5 = CGPointMake(-7.5f, 1.5f);
    CGPoint pointB1 = CGPointMake(-5.5f, 4.5f);
    CGPoint pointB2 = CGPointMake(-2.5f, 4.5f);
    CGPoint pointB3 = CGPointMake( 0.5f, 4.5f);
    CGPoint pointB4 = CGPointMake( 3.5f, 4.5f);
    CGPoint pointB5 = CGPointMake( 6.5f, 4.5f);
    CGPoint pointE1 = CGPointMake( 6.5f, 1.5f);
    CGPoint pointC0 = CGPointMake(-6.0f, 2.0f);
    CGPoint pointD0 = CGPointMake(-6.5f, 0.0f);
    CGPoint pointC1 = CGPointMake(-4.0f, 2.0f);
    CGPoint pointD1 = CGPointMake(-4.0f, 0.0f);
    CGPoint pointC2 = CGPointMake(-2.0f, 2.0f);
    CGPoint pointD2 = CGPointMake(-2.0f, 0.0f);
    CGPoint pointC3 = CGPointMake( 0.0f, 2.0f);
    CGPoint pointD3 = CGPointMake( 0.0f, 0.0f);
    CGPoint pointC4 = CGPointMake( 2.0f, 2.0f);
    CGPoint pointD4 = CGPointMake( 2.0f, 0.0f);
    CGPoint pointC5 = CGPointMake( 4.0f, 2.0f);
    CGPoint pointD5 = CGPointMake( 4.0f, 0.0f);

    f3IntegerArray *pawnIndices = [[f3IntegerArray alloc] init];
    f3FloatArray *pawnVertex = [f3FloatArray buildHandleForCircle:32];

    // pawn
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA1.x y:pointA1.y]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA2.x y:pointA2.y]];
    [builder buildDecorator:1];

    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA3.x y:pointA3.y]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA4.x y:pointA4.y]];
    [builder buildDecorator:1];
    
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.5f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA5.x y:pointA5.y]];
    [builder buildDecorator:1];
    
    // house
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB1.x y:pointB1.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB1.x y:pointB1.y]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB2.x y:pointB2.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB2.x y:pointB2.y]];
    [builder buildDecorator:1];

    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB3.x y:pointB3.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB3.x y:pointB3.y]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB4.x y:pointB4.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB4.x y:pointB4.y]];
    [builder buildDecorator:1];

    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB5.x y:pointB5.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.5f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB5.x y:pointB5.y]];
    [builder buildDecorator:1];
    
    // pillar
    [builder push:pawnIndices];
    [builder push:[f3FloatArray buildHandleForCircle:8]];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForWidth:2.75f height:2.75f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE1.x y:pointE1.y]];
    [builder buildDecorator:1];

    // small plank
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.5f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC0.x y:pointC0.y]];
    [builder buildDecorator:1];

    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC1.x y:pointC1.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC1.x y:pointC1.y]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC2.x y:pointC2.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC2.x y:pointC2.y]];
    [builder buildDecorator:1];
    
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC3.x y:pointC3.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC3.x y:pointC3.y]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC4.x y:pointC4.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC4.x y:pointC4.y]];
    [builder buildDecorator:1];
    
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC5.x y:pointC5.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC5.x y:pointC5.y]];
    [builder buildDecorator:1];
    
    // medium plank
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:3.0f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD0.x y:pointD0.y]];
    [builder buildDecorator:1];

    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD1.x y:pointD1.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD1.x y:pointD1.y]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD2.x y:pointD2.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD2.x y:pointD2.y]];
    [builder buildDecorator:1];
    
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD3.x y:pointD3.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD3.x y:pointD3.y]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD4.x y:pointD4.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD4.x y:pointD4.y]];
    [builder buildDecorator:1];
    
    [builder push:pawnIndices];
    [builder push:pawnVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD5.x y:pointD5.y]];
    [builder buildDecorator:1];
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD5.x y:pointD5.y]];
    [builder buildDecorator:1];

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]];
} */

@end
