//
//  GameObject.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/22/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface GameObject : NSObject

@property (strong) CCSprite* sprite;

-(void) removeObject;

@end
