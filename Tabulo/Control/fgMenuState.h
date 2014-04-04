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
#import "fgTabuloEvent.h"

@interface fgMenuState : f3GameState {
    
    f3ViewScene *currentScene;
    f3OffsetDecorator *offsetDecorator;
    float verticalOffset;
}

- (void)buildMenu:(f3ViewBuilder *)_builder;

@end
