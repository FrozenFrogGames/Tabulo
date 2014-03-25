//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgGameState.h"
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

@implementation fgGameState

const NSUInteger LEVEL_MAXIMUM = 18;
const NSUInteger LEVEL_LOCKED = 19;

enum TabuloLevelState {

    LEVELSTATE_unlocked,
    LEVELSTATE_locked,
    LEVELSTATE_bronze,
    LEVELSTATE_silver,
    LEVELSTATE_gold
};

- (id)init {

    self = [super init];

    if (self != nil)
    {
        currentScene = nil;
        gameLevel = 0;
        goldPathLength = 0;
        solutions = nil;
        hintEnable = true;
        hintLayer = nil;
        hintCommand = nil;
    }

    return self;
}

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level {

    self = [super init];

    if (self != nil)
    {
        currentScene = _scene;
        gameLevel = _level;
        goldPathLength = 0;
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

    if (goldPathLength == 0 || pathLength < goldPathLength)
    {
        goldPathLength = pathLength;
    }

    [solutions addObject:_config];
}

- (void)buildMenu:(f3ViewBuilder *)_builder {

    if (currentScene == nil)
    {
        currentScene = [[f3ViewScene alloc] init];
        
        NSUInteger index = 1;
        
        while (index < LEVEL_MAXIMUM)
        {
            float offset = 1.5f -(((index -1) /6) *3.f);
            
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-6.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 6.25f, offset) level:index++];
        }

        [_builder buildComposite:0];
        [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]]; // levels
        
        [self buildHeader:_builder];
        
        [_builder buildComposite:0];
        [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]]; // header
    }
    else
    {
        // throw f3Exception
    }
}

- (void)buildHeader:(f3ViewBuilder *)_builder {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:CGPointMake(0.f, 1216.f) withExtend:CGSizeMake(2048.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:3.f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:4.5f]];
    [_builder buildDecorator:1];
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state atPosition:(CGPoint)_position level:(NSUInteger)_level {
    
    enum TabuloLevelState state = (_level < LEVEL_LOCKED) ? LEVELSTATE_unlocked : LEVELSTATE_locked;
    
    CGPoint coordonatePoint;
    
    switch (state) {
            
        case LEVELSTATE_unlocked:
            coordonatePoint = CGPointMake(768.f, 640.f);
            break;
            
        case LEVELSTATE_locked:
            coordonatePoint = CGPointMake(1088.f, 640.f);
            break;
            
        case LEVELSTATE_bronze:
            coordonatePoint = CGPointMake(768.f, 320.f);
            break;
            
        case LEVELSTATE_silver:
            coordonatePoint = CGPointMake(1088.f, 320.f);
            break;
            
        case LEVELSTATE_gold:
            coordonatePoint = CGPointMake(1408.f, 320.f);
            break;
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:coordonatePoint withExtend:CGSizeMake(320.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
    
    if (_level < LEVEL_LOCKED)
    {
        f3GraphNode *node = [_state buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];
        fgTabuloEvent * event = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
        fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
        [_state appendComponent:[[f3Controller alloc] initState:controlView]];
    }
}

- (void)buildPauseButtton:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position level:(NSUInteger)_level {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:CGPointMake(1920.f, 512.f) withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];

    [_builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];

    f3GraphNode *node = [self buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];
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

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:CGPointMake(1920.f, 256.f) withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
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

    f3GameDirector *director = [f3GameDirector Director];
    f3GameAdaptee *producer = [f3GameAdaptee Producer];

    enum fgTabuloGrade grade = configRevisited ? GRADE_bronze : GRADE_silver;

    if (grade == GRADE_silver)
    {
        if (currentConfig.PathLength == goldPathLength)
        {
            grade = GRADE_gold;
        }
    }

    if (gameLevel < (LEVEL_LOCKED -1))
    {
        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:GAME_Next level:gameLevel grade:grade];
        [producer switchState:dialogState];
    }
    else
    {
        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:GAME_Over level:gameLevel grade:grade];
        [producer switchState:dialogState];
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    currentScene = nil;
}

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data {

    return nil;
}

- (fgHouseNode *)buildHouseNode:(CGPoint)_position extend:(CGSize)_extend {

    fgHouseNode *node = [[fgHouseNode alloc] initPosition:_position extend:_extend];

    [keys addObject:node.Key];
    [grid appendNode:node];

    return node;
}

- (void)notifyEvent:(f3GameEvent *)_event {

    if (_event.Event < GAME_EVENT_MAX)
    {
        f3GameDirector *director = [f3GameDirector Director];
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        if ([_event isKindOfClass:[fgTabuloEvent class]])
        {
            fgTabuloEvent * event = (fgTabuloEvent *)_event;

            enum fgTabuloGrade grade = GRADE_none; // TODO obtain previous grade for that level

            fgDialogState *dialogState = [[fgDialogState alloc] init:self];
            [dialogState build:director.Builder event:event.Event level:event.Level grade:grade];
            [producer switchState:dialogState];
        }
        else
        {
            fgGameState *nextState = [[fgGameState alloc] init];
            [nextState buildMenu:director.Builder];
            [producer switchState:nextState];
        }
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
                [currentScene appendComposite:hintLayer];

                f3VectorHandle *targetPoint = [hintEdge.Target getPositionHandle];
                f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];
                f3FloatArray *zoomOut = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:-0.25f], [[NSNumber alloc] initWithFloat:-0.25f], nil];
                f3FloatArray *scale = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:1.f], [[NSNumber alloc] initWithFloat:1.f], nil];
                f3FloatArray *zoomIn = [f3FloatArray buildHandleForFloat32:2, [[NSNumber alloc] initWithFloat:0.25f], [[NSNumber alloc] initWithFloat:0.25f], nil];

                hintCommand = [[f3ControlCommand alloc] init];
                [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomOut speed:0.4f]];
                [hintCommand appendComponent:[[f3TranslationCommand alloc] initWithView:view translation:translation speed:0.2f]];
                [hintCommand appendComponent:[[f3SetOffsetCommand alloc] initWithView:view Offset:targetPoint]];
                [hintCommand appendComponent:[[f3SetScaleCommand alloc] initWithView:view scale:scale]];
                [hintCommand appendComponent:[[f3ZoomCommand alloc] initWithView:view zoom:zoomIn speed:0.2f]];
                [[f3GameAdaptee Producer] appendComponent:hintCommand];
            }
        }
    }
}

@end
