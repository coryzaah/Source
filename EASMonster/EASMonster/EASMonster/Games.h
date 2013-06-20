//
//  Games.h
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSupport.h"
#import "SingleGame.h"

// Games interface part
@interface Games : UIView<FrameResize> {
    UIImageView*			_background;		// background image
    UIImageView*			_logo;				// logo image
    
    NSArray*				_games;				// subviews of game array
}

@end
