//
//  ViewController.h
//  Prototype
//
//  Created by Serge Menard on 13-10-24.
//  Copyright (c) 2013 Frozenfrog Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "View/fgTabuloDirector.h"
#import "../../Framework/Framework/Control/f3GameAdaptee.h"

@interface fgGameAdapter : GLKViewController {
    
    bool orientationHasChanged;
    fgTabuloDirector *director;
    f3GameAdaptee *adaptee;
}

@end
