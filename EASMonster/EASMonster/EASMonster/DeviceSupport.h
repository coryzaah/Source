//
//  DeviceSupport.h
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>

// My orientation indexes
typedef enum DeviceOrientation {
    DeviceOrientation_Horz,					// horizontal index
    DeviceOrientation_Vert,					// vertical indexes

    DeviceOrientation_Count					// count of orientation
} DeviceOrientation;


// file source item on screen
typedef struct FileItemInfo {
    NSString*	fileName;
    CGRect 		rects[DeviceOrientation_Count];
} FileItemInfo;


// Convert interface orientations to my orientation indexes
DeviceOrientation convertInterfaceOrientation(UIInterfaceOrientation orient);

// Detect current device orientation indexes
DeviceOrientation detectDeviceOrientation();


// Protocol of interface part
@protocol FrameResize <NSObject>

- (void) resize:(DeviceOrientation)orient;	// Resize to orientation
- (void) stopAll;							// stop all view processes

- (void) pause;								// pause processes
- (void) start;								// start / continue processes

@end
