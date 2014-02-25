//
//  fgPlankFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "fgTabuloEdge.h"

@implementation fgPlankFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view Type:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node {

    self = [super initWithView:_view];
    
    if (self != nil)
    {
        plankType = _type;
        plankNode = _node;
    }
    
    return self;
}

- (f3ViewComposite *)buildFeedbackCompositeFor:(f3ViewComponent *)_component {
    
    NSArray *edges = [f3GraphEdge edgesFromNode:plankNode];
    f3ViewComposite *result = [[f3ViewComposite alloc] init];
    f3ViewBuilder *builder = [f3GameDirector Director].Builder;

    for (fgTabuloEdge *edge in edges)
    {
        if ([edge evaluateConditions])
        {
            NSArray *controlHeaders = [edge getControlHeaders];
            if ([controlHeaders count] > 0)
            {
                float targetAngle = [[[controlHeaders objectAtIndex:0] getModel:0] float32Value];

                switch (plankType) {
        
                    case TABULO_HaveSmallPlank:
                        [self buildSmallPlank:builder Position:edge.Target.Position Angle:targetAngle];
                        break;
                        
                    case TABULO_HaveMediumPlank:
                        [self buildMediumPlank:builder Position:edge.Target.Position Angle:targetAngle];
                        break;
                        
                    case TABULO_HaveLongPlank:
                        // TODO support long plank
                        break;
                }
                
                [result appendComponent:[builder popComponent]];
            }
        }
    }
    
    [result appendComponent:_component];
    
    return result;
}

- (void)buildSmallPlank:(f3ViewBuilder *)_builder Position:(CGPoint)_position Angle:(float)_angle {

    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];

    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.f), // 0
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

    float holeOffset = 176.f; // TODO support hole

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.0625f), FLOAT_BOX(0.42857143f), // 0
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(0.0625f), FLOAT_BOX(0.71428571f), // 2
                                     FLOAT_BOX(0.0859375f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.42857143f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.42857143f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.42857143f),
                                     FLOAT_BOX(0.1640625f), FLOAT_BOX(0.71428571f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f), nil];

    [_builder push:plankIndices];
    [_builder push:plankVertex];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.4f),nil]];
    [_builder buildProperty:0]; // reduce opacity

    [_builder push:plankCoordonate];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpriteSheet]];
    [_builder buildDecorator:4];

    [_builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [_builder buildDecorator:3];

    [_builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildMediumPlank:(f3ViewBuilder *)_builder Position:(CGPoint)_position Angle:(float)_angle {
    
    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:18, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11), nil];
    
    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(-0.5f), FLOAT_BOX(-1.5f), // 0
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

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:24, FLOAT_BOX(0.f), FLOAT_BOX(0.71428571f), // 0
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f), // 2
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(0.71428571f), // 4
                                     FLOAT_BOX(0.07813f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f), // 6
                                     FLOAT_BOX(0.07813f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(1.f), // 10
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(1.f), nil];

    [_builder push:plankIndices];
    [_builder push:plankVertex];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(0.4f),nil]];
    [_builder buildProperty:0]; // reduce opacity

    [_builder push:plankCoordonate];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpriteSheet]];
    [_builder buildDecorator:4];

    [_builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [_builder buildDecorator:3];

    [_builder push:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [_builder buildDecorator:1];
}

@end
