//
//  Robot.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/30/13.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameEnemy.h"

@interface YellowBot : GameEnemy

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position;

@end
