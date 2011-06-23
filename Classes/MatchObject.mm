//
//  Bubble.m
//  BubbleBlitz
//
//  Created by Robert Backman on 12/31/10.
//  Copyright 2010 Student: UC Merced. All rights reserved.
//

#import "MatchObject.h"
#import "GameScene.h"
#import "SoundLayer.h"
#import "Bubble.h"

@implementation MatchObject

@synthesize alive;
@synthesize value;
@synthesize selected;



-(int)getVal
{
	return [GameScene getVal:value];	
}

-(void)addForce:(CGPoint)f
{
    CCArray* children = [bubbles children];
    for (Bubble* b in children)
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
	
    
    [[GameScene scene] addBonusLabelAt:[self position] value:[GameScene getVal:value]];
    
    if(hit)
    {
        
        [[GameScene scene] addRippleAt:[self position] radius:256 value:[GameScene getVal:value]];
    }
    
    [intNode release];
	[bubbles removeAllChildrenWithCleanup:YES];
    //[bubbles release];
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
        hit = NO;
        // intNode = [[IntegerNode alloc] initNode:nil startVal:v];
        // [intNode expand];
        label = 0;
        value = v;
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
        
        bubbles = [CCNode node];
        [self addChild:bubbles z:0];
        
        glowSprite = [CCSprite spriteWithFile:@"BubbleGlow.png"];
        [glowSprite setVisible:NO];
        [glowSprite setOpacity:180];

        operators op;
        NSString *temp;
        
        int numBubbles = [GameScene getValExprOp:v expr:&temp op:&op];
        bubble_colors col = (numBubbles < 0)?RED_BUBBLE:BLUE_BUBBLE;
        numBubbles = (numBubbles < 0)?-numBubbles:numBubbles;
        
        int outMode = rand()%3; // Change this to control the types that get outputted
        
        [self addChild:glowSprite];
        if (![[GameScene scene] symbols])
            outMode = 0;
        
        if (outMode > 0)
        {
            if (outMode == 2)
                if (![[GameScene scene] addition] && op == ADDITION ||
                    ![[GameScene scene] subtraction] && op == SUBTRACTION ||
                    ![[GameScene scene] multiplication] && op == MULTIPlICATION ||
                    ![[GameScene scene] division] && op == DIVISION ||
                    ![[GameScene scene] remainder] && op == REMAINDER)
                        outMode = 1; // If the operator is not turned on then set the output to be just the Number
                    
                    
            numBubbles = 1;
        }
        
        if (op == FRACTION) { //Make sure to only print out in fractional format
            numBubbles = 1;
            outMode = 3;
        }
        
        NSString *str = [GameScene getExpr:v mode:outMode];
        int size = 2+outMode;
        

        
        printf("Starting Node %d with numBubbles %d and %s\n", v, numBubbles, [str UTF8String]);
       
        //for now the bubbles are just made at random locations around the MatchObject position
        float rad = CCRANDOM_0_1()*2;
        for (int i=0; i<numBubbles; i++) 
        {
            rad += (2*3.1415/numBubbles);
            CGPoint pos = ccpAdd(p,ccp(CCRANDOM_MINUS1_1()*5,CCRANDOM_MINUS1_1()*5));
            
            ; //ccpAdd(p,ccpRotateByAngle(ccp(CCRANDOM_MINUS1_1()*12,64 + CCRANDOM_0_1()*12), ccp(0,0), rad));
            
            [bubbles addChild:[Bubble bubbleWithPosition:pos
                                                   color:col   //color:(int)(CCRANDOM_0_1()*2.0f) /*make the bubble random color*/
                                                     val:str   // val:CCRANDOM_0_1()*2+1 /*for now all bubbles have val 1*/
                                                    size:size
                               ] z:1 ];
            
        }
        
        
        printf("Ending Node %d\n", v);
        
        [self schedule: @selector(update:)];
		
		[self setIsTouchEnabled:YES priority:1];
	}
	return self;
}
+(id)matchObjectWithPosition:(CGPoint)p value:(int)v
{
	return [[[MatchObject alloc]	initWithPosition:p value:(int)v] autorelease];
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
    CCArray* children = [bubbles children];
    for (Bubble* b in children) 
    {
        centroid = ccpAdd(centroid, [b position]);
    }
    centroid = ccpMult(centroid, 1.0f/[children count]);
    
}

-(void) update: (ccTime) dt
{
    
    CCArray* children = [bubbles children];
    for (Bubble* b1 in children)    
    {
        
        for (Bubble* b2 in children)
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
	
    CCArray* children = [bubbles children];
    for (Bubble* b in children)
    {
        if(ccpDistance([b position] , p ) < [b radius]*2 ) 
        { 
            
            [[ [GameScene scene ] sound] playSound: SQUEAK_SOUND + (int)(CCRANDOM_0_1()*2.99)]; //try one of the three squeak sounds
            hit = YES;
            touchStart = p;
            //alive = NO;
            selected = YES;
            
            [[GameScene scene] objectPressed:self];
        }
        
    }
	
    
	return hit;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
	
	
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView:[touch view]] ];
    
    /* for (Bubble* b in bubbles)
     {
     if(ccpDistance([b position] , p ) < [b radius]*2 ) 
     { */
    
    selected = NO;
    [[GameScene scene] objectReleased:self];
    //  }
    /*if([self isActive]) 
     { 
     CGPoint vecDir = ccpSub(p, touchStart);
     [self addForce:vecDir];
     }
     */
    
    //   }
    
	
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
