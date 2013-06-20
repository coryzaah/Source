//
//  ViewController.h
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PassCodeView.h"
#import "DeviceSupport.h"


// interface part
typedef enum WorkView {
    WorkView_TurnAround,		// turn 360'
    WorkView_Turntable,			// Turntable
    WorkView_videos,			// Videos
    WorkView_Games,				// Games
    WorkView_Unkwnon,			// Unknown for begining
} WorkView;


// Main view Controller
@interface ViewController : UIViewController<PassCodeView_Delegate> {
    UIView*						_frame;					// Frame for interface parts
    
    NSSet*						_passcodes;				// Passcodes for fast find
    NSString*					_passcode;				// current passcode for second testes
    
    WorkView 					_currentMode;			// Current active interface part
    WorkView 					_requestMode;			// User request interface part
    UIView<FrameResize>*		_currentView;			// Interface part view (or splash screen)
    PassCodeView*				_passcodeView;			// passcode if on screen
    
    UIImageView*				_tool_background;
    UIButton*					_tool_turnaround;
    UIButton*					_tool_turntable;
    UIButton*					_tool_videos;
    UIButton*					_tool_games;
}
- (void) deactivateApplication;
- (void) activateApplication;

@end
