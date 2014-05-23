//
//  f3ViewController.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgGameAdapter.h"
#import "fgViewCanvas.h"
#import "fgViewAdapter.h"
#import "fgDataAdapter.h"
#import "Control/fgTabuloEvent.h"
#import "Control/fgMenuState.h"
#import "View/fgTabuloDirector.h"

@interface fgGameAdapter ()

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation fgGameAdapter

@synthesize context = _context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil)
    {
        director = [[fgTabuloDirector alloc] init:[fgViewAdapter class]];

        adaptee = [[f3GameAdaptee alloc] initAdaptee:[fgMenuState class]];

        orientationHasChanged = false;
    }
    
    return self;
}

- (void)loadView {
    
    self.view = [fgViewCanvas alloc];
}

- (void)viewDidLoad
{
    fgViewCanvas *canvas = nil;

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (self.context != nil)
    {
        canvas = (fgViewCanvas *)self.view;
        canvas = [canvas init:self.context];
        canvas.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    }
    else
    {
        // TODO throw f3Exception @"Failed to create ES context"
    }
    
    [EAGLContext setCurrentContext:self.context];

    [adaptee updateCanvas:(NSObject<IViewCanvas> *)self.view orientation:[[UIDevice currentDevice] orientation]];
    
    [director loadResource:canvas];

    [director loadSavegame];

    [adaptee buildMenu:director.Builder];
}

- (void)viewWillAppear:(BOOL)animated {

    [director loadResource:(fgViewCanvas *)self.view];
    
    [director.Scene refresh];

    [super viewWillAppear:animated];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {

    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [super viewWillDisappear:animated];

    [director clearResource];
}

- (void)viewOrientationDidChange:(NSNotification *)notification {
    
    orientationHasChanged = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // TODO dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIDeviceOrientationIsLandscape(interfaceOrientation))
    {
        return YES;
    }

    return NO;
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
    director = nil;
    
    adaptee = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [adaptee update:self.timeSinceLastUpdate];

    if (orientationHasChanged)
    {
        [adaptee updateCanvas:(NSObject<IViewCanvas> *)self.view orientation:[[UIDevice currentDevice] orientation]];

        orientationHasChanged = false;
    }

    [director.Scene refresh];
}

#pragma mark - Touch based methods

- (CGPoint)absolutePointInTouch:(UITouch *)_touch {

    CGPoint absolutePoint = [_touch locationInView:self.view];

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) // to support RETINA display
    {
        absolutePoint.x = absolutePoint.x * [[UIScreen mainScreen] scale];
        absolutePoint.y = absolutePoint.y * [[UIScreen mainScreen] scale];
    }

    return absolutePoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSArray *touchArray = [[event touchesForView:self.view] allObjects];

    for (id touch in touchArray)
    {
        CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:touch]];

        [adaptee notifyInput:relativePoint type:INPUT_BEGAN];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    
    for (id touch in touchArray)
    {
        CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:touch]];

        [adaptee notifyInput:relativePoint type:INPUT_MOVED];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    
    for (id touch in touchArray)
    {
        CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:touch]];

        [adaptee notifyInput:relativePoint type:INPUT_ENDED];
    }
}

@end
