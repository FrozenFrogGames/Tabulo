//
//  fgPawnFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPawnFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3GameScene.h"

@implementation fgPawnFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view Type:(enum f3TabuloPawnType)_type Node:(f3GraphNode *)_node {

    self = [super initWithView:_view];
    
    if (self != nil)
    {
        pawnType = _type;
        pawnNode = _node;
    }
    
    return self;
}

- (f3ViewComposite *)buildFeedbackCompositeFor:(f3ViewComponent *)_component {

    NSArray *edges = [f3GraphEdge edgesFromNode:pawnNode];
    f3ViewComposite *result = [[f3ViewComposite alloc] init];
    f3ViewBuilder *builder = [f3GameDirector Director].Builder;
    
    for (f3GraphEdge *edge in edges)
    {
        if ([edge evaluateConditions])
        {
            [self buildPawn:builder Position:edge.Target.Position Type:pawnType];
            
            [result appendComponent:[builder popComponent]];
        }
    }

    [result appendComponent:_component];

    return result;
}

- (void)buildPawn:(f3ViewBuilder *)_builder Position:(CGPoint)_position Type:(enum f3TabuloPawnType)_type {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                    FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

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
    }
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.4f),nil]];
    [_builder buildProperty:0]; // reduce opacity
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f)
                                         atPoint:CGPointMake(textureCoordonate.x, textureCoordonate.y)
                                      withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpriteSheet]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [_builder buildDecorator:1];
}

@end
