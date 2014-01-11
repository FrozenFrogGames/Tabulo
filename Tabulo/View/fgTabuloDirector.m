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
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
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
        gameController = [[fgTabuloController alloc] init];
        displayFirstScene = true;
    }
    
    return self;
}

- (bool)requestFocus:(f3GraphNode *)_node {
    
    if (focusNode == nil)
    {
        focusNode = _node;

        return true;
    }
    
    if ([focusNode getFlag:TABULO_HavePawn])
    {
        if ([_node getFlag:TABULO_HavePawn])
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

- (void)loadScene:(f3GameDirector *)_director producer:(f3GameAdaptee *)_producer {

    [_producer removeAllComponents];

    // TODO read local variable and builder instruction from data file

    if (displayFirstScene)
    {
        [self loadFirstScene:_director producer:_producer];
    }
    else
    {
        [self loadSecondScene:_director producer:_producer];
    }
    
    [_producer appendComponent:gameController];
}

- (void)nextScene {
    
    [scene removeAllComposites];
    
    displayFirstScene = !displayFirstScene;
    
    [self loadScene:self producer:[f3GameAdaptee Producer]];
}

- (void)loadFirstScene:(f3GameDirector *)_director producer:(f3GameAdaptee *)_producer {

    f3IntegerArray *indicesHandle = [[f3IntegerArray alloc] init]; // nil
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForCircle:8];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForX:-3.f y:0.f]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];

    vertexHandle = [f3FloatArray buildHandleForCircle:32];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForX:3.f y:0.f]];
    [builder buildDecorator:1];

    indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:3.f y:0.f]];
    [builder buildDecorator:1];

    [builder buildComposite:0];
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // background layer

    indicesHandle = [[f3IntegerArray alloc] init]; // nil
    vertexHandle = [f3FloatArray buildHandleForCircle:32];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];

    f3ViewAdaptee *pawn = (f3ViewAdaptee *)[builder popComponent];
    pawn.Color = GLKVector4Make(0.f, 0.f, 1.f, 1.f);
    [builder push:pawn];

    [builder push:[f3VectorHandle buildHandleForX:-3.f y:0.f]];
    [builder buildDecorator:1];

    indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *plank = (f3ViewAdaptee *)[builder popComponent];
    plank.Color = GLKVector4Make(0.f, 0.f, 1.f, 1.f);
    [builder push:plank];

    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:-0.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:-1.5f y:0.f]];
    [builder buildDecorator:1];

    [builder buildComposite:0];

//  [_producer.Grid sceneDidLoad:_director.Scene]; // debug purpose

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // foreground layer
    {
        f3GraphNode *nodeA = [[f3GraphNode alloc] initPosition:CGPointMake(-3.f, 0.f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeA];

        f3GraphNode *nodeB = [[f3GraphNode alloc] initPosition:CGPointMake(-1.5f, 0.f) extend:CGSizeMake(0.75f, 0.75f)];
        f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initForAdaptee:plank onNode:nodeB withFlag:TABULO_HaveSmallPlank];
        [_producer.Grid appendNode:nodeB];
        [_producer appendComponent:[[f3Controller alloc] initState:controlPlank]];

        f3GraphNode *nodeC = [[f3GraphNode alloc] initPosition:CGPointMake(0.f, 0.f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeC];
        
        f3GraphNode *nodeD = [[f3GraphNode alloc] initPosition:CGPointMake(1.5f, 0.f) extend:CGSizeMake(0.75f, 0.75f)];
        [_producer.Grid appendNode:nodeD];

        f3GraphNode *nodeE = [[f3GraphNode alloc] initPosition:CGPointMake(3.f, 0.f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeE];

        f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initForAdaptee:pawn onNode:nodeA withFlag:TABULO_HavePawn];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:nodeE]];

        f3GraphEdge *edgeAC = [[f3GraphEdge alloc] initFromNode:nodeA toNode:nodeC];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:edgeAC.Origin flag:TABULO_HavePawn value:true]];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:edgeAC.Target flag:TABULO_HavePawn value:false]];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:nodeB flag:TABULO_HaveSmallPlank value:true]];

        f3GraphEdge *edgeCA = [[f3GraphEdge alloc] initFromNode:nodeC toNode:nodeA];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:edgeCA.Origin flag:TABULO_HavePawn value:true]];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:edgeCA.Target flag:TABULO_HavePawn value:false]];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:nodeB flag:TABULO_HaveSmallPlank value:true]];

        f3GraphEdge *edgeCE = [[f3GraphEdge alloc] initFromNode:nodeC toNode:nodeE];
        [edgeCE bindCondition:[[f3GraphCondition alloc] init:edgeCE.Origin flag:TABULO_HavePawn value:true]];
        [edgeCE bindCondition:[[f3GraphCondition alloc] init:edgeCE.Target flag:TABULO_HavePawn value:false]];
        [edgeCE bindCondition:[[f3GraphCondition alloc] init:nodeD flag:TABULO_HaveSmallPlank value:true]];

        f3GraphEdge *edgeEC = [[f3GraphEdge alloc] initFromNode:nodeE toNode:nodeC];
        [edgeEC bindCondition:[[f3GraphCondition alloc] init:edgeEC.Origin flag:TABULO_HavePawn value:true]];
        [edgeEC bindCondition:[[f3GraphCondition alloc] init:edgeEC.Target flag:TABULO_HavePawn value:false]];
        [edgeEC bindCondition:[[f3GraphCondition alloc] init:nodeD flag:TABULO_HaveSmallPlank value:true]];

        f3ControlHeader *offsetHeaderA = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderA bindParam:[nodeA getPositionHandle]];
        [edgeCA bindControlHeader:offsetHeaderA];

        f3ControlHeader *offsetHeaderC = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderC bindParam:[nodeC getPositionHandle]];
        [edgeAC bindControlHeader:offsetHeaderC];
        [edgeEC bindControlHeader:offsetHeaderC];

        f3ControlHeader *offsetHeaderE = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderE bindParam:[nodeE getPositionHandle]];
        [edgeCE bindControlHeader:offsetHeaderE];

        f3GraphEdge *edgeBD = [[f3GraphEdge alloc] initFromNode:nodeB toNode:nodeD];
        [edgeBD bindCondition:[[f3GraphCondition alloc] init:edgeBD.Origin flag:TABULO_HaveSmallPlank value:true]];
        [edgeBD bindCondition:[[f3GraphCondition alloc] init:edgeBD.Target flag:TABULO_HaveSmallPlank value:false]];
        [edgeBD bindCondition:[[f3GraphCondition alloc] init:nodeC flag:TABULO_HavePawn value:true]];

        f3GraphEdge *edgeDB = [[f3GraphEdge alloc] initFromNode:nodeD toNode:nodeB];
        [edgeDB bindCondition:[[f3GraphCondition alloc] init:edgeDB.Origin flag:TABULO_HaveSmallPlank value:true]];
        [edgeDB bindCondition:[[f3GraphCondition alloc] init:edgeDB.Target flag:TABULO_HaveSmallPlank value:false]];
        [edgeDB bindCondition:[[f3GraphCondition alloc] init:nodeC flag:TABULO_HavePawn value:true]];

        f3ControlHeader *offsetHeaderD = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderD bindParam:[nodeD getPositionHandle]];
        [edgeBD bindControlHeader:offsetHeaderD];

        f3ControlHeader *offsetHeaderB = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderB bindParam:[nodeB getPositionHandle]];
        [edgeDB bindControlHeader:offsetHeaderB];
    }
    else
    {
        // TODO throw f3Exception
    }
}

- (void)loadSecondScene:(f3GameDirector *)_director producer:(f3GameAdaptee *)_producer {

    f3IntegerArray *indicesHandle = [[f3IntegerArray alloc] init]; // nil
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForCircle:32];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForX:-3.6f y:1.5f]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForX:3.6f y:-1.5f]];
    [builder buildDecorator:1];
        
    vertexHandle = [f3FloatArray buildHandleForCircle:8];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForX:0.6f y:1.5f]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForX:0.6f y:-1.5f]];
    [builder buildDecorator:1];
    
    indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:-3.6f y:1.5f]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:0.75f height:0.75f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:3.6f y:-1.5f]];
    [builder buildDecorator:1];

    [builder buildComposite:0];
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // background layer

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *smallPlank = (f3ViewAdaptee *)[builder popComponent];
    smallPlank.Color = GLKVector4Make(0.f, 0.5f, 0.f, 1.f);
    [builder push:smallPlank];

    [builder push:[f3VectorHandle buildHandleForWidth:0.7f height:-0.5f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForX:2.1f y:-1.5f]];
    [builder buildDecorator:1];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *mediumPlank = (f3ViewAdaptee *)[builder popComponent];
    mediumPlank.Color = GLKVector4Make(0.f, 0.5f, 0.f, 1.f);
    [builder push:mediumPlank];

    [builder push:[f3VectorHandle buildHandleForWidth:1.9f height:-0.5f]];
    [builder buildDecorator:2];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForX:-1.5f y:1.5f]];
    [builder buildDecorator:1];
    
    indicesHandle = [[f3IntegerArray alloc] init]; // nil
    vertexHandle = [f3FloatArray buildHandleForCircle:32];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    
    f3ViewAdaptee *bluePawn = (f3ViewAdaptee *)[builder popComponent];
    bluePawn.Color = GLKVector4Make(0.f, 0.f, 1.f, 1.f);
    [builder push:bluePawn];
    
    [builder push:[f3VectorHandle buildHandleForX:-3.6f y:1.5f]];
    [builder buildDecorator:1];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    
    f3ViewAdaptee *redPawn = (f3ViewAdaptee *)[builder popComponent];
    redPawn.Color = GLKVector4Make(1.f, 0.f, 0.f, 1.f);
    [builder push:redPawn];
    
    [builder push:[f3VectorHandle buildHandleForX:3.6f y:-1.5f]];
    [builder buildDecorator:1];
    
    [builder buildComposite:0];

//  [_producer.Grid sceneDidLoad:_director.Scene]; // debug purpose

    if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // foreground layer
    {
        f3GraphNode *nodeA = [[f3GraphNode alloc] initPosition:CGPointMake(-3.6f, 1.5f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeA];

        f3GraphNode *nodeB = [[f3GraphNode alloc] initPosition:CGPointMake(-1.5f, 1.5f) extend:CGSizeMake(0.75f, 0.75f)];
        f3DragViewFromNode *controlMediumPlank = [[f3DragViewFromNode alloc] initForAdaptee:mediumPlank onNode:nodeB withFlag:TABULO_HaveMediumPlank];
        [_producer.Grid appendNode:nodeB];
        [_producer appendComponent:[[f3Controller alloc] initState:controlMediumPlank]];

        f3GraphNode *nodeC = [[f3GraphNode alloc] initPosition:CGPointMake(0.6f, 1.5f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeC];

        f3GraphNode *nodeD = [[f3GraphNode alloc] initPosition:CGPointMake(0.6f, 0.f) extend:CGSizeMake(0.75f, 0.75f)];
        [_producer.Grid appendNode:nodeD];

        f3GraphNode *nodeE = [[f3GraphNode alloc] initPosition:CGPointMake(2.1f, 0.f) extend:CGSizeMake(0.75f, 0.75f)];
        [_producer.Grid appendNode:nodeE];

        f3GraphNode *nodeF = [[f3GraphNode alloc] initPosition:CGPointMake(0.6f, -1.5f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeF];

        f3GraphNode *nodeG = [[f3GraphNode alloc] initPosition:CGPointMake(2.1f, -1.5f) extend:CGSizeMake(0.75f, 0.75f)];
        f3DragViewFromNode *controlSmallPlank = [[f3DragViewFromNode alloc] initForAdaptee:smallPlank onNode:nodeG withFlag:TABULO_HaveSmallPlank];
        [_producer.Grid appendNode:nodeG];
        [_producer appendComponent:[[f3Controller alloc] initState:controlSmallPlank]];

        f3GraphNode *nodeH = [[f3GraphNode alloc] initPosition:CGPointMake(3.6f, -1.5f) extend:CGSizeMake(0.6f, 0.6f)];
        [_producer.Grid appendNode:nodeH];

        f3DragViewFromNode *controlBluePawn = [[f3DragViewFromNode alloc] initForAdaptee:bluePawn onNode:nodeA withFlag:TABULO_HavePawn];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlBluePawn Home:nodeH]];

        f3DragViewFromNode *controlRedPawn = [[f3DragViewFromNode alloc] initForAdaptee:redPawn onNode:nodeH withFlag:TABULO_HavePawn];
        [gameController appendComponent:[[fgPawnController alloc] initState:controlRedPawn Home:nodeA]];

        f3GraphEdge *edgeAC = [[f3GraphEdge alloc] initFromNode:nodeA toNode:nodeC];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:edgeAC.Origin flag:TABULO_HavePawn value:true]];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:edgeAC.Target flag:TABULO_HavePawn value:false]];
        [edgeAC bindCondition:[[f3GraphCondition alloc] init:nodeB flag:TABULO_HaveMediumPlank value:true]];

        f3GraphEdge *edgeCA = [[f3GraphEdge alloc] initFromNode:nodeC toNode:nodeA];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:edgeCA.Origin flag:TABULO_HavePawn value:true]];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:edgeCA.Target flag:TABULO_HavePawn value:false]];
        [edgeCA bindCondition:[[f3GraphCondition alloc] init:nodeB flag:TABULO_HaveMediumPlank value:true]];

        f3GraphEdge *edgeCH = [[f3GraphEdge alloc] initFromNode:nodeC toNode:nodeH];
        [edgeCH bindCondition:[[f3GraphCondition alloc] init:edgeCH.Origin flag:TABULO_HavePawn value:true]];
        [edgeCH bindCondition:[[f3GraphCondition alloc] init:edgeCH.Target flag:TABULO_HavePawn value:false]];
        [edgeCH bindCondition:[[f3GraphCondition alloc] init:nodeE flag:TABULO_HaveMediumPlank value:true]];

        f3GraphEdge *edgeHC = [[f3GraphEdge alloc] initFromNode:nodeH toNode:nodeC];
        [edgeHC bindCondition:[[f3GraphCondition alloc] init:edgeHC.Origin flag:TABULO_HavePawn value:true]];
        [edgeHC bindCondition:[[f3GraphCondition alloc] init:edgeHC.Target flag:TABULO_HavePawn value:false]];
        [edgeHC bindCondition:[[f3GraphCondition alloc] init:nodeE flag:TABULO_HaveMediumPlank value:true]];

        f3GraphEdge *edgeCF = [[f3GraphEdge alloc] initFromNode:nodeC toNode:nodeF];
        [edgeCF bindCondition:[[f3GraphCondition alloc] init:edgeCF.Origin flag:TABULO_HavePawn value:true]];
        [edgeCF bindCondition:[[f3GraphCondition alloc] init:edgeCF.Target flag:TABULO_HavePawn value:false]];
        [edgeCF bindCondition:[[f3GraphCondition alloc] init:nodeD flag:TABULO_HaveSmallPlank value:true]];
        
        f3GraphEdge *edgeFC = [[f3GraphEdge alloc] initFromNode:nodeF toNode:nodeC];
        [edgeFC bindCondition:[[f3GraphCondition alloc] init:edgeFC.Origin flag:TABULO_HavePawn value:true]];
        [edgeFC bindCondition:[[f3GraphCondition alloc] init:edgeFC.Target flag:TABULO_HavePawn value:false]];
        [edgeFC bindCondition:[[f3GraphCondition alloc] init:nodeD flag:TABULO_HaveSmallPlank value:true]];
        
        f3GraphEdge *edgeFH = [[f3GraphEdge alloc] initFromNode:nodeF toNode:nodeH];
        [edgeFH bindCondition:[[f3GraphCondition alloc] init:edgeFH.Origin flag:TABULO_HavePawn value:true]];
        [edgeFH bindCondition:[[f3GraphCondition alloc] init:edgeFH.Target flag:TABULO_HavePawn value:false]];
        [edgeFH bindCondition:[[f3GraphCondition alloc] init:nodeG flag:TABULO_HaveSmallPlank value:true]];
        
        f3GraphEdge *edgeHF = [[f3GraphEdge alloc] initFromNode:nodeH toNode:nodeF];
        [edgeHF bindCondition:[[f3GraphCondition alloc] init:edgeHF.Origin flag:TABULO_HavePawn value:true]];
        [edgeHF bindCondition:[[f3GraphCondition alloc] init:edgeHF.Target flag:TABULO_HavePawn value:false]];
        [edgeHF bindCondition:[[f3GraphCondition alloc] init:nodeG flag:TABULO_HaveSmallPlank value:true]];

        f3ControlHeader *offsetHeaderA = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderA bindParam:[nodeA getPositionHandle]];
        [edgeCA bindControlHeader:offsetHeaderA];

        f3ControlHeader *offsetHeaderC = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderC bindParam:[nodeC getPositionHandle]];
        [edgeAC bindControlHeader:offsetHeaderC];
        [edgeHC bindControlHeader:offsetHeaderC];
        [edgeFC bindControlHeader:offsetHeaderC];

        f3ControlHeader *offsetHeaderF = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderF bindParam:[nodeF getPositionHandle]];
        [edgeCF bindControlHeader:offsetHeaderF];
        [edgeHF bindControlHeader:offsetHeaderF];

        f3ControlHeader *offsetHeaderH = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderH bindParam:[nodeH getPositionHandle]];
        [edgeCH bindControlHeader:offsetHeaderH];
        [edgeFH bindControlHeader:offsetHeaderH];

        f3GraphEdge *edgeBE = [[f3GraphEdge alloc] initFromNode:nodeB toNode:nodeE];
        [edgeBE bindCondition:[[f3GraphCondition alloc] init:edgeBE.Origin flag:TABULO_HaveMediumPlank value:true]];
        [edgeBE bindCondition:[[f3GraphCondition alloc] init:edgeBE.Target flag:TABULO_HaveMediumPlank value:false]];
        [edgeBE bindCondition:[[f3GraphCondition alloc] init:nodeC flag:TABULO_HavePawn value:true]];

        f3GraphEdge *edgeEB = [[f3GraphEdge alloc] initFromNode:nodeE toNode:nodeB];
        [edgeEB bindCondition:[[f3GraphCondition alloc] init:edgeEB.Origin flag:TABULO_HaveMediumPlank value:true]];
        [edgeEB bindCondition:[[f3GraphCondition alloc] init:edgeEB.Target flag:TABULO_HaveMediumPlank value:false]];
        [edgeEB bindCondition:[[f3GraphCondition alloc] init:nodeC flag:TABULO_HavePawn value:true]];

        f3GraphEdge *edgeDG = [[f3GraphEdge alloc] initFromNode:nodeD toNode:nodeG];
        [edgeDG bindCondition:[[f3GraphCondition alloc] init:edgeDG.Origin flag:TABULO_HaveSmallPlank value:true]];
        [edgeDG bindCondition:[[f3GraphCondition alloc] init:edgeDG.Target flag:TABULO_HaveSmallPlank value:false]];
        [edgeDG bindCondition:[[f3GraphCondition alloc] init:nodeF flag:TABULO_HavePawn value:true]];

        f3GraphEdge *edgeGD = [[f3GraphEdge alloc] initFromNode:nodeG toNode:nodeD];
        [edgeGD bindCondition:[[f3GraphCondition alloc] init:edgeGD.Origin flag:TABULO_HaveSmallPlank value:true]];
        [edgeGD bindCondition:[[f3GraphCondition alloc] init:edgeGD.Target flag:TABULO_HaveSmallPlank value:false]];
        [edgeGD bindCondition:[[f3GraphCondition alloc] init:nodeF flag:TABULO_HavePawn value:true]];

        f3ControlHeader *offsetHeaderB = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderB bindParam:[nodeB getPositionHandle]];
        f3ControlHeader *angleHeaderB = [[f3ControlHeader alloc] initForType:1];
        [angleHeaderB bindParam:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.f), nil]];
        [edgeEB bindControlHeader:offsetHeaderB];
        [edgeEB bindControlHeader:angleHeaderB];

        f3ControlHeader *offsetHeaderD = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderD bindParam:[nodeD getPositionHandle]];
        f3ControlHeader *angleHeaderD = [[f3ControlHeader alloc] initForType:1];
        [angleHeaderD bindParam:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(90.f), nil]];
        [edgeGD bindControlHeader:offsetHeaderD];
        [edgeGD bindControlHeader:angleHeaderD];

        f3ControlHeader *offsetHeaderE = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderE bindParam:[nodeE getPositionHandle]];
        f3ControlHeader *angleHeaderE = [[f3ControlHeader alloc] initForType:1];
        [angleHeaderE bindParam:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(135.f), nil]];
        [edgeBE bindControlHeader:offsetHeaderE];
        [edgeBE bindControlHeader:angleHeaderE];

        f3ControlHeader *offsetHeaderG = [[f3ControlHeader alloc] initForType:0];
        [offsetHeaderG bindParam:[nodeG getPositionHandle]];
        f3ControlHeader *angleHeaderG = [[f3ControlHeader alloc] initForType:1];
        [angleHeaderG bindParam:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.f), nil]];
        [edgeDG bindControlHeader:offsetHeaderG];
        [edgeDG bindControlHeader:angleHeaderG];
    }
}

@end
