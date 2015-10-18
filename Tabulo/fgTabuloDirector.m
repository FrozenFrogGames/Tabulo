//
//  fgTabuloDirector.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "fgDataAdapter.h"
#import "fgViewCanvas.h"
#import "../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../Framework/Framework/View/f3ViewComposite.h"
#import "../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../Framework/Framework/View/f3AngleDecorator.h"
#import "../../Framework/Framework/Control/f3MutableGraphNodeState.h"
#import "../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../Framework/Framework/Control/f3Controller.h"
#import "../../Framework/Framework/Control/f3GraphNode.h"
#import "../../Framework/Framework/Control/f3GraphMaskCondition.h"
#import "../../Framework/Framework/Control/f3GraphSchema.h"
#import "Control/fgDragOverGraphEdgeState.h"
#import "Control/fgDragAroundGraphNodeState.h"
#import "Control/fgTabuloStrategy.h"
#import "Control/fgHouseNode.h"
#import "Control/fgPawnEdge.h"
#import "Control/fgPlankEdge.h"
#import "Control/fgPlankMaskCondition.h"

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

    fgDataAdapter *dataFlags = [[fgDataAdapter alloc] init:@"DATASAVE" bundle:false];
    
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

    [dataFlags close:@"DATASAVE"];
}

- (f3GraphNode *)buildNodeWithExtend:(NSObject<IDataAdapter> *)_data {
    
    uint16_t dataLength = sizeof(float) *4;
    float *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);
    CGSize extend = CGSizeMake(dataArray[2], dataArray[3]);
    
    f3GraphNode *node = [[f3GraphNode alloc] init:position extend:extend];
    free(dataArray);
    return node;
}

- (f3GraphNode *)buildNodeWithRadius:(NSObject<IDataAdapter> *)_data {
    
    uint16_t dataLength = sizeof(float) *3;
    float *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);
    
    f3GraphNode *node = [[f3GraphNode alloc] init:position radius:dataArray[2]];
    free(dataArray);
    return node;
}

- (f3GoalNode *)buildHouseNodeWithExtend:(NSObject<IDataAdapter> *)_data {
    
    uint16_t dataLength = sizeof(float) *4;
    float *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];

    uint8_t flag;
    [_data readBytes:&flag length:sizeof(uint8_t)];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);
    CGSize extend = CGSizeMake(dataArray[2], dataArray[3]);
    
    fgHouseNode *node = [[fgHouseNode alloc] init:position extend:extend flag:flag];
    free(dataArray);
    return node;
}

- (f3GoalNode *)buildHouseNodeWithRadius:(NSObject<IDataAdapter> *)_data {
    
    uint16_t dataLength = sizeof(float) *3;
    float *dataArray = malloc(dataLength);
    [_data readBytes:dataArray length:dataLength];
    
    uint8_t flag;
    [_data readBytes:&flag length:sizeof(uint8_t)];
    
    CGPoint position = CGPointMake(dataArray[0], dataArray[1]);

    fgHouseNode *node = [[fgHouseNode alloc] init:position radius:dataArray[2] flag:flag];
    free(dataArray);
    return node;
}

- (f3ViewAdaptee *)buildViewAdaptee:(NSObject<IDataAdapter> *)_data {
    
    f3ModelData *indicesModel = [[f3ModelData alloc] init:_data];
    f3ModelData *vertexModel = [[f3ModelData alloc] init:_data];
    
    f3IntegerArray *indicesHandle = [[f3IntegerArray alloc] initWithModel:indicesModel size:sizeof(unsigned short)];
    f3FloatArray *vertexHandle = [[f3FloatArray alloc] initWithModel:vertexModel size:sizeof(float)];
    
    [viewBuilder push:indicesHandle];
    [viewBuilder push:vertexHandle];
    [viewBuilder buildAdaptee:DRAW_TRIANGLES];

    return (f3ViewAdaptee *)[viewBuilder top];
}

- (void)buildOffsetDecorator:(NSObject<IDataAdapter> *)_data {

    f3ModelData *offsetModel = [[f3ModelData alloc] init:_data];
    f3VectorHandle *offsetHandle = [[f3VectorHandle alloc] initWithModel:offsetModel size:sizeof(float)];

    [viewBuilder push:offsetHandle];
    [viewBuilder buildDecorator:1];
}

- (void)buildScaleDecorator:(NSObject<IDataAdapter> *)_data {

    f3ModelData *scaleModel = [[f3ModelData alloc] init:_data];
    f3VectorHandle *scaleHandle = [[f3VectorHandle alloc] initWithModel:scaleModel size:sizeof(float)];

    [viewBuilder push:scaleHandle];
    [viewBuilder buildDecorator:2];
}

- (void)buildAngleDecorator:(NSObject<IDataAdapter> *)_data {

    f3ModelData *angleModel = [[f3ModelData alloc] init:_data];
    f3FloatArray *angleHandle = [[f3FloatArray alloc] initWithModel:angleModel size:sizeof(float)];

    [viewBuilder push:angleHandle];
    [viewBuilder buildDecorator:3];
}

- (void)buildTextureDecorator:(NSObject<IDataAdapter> *)_data {

    f3ModelData *resourceModel = [[f3ModelData alloc] init:_data];
    f3ModelData *coordonateModel = [[f3ModelData alloc] init:_data];

    f3IntegerArray *resourceHandle = [[f3IntegerArray alloc] initWithModel:resourceModel size:sizeof(unsigned short)];
    f3FloatArray *coordonateHandle = [[f3FloatArray alloc] initWithModel:coordonateModel size:sizeof(float)];

    [viewBuilder push:coordonateHandle];
    [viewBuilder push:resourceHandle];
    [viewBuilder buildDecorator:4];
}

- (void)buildBackgroundDecorator:(NSObject<IDataAdapter> *)_data screen:(CGSize)_screen unit:(CGSize)_unit scale:(float)_scale {

    float backgroundWith = _screen.width / _unit.width;
    float backgroundHeight = _screen.height / _unit.height;

    [viewBuilder push:[f3VectorHandle buildHandleForWidth:backgroundWith /_scale height:backgroundHeight /_scale]];
    [viewBuilder buildDecorator:2];
}

- (void)buildViewLayer:(NSObject<IDataAdapter> *)_data {

    f3ModelData *layerModel = [[f3ModelData alloc] init:_data];
    f3IntegerArray *layerHandle = [[f3IntegerArray alloc] initWithModel:layerModel size:sizeof(unsigned short)];

    [viewBuilder push:layerHandle];
    [viewBuilder buildComposite:1];
}

- (void)bindViewToNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols {
    
    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *node = [_symbols objectAtIndex:nodeIndex];
    
    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *view = [_symbols objectAtIndex:viewIndex];
    
    if ([node isKindOfClass:[fgHouseNode class]])
    {
        [(fgHouseNode *)node bindView:view];
    }
}

- (void)buildEdgeForPawn:(uint8_t)_pawn origin:(NSNumber *)_origin target:(NSNumber *)_target plank:(uint8_t)_plank node:(NSNumber *)_node {

    f3GraphEdgeWithInputNode *edge = [[fgPawnEdge alloc] init:_origin target:_target input:_node];

    [edge bindCondition:[[f3GraphFlagCondition alloc] init:_origin flag:_pawn result:true]];
    [edge bindCondition:[[f3GraphMaskCondition alloc] init:_target mask:TABULO_PAWN_MASK result:0x0000]];

    float plankAngle = [f3GraphEdge angleBetween:[[f3GraphNode nodeForKey:_target] Position] and:[[f3GraphNode nodeForKey:_origin] Position]];
    f3NodeFlags orientationFlag = [fgPlankEdge getOrientationFlag:plankAngle];
    fgPlankMaskCondition *orientationCondition = [[fgPlankMaskCondition alloc] init:_node mask:TABULO_PLANK_ORIENTATION result:orientationFlag];
    
    [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:_plank result:true]];
    [edge bindCondition:orientationCondition];
    
    switch (_pawn)
    {
        case TABULO_PAWN_Red:
            [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:TABULO_HOLE_Red result:false]];
            break;
            
        case TABULO_PAWN_Green:
            [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:TABULO_HOLE_Green result:false]];
            break;
            
        case TABULO_PAWN_Blue:
            [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:TABULO_HOLE_Blue result:false]];
            break;
            
        case TABULO_PAWN_Yellow:
            [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:TABULO_HOLE_Yellow result:false]];
            break;
    }
}

- (void)buildEdgeForPawn:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols plank:(uint8_t)_plank {

    uint16_t plankIndex;
    [_data readBytes:&plankIndex length:sizeof(uint16_t)];
    f3GraphNode *plankNode = [_symbols objectAtIndex:plankIndex];
    
    uint16_t originIndex;
    [_data readBytes:&originIndex length:sizeof(uint16_t)];
    f3GraphNode *originNode = [_symbols objectAtIndex:originIndex];
    
    uint16_t targetIndex;
    [_data readBytes:&targetIndex length:sizeof(uint16_t)];
    f3GraphNode *targetNode = [_symbols objectAtIndex:targetIndex];

    [self buildEdgeForPawn:TABULO_PAWN_Red origin:originNode.Key target:targetNode.Key plank:_plank node:plankNode.Key];
    [self buildEdgeForPawn:TABULO_PAWN_Green origin:originNode.Key target:targetNode.Key plank:_plank node:plankNode.Key];
    [self buildEdgeForPawn:TABULO_PAWN_Blue origin:originNode.Key target:targetNode.Key plank:_plank node:plankNode.Key];
    [self buildEdgeForPawn:TABULO_PAWN_Yellow origin:originNode.Key target:targetNode.Key plank:_plank node:plankNode.Key];
}

- (void)buildControlOverGraphEdge:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols strategy:(f3GameStrategy *)_strategy {
    
    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:nodeIndex];
    
    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *_view = [_symbols objectAtIndex:viewIndex];
    
    f3MutableGraphNodeState *controlState = [[f3MutableGraphNodeState alloc] initWithNode:_node forView:_view nextState:[fgDragOverGraphEdgeState class]];
    [_strategy appendGameController:[[f3Controller alloc] initWithState:controlState]];
}

- (void)buildEdgeForPlank:(uint8_t)_plank origin:(NSNumber *)_origin target:(NSNumber *)_target node:(NSNumber *)_node {

    CGPoint originPoint = [[f3GraphNode nodeForKey:_origin] Position];
    CGPoint rotationPoint = [[f3GraphNode nodeForKey:_node] Position];
    float originAngle = [f3GraphEdge angleBetween:originPoint and:rotationPoint];

    f3NodeFlags orientationFlag = [fgPlankEdge getOrientationFlag:originAngle];
    fgPlankMaskCondition *orientationCondition = [[fgPlankMaskCondition alloc] init:_origin mask:TABULO_PLANK_ORIENTATION result:orientationFlag];

    f3GraphFlagCondition *originCondition = [[f3GraphFlagCondition alloc] init:_origin flag:_plank result:true];
    f3GraphFlagCondition *targetCondition = [[f3GraphFlagCondition alloc] init:_target flag:_plank result:false];

    for (int pawn = TABULO_PAWN_Red; pawn < TABULO_HOLE_Red; ++pawn)
    {
        fgPlankEdge *edge = [[fgPlankEdge alloc] init:_origin target:_target rotation:_node plank:_plank];

        [edge bindCondition:originCondition];
        [edge bindCondition:targetCondition];
        [edge bindCondition:[[f3GraphFlagCondition alloc] init:_node flag:pawn result:true]];
        [edge bindCondition:orientationCondition];
    }
}

- (void)buildEdgeForPlank:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols plank:(uint8_t)_plank {

    uint16_t pawnIndex;
    [_data readBytes:&pawnIndex length:sizeof(uint16_t)];
    f3GraphNode *pawnNode = [_symbols objectAtIndex:pawnIndex];

    uint16_t originIndex;
    [_data readBytes:&originIndex length:sizeof(uint16_t)];
    f3GraphNode *originNode = [_symbols objectAtIndex:originIndex];

    uint16_t targetIndex;
    [_data readBytes:&targetIndex length:sizeof(uint16_t)];
    f3GraphNode *targetNode = [_symbols objectAtIndex:targetIndex];

    [self buildEdgeForPlank:_plank origin:originNode.Key target:targetNode.Key node:pawnNode.Key];
}

- (void)buildControlAroundGraphNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols strategy:(f3GameStrategy *)_strategy {
    
    uint16_t nodeIndex;
    [_data readBytes:&nodeIndex length:sizeof(uint16_t)];
    f3GraphNode *_node = [_symbols objectAtIndex:nodeIndex];
    
    uint16_t viewIndex;
    [_data readBytes:&viewIndex length:sizeof(uint16_t)];
    f3ViewAdaptee *_view = [_symbols objectAtIndex:viewIndex];
    
    f3MutableGraphNodeState *controlState = [[f3MutableGraphNodeState alloc] initWithNode:_node forView:_view nextState:[fgDragAroundGraphNodeState class]];
    [_strategy appendGameController:[[f3Controller alloc] initWithState:controlState]];
}

- (void)loadSceneFromFile:(NSObject<IDataAdapter> *)_data strategy:(f3GraphSchemaStrategy *)_strategy {

    f3GameAdaptee *producer = [f3GameAdaptee Producer];
    f3GraphNode *node = nil;

    NSMutableArray *symbols = [NSMutableArray array];
    NSMutableArray *conditions = [NSMutableArray array];
    uint8_t marker = [_data readMarker];

    while (marker != 0xFF)
    {
        switch (marker)
        {
            // graph marker
            case 0x00:
                [f3GraphSchema initGraphSchema:_data symbols:symbols conditions:conditions];
                break;
            case 0x01:
                if (_strategy.Schema == nil)
                {
                    [_strategy initGraphSchema:[[f3GraphSchema alloc] init:_data] producer:producer];
                }
                else
                {
                    __unused f3GraphSchema *neighbor = [[f3GraphSchema alloc] init:_data];
                }
                break;
            // node marker
            case 0x02:
                node = [self buildNodeWithExtend:_data];
                [symbols addObject:node];
                [_strategy appendTouchListener:node];
                node = nil;
                break;
            case 0x03:
                node = [self buildNodeWithRadius:_data];
                [symbols addObject:node];
                [_strategy appendTouchListener:node];
                node = nil;
                break;
            case 0x04:
                node = [self buildHouseNodeWithExtend:_data];
                [symbols addObject:node];
                [conditions addObject:[(f3GoalNode *)node buildCondition]];
                [_strategy appendTouchListener:node];
                node = nil;
                break;
            case 0x05:
                node = [self buildHouseNodeWithRadius:_data];
                [symbols addObject:node];
                [conditions addObject:[(f3GoalNode *)node buildCondition]];
                [_strategy appendTouchListener:node];
                node = nil;
                break;
            // decorator marker
            case 0x06:
                [self buildOffsetDecorator:_data];
                break;
            case 0x07:
                [self buildScaleDecorator:_data];
                break;
            case 0x08:
                [self buildAngleDecorator:_data];
                break;
            case 0x09:
                [self buildTextureDecorator:_data];
                break;
            case 0x0B:
                [self buildBackgroundDecorator:_data screen:producer.ScreenSize unit:producer.UnitSize scale:producer.UnitScale];
                break;
            // view marker
            case 0x0A:
                [symbols addObject:[self buildViewAdaptee:_data]];
                break;
            case 0x0C:
                [self buildViewLayer:_data];
                break;
            // control marker
            case 0x0D:
                [self buildControlOverGraphEdge:_data symbols:symbols strategy:_strategy];
                break;
            case 0x0E:
                [self buildControlAroundGraphNode:_data symbols:symbols strategy:_strategy];
                break;
            // tabulo marker
            case 0x10:
                [self bindViewToNode:_data symbols:symbols];
                break;
            case 0x11:
                [self buildEdgeForPawn:_data symbols:symbols plank:TABULO_PLANK_Small];
                break;
            case 0x12:
                [self buildEdgeForPawn:_data symbols:symbols plank:TABULO_PLANK_Medium];
                break;
            case 0x13:
                [self buildEdgeForPawn:_data symbols:symbols plank:TABULO_PLANK_Long];
                break;
            case 0x14:
                [self buildEdgeForPlank:_data symbols:symbols plank:TABULO_PLANK_Small];
                break;
            case 0x15:
                [self buildEdgeForPlank:_data symbols:symbols plank:TABULO_PLANK_Medium];
                break;
            case 0x16:
                [self buildEdgeForPlank:_data symbols:symbols plank:TABULO_PLANK_Long];
                break;
        }

        marker = [_data readMarker];
    }

    [symbols removeAllObjects];
}

@end
