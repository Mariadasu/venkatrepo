#import "IntegerNode.h"
#import "GameScene.h"


#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

static bool seedInit = NO;
static int OUTMASK = 0xFF;
static int OPLEVEL = 5;
static int OPMASK = 0xFF;

//function for randomly selecting one factor of the integer x
static int getFactor(int x)
{
	NSMutableArray *factors = [[NSMutableArray alloc] init];
	int i = 0,count = 0;
	for (i = 1; i <= sqrt(x); i++)
	{
		if (x % i == 0)
		{
			[factors addObject:[NSNumber numberWithInt:i]];
			count++;
		}
	}
	if (count == 0) return 1;
	NSNumber* n = [factors objectAtIndex:(rand() % count)];
	return [n integerValue];
}

@implementation IntegerOperator
- (id) initNode:(IntegerNode*) node
{
	self = [super init];
	if(self){
		if(!seedInit){
			srand ( time(NULL) );
			seedInit=YES;
		}
		int v = [node getVal];
		int x = 0;
		int shift = rand() % OPLEVEL;
		int o = (1 << shift) & OPMASK;
		switch(o)
		{
			case 1:
				if ([[GameScene scene] addition]) 
				{
					opString = @"+";
					x = rand() % v;
					leftOperand = [[IntegerNode alloc] initNode:node startVal:x];
					rightOperand = [[IntegerNode alloc] initNode:node startVal:(v-x)];	
				}
				break;
			case 2:
				if ([[GameScene scene] subtraction]) 
				{
					opString = @"-";
					x = v + rand() % v;
					leftOperand = [[IntegerNode alloc] initNode:node startVal:x];
					rightOperand = [[IntegerNode alloc] initNode:node startVal:(x-v)];		
				}
				break;
			case 4:
				if ([[GameScene scene] multiplication]) 
				{
					opString = @"x";
					x = getFactor(v);
					leftOperand = [[IntegerNode alloc] initNode:node startVal:x];
					rightOperand = [[IntegerNode alloc] initNode:node startVal:(v/x)];	
				}
				break;
			case 8:
				opString = @"/";
				x = getFactor(v);
				leftOperand = [[IntegerNode alloc] initNode:node startVal:x*v];
				rightOperand = [[IntegerNode alloc] initNode:node startVal:x];		
				break;
			case 16:
				opString = @"%";
				x = rand() % 10;
				x = (v >= x)?(v+1):x;
				int y = v/x + rand() % 2;
				leftOperand = [[IntegerNode alloc] initNode:node startVal:y*x+v];
				rightOperand = [[IntegerNode alloc] initNode:node startVal:x];		
				break;
		}
		
		

	}
	return self;
}

- (NSString *) getResultString
{
	//pretty sure this leaks memory
	return [NSString stringWithFormat:@"%@ %@ %@",[leftOperand getTreeString],opString,[rightOperand getTreeString]];
	
}

@end

@implementation IntegerNode
- (id) initNode:(IntegerNode*) node  startVal:(int) value;
{
	self = [super init];
	if(self){
		self->val = value;
		op = NULL;
	}
	return self;
}
- (void) expand
{
	op = [[IntegerOperator alloc] initNode:self];
}

- (NSString*) getTreeString
{
	int level = (1 << (rand() % 3)) & OUTMASK; // to randomize output
	if(op != NULL)
		switch (level) {
			case(1):
					return [NSString stringWithFormat:@"%d = %@", val, [op getResultString]];
			case(2):
					return [NSString stringWithFormat:@"%d", val];
			case(4):
					return [NSString stringWithFormat:@"%@", [op getResultString]];
		}
					
	return [NSString stringWithFormat:@"%d", val];
	
}
- (NSString*) getNodeString
{
	return [NSString stringWithFormat:@"%d", val];
}
- (bool) checkEqual:(IntegerNode*) node
{
	return (node->val == val);
}

- (int) getVal
{
	return val;
}
@end