//
//  fgTabuloDirector.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Model/f3IntegerArray.h"
#import "../../../Framework/Framework/Model/f3FloatArray.h"
#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/View/f3RotationDecorator.h"
#import "../Control/fgTabuloController.h"
#import "fgViewCanvas.h"

enum f3TabuloPawnType {
    
    TABULO_PawnOne   = 0,
    TABULO_PawnTwo   = 1,
    TABULO_PawnThree = 2,
    TABULO_PawnFour  = 3,
    TABULO_PawnFive  = 4
};

enum f3TabuloPlankType {
    
    TABULO_HaveSmallPlank  = 5,
    TABULO_HaveMediumPlank = 6,
    TABULO_HaveLongPlank   = 7
};

enum f3TabuloHoleType {
    
    TABULO_HoleOne   = 8,
    TABULO_HoleTwo   = 9,
    TABULO_HoleThree = 10,
    TABULO_HoleFour  = 11,
    TABULO_HoleFive  = 12
};

@interface fgTabuloDirector : f3GameDirector {

    f3IntegerArray *spritesheet, *background;
    f3RotationDecorator *backgroundRotation;
    f3IntegerArray *indicesHandle;
    f3FloatArray *vertexHandle;
    fgViewCanvas *gameCanvas;
    bool backgroundIsPortrait;
    NSUInteger levelIndex;
}

- (float)computeAbsoluteAngleBetween:(CGPoint)_pointA and:(CGPoint)_pointB;
- (f3FloatArray *)getCoordonate:(CGSize)_spritesheet atPoint:(CGPoint)_position withExtend:(CGSize)_extend;

- (void)buildBackground;
- (void)buildPillar:(NSUInteger)_index;
- (void)buildHouse:(NSUInteger)_index Type:(unsigned int)_type;

- (f3ViewAdaptee *)buildPawn:(NSUInteger)_index Type:(enum f3TabuloPawnType)_type;
- (f3ViewAdaptee *)buildSmallPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole;
- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole:(int)_hole;
- (f3ViewAdaptee *)buildMediumPlank:(NSUInteger)_index Angle:(float)_angle Hole1:(int)_hole1 Hole2:(int)_hole2;

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;
- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;

- (void)nextScene;

@end
