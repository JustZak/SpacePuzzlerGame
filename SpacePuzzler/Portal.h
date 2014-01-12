//
//  Portal.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/11/13.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "Wall.h"

@interface Portal : NSObject

@property (strong) CCSprite* sprite;
@property (strong) CCSprite* sprite2;

-(b2Body*)getBody;
-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)pos withOrientation:(NSInteger)orientation with2ndPosition:(b2Vec2)pos2;


@end
