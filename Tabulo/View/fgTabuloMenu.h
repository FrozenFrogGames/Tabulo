//
//  fgTabuloMenu.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@interface fgTabuloMenu : NSObject

+ (void)buildDialog:(enum f3TabuloDialogOptions)_options director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

+ (void)buildMenu:(NSUInteger)_count director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

@end
