//
//  fgMenuState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-30.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/View/f3ViewComposite.h"
#import "fgTabuloEvent.h"

@interface fgMenuState : f3GameState {

    f3OffsetDecorator *offsetDecorator;
    f3ViewComposite *levelContainer;
    float offsetPadding, inputBeginY, inputCurrentY, inputEndY;
    NSTimeInterval motionTimeInterval, motionTotalTime;
    bool notInMotion, insideOfArea;
}

- (void)computePadding:(NSUInteger)_level;

@end
