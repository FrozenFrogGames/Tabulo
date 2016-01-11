//
//  fgPlankEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankEdge.h"
#import "../fgTabuloDirector.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/Control/f3ControlSequence.h"
#import "../../../Framework/Framework/Control/f3TransformCommand.h"
#import "../../../Framework/Framework/Control/f3SetAngleCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPlankEdge

+ (float)getOrientationFlag:(float)_angle {

    float orientationAngle = (_angle < 168.75f) ? _angle : _angle - 191.25f;
    
    if (orientationAngle < 11.25f || orientationAngle >= 168.75f)
    {
        return 0x00000000;
    }
    else if (orientationAngle < 33.75f)
    {
        return (0x00000001 << 0xB);
    }
    else if (orientationAngle < 56.25f)
    {
        return (0x00000002 << 0xB);
    }
    else if (orientationAngle < 78.75f)
    {
        return (0x00000003 << 0xB);
    }
    else if (orientationAngle < 101.25f)
    {
        return (0x00000004 << 0xB);
    }
    else if (orientationAngle < 123.75f)
    {
        return (0x00000005 << 0xB);
    }
    else if (orientationAngle < 146.25f)
    {
        return (0x00000006 << 0xB);
    }
    else // if (orientationAngle < 168.75f)
    {
        return (0x00000007 << 0xB);
    }
}

- (id)init:(f3NodeFlags)_mask origin:(NSNumber *)_originKey target:(NSNumber *)_targetKey node:(NSNumber *)_nodeKey {

    return [self init:_mask origin:_originKey target:_targetKey node:_nodeKey plank:UINT8_MAX];
}

- (id)init:(f3NodeFlags)_mask origin:(NSNumber *)_originKey target:(NSNumber *)_targetKey node:(NSNumber *)_nodeKey plank:(uint8_t)_plank {

    self = [super init:_mask origin:_originKey target:_targetKey node:_nodeKey];

    if (self != nil)
    {
        CGPoint originPoint = [[f3GraphNode nodeForKey:_originKey] Position];
        CGPoint targetPoint = [[f3GraphNode nodeForKey:_targetKey] Position];
        CGPoint rotationPoint = [[f3GraphNode nodeForKey:_nodeKey] Position];

        targetAngle = [f3GraphEdge angleBetween:targetPoint and:rotationPoint];

        orientationFlag = [fgPlankEdge getOrientationFlag:targetAngle];

        rotationAngle = targetAngle - [f3GraphEdge angleBetween:originPoint and:rotationPoint];

        if (rotationAngle > 180.f)
        {
            rotationAngle -= 360.f;
        }
        else if (rotationAngle < -180.f)
        {
            rotationAngle += 360.f;
        }

        switch (_plank)
        {
            case TABULO_PLANK_Small:
                rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
                break;
                
            case TABULO_PLANK_Long:
                rotationRadius = 3.5f; // long plank is 7 (7.07) units length
                break;

            case TABULO_PLANK_Medium: // medium plank is 5 (4.95) units
                rotationRadius = 2.5f;
                break;

            default:
                rotationRadius = 0.f; // TODO throw f3Exception
                break;
        }
    }

    return self;
}

- (float)Angle {

    return targetAngle;
}

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view slowMotion:(float)_slowmo {

    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:nodeKey];
    f3GraphNode *targetNode = [f3GraphNode nodeForKey:targetKey];
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(targetAngle), nil];

    float speed = [f3GraphEdge distanceBetween:[f3GraphNode nodeForKey:originKey].Position to:targetNode.Position] /2.f *_slowmo;

    f3ControlSequence *command = [[f3ControlSequence alloc] init];
    f3TransformCommand *transform = [[f3TransformCommand alloc] initWithView:_view Point:[rotationNode getPositionHandle]
                                                                    Rotation:rotationAngle Radius:rotationRadius Angle:targetAngle Speed:speed];
    [command appendComponent:transform];
    f3ControlComposite *composite = [[f3ControlComposite alloc] init];
    [composite appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:[targetNode getPositionHandle]]];
    [composite appendComponent:[[f3SetAngleCommand alloc] initWithView:_view Angle:angleHandle]];
    [command appendComponent: composite];
    [_builder push:command];
}

- (bool)initFlags:(const f3NodeFlags *)_data keys:(NSArray *)_keys {
    
    if ([_keys containsObject:originKey] && [_keys containsObject:targetKey])
    {
        const f3NodeFlags plankMask = 0xFFFF ^ (flagMask | TABULO_PLANK_ORIENTATION);
        
        const NSUInteger originIndex = [_keys indexOfObject:originKey];
        originFlags = _data[originIndex] & plankMask;
        
        const NSUInteger targetIndex = [_keys indexOfObject:targetKey];
        targetFlags = _data[targetIndex] & plankMask;
        targetFlags |= _data[originIndex] & flagMask;
        targetFlags |= orientationFlag;
        
        return true;
    }
    
    return false;
}

@end
