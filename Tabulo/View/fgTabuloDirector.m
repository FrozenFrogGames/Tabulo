//
//  fgTabuloDirector.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "fgViewCanvas.h"
#import "fgLevelState.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3ViewComposite.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3Controller.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"

@implementation fgTabuloDirector

- (id)init:(Class )_adapterType {

    self = [super init:_adapterType];

    if (self != nil)
    {
        gameCanvas = nil;
        spritesheetMenu = nil;
        spritesheetLevel = nil;
        backgroundMenu = nil;
        backgroundLevel = nil;
    }

    return self;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {

    if (gameCanvas == nil && _canvas != nil)
    {
        gameCanvas = (fgViewCanvas *)_canvas;
    }

    spritesheetMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-menu.png"]), nil];
    spritesheetLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-gameplay.png"]), nil];
    backgroundLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-gameplay.png"]), nil];
    backgroundMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-menu.png"]), nil];
}

- (f3IntegerArray *)getResourceIndex:(enum f3TabuloResource)_resource {

    switch (_resource)
    {
        case RESOURCE_SpritesheetMenu: return spritesheetMenu;

        case RESOURCE_SpritesheetLevel: return spritesheetLevel;

        case RESOURCE_BackgroundMenu: return backgroundMenu;
            
        case RESOURCE_BackgroundLevel: return backgroundLevel;
    }
}

- (f3ViewAdaptee *)buildPawn:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    return nil;
}

- (f3ViewAdaptee *)buildSmallPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    return nil;
}

- (f3ViewAdaptee *)buildMediumPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    return nil;
}

- (f3ViewAdaptee *)buildLongPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    return nil;
}

- (f3ControllerState *)buildControlState:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    return nil;
}

- (void)buildController:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
}

- (void)buildComposite:(NSObject<IDataAdapter> *)_data {
    
    [viewBuilder buildComposite:0xFFFF];
}

- (void)buildDecorator:(NSObject<IDataAdapter> *)_data {
    
    [viewBuilder buildDecorator:0xFFFF];
}

- (void)buildProperty:(NSObject<IDataAdapter> *)_data {
    
    [viewBuilder buildProperty:0xFFFF];
}

- (void)buildAdaptee:(NSObject<IDataAdapter> *)_data {
    
    [viewBuilder buildAdaptee:0xFFFF];
}

- (void)buildBackground:(NSObject<IDataAdapter> *)_data {

}

- (void)buildPillard:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols{

}

- (void)buildHouse:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols state:(fgLevelState *)_state {

}

- (void)buildEdgesForPawn:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
}

- (void)buildEdgesForPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
}

- (void)buildScene:(NSObject<IDataAdapter> *)_data state:(fgLevelState *)_state level:(NSUInteger)_level {

    scene = [[f3ViewScene alloc] init];
    
    NSMutableArray *symbols = [NSMutableArray array];
    uint8_t marker = [_data readMarker];

    while (marker != 0xFF)
    {
        switch (marker)
        {
            case 0x00:
                [symbols addObject:[[f3ModelData alloc] init:_data]];
                break;

            case 0x01:
                [symbols addObject:[self buildPawn:_data symbols:symbols]];
                break;
            case 0x02:
                [symbols addObject:[_state buildNodeWithExtend:_data]];
                break;
            case 0x03:
                [symbols addObject:[_state buildNodeWithRadius:_data]];
                break;
            case 0x04:
                [symbols addObject:[_state buildHouseNode:_data]];
                break;
            case 0x05:
                [symbols addObject:[self buildSmallPlank:_data symbols:symbols]];
                break;
            case 0x06:
                [symbols addObject:[self buildMediumPlank:_data symbols:symbols]];
                break;
            case 0x07:
                [symbols addObject:[self buildLongPlank:_data symbols:symbols]];
                break;
            case 0x08:
                [symbols addObject:[self buildControlState:_data symbols:symbols]];
                break;

            case 0x09:
                [self buildController:_data symbols:symbols];
                break;
            case 0x0A:
                [self buildComposite:_data];
                break;
            case 0x0B:
                [self buildDecorator:_data];
                break;
            case 0x0C:
                [self buildProperty:_data];
                break;
            case 0x0D:
                [self buildAdaptee:_data];
                break;
            case 0x0E:
                [self buildBackground:_data];
                break;
            case 0x0F:
                [self buildPillard:_data symbols:symbols];
                break;
            case 0x10:
                [self buildHouse:_data symbols:symbols state:_state];
                break;
            case 0x11:
                [self buildEdgesForPawn:_data symbols:symbols];
                break;
            case 0x12:
                [self buildEdgesForPlank:_data symbols:symbols];
                break;

            case 0x13:
                [scene appendComposite:(f3ViewComposite *)[viewBuilder popComponent]];
                break;
            case 0x14:
                [_state appendComponent:[[f3GameAdaptee Producer].Builder popComponent]];
                break;
                
            // TODO add GraphConfig and GraphResolver
        }

        marker = [_data readMarker];
    }

    [symbols removeAllObjects];
}

/*
- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole1:(int)_hole1 Hole2:(int)_hole2 {

    f3IntegerArray *plankIndices = [f3IntegerArray buildHandleForValues:30, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2),
                                    USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3),
                                    USHORT_BOX(4), USHORT_BOX(5), USHORT_BOX(6),
                                    USHORT_BOX(6), USHORT_BOX(5), USHORT_BOX(7),
                                    USHORT_BOX(8), USHORT_BOX(9), USHORT_BOX(10),
                                    USHORT_BOX(10), USHORT_BOX(9), USHORT_BOX(11),
                                    USHORT_BOX(12), USHORT_BOX(13), USHORT_BOX(14),
                                    USHORT_BOX(14), USHORT_BOX(13), USHORT_BOX(15),
                                    USHORT_BOX(16), USHORT_BOX(17), USHORT_BOX(18),
                                    USHORT_BOX(18), USHORT_BOX(17), USHORT_BOX(19), nil];

    f3FloatArray *plankVertex = [f3FloatArray buildHandleForValues:40, FLOAT_BOX(-1.5f), FLOAT_BOX(0.5f), // 0
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 2
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f), // 4
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f), // 6
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f), // 8
                                 FLOAT_BOX(1.5f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f), // 10
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-1.5f), FLOAT_BOX(-0.5f), // 12
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(0.5f), // 14
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f),
                                 FLOAT_BOX(-0.625f), FLOAT_BOX(-0.5f), // 16
                                 FLOAT_BOX(0.625f), FLOAT_BOX(-0.5f),
                                 FLOAT_BOX(0.625f), FLOAT_BOX(0.5f), // 18
                                 FLOAT_BOX(1.5f), FLOAT_BOX(0.5f), nil];

    float holeOneOffset = (_indexOne == 0) ? 112.f : 176. +(_indexOne *256.f);
    float holeTwoOffset = (_indexTwo == 0) ? 112.f : 176. +(_indexTwo *256.f);

    f3FloatArray *plankCoordonate = [f3FloatArray buildHandleForValues:40, FLOAT_BOX(0.f), FLOAT_BOX(0.71428571f), // 0
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f), // 2
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f), // 4
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(1.f), // 6
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f), // 8
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(0.71428571f), // 10
                                     FLOAT_BOX(0.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX(0.0546875f), FLOAT_BOX(1.f), // 12
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(0.71428571f), // 14
                                     FLOAT_BOX(holeOffset / 2048.f), FLOAT_BOX(1.f),
                                     FLOAT_BOX((holeOffset +160.f) / 2048.f), FLOAT_BOX(1.f), // 16
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(0.71428571f),
                                     FLOAT_BOX(0.1328125f), FLOAT_BOX(1.f), // 18
                                     FLOAT_BOX(0.1875f), FLOAT_BOX(1.f), nil];
    
    [builder push:plankIndices];
    [builder push:plankVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    f3ViewAdaptee *result = (f3ViewAdaptee *)[builder top];
    
    [builder push:plankCoordonate];
    [builder push:[self getResourceIndex:RESOURCE_SpriteSheet]];
    [builder buildDecorator:4];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(_angle), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:_position.x y:_position.y]];
    [builder buildDecorator:1];

    return result;
}

- (void)loadInterfaceTemplate {
    
    CGPoint pointA1 = CGPointMake(-0.5f, 4.75f);
    CGPoint pointB1 = CGPointMake(-5.f, 0.f);
    CGPoint pointC1 = CGPointMake(-0.75f, -0.25f);
    CGPoint pointC2 = CGPointMake(1.75f, -0.25f);
    CGPoint pointC3 = CGPointMake(-0.75f, 2.25f);
    CGPoint pointC4 = CGPointMake(1.75f, 2.25f);
    CGPoint pointC5 = CGPointMake(4.25f, 2.25f);
    CGPoint pointD1 = CGPointMake(6.f, -0.5f);
    CGPoint pointD2 = CGPointMake(4.f, -0.5f);
    CGPoint pointD3 = CGPointMake(6.25f, 2.75f);
    CGPoint pointD4 = CGPointMake(6.25f, 1.25f);
    CGPoint pointE1 = CGPointMake(7.5f, 5.5f);
    CGPoint pointE2 = CGPointMake(7.5f, 4.5f);
    CGPoint pointE3 = CGPointMake(7.5f, 3.5f);
    CGPoint pointE4 = CGPointMake(7.5f, 2.5f);
    CGPoint pointF1 = CGPointMake(7.5f, 1.5f);
    CGPoint pointF2 = CGPointMake(7.5f, 0.5f);
    CGPoint pointF3 = CGPointMake(7.5f, -0.5f);
    CGPoint pointF4 = CGPointMake(7.5f, -1.5f);
    CGPoint pointH1 = CGPointMake(0.f, -4.75f);

    f3IntegerArray *circlesIndices = [[f3IntegerArray alloc] init];
    f3IntegerArray *squareIndices = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *circlesVertex = [f3FloatArray buildHandleForCircle:32 scale:0.5f];
    f3FloatArray *squareVertex = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.7f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:15.0f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA1.x y:pointA1.y]];
    [builder buildDecorator:1]; // panel
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:6.f height:7.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB1.x y:pointB1.y]];
    [builder buildDecorator:1]; // dialog box

    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.6f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC1.x y:pointC1.y]];
    [builder buildDecorator:1]; // level unlock icon
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.6f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC2.x y:pointC2.y]];
    [builder buildDecorator:1]; // level lock icon
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.58824f), FLOAT_BOX(0.35294f), FLOAT_BOX(0.21961f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC3.x y:pointC3.y]];
    [builder buildDecorator:1]; // level bronze icon
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.65882f), FLOAT_BOX(0.65882f), FLOAT_BOX(0.65882f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC4.x y:pointC4.y]];
    [builder buildDecorator:1]; // level silver icon
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.78824f), FLOAT_BOX(0.53725f), FLOAT_BOX(0.06275f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC5.x y:pointC5.y]];
    [builder buildDecorator:1]; // level gold icon
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD1.x y:pointD1.y]];
    [builder buildDecorator:1]; // button play
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD2.x y:pointD2.y]];
    [builder buildDecorator:1]; // button next
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.5f height:1.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD3.x y:pointD3.y]];
    [builder buildDecorator:1]; // button reset

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.5f height:1.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD4.x y:pointD4.y]];
    [builder buildDecorator:1]; // button menu

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE1.x y:pointE1.y]];
    [builder buildDecorator:1]; // star empty

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.58824f), FLOAT_BOX(0.35294f), FLOAT_BOX(0.21961f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE2.x y:pointE2.y]];
    [builder buildDecorator:1]; // star bronze
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.65882f), FLOAT_BOX(0.65882f), FLOAT_BOX(0.65882f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE3.x y:pointE3.y]];
    [builder buildDecorator:1]; // star silver

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.78824f), FLOAT_BOX(0.53725f), FLOAT_BOX(0.06275f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE4.x y:pointE4.y]];
    [builder buildDecorator:1]; // star gold

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointF1.x y:pointF1.y]];
    [builder buildDecorator:1]; // button undo
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointF2.x y:pointF2.y]];
    [builder buildDecorator:1]; // button pause
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointF3.x y:pointF3.y]];
    [builder buildDecorator:1]; // sound on
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointF4.x y:pointF4.y]];
    [builder buildDecorator:1]; // sound off
    
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:16.0f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointH1.x y:pointH1.y]];
    [builder buildDecorator:1]; // header

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]];
}

- (void)loadGameplaySpritesheet {

    CGPoint pointA1 = CGPointMake(-7.5f, 5.5f);
    CGPoint pointA2 = CGPointMake(-7.5f, 4.5f);
    CGPoint pointA3 = CGPointMake(-7.5f, 3.5f);
    CGPoint pointA4 = CGPointMake(-7.5f, 2.5f);
    CGPoint pointA5 = CGPointMake(-7.5f, 1.5f);
    CGPoint pointB1 = CGPointMake(-5.5f, 4.5f);
    CGPoint pointB2 = CGPointMake(-2.5f, 4.5f);
    CGPoint pointB3 = CGPointMake( 0.5f, 4.5f);
    CGPoint pointB4 = CGPointMake( 3.5f, 4.5f);
    CGPoint pointB5 = CGPointMake( 6.5f, 4.5f);
    CGPoint pointE1 = CGPointMake( 6.5f, 1.5f);
    CGPoint pointC0 = CGPointMake(-6.0f, 2.0f);
    CGPoint pointD0 = CGPointMake(-6.5f, 0.0f);
    CGPoint pointC1 = CGPointMake(-4.0f, 2.0f);
    CGPoint pointD1 = CGPointMake(-4.0f, 0.0f);
    CGPoint pointC2 = CGPointMake(-2.0f, 2.0f);
    CGPoint pointD2 = CGPointMake(-2.0f, 0.0f);
    CGPoint pointC3 = CGPointMake( 0.0f, 2.0f);
    CGPoint pointD3 = CGPointMake( 0.0f, 0.0f);
    CGPoint pointC4 = CGPointMake( 2.0f, 2.0f);
    CGPoint pointD4 = CGPointMake( 2.0f, 0.0f);
    CGPoint pointC5 = CGPointMake( 4.0f, 2.0f);
    CGPoint pointD5 = CGPointMake( 4.0f, 0.0f);

    f3IntegerArray *circlesIndices = [[f3IntegerArray alloc] init];
    f3IntegerArray *squareIndices = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *circlesVertex = [f3FloatArray buildHandleForCircle:32 scale:0.5f];
    f3FloatArray *squareVertex = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                    FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    // pawn
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA1.x y:pointA1.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA2.x y:pointA2.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA3.x y:pointA3.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA4.x y:pointA4.y]];
    [builder buildDecorator:1];
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.5f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointA5.x y:pointA5.y]];
    [builder buildDecorator:1];
    
    // house
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB1.x y:pointB1.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB1.x y:pointB1.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB2.x y:pointB2.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB2.x y:pointB2.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB3.x y:pointB3.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB3.x y:pointB3.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB4.x y:pointB4.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB4.x y:pointB4.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB5.x y:pointB5.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.5f), FLOAT_BOX(0.f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointB5.x y:pointB5.y]];
    [builder buildDecorator:1];
    
    // pillar
    [builder push:circlesIndices];
    [builder push:[f3FloatArray buildHandleForCircle:8 scale:0.5f]];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3FloatArray buildHandleForValues:1, FLOAT_BOX(22.5f), nil]];
    [builder buildDecorator:3];
    [builder push:[f3VectorHandle buildHandleForWidth:2.75f height:2.75f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointE1.x y:pointE1.y]];
    [builder buildDecorator:1];

    // small plank
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.5f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC0.x y:pointC0.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC1.x y:pointC1.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC1.x y:pointC1.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC2.x y:pointC2.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC2.x y:pointC2.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC3.x y:pointC3.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC3.x y:pointC3.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC4.x y:pointC4.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC4.x y:pointC4.y]];
    [builder buildDecorator:1];
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC5.x y:pointC5.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), FLOAT_BOX(0.75f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointC5.x y:pointC5.y]];
    [builder buildDecorator:1];
    
    // medium plank
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:3.0f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD0.x y:pointD0.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD1.x y:pointD1.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD1.x y:pointD1.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD2.x y:pointD2.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD2.x y:pointD2.y]];
    [builder buildDecorator:1];
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD3.x y:pointD3.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD3.x y:pointD3.y]];
    [builder buildDecorator:1];

    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD4.x y:pointD4.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD4.x y:pointD4.y]];
    [builder buildDecorator:1];
    
    [builder push:circlesIndices];
    [builder push:circlesVertex];
    [builder buildAdaptee:DRAW_TRIANGLE_FAN];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(1.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), nil]];
    [builder buildProperty:1];
    [builder push:[f3VectorHandle buildHandleForWidth:1.15625f height:1.15625f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD5.x y:pointD5.y]];
    [builder buildDecorator:1];
    [builder push:squareIndices];
    [builder push:squareVertex];
    [builder buildAdaptee:DRAW_TRIANGLES];
    [builder push:[f3FloatArray buildHandleForValues:3, FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), nil]];
    [builder buildProperty:1];
    [builder buildDecorator:4];
    [builder push:[f3VectorHandle buildHandleForWidth:1.25f height:1.25f]];
    [builder buildDecorator:2];
    [builder push:[f3VectorHandle buildHandleForX:pointD5.x y:pointD5.y]];
    [builder buildDecorator:1];

    [builder buildComposite:0];
    
    [scene appendComposite:(f3ViewComposite *)[builder popComponent]];
}
 */
@end
