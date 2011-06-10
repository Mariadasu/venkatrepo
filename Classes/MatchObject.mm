//
//  Bubble.m
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "MatchObject.h"
#import "GameScene.h"

#import "Bubble.h"

@implementation MatchObject

@synthesize alive;

+(id)matchObjectWithPosition:(CGPoint)p value:(int)v
{
	return [[[MatchObject alloc]	initWithPosition:p value:(int)v] autorelease];
}

-(int)val
{
	return [intNode getVal];	
}

-(void)addForce:(CGPoint)f
{
    for (Bubble* b in bubbles)
    {
        [b addForce:f];
      
    }    
}
-(void)dealloc
{

    [super dealloc];
}
-(void)destroy
{
	
    [intNode release];
	[bubbles removeAllObjects];
    [bubbles release];
    bubbles = 0;
    intNode = 0;
    
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
	
    bubbles = [[NSMutableArray alloc] init];
        
    glowSprite = [CCSprite spriteWithFile:@"BubbleGlow.png"];
	[glowSprite setVisible:NO];
    [glowSprite setOpacity:180];
        
	[self addChild:glowSprite];
	
        //for now the bubbles are just made at random locations around the MatchObject position and the are all blue
        for (int i=0; i<v; i++) 
        {
                [bubbles addObject:[Bubble bubbleWithPosition:CGPointMake(p.x+CCRANDOM_MINUS1_1()*64 , p.y+CCRANDOM_MINUS1_1()*64) 
                                                    color:(int)(CCRANDOM_0_1()*2.0f) /*make the bubble random color*/
                                                      val:CCRANDOM_0_1()*2+1 /*for now all bubbles have val 1*/
                                ]];          
        }
        
        
        for (Bubble* b in bubbles)
            [self addChild:[b sprite] ];
	
       
	
	
        //[self schedule: @selector(update:)];
		
		[self setIsTouchEnabled:YES priority:1];
	}
	return self;
}

-(bool)isActive
{
	return glowScale > 0.1f;
}
-(void)activate
{
	glowScale = 1;
	[glowSprite setScale:glowScale];
	[glowSprite setVisible:YES];

}
-(CGPoint)position
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
    for (Bubble* b in bubbles) 
    {
        centroid = ccpAdd(centroid, [b position]);
    }
    centroid = ccpMult(centroid, 1.0f/[bubbles count]);
    
}

-(void) update: (ccTime) dt
{

    for (Bubble* b1 in bubbles)    {
       
         for (Bubble* b2 in bubbles)
        {
        
            if(b1!=b2)
            {
                
                CGPoint len = ccpSub([b2 position], [b1 position] );
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

    
     for (Bubble* b in bubbles)
   {
       [b update];
   }
    
    [self calculateCentroid];
    
        label.position = centroid;
	//	label.rotation = mySprite.rotation;
		glowSprite.position = centroid;
	//	glowSprite.rotation = centroid;
		if ([self isActive]) 
		{
			glowScale *= 0.9f;
			[glowSprite setScale:glowScale];
			if (![self isActive]) 
			{
				[glowSprite setVisible:NO];
			}
		}
	
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
	bool hit = NO;
	

    for (Bubble* b in bubbles)
    {
        if(ccpDistance([b position] , p ) < [b radius] ) 
        { 
            hit = YES;
            touchStart = p;
            alive = NO;
           
        }

    }
	if(hit)
         [[GameScene scene] addRippleAt:centroid radius:[intNode getVal]*64 value:[intNode getVal]];
    
	return hit;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
	
	
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
    
    for (Bubble* b in bubbles)
    {
        if([self isActive]) 
        { 
            CGPoint vecDir = ccpSub(p, touchStart);
            [self addForce:vecDir];
        }
        
    }
    
	
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
