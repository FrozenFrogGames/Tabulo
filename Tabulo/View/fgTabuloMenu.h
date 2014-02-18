//
//  fgTabuloMenu.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEvent.h"
#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/View/f3GameScene.h"

@interface fgTabuloMenu : f3GameScene

- (void)buildMenu:(NSUInteger)_count director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

- (f3ViewComposite *)buildDialog:(fgTabuloEvent *)_event director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

@end
