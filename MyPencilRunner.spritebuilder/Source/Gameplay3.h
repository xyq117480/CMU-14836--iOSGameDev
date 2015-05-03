//
//  Gameplay1.h
//  MyPencilRunner
//
//  Created by Aihua Peng on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Runner.h"
@interface Gameplay3 : CCNode <CCPhysicsCollisionDelegate>

//enumerations
typedef enum _ActionState
{
    kActionStateNone = 0,
    kActionStateIdle = 1 ,
    kActionStateWalkLeft = 2,
    kActionStateWalk = 3,
    kActionStateJump = 4,
    kActionStateOut = 5
} ActionState;


//actionState
@property(nonatomic,assign)ActionState actionState;
@property(nonatomic,assign)BOOL actionGoing;
@property(nonatomic,assign)BOOL actionIsMovingLeft;

//velocity
@property(nonatomic,assign)CGPoint velocity;

@end
