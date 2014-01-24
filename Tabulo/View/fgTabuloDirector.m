//
//  fgTabuloDirector.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3ViewComposite.h"
#import "../../../Framework/Framework/View/f3TranslationDecorator.h"
#import "../../../Framework/Framework/Control/f3ControlHeader.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3Controller.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "../Control/fgPawnController.h"
#import "../Control/fgTabuloEdge.h"
#import "../Control/fgDragPawnFromNode.h"

@implementation fgTabuloDirector

- (id)init:(Class )_adapterType {
    
    self = [super init:_adapterType];
    
    if (self != nil)
    {
        designIndex = 3;
        levelIndex = 1;

        focusNode = nil;

        gameCanvas = nil;
        gameController = [[fgTabuloController alloc] init];

        indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                        FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
        
        spritesheet = nil;
        background = nil;
    }
    
    return self;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {

    if (gameCanvas == nil && _canvas != nil)
    {
        gameCanvas = (fgViewCanvas *)_canvas;
    }
    
    if (levelIndex == NSUIntegerMax)
    {
        spritesheet = nil;
        background = nil;
    }
    else if (gameCanvas != nil)
    {
        [gameCanvas clearRessource];

        switch (designIndex)
        {
            case 1:
                spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-techno.png"]), nil];
                background = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"background-techno.png"]), nil];
                break;

            case 2:
                spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-wood.png"]), nil];
                background = nil;
                break;

            case 3:
                spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-sea.png"]), nil];
                background = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"background-sea.png"]), nil];
                break;

            case 4:
                spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-custom.png"]), nil];
                background = nil;
                break;
                
            default:
                spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-opengl.png"]), nil];
                background = nil;
                break;
        }
    }
}

- (void)loadScene:(f3GameAdaptee *)_producer {

    [_producer removeAllComponents];

    if (levelIndex == NSUIntegerMax)
    {
        [self loadSceneTemplate];
    }
    else
    {
        switch (levelIndex)
        {
            case 1:
                [self loadSceneOne:_producer];
                break;

            case 2:
                [self loadSceneTwo:_producer];
                break;

            case 3:
                [self loadSceneFive:_producer];
                break;
        }
        
        [_producer appendComponent:gameController];
    }
}

- (void)nextScene {

    if (levelIndex < NSUIntegerMax)
    {
        if (levelIndex < 3)
        {
            levelIndex++;
        }
        else
        {
//          designIndex = (designIndex < 4) ? designIndex+1 : 0;

            [self loadResource:gameCanvas];

            levelIndex = 1;
        }

        [scene removeAllComposites];

        [self loadScene:[f3GameAdaptee Producer]];
    }
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
    }
}

- (void)builPillarAtPosition:(CGPoint)_position {
    
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
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];
}

- (void)buildHouse:(unsigned int)_index atPosition:(CGPoint)_position {

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(128.f +(_index *384.f), 0.f)
                           withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:spritesheet];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:3.f height:3.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];
}

- (f3ViewAdaptee *)buildPawn:(enum f3TabuloPawnType)_index atPosition:(CGPoint)_position {

    CGPoint position;

    switch (_index) {
        case TABULO_PawnOne:
            position = CGPointMake(0.f, designIndex == 3 ? 512.f : 0.f);
            break;

        case TABULO_PawnTwo:
            position = CGPointMake(0.f, designIndex == 3 ? 384.f : 128.f);
            break;

        case TABULO_PawnThree:
            position = CGPointMake(0.f, 256.f);
            break;

        case TABULO_PawnFour:
            position = CGPointMake(0.f, designIndex == 3 ? 128.f : 384.f);
            break;

        case TABULO_PawnFive:
            position = CGPointMake(0.f, designIndex == 3 ? 0.f : 512.f);
            break;
    }

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];

    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(position.x, position.y)
                           withExtend:CGSizeMake(128.f, 128.f)]];

    [builder push:spritesheet];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];

    return result;
}

- (f3ViewAdaptee *)buildSmallPlank:(float)_angle atPosition:(CGPoint)_position withHole:(int)_index {

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

    float holeOffset = 176.f +(_index *256.f);

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
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];

    return result;
}

- (f3ViewAdaptee *)buildMediumPlank:(float)_angle atPosition:(CGPoint)_position withHole:(int)_index {

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

    float holeOffset = (_index == 0) ? 112.f : 176. +(_index *256.f);

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
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];
    
    return result;
}

- (f3ViewAdaptee *)buildMediumPlank:(float)_angle atPosition:(CGPoint)_position withHoleOne:(int)_indexOne andHoleTwo:(int)_indexTwo {
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
    
    return result;
 */
    return nil;
}

- (f3GraphNode *)buildNode:(f3GameAdaptee *)_producer atPosition:(CGPoint)_position withExtend:(CGSize)_extend {
    
    f3GraphNode *node = [[f3GraphNode alloc] initPosition:_position extend:_extend];

    [_producer.Grid appendNode:node];

    return node;
}

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {

    f3ControlHeader *translationHeader = [[f3ControlHeader alloc] initForType:2];

    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgTabuloEdge *edge = [[fgTabuloEdge alloc] initFromNode:_origin toNode:_target plankNode:_node];
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

- (float)computeAbsoluteAngleBetween:(CGPoint)_pointA And:(CGPoint)_pointB {
    
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

- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Angle:(float)_angle Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {

    float targetAngle = [self computeAbsoluteAngleBetween:_target.Position And:_node.Position];

    float deltaAngle = targetAngle - [self computeAbsoluteAngleBetween:_origin.Position And:_node.Position];
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

    f3ControlHeader *transformHeader = [[f3ControlHeader alloc] initForType:3];
    [transformHeader bindModel:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(targetAngle), nil]];
    [transformHeader bindModel:[f3FloatArray buildHandleForValues:2, FLOAT_BOX(deltaAngle), FLOAT_BOX(radius), nil]];
    [transformHeader bindModel:[_node getPositionHandle]];

    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        f3GraphEdge *edge = [[f3GraphEdge alloc] initFromNode:_origin toNode:_target];

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin flag:_type value:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:pawn value:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:_type value:false]];

        [edge bindControlHeader:transformHeader];
    }
}

- (void)loadSceneOne:(f3GameAdaptee *)_producer {
    
    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f];
    [self addPointFrom:2 Radius:1.75f Angle:90.f];
    [self addPointFrom:3 Radius:1.75f Angle:90.f];
    [self computePoints];

    [self builPillarAtPosition:[self getPointAt:0]];
    [self builPillarAtPosition:[self getPointAt:2]];
    [self buildHouse:TABULO_PawnOne atPosition:[self getPointAt:4]];
    [self buildBackground];

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawn = [self buildPawn:TABULO_PawnOne atPosition:[self getPointAt:0]];
    f3ViewAdaptee *plank = [self buildSmallPlank:270.f atPosition:[self getPointAt:1] withHole:0];

    [builder buildComposite:0];

    f3GraphNode *nodeA = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeB = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeC = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeD = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeE = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];

    [self clearPoints];
    
    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeA Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeC Target:nodeA];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeC Target:nodeE];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeE Target:nodeC];

        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeC Origin:nodeB Target:nodeD];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeC Origin:nodeD Target:nodeB];

        f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initForView:plank onNode:nodeB withFlag:TABULO_HaveSmallPlank];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlank]];
        
        fgDragPawnFromNode *controlPawn = [[fgDragPawnFromNode alloc] initForView:pawn onNode:nodeA withFlag:TABULO_PawnOne];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:nodeE]];
    }
    else
    {
        // TODO throw f3Exception
    }
}

- (void)loadSceneTwo:(f3GameAdaptee *)_producer {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f];
    [self addPointFrom:2 Radius:1.75f Angle:180.f];
    [self addPointFrom:2 Radius:2.5f Angle:135.f];
    [self addPointFrom:3 Radius:1.75f Angle:180.f];
    [self addPointFrom:4 Radius:2.5f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:90.f];
    [self computePoints];

    [self buildHouse:TABULO_PawnThree atPosition:[self getPointAt:0]];
    [self builPillarAtPosition:[self getPointAt:2]];
    [self builPillarAtPosition:[self getPointAt:5]];
    [self buildHouse:TABULO_PawnTwo atPosition:[self getPointAt:6]];
    [self buildBackground];

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:TABULO_PawnTwo atPosition:[self getPointAt:0]];
    f3ViewAdaptee *pawnThree = [self buildPawn:TABULO_PawnThree atPosition:[self getPointAt:6]];
    
    f3ViewAdaptee *plankOne = [self buildMediumPlank:270.f atPosition:[self getPointAt:1] withHole:0];
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:90.f atPosition:[self getPointAt:7] withHole:0];
    
    [builder buildComposite:0];
    
    f3GraphNode *nodeA = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeB = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeC = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeD = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeE = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeF = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeG = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeH = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];

    [self clearPoints];

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeB Origin:nodeA Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeB Origin:nodeC Target:nodeA];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeE Origin:nodeC Target:nodeH];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeE Origin:nodeH Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeC Target:nodeF];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeF Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeG Origin:nodeF Target:nodeH];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeG Origin:nodeH Target:nodeF];

        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:135.f Node:nodeC Origin:nodeB Target:nodeE];
        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:0.f Node:nodeC Origin:nodeE Target:nodeB];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeF Origin:nodeD Target:nodeG];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:90.f Node:nodeF Origin:nodeG Target:nodeD];

        f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initForView:plankTwo onNode:nodeG withFlag:TABULO_HaveSmallPlank];
        f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initForView:plankOne onNode:nodeB withFlag:TABULO_HaveMediumPlank];
        
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
        
        fgDragPawnFromNode *controlPawnTwo = [[fgDragPawnFromNode alloc] initForView:pawnTwo onNode:nodeA withFlag:TABULO_PawnTwo];
        fgDragPawnFromNode *controlPawnThree = [[fgDragPawnFromNode alloc] initForView:pawnThree onNode:nodeH withFlag:TABULO_PawnThree];
        
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:nodeH]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnThree Home:nodeA]];
    }
}

- (void)loadSceneFive:(f3GameAdaptee *)_producer {
    
    [self addPointFrom:0 Radius:1.75f Angle:180.f];
    [self addPointFrom:1 Radius:1.75f Angle:180.f];
    [self addPointFrom:0 Radius:2.5f Angle:135.f];
    [self addPointFrom:2 Radius:1.75f Angle:90.f];
    [self addPointFrom:4 Radius:1.75f Angle:90.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:2.5f Angle:90.f];
    [self addPointFrom:6 Radius:1.75f Angle:135.f];
    [self addPointFrom:8 Radius:1.75f Angle:45.f];
    [self addPointFrom:7 Radius:2.5f Angle:90.f];
    [self addPointFrom:10 Radius:2.5f Angle:0.f];
    [self addPointFrom:11 Radius:2.5f Angle:0.f];
    [self computePoints];

    [self buildHouse:TABULO_PawnFive atPosition:[self getPointAt:0]];
    [self builPillarAtPosition:[self getPointAt:2]];
    [self buildHouse:TABULO_PawnOne atPosition:[self getPointAt:5]];
    [self builPillarAtPosition:[self getPointAt:8]];
    [self builPillarAtPosition:[self getPointAt:10]];
    [self buildHouse:TABULO_PawnFour atPosition:[self getPointAt:12]];
    [self buildBackground];
    
    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnFour = [self buildPawn:TABULO_PawnFour atPosition:[self getPointAt:0]];
    f3ViewAdaptee *pawnFive = [self buildPawn:TABULO_PawnFive atPosition:[self getPointAt:5]];
    f3ViewAdaptee *pawnOne = [self buildPawn:TABULO_PawnOne atPosition:[self getPointAt:12]];

    f3ViewAdaptee *plankOne = [self buildSmallPlank:90.f atPosition:[self getPointAt:4] withHole:0];
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:45.f atPosition:[self getPointAt:9] withHole:0];
    f3ViewAdaptee *plankThree = [self buildMediumPlank:0.f atPosition:[self getPointAt:11] withHole:0];

    [builder buildComposite:0];

    f3GraphNode *nodeA = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeB = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeC = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeD = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeE = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeF = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeG = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeH = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeI = [self buildNode:_producer atPosition:[self getPointAt:8] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeJ = [self buildNode:_producer atPosition:[self getPointAt:9] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeK = [self buildNode:_producer atPosition:[self getPointAt:12] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeL = [self buildNode:_producer atPosition:[self getPointAt:11] withExtend:CGSizeMake(0.75f, 0.75f)];
    f3GraphNode *nodeM = [self buildNode:_producer atPosition:[self getPointAt:10] withExtend:CGSizeMake(0.75f, 0.75f)];
    
    [self clearPoints];

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeA Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeC Target:nodeA];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeD Origin:nodeA Target:nodeF];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeD Origin:nodeF Target:nodeA];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeE Origin:nodeC Target:nodeF];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeE Origin:nodeF Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeG Origin:nodeF Target:nodeI];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeG Origin:nodeI Target:nodeF];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeH Origin:nodeF Target:nodeM];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeH Origin:nodeM Target:nodeF];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeJ Origin:nodeI Target:nodeM];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeJ Origin:nodeM Target:nodeI];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeL Origin:nodeK Target:nodeM];
        [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:nodeL Origin:nodeM Target:nodeK];

        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:0.f Node:nodeF Origin:nodeD Target:nodeH];
        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:135.f Node:nodeF Origin:nodeH Target:nodeD];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeF Origin:nodeG Target:nodeE];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:135.f Node:nodeF Origin:nodeE Target:nodeG];
        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:90.f Node:nodeM Origin:nodeH Target:nodeL];
        [self buildEdgesForPlank:TABULO_HaveMediumPlank Angle:0.f Node:nodeM Origin:nodeL Target:nodeH];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeC Origin:nodeB Target:nodeE];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:90.f Node:nodeC Origin:nodeE Target:nodeB];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:45.f Node:nodeI Origin:nodeG Target:nodeJ];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:135.f Node:nodeI Origin:nodeJ Target:nodeG];
        
        f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initForView:plankOne onNode:nodeE withFlag:TABULO_HaveSmallPlank];
        f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initForView:plankTwo onNode:nodeJ withFlag:TABULO_HaveSmallPlank];
        f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initForView:plankThree onNode:nodeL withFlag:TABULO_HaveMediumPlank];

        [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

        fgDragPawnFromNode *controlPawnFour = [[fgDragPawnFromNode alloc] initForView:pawnFour onNode:nodeA withFlag:TABULO_PawnFour];
        fgDragPawnFromNode *controlPawnFive = [[fgDragPawnFromNode alloc] initForView:pawnFive onNode:nodeF withFlag:TABULO_PawnFive];
        fgDragPawnFromNode *controlPawnOne = [[fgDragPawnFromNode alloc] initForView:pawnOne onNode:nodeK withFlag:TABULO_PawnOne];
        
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFour Home:nodeK]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFive Home:nodeA]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:nodeF]];
    }
}

- (void)loadSceneTemplate {

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
}

@end
