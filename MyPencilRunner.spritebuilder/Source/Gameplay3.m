//
//  Gameplay1.m
//  MyPencilRunner
//
//  Created by Aihua Peng on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#define WeakSelf(__var__) __unsafe_unretained typeof(*self) *__var__ = self
#define WeakNode(__var__,__node__) __unsafe_unretained typeof(*__node__) *__var__ = __node__


#import "Gameplay3.h"
#import "Runner.h"


@implementation Gameplay3{
    CCPhysicsNode *_physicsNode;
    
    CCNode *_contentNode;
    CCNode *_leftbound;
    CCNode *_rightbound;
    CCNode *_topbound;
    CCNode *_spike1;
    CCButton *_restart;
    CCButton *_jump;
    CCButton *_move;
    CCButton *_moveLeft;
    Runner *_runner;
    CCNode *_spikeInAir1;
    CCNode *_spikeInAir3;
    CCNode *_coin1;
    CCNode *_coin2;
    CCNode *_cherry1;
    CCNode *_cherry2;
    CCNode *_cherry3;
    CCNode *_cherry4;
    CCNode *_door;
    CCNode *_underDoor;
    CCNode *_underDoor2;
    CCNode *_hiddenWall;
    CCNode *_hiddenWall2;
    CCNode *_hiddenWall3;
    CCNode *_stick1;
    CCNode *_stick2;
    CCNode *_stick3;
    CCNode *_stick4;
    CCNode *_stick5;
    CCNode *_stick6;
    CCNode *_stick7;
    
    CCLabelTTF *_textBox;
    CCLabelTTF *_cherryTextBox;
    CCLabelTTF *_timerBox;
    
    CCNode *_pole_short;
    CCNode *_pole_long;
    CCNode *_pole_long_short;
    CCNode *_pole_long_short1;
    CCNode *_pole_long_short2;
    CCNode *_pole_long_short3;
    CCNode *_pole_left_short;
    CCNode *_pole_left_short3;
    CCNode *_cherry_small;
    CCNode *_stick_small;
    CCNode *_ground;
    
    
    bool isWin;
    BOOL isRunning;
    BOOL isJumpping;
    BOOL _isCherry3Triggered;
    BOOL _isCoinTriggered;
    BOOL _isStickCollected;
    BOOL _isSpikeStuck;
    BOOL _isCherryCollected;
    BOOL _isCherryTapped;
    BOOL _isStickTapped;
    BOOL _isStickPlaced;
    BOOL _isPoleHitted;
    BOOL _isPoleEnded;
    
    BOOL _isTurnRight;
    BOOL _isTurnRight2;
    BOOL _isTurnRight3;
    BOOL _isTurnRight4;
    BOOL _isTurnRight5;
    
    CCAnimationManager *animationManager;
    
    NSArray *_tipsArray;
    
    int countOfTime;
}


-(void)didLoadFromCCB{
    _physicsNode.debugDraw = FALSE;
    isWin = FALSE;
    _actionGoing = FALSE;
    _actionIsMovingLeft = FALSE;
    _actionState = kActionStateNone;
    isJumpping = FALSE;
    isRunning = FALSE;
    _isCherry3Triggered = FALSE;
    _isCoinTriggered = FALSE;
    _isCherryCollected = FALSE;
    _isStickCollected = FALSE;
    _isStickPlaced = FALSE;
    
    _restart.visible = FALSE;
    _spikeInAir1.visible=TRUE;
    
    _spikeInAir3.visible=TRUE;
    
    _cherry1.visible = FALSE;
    _cherry2.visible = FALSE;
    _cherry3.visible = FALSE;
    _cherry4.visible = FALSE;
    _door.visible = FALSE;
    _pole_short.visible = FALSE;
    
    _pole_long_short1.visible = FALSE;
    _pole_long_short2.visible = FALSE;
    _isCherryTapped = FALSE;
    _isStickTapped  = FALSE;
    //_underDoor.visible = FALSE;
    
    
    _isTurnRight = TRUE;
    _isTurnRight2 = TRUE;
    _isTurnRight3 = TRUE;
    _isTurnRight4 = TRUE;
    _isTurnRight5 = TRUE;
    
    _cherry1.physicsBody.sensor = TRUE;
    _cherry2.physicsBody.sensor = TRUE;
    _cherry3.physicsBody.sensor = TRUE;
    _cherry4.physicsBody.sensor = TRUE;
    _coin2.physicsBody.sensor = TRUE;
    _door.physicsBody.sensor = TRUE;
    _hiddenWall.physicsBody.sensor = TRUE;
    _hiddenWall2.physicsBody.sensor = TRUE;
    _hiddenWall3.physicsBody.sensor = TRUE;
    _pole_short.physicsBody.sensor = TRUE;
    _physicsNode.collisionDelegate = self;
    
    
    self.userInteractionEnabled = TRUE;
    
    _runner = (Runner *)[CCBReader load:@"RunnerNode"];
    
    
    
    _runner.position = CGPointMake(40.0f, 190.0f);
    _runner.physicsBody.collisionType=@"runner";
    _runner.physicsBody.allowsRotation = FALSE;
    
    
    
    [_physicsNode addChild:_runner];
    
    animationManager = _runner.animationManager;
    
    [animationManager runAnimationsForSequenceNamed:@"idle"];
    
    
    _spike1.physicsBody.collisionType=@"bound";
    _leftbound.physicsBody.collisionType=@"bound";
    _rightbound.physicsBody.collisionType=@"bound";
    _topbound.physicsBody.collisionType=@"bound";
    _pole_left_short.physicsBody.collisionType = @"bound1";
    _pole_left_short3.physicsBody.collisionType = @"bound1";
    
    _pole_long_short.physicsBody.collisionType=@"bound1";
    _pole_long_short3.physicsBody.collisionType=@"bound1";
    _ground.physicsBody.collisionType = @"ground";
    
    
    _spikeInAir1.physicsBody.collisionType=@"spike";
    _spikeInAir3.physicsBody.collisionType=@"spike";
    _coin2.physicsBody.collisionType=@"cherryFall";
    _hiddenWall.physicsBody.collisionType=@"hiddenWallTrigger";
    _hiddenWall2.physicsBody.collisionType=@"hiddenWallTrigger2";
    _hiddenWall3.physicsBody.collisionType=@"hiddenWallTrigger3";
    _cherry1.physicsBody.collisionType=@"bound";
    _cherry2.physicsBody.collisionType=@"bound";
    _cherry3.physicsBody.collisionType=@"win";
    _stick1.physicsBody.collisionType=@"stickHit";
    
    _stick2.physicsBody.collisionType=@"stickHit";
    _stick3.physicsBody.collisionType=@"stickHit";
    _stick4.physicsBody.collisionType=@"stickHit";
    _stick5.physicsBody.collisionType=@"stickHit";
    _stick7.physicsBody.collisionType=@"stickTrap";
    
    _door.physicsBody.collisionType=@"finalWin";
    _cherry4.physicsBody.collisionType=@"bound";
    _underDoor.physicsBody.collisionType=@"bound";
    _underDoor2.physicsBody.collisionType=@"railing";
    
    _pole_long.physicsBody.collisionType=@"hitPole";
    
    self.userInteractionEnabled = TRUE;
    _spikeInAir3.scale = 0.5f;
    _tipsArray = [NSArray arrayWithObjects:
                  @"Move aroung. Don't get hit by the bats.",  //0
                  @"Good! Then go to get the coin and be careful!", //1
                  @"Collect the cherry!", //2
                  @"Wow! You got the cherry",//3
                  @"Door is unlocked! Continue moving right.",//4
                  @"You get hit by a stick! Push the stick to stuck the gear!",//5
                  @"You got it!. Move right!",//6
                  nil];
    [_textBox setString:@"Tips: think, tap and move."];
    [_textBox setColor:[CCColor whiteColor]];
    [_textBox setHorizontalAlignment:CCTextAlignmentLeft];
    [_textBox setPosition:ccp(150, 20)];
    [_textBox setAnchorPoint:ccp(0, 0.5f)];
    
    
    
    countOfTime = 60;
    [_timerBox setString:@"60"];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
    
   
    
}

-(void)countTime:(NSTimer *)timer{
   
    if (countOfTime<0) {
        [self stop];
        _restart.visible = TRUE;
        [timer invalidate];
    }else{
        [_timerBox setString:[NSString stringWithFormat:@"%d",countOfTime ]];
    }
    countOfTime -= 1;
}




-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    NSLog(@"touchchchchchch");
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    
    
    /*
     CGRect cherry3AbsoluteBox = CGRectMake(_cherry3.position.x, _cherry3.position.y, _cherry3.boundingBox.size.width, _cherry3.boundingBox.size.height);
     */
    NSLog(@"_cherry3 size: %f, %f", _cherry3.boundingBox.size.height, _cherry3.boundingBox.size.width);
    NSLog(@"%@",  NSStringFromCGRect(_cherry3.boundingBox));
    NSLog(@"%@", NSStringFromCGPoint(touchLocation));
    
    NSLog(@"content node x: %f", _contentNode.position.x);
    
    if (CGRectContainsPoint(_stick1.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        if (_isTurnRight) {
            [_stick1 runAction:[CCActionRotateTo actionWithDuration:1 angle:90]];
          
            _isTurnRight = FALSE;
        }
        else{
            [_stick1 runAction:[CCActionRotateTo actionWithDuration:1 angle:0]];
            _isTurnRight = TRUE;
        }
        
        
    }
    else if (CGRectContainsPoint(_stick2.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        if (_isTurnRight2) {
            [_stick2 runAction:[CCActionRotateTo actionWithDuration:1 angle:0]];
            _isTurnRight2 = FALSE;
        }
        else{
            [_stick2 runAction:[CCActionRotateTo actionWithDuration:1 angle:180]];
            _isTurnRight2 = TRUE;
        }
    }
    else if (CGRectContainsPoint(_stick3.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        if (_isTurnRight3) {
            [_stick3 runAction:[CCActionRotateTo actionWithDuration:1 angle:20]];
            _isTurnRight3 = FALSE;
        }
        else{
            [_stick3 runAction:[CCActionRotateTo actionWithDuration:1 angle:110]];
            _isTurnRight3 = TRUE;
        }
    }
    else if (CGRectContainsPoint(_stick4.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        _stick7.physicsBody = nil;
        _stick7.visible= FALSE;
        [_stick4 runAction:[CCActionRotateTo actionWithDuration:1 angle:90]];
         
    }
    else if (CGRectContainsPoint(_stick5.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        if (_isTurnRight5) {
            
            
            [_stick5 runAction:[CCActionRotateTo actionWithDuration:1 angle:150]];
            _door.visible = TRUE;
            _isTurnRight5 = FALSE;
        }
        else{
           
            [_stick5 runAction:[CCActionRotateTo actionWithDuration:1 angle:180]];
            _isTurnRight5 = TRUE;
        }
       
        
    }
    else if (CGRectContainsPoint(_stick6.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE) {
        _stick4.physicsBody = nil;
        _stick4.visible = FALSE;
        
        
    }
    
  
    else{
        
    }
}







-(BOOL) getYesOrNo
{
    /*
     int tmp = (arc4random() % 30)+1;
     if(tmp % 5 == 0)
     return YES;
     return NO;
     */
    
    NSInteger randomy=arc4random() % (1-0+1);
    randomy=randomy+0;
    NSLog(@"%ld",(long)randomy);
    return randomy == 0;
}

-(CGPoint)getAbsoluteTouchLocation: (CGPoint) touchLocation{
    CGPoint absTouch = CGPointMake(touchLocation.x-_contentNode.position.x, touchLocation.y);
    return absTouch;
}

-(void)cherryGetCollected: (CCNode *)cherry{
    cherry.visible = FALSE;
    cherry.physicsBody = nil;
}



-(void)update:(CCTime)delta{
    
    
    
    if (_spikeInAir1.position.y <= 120){
        _spikeInAir1.physicsBody.velocity = ccp(0, 130);
    }
    
    //NSLog(@"last is %@",animationManager.lastCompletedSequenceName);
    //NSLog(@"is action going? %d", _actionGoing);
    //NSLog(@"actionstate = %u", _actionState);
    
    if (_actionGoing) {
        if (_actionState == kActionStateJump) {
            isJumpping = TRUE;
            isRunning = TRUE;
        }
        else{
            
        }
    }
    
    
    if (_actionState == kActionStateNone && _actionGoing) {
        
        
        if ([animationManager.lastCompletedSequenceName isEqualToString:@"jump"]||[animationManager.lastCompletedSequenceName isEqualToString:@"jumpLeft"]) {
            NSLog(@"in lastCompletedSequenceName ") ;
            _actionState = kActionStateIdle;
            _actionGoing = FALSE;
            NSLog(@"after lastCompletedSequenceName actionstate=%u",_actionState) ;
            
        }
        if ([animationManager.lastCompletedSequenceName isEqualToString:@"run"]) {
            NSLog(@"in lastCompletedSequenceName ") ;
            _actionState = kActionStateIdle;
            _actionGoing = FALSE;
            NSLog(@"after lastCompletedSequenceName actionstate=%u",_actionState) ;
            
        }
        
        if ([animationManager.lastCompletedSequenceName isEqualToString:@"runLeft"]) {
            NSLog(@"in lastCompletedSequenceName ") ;
            _actionState = kActionStateIdle;
            _actionGoing = FALSE;
            NSLog(@"after lastCompletedSequenceName actionstate=%u",_actionState) ;
            
        }
        
    }
    else{
        
        if (_actionState == kActionStateIdle && !_actionGoing) {
            isJumpping = FALSE;
            isRunning = FALSE;
            
            
            if (_actionIsMovingLeft) {
                NSLog(@"idle left ") ;
                [animationManager jumpToSequenceNamed:@"idle" time:0.1f];
                _actionGoing = FALSE;
                _actionState = kActionStateOut;
                
            }
            else{
                NSLog(@"idle right ") ;
                [animationManager jumpToSequenceNamed:@"idle" time:0.1f];
                _actionGoing = FALSE;
                _actionState = kActionStateOut;
            }
            
        }
        
        if (_actionState == kActionStateJump ) {
            isJumpping = TRUE;
            if (_actionIsMovingLeft) {
                [animationManager runAnimationsForSequenceNamed:@"jumpLeft"];
            }
            else{
                [animationManager runAnimationsForSequenceNamed:@"jump"];
                
            }
            _actionGoing = TRUE;
            _actionState = kActionStateNone;
            
            
            
        }
        if (_actionState == kActionStateWalk ) {
            isRunning = TRUE;
            [animationManager runAnimationsForSequenceNamed:@"run"];
            _actionGoing = TRUE;
            _actionState = kActionStateNone;
            
        }
        if (_actionState == kActionStateWalkLeft) {
            isRunning = TRUE;
            [animationManager runAnimationsForSequenceNamed:@"runLeft"];
            _actionGoing = TRUE;
            _actionState = kActionStateNone;
            
        }
        
    }
    
    
    
    
    
    
    
    
}




-(void)jump{
    
    if (TRUE) {
        
        isJumpping = TRUE;
        _actionState = kActionStateJump;
        _actionGoing = TRUE;
        NSLog(@"%u",_actionState);
        
        CGPoint launchDirection = ccp(0, 4);
        CGPoint force = ccpMult(launchDirection, 4000);
        [_runner.physicsBody applyForce:force];
    }
    
    
    
}



-(void)moveRight{
    if (FALSE) {
        isRunning = TRUE;
        _actionGoing = TRUE;
        _actionState = kActionStateWalk;
        _actionIsMovingLeft = FALSE;
        [_runner stopAllActions];
        _runner.physicsBody.velocity = ccp(60.f,0);
    }
    isRunning = TRUE;
    _actionGoing = TRUE;
    _actionState = kActionStateWalk;
    _actionIsMovingLeft = FALSE;
    [_runner stopAllActions];
    _runner.physicsBody.velocity = ccp(60.f,0);
    //[_runner runAction:[CCActionMoveBy actionWithDuration:1 position:ccp(50,0)]];
    
    
}

-(void)moveLeft{
    if (TRUE) {
        isRunning = TRUE;
        _actionGoing = TRUE;
        _actionState = kActionStateWalkLeft;
        _actionIsMovingLeft = TRUE;
        [_runner stopAllActions];
        
        /*
         CGPoint launchDirection = ccp(-1, 0);
         CGPoint force = ccpMult(launchDirection, 800);
         [_runner.physicsBody applyForce:force];
         */
        _runner.physicsBody.velocity = ccp(-60.f,0);
        
    }
    
}








-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner bound:(CCNode *)bound{
    [self stop];
    
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    return TRUE;
}




-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)runner finalWin:(CCNode *)door{
    [self stop];
    if (TRUE) {
        _restart.title = @"Win!";
        NSLog(@"Win!");
        _runner.visible = FALSE;
        _runner.physicsBody = nil;
    }
    else{
        NSLog(@"Not win yet");
    }
    _restart.visible = TRUE;
    
    
    return TRUE;
}




-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner ground:(CCNode *)bound{
    [self stop];
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair stickHit:(CCNode *)nodeA stickHit:(CCNode *)nodeB{
    
    [nodeA stopAllActions];
    [nodeB stopAllActions];
    
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)nodeA stickTrap:(CCNode *)nodeB{
    _stick7.physicsBody = nil;
    _stick7.visible= FALSE;
    [_stick4 runAction:[CCActionRotateTo actionWithDuration:1 angle:90]];
    
    return TRUE;
}

-(void)win{
    _door.visible = TRUE;
    
    isWin = TRUE;
}


-(void)stop{
    _jump.visible=FALSE;
    _move.visible=FALSE;
    _moveLeft.visible = FALSE;
    [_runner stopAllActions];
    
}

-(void)restart{
    
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay3"];
    
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

-(void)returnToMain{
    
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene];
    
}



@end
