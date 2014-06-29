//
//  fgTabuloEditor.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloScene.h"
#import "../../../Framework/Framework/Control/f3GraphResolver.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "../Control/fgPawnEdge.h"
#import "../Control/fgPlankEdge.h"
#import "../Control/fgLevelState.h"
#import "../fgDataAdapter.h"
#import "../Control/fgDragViewOverEdge.h"

@implementation fgTabuloScene

- (void)buildBackground:(fgTabuloDirector *)_director writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6,
                                     USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    f3FloatArray *coordonateHandle = [f3FloatArray buildHandleForFloat32:8,
                                      FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f),
                                      FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil];
    
    CGSize scale = CGSizeMake(16.f, 12.f);
    CGPoint position = CGPointZero;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_BackgroundLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;

        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_BackgroundLevel]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
    }
}

- (void)buildComposite:(fgTabuloDirector *)_director writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    [_director.Builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_director.Builder popComponent]];
    
    if (_writer != nil)
    {
        [_writer writeMarker:0x0A];
    }
}

- (void)buildDragControl:(fgTabuloDirector *)_director state:(f3GameState *)_state node:(f3GraphNode *)_node view:(f3ViewAdaptee *)_view writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:_node forView:_view nextState:[fgDragViewOverEdge class]];
    
    [_state appendComponent:[[f3Controller alloc] initState:controlPawn]];
    
    if (_writer != nil)
    {
        [_writer writeMarker:0x09];
        uint16_t node0Index = (uint16_t)[_symbols indexOfObject:_node];
        [_writer writeBytes:&node0Index length:sizeof(uint16_t)];
        uint16_t pawnIndex = (uint16_t)[_symbols indexOfObject:_view];
        [_writer writeBytes:&pawnIndex length:sizeof(uint16_t)];
    }
}

- (void)buildPillar:(fgTabuloDirector *)_director node:(f3GraphNode *)_node writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6,
                                     USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8,
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    f3FloatArray *coordonateHandle = [f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f) atPoint:CGPointMake(1664.f, 512.f)
                                                         withExtend:CGSizeMake(384.f, 384.f)];
    
    CGSize scale = CGSizeMake(3.f, 3.f);
    CGPoint position = _node.Position;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_SpritesheetLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;
        
        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
    }
}

- (void)buildHouse:(fgTabuloDirector *)_director node:(fgHouseNode *)_node type:(enum f3TabuloPawnType)_type state:(f3GameState *)_state writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    float houseX1 = (128.f +(_type *384.f)) /2048.f;
    float houseX2 = (512.f +(_type *384.f)) /2048.f;
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:12, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:16, FLOAT_BOX(-1.5f), FLOAT_BOX(1.5f), // 0
                                  FLOAT_BOX(1.5f), FLOAT_BOX(1.5f),
                                  FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 2
                                  FLOAT_BOX(1.5f), FLOAT_BOX(-0.5f),
                                  FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 4
                                  FLOAT_BOX(1.5f), FLOAT_BOX(-0.5f),
                                  FLOAT_BOX(-1.5f), FLOAT_BOX(-1.5f), // 6
                                  FLOAT_BOX(1.5f), FLOAT_BOX(-1.5f), nil];
    
    f3FloatArray *coordonateHandle = [f3FloatArray buildHandleForFloat32:16, FLOAT_BOX(houseX1), FLOAT_BOX(0.f), // 0
                                      FLOAT_BOX(houseX2), FLOAT_BOX(0.f),
                                      FLOAT_BOX(houseX1), FLOAT_BOX(0.222222222f), // 2
                                      FLOAT_BOX(houseX2), FLOAT_BOX(0.222222222f),
                                      FLOAT_BOX(houseX1), FLOAT_BOX(0.222222222f), // 4
                                      FLOAT_BOX(houseX2), FLOAT_BOX(0.222222222f),
                                      FLOAT_BOX(houseX1), FLOAT_BOX(0.333333333f), // 6
                                      FLOAT_BOX(houseX2), FLOAT_BOX(0.333333333f), nil];
    
    CGSize scale = CGSizeMake(1.f, 1.f);
    CGPoint position = _node.Position;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_SpritesheetLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;
        
        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    f3GraphCondition *condition = [[f3GraphCondition alloc] init:_node.Key flag:_type result:true];
    [_state bindCondition:condition]; // each house add its game condition
    [_node bindView:_view type:_type]; // only used for visual feedback on the house
    
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
        
        if (_writer != nil)
        {
            [_writer writeMarker:0x0F];
            
            uint16_t dataLength = sizeof(uint16_t) *2;
            uint16_t *dataArray = malloc(dataLength);
            dataArray[0] = (uint16_t)[_symbols indexOfObject:_node];
            dataArray[1] = (uint16_t)[_symbols indexOfObject:_view];
            [_writer writeBytes:dataArray length:dataLength];
            
            uint8_t dataFlag = _type;
            [_writer writeBytes:&dataFlag length:sizeof(uint8_t)];
            
            free(dataArray);
        }
    }
}

- (f3ViewAdaptee *)buildPawn:(fgTabuloDirector *)_director state:(f3GameState *)_state node:(f3GraphNode *)_node type:(enum f3TabuloPawnType)_type writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    CGPoint textureCoordonate;
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
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6,
                                     USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    f3FloatArray *coordonateHandle = [f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f) atPoint:textureCoordonate withExtend:CGSizeMake(128.f, 128.f)];
    
    CGSize scale = CGSizeMake(1.f, 1.f);
    CGPoint position = _node.Position;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_SpritesheetLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;
        
        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
        
        if (_writer != nil)
        {
            [_writer writeMarker:0x05];
            
            uint16_t dataIndex = (uint16_t)[_symbols indexOfObject:_node];
            [_writer writeBytes:&dataIndex length:sizeof(uint16_t)];
            
            uint8_t dataFlag = _type;
            [_writer writeBytes:&dataFlag length:sizeof(uint8_t)];
        }
    }
    
    [_state setNodeFlag:_node.Key flag:_type value:true];
    
    return _view;
}

- (f3ViewAdaptee *)buildSmallPlank:(fgTabuloDirector *)_director state:(f3GameState *)_state node:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    float holeOffset;
    
    switch (_hole) {
        case TABULO_OneHole_One:
            holeOffset = 432.f;
            break;
        case TABULO_OneHole_Two:
            holeOffset = 688.f;
            break;
        case TABULO_OneHole_Three:
            holeOffset = 944.f;
            break;
        case TABULO_OneHole_Four:
            holeOffset = 1200.f;
            break;
        case TABULO_OneHole_Five:
            holeOffset = 1456.f;
            break;
        default:
            holeOffset = 176.f;
            break;
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                     USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                     USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
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
    
    f3FloatArray *coordonateHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.444444444f), // 0
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
    
    CGSize scale = CGSizeMake(2.f, 1.f);
    CGPoint position = _node.Position;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_SpritesheetLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;

        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];

        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_angle), nil];

    bool haveHole = (_hole != TABULO_HaveSmallPlank && _hole != TABULO_HaveMediumPlank && _hole != TABULO_HaveLongPlank && _hole < TABULO_HOLE_MAX);

    if (_symbols != nil)
    {
        [_symbols addObject:_view];
        
        if (_writer != nil)
        {
            [_writer writeMarker:(haveHole ? 0x07 : 0x06)];

            [angleHandle.Data serialize:_writer];
            
            uint16_t dataIndex = (uint16_t)[_symbols indexOfObject:_node];
            [_writer writeBytes:&dataIndex length:sizeof(uint16_t)];
            
            uint8_t dataPlank = TABULO_HaveSmallPlank;
            [_writer writeBytes:&dataPlank length:sizeof(uint8_t)];

            if (haveHole)
            {
                uint8_t dataHole = _hole;
                [_writer writeBytes:&dataHole length:sizeof(uint8_t)];
            }
        }
    }

    [_state setNodeFlag:_node.Key flag:TABULO_HaveSmallPlank value:true];

    if (haveHole)
    {
        [_state setNodeFlag:_node.Key flag:_hole value:true];
    }

    [builder push:angleHandle];
    [builder buildDecorator:3];
    
    return _view;
}

- (f3ViewAdaptee *)buildMediumPlank:(fgTabuloDirector *)_director state:(f3GameState *)_state node:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    float holeOffset = 112.f;

    switch (_hole) {
        case TABULO_TwoHoles_OneTwo:
        case TABULO_TwoHoles_OneThree:
        case TABULO_TwoHoles_OneFour:
        case TABULO_TwoHoles_OneFive:
        case TABULO_TwoHoles_TwoThree:
        case TABULO_TwoHoles_TwoFour:
        case TABULO_TwoHoles_TwoFive:
        case TABULO_TwoHoles_ThreeFour:
        case TABULO_TwoHoles_ThreeFive:
        case TABULO_TwoHoles_FourFive:
        case TABULO_ThreeHoles_OneTwoThree:
        case TABULO_ThreeHoles_OneTwoFour:
        case TABULO_ThreeHoles_OneTwoFive:
        case TABULO_ThreeHoles_OneThreeFour:
        case TABULO_ThreeHoles_OneThreeFive:
        case TABULO_ThreeHoles_OneFourFive:
        case TABULO_ThreeHoles_TwoThreeFour:
        case TABULO_ThreeHoles_TwoThreeFive:
        case TABULO_ThreeHoles_TwoFourFive:
        case TABULO_ThreeHoles_ThreeFourFire:
        default:
            holeOffset = 112.f;
            break;
    }

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                     USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                     USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
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
    
    f3FloatArray *coordonateHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.f), FLOAT_BOX(0.666666667f), // 0
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
    
    CGSize scale = CGSizeMake(2.f, 1.f);
    CGPoint position = _node.Position;
    
    if (_writer != nil)
    {
        uint8_t dataResource = RESOURCE_SpritesheetLevel;
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)scale.width;
        dataArray[1] = (float)scale.height;
        dataArray[2] = (float)position.x;
        dataArray[3] = (float)position.y;
        
        [_writer writeMarker:0x0E];
        [indicesHandle.Data serialize:_writer];
        [vertexHandle.Data serialize:_writer];
        [coordonateHandle.Data serialize:_writer];
        [_writer writeBytes:&dataResource length:sizeof(uint8_t)];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    f3ViewBuilder *builder = _director.Builder;
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_angle), nil];
    
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[builder top];
    
    [builder push:coordonateHandle];
    [builder push:[_director getResourceIndex:RESOURCE_SpritesheetLevel]];
    [builder buildDecorator:4];
    
    [builder push:angleHandle];
    [builder buildDecorator:3];
    
    [builder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [builder buildDecorator:2];
    
    bool haveHole = (_hole != TABULO_HaveSmallPlank && _hole != TABULO_HaveMediumPlank && _hole != TABULO_HaveLongPlank && _hole < TABULO_HOLE_MAX);
    
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
        
        if (_writer != nil)
        {
            [_writer writeMarker:(haveHole ? 0x07 : 0x06)];

            [angleHandle.Data serialize:_writer];
            
            uint16_t dataIndex = (uint16_t)[_symbols indexOfObject:_node];
            [_writer writeBytes:&dataIndex length:sizeof(uint16_t)];
            
            uint8_t dataFlag = TABULO_HaveMediumPlank;
            [_writer writeBytes:&dataFlag length:sizeof(uint8_t)];
            
            if (haveHole)
            {
                uint8_t dataHole = _hole;
                [_writer writeBytes:&dataHole length:sizeof(uint8_t)];
            }
        }
    }

    [_state setNodeFlag:_node.Key flag:TABULO_HaveMediumPlank value:true];

    if (haveHole)
    {
        [_state setNodeFlag:_node.Key flag:_hole value:true];
    }

    [builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [builder buildDecorator:1];
    
    return _view;
}

- (void)buildEdgesForPawn:(fgTabuloDirector *)_director type:(enum f3TabuloPlankType)_type node:(f3GraphNode *)_node origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    if (_writer != nil)
    {
        uint8_t dataFlag = _type;
        
        if (_symbols != nil)
        {
            uint16_t dataLength = sizeof(uint16_t) *3;
            uint16_t *dataArray = malloc(dataLength);
            dataArray[0] = (uint16_t)[_symbols indexOfObject:_node];
            dataArray[1] = (uint16_t)[_symbols indexOfObject:_origin];
            dataArray[2] = (uint16_t)[_symbols indexOfObject:_target];
            
            [_writer writeMarker:0x10];
            [_writer writeBytes:&dataFlag length:sizeof(uint8_t)];
            [_writer writeBytes:dataArray length:dataLength];
            
            free(dataArray);
        }
    }
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPawnEdge *edge = [[fgPawnEdge alloc] init:pawn origin:_origin target:_target input:_node];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:_type result:true]];
        
        switch (pawn) // restrict edge if a hole is present
        {
            case TABULO_PawnOne:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_OneHole_One result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneTwo result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFive result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                break;
                
            case TABULO_PawnTwo:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_OneHole_Two result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneTwo result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFive result:false]];
    
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                break;
                
            case TABULO_PawnThree:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_OneHole_Three result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFive result:false]];
                
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
                
            case TABULO_PawnFour:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_OneHole_Four result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_FourFive result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
                
            case TABULO_PawnFive:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_OneHole_Five result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_TwoHoles_FourFive result:false]];

                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
        }
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnOne result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnTwo result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnThree result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFive result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFour result:false]];
    }
}

- (void)buildEdgesForPlank:(fgTabuloDirector *)_director type:(enum f3TabuloPlankType)_type node:(f3GraphNode *)_node origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    if (_writer != nil)
    {
        uint8_t dataFlag = _type;
        
        if (_symbols != nil)
        {
            uint16_t dataLength = sizeof(uint16_t) *3;
            uint16_t *dataArray = malloc(dataLength);
            dataArray[0] = (uint16_t)[_symbols indexOfObject:_node];
            dataArray[1] = (uint16_t)[_symbols indexOfObject:_origin];
            dataArray[2] = (uint16_t)[_symbols indexOfObject:_target];
            
            [_writer writeMarker:0x11];
            [_writer writeBytes:&dataFlag length:sizeof(uint8_t)];
            [_writer writeBytes:dataArray length:dataLength];
            
            free(dataArray);
        }
    }

    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPlankEdge *edge = [[fgPlankEdge alloc] init:_type origin:_origin target:_target rotation:_node];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:_type result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:_type result:false]];
    }
}

@end
