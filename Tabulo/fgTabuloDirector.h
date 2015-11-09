//
//  fgTabuloDirector.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-08.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../Framework/Framework/Control/f3GraphNode.h"
#import "../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../Framework/Framework/Model/f3IntegerArray.h"
#import "../../Framework/Framework/Model/f3FloatArray.h"
#import "../../Framework/Framework/View/f3GameDirector.h"
#import "../../Framework/Framework/IDataAdapter.h"

enum f3TabuloPawnType {

    TABULO_PAWN_Red    = 0,
    TABULO_PAWN_Green  = 1,
    TABULO_PAWN_Blue   = 2,
    TABULO_PAWN_Yellow = 3
};

const uint16_t TABULO_PAWN_MASK = 15;

enum f3TabuloHoleType {

    TABULO_HOLE_Red    = 4,
    TABULO_HOLE_Green  = 5,
    TABULO_HOLE_Blue   = 6,
    TABULO_HOLE_Yellow = 7
};

const uint16_t TABULO_HOLE_MASK = 240;

enum f3TabuloPlankType {

    TABULO_PLANK_Small  = 8,
    TABULO_PLANK_Medium = 9,
    TABULO_PLANK_Long   = 10
};

const uint16_t TABULO_PLANK_MASK = 1792;

const uint16_t TABULO_PLANK_ORIENTATION = 14336;

enum f3TabuloResource {
    
    RESOURCE_SpritesheetMenu,
    RESOURCE_SpritesheetLevel,
    RESOURCE_BackgroundMenu,
    RESOURCE_BackgroundLevel
};

enum fgTabuloGrade {
    
    GRADE_none,
    GRADE_bronze,
    GRADE_silver,
    GRADE_gold
};

@class fgViewCanvas;

@interface fgTabuloDirector : f3GameDirector {

    fgViewCanvas *gameCanvas;
    f3IntegerArray  *spritesheetLevel, *spritesheetMenu, *backgroundLevel, *backgroundMenu;
    NSMutableArray *levelFlags;
    NSUInteger lockedLevelIndex;
}

- (f3IntegerArray *)getResourceIndex:(enum f3TabuloResource)_resource;

- (enum fgTabuloGrade)getGradeForLevel:(NSUInteger)_level;
- (void)setGrade:(enum fgTabuloGrade)_grade level:(NSUInteger)_level;
- (bool)isLevelLocked:(NSUInteger)_level;
- (NSUInteger)getLevelCount;

@end
