//
//  HelloWorldLayer.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "RootViewController.h"

#define PTM_RATIO 32.0

@interface GameLayer : CCLayer {
}

-(void)selectAmmo:(NSInteger)ammo;
-(id)initWithRootViewController:(RootViewController*)rootViewController level:(NSInteger)levelNum;
-(void)startMove:(NSInteger)direction;
-(void)endMove;
+ (id)scene:(RootViewController*)rootViewController level:(NSInteger)levelNum;

@end