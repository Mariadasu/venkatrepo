//
//  GameConfig.h
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

#define SOUND_ACTIVE
#define BACKGROUND_MUSIC_ACTIVE
//#define CONTINUOUS_PLAY

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController


#endif // __GAME_CONFIG_H
