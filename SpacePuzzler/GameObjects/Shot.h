//
//  Shot.h
//  SpaceCollector
//
//  Created by Zachary Reik on 6/10/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "Player.h"



@class Player;

@interface Shot : GameObject

@property (assign) NSInteger shotType;
@property (assign) NSInteger damage;
@property (assign) NSInteger numBounces;
@property (assign) CGPoint angle;
@property (assign) BOOL doesBounce;
@property (assign) BOOL colliding;
@property (assign) BOOL shouldDelete;

-(id)initWithType:(NSInteger)type withWorld:(b2World*)world withPlayer:(Player*)player;
-(b2Body*)getBody;


@end
