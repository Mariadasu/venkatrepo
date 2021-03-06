//
//  HelloWorldScene.mm
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright Student: UC Merced 2010. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "GameLogic.h"
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

@synthesize score;
@synthesize world;
@synthesize difficulty;
@synthesize sound;
@synthesize addition;
@synthesize subtraction;
@synthesize multiplication;
@synthesize remainder;
@synthesize division;
@synthesize symbols;
@synthesize fraction;

static GameScene *sharedScene = nil;

+(id)scene
{
	if (sharedScene == nil) 
	{
        
		sharedScene = [[[GameScene alloc] init] autorelease];
        
	}
	return sharedScene;	
}

-(CCArray*)MatchObjects
{
	return [[self getChildByTag:kTagMatchObjectNode] children];
}
-(void)removeAllMatchObjects
{
    [[self getChildByTag:kTagMatchObjectNode] removeAllChildrenWithCleanup:YES];
}
-(void)removeMatchObject:(MatchObject*)mo
{
    CCNode* n = [self getChildByTag:kTagMatchObjectNode];
    [n removeChild:mo cleanup:YES];
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
	return [GameLogic getVal:[[self getMatchObject:i] value]];
}
-(void)addMatchObjectAtPosition:(CGPoint)p value:(int)v
{
	
	[[self getChildByTag:kTagMatchObjectNode] addChild:[MatchObject matchObjectWithPosition:p value:v]];
    
    
}

-(void) pauseScene: (id) sender
{
	[[CCDirector sharedDirector] pushScene:[CCTransitionMoveInR transitionWithDuration:2 scene:[MenuScene scene]] ];

}

-(void)setLevel:(int)lev
{
    
    level = lev;
    
    switch (level) 
    {
        case 0:
        {
            symbols = NO;
            addition = NO;
            subtraction = NO;
            multiplication = NO;
            division = NO;
            remainder = NO;
            fraction = NO;
            
        }break;
        case 1:
        {
            symbols = YES;
            addition = NO;
            subtraction = NO;
            multiplication = NO;
            division = NO;
            remainder = NO;
            fraction = NO;            
        }break;
        case 2:
        {
            symbols = YES;
            addition = YES;
            subtraction = NO;
            multiplication = NO;
            division = NO;
            remainder = NO;
            fraction = NO;
        }break;
        case 3:
        {
            symbols = YES;
            addition = YES;
            subtraction = YES;
            multiplication = NO;
            division = NO;
            remainder = NO;
            fraction = NO;
        }break;
        case 4:
        {
            symbols = YES;
            addition = YES;
            subtraction = YES;
            multiplication = YES;
            division = NO;
            remainder = NO;
            fraction = NO;
        }break;
        case 5:
        {
            symbols = YES;
            addition = YES;
            subtraction = YES;
            multiplication = YES;
            division = YES;
            remainder = NO;
            fraction = NO;
        }break;
        case 6:
        {
            symbols = YES;
            addition = YES;
            subtraction = YES;
            multiplication = YES;
            division = YES;
            remainder = YES;
            fraction = NO;
        }break;
        case 7:
        {
            symbols = YES;
            addition = YES;
            subtraction = YES;
            multiplication = YES;
            division = YES;
            remainder = YES;
            fraction = YES;
        }break;

        default:
            break;
    }
}

-(void)setDifficulty:(int)df 
{
     difficulty = df;
    if(difficulty>4)
    {
        difficulty = 0;
        [ self setLevel:level+1];
    }
    
   
    maxMatchObjects = 4 + (int)(difficulty*0.3f);
    minMatches = 2 + (int)(difficulty*0.5f);
}

-(id) init
{
	if( (self=[super init])) {
		
        [self setLevel:0];
        [self setDifficulty:0];
        levelUp = NO;
        levelUpScale = 1.0f;
        score = 0;
        
        selectedObjects = [[CCArray alloc] init];
        
        sound = [[[SoundLayer alloc] init] autorelease];
        //[self addChild:sound];
        [sound loadLayer];
		
		background = [CCSprite spriteWithFile:@"gridBackground.png"];
		background.anchorPoint = ccp(0,0);
		background.position = ccp(0,0);
		
        waves = [[WavePool alloc] initWithImage:background size:ccg(30,30)];
		
		[self addChild:background z:kTagBackground tag:kTagBackground];
		
        [background runAction:waves];
		
        
        
		CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseScene:)];
		[pauseButton setScale:3];
		CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
		
		menu.position = ccp(64,32);
		
		[self addChild: menu z:1];
		
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
        
		[levelUpLabel setColor:ccc3(255,255,255)];
		levelUpLabel.position = ccp( screenSize.width/2, screenSize.height/2);
        [levelUpLabel setVisible:NO];
        
        scoreLabel = [CCLabelTTF labelWithString:@"Score:0" fontName:@"Marker Felt" fontSize:64];
        
        [self addChild:scoreLabel z:0];
		[scoreLabel setColor:ccc3(255,255,255)];
		scoreLabel.position = ccp( screenSize.width/2, screenSize.height-64);
        
		[self schedule: @selector(update:)];
		
		first = YES;
	}
	return self;
}


-(void)addMatchObject:(CGPoint)p
{
	
	/*I am not sure this will guarentee a match is on screen
	 It does not but that's because it's inefficient and we need a better way to control
	 so changed it to just generating bubbles for now but the numbers are fairly low so there are matches*/
	/* int v = (rand() % (difficulty<<3)) + 1; // [self needsVal];
     v = (v%2)?-v:lv;
     
     
     
     if(v) 
     {
     [self addMatchObjectAtPosition:p value:v];	
     }
     else 
     {
     [self addMatchObjectAtPosition:p value:1+CCRANDOM_0_1()*6 * difficulty];	
     } OLD CODE*/
    // Kelvin: New Structure
    
    [self addMatchObjectAtPosition:p value:[GameLogic genNum]];	
    
}
/*add maxMaxbjects to the level in a grid like patterns*/
-(void)newLevel
{
    [selectedObjects removeAllObjects];
    [ [self getChildByTag:kTagMatchObjectNode] removeAllChildrenWithCleanup:YES];
    
    
     
    int nums[maxMatchObjects]; // Holds all the numbers for the current Scene
  
    int makeMatch = minMatches; // Assumes minMatches is less than half of maxMatchObjects
    int n = 0;
    for (n = 0; n < maxMatchObjects; n++)
    {
        if (n == (maxMatchObjects - makeMatch))
            nums[n] = [GameLogic getVal:nums[--makeMatch]]; // Copy the effective value from beginning index
        else
            nums[n] = [GameLogic genNum];
    }
    
  
    n = 0;            
    for(int i=0;i<maxMatchObjects/3+1;i++)
    {
        for(int j=0;j<3;j++)
        {
            if([self numMatchObjects] >= maxMatchObjects)
            {
               return;
            }
            
            // Kelvin: this logic needs to change the bubbles are being created outside the grid so changed i*256 to i*128
            printf("index %d has value %d\n", n, nums[n]);
            [self addMatchObjectAtPosition:ccp(256 + j*256 + CCRANDOM_MINUS1_1()*64, 256+i*128 + CCRANDOM_MINUS1_1()*64 ) value:nums[n++]];
        }
    }
    
	
}
/*enable this to draw any level graphics with pure opengl commands.. everything else is handled by the rendering engine*/
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

/*calculate forces and make a timestep for the physics*/
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
/*A bonus label is currently the way to add points*/
-(void)addBonusLabelAt:(CGPoint)p value:(int)v
{
    int matches = 0;
    /*check if there are any waves that have the value being added*/
    for (Wave* w1 in [waves waves]) 
    {
        if ([w1 value] == v)
        {
            matches++;
            
        }
        else
        {
            /*not sure how to handle this but essentially it means to get a bonus you have to have only popped bubbles with the
             same value. so if you bopped one with a differnt value then you dont get bonus, but then it seems very hard to get a bonus since the waves 
             lase for a while*/
            //matches = 0;  
            //  break;
        }
    }
    //  printf("num matches %d\n",matches);
    if (matches>0) 
    {
        /*if there is matches add more points, right now it is 100 times the number of matches so far*/
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
    
   
    
//    printf("%d %d %d %d %d %d\n",addition,subtraction,multiplication,division,remainder,symbols);
#ifdef CONTINUOUS_PLAY
    /*keep maxMatchObject number of objects on screen*/
    while ([self numMatchObjects]<maxMatchObjects) 
        [self addMatchObject];
#else
    /*once the objects are clear make a new level*/
    if([self numMatchObjects]==0 && !levelUp)
    {
        levelUpScale = 0.1f;
        levelUp = YES;
        [self setDifficulty:difficulty+1];
       
        if (difficulty == 0) 
        {
            [levelUpLabel setString:[NSString stringWithFormat:@"LEVEL: %d",level]];
        }
        else
        {
            [levelUpLabel setString:[NSString stringWithFormat:@"STAGE: %d",difficulty]];
        }
        
        [levelUpLabel setVisible:YES];
        //[levelUpLabel setOpacity:1];
        
    }
    if(levelUp)
    {
         
        levelUpScale *= 1.05f;
        [levelUpLabel setScale:levelUpScale];
        // [levelUpLabel setOpacity:levelUpScale];
        if (levelUpScale>=0.75) 
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
    
    /*clear out any MatchObjects that are not alive and add an explosion and a pop sound*/
    for (int i=0;i<[self numMatchObjects];i++) 
    {
        MatchObject* anObject = [self getMatchObject:i];
        
       // [anObject update:dt];
        
        if(![anObject alive])
        {
            [[GameScene scene] addChild:[RingExplosion explosionAtPosition:[anObject position]]];
            //[[GameScene scene] addChild:[BlockExplosion explosionAtPosition:[anObject position]]];
            [sound playSound:POP_SOUND];
            
            if ([selectedObjects containsObject:anObject]) 
            {
                [selectedObjects removeObject:anObject];
            }
           
            
            //[self removeMatchObject:anObject];
            [anObject destroy];
           
            anObject = 0;
           
        }
        else
        {
            /*check if any waves are hitting this object and then pop them without considering a bonus or making a new wave*/
            for(Wave* w in  [waves waves])
            {
                if ([w value] == [anObject getVal]) 
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
    
	
    
}
-(void)objectPressed:(MatchObject*)obj
{
    for(MatchObject* m in selectedObjects)
    {
        if ([GameLogic getVal:[m value]] != [GameLogic getVal:[obj value]]) 
        {
            //there is a mismatch so play bad sound and unselect all objects
            if(CCRANDOM_MINUS1_1()>0)
                [sound playSound:ERROR_SOUND];
            else 
                [sound playSound:ERROR2_SOUND];
            
            [selectedObjects removeAllObjects];
            return;
            
        }
    }
    [selectedObjects addObject:obj];
}
-(void)objectReleased:(MatchObject*)obj
{
    if ([selectedObjects containsObject:obj] )
    {
        
        for(MatchObject* m in selectedObjects)
        {
            if ([m selected]) 
            {
                //there is still an object selected
                return;
                
            }
        }
        
        
        for(MatchObject* m in selectedObjects)
        {
            [m setAlive:NO];
        }
        [selectedObjects removeAllObjects];
        
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     //use this to deal with touches at the game scene level.. each MatchObject handles touches itself
     for( UITouch *touch in touches ) {
     CGPoint location = [touch locationInView: [touch view]];
     
     location = [[CCDirector sharedDirector] convertToGL: location];
     
     
     }
     */
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	//uncomment this if you want the accelerometer to effect the physics gravity
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
