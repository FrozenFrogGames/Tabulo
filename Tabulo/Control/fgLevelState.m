//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevelState.h"
#import "fgMenuState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3ZoomCommand.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../Control/fgEventOnClick.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"
#import "fgHouseNode.h"

@implementation fgLevelState

- (id)init {

    return nil;
}

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level {

    self = [super init];

    if (self != nil)
    {
        currentScene = _scene;
        levelIndex = _level;
        levelGrade = [(fgTabuloDirector *)[f3GameDirector Director] getGradeForLevel:_level];
        minimumPathLength = 0;
        solutions = nil;
        hintEnable = true;
        hintLayer = nil;
        hintCommand = nil;
    }

    return self;
}

- (void)bindSolution:(f3GraphConfig *)_config {

    if (solutions == nil)
    {
        solutions = [NSMutableArray array];
    }
    
    NSUInteger pathLength = _config.PathLength;

    if (minimumPathLength == 0 || pathLength < minimumPathLength)
    {
        minimumPathLength = pathLength;
    }

    [solutions addObject:_config];
}

- (void)buildPauseButtton:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position level:(NSUInteger)_level {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(1408.f, 832.f) withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];

    [_builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];

    f3GraphNode *node = [self buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f) writer:nil symbols:nil];
    fgTabuloEvent *event = [[fgTabuloEvent alloc] init:GAME_Pause level:_level];
    fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
    [self appendComponent:[[f3Controller alloc] initState:controlView]];
}

- (f3ViewAdaptee *)buildHintcursor:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *view = (f3ViewAdaptee *)[_builder top];

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(1600.f, 1216.f) withExtend:CGSizeMake(64.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:0.83f height:1.33f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
    
    return view;
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {
    
    if (currentScene != nil)
    {
        [[f3GameDirector Director] loadScene:currentScene];
    }
}

- (void)onGameOver:(f3Controller *)_owner {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    f3GameAdaptee *producer = [f3GameAdaptee Producer];

    enum fgTabuloGrade grade = configRevisited ? GRADE_bronze : GRADE_silver;

    if (grade == GRADE_silver)
    {
        if (currentConfig.PathLength == minimumPathLength)
        {
            grade = GRADE_gold;
        }
    }

    if (grade > levelGrade)
    {
        [director setGrade:grade level:levelIndex];
        
        levelGrade = grade;
    }

    if (levelIndex < 18)
    {
        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:GAME_Next level:levelIndex grade:grade];
        [producer switchState:dialogState];
    }
    else
    {
        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:GAME_Over level:levelIndex grade:grade];
        [producer switchState:dialogState];
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    currentScene = nil;
}

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    uint16_t dataLength = sizeof(float) *4;
    float *dataArray = malloc(dataLength);

    [_data readBytes:dataArray length:dataLength];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);
    CGSize extend = CGSizeMake(dataArray[2], dataArray[3]);
    
    fgHouseNode *node = [[fgHouseNode alloc] initPosition:position extend:extend];

    [keys addObject:node.Key];
    [grid appendNode:node];

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
    [grid appendNode:node];
    
    if (_symbols != nil)
    {
        [_symbols addObject:node];
    }

    return node;
}

- (void)notifyEvent:(f3GameEvent *)_event {

    if (hintCommand != nil)
    {
        [[f3GameAdaptee Producer] removeComponent:hintCommand];
        hintCommand = nil; // action interrupted
    }
    
    if (hintLayer != nil)
    {
        [hintLayer removeAllComponents];
        [currentScene removeComposite:hintLayer];
        hintLayer = nil;
    }

    if (_event.Event < GAME_EVENT_MAX)
    {
        f3GameDirector *director = [f3GameDirector Director];
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:_event.Event level:levelIndex grade:levelGrade];
        [producer switchState:dialogState];
    }
    else
    {
        [super notifyEvent:_event];
    }
}

- (void)onActionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {
    
    if (_action == hintCommand)
    {
        hintCommand = nil;

        if (hintLayer != nil)
        {
            [hintLayer removeAllComponents];
            [currentScene removeComposite:hintLayer];
            hintLayer = nil;
        }
    }
    else
    {
        [super onActionCompleted:_action owner:_owner];
    }
}

- (f3GraphEdge *)findEdgeFor:(f3GraphConfig *)_current next:(f3GraphConfig *)_next {

    for (NSNumber *key in keys)
    {
        NSArray *currentEdges = [f3GraphEdge edgesFromNode:key];
        
        for (f3GraphEdge *edge in currentEdges)
        {
            if ([edge evaluateConditions:_current keys:keys])
            {
                f3GraphConfig *config = [[f3GraphConfig alloc] init:keys previous:_current event:[edge buildGraphEvent]];
                
                if ([config isEqual:_next])
                {
                    return edge;
                }
            }
        }
    }

    return nil;
}

- (void)onConfigChanged:(f3GraphConfig *)_config {

    if (hintEnable)
    {
        if (hintCommand != nil)
        {
            [controls removeComponent:hintCommand];
            hintCommand = nil;
        }

        if (hintLayer != nil)
        {
            [hintLayer removeAllComponents];
            [currentScene removeComposite:hintLayer];
            hintLayer = nil;
        }

        f3GraphConfig *nextConfig = nil;

        if (initialConfig == _config)
        {
            if ([solutions count] > 0)
            {
                nextConfig = [solutions objectAtIndex:0];
            }
        }
        else
        {
            for (f3GraphConfig *solution in solutions)
            {
                nextConfig = solution;

                while (nextConfig != nil)
                {
                    bool configFound = [_config isEqual:nextConfig];
                    nextConfig = [nextConfig Next];
                    if (configFound) break;
                }
                
                if (nextConfig != nil)
                {
//                  NSLog(@"target config:%@", nextConfig);
                    break;
                }
            }
        }

        if (nextConfig != nil)
        {
            hintEdge = [self findEdgeFor:_config next:nextConfig];

            if (hintEdge != nil)
            {
                CGPoint originPoint = hintEdge.Origin.Position;
                f3ViewBuilder *builder = [[f3GameDirector Director] Builder];
                f3ViewAdaptee *view = [self buildHintcursor:builder atPosition:originPoint];
                [builder buildComposite:0];
                hintLayer = (f3ViewComposite *)[builder popComponent];
                [[f3GameDirector Director].Scene appendComposite:hintLayer];

                f3VectorHandle *targetPoint = [hintEdge.Target getPositionHandle];
                f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];
                f3FloatArray *zoomOut = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:-0.33f], [[NSNumber alloc] initWithFloat:-0.33f], nil];
                f3FloatArray *scale = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:0.5f], [[NSNumber alloc] initWithFloat:1.f], nil];
                f3FloatArray *zoomIn = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:0.33f], [[NSNumber alloc] initWithFloat:0.33f], nil];

                hintCommand = [[f3ControlCommand alloc] init];
                [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomOut speed:0.5f]];
                [hintCommand appendComponent:[[f3TranslationCommand alloc] initWithView:view translation:translation speed:0.33f]];
                [hintCommand appendComponent:[[f3SetOffsetCommand alloc] initWithView:view Offset:targetPoint]];
                [hintCommand appendComponent:[[f3SetScaleCommand alloc] initWithView:view scale:scale]];
                [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomIn speed:0.5f]];
                [[f3GameAdaptee Producer] appendComponent:hintCommand];
            }
        }
    }
}

@end
