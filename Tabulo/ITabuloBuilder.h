//
//  ITabuloLevelBuilder.h
//  Tabulo
//
//  Created by Serge Menard on 2014-01-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "Control/fgPawnController.h"
#import "Control/fgTabuloController.h"
#import "View/fgTabuloDirector.h"
#import "../../Framework/Framework/Control/f3GameAdaptee.h"

@protocol ITabuloBuilder <NSObject>

+ (fgTabuloController *)buildLevel:(NSUInteger)_index director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer;

@end
