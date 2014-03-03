//
//  fgDialogState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"

enum fgTabuloGrade {
    
    GRADE_none,
    GRADE_bronze,
    GRADE_silver,
    GRADE_gold
};

@interface fgDialogState : f3GameState {
    
    f3ViewComposite *dialogLayer;
    f3GameState *previousState;
}

- (id)init:(f3GameState *)_previousState;
- (void)build:(f3ViewBuilder *)_builder event:(enum f3GameEvent)_event level:(NSUInteger)_level grade:(enum fgTabuloGrade)_grade;

@end
