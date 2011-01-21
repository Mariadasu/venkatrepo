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

@implementation Bubble



+(id)bubbleWithPosition:(CGPoint)p value:(int)v
{
	return [[[Bubble alloc]	initWithPosition:p value:(int)v] autorelease];
}
-(int)val
{
	return [intNode getVal];	
}
-(void)destroy
{
	[intNode release];
	[[GameScene scene] addChild:[RingExplosion explosionAtPosition:mySprite.position]];
	[[GameScene scene] addChild:[BlockExplosion explosionAtPosition:mySprite.position]];

	//[[GameScene scene] addRippleAt:mySprite.position];
	mySprite=0;
	glowSprite=0;
	
	
	[[GameScene scene] world]->DestroyBody(b);
	[self removeFromParentAndCleanup:YES];
	
}
-(id)initWithPosition:(CGPoint)p value:(int)v
{
	if( (self=[super init])) {
		
	intNode = [[IntegerNode alloc] initNode:nil startVal:v];
	[intNode expand];
	label = [CCLabelTTF labelWithString:[[intNode getTreeString]copy] dimensions:CGSizeMake(128, 64)  alignment:CCTextAlignmentCenter fontName:@"Marker Felt" fontSize:32];
		label.color = ccc3(0,0,0);
		
		
		
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	//	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	/*	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	 //just randomly picking one of the images
	 int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	 int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	 */
	mySprite = [CCSprite spriteWithFile:@"Bubble.png"];
	glowSprite = [CCSprite spriteWithFile:@"BubbleGlow.png"];
		[glowSprite setVisible:NO];
	
	[self addChild:glowSprite];
	[self addChild:mySprite ];
	[self addChild:label];
		
	mySprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = mySprite;
	b = [[GameScene scene] world]->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2CircleShape dynamicCircle;
	dynamicCircle.m_radius = 64/PTM_RATIO;
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicCircle;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.6f;
	
	b->CreateFixture(&fixtureDef);
	
	[self schedule: @selector(update:)];
		
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
-(void) update: (ccTime) dt
{
		mySprite.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
		mySprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		label.position = mySprite.position;
	//	label.rotation = mySprite.rotation;
		glowSprite.position = mySprite.position;
		glowSprite.rotation = mySprite.rotation;
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
	
	
	
	if(ccpDistance(mySprite.position , p ) < 80 ) 
	{ 
		hit = YES;
		[self activate];
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

	[aCoder encodeFloat:mySprite.position.x  forKey:@"position_x"];
	[aCoder encodeFloat:mySprite.position.y  forKey:@"position_y"];
	
	
}



@end
