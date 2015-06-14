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
#import "../../../Framework/Framework/Control/f3GameEvent.h"
#import "../../../Framework/Framework/Control/f3GraphPath.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../Control/fgEventOnClick.h"
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
        hintView = nil;
        hintCommand = nil;
        hintEnable = true; // (_level < 7);
    }
    
    return self;
}

- (float)computeScale:(CGSize)_screen unit:(CGSize)_unit {
    
    float resultScale = [super computeScale:_screen unit:_unit];

    if (resultScale > 1.2f)
    {
        resultScale = 1.2f;
    }
    
    return resultScale;
}

- (void)buildLayer:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit {
    
    [super buildLayer:_builder screen:_screen unit:_unit];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(1408.f, 832.f) withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    float iconScale = (_screen.width /10.f /_unit.width);
    float x = (iconScale /2.f) -(_screen.width /2.f /_unit.width);
    float y = (iconScale /2.f) -(_screen.height /2.f /_unit.height);
    
    [_builder push:[f3VectorHandle buildHandleForWidth:iconScale height:iconScale]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:x height:y]];
    [_builder buildDecorator:1];
    
    [interfaceLayer appendComponent:[_builder popComponent]];
    
    f3GraphNode *node = [self buildNode:CGPointMake(x, y) withExtend:CGSizeMake(1.1f, 1.1f) writer:nil symbols:nil];
    fgTabuloEvent *event = [[fgTabuloEvent alloc] init:GAME_Pause level:levelIndex];
    fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
    [self appendGameController:[[f3Controller alloc] initWithState:controlView]];
}
/*
- (void)begin:(f3ControllerState *)_previousState {
    
    if (overlayLayer != nil)
    {
        f3ViewScene *scene = [f3GameDirector Director].Scene;
        
        [scene appendComposite:overlayLayer];
    }
}

- (void)update:(NSTimeInterval)_elapsed {
    
    if (hintView != nil && hintCommand != nil && hintCommand.finished)
    {
        [overlayLayer removeComponent:hintView];
        hintView = nil;
        hintCommand = nil;
    }
}

- (void)end:(f3ControllerState *)_nextState {
    
    if (overlayLayer != nil)
    {
        f3ViewScene *scene = [f3GameDirector Director].Scene;
        
        [scene removeComposite:overlayLayer];
    }
}
 */
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

- (bool)notifyGameEvent:(f3GameEvent *)_event {

    if (_event.Event < GAME_EVENT_MAX)
    {
        fgDialogState *dialogState;
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        if (_event.Event == GAME_Over) // convert GAME_Over into Tabulo's event
        {
            fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

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
        
        if (hintView != nil && hintCommand != nil)
        {
            [interfaceLayer removeComponent:hintView];
            [hintCommand interrupt];
            hintView = nil;
            hintCommand = nil;
        }
        
        [producer loadGameLayer:[f3GameDirector Director].Builder withState:dialogState];

        return TRUE;
    }

    return FALSE;
}

- (void)computeHelpForEdge:(f3GraphEdge *)_edge {
/*
    if (hintView != nil && hintCommand != nil)
    {
        [overlayLayer removeComponent:hintView];
        [hintCommand interrupt];

        hintView = nil;
        hintCommand = nil;
    }

    if (_edge != nil)
    {
        f3GraphNode *originNode = [f3GraphNode nodeForKey:_edge.OriginKey];
        CGPoint originPoint = originNode.Position;
        f3GraphNode *targetNode = [f3GraphNode nodeForKey:_edge.TargetKey];
        f3VectorHandle *targetPoint = [targetNode getPositionHandle];
        
        f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];
        f3FloatArray *zoomOut = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:-0.33f], [[NSNumber alloc] initWithFloat:-0.33f], nil];
        f3FloatArray *scale = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:0.5f], [[NSNumber alloc] initWithFloat:1.f], nil];
        f3FloatArray *zoomIn = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:0.33f], [[NSNumber alloc] initWithFloat:0.33f], nil];
        
        f3ViewBuilder *builder = [[f3GameDirector Director] Builder];
        f3ViewAdaptee *view = [self buildHintcursor:builder atPosition:originPoint];
        
        [builder buildComposite:0];
        hintView = (f3ViewComposite *)[builder popComponent];
        [overlayLayer appendComponent:hintView];
        
        hintCommand = [[f3ControlCommand alloc] init];
        [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomOut speed:0.5f]];
        [hintCommand appendComponent:[[f3TranslationCommand alloc] initWithView:view translation:translation speed:0.33f]];
        [hintCommand appendComponent:[[f3SetOffsetCommand alloc] initWithView:view Offset:targetPoint]];
        [hintCommand appendComponent:[[f3SetScaleCommand alloc] initWithView:view scale:scale]];
        [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomIn speed:0.5f]];
        [self appendGameController:hintCommand];
    }
 */
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
    
    [_builder push:[f3VectorHandle buildHandleForWidth:0.83f height:1.33f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
    
    return view;
}

@end
