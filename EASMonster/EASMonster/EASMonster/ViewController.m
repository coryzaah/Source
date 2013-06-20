//
//  ViewController.m
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "ViewController.h"

#import "TurnAround.h"
#import "Turntable.h"
#import "SplashScreen.h"
#import "Games.h"
#import "Video.h"

static const FileItemInfo Tool_Background	=
{
    @"toolbar_background.jpg",
    {{{ 0, 708}, {  1024,  60}}, {{ -128, 964}, { 1024,  60}}}
};

static const FileItemInfo Tool_TurnAround	=
{
    @"toolbar_turnaround.png",
    {{{ 0, 708}, {  346,  60}}, {{ -128, 964}, {  346,  60}}}
};

static const FileItemInfo Tool_Turntable	=
{
    @"toolbar_turntable.png",
    {{{ 347, 708}, {  212,  60}}, {{ 219, 964}, {  212,  60}}}
};

static const FileItemInfo Tool_Video	=
{
    @"toolbar_video.png",
    {{{ 560, 708}, {  186,  60}}, {{ 432, 964}, {  186,  60}}}
};

static const FileItemInfo Tool_Games	=
{
    @"toolbar_games.png",
    {{{ 745, 708}, {  280,  60}}, {{ 617, 964}, {  280,  60}}}
};


static const float interfaceToolBarHeight			= 60.0f;
	
// Passcode static array
static const int codes_number = 1;
static NSString* const codes[codes_number] =
{
    @"2013"
};

@interface ViewController ()

@end

@implementation ViewController

- (BOOL) shouldAutorotate {
    return TRUE;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _currentMode		= WorkView_Unkwnon;
    _requestMode		= WorkView_Unkwnon;
    
    UIView*	selfview 	= [self view];
    CGRect 	rect		= [selfview bounds];
    rect.origin			= CGPointZero;
    
    [selfview setClipsToBounds:TRUE];
    [selfview setBackgroundColor:[UIColor blackColor]];

    { // codes
        NSMutableSet* set  = [[NSMutableSet alloc] init];
        for(int i = 0; i < codes_number; ++i)
			[set addObject:codes[i]];
        _passcodes = set;
    }
    
    {
		_frame = [[UIView alloc] init];
        [_frame setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - interfaceToolBarHeight)];
        [_frame setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_frame setUserInteractionEnabled:TRUE];
        [selfview addSubview:_frame];
    }
    
    { // Create toolbar
        _tool_background	= [[UIImageView alloc] initWithImage:[UIImage imageNamed:Tool_Background.fileName]];
        _tool_turnaround 	= [UIButton buttonWithType:UIButtonTypeCustom];
        _tool_turntable 	= [UIButton buttonWithType:UIButtonTypeCustom];
        _tool_videos 		= [UIButton buttonWithType:UIButtonTypeCustom];
        _tool_games 		= [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_tool_turnaround	setImage:[UIImage imageNamed:Tool_TurnAround.fileName] forState:UIControlStateNormal];
        [_tool_turnaround 	addTarget:self action:@selector(onChangeTurnAround:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tool_turntable	setImage:[UIImage imageNamed:Tool_Turntable.fileName] forState:UIControlStateNormal];
        [_tool_turntable 	addTarget:self action:@selector(onChangeTurntable:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tool_videos		setImage:[UIImage imageNamed:Tool_Video.fileName] forState:UIControlStateNormal];
        [_tool_videos 		addTarget:self action:@selector(onChangeVideos:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tool_games		setImage:[UIImage imageNamed:Tool_Games.fileName] forState:UIControlStateNormal];
        [_tool_games 		addTarget:self action:@selector(onChangeGames:) forControlEvents:UIControlEventTouchUpInside];
        
        [selfview addSubview:_tool_background];
        [selfview addSubview:_tool_turnaround];
        [selfview addSubview:_tool_turntable];
        [selfview addSubview:_tool_videos];
        [selfview addSubview:_tool_games];
    }
    
    [self resize:detectDeviceOrientation()];
    return;
}

- (void) dealloc {
    [_tool_background	release];
    [_tool_turnaround	release];
    [_tool_turntable	release];
    [_tool_videos		release];
    [_tool_games		release];

    [_currentView		stopAll];
    [_currentView		release];
    [_passcodeView		release];

    [_frame				release];
    [_passcodes 		release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self resize:convertInterfaceOrientation(toInterfaceOrientation)];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_currentView pause];
    return;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_currentView start];
    return;
}

- (void) resize:(DeviceOrientation)orient {
    UIView* selfview = [self view];
    
    CGRect rect = [selfview bounds];
    rect.origin = CGPointZero;
    
    [_tool_background 	setFrame:Tool_Background.rects[orient]];
    [_tool_turnaround 	setFrame:Tool_TurnAround.rects[orient]];
    [_tool_turntable 	setFrame:Tool_Turntable.rects[orient]];
    [_tool_videos 		setFrame:Tool_Video.rects[orient]];
    [_tool_games 		setFrame:Tool_Games.rects[orient]];
    
    [_currentView resize:orient];
    
    return;
}

- (void) deactivateApplication {
    [_passcode release];
    _passcode = nil;
    if([_currentView respondsToSelector:@selector(stopAll)])
	    [_currentView stopAll];
    if(![_currentView isKindOfClass:[SplashScreen class]]) {
        [_currentView	removeFromSuperview];
        [_currentView	release];
        _currentView	= [[SplashScreen alloc] init];
        [self.view addSubview:_currentView];
    }
    if([_passcodeView isKindOfClass:[PassCodeView class]]) {
        [_passcodeView reset];
    }
    return;
}

- (void) activateApplication {
    if(![_passcodeView isKindOfClass:[PassCodeView class]]) {
	    if(_currentMode == WorkView_Unkwnon)
    	    _currentMode = WorkView_TurnAround;
    	[self testPassword:_currentMode];
    } else {
    }
    return;
}

- (bool) testPassword:(WorkView)mode {
    if([_passcodes containsObject:_passcode])
        return true;

    [_currentView	removeFromSuperview];
    [_currentView	release];
    
    _requestMode 	= mode;
    _currentMode	= WorkView_Unkwnon;
    _currentView	= [[SplashScreen alloc] init];
    _passcodeView	= [[PassCodeView alloc] init];
    
    [_passcodeView	setEnableCancel:FALSE];
    [_passcodeView	setDelegate:self];
    
    UIView* selfview = [self view];
    [selfview		addSubview:_currentView];
    [selfview		addSubview:_passcodeView];

    return false;
}

- (void) enterPasscode:(PassCodeView*)sender {
    if([_passcodes containsObject:[sender passcode]]) {
        [_passcode		release];
        _passcode		= [_passcodeView passcode];
        [_passcode		retain];

	    [_passcodeView	removeFromSuperview];
        [_passcodeView	release];
        _passcodeView	= nil;
        
        [_currentView	removeFromSuperview];
        [_currentView	release];
        _currentView = nil;
        
        [self setCurrentMode:_requestMode];
        return;
    }
    [sender reset];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid passcode" delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:nil] autorelease];
    [alert show];
    return;
}

- (void) cancelPasscode:(PassCodeView*)sender {
/*    [_passcodeView	removeFromSuperview];
    [_passcodeView	release];
    _passcodeView	= nil;

    [self setCurrentMode:_requestMode];*/
    return;
}

// Monster 360 action
- (void) onChangeTurnAround:(id)sender {
    [self setCurrentMode:WorkView_TurnAround];
    return;
}

// Turntable action
- (void) onChangeTurntable:(id) sender {
    [self setCurrentMode:WorkView_Turntable];
    return;
}

// Videos action
- (void) onChangeVideos:(id)sender {
    [self setCurrentMode:WorkView_videos];
}

// Games action
- (void) onChangeGames:(id) sender {
    [self setCurrentMode:WorkView_Games];
}

- (void) setCurrentMode:(WorkView)mode {
    if(_currentMode != mode) {
        CGRect rect = [_frame bounds];
        rect.origin = CGPointZero;
        
        UIView<FrameResize>* newview = nil;
        
        switch (mode) {
            case WorkView_TurnAround:
                newview = [[TurnAround alloc] init];
                break;
            case WorkView_Turntable:
                newview = [[Turntable alloc] init];
                break;
            case WorkView_videos:
                newview = [[Video alloc] init];
                break;
            case WorkView_Games:
                newview = [[Games alloc] init];
                break;
                
            default:
                break;
        }
        
        [newview setFrame:rect];
        [newview setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        [_frame addSubview:newview];
        
        [_currentView removeFromSuperview];
        [_currentView stopAll];
        [_currentView release];
        _currentView = newview;
        [_currentView start];
        
        _currentMode = mode;
    }
    return;
}


@end
