#import <Foundation/Foundation.h>

@class IntegerNode;

@interface IntegerOperator: NSObject {
	IntegerNode *leftOperand,*rightOperand;
	NSString *opString;
}
- (id) initNode:(IntegerNode*) node;
- (NSString *) getResultString;

@end

@interface IntegerNode : NSObject {
	int depth;
	int val;
	IntegerNode * parent;
	IntegerOperator * op;
}

- (id) initNode:(IntegerNode*) node
	startVal:(int) val;
- (void) expand;
- (NSString*) getTreeString;
- (NSString*) getNodeString;
- (bool) checkEqual:(IntegerNode*) node;
- (int) getVal;
@end