//
//  HudLayer.m
//  SpaceCollector
//
//  Created by Zachary Reik on 6/8/13.
//
//

#import "HUDLayer.h"
#import "GameLayer.h"
#import "Player.h"

@interface HUDLayer(){
    CCSprite* _left;
    CCSprite* _right;
    
}

@end

@implementation HUDLayer

-(id) init
{
	if( (self=[super init])) {
        self.isTouchEnabled = NO;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
        _left = [CCSprite spriteWithFile:@"arrowLeft.png"];
        _right = [CCSprite spriteWithFile:@"arrowRight.png"];
        _right.position = ccp(winSize.width - winSize.width/10 , winSize.height/16);
        _left.position = ccp(_right.position.x - (_right.contentSize.width*1.5) , _right.position.y);
        [self addChild:_left];
        [self addChild:_right];
        
        CCMenuItem *weaponButton = [CCMenuItemImage itemFromNormalImage:@"blue9.png" selectedImage:@"blue9.png" target:self selector:@selector(weaponButtonTapped:)];
        weaponButton.position = ccp(winSize.width/10, winSize.height/16);
        CCMenu *weaponMenu = [CCMenu menuWithItems:weaponButton, nil];
        weaponMenu.position = CGPointZero;
        [self addChild:weaponMenu];
    }
    
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(_left.boundingBox, location)){
        self.moveBeginning = YES;
        self.movePressed = YES;
        self.moveDirection = 0;
        self.moveDone = NO;
    } else if (CGRectContainsPoint(_right.boundingBox, location)){
        self.moveBeginning = YES;
        self.movePressed = YES;
        self.moveDirection = 1;
        self.moveDone = NO;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.moveBeginning = NO;
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    self.moveDone = YES;
    self.movePressed = NO;
}

- (void)weaponButtonTapped:(id)sender {
}


@end
