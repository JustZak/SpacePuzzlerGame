//
//  Wall.h
//  SpaceCollector
//
//  Created by Zachary Reik on 6/12/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"
#import "Box2D.h"


@interface Wall : GameObject

@property (strong) NSString* type;
@property (assign) BOOL isBouncy;
@property (assign) float height;
@property (assign) float width;

-(id)initWithType:(NSString*)wallType withObjectGroup:(CCTMXObjectGroup*)walls withWorld:(b2World*)world withWallNum:(NSInteger)wallNum;
-(b2Body*)getWallBody;

@end
