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
#import "../../../Framework/Framework/IDataAdapter.h"

enum f3TabuloPawnType {
    
    TABULO_PawnOne   = 0,
    TABULO_PawnTwo   = 1,
    TABULO_PawnThree = 2,
    TABULO_PawnFour  = 3,
    TABULO_PawnFive  = 4,

    TABULO_PAWN_MAX  = 5
};

enum f3TabuloPlankType {
    
    TABULO_HaveSmallPlank  = 5,
    TABULO_HaveMediumPlank = 6,
    TABULO_HaveLongPlank   = 7,
    
    TABULO_PLANK_MAX = 8
};

enum f3TabuloHoleType {
    
    TABULO_HoleOne   = 8,
    TABULO_HoleTwo   = 9,
    TABULO_HoleThree = 10,
    TABULO_HoleFour  = 11,
    TABULO_HoleFive  = 12
};

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
@class fgLevelState;

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

- (void)buildScene:(NSObject<IDataAdapter> *)_data state:(fgLevelState *)_state;

@end
