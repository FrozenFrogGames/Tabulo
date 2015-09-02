//
//  fgPawnEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPawnEdge.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3ControlSequence.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPawnEdge

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view slowMotion:(float)_slowmo {

    f3GraphNode *targetNode = [f3GraphNode nodeForKey:targetKey];
    f3VectorHandle *targetPoint = [targetNode getPositionHandle];

    CGPoint originPoint = [f3GraphNode nodeForKey:originKey].Position;
    f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];
    
    float speed = [f3GraphEdge distanceBetween:originPoint to:targetNode.Position] /50.f *_slowmo;

    f3ControlSequence *command = [[f3ControlSequence alloc] init];
    [command appendComponent:[[f3TranslationCommand alloc] initWithView:_view translation:translation speed:speed]];
    [command appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:targetPoint]];
    [_builder push:command];
}

@end
