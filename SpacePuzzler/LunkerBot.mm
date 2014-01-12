//
//  LunkerBot.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/16/13.
//
//

#import "LunkerBot.h"
#import "GameLayer.h"
#import "BotPart.h"

@interface LunkerBot(){
    
    BotPart* _head;
    BotPart* _leftShoulder;
    BotPart* _leftWrist;
    BotPart* _leftHand;
    BotPart* _leftLeg;
    BotPart* _rightShoulder;
    BotPart* _rightWrist;
    BotPart* _rightHand;
    BotPart* _rightLeg;
}
@end


@implementation LunkerBot

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position{
    if (self = [super init]){
        CCSprite* headS = [CCSprite spriteWithFile:@"lunkerBotHead.png"];
        CCSprite* leftShoulderS = [CCSprite spriteWithFile:@"lunkerBotLeftShoulder.png"];
        CCSprite* leftWristS = [CCSprite spriteWithFile:@"lunkerBotLeftWrist.png"];
        CCSprite* leftHandS = [CCSprite spriteWithFile:@"lunkerBotLeftHand.png"];
        CCSprite* leftLegS = [CCSprite spriteWithFile:@"lunkerBotLeftLeg.png"];
        CCSprite* rightShoulderS = [CCSprite spriteWithFile:@"lunkerBotRightShoulder.png"];
        CCSprite* rightWristS = [CCSprite spriteWithFile:@"lunkerBotRightWrist.png"];
        CCSprite* rightHandS = [CCSprite spriteWithFile:@"lunkerBotRightHand.png"];
        CCSprite* rightLegS = [CCSprite spriteWithFile:@"lunkerBotRightLeg.png"];
        
        // ******* Reusable defs for ragdoll robot *******
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        b2FixtureDef fixDef;
        b2PolygonShape poly;
        
        int gravityScale = 1;
        
        // ******* Head ********
        
        bodyDef.position.Set(position.x, position.y);
        b2Body *head = world->CreateBody(&bodyDef);
        head->SetGravityScale(gravityScale);
        
        float headX = head->GetPosition().x;
        float headY = head->GetPosition().y;
        
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-9.2f / PTM_RATIO, 24.7f / PTM_RATIO),
            b2Vec2(-25.9f / PTM_RATIO, -4.2f / PTM_RATIO),
            b2Vec2(-26.0f / PTM_RATIO, -8.2f / PTM_RATIO),
            b2Vec2(-9.9f / PTM_RATIO, -24.2f / PTM_RATIO),
            b2Vec2(10.0f / PTM_RATIO, -24.2f / PTM_RATIO),
            b2Vec2(26.1f / PTM_RATIO, -8.5f / PTM_RATIO),
            b2Vec2(25.9f / PTM_RATIO, -4.4f / PTM_RATIO),
            b2Vec2(9.1f / PTM_RATIO, 24.6f / PTM_RATIO)
        };
        poly.Set(verts, num);
        
        fixDef.shape = &poly;
        fixDef.density = 1.0f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.filter.categoryBits = ENEMY;
        fixDef.filter.maskBits = ENEMY | PROJECTILE | BOUNDARY;
        fixDef.userData = (void*)TAGS_ENEMY;
        head->CreateFixture(&fixDef);
        
        _head = [[BotPart alloc] initWithBody:head withSprite:headS withBot:self];
        head->SetUserData((__bridge void*)_head);
        
        // ****************** Left Side ******************
        
        // ******* Left Shoulder *******
        
        bodyDef.position.Set(headX - 32.2/PTM_RATIO, headY + 10.3/PTM_RATIO);
        b2Body *leftShoulder = world->CreateBody(&bodyDef);
        leftShoulder->SetGravityScale(gravityScale);
        
        int num2 = 8;
        b2Vec2 verts2[] = {
            b2Vec2(-4.9f / PTM_RATIO, 10.0f / PTM_RATIO),
            b2Vec2(-10.9f / PTM_RATIO, -0.9f / PTM_RATIO),
            b2Vec2(-11.0f / PTM_RATIO, -9.3f / PTM_RATIO),
            b2Vec2(10.0f / PTM_RATIO, -8.7f / PTM_RATIO),
            b2Vec2(11.7f / PTM_RATIO, -1.9f / PTM_RATIO),
            b2Vec2(10.9f / PTM_RATIO, 6.5f / PTM_RATIO),
            b2Vec2(4.9f / PTM_RATIO, 6.6f / PTM_RATIO),
            b2Vec2(4.9f / PTM_RATIO, 9.5f / PTM_RATIO)
        };
        poly.Set(verts2, num2);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftShoulder->CreateFixture(&fixDef);
        
        _leftShoulder = [[BotPart alloc] initWithBody:leftShoulder withSprite:leftShoulderS withBot:self];
        leftShoulder->SetUserData((__bridge void*)_leftShoulder);
        
        // ******* Left Wrist *******
        
        bodyDef.position.Set(headX - 41/PTM_RATIO, headY - 5.8/PTM_RATIO);
        b2Body *leftWrist = world->CreateBody(&bodyDef);
        leftWrist->SetGravityScale(gravityScale);
        
        poly.SetAsBox(leftWristS.contentSize.width/2/PTM_RATIO, leftWristS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftWrist->CreateFixture(&fixDef);
        
        _leftWrist = [[BotPart alloc] initWithBody:leftWrist withSprite:leftWristS withBot:self];
        leftWrist->SetUserData((__bridge void*)_leftWrist);
        
        // ******* Left Hand *******
        
        bodyDef.position.Set(headX - 41.3/PTM_RATIO, headY - 27/PTM_RATIO);
        b2Body *leftHand = world->CreateBody(&bodyDef);
        leftHand->SetGravityScale(gravityScale);
        
        int num3 = 9;
        b2Vec2 verts3[] = {
            b2Vec2(-5.4f / PTM_RATIO, 15.7f / PTM_RATIO),
            b2Vec2(-11.5f / PTM_RATIO, 2.9f / PTM_RATIO),
            b2Vec2(-11.4f / PTM_RATIO, -8.8f / PTM_RATIO),
            b2Vec2(-7.1f / PTM_RATIO, -13.7f / PTM_RATIO),
            b2Vec2(6.4f / PTM_RATIO, -14.9f / PTM_RATIO),
            b2Vec2(10.9f / PTM_RATIO, -9.7f / PTM_RATIO),
            b2Vec2(10.8f / PTM_RATIO, 0.8f / PTM_RATIO),
            b2Vec2(4.6f / PTM_RATIO, 6.1f / PTM_RATIO),
            b2Vec2(4.4f / PTM_RATIO, 15.7f / PTM_RATIO)
        };

        poly.Set(verts3, num3);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftHand->CreateFixture(&fixDef);
        
        _leftHand = [[BotPart alloc] initWithBody:leftHand withSprite:leftHandS withBot:self];
        leftHand->SetUserData((__bridge void*)_leftHand);
        
        // ******** Left Leg ********
        
        bodyDef.position.Set(headX - 20.5/PTM_RATIO, headY - 40.4/PTM_RATIO);
        b2Body *leftLeg = world->CreateBody(&bodyDef);
        leftLeg->SetGravityScale(gravityScale);
        
        int num4 = 8;
        b2Vec2 verts4[] = {
            b2Vec2(-5.2f / PTM_RATIO, 26.7f / PTM_RATIO),
            b2Vec2(-9.9f / PTM_RATIO, -15.0f / PTM_RATIO),
            b2Vec2(-10.0f / PTM_RATIO, -26.2f / PTM_RATIO),
            b2Vec2(6.6f / PTM_RATIO, -25.9f / PTM_RATIO),
            b2Vec2(9.9f / PTM_RATIO, 13.6f / PTM_RATIO),
            b2Vec2(9.4f / PTM_RATIO, 17.9f / PTM_RATIO),
            b2Vec2(-2.7f / PTM_RATIO, 24.7f / PTM_RATIO),
            b2Vec2(-3.0f / PTM_RATIO, 26.9f / PTM_RATIO)
        };
        
        poly.Set(verts4, num4);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.1f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftLeg->CreateFixture(&fixDef);
        
        _leftLeg = [[BotPart alloc] initWithBody:leftLeg withSprite:leftLegS withBot:self];
        leftLeg->SetUserData((__bridge void*)_leftLeg);
        
        // ****************** Right Side ******************
        
        // ******* Right Shoulder *******
        
        bodyDef.position.Set(headX + 32.2/PTM_RATIO, headY + 10.3/PTM_RATIO);
        b2Body *rightShoulder = world->CreateBody(&bodyDef);
        rightShoulder->SetGravityScale(gravityScale);
        
        int num5 = 8;
        b2Vec2 verts5[] = {
            b2Vec2(-4.8f / PTM_RATIO, 10.1f / PTM_RATIO),
            b2Vec2(-4.9f / PTM_RATIO, 6.5f / PTM_RATIO),
            b2Vec2(-10.8f / PTM_RATIO, 6.2f / PTM_RATIO),
            b2Vec2(-11.0f / PTM_RATIO, -2.7f / PTM_RATIO),
            b2Vec2(-7.8f / PTM_RATIO, -9.2f / PTM_RATIO),
            b2Vec2(11.3f / PTM_RATIO, -9.1f / PTM_RATIO),
            b2Vec2(11.1f / PTM_RATIO, -1.3f / PTM_RATIO),
            b2Vec2(5.0f / PTM_RATIO, 10.1f / PTM_RATIO)
        };
        
        poly.Set(verts5, num5);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightShoulder->CreateFixture(&fixDef);
        
        _rightShoulder = [[BotPart alloc] initWithBody:rightShoulder withSprite:rightShoulderS withBot:self];
        rightShoulder->SetUserData((__bridge void*)_rightShoulder);
        
        // ******* Right Wrist *******
        
        bodyDef.position.Set(headX + 41/PTM_RATIO, headY - 5.8/PTM_RATIO);
        b2Body *rightWrist = world->CreateBody(&bodyDef);
        rightWrist->SetGravityScale(gravityScale);
        
        poly.SetAsBox(rightWristS.contentSize.width/2/PTM_RATIO, rightWristS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightWrist->CreateFixture(&fixDef);
        
        _rightWrist = [[BotPart alloc] initWithBody:rightWrist withSprite:rightWristS withBot:self];
        rightWrist->SetUserData((__bridge void*)_rightWrist);
        
        // ******** Right Hand ********
        
        bodyDef.position.Set(headX + 41.3/PTM_RATIO, headY - 27/PTM_RATIO);
        b2Body *rightHand = world->CreateBody(&bodyDef);
        rightHand->SetGravityScale(gravityScale);
        
        int num6= 9;
        b2Vec2 verts6[] = {
            b2Vec2(-4.3f / PTM_RATIO, 15.7f / PTM_RATIO),
            b2Vec2(-4.4f / PTM_RATIO, 6.1f / PTM_RATIO),
            b2Vec2(-11.4f / PTM_RATIO, -1.8f / PTM_RATIO),
            b2Vec2(-11.4f / PTM_RATIO, -9.7f / PTM_RATIO),
            b2Vec2(-6.6f / PTM_RATIO, -14.7f / PTM_RATIO),
            b2Vec2(2.4f / PTM_RATIO, -14.6f / PTM_RATIO),
            b2Vec2(11.6f / PTM_RATIO, -8.9f / PTM_RATIO),
            b2Vec2(11.3f / PTM_RATIO, 3.4f / PTM_RATIO),
            b2Vec2(5.3f / PTM_RATIO, 15.6f / PTM_RATIO)
        };
        
        poly.Set(verts6, num6);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightHand->CreateFixture(&fixDef);
        
        _rightHand = [[BotPart alloc] initWithBody:rightHand withSprite:rightHandS withBot:self];
        rightHand->SetUserData((__bridge void*)_rightHand);
        
        // ******** Right Leg ********
        
        bodyDef.position.Set(headX + 20.5/PTM_RATIO, headY - 40.4/PTM_RATIO);
        b2Body *rightLeg = world->CreateBody(&bodyDef);
        rightLeg->SetGravityScale(gravityScale);
        
        int num7 = 7;
        b2Vec2 verts7[] = {
            b2Vec2(2.0f / PTM_RATIO, 27.0f / PTM_RATIO),
            b2Vec2(-9.9f / PTM_RATIO, 18.0f / PTM_RATIO),
            b2Vec2(-6.9f / PTM_RATIO, -25.9f / PTM_RATIO),
            b2Vec2(10.0f / PTM_RATIO, -25.6f / PTM_RATIO),
            b2Vec2(10.3f / PTM_RATIO, -13.3f / PTM_RATIO),
            b2Vec2(6.0f / PTM_RATIO, 18.6f / PTM_RATIO),
            b2Vec2(5.9f / PTM_RATIO, 27.1f / PTM_RATIO)
        };

        poly.Set(verts7, num7);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.1f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightLeg->CreateFixture(&fixDef);
        
        _rightLeg = [[BotPart alloc] initWithBody:rightLeg withSprite:rightLegS withBot:self];
        rightLeg->SetUserData((__bridge void*)_rightLeg);
        
        // *******************
        // Joints
        // *******************
        
        b2RevoluteJointDef jointDef;
        jointDef.enableLimit = true;
        b2Vec2 pos;
        b2Joint* joint;
        NSValue* val;
        
        // ******************** Left Side *********************
        
        // Head to Left Shoulder
        
        jointDef.bodyA = head;
        jointDef.bodyB = leftShoulder;
        jointDef.localAnchorA = b2Vec2(-21.6f / PTM_RATIO, 6.6f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(11.4f / PTM_RATIO, -3.4f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_head.joints addObject:val];
        
        // Left Shoulder to Left Wrist
        
        jointDef.bodyA = leftShoulder;
        jointDef.bodyB = leftWrist;
        jointDef.localAnchorA = b2Vec2(-9.0f / PTM_RATIO, -9.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(0.4f / PTM_RATIO, 6.4f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_leftWrist.joints addObject:val];
        
        // Left Wrist to Left Hand
        
        jointDef.bodyA = leftWrist;
        jointDef.bodyB = leftHand;
        jointDef.localAnchorA = b2Vec2(-0.6f / PTM_RATIO, -5.5f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-0.5f / PTM_RATIO, 15.8f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftHand.joints addObject:val];
        [_leftWrist.joints addObject:val];
        
        // Head to Left Leg
        
        jointDef.bodyA = head;
        jointDef.bodyB = leftLeg;
        jointDef.localAnchorA = b2Vec2(-16.4f / PTM_RATIO, -19.5f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(3.5f / PTM_RATIO, 23.2f / PTM_RATIO);
        jointDef.lowerAngle = -1.0f / (180.0f / M_PI);
        jointDef.upperAngle = 1.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftLeg.joints addObject:val];
        [_head.joints addObject:val];
        
        // ******************** Right Side *********************
        
        // Head to Right Shoulder
        
        jointDef.bodyA = head;
        jointDef.bodyB = rightShoulder;
        jointDef.localAnchorA = b2Vec2(22.5f / PTM_RATIO, 7.6f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-10.6f / PTM_RATIO, -3.0f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_head.joints addObject:val];
        
        // Right Shoulder to Right Wrist
        
        jointDef.bodyA = rightShoulder;
        jointDef.bodyB = rightWrist;
        jointDef.localAnchorA = b2Vec2(8.9f / PTM_RATIO, -9.5f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-0.6f / PTM_RATIO, 6.4f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_rightWrist.joints addObject:val];
        
        // Right Wrist to Right Hand
        
        jointDef.bodyA = rightWrist;
        jointDef.bodyB = rightHand;
        jointDef.localAnchorA = b2Vec2(0.5f / PTM_RATIO, -5.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(0.6f / PTM_RATIO, 16.0f / PTM_RATIO);
        jointDef.lowerAngle = -2.0f / (180.0f / M_PI);
        jointDef.upperAngle = 2.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightWrist.joints addObject:val];
        [_rightHand.joints addObject:val];
        
        // Head to Right Leg
        
        jointDef.bodyA = head;
        jointDef.bodyB = rightLeg;
        jointDef.localAnchorA = b2Vec2(16.5f / PTM_RATIO, -19.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-3.8f / PTM_RATIO, 23.9f / PTM_RATIO);
        jointDef.lowerAngle = -1.0f / (180.0f / M_PI);
        jointDef.upperAngle = 1.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightLeg.joints addObject:val];
        [_head.joints addObject:val];
    }
    
    return self;
}

-(NSMutableArray*)getBotParts{
    NSMutableArray* botParts = [NSMutableArray array];
    [botParts addObject:_head];
    [botParts addObject:_leftShoulder];
    [botParts addObject:_leftWrist];
    [botParts addObject:_leftHand];
    [botParts addObject:_leftLeg];
    [botParts addObject:_rightShoulder];
    [botParts addObject:_rightWrist];
    [botParts addObject:_rightHand];
    [botParts addObject:_rightLeg];
    
    return botParts;
}


@end
