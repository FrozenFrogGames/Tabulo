//
//  fgTabuloDirector.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "../fgViewCanvas.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3ViewComposite.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/View/f3AngleDecorator.h"
#import "../../../Framework/Framework/View/f3ViewSearch.h"
#import "../../../Framework/Framework/Control/f3MutableGraphNodeState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3Controller.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../Control/fgDragOverGraphEdgeState.h"
#import "../Control/fgDragAroundGraphNodeState.h"
#import "../Control/fgTabuloStrategy.h"
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

const NSUInteger LEVEL_COUNT = 36;

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
        lockedLevelIndex = LEVEL_COUNT +1;
    }

    return self;
}

- (void)loadResource:(NSObject<IViewCanvas> *)_canvas {

    if (gameCanvas == nil && _canvas != nil)
    {
        gameCanvas = (fgViewCanvas *)_canvas;
    }

    if (spritesheetMenu == nil)
    {
        spritesheetMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-menu.png"]), nil];
    }

    if (backgroundMenu == nil)
    {
        backgroundMenu = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-menu.png"]), nil];
    }

    if (spritesheetLevel == nil)
    {
        spritesheetLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"spritesheet-gameplay.png"]), nil];
    }

    if (backgroundLevel == nil)
    {
        backgroundLevel = [f3IntegerArray buildHandleForUInt16:1, USHORT_BOX([gameCanvas loadRessource:@"background-gameplay.png"]), nil];
    }
}

- (void)clearResource {
    
    if (gameCanvas != nil)
    {
        [gameCanvas clearRessource];
    }
    
    spritesheetMenu = nil;
    backgroundMenu = nil;
    spritesheetLevel = nil;
    backgroundLevel = nil;
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

- (void)loadSavegame {

    fgDataAdapter *dataFlags = [[fgDataAdapter alloc] initWithName:@"DATASAVE" fromBundle:false];
    
    for (NSUInteger i = 0; i < LEVEL_COUNT; ++i)
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
    
    if (dataFlags != nil) // if data has been saved then compute value of lockedLevelIndex
    {
        for (NSUInteger i = 1; i < (LEVEL_COUNT /6); ++i)
        {
            [self unlockLevel];
        }
    }
}

- (enum fgTabuloGrade)getGradeForLevel:(NSUInteger)_level {

    if (_level > 0 && _level <= [levelFlags count])
    {
        return [(__LevelFlags *)[levelFlags objectAtIndex:_level -1] Grade];
    }
    
    return GRADE_none;
}

- (void)setGrade:(enum fgTabuloGrade)_grade level:(NSUInteger)_level {
    
    if (_level > 0 && _level <= [levelFlags count])
    {
        __LevelFlags *flags = [levelFlags objectAtIndex:_level -1];

        if (flags.Grade != _grade)
        {
            flags.Grade = _grade;
            
            [self unlockLevel];
            
            [self writeLevelFlags];
        }
    }
}

- (bool)isLevelLocked:(NSUInteger)_level {
    
    return (_level >= lockedLevelIndex);
}

- (NSUInteger)getLevelCount {
    
    return LEVEL_COUNT;
}

- (void)unlockLevel {

    if (lockedLevelIndex < LEVEL_COUNT)
    {
        for (NSUInteger i = 6; i > 0; --i)
        {
            __LevelFlags *flags = [levelFlags objectAtIndex:lockedLevelIndex -i -1];
            
            if (flags.Grade == GRADE_none)
            {
                return;
            }
        }
        
        lockedLevelIndex += 6;
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

- (void)buildBackground:(NSObject<IDataAdapter> *)_data screen:(CGSize)_screen unit:(CGSize)_unit scale:(float)_scale symbols:(NSMutableArray *)_symbols {

    f3ModelData *indicesModel = [[f3ModelData alloc] init:_data];
    f3ModelData *vertexModel = [[f3ModelData alloc] init:_data];
    f3ModelData *coordonateModel = [[f3ModelData alloc] init:_data];
    
    uint8_t dataResource;
    [_data readBytes:&dataResource length:sizeof(uint8_t)];
    
    f3IntegerArray *indicesHandle = [[f3IntegerArray alloc] initWithModel:indicesModel size:sizeof(unsigned short)];
    f3FloatArray *vertexHandle = [[f3FloatArray alloc] initWithModel:vertexModel size:sizeof(float)];
    f3FloatArray *coordonateHandle = [[f3FloatArray alloc] initWithModel:coordonateModel size:sizeof(float)];
    
    enum f3TabuloResource resourceIndex = dataResource;
    float backgroundWith = _screen.width / _unit.width;
    float backgroundHeight = _screen.height / _unit.height;
    
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

    [viewBuilder push:[f3VectorHandle buildHandleForWidth:backgroundWith /_scale height:backgroundHeight /_scale]];
    [viewBuilder buildDecorator:2];
    
    [viewBuilder push:[f3VectorHandle buildHandleForX:0.f y:0.f]];
    [viewBuilder buildDecorator:1];

    [viewBuilder push:[f3IntegerArray buildHandleForUInt16:1, USHORT_BOX(BackgroundLayer), nil]];
    [viewBuilder buildComposite:1];
}

- (void)buildLayer:(NSObject<IDataAdapter> *)_data {

    uint8_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint8_t)];

    [viewBuilder push:[f3IntegerArray buildHandleForUInt16:1, USHORT_BOX(dataIndex), nil]];
    [viewBuilder buildComposite:1];
}

- (void)buildPawn:(NSObject<IDataAdapter> *)_data strategy:(fgTabuloStrategy *)_strategy symbols:(NSMutableArray *)_symbols {

    uint16_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint16_t)];
    f3GraphNode *node = [_symbols objectAtIndex:dataIndex];
    
    uint8_t dataPawn;
    [_data readBytes:&dataPawn length:sizeof(uint8_t)];
    enum f3TabuloPawnType pawnType = dataPawn;

    [_strategy setNodeFlag:node.Key flag:pawnType value:true];
}

- (void)buildPlank:(NSObject<IDataAdapter> *)_data strategy:(fgTabuloStrategy *)_strategy symbols:(NSMutableArray *)_symbols {

    f3ModelData *angleModel = [[f3ModelData alloc] init:_data];
    f3FloatArray *angleHandle = [[f3FloatArray alloc] initWithModel:angleModel size:sizeof(float)];

    uint16_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint16_t)];
    f3GraphNode *node = [_symbols objectAtIndex:dataIndex];

    uint8_t dataPlank;
    [_data readBytes:&dataPlank length:sizeof(uint8_t)];
    enum f3TabuloPlankType plankType = dataPlank;

    [_strategy setNodeFlag:node.Key flag:plankType value:true];

    [viewBuilder push:angleHandle];
    [viewBuilder buildDecorator:3];
}

- (void)buildPlankWithHole:(NSObject<IDataAdapter> *)_data strategy:(fgTabuloStrategy *)_strategy symbols:(NSMutableArray *)_symbols {

    f3ModelData *angleModel = [[f3ModelData alloc] init:_data];
    f3FloatArray *angleHandle = [[f3FloatArray alloc] initWithModel:angleModel size:sizeof(float)];

    uint16_t dataIndex;
    [_data readBytes:&dataIndex length:sizeof(uint16_t)];
    f3GraphNode *node = [_symbols objectAtIndex:dataIndex];

    uint8_t dataPlank;
    [_data readBytes:&dataPlank length:sizeof(uint8_t)];
    enum f3TabuloPlankType plankType = dataPlank;

    uint8_t dataHole;
    [_data readBytes:&dataHole length:sizeof(uint8_t)];
    enum f3TabuloHoleType plankHole = dataHole;

    [_strategy setNodeFlag:node.Key flag:plankType value:true];
    [_strategy setNodeFlag:node.Key flag:plankHole value:true];

    [viewBuilder push:angleHandle];
    [viewBuilder buildDecorator:3];
}

- (void)buildDragPawnControl:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols strategy:(fgTabuloStrategy *)_strategy {

    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:nodeIndex];

    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *_view = [_symbols objectAtIndex:viewIndex];

    f3MutableGraphNodeState *controlState = [[f3MutableGraphNodeState alloc] initWithNode:_node forView:_view nextState:[fgDragOverGraphEdgeState class]];
    [_strategy appendGameController:[[f3Controller alloc] initWithState:controlState]];
}

- (void)buildDragPlankControl:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols strategy:(fgTabuloStrategy *)_strategy {
    
    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:nodeIndex];
    
    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *_view = [_symbols objectAtIndex:viewIndex];
    
    f3MutableGraphNodeState *controlState = [[f3MutableGraphNodeState alloc] initWithNode:_node forView:_view nextState:[fgDragAroundGraphNodeState class]];
    [_strategy appendGameController:[[f3Controller alloc] initWithState:controlState]];
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

- (void)buildHouseCondition:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols strategy:(fgTabuloStrategy *)_strategy {

    uint16_t dataLength = sizeof(uint16_t) *2;
    uint16_t *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    fgHouseNode *_node = (fgHouseNode *)[_symbols objectAtIndex:dataArray[0]];
    f3ViewAdaptee *_view = (f3ViewAdaptee *)[_symbols objectAtIndex:dataArray[1]];

    uint8_t dataFlag;
    [_data readBytes:&dataFlag length:sizeof(uint8_t)];
    enum f3TabuloPawnType _type = dataFlag;

    f3GraphEdgeCondition *condition = [[f3GraphEdgeCondition alloc] init:_node.Key flag:_type result:true];
    [_strategy bindCondition:condition];
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
    
    for (int pawnType = TABULO_PawnOne; pawnType < TABULO_PAWN_MAX; ++pawnType)
    {
        fgPawnEdge *edge = [[fgPawnEdge alloc] init:_origin.Key target:_target.Key input:_node.Key];

        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:_type result:true]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.OriginKey flag:pawnType result:true]];

        switch (pawnType) // restrict edge if a hole is present
        {
            case TABULO_PawnOne:
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_OneHole_One result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneTwo result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFive result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                break;
                
            case TABULO_PawnTwo:
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_OneHole_Two result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneTwo result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFive result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                break;
                
            case TABULO_PawnThree:
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_OneHole_Three result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFive result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoThree result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
                
            case TABULO_PawnFour:
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_OneHole_Four result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_FourFive result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFour result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
                
            case TABULO_PawnFive:
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_OneHole_Five result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_OneFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_TwoFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_ThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_TwoHoles_FourFive result:false]];
                
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneTwoFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_OneFourFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoThreeFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_TwoFourFive result:false]];
                [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:TABULO_ThreeHoles_ThreeFourFire result:false]];
                break;
        }
        
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:TABULO_PawnOne result:false]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:TABULO_PawnTwo result:false]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:TABULO_PawnThree result:false]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:TABULO_PawnFive result:false]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:TABULO_PawnFour result:false]];
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
    
    for (int pawnType = TABULO_PawnOne; pawnType < TABULO_PAWN_MAX; ++pawnType)
    {
        fgPlankEdge *edge = [[fgPlankEdge alloc] init:_origin.Key target:_target.Key rotation:_node.Key];
        [edge setPlankType:_type];
    
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.OriginKey flag:_type result:true]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:_node.Key flag:pawnType result:true]];
        [edge bindCondition:[[f3GraphEdgeCondition alloc] init:edge.TargetKey flag:_type result:false]];
    }
}

- (void)loadSceneFromFile:(NSObject<IDataAdapter> *)_data state:(f3GameState *)_state {

    f3GameAdaptee *producer = [f3GameAdaptee Producer];
    fgTabuloStrategy *strategy = (fgTabuloStrategy *)[_state Strategy];

    if (scene == nil)
    {
        scene = [[f3ViewScene alloc] init];
    }
    
    NSMutableArray *symbols = [NSMutableArray array];
    uint8_t marker = [_data readMarker];
    
    while (marker != 0xFF)
    {
        switch (marker)
        {
            case 0x00:
                [strategy initGraphStrategy:nil symbols:symbols];
                break;

            case 0x01:
                [self buildBackground:_data screen:producer.ScreenSize unit:producer.UnitSize scale:producer.UnitScale symbols:symbols];
                break;

            case 0x02:
                [strategy buildNodeWithExtend:_data symbols:symbols];
                break;
            case 0x03:
                [strategy buildNodeWithRadius:_data symbols:symbols];
                break;
            case 0x04:
                [strategy buildHouseNode:_data symbols:symbols];
                break;
            case 0x05:
                [self buildPawn:_data strategy:strategy symbols:symbols];
                break;
            case 0x06:
                [self buildPlank:_data strategy:strategy symbols:symbols];
                break;
            case 0x07:
                [self buildPlankWithHole:_data strategy:strategy symbols:symbols];
                break;
            case 0x08:
                [self buildDragPawnControl:_data symbols:symbols strategy:strategy];
                break;
            case 0x09:
                [self buildDragPlankControl:_data symbols:symbols strategy:strategy];
                break;

            case 0x0A:
                [self buildLayer:_data];
                break;

            case 0x0B:
                [strategy extractFirstGraphPath:_data]; // ready to render the scene once that initial graph path has been red
                break;
            case 0x0C:
                [strategy extractNextGraphPath:_data]; // keep create graph path in background for help
                break;
            case 0x0D:
                [strategy buildGraphPath]; // end of file - bind neighbors and compute help
                break;

            case 0x0E:
                [self buildSprite:_data symbols:symbols];
                break;
            case 0x0F:
                [self buildHouseCondition:_data symbols:symbols strategy:strategy];
                break;
            case 0x10:
                [self buildEdgesForPawn:_data symbols:symbols];
                break;
            case 0x11:
                [self buildEdgesForPlank:_data symbols:symbols];
                break;
        }

        marker = [_data readMarker];
    }

    [symbols removeAllObjects];
}

@end
