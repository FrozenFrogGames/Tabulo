//
//  fgPlankEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankEdge.h"
#import "fgTabuloDirector.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3ControlCommand.h"
#import "../../../Framework/Framework/Control/f3TransformCommand.h"
#import "../../../Framework/Framework/Control/f3SetAngleCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPlankEdge

- (id)init:(int)_flag origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target rotation:(f3GraphNode *)_rotation {
    
    self = [super init:_flag origin:_origin target:_target];
    
    if (self != nil)
    {
        CGPoint originPoint = _origin.Position, targetPoint = _target.Position, rotationPoint = _rotation.Position;

        NSArray *pawnEdges = [fgTabuloEdge edgesFromNode:_rotation withInput:_target];
        if ([pawnEdges count] > 0)
        {
            fgTabuloEdge *edge = (fgTabuloEdge *)[pawnEdges objectAtIndex:0];
            f3GraphNode *inputNode = edge.Target;
            for (int i = 1; i < [pawnEdges count]; ++i)
            {
                edge = (fgTabuloEdge *)[pawnEdges objectAtIndex:i];
                if (inputNode != edge.Target)
                {
                    // TODO throw f3Exception
                }
            }
            inputKey = inputNode.Key;
        }
        
        targetAngle = [f3GraphEdge computeAngleBetween:targetPoint and:rotationPoint];
        rotationAngle = targetAngle - [f3GraphEdge computeAngleBetween:originPoint and:rotationPoint];

        if (rotationAngle > 180.f)
        {
            rotationAngle -= 360.f;
        }
        else if (rotationAngle < -180.f)
        {
            rotationAngle += 360.f;
        }
        
        switch (_flag)
        {
            case TABULO_HaveSmallPlank:
                rotationRadius = 1.75f;
                break;
                
            case TABULO_HaveMediumPlank:
                rotationRadius = 2.5f;
                break;
                
            case TABULO_HaveLongPlank:
                rotationRadius = 4.0f; // TODO compute gameplay for long plank
                break;
        }
        
        rotationKey = _rotation.Key;
    }

    return self;
}

- (float)Angle {

    return targetAngle;
}

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view {

    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:rotationKey];
    f3GraphNode *targetNode = [f3GraphNode nodeForKey:targetKey];
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForValues:1, FLOAT_BOX(targetAngle), nil];

    f3ControlCommand *command = [[f3ControlCommand alloc] init];
    f3TransformCommand *transform = [[f3TransformCommand alloc] initWithView:_view Point:[rotationNode getPositionHandle] Rotation:rotationAngle Radius:rotationRadius Angle:targetAngle];
    [command appendComponent:transform];
    f3ControlComposite *composite = [[f3ControlComposite alloc] init];
    [composite appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:[targetNode getPositionHandle]]];
    [composite appendComponent:[[f3SetAngleCommand alloc] initWithView:_view Angle:angleHandle]];
    [command appendComponent: composite];
    [_builder push:command];
}

@end
