//
//  HelloWorldScene.mm
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "Bubble.h"
#import "WavePool.h"
#import "MenuScene.h"
#import "SoundLayer.h"

// enums that will be used as tags
enum {
	kTagBackground = -1,
	kTagEffectNode,
	kTagBubbleNode,
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
	for (int i = 0;i < [self numBubbles]; i++) 
	{
		if([[self getBubble:i] active])[selected addObject:[self getBubble:i]];
	}
	if ([selected count]>1) 
	{
		//there are some selected so check if they are matches
		int v = -1;
		for(Bubble* b in selected)
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
			for(Bubble* b in selected)
			{
				[b destroy];
                [sound playSound:POP_SOUND];
			}
		}

	}
	[selected removeAllObjects];
	selected = 0;
	
}
-(CCArray*)bubbles
{
	return [[self getChildByTag:kTagBubbleNode] children];
}
-(int)numBubbles
{
	return [[self bubbles] count];
}
-(Bubble*)getBubble:(int)i
{
	return [[self bubbles] objectAtIndex:i];
	
}
-(int)getBubbleValue:(int)i
{
	return [[self getBubble:i] val];
}
-(void)addBubbleAtPosition:(CGPoint)p value:(int)v
{
	
	[[self getChildByTag:kTagBubbleNode] addChild:[Bubble bubbleWithPosition:p value:v]];

}

-(void)addRippleAt:(CGPoint)p
{
	id bg = [self getChildByTag:kTagBackground] ;
	[bg runAction:[CCRipple3D actionWithPosition:p radius:256 waves:3 amplitude:1 grid:ccg(32,24) duration:8]];
}
// initialize your instance here
-(void) pauseScene: (id) sender
{
	[[CCDirector sharedDirector] pushScene:[CCTransitionFlipY transitionWithDuration:2 scene:[MenuScene scene] orientation:kOrientationLeftOver]] ;
}

-(id) init
{
	if( (self=[super init])) {
		difficulty = 1;
		
		addition = YES;
		multiplication = YES;
		division = YES;
		remainder = YES;
		subtraction = YES;
		
        
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
		
		menu.position = ccp(32,32);
		
		[self addChild: menu z:1];
		
		
		
		[background runAction:waves];
		
		maxBubbles = 5;
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
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		[self addChild:[CCNode node]  z:kTagBubbleNode tag:kTagBubbleNode ];
	
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		
		[self schedule: @selector(tick:)];
		
		first = YES;
	}
	return self;
}


-(int)needsVal
{

	for(int i = 0; i < [self numBubbles]; i++)
	{
		Bubble* b = [self getBubble:i];
			for(int j = 0; j < [self numBubbles]; j++)
			{
				
				if (i != j) 
				{
					Bubble* b2 = [self getBubble:j];
					if ([b val] == [b2 val]) 
					{
						//there is a match so return 0
						return 0;
					}
					

				}
				
			}
		
		
	}
	return [[self getBubble:CCRANDOM_0_1()*[self numBubbles]] val];	
}

-(void)addBubble
{
	
	
	int v = [self needsVal];
	if(v) 
	{
		[self addBubbleAtPosition:ccp(64+CCRANDOM_0_1()*(screenSize.width-128),64+CCRANDOM_0_1()*(screenSize.height-128)) value:v];	
	}
	else 
	{
		[self addBubbleAtPosition:ccp(64+CCRANDOM_0_1()*(screenSize.width-128),64+CCRANDOM_0_1()*(screenSize.height-128)) value:1+CCRANDOM_0_1()*6 * difficulty];	
	}

}
-(void)newGame
{
	for (int i=0; i<maxBubbles; i++) 
	{
		[self addBubble];
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




-(void) tick: (ccTime) dt
{
	
	if (first)
	{
		first = NO;
		[self newGame];
	}
    
	while ([self numBubbles]<maxBubbles) 
		[self addBubble];
	
    CCArray* rem = [CCArray array];
    for(Bubble* b1 in [self bubbles])
    {
        if(![b1 alive])
            [rem addObject:b1];
    }
    [[self bubbles] removeObjectsInArray:rem];
    
    
    for(Bubble* b1 in [self bubbles])
    {
        
        for(Bubble* b2 in [self bubbles])
        {
            
            if(b1!=b2)
            {
                
                CGPoint len = ccpSub([b2 getPosition], [b1 getPosition] );
                float length = ccpLength(len);
                
                if(length>32 && length < 512)
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

    
    
	[self checkMatches];
	
	[waves update:dt];
    
   
    for (int i=0;i<[self numBubbles];i++) 
    {
        [[self getBubble:i] update:dt];
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

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		[waves addRippleAt:location];
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
