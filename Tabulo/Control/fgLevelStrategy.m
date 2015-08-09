//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevelStrategy.h"
#import "fgMenuState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3ZoomCommand.h"
#import "../../../Framework/Framework/Control/f3EventButtonState.h"
#import "../../../Framework/Framework/Control/f3ActionEvent.h"
#import "../../../Framework/Framework/Control/f3GraphPath.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"
#import "fgHouseNode.h"

@implementation fgLevelStrategy

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

- (void)buildSceneLayer:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit scale:(float)_scale {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(1408.f, 832.f) withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    float x = (0.75f /_scale) - ((_screen.width /2.f) / (_unit.width *_scale));
    float y = (0.75f /_scale) - ((_screen.height /2.f) / (_unit.height *_scale));

    [_builder push:[f3VectorHandle buildHandleForWidth:(1.25f /_scale) height:(1.25f /_scale)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:x height:y]];
    [_builder buildDecorator:1];
    
    f3GraphNode *node = [self buildNode:CGPointMake(x, y) withExtend:CGSizeMake(0.5f /_scale, 0.5f/_scale) writer:nil symbols:nil];
    fgTabuloEvent *event = [[fgTabuloEvent alloc] init:GAME_Pause level:levelIndex];
    f3EventButtonState *controlView = [[f3EventButtonState alloc] initWithNode:node event:event];

    [self appendGameController:[[f3Controller alloc] initWithState:controlView]];
    
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
    
    [keys addObject:node.Key];
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
    
    [keys addObject:node.Key];
    [self appendTouchListener:node];
    
    if (_symbols != nil)
    {
        [_symbols addObject:node];
    }
    
    return node;
}

- (bool)notifyEvent:(f3GameEvent *)_event {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

    if ([_event isKindOfClass:[f3ActionEvent class]])
    {
        f3ActionEvent *actionEvent = (f3ActionEvent *)_event;
        
        if (hintCommand == actionEvent.Action)
        {
            [director.Scene removeLayerAtIndex:HelperOverlay];

            hintCommand = nil;
            
            return TRUE;
        }
    }
    
    if (_event.Event < GAME_EVENT_MAX)
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

    f3GraphEdge *hintEdge = [currentPath findBestEdge:self keys:keys];
    if (hintEdge != nil)
    {
        f3GraphNode *originNode = [f3GraphNode nodeForKey:hintEdge.OriginKey];
        CGPoint originPoint = originNode.Position;
        f3GraphNode *targetNode = [f3GraphNode nodeForKey:hintEdge.TargetKey];
        f3VectorHandle *targetPoint = [targetNode getPositionHandle];

        f3ViewAdaptee *view = [self buildHintcursor:_builder atPosition:originPoint];
        [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(HelperOverlay), nil]];
        [_builder buildComposite:1]; // create helper layer with the view to manipulate

        [hintCommand interrupt]; // cancel previous command if any

        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        hintCommand = [[f3ControlCommand alloc] init];
        [producer appendComponent:hintCommand]; // push command that will manipulate the view

        f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];
        [hintCommand appendComponent:[[f3TranslationCommand alloc] initWithView:view translation:translation speed:0.5f]];
        [hintCommand appendComponent:[[f3SetOffsetCommand alloc] initWithView:view Offset:targetPoint]];
    }
    else
    {
        f3ViewScene *scene = [f3GameDirector Director].Scene;
        
        [hintCommand interrupt];

        [scene removeLayerAtIndex:HelperOverlay];
        
        hintCommand = nil;
    }
}

- (f3ViewAdaptee *)buildHintcursor:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *view = (f3ViewAdaptee *)[_builder top];
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(1600.f, 1216.f) withExtend:CGSizeMake(64.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:0.8f height:1.f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
    
    return view;
}

@end
