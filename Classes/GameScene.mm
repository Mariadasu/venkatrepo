//
//  HelloWorldScene.mm
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "MatchObject.h"
#import "WavePool.h"
#import "MenuScene.h"
#import "SoundLayer.h"
#import "explosion.h"
#import "BonusLabel.h"

// enums that will be used as tags
enum {
	kTagBackground = -1,
	kTagEffectNode,
	kTagMatchObjectNode,
	kTagUINode
};
//test

// HelloWorld implementation
@implementation GameScene

@synthesize world;
@synthesize difficulty;

@synthesize addition;
@synthesize subtraction;
@synthesize multiplication;
@synthesize remainder;
@synthesize division;


static GameScene *sharedScene = nil;

+(id)scene
{
	if (sharedScene == nil) 
	{
	
		sharedScene = [[[GameScene alloc] init] autorelease];
	
	}
	return sharedScene;	
}

-(void)checkMatches
{
	NSMutableArray* selected = [NSMutableArray array];
	for (int i = 0;i < [self numMatchObjects]; i++) 
	{
		if([[self getMatchObject:i] isActive])
            [selected addObject:[self getMatchObject:i]];
	}
	if ([selected count]>1) 
	{
		//there are some selected so check if they are matches
		int v = -1;
		for(MatchObject* b in selected)
		{
			if (v==-1) { v = [b val]; }
			else 
			{
				if (v != [b val]) 
				{
					//there are mismatches
					v=-1;
					break;
				}
			}

		}
		if (v==-1) 
		{
			NSLog(@"there were mismatches");
		}
		else
		{
			for(MatchObject* b in selected)
			{
				[b destroy];
                
			}
		}

	}
	[selected removeAllObjects];
	selected = 0;
	
}
-(CCArray*)MatchObjects
{
	return [[self getChildByTag:kTagMatchObjectNode] children];
}
-(void)addRippleAt:(CGPoint)p radius:(int)r value:(int)v
{
     [waves addRippleAt:p radius:r val:v];
}
-(int)numMatchObjects
{
	return [[self MatchObjects] count];
}
-(MatchObject*)getMatchObject:(int)i
{
	return [[self MatchObjects] objectAtIndex:i];
}
-(int)getMatchObjectValue:(int)i
{
	return [[self getMatchObject:i] val];
}
-(void)addMatchObjectAtPosition:(CGPoint)p value:(int)v
{
	
	[[self getChildByTag:kTagMatchObjectNode] addChild:[MatchObject matchObjectWithPosition:p value:v]];

}


-(void) pauseScene: (id) sender
{
	[[CCDirector sharedDirector] pushScene:[CCTransitionFlipY transitionWithDuration:2 scene:[MenuScene scene] orientation:kOrientationLeftOver]] ;
}

-(id) init
{
	if( (self=[super init])) {
		difficulty = 1;
		maxMatchObjects = 6;
		addition = YES;
		multiplication = YES;
		division = YES;
		remainder = YES;
		subtraction = YES;
        levelUp = NO;
        levelUpScale = 1.0f;
        score = 0;
        
        
        sound = [[[SoundLayer alloc] init] autorelease];
        //[self addChild:sound];
        [sound loadLayer];
		
		background = [CCSprite spriteWithFile:@"gridBackground.png"];
		background.anchorPoint = ccp(0,0);
		background.position = ccp(0,0);
		waves = [[WavePool alloc] initWithImage:background size:ccg(30,30)];
		
		[self addChild:background z:kTagBackground tag:kTagBackground];
		
	
		CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseScene:)];
		[pauseButton setScale:3];
		CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
		
		menu.position = ccp(64,32);
		
		[self addChild: menu z:1];
		
                
		[background runAction:waves];
		
		
		// enable touches
		self.isTouchEnabled = YES;
		
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f,0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = NO;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,80/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,80/PTM_RATIO));
        groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
        groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,80/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,80/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		
		[self addChild:[CCNode node]  z:kTagMatchObjectNode tag:kTagMatchObjectNode ];
	


        
        levelUpLabel = [CCLabelTTF labelWithString:@"Level Up" fontName:@"Marker Felt" fontSize:256];
		[self addChild:levelUpLabel z:0];
		[levelUpLabel setColor:ccc3(0,0,255)];
		levelUpLabel.position = ccp( screenSize.width/2, screenSize.height/2);
         [levelUpLabel setVisible:NO];

       scoreLabel = [CCLabelTTF labelWithString:@"Score:0" fontName:@"Marker Felt" fontSize:64];
  
        [self addChild:scoreLabel z:0];
		[scoreLabel setColor:ccc3(0,0,255)];
		scoreLabel.position = ccp( screenSize.width/2, screenSize.height-64);
        
		[self schedule: @selector(update:)];
		
		first = YES;
	}
	return self;
}


-(int)needsVal
{

    if([self numMatchObjects]==0)
        return 0;
    
	for(int i = 0; i < [self numMatchObjects]; i++)
	{
		MatchObject* b = [self getMatchObject:i];
			for(int j = 0; j < [self numMatchObjects]; j++)
			{
				
				if (i != j) 
				{
					MatchObject* b2 = [self getMatchObject:j];
					if ([b val] == [b2 val]) 
					{
						//there is a match so return 0
						return 0;
					}
					

				}
				
			}
		
		
	}
	return [[self getMatchObject:CCRANDOM_0_1()*[self numMatchObjects]] val];	
}

-(void)addMatchObject:(CGPoint)p
{
	
	
	int v = rand() % (difficulty<<2); // [self needsVal];
	v = v?v:1;
	v = (v%2)?-v:v;
	
	if(v) 
	{
		[self addMatchObjectAtPosition:p value:v];	
	}
	else 
	{
		[self addMatchObjectAtPosition:p value:1+CCRANDOM_0_1()*6 * difficulty];	
	}

}
-(void)newLevel
{
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<3;j++)
        {
            if([self numMatchObjects] >= maxMatchObjects)
                return;
            
            [self addMatchObject:ccp(256 + j*256 + CCRANDOM_MINUS1_1()*64, 256+i*256 + CCRANDOM_MINUS1_1()*64 )];
        }
    }
	
}
-(void) draw
{
	/*
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	 */

}


-(void)updatePhysics:(float)dt
{
    //add a repulsion force between the objects so they dont bunch up
    for(MatchObject* b1 in [self MatchObjects])
    {
        
        for(MatchObject* b2 in [self MatchObjects])
        {
            
            if(b1!=b2)
            {
                
                CGPoint len = ccpSub([b2 position], [b1 position] );
                float length = ccpLength(len);
                
                if(length>32 && length < 256)
                {
                    CGPoint force = ccpNormalize(len);
                    
                    force = ccpMult(force, 150000.0f/(length*length));
                    
                    // printf("the force is %g\n",ccpLength(force));
                    [b2 addForce:force ];
                    [b1 addForce:ccpMult(force, -1.0f)];
                }
                
            }
        }
        
    }
    //It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
}
-(void)addBonusLabelAt:(CGPoint)p value:(int)v
{
    int matches = 0;
    
    for (Wave* w1 in [waves waves]) 
    {
        if ([w1 value] == v) 
        {
            matches++;
            
        }
        else
        {
             
             break;
        }
    }
    if (matches>0) 
    {
        
        [self addChild:[BonusLabel bonusLabelWithPosition:p value:matches*100]];
        [sound playSound:REWARD_SOUND];
        score += matches*100;
    }
    else
    {
       [self addChild:[BonusLabel bonusLabelWithPosition:p value:10]];
        score += 10;
    }
    
    
    [scoreLabel setString:[NSString stringWithFormat:@"Score:%d",score]];
    
}
-(void) update: (ccTime) dt
{
	
	if (first)
	{
		first = NO;
		[self newLevel];
	}
   
#ifdef CONTINUOUS_PLAY
	while ([self numMatchObjects]<maxMatchObjects) 
		[self addMatchObject];
#else
    
    if([self numMatchObjects]==0 && !levelUp)
    {
        levelUpScale = 1.0f;
        levelUp = YES;
        [levelUpLabel setVisible:YES];
        //[levelUpLabel setOpacity:1];
    
    }
    if(levelUp)
    {
        levelUpScale *= 0.9f;
        [levelUpLabel setScale:levelUpScale];
       // [levelUpLabel setOpacity:levelUpScale];
        if (levelUpScale<=0.1f) 
        {
            levelUp = NO;
            [levelUpLabel setVisible:NO];
            [waves removeAllWaves];
            [self newLevel];
        }
    }
#endif
    
    
    
    [self updatePhysics:dt];
    
	[waves update:dt];
    
   
    for (int i=0;i<[self numMatchObjects];i++) 
    {
        MatchObject* anObject = [self getMatchObject:i];
        
        [anObject update:dt];
        
        
        
        if(![anObject alive])
        {
            [[GameScene scene] addChild:[RingExplosion explosionAtPosition:[anObject position]]];
            //[[GameScene scene] addChild:[BlockExplosion explosionAtPosition:[anObject position]]];
            [sound playSound:POP_SOUND];
            
            [anObject destroy];
        }
        else
        {
            for(Wave* w in  [waves waves])
            {
                float h = [w heightAt:[anObject position]] ;
                
                if (h > 0 )
                {
                    [anObject setAlive:NO];
                }
            }
        }
    }                  
  
	

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	
    /*
     static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
     */
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
