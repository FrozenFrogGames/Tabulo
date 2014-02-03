//
//  fgClickViewOnLevel.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3ClickViewOnNode.h"

@interface fgClickViewOnLevel : f3ClickViewOnNode {

    NSUInteger levelIndex;
}

- (id)initForView:(f3ViewAdaptee *)_view onNode:(f3GraphNode *)_node forLevel:(NSUInteger)_levelIndex;

@end
