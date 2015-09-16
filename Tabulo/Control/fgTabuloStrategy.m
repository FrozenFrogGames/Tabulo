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
#import "../../../Framework/Framework/Control/f3MutableGraphNodeState.h"
#import "../../../Framework/Framework/Control/f3DragOverGraphEdgeState.h"
#import "../../../Framework/Framework/Control/f3DragAroundGraphNodeState.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"
#import "../../../Framework/Framework/Model/f3GraphSchemaMemento.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"
#import "fgHouseNode.h"
#import "fgPawnEdge.h"
#import "fgPlankEdge.h"

@implementation fgTabuloStrategy

- (id)init {
    
    return nil; // TODO throw f3Exception
}

- (id)init:(NSUInteger)_level {
    
    self = [super init];
    
    if (self != nil)
    {
        levelIndex = _level;
        levelGrade = [(fgTabuloDirector *)[f3GameDirector Director] getGradeForLevel:_level];
        hintCommand = nil;
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
    
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:_sprite withExtend:CGSizeMake(128.f, 128.f)]];
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

    f3GraphNode *node = [[f3GraphNode alloc] init:position extend:CGSizeMake(0.5f /_scale, 0.5f/_scale)];
    [self appendTouchListener:node];

    fgTabuloEvent *pauseEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:levelIndex];
    f3EventButtonState *pauseControl = [[f3EventButtonState alloc] initWithNode:node event:pauseEvent];
    [self appendGameController:[[f3Controller alloc] initWithState:pauseControl]];

    position = CGPointMake(((_screen.width /2.f) / (_unit.width *_scale)) - (0.75f /_scale), (0.75f /_scale) - ((_screen.height /2.f) / (_unit.height *_scale)));
    [self buildButton:_builder position:position sprite:CGPointMake(1408.f, 960.f) scale:_scale];

    node = [[f3GraphNode alloc] init:position extend:CGSizeMake(0.5f /_scale, 0.5f/_scale)];
    [self appendTouchListener:node];

    f3CustomEvent *helperEvent = [[f3CustomEvent alloc] init:CUSTOM_Helper];
    f3EventButtonState *helperControl = [[f3EventButtonState alloc] initWithNode:node event:helperEvent];
    [self appendGameController:[[f3Controller alloc] initWithState:helperControl]];

    [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(InterfaceLayer), nil]];
    [_builder buildComposite:1];
}

- (bool)notifyEvent:(f3GameEvent *)_event {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

    if ([_event isKindOfClass:[f3CustomEvent class]])
    {
        if (_event.Event == CUSTOM_Helper)
        {
            [self buildHelperLayer:director.Builder];
            
            id helperLayer = [director.Builder popComponent];
            
            if ([helperLayer isKindOfClass:[f3ViewLayer class]])
            {
                [director.Scene appendLayer:(f3ViewLayer *)helperLayer];
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
            
            if (memento != nil)
            {
                grade = GRADE_bronze;
            }
            else if (graphStepCount > minimumDistanceToGoal)
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

    return [super notifyEvent:_event];
}

+ (void)setPawnAttribute:(f3GraphSchema *)_schema key:(NSNumber *)_key coordonate:(f3FloatArray **)_coordonate {
    
    CGPoint textureCoordonate;
    
    if ([_schema getNodeFlag:_key flag:TABULO_PAWN_Red])
    {
        textureCoordonate = CGPointMake(0.f, 0.f);
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_PAWN_Green])
    {
        textureCoordonate = CGPointMake(0.f, 128.f);
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_PAWN_Blue])
    {
        textureCoordonate = CGPointMake(0.f, 256.f);
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_PAWN_Yellow])
    {
        textureCoordonate = CGPointMake(0.f, 384.f);
    }
    
    (*_coordonate) = [f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1152.f) atPoint:textureCoordonate withExtend:CGSizeMake(128.f, 128.f)];
}

+ (void)setPlankAttribute:(f3GraphSchema *)_schema key:(NSNumber *)_key coordonate:(f3FloatArray **)_coordonate vertex:(f3FloatArray **)_vertex {
    
    float holeOffset = 0.f;
    
    if ([_schema getNodeFlag:_key flag:TABULO_HOLE_Red])
    {
        holeOffset = 432.f;
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_HOLE_Green])
    {
        holeOffset = 688.f;
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_HOLE_Blue])
    {
        holeOffset = 944.f;
    }
    else if ([_schema getNodeFlag:_key flag:TABULO_HOLE_Yellow])
    {
        holeOffset = 1200.f;
    }
    
    if ([_schema getNodeFlag:_key flag:TABULO_PLANK_Small])
    {
        if (holeOffset == 0.f)
        {
            holeOffset = 176.f;
        }
        
        (*_coordonate) = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.444444444f), // 0
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
        
        (*_vertex) = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
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
    else if ([_schema getNodeFlag:_key flag:TABULO_PLANK_Medium])
    {
        if (holeOffset == 0.f)
        {
            holeOffset = 112.f;
        }
        
        (*_coordonate) = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(0.f), FLOAT_BOX(0.666666667f), // 0
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
        
        (*_vertex) = [f3FloatArray buildHandleForFloat32:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
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
        (*_coordonate) = nil;
        (*_vertex) = nil;
    }
}

- (void)buildFeedbackLayer:(f3ViewBuilder *)_builder edges:(NSArray *)_edges {

    if (_edges.count > 0)
    {
        if (hintCommand != nil)
        {
            hintCommand = nil;
        }

        for (f3GraphEdge *edge in _edges)
        {
            if ([edge isKindOfClass:[fgPawnEdge class]])
            {
                [fgTabuloStrategy buildFeedbackPawn:_builder edge:edge schema:graphSchema opacity:0.5f];
            }
            else if ([edge isKindOfClass:[fgPlankEdge class]])
            {
                fgPlankEdge *plankEdge = (fgPlankEdge *)edge;

                [fgTabuloStrategy buildFeedbackPlank:_builder edge:plankEdge schema:graphSchema opacity:0.5f];
            }
        }

        [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(HelperOverlay), nil]];
        [_builder buildComposite:1]; // create feedback layer
    }
}

+ (f3ViewAdaptee *)buildFeedbackPawn:(f3ViewBuilder *)_builder edge:(f3GraphEdge *)_edge schema:(f3GraphSchema *)_schema opacity:(float)_opacity {

    CGPoint position = [f3GraphNode nodeForKey:_edge.TargetKey].Position;
    
    f3FloatArray *coordonateHandle;

    [self setPawnAttribute:_schema key:_edge.OriginKey coordonate:&coordonateHandle];

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = [_builder top];
    if (_opacity < 1.f)
    {
        adaptee.Color = GLKVector4Make(adaptee.Color.r, adaptee.Color.g, adaptee.Color.b, _opacity);
    }
    
    [_builder push:coordonateHandle];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

+ (f3ViewAdaptee *)buildFeedbackPlank:(f3ViewBuilder *)_builder edge:(f3GraphEdgeWithRotationNode *)_edge schema:(f3GraphSchema *)_schema opacity:(float)_opacity {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                     USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                     USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *vertexHandle, *coordonateHandle;
    
    [self setPlankAttribute:_schema key:_edge.OriginKey coordonate:&coordonateHandle vertex:&vertexHandle];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = (f3ViewAdaptee *)[_builder top];
    if (_opacity < 1.f)
    {
        adaptee.Color = GLKVector4Make(adaptee.Color.r, adaptee.Color.g, adaptee.Color.b, _opacity);
    }
    
    [_builder push:coordonateHandle];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];
    
    CGPoint targetPosition = [f3GraphNode nodeForKey:_edge.TargetKey].Position;
    CGPoint rotationPosition = [f3GraphNode nodeForKey:_edge.RotationKey].Position;

    float plankAngle = [f3GraphEdge angleBetween:targetPosition and:rotationPosition];
    
    [_builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(plankAngle), nil]];
    [_builder buildDecorator:3];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:targetPosition.x y:targetPosition.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

- (void)buildHelperLayer:(f3ViewBuilder *)_builder {

    if (hintCommand == nil)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        hintCommand = [[f3ControlSequence alloc] init];
        
        bool bDelayViewVisibility = false;
/*
        while (memento != nil && memento.Schema.DistanceToGoal < graphSchema.DistanceToGoal)
        {
            f3GraphEdge *previousEdge = [graphSchema findEdgeTo:memento.Schema];

            if (previousEdge != nil)
            {
                graphSchema = memento.Schema;
                
                f3Controller *controller = [producer findController:[f3GraphNode nodeForKey:previousEdge.OriginKey]];
                if ([controller.State isKindOfClass:[f3MutableGraphNodeState class]])
                {
                    f3MutableGraphNodeState *state = (f3MutableGraphNodeState *)controller.State;
                    f3GraphNode *node = [f3GraphNode nodeForKey:previousEdge.TargetKey];
                    
                    [controller pushState:[[f3MutableGraphNodeState alloc] initWithNode:node forView:state.View nextState:state.NextState]];
                    [previousEdge buildGraphCommand:producer.Builder view:state.View slowMotion:1.f];
                    
                    f3ControlComponent *action = [producer.Builder popComponent];
                    while (action != nil)
                    {
                        // TODO reverse command for the edge from previous to current schema

                        [hintCommand appendComponent:action];
                        action = [producer.Builder popComponent];
                    }
                    
                    bDelayViewVisibility = true;
                }
                
                memento = (f3GraphSchemaMemento *)memento.Previous;
            }
            else
            {
                break; // fail-safe with f3Exception
            }
        }
 */
        f3GraphEdge *hintEdge = [graphSchema findBestEdge:graphSchema];
        if (hintEdge != nil)
        {
            f3ViewAdaptee *view = nil;
            
            if ([hintEdge isKindOfClass:[fgPawnEdge class]])
            {
                view = [fgTabuloStrategy buildHelperPawn:_builder edge:hintEdge schema:graphSchema opacity:0.8f];
            }
            else if ([hintEdge isKindOfClass:[fgPlankEdge class]])
            {
                f3GraphEdgeWithRotationNode *edgeWithRotation = (f3GraphEdgeWithRotationNode *)hintEdge;
                
                view = [fgTabuloStrategy buildHelperPlank:_builder edge:edgeWithRotation schema:graphSchema opacity:0.8f];
            }
            
            if (view != nil)
            {
                view.IsHidden = bDelayViewVisibility; // delay visibility when rewind is required
                
                [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(HelperOverlay), nil]];
                [_builder buildComposite:1]; // create helper layer with the view to manipulate
                
                [hintEdge buildGraphCommand:producer.Builder view:view slowMotion:2.f];
                
                f3ControlComponent *action = [producer.Builder popComponent];
                while (action != nil)
                {
                    [hintCommand appendComponent:action];

                    action = [producer.Builder popComponent];
                }
            }
        }
        
        [producer appendComponent:hintCommand];
    }
}

+ (f3ViewAdaptee *)buildHelperPawn:(f3ViewBuilder *)_builder edge:(f3GraphEdge *)_edge schema:(f3GraphSchema *)_schema opacity:(float)_opacity {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    f3FloatArray *coordonateHandle;
    [self setPawnAttribute:_schema key:_edge.OriginKey coordonate:&coordonateHandle];
    
    CGPoint originPosition = [f3GraphNode nodeForKey:_edge.OriginKey].Position;

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = [_builder top];
    if (_opacity < 1.f)
    {
        adaptee.Color = GLKVector4Make(adaptee.Color.r, adaptee.Color.g, adaptee.Color.b, _opacity);
    }
    
    [_builder push:coordonateHandle];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:originPosition.x y:originPosition.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

+ (f3ViewAdaptee *)buildHelperPlank:(f3ViewBuilder *)_builder edge:(f3GraphEdgeWithRotationNode *)_edge schema:(f3GraphSchema *)_schema opacity:(float)_opacity {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                     USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                     USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                     USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                     USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                     USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *vertexHandle, *coordonateHandle;
    
    [self setPlankAttribute:_schema key:_edge.OriginKey coordonate:&coordonateHandle vertex:&vertexHandle];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *adaptee = (f3ViewAdaptee *)[_builder top];
    if (_opacity < 1.f)
    {
        adaptee.Color = GLKVector4Make(adaptee.Color.r, adaptee.Color.g, adaptee.Color.b, _opacity);
    }
    
    [_builder push:coordonateHandle];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetLevel]];
    [_builder buildDecorator:4];

    f3GraphNode *originNode = [f3GraphNode nodeForKey:_edge.OriginKey];
    CGPoint originPosition = originNode.Position;
    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:_edge.RotationKey];
    CGPoint rotationPosition = rotationNode.Position;

    float plankAngle = [f3GraphEdge angleBetween:originPosition and:rotationPosition];
    
    [_builder push:[f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(plankAngle), nil]];
    [_builder buildDecorator:3];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:originPosition.x y:originPosition.y]];
    [_builder buildDecorator:1];
    
    return adaptee;
}

@end
