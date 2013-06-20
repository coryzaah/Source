//
//  Turntable.h
//  EASMonster
//
//  Created by ProgDenisMac on 09.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DeviceSupport.h"

// Turntable interface part
@interface Turntable : UIView<FrameResize, AVAudioPlayerDelegate> {
    UIImageView* 			_background;		// Background image
    UIImageView*			_disc;				// Rotating disc png sequence
    UIImageView*			_logo1;				// EA Sport logo rotating image
    UIImageView*			_logo2;				// Monster logo
    
    NSTimer*				_timer;				// Timer for roration and tonarm
    float					_angle;				// Angle of logo1 roration
    
    UIButton*				_buttons[6];		// Music change buttons
    UIImage*				_images[6][2];		// Image for buttons

    UIImageView*			_tonarm;			// Tonarm sequence
    NSInvocationOperation*	_operation;			// Load sequence operation
	NSOperationQueue*		_operationQueue;	// Load sequence operation queue
    int						_base;				// Base position of begin drag
    CGFloat					_gestposition;		// Base point of gesture
    AVAudioPlayer*			_player;			// Audio player
    int						_music;				// index of chenged music
    
	UIWebView*				_description;		// html description view
}

@end
