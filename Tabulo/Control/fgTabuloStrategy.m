//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloStrategy.h"
#import "fgMenuState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3ZoomCommand.h"
#import "../../../Framework/Framework/Control/f3EventButtonState.h"
#import "../../../Framework/Framework/Control/f3ActionEvent.h"
#import "../../../Framework/Framework/Control/f3CustomEvent.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"
#import "fgHouseNode.h"
#import "fgPawnEdge.h"
#import "fgPlankEdge.h"
#import "fgPawnFeedbackCommand.h"
#import "fgPlankFeedbackCommand.h"

@implementation fgTabuloStrategy

- (id)init {
    
    return nil;
}

- (id)init:(NSUInteger)_level {
    
    self = [super init];
    
    if (self != nil)
    {
        levelIndex = _level;
        levelGrade = [(fgTabuloDirector *)[f3GameDirector Director] getGradeForLevel:_level];
        hintCommand = nil;
        hintEnable = false; // (_level < 7);
    }
    
    return self;
}

- (float)computeUnitScale:(CGSize)_screen unit:(CGSize)_unit {
    
    float resultScale = [super computeUnitScale:_screen unit:_unit];

    if (resultScale > 1.25f)
    {
        resultScale = 1.25f;
    }
    
    return resultScale;
}

- (void)buildButton:(f3ViewBuilder *)_builder position:(CGPoint)_position sprite:(CGPoint)_sprite scale:(float)_scale  {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:_sprite withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(1.25f /_scale) height:(1.25f /_scale)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildSceneLayer:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit scale:(float)_scale {

    CGPoint position = CGPointMake((0.75f /_scale) - ((_screen.width /2.f) / (_unit.width *_scale)), (0.75f /_scale) - ((_screen.height /2.f) / (_unit.height *_scale)));
    [self buildButton:_builder position:position sprite:CGPointMake(1408.f, 832.f) scale:_scale];

    f3GraphNode *node = [self buildNode:position withExtend:CGSizeMake(0.5f /_scale, 0.5f/_scale) writer:nil symbols:nil];
    fgTabuloEvent *pauseEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:levelIndex];
    f3EventButtonState *pauseControl = [[f3EventButtonState alloc] initWithNode:node event:pauseEvent];
    [self appendGameController:[[f3Controller alloc] initWithState:pauseControl]];

    position = CGPointMake((2.125f /_scale) - ((_screen.width /2.f) / (_unit.width *_scale)), (0.75f /_scale) - ((_screen.height /2.f) / (_unit.height *_scale)));
    [self buildButton:_builder position:position sprite:CGPointMake(1408.f, 960.f) scale:_scale];

    node = [self buildNode:position withExtend:CGSizeMake(0.5f /_scale, 0.5f/_scale) writer:nil symbols:nil];
    f3CustomEvent *helperEvent = [[f3CustomEvent alloc] init:CUSTOM_Helper];
    f3EventButtonState *helperControl = [[f3EventButtonState alloc] initWithNode:node event:helperEvent];
    [self appendGameController:[[f3Controller alloc] initWithState:helperControl]];

    [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(InterfaceLayer), nil]];
    [_builder buildComposite:1];
}

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    uint16_t dataLength = sizeof(float) *4;
    float *dataArray = malloc(dataLength);
    
    [_data readBytes:dataArray length:dataLength];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);
    CGSize extend = CGSizeMake(dataArray[2], dataArray[3]);
    
    fgHouseNode *node = [[fgHouseNode alloc] initPosition:position extend:extend];
    
    if (minimumDistanceToGoal == UINT8_MAX)
    {
        [keys addObject:node.Key];
    }

    [self appendTouchListener:node];
    
    free(dataArray);
    
    if (_symbols != nil)
    {
        [_symbols addObject:node];
    }
    
    return node;
}

- (fgHouseNode *)buildHouseNode:(CGPoint)_position extend:(CGSize)_extend writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols {
    
    if (_writer != nil)
    {
        uint16_t dataLength = sizeof(float) *4;
        float *dataArray = malloc(dataLength);
        dataArray[0] = (float)_position.x;
        dataArray[1] = (float)_position.y;
        dataArray[2] = (float)_extend.width;
        dataArray[3] = (float)_extend.height;
        
        [_writer writeMarker:0x04];
        [_writer writeBytes:dataArray length:dataLength];
        
        free(dataArray);
    }
    
    fgHouseNode *node = [[fgHouseNode alloc] initPosition:_position extend:_extend];
    
    if (minimumDistanceToGoal == UINT8_MAX)
    {
        [keys addObject:node.Key];
    }

    [self appendTouchListener:node];
    
    if (_symbols != nil)
    {
        [_symbols addObject:node];
    }
    
    return node;
}

- (bool)notifyEvent:(f3GameEvent *)_event {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

    if ([_event isKindOfClass:[f3CustomEvent class]])
    {
        if (_event.Event == CUSTOM_Helper)
        {
            if (hintCommand == nil)
            {
                [self buildHelperLayer:director.Builder];
                
                id helperLayer = [director.Builder popComponent];
                
                if ([helperLayer isKindOfClass:[f3ViewLayer class]])
                {
                    [director.Scene appendLayer:(f3ViewLayer *)helperLayer];
                }
            }
        }
        
        return TRUE;
    }
    
    else if ([_event isKindOfClass:[f3ActionEvent class]])
    {
        f3ActionEvent *actionEvent = (f3ActionEvent *)_event;

        if (hintCommand == actionEvent.Action)
        {
            [director.Scene removeLayerAtIndex:HelperOverlay];

            hintCommand = nil;
        }
        
        return TRUE;
    }
    
    else if (_event.Event < GAME_EVENT_MAX)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        fgDialogState *dialogState;

        if (_event.Event == GAME_Over) // convert GAME_Over into Tabulo's event
        {
            enum fgTabuloGrade grade = GRADE_gold;
            
            if (graphPathCount > greaterDistanceToGoal)
            {
                grade = GRADE_bronze;
            }
            else if (graphPathCount > minimumDistanceToGoal)
            {
                grade = GRADE_silver;
            }
            
            if (grade > levelGrade)
            {
                [director setGrade:grade level:levelIndex];
                
                levelGrade = grade;
            }
            
            if ([director isLevelLocked:levelIndex+1])
            {
                dialogState = [[fgDialogState alloc] initWithEvent:[[fgTabuloEvent alloc] init:GAME_Over level:levelIndex]];
            }
            else
            {
                dialogState = [[fgDialogState alloc] initWithEvent:[[fgTabuloEvent alloc] init:GAME_Next level:levelIndex]];
            }
        }
        else if ([_event isKindOfClass:[fgTabuloEvent class]])
        {
            dialogState = [[fgDialogState alloc] initWithEvent:(fgTabuloEvent *)_event];
        }
        else
        {
            dialogState = [[fgDialogState alloc] initWithEvent:[[fgTabuloEvent alloc] init:_event.Event level:levelIndex]];
        }
        
        if (hintCommand != nil)
        {
            [director.Scene removeLayerAtIndex:HelperOverlay];
        }
        
        [producer buildScene:director.Builder state:dialogState];

        return TRUE;
    }

    return FALSE;
}

- (void)buildHelperLayer:(f3ViewBuilder *)_builder {

    f3GraphEdge *hintEdge = [graphSchema findBestEdge:self keys:keys];
    if (hintEdge != nil)
    {
        f3ViewAdaptee *view = nil;

        if ([hintEdge isKindOfClass:[fgPawnEdge class]])
        {
            f3GraphNode *originNode = [f3GraphNode nodeForKey:hintEdge.OriginKey];
    
            view = [fgTabuloStrategy buildPawn:_builder node:originNode strategy:self opacity:0.6f];
        }
        else if ([hintEdge isKindOfClass:[fgPlankEdge class]])
        {
            f3GraphEdgeWithRotationNode *edgeWithRotation = (f3GraphEdgeWithRotationNode *)hintEdge;

            view = [fgTabuloStrategy buildPlank:_builder edge:edgeWithRotation strategy:self opacity:0.6f];
        }

        [hintCommand interrupt]; // cancel previous command if not nil

        if (view != nil)
        {
            [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(HelperOverlay), nil]];
            [_builder buildComposite:1]; // create helper layer with the view to manipulate

            f3GameAdaptee *producer = [f3GameAdaptee Producer];
            hintCommand = [[f3ControlCommand alloc] init];
            [producer appendComponent:hintCommand]; // push command that will manipulate the view
            
            [hintEdge buildGraphCommand:producer.Builder view:view slowMotion:2.f];

            f3ControlComponent *action = [producer.Builder popComponent];
            while (action != nil)
            {
                [hintCommand appendComponent:action];
                
                action = [producer.Builder popComponent];
            }
        }
    }
    else
    {
        f3ViewScene *scene = [f3GameDirector Director].Scene;
        
        [hintCommand interrupt];

        [scene removeLayerAtIndex:HelperOverlay];
        
        hintCommand = nil;
    }
}

+ (f3ViewAdaptee *)buildPawn:(f3ViewBuilder *)_builder node:(f3GraphNode *)_node strategy:(f3GraphNodeStrategy *)_strategy opacity:(float)_opacity {
    
    NSNumber *nodeKey = _node.Key;
    CGPoint textureCoordonate;
    
    if ([_strategy getNodeFlag:nodeKey flag:TABULO_PawnOne])
    {
        textureCoordonate = CGPointMake(0.f, 0.f);
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_PawnTwo])
    {
        textureCoordonate = CGPointMake(0.f, 128.f);
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_PawnThree])
    {
        textureCoordonate = CGPointMake(0.f, 256.f);
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_PawnFour])
    {
        textureCoordonate = CGPointMake(0.f, 384.f);
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_PawnFive])
    {
        textureCoordonate = CGPointMake(0.f, 512.f);
    }
    else
    {
        return nil; // TODO throw f3Exception
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = [_builder top];
    
    if (_opacity < 1.f)
    {
        [_builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_opacity),nil]];
        [_builder buildProperty:0];
    }
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1152.f) atPoint:textureCoordonate withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:_node.Position.x y:_node.Position.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

+ (f3ViewAdaptee *)buildPlank:(f3ViewBuilder *)_builder edge:(f3GraphEdgeWithRotationNode *)_edge strategy:(f3GraphNodeStrategy *)_strategy opacity:(float)_opacity {

    NSNumber *nodeKey = _edge.OriginKey;

    float holeOffset = 0.f;

    if ([_strategy getNodeFlag:nodeKey flag:TABULO_OneHole_One])
    {
        holeOffset = 432.f;
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_OneHole_Two])
    {
        holeOffset = 688.f;
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_OneHole_Three])
    {
        holeOffset = 944.f;
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_OneHole_Four])
    {
        holeOffset = 1200.f;
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_OneHole_Five])
    {
        holeOffset = 1456.f;
    }

    f3FloatArray *vertexHandle, *coordonateHandle;

    if ([_strategy getNodeFlag:nodeKey flag:TABULO_HaveSmallPlank])
    {
        if (holeOffset == 0.f)
        {
            holeOffset = 176.f;
        }

        coordonateHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.444444444f), // 0
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

        vertexHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
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
    }
    else if ([_strategy getNodeFlag:nodeKey flag:TABULO_HaveMediumPlank])
    {
        if (holeOffset == 0.f)
        {
            holeOffset = 112.f;
        }

        coordonateHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.f), FLOAT_BOX(0.666666667f), // 0
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
        
        vertexHandle = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
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
    }
    else
    {
        return nil; // TODO throw f3Exception
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                     USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                     USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = (f3ViewAdaptee *)[_builder top];
    
    if (_opacity < 1.f)
    {
        [_builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(_opacity),nil]];
        [_builder buildProperty:0];
    }
    
    [_builder push:coordonateHandle];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];

    f3GraphNode *originNode = [f3GraphNode nodeForKey:nodeKey];
    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:_edge.RotationKey];
    
    float plankAngle = [f3GraphEdge computeAngleBetween:originNode.Position and:rotationNode.Position];    
    
    [_builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(plankAngle), nil]];
    [_builder buildDecorator:3];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:originNode.Position.x y:originNode.Position.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

@end
