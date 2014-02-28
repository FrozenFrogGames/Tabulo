//
//  fgTabuloNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloNode.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../../../Framework/Framework/View/f3TextureDecorator.h"

@implementation fgTabuloNode

- (id)initPosition:(CGPoint)_position extend:(CGSize)_extend view:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type {

    self = [super initPosition:_position extend:_extend];

    if (self != nil)
    {
        houseView = _view;
        houseType = _type;
    }

    return self;
}

- (id)initPosition:(CGPoint)_position radius:(float)_radius view:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type {

    self = [super initPosition:_position radius:_radius];

    if (self != nil)
    {
        houseView = _view;
        houseType = _type;
    }

    return self;
}

- (bool)IsPawnHome {

    return [self getFlag:houseType];
}

- (f3TextureDecorator *)buildTextureDecorator {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

    [director.Builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1152.f)
                                         atPoint:CGPointMake(128.f +(houseType *384.f), 0.f)
                                      withExtend:CGSizeMake(384.f, 384.f)]];
    [director.Builder push:[director getResourceIndex:RESOURCE_SpriteSheet]];
    [director.Builder buildDecorator:4];

    return (f3TextureDecorator *)[director.Builder popComponent];
}

@end
