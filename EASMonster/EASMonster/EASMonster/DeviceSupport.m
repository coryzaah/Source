//
//  DeviceSupport.m
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#include "DeviceSupport.h"

// Convert apple interface orientation to my format
DeviceOrientation convertInterfaceOrientation(UIInterfaceOrientation orient) {
    return (orient == UIInterfaceOrientationLandscapeLeft || orient == UIInterfaceOrientationLandscapeRight) ? DeviceOrientation_Horz : DeviceOrientation_Vert;
}

// Detect current interface orientation
DeviceOrientation detectDeviceOrientation() {
    return convertInterfaceOrientation([[UIApplication sharedApplication] statusBarOrientation]);
}
