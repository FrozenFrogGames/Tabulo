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
#import "../../../Framework/Framework/View/f3AngleDecorator.h"
#import "../../../Framework/Framework/View/f3ViewSearch.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3Controller.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/Control/f3GraphConfig.h"
#import "../Control/fgDragViewOverEdge.h"
#import "../Control/fgHouseNode.h"
#import "../Control/fgPawnEdge.h"
#import "../Control/fgPlankEdge.h"
#import "../fgDataAdapter.h"

@interface __LevelFlags : NSObject

@property enum fgTabuloGrade Grade;

- (id)init;
- (id)init:(NSObject<IDataAdapter> *)_data;
- (void)serialize:(NSObject<IDataAdapter> *)_data;

@end // private class only used to resolve graph

@implementation __LevelFlags

@synthesize Grade;

- (id)init {

    self = [super init];
    
    if (self != nil)
    {
        Grade = GRADE_none;
    }
    
    return self;
}

- (id)init:(NSObject<IDataAdapter> *)_data {

    self = [super init];
    
    if (self != nil)
    {
        uint8_t data = 0xff;

        [_data readBytes:&data length:sizeof(uint8_t)];
    
        switch (data & 0x03)
        {
            case 3: Grade = GRADE_none;
                break;
            case 2: Grade = GRADE_bronze;
                break;
            case 1: Grade = GRADE_silver;
                break;
            case 0: Grade = GRADE_gold;
                break;
        }
    }

    return self;
}

- (void)serialize:(NSObject<IDataAdapter> *)_data {

    uint8_t data;

    switch (Grade) {

        case GRADE_none:
            data = 0x03;
            break;

        case GRADE_bronze:
            data = 0x02;
            break;

        case GRADE_silver:
            data = 0x01;
            break;

        case GRADE_gold:
            data = 0x00;
            break;
    }

    [_data writeBytes:&data length:sizeof(uint8_t)];
}

@end

@implementation fgTabuloDirector

- (id)init:(Class )_adapterType {

    self = [super init:_adapterType];

    if (self != nil)
    {
        gameCanvas = nil;
        spritesheetMenu = nil;
        backgroundMenu = nil;
        spritesheetLevel = nil;
        backgroundLevel = nil;
        levelFlags = [NSMutableArray array];
    }

    return self;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {

    if (gameCanvas == nil && _canvas != nil)
    {
        gameCanvas = (fgViewCanvas *)_canvas;
    }

    spritesheetMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-menu.png"]), nil];
    backgroundMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-menu.png"]), nil];
    spritesheetLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-gameplay.png"]), nil];
    backgroundLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-gameplay.png"]), nil];

    fgDataAdapter *dataFlags = [[fgDataAdapter alloc] initWithName:@"DATASAVE" fromBundle:false];

    for (NSUInteger i = 0; i < 18; ++i)
    {
        if (dataFlags == nil)
        {
            [levelFlags addObject:[[__LevelFlags alloc] init]];
        }
        else
        {
            [levelFlags addObject:[[__LevelFlags alloc] init:dataFlags]];
        }
    }
}

- (f3IntegerArray *)getResourceIndex:(enum f3TabuloResource)_resource {

    switch (_resource)
    {
        case RESOURCE_SpritesheetMenu: return spritesheetMenu;

        case RESOURCE_SpritesheetLevel: return spritesheetLevel;

        case RESOURCE_BackgroundMenu: return backgroundMenu;
            
        case RESOURCE_BackgroundLevel: return backgroundLevel;
            
        default: return nil;
    }
}

- (enum fgTabuloGrade)getGradeForLevel:(NSUInteger)_level {

    if ([levelFlags count] > _level)
    {
        return [(__LevelFlags *)[levelFlags objectAtIndex:_level] Grade];
    }
    
    return GRADE_none;
}

- (void)setGrade:(enum fgTabuloGrade)_grade level:(NSUInteger)_level {
    
    if ([levelFlags count] > _level)
    {
        __LevelFlags *flags = [levelFlags objectAtIndex:_level];

        if (flags.Grade != _grade)
        {
            flags.Grade = _grade;
            
            [self writeLevelFlags];
        }
    }
}

- (void)writeLevelFlags {

    fgDataAdapter *dataFlags = [[fgDataAdapter alloc] init];

    for (NSUInteger i = 0; i < [levelFlags count]; ++i)
    {
        [(__LevelFlags *)[levelFlags objectAtIndex:i] serialize:dataFlags];
    }

    [dataFlags closeWithName:@"DATASAVE"];
}

- (void)buildPawn:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    uint16_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:dataIndex];
    
    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPawnType _type = dataFlag;

    [_node setFlag:_type value:true];
}

- (void)buildPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    f3ModelData *angleModel = [[f3ModelData alloc] init:_data];
    f3FloatArray *angleHandle = [[f3FloatArray alloc] initWithModel:angleModel size:sizeof(float)];

    uint16_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:dataIndex];

    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPlankType _type = dataFlag;

    [_node setFlag:_type value:true];

    [viewBuilder push:angleHandle];
    [viewBuilder buildDecorator:3];
}

- (void)buildDragControl:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols state:(fgLevelState *)_state {

    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:nodeIndex];

    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *_view = [_symbols objectAtIndex:viewIndex];

    f3DragViewFromNode *controlState = [[f3DragViewFromNode alloc] initWithNode:_node forView:_view nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlState]];
}

- (void)buildComposite:(NSObject<IDataAdapter> *)_data {
    
    [viewBuilder buildComposite:0];
    [scene appendComposite:(f3ViewComposite *)[viewBuilder popComponent]];
}

- (void)buildSprite:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    f3ModelData *indicesModel = [[f3ModelData alloc] init:_data];
    f3ModelData *vertexModel = [[f3ModelData alloc] init:_data];
    f3ModelData *coordonateModel = [[f3ModelData alloc] init:_data];

    uint8_t dataResource;
    [_data readBytes:&dataResource length:sizeof(uint8_t)];

    uint16_t dataLength = sizeof(float) *4;
    float *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];

    f3IntegerArray *indicesHandle = [[f3IntegerArray alloc] initWithModel:indicesModel size:sizeof(unsigned short)];
    f3FloatArray *vertexHandle = [[f3FloatArray alloc] initWithModel:vertexModel size:sizeof(float)];
    f3FloatArray *coordonateHandle = [[f3FloatArray alloc] initWithModel:coordonateModel size:sizeof(float)];

    enum f3TabuloResource resourceIndex = dataResource;

    CGSize scale = CGSizeMake(dataArray[0], dataArray[1]);
    CGPoint position = CGPointMake(dataArray[2], dataArray[3]);

    [viewBuilder push:indicesHandle];
    [viewBuilder push:vertexHandle];
    [viewBuilder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *_view = (f3ViewAdaptee *)[viewBuilder top];
    if (_symbols != nil)
    {
        [_symbols addObject:_view];
    }

    [viewBuilder push:coordonateHandle];
    [viewBuilder push:[self getResourceIndex:resourceIndex]];
    [viewBuilder buildDecorator:4];

    [viewBuilder push:[f3VectorHandle buildHandleForWidth:scale.width height:scale.height]];
    [viewBuilder buildDecorator:2];

    [viewBuilder push:[f3VectorHandle buildHandleForX:position.x y:position.y]];
    [viewBuilder buildDecorator:1];
}

- (void)buildHouseCondition:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols state:(fgLevelState *)_state {

    uint16_t dataLength = sizeof(uint16_t) *2;
    uint16_t *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    fgHouseNode *_node = (fgHouseNode *)[_symbols objectAtIndex:dataArray[0]];
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[_symbols objectAtIndex:dataArray[1]];

    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPawnType _type = dataFlag;

    f3GraphCondition *condition = [[f3GraphCondition alloc] init:_node.Key flag:_type result:true];
    [_state bindCondition:condition];
    [_node bindView:_view type:_type];
    
    free(dataArray);
}

- (void)buildEdgesForPawn:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPlankType _type = dataFlag;

    uint16_t dataLength = sizeof(uint16_t) *3;
    uint16_t *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    f3GraphNode *_node = [_symbols objectAtIndex:dataArray[0]];
    f3GraphNode *_origin = [_symbols objectAtIndex:dataArray[1]];
    f3GraphNode *_target = [_symbols objectAtIndex:dataArray[2]];
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPawnEdge *edge = [[fgPawnEdge alloc] init:pawn origin:_origin target:_target input:_node];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:_type result:true]];
        
        switch (pawn) // restrict edge if a hole is present
        {
            case TABULO_PawnOne:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleOne result:false]];
                break;
                
            case TABULO_PawnTwo:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleTwo result:false]];
                break;
                
            case TABULO_PawnThree:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleThree result:false]];
                break;
                
            case TABULO_PawnFive:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleFour result:false]];
                break;
                
            case TABULO_PawnFour:
                [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:TABULO_HoleFive result:false]];
                break;
        }
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnOne result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnTwo result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnThree result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFive result:false]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:TABULO_PawnFour result:false]];
    }
}

- (void)buildEdgesForPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {

    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPlankType _type = dataFlag;
    
    uint16_t dataLength = sizeof(uint16_t) *3;
    uint16_t *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    f3GraphNode *_node = [_symbols objectAtIndex:dataArray[0]];
    f3GraphNode *_origin = [_symbols objectAtIndex:dataArray[1]];
    f3GraphNode *_target = [_symbols objectAtIndex:dataArray[2]];
    
    for (int pawn = TABULO_PawnOne; pawn <= TABULO_PawnFive; ++pawn)
    {
        fgPlankEdge *edge = [[fgPlankEdge alloc] init:_type origin:_origin target:_target rotation:_node];
        
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Origin.Key flag:_type result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:_node.Key flag:pawn result:true]];
        [edge bindCondition:[[f3GraphCondition alloc] init:edge.Target.Key flag:_type result:false]];
    }
}


- (void)buildGraphSolution:(NSObject<IDataAdapter> *)_data state:(fgLevelState *)_state {

    [(fgLevelState *)_state bindSolution:[[f3GraphConfig alloc] init:_data]];
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
                //
                break;
            case 0x01:
                //
                break;

            case 0x02:
                [_state buildNodeWithExtend:_data symbols:symbols];
                break;
            case 0x03:
                [_state buildNodeWithRadius:_data symbols:symbols];
                break;
            case 0x04:
                [_state buildHouseNode:_data symbols:symbols];
                break;
            case 0x05:
                [self buildPawn:_data symbols:symbols];
                break;
            case 0x06:
                [self buildPlank:_data symbols:symbols];
                break;
            case 0x07:
                //
                break;
            case 0x08:
                //
                break;

            case 0x09:
                [self buildDragControl:_data symbols:symbols state:_state];
                break;
            case 0x0A:
                [self buildComposite:_data];
                break;
            case 0x0B:
                [self buildGraphSolution:_data state:_state];
                break;
            case 0x0C:
                //
                break;
            case 0x0D:
                //
                break;
            case 0x0E:
                [self buildSprite:_data symbols:symbols];
                break;
            case 0x0F:
                [self buildHouseCondition:_data symbols:symbols state:_state];
                break;
            case 0x10:
                [self buildEdgesForPawn:_data symbols:symbols];
                break;
            case 0x11:
                [self buildEdgesForPlank:_data symbols:symbols];
                break;
                
            // TODO add GraphConfig and GraphResolver
        }

        marker = [_data readMarker];
    }

    [symbols removeAllObjects];
}

@end
