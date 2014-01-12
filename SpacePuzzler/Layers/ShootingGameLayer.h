//
//  ShootingGameLayer.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 10/21/13.
//
//

#import "cocos2d.h"
#import "Box2D.h"
#import "RootViewController.h"

#define PTM_RATIO 32.0

@interface ShootingGameLayer : CCLayer{
}

-(void)selectAmmo:(NSInteger)ammo;
-(id)initWithRootViewController:(RootViewController*)rootViewController;
-(void)startMove:(NSInteger)direction;
-(void)endMove;
+ (id)scene:(RootViewController*)rootViewController;

@end
