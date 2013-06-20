//
//  Video.h
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DeviceSupport.h"

// Videos interface part
@interface Video : UIView<FrameResize> {
    UIImageView*				_background;		// Back ground image
    UIImageView*				_logo;				// EA Sport logo
    
    MPMoviePlayerController*	_player;			// Movie mplayer
	UIWebView*					_description;		// html text view
}

@end
