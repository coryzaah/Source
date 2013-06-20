//
//  SingleGame.h
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DeviceSupport.h"

extern const CGSize SingleGame_Size;

// Info of single game
typedef struct SingleGameInfo {
    NSString*	imageFileName;						// Image of game
    NSString*	textFileName;						// Text html file
    NSString*	link;								// http link
    CGPoint		position[DeviceOrientation_Count];	// Position on the screen
} SingleGameInfo;


// Single game view
@interface SingleGame : UIView {
    UIImageView*	_background;					// Background image of single game frame
    UIImageView*	_image;							// Image of game
    UIWebView*		_description;					// description view
    UIButton*		_play;							// Play button
    
    NSString*		_link;							// http link
}

- (id)initWithInfo:(SingleGameInfo)info;
- (void)reload;

@end
