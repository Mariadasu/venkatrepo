//
//  Bubble.m
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "Bubble.h"
#import "GameScene.h"
#import "explosion.h"
#import "PhysicsBody.h"

@implementation Bubble

@synthesize alive;
-(void)dealloc
{
    	
    [super dealloc];
    
}
+(id)bubbleWithPosition:(CGPoint)p value:(int)v
{
	return [[[Bubble alloc]	initWithPosition:p value:(int)v] autorelease];
}

-(int)val
{
	return [intNode getVal];	
}

-(void)addForce:(CGPoint)f
{
    for (PhysicsBody* b in bodies)
    {
        [b addForce:f];
      
    }    
}
-(void)destroy
{
	
    for (PhysicsBody* b in bodies) 
    {
        [[GameScene scene] addChild:[RingExplosion explosionAtPosition:[b getPosition]]];
        [[GameScene scene] addChild:[BlockExplosion explosionAtPosition:[b getPosition]]];
       
    }
	
    [intNode release];
	[bodies removeAllObjects];
    [bodies release];
    bodies = 0;
    intNode = 0;

	//[[GameScene scene] addRippleAt:mySprite.position];
	
    glowSprite=0;
    
    [self removeFromParentAndCleanup:YES];
   
	
}
-(id)initWithPosition:(CGPoint)p value:(int)v
{
	if( (self=[super init]))
    {
		
        alive = YES;
	intNode = [[IntegerNode alloc] initNode:nil startVal:v];
	[intNode expand];
        label = 0;
      
        /*
         label = [CCLabelTTF labelWithString:[[intNode getTreeString]copy] dimensions:CGSizeMake(128, 64)  alignment:CCTextAlignmentCenter fontName:@"Marker Felt" fontSize:32];
		label.color = ccc3(0,0,0);
		 [self addChild:label];
		*/
        
		
	//CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	//	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	/*	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	 //just randomly picking one of the images
	 int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	 int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	 */
	
    bodies = [[NSMutableArray alloc] init];
        
    glowSprite = [CCSprite spriteWithFile:@"BubbleGlow.png"];
	[glowSprite setVisible:NO];
    [glowSprite setOpacity:180];
        
	[self addChild:glowSprite];
	
        for (int i=0; i<v; i++) 
        {
            [bodies addObject:[PhysicsBody bodyWithPosition:CGPointMake(p.x+CCRANDOM_MINUS1_1()*32 , p.y+CCRANDOM_MINUS1_1()*32)]];
        }
        
        
        for(PhysicsBody* body in bodies)
            [self addChild:[body sprite] ];
	
       
	
	
        //[self schedule: @selector(update:)];
		
		[self setIsTouchEnabled:YES priority:1];
	}
	return self;
}
-(BOOL)active
{
	return glowScale > 0.1f;
}
-(void)activate
{
	glowScale = 1;
	[glowSprite setScale:glowScale];
	[glowSprite setVisible:YES];

}
-(CGPoint)getPosition
{
    return centroid;
}
-(void) setIsTouchEnabled:(BOOL)enabled priority:(int)pr
		{
			if( isTouchEnabled_ != enabled ) 
			{
				isTouchEnabled_ = enabled;
				
				if( enabled )
					[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:pr swallowsTouches:NO];
				else
					[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
			}
		}
-(void)calculateCentroid
{
    
    centroid = CGPointMake(0, 0);
    for (PhysicsBody* b in bodies) 
    {
        centroid = ccpAdd(centroid, [b getPosition]);
    }
    centroid = ccpMult(centroid, 1.0f/[bodies count]);
    
}

-(void) update: (ccTime) dt
{

    for(PhysicsBody* b1 in bodies)
    {
       
        for(PhysicsBody* b2 in bodies)
        {
        
            if(b1!=b2)
            {
                
                CGPoint len = ccpSub([b2 getPosition], [b1 getPosition] );
                float length = ccpLength(len);
                
                if(length>16)
                {
                    CGPoint force = ccpNormalize(len);
                    
                    force = ccpMult(force, 20000.0f/(length*length));
                    
                    // printf("the force is %g\n",ccpLength(force));
                    [b1 addForce:force ];
                   [b2 addForce:ccpMult(force, -1.0f)];
                }
                
            }
        }
        
    }

    
   for(PhysicsBody* body in bodies)
   {
       [body update];
   }
    
    [self calculateCentroid];
    
        label.position = centroid;
	//	label.rotation = mySprite.rotation;
		glowSprite.position = centroid;
	//	glowSprite.rotation = centroid;
		if ([self active]) 
		{
			glowScale *= 0.9f;
			[glowSprite setScale:glowScale];
			if (![self active]) 
			{
				[glowSprite setVisible:NO];
			}
		}
	
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
	bool hit = NO;
	
	
	for (PhysicsBody* b in bodies) 
    {
        if(ccpDistance([b getPosition] , p ) < 80 ) 
        { 
            hit = YES;
            [self activate];
        }

    }
	
	return hit;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}



- (id)initWithCoder:(NSCoder *)aDecoder 
{
	CGPoint p = ccp([aDecoder decodeFloatForKey:@"position_x"],[aDecoder decodeFloatForKey:@"position_y"]);
	
	[self initWithPosition:p value:5];
	
	return self;
}





- (void)encodeWithCoder:(NSCoder *)aCoder 
{

	
    [aCoder encodeFloat:centroid.x  forKey:@"position_x"];
	[aCoder encodeFloat:centroid.y  forKey:@"position_y"];
	
	
}



@end
