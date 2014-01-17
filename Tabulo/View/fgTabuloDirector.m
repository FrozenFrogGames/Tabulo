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

@implementation fgTabuloDirector

- (id)init:(Class )_adapterType {
    
    self = [super init:_adapterType];
    
    if (self != nil)
    {
        levelIndex = 1;

        focusNode = nil;

        gameController = [[fgTabuloController alloc] init];

        indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                        FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
        
        spritesheet = nil;

        background = nil;
    }
    
    return self;
}

- (bool)requestFocus:(f3GraphNode *)_node {
    
    if (focusNode == nil)
    {
        focusNode = _node;

        return true;
    }
    
    if ([focusNode getFlag:TABULO_CirclePawn]   ||
        [focusNode getFlag:TABULO_PentagonPawn] ||
        [focusNode getFlag:TABULO_TrianglePawn] ||
        [focusNode getFlag:TABULO_StarPawn]     ||
        [focusNode getFlag:TABULO_SquarePawn] )
    {
        if ([_node getFlag:TABULO_CirclePawn]     ||
            [_node getFlag:TABULO_PentagonPawn]   ||
            [_node getFlag:TABULO_TrianglePawn]   ||
            [_node getFlag:TABULO_StarPawn]   ||
            [_node getFlag:TABULO_SquarePawn] )
        {
            focusNode = _node;
            
            return true;
        }
    }
    else if ([focusNode getFlag:TABULO_HaveSmallPlank])
    {
        if ([_node getFlag:TABULO_HaveSmallPlank])
        {
            focusNode = _node;
            
            return true;
        }
    }
    else if ([focusNode getFlag:TABULO_HaveMediumPlank])
    {
        if ([_node getFlag:TABULO_HaveMediumPlank])
        {
            focusNode = _node;
            
            return true;
        }
    }
    else if ([focusNode getFlag:TABULO_HaveLongPlank])
    {
        if ([_node getFlag:TABULO_HaveLongPlank])
        {
            focusNode = _node;
            
            return true;
        }
    }
    
    return false;
}

- (bool)releaseFocus:(f3GraphNode *)_node {
    
    if (focusNode == _node)
    {
        focusNode = nil;
        
        return true;
    }
    
    return false;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {
    
    spritesheet = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([_canvas loadRessource:@"spritesheet_high.png"]), nil];
    background = [f3IntegerArray buildHandleForValues:1, USHORT_BOX([_canvas loadRessource:@"background_high.png"]), nil];
}

- (void)loadScene:(f3GameAdaptee *)_producer {

    [_producer removeAllComponents];

    // TODO read local variable and builder instruction from data file

    switch (levelIndex)
    {
        case 1:
            [self loadSceneOne:_producer];
            break;

        case 2:
            [self loadSceneTwo:_producer];
            break;
            
        case 3:
            [self loadSceneThree:_producer];
            break;
    }
    
    [_producer appendComponent:gameController];
}

- (void)nextScene {

    levelIndex = (levelIndex < 3) ? levelIndex +1 : 1;

    [scene removeAllComposites];

    [self loadScene:[f3GameAdaptee Producer]];
}

- (f3FloatArray *)getCoordonate:(CGSize)_spritesheet atPoint:(CGPoint)_position withExtend:(CGSize)_extend {
    
    CGPoint lowerRight = CGPointMake(_position.x + _extend.width, _position.y + _extend.height);
    
    return  [f3FloatArray buildHandleForValues:8, FLOAT_BOX(_position.x / _spritesheet.width), FLOAT_BOX(_position.y / _spritesheet.height),
             FLOAT_BOX(lowerRight.x / _spritesheet.width), FLOAT_BOX(_position.y / _spritesheet.height),
             FLOAT_BOX(_position.x / _spritesheet.width), FLOAT_BOX(lowerRight.y / _spritesheet.height),
             FLOAT_BOX(lowerRight.x / _spritesheet.width), FLOAT_BOX(lowerRight.y / _spritesheet.height), nil];
}

- (void)buildBackground {

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

- (void)builPillarAtPosition:(CGPoint)_position {
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:CGPointMake(1664.f, 384.f)
                           withExtend:CGSizeMake(384.f, 384.f)]];
    [builder push:spritesheet];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
//  [builder push:[f3VectorHandle buildHandleForWidth:2.75f height:2.75f]];
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
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];
}

- (f3ViewAdaptee *)buildPawn:(enum f3TabuloPawnType)_index atPosition:(CGPoint)_position {

    CGPoint position;

    switch (_index) {
        case TABULO_CirclePawn:
            position = CGPointMake(0.f, 0.f);
            break;

        case TABULO_PentagonPawn:
            position = CGPointMake(0.f, 128.f);
            break;

        case TABULO_TrianglePawn:
            position = CGPointMake(0.f, 256.f);
            break;

        case TABULO_StarPawn:
            position = CGPointMake(0.f, 384.f);
            break;

        case TABULO_SquarePawn:
            position = CGPointMake(0.f, 512.f);
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

- (f3ViewAdaptee *)buildPlank:(enum f3TabuloPlankType)_index atPosition:(CGPoint)_position withAngle:(float)_angle {

    float width, scale;
    CGPoint position;

    switch (_index) {
        case TABULO_HaveSmallPlank:
            width = 256.f;
            scale = 1.5f;
            position = CGPointMake(128.f, 384.f);
            break;

        case TABULO_HaveMediumPlank:
            width = 384.f;
            scale = 3.f;
            position = CGPointMake(0.f, 640.f);
            break;

        case TABULO_HaveLongPlank:
            width = 384.f;
            scale = 3.f;
            position = CGPointMake(0.f, 640.f);
            break;
    }

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];

    [builder push:[self getCoordonate:CGSizeMake(2048.f, 896.f)
                              atPoint:position
                           withExtend:CGSizeMake(width, 256.f)]];

    [builder push:spritesheet];
    [builder buildDecorator:4];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForWidth:scale height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];

    return result;
}

- (f3GraphNode *)buildNode:(f3GameAdaptee *)_producer atPosition:(CGPoint)_position withExtend:(CGSize)_extend {
    
    f3GraphNode *node = [[f3GraphNode alloc] initPosition:_position extend:_extend];

    [_producer.Grid appendNode:node];

    return node;
}

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {

    f3ControlHeader *offsetHeader = [[f3ControlHeader alloc] initForType:0];

    for (int pawn = TABULO_CirclePawn; pawn <= TABULO_SquarePawn; ++pawn)
    {
        f3GraphEdge *edge = [[f3GraphEdge alloc] initFromNode:_origin toNode:_target];
        [edge bindControlHeader:offsetHeader];

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin flag:pawn value:true]];

        [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:_type value:true]];

        switch (pawn) // restrict edge if a hole is present
        {
            case TABULO_CirclePawn:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_CircleHole value:false]];
                break;
                
            case TABULO_PentagonPawn:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_PentagonHole value:false]];
                break;

            case TABULO_TrianglePawn:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_TriangleHole value:false]];
                break;

            case TABULO_StarPawn:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_StarHole value:false]];
                break;

            case TABULO_SquarePawn:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:TABULO_SquareHole value:false]];
                break;
        }

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_CirclePawn value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_PentagonPawn value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_TrianglePawn value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_StarPawn value:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:TABULO_SquarePawn value:false]];
    }
}

- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Angle:(float)_angle Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target {
    
    f3ControlHeader *offsetHeader = [[f3ControlHeader alloc] initForType:0];

    f3ControlHeader *angleHeader = [[f3ControlHeader alloc] initForType:1];
    [angleHeader bindModel:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];

    for (int pawn = TABULO_CirclePawn; pawn <= TABULO_SquarePawn; ++pawn)
    {
        f3GraphEdge *edge = [[f3GraphEdge alloc] initFromNode:_origin toNode:_target];
        [edge bindControlHeader:offsetHeader];
        [edge bindControlHeader:angleHeader];

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin flag:_type value:true]];

        [edge bindCondition:[[f3GraphCondition alloc] init:_node flag:pawn value:true]];

        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target flag:_type value:false]];
    }
}

- (void)loadSceneOne:(f3GameAdaptee *)_producer {

    CGPoint pointA = CGPointMake(-3.5f, 0.f);
    CGPoint pointB = CGPointMake(-1.75f, 0.f);
    CGPoint pointC = CGPointMake(0.f, 0.f);
    CGPoint pointD = CGPointMake(1.75f, 0.f);
    CGPoint pointE = CGPointMake(3.5f, 0.f);

    [self builPillarAtPosition:pointA];
    [self builPillarAtPosition:pointC];
    [self buildHouse:TABULO_CirclePawn atPosition:pointE];
    [self buildBackground];

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawn = [self buildPawn:TABULO_CirclePawn atPosition:pointA];
    f3ViewAdaptee *plank = [self buildPlank:TABULO_HaveSmallPlank atPosition:pointB withAngle:0.f];

    [builder buildComposite:0];

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        f3GraphNode *nodeA = [self buildNode:_producer atPosition:pointA withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeB = [self buildNode:_producer atPosition:pointB withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeC = [self buildNode:_producer atPosition:pointC withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeD = [self buildNode:_producer atPosition:pointD withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeE = [self buildNode:_producer atPosition:pointE withExtend:CGSizeMake(0.75f, 0.75f)];

        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeA Target:nodeC];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeB Origin:nodeC Target:nodeA];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeC Target:nodeE];
        [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:nodeD Origin:nodeE Target:nodeC];

        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeC Origin:nodeB Target:nodeD];
        [self buildEdgesForPlank:TABULO_HaveSmallPlank Angle:0.f Node:nodeC Origin:nodeD Target:nodeB];
        
        f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initForView:plank onNode:nodeB withFlag:TABULO_HaveSmallPlank];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlank]];
        
        f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initForView:pawn onNode:nodeA withFlag:TABULO_CirclePawn];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:nodeE]];
    }
    else
    {
        // TODO throw f3Exception
    }
}

- (void)loadSceneTwo:(f3GameAdaptee *)_producer {

    CGPoint pointA = CGPointMake(-5.f, 1.75f);
    CGPoint pointB = CGPointMake(-2.5f, 1.75f);
    CGPoint pointC = CGPointMake(0.f, 1.75f);
    CGPoint pointD = CGPointMake(0.f, 0.f);
    CGPoint pointE = CGPointMake(1.75f, 0.f);
    CGPoint pointF = CGPointMake(0.f, -1.75f);
    CGPoint pointG = CGPointMake(1.75f, -1.75f);
    CGPoint pointH = CGPointMake(3.5f, -1.75f);

    [self buildHouse:TABULO_TrianglePawn atPosition:pointA];
    [self builPillarAtPosition:pointC];
    [self builPillarAtPosition:pointF];
    [self buildHouse:TABULO_PentagonPawn atPosition:pointH];
    [self buildBackground];

    [builder buildComposite:0];

    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background

    f3ViewAdaptee *pentagonPawn = [self buildPawn:TABULO_PentagonPawn atPosition:pointA];
    f3ViewAdaptee *trianglePawn = [self buildPawn:TABULO_TrianglePawn atPosition:pointH];

    f3ViewAdaptee *plankOne = [self buildPlank:TABULO_HaveMediumPlank atPosition:pointB withAngle:0.f];
    f3ViewAdaptee *plankTwo = [self buildPlank:TABULO_HaveSmallPlank atPosition:pointG withAngle:0.f];

    [builder buildComposite:0];

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        f3GraphNode *nodeA = [self buildNode:_producer atPosition:pointA withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeB = [self buildNode:_producer atPosition:pointB withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeC = [self buildNode:_producer atPosition:pointC withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeD = [self buildNode:_producer atPosition:pointD withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeE = [self buildNode:_producer atPosition:pointE withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeF = [self buildNode:_producer atPosition:pointF withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeG = [self buildNode:_producer atPosition:pointG withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeH = [self buildNode:_producer atPosition:pointH withExtend:CGSizeMake(0.75f, 0.75f)];

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
        
        f3DragViewFromNode *controlPentagonPawn = [[f3DragViewFromNode alloc] initForView:pentagonPawn onNode:nodeA withFlag:TABULO_CirclePawn];
        f3DragViewFromNode *controlTrianglePawn = [[f3DragViewFromNode alloc] initForView:trianglePawn onNode:nodeH withFlag:TABULO_CirclePawn];
        
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPentagonPawn Home:nodeH]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlTrianglePawn Home:nodeA]];
    }
}

- (void)loadSceneThree:(f3GameAdaptee *)_producer {
    
    CGPoint pointA = CGPointMake(-4.f,   2.5f);
    CGPoint pointB = CGPointMake(-4.f,   0.75f);
    CGPoint pointC = CGPointMake(-4.f,  -1.0f);
    CGPoint pointD = CGPointMake(-2.25f,  0.75f);
    CGPoint pointE = CGPointMake(-2.25f, -1.0f);
    CGPoint pointF = CGPointMake(-0.5f,  -1.0f);
    CGPoint pointG = CGPointMake( 0.75f, -2.225f);
    CGPoint pointH = CGPointMake( 2.0f,  -1.0f);
    CGPoint pointI = CGPointMake( 2.0f,  -3.45f);
    CGPoint pointJ = CGPointMake( 3.25f, -2.225f);
    CGPoint pointK = CGPointMake( 4.5f,   4.0f);
    CGPoint pointL = CGPointMake( 4.5f,   1.5f);
    CGPoint pointM = CGPointMake( 4.5f,  -1.0f);

    [self buildHouse:TABULO_TrianglePawn atPosition:pointA];
    [self builPillarAtPosition:pointC];
    [self buildHouse:TABULO_CirclePawn atPosition:pointF];
    [self builPillarAtPosition:pointI];
    [self buildHouse:TABULO_SquarePawn atPosition:pointK];
    [self builPillarAtPosition:pointM];
    [self buildBackground];
    
    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *squarePawn = [self buildPawn:TABULO_SquarePawn atPosition:pointA];
    f3ViewAdaptee *trianglePawn = [self buildPawn:TABULO_TrianglePawn atPosition:pointF];
    f3ViewAdaptee *circlePawn = [self buildPawn:TABULO_CirclePawn atPosition:pointK];

    f3ViewAdaptee *plankOne = [self buildPlank:TABULO_HaveSmallPlank atPosition:pointE withAngle:0.f];
    f3ViewAdaptee *plankTwo = [self buildPlank:TABULO_HaveSmallPlank atPosition:pointJ withAngle:45.f];
    f3ViewAdaptee *plankThree = [self buildPlank:TABULO_HaveMediumPlank atPosition:pointL withAngle:90.f];

    [builder buildComposite:0];

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
    {
//      [_producer.Grid sceneDidLoad:scene]; // debug purpose

        f3GraphNode *nodeA = [self buildNode:_producer atPosition:pointA withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeB = [self buildNode:_producer atPosition:pointB withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeC = [self buildNode:_producer atPosition:pointC withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeD = [self buildNode:_producer atPosition:pointD withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeE = [self buildNode:_producer atPosition:pointE withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeF = [self buildNode:_producer atPosition:pointF withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeG = [self buildNode:_producer atPosition:pointG withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeH = [self buildNode:_producer atPosition:pointH withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeI = [self buildNode:_producer atPosition:pointI withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeJ = [self buildNode:_producer atPosition:pointJ withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeK = [self buildNode:_producer atPosition:pointK withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeL = [self buildNode:_producer atPosition:pointL withExtend:CGSizeMake(0.75f, 0.75f)];
        f3GraphNode *nodeM = [self buildNode:_producer atPosition:pointM withExtend:CGSizeMake(0.75f, 0.75f)];

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
        
        f3DragViewFromNode *controlSquarePawn = [[f3DragViewFromNode alloc] initForView:squarePawn onNode:nodeA withFlag:TABULO_SquarePawn];
        f3DragViewFromNode *controlTrianglePawn = [[f3DragViewFromNode alloc] initForView:trianglePawn onNode:nodeF withFlag:TABULO_TrianglePawn];
        f3DragViewFromNode *controlCirclePawn = [[f3DragViewFromNode alloc] initForView:circlePawn onNode:nodeK withFlag:TABULO_CirclePawn];
        
        [gameController appendComponent:[[fgPawnController alloc] initState:controlSquarePawn Home:nodeK]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlTrianglePawn Home:nodeA]];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlCirclePawn Home:nodeF]];
    }
}

@end
