//
//  f3ViewController.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgGameAdapter.h"
#import "fgDataAdapter.h"
#import "fgViewCanvas.h"
#import "fgViewAdapter.h"
#import "fgTabuloDirector.h"
#import "Control/fgMenuState.h"

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
        
        orientationHasChanged = true;
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
    
    [adaptee buildMenuState:director.Builder];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSObject<IViewCanvas> *canvas = (fgViewCanvas *)self.view;
    
    [director loadResource:canvas];

    [canvas setScreen:adaptee.ScreenSize unit:adaptee.UnitSize];
    
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

- (BOOL)shouldAutorotate {

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
 
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
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
    NSObject<IViewCanvas> *canvas = (NSObject<IViewCanvas> *)self.view;

    [adaptee update:self.timeSinceLastUpdate];

    if (orientationHasChanged)
    {
        [adaptee updateCanvas:canvas orientation:[[UIDevice currentDevice] orientation]];
    }
    
    CGSize unitSizeScaled = CGSizeMake(adaptee.UnitSize.width * adaptee.UnitScale, adaptee.UnitSize.height * adaptee.UnitScale);

    if (orientationHasChanged || canvas.UnitSize.width != unitSizeScaled.width || canvas.UnitSize.height != unitSizeScaled.height)
    {
        [canvas setScreen:adaptee.ScreenSize unit:unitSizeScaled];
        
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
    CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:[touchArray objectAtIndex:0]]];

    [adaptee notifyInput:relativePoint type:GRAPH_InputBegan];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:[touchArray objectAtIndex:0]]];

    [adaptee notifyInput:relativePoint type:GRAPH_InputMoved];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    CGPoint relativePoint = [adaptee relativePointInScreen:[self absolutePointInTouch:[touchArray objectAtIndex:0]]];
    
    [adaptee notifyInput:relativePoint type:GRAPH_InputEnded];
}

@end
