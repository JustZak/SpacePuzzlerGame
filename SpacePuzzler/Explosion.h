//
//  Explosion.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 7/20/13.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

@interface Explosion : NSObject

@property (assign) NSInteger length;
@property (strong) NSMutableArray* explosionBodies;

-(id)initWithWorld:(b2World*)world withCenter:(b2Vec2)center explosionType:(NSString*)type;

@end
