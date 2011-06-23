//
//  HelloWorldScene.h
//  SolAPG
//
//  Created by Robert Backman on 10/25/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "CDAudioManager.h"

enum sounds {
    POP_SOUND = 0,
    PUNCH_SOUND,
    EXPLOSION_SOUND,
    REWARD_SOUND,
    SPLASH_SOUND,
    SQUEAK_SOUND,
    SQUEAK_BIG_SOUND,
    SQUEAK_SMALL_SOUND,
    ERROR_SOUND,
    ERROR2_SOUND,
    SOUND_TRACK,
    };

typedef enum {
	kAppStateAudioManagerInitialising,	//Audio manager is being initialised
	kAppStateSoundBuffersLoading,		//Sound buffers are loading
	kAppStateReady						//Everything is loaded
} tAppState;


@interface SoundLayer : CCLayer
{
	CDAudioManager *am;
	CDSoundEngine  *_soundEngine;
	tAppState		_appState;
    
}
-(void)loadLayer;

-(void) loadSoundBuffers:(NSObject*) data;
-(void) backgroundMusicFinished;
-(void)	playSound:(int)snd;

@end

