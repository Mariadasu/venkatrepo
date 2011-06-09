//
//  HelloWorldScene.mm
//  SolAPG
//
//  Created by Robert Backman on 10/25/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// Import the interfaces

#import "GameScene.h"
#import "SoundLayer.h"


@implementation SoundLayer




-(id) init
{
	if( (self=[super init])) 
	{
		
		[self schedule: @selector(update:)];
	
	}
	return self;
}



-(void)loadLayer
{
	
#ifdef SOUND_ACTIVE
	if ([CDAudioManager sharedManagerState] != kAMStateInitialised) 
	{
		//The audio manager is not initialised yet so kick off the sound loading as an NSOperation that will wait for
		//the audio manager
		NSInvocationOperation* bufferLoadOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadSoundBuffers:) object:nil] autorelease];
		NSOperationQueue *opQ = [[[NSOperationQueue alloc] init] autorelease]; 
		[opQ addOperation:bufferLoadOp];
		_appState = kAppStateAudioManagerInitialising;
	} else 
	{
		[self loadSoundBuffers:nil];
		_appState = kAppStateSoundBuffersLoading;
	}	
	
	am = [CDAudioManager sharedManager];
	_soundEngine = am.soundEngine;
	//[soundEngine playSound:SOUND_TRACK sourceGroupId:1 pitch:1.0f pan:0.0f gain:1.0 loop:NO];
#ifdef BACKGROUND_MUSIC_ACTIVE
	[am playBackgroundMusic:@"oyshort.mp3" loop:TRUE];
#endif
#endif
	
}
-(void) update: (ccTime) dt
{

}
-(NSString*)description
{
	
	return [NSString stringWithFormat: @"Sound Layer"];
}

- (void) dealloc
{
	[am stopBackgroundMusic]; am = 0;
	[_soundEngine stopAllSounds]; _soundEngine = 0;
	[super dealloc];
}
	

-(void)playSound:(int)snd
{
	#ifdef SOUND_ACTIVE
		[_soundEngine playSound:snd sourceGroupId:0 pitch:1.0f pan:0.0f gain:1.0 loop:NO];
	#endif
}



-(void) loadBuffersSynch {
	
	struct timeval start,end;
	
	gettimeofday( &start, NULL);
	
	CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine;
	[sse loadBuffer:EXPLOSION_SOUND filePath:@"Grenade.mp3"];
	[sse loadBuffer:POP_SOUND filePath:@"punch.wav"];
	[sse loadBuffer:REWARD_SOUND filePath:@"BonusEnd.mp3"];
	[sse loadBuffer:SOUND_TRACK filePath:@"oyshort.mp3"];
	[sse loadBuffer:SPLASH_SOUND filePath:@"clickfast.mp3"];
	
	
	gettimeofday( &end, NULL);
	
	float dt = (end.tv_sec - start.tv_sec) + (end.tv_usec - start.tv_usec) / 1000000.0f;
	NSLog(@"Buffer load time %0.4f",dt);
	
}	


-(void) loadSoundBuffers:(NSObject*) data 
{
	
	//Wait for the audio manager if it is not initialised yet
	while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
		[NSThread sleepForTimeInterval:0.1];
	}	
	
	
	//Load the buffers with audio data. There is no correspondence between voices/channels and
	//buffers.  For example you can play the same sound in multiple channel groups with different
	//pitch, pan and gain settings.
	//Buffers can be loaded with different sounds simply by calling loadBuffer again, however,
	//any sources attached to the buffer will be stopped if they are currently playing
	//Use: afconvert -f caff -d ima4 yourfile.wav to create an ima4 compressed version of a wave file
	CDSoundEngine *sse = [CDAudioManager sharedManager].soundEngine;
	
	//New school
	NSArray *defs = [NSArray arrayWithObjects:
					 [NSNumber numberWithInt:3],
					 [NSNumber numberWithInt:3],
					 [NSNumber numberWithInt:3],
					 [NSNumber numberWithInt:3],
					 [NSNumber numberWithInt:3],
					 nil];
	[sse defineSourceGroups:defs];
	
	
	//Code for loading buffers synchronously
	/*
	 [sse loadBuffer:SND_ID_DRUMLOOP filePath:@"808_120bpm.caf"];
	 [sse loadBuffer:SND_ID_TONELOOP filePath:@"sine440.caf"];
	 [sse loadBuffer:SND_ID_BALL filePath:@"ballbounce.wav"];
	 [sse loadBuffer:SND_ID_GUN filePath:@"machinegun.caf"];
	 [sse loadBuffer:SND_ID_STAB filePath:@"rustylow.wav"];
	 [sse loadBuffer:SND_ID_COWBELL filePath:@"cowbell.wav"];
	 [sse loadBuffer:SND_ID_EXPLODE filePath:@"explodelow.wav"];
	 [sse loadBuffer:SND_ID_KARATE filePath:@"karate.wav"];
	 */
	
	//Load sound buffers asynchrounously
	NSMutableArray *loadRequests = [[[NSMutableArray alloc] init] autorelease];
	

    
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:EXPLOSION_SOUND filePath:@"Grenade.mp3"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:POP_SOUND filePath:@"punch.wav"] autorelease]];
	[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:REWARD_SOUND filePath:@"CoinReward.mp3"] autorelease]];
    //[loadRequests addObject:[[[CDBufferLoadRequest alloc] init:SPLASH_SOUND filePath:@"clickfast.mp3"] autorelease]];
	
	[sse loadBuffersAsynchronously:loadRequests];
	_appState = kAppStateSoundBuffersLoading;
	
	//Sound engine is now set up. You can check the functioning property to see if everything worked.
	//In addition the loadBuffer method returns a boolean indicating whether it worked.
	//If your buffers loaded and the functioning = TRUE then you are set to play sounds.
	
}	 

- (void) backgroundMusicFinished {
	CCLOG(@"Denshion: backgroundMusicFinished selector called");
}		 



		 
		 
		 
@end
