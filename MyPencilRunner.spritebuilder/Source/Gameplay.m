//
//  Gameplay.m
//  MyPencilRunner
//
//  Created by Aihua Peng on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#define WeakSelf(__var__) __unsafe_unretained typeof(*self) *__var__ = self
#define WeakNode(__var__,__node__) __unsafe_unretained typeof(*__node__) *__var__ = __node__


#import "Gameplay.h"
#import "Runner.h"


@implementation Gameplay{
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
    CCNode *_channelWall1;
    CCNode *_channelWall2;
    CCNode *_channelWall3;
    
    CCLabelTTF *_textBox;
    CCLabelTTF *_cherryTextBox;
    
    CCNode *_pole_short;
    CCNode *_pole_long;
    CCNode *_pole_long_short1;
    CCNode *_pole_long_short2;
    CCNode *_cherry_small;
    CCNode *_stick_small;
    
    
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
    CCAnimationManager *animationManager;
    
    NSArray *_tipsArray;
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
    _stick1.visible = FALSE;
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
    
    
    
    
    _cherry1.physicsBody.sensor = TRUE;
    _cherry2.physicsBody.sensor = TRUE;
    _cherry3.physicsBody.sensor = TRUE;
    _cherry4.physicsBody.sensor = TRUE;
    _coin2.physicsBody.sensor = TRUE;
    _hiddenWall.physicsBody.sensor = TRUE;
    _hiddenWall2.physicsBody.sensor = TRUE;
    _hiddenWall3.physicsBody.sensor = TRUE;
    _pole_short.physicsBody.sensor = TRUE;
    _physicsNode.collisionDelegate = self;
    
    self.userInteractionEnabled = TRUE;
    
    _runner = (Runner *)[CCBReader load:@"RunnerNode"];
  
    
    
    _runner.position = CGPointMake(50.0f, 200.0f);
    _runner.physicsBody.collisionType=@"runner";
    _runner.physicsBody.allowsRotation = FALSE;
    
    
    [_physicsNode addChild:_runner];
    
    animationManager = _runner.animationManager;
   
    [animationManager runAnimationsForSequenceNamed:@"idle"];
    
   
    _spike1.physicsBody.collisionType=@"bound";
    _leftbound.physicsBody.collisionType=@"bound";
    _rightbound.physicsBody.collisionType=@"bound";
    //_topbound.physicsBody.collisionType=@"bound";
    //_channelWall1.physicsBody.collisionType=@"bound";
    //_channelWall2.physicsBody.collisionType=@"bound";
    //_channelWall3.physicsBody.collisionType=@"bound";
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
    [_textBox setString:_tipsArray[0]];
    [_textBox setColor:[CCColor whiteColor]];
    [_textBox setHorizontalAlignment:CCTextAlignmentLeft];
    [_textBox setPosition:ccp(150, 20)];
    [_textBox setAnchorPoint:ccp(0, 0.5f)];
   
}




-(void)spikePopUp:(CCNode *) spike{
    
    NSLog(@"spike1111spike1111spike1111spike1111spike1111");
    CGPoint launchDirection = ccp(0, 1);
    CGPoint force = ccpMult(launchDirection, 8000);
    [spike.physicsBody applyForce:force];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    
    NSLog(@"touchchchchchch");
    
    CGPoint touchLocation = [touch locationInNode:self];

    if (CGRectContainsPoint([_spike1 boundingBox], touchLocation)) {
        [self spike1PopUp:_spike1];
        
    }
   
    /*
    CGRect cherry3AbsoluteBox = CGRectMake(_cherry3.position.x, _cherry3.position.y, _cherry3.boundingBox.size.width, _cherry3.boundingBox.size.height);
    */
    NSLog(@"_cherry3 size: %f, %f", _cherry3.boundingBox.size.height, _cherry3.boundingBox.size.width);
    NSLog(@"%@",  NSStringFromCGRect(_cherry3.boundingBox));
    NSLog(@"%@", NSStringFromCGPoint(touchLocation));
    
    NSLog(@"content node x: %f", _contentNode.position.x);
    
    if (CGRectContainsPoint(_cherry3.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE && _isCherry3Triggered) {
        NSLog(@"cherry 3 : %d", _isCherry3Triggered);
        [_textBox setString:_tipsArray[3]];
        [self cherryGetCollected:_cherry3];
        _isCherryCollected = TRUE;
        _isCherry3Triggered = TRUE;
        [_cherryTextBox setString:@"Green cherry collected."];
        _cherry_small.visible = TRUE;
        _cherry4.physicsBody = nil;
        _cherry1.physicsBody = nil;
        _cherry2.physicsBody = nil;
        [self win];
    }
    
    else if (CGRectContainsPoint(_stick1.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE &&
        _isSpikeStuck) {
        [self cherryGetCollected:_stick1];
        _isStickCollected = TRUE;
        [_cherryTextBox setString:@"Stick collected."];
        _stick_small.visible = TRUE;
        
    }
    else if (CGRectContainsPoint(_stick_small.boundingBox, touchLocation) == TRUE&&_isStickCollected) {
        NSLog(@"stick-small get touched!!!!");
        _isStickTapped = TRUE;
        [_stick_small setScaleX:0.3];
        [_stick_small setScaleY:0.4];
    }
    else if ( CGRectContainsPoint(_pole_short.boundingBox, [self getAbsoluteTouchLocation:touchLocation]) == TRUE&&_isStickTapped) {
        NSLog(@"pole-short get placed!!!!");
        [_pole_short setVisible:TRUE];
        
        [_pole_short.physicsBody setSensor:FALSE];
        _isStickTapped = FALSE;
        [_pole_short.physicsBody setType: CCPhysicsBodyTypeStatic];
        _isStickPlaced = TRUE;
        
        [_stick_small setScaleX:0.2];
        [_stick_small setScaleY:0.3];
        
    }
    else{
        _isStickTapped = FALSE;
        [_stick_small setScaleX:0.2];
        [_stick_small setScaleY:0.3];
    }
   
    
    
    
    
}


-(CGPoint)getAbsoluteTouchLocation: (CGPoint) touchLocation{
    CGPoint absTouch = CGPointMake(touchLocation.x-_contentNode.position.x, touchLocation.y);
    return absTouch;
}

-(void)cherryGetCollected: (CCNode *)cherry{
    cherry.visible = FALSE;
    cherry.physicsBody = nil;
}

-(void)spike1PopUp: (CCNode *)spike{
    spike.physicsBody.type= CCPhysicsBodyTypeDynamic;
    _spikeInAir1.opacity = 0.5f;
    _spikeInAir1.visible = TRUE;
    _spikeInAir1.physicsBody =nil;
 
    _spikeInAir3.opacity = 0.5f;
    _spikeInAir3.visible = TRUE;
    _spikeInAir3.physicsBody =nil;
    [ _spike1.physicsBody applyImpulse:ccp(0, 600.f)];
   

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

-(void)moveRight1{
    
     _actionState = kActionStateWalk;
    
    [_runner stopAllActions];
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 800);
    [_runner.physicsBody applyForce:force];
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_runner worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
    
}

-(void)moveRight{
    if (FALSE) {
        isRunning = TRUE;
        _actionGoing = TRUE;
        _actionState = kActionStateWalk;
        _actionIsMovingLeft = FALSE;
        [_runner stopAllActions];
        _runner.physicsBody.velocity = ccp(60.f,0);
        CCActionFollow *follow = [CCActionFollow actionWithTarget:_runner worldBoundary:self.boundingBox];
        [_contentNode runAction:follow];
    }
    isRunning = TRUE;
    _actionGoing = TRUE;
    _actionState = kActionStateWalk;
    _actionIsMovingLeft = FALSE;
    [_runner stopAllActions];
    _runner.physicsBody.velocity = ccp(60.f,0);
    //[_runner runAction:[CCActionMoveBy actionWithDuration:1 position:ccp(50,0)]];
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_runner worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
    
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
        CCActionFollow *follow = [CCActionFollow actionWithTarget:_runner worldBoundary:self.boundingBox];
        [_contentNode runAction:follow];
    }
   
}






-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner spike:(CCNode *)spike{
    [self stop];
    
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    _spikeInAir1.visible=TRUE;
    _spikeInAir3.visible=TRUE;
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner bound:(CCNode *)bound{
    [self stop];
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bound:(CCNode *)nodeA railing:(CCNode *)nodeB{
    nodeB.physicsBody.velocity = ccp(100, 0);
    

    
    
    return TRUE;
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner hiddenWallTrigger:(CCNode *)_hiddenWall{
    
    
    _spikeInAir1.physicsBody.velocity = ccp(-100, 0);
    NSLog(@"crash on hidden wall");
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner hiddenWallTrigger2:(CCNode *)_hiddenWall2{
    
    NSLog(@"crash on hidden wall2222222");
    
    CCNode *railing = [CCBReader load:@"RailingNode"];
    railing.physicsBody.type = CCPhysicsBodyTypeDynamic;
    railing.physicsBody.collisionType = @"railingHit";
    railing.physicsBody.allowsRotation = FALSE;
    railing.physicsBody.affectedByGravity = FALSE;
    railing.position = ccp(1061, 67);
    [_physicsNode addChild:railing];

    railing.physicsBody.velocity = ccp(-100, 0);
    
    [_textBox setString:_tipsArray[4]];
    
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair railingHit:(CCNode *)nodeA bound:(CCNode *)nodeB{
    NSLog(@"railingHitBound");
    [nodeA setVisible:FALSE];
    [nodeA removeFromParent];
    return TRUE;
    
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair railingHit:(CCNode *)nodeA runner:(CCNode *)nodeB{
    [self stop];
    NSLog(@"collision detected");
    _restart.visible = TRUE;
    return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner hiddenWallTrigger3:(CCNode *)_hiddenWall3{
    
    
    
    NSLog(@"crash on hidden wall33333");
    [_textBox setString:_tipsArray[1]];
    
    return TRUE;
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)nodeA stickHit:(CCNode *)nodeB{
    
    
    [_textBox setString:_tipsArray[5]];
    return TRUE;    
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair stickHit:(CCNode *)nodeA spike:(CCNode *)nodeB{
    [nodeA.physicsBody setType:CCPhysicsBodyTypeStatic];
    [nodeB setPhysicsBody:nil];
    [nodeB.animationManager setPaused:YES];
    [_textBox setString:_tipsArray[6]];
    _isSpikeStuck = TRUE;
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)nodeA hitPole:(CCNode *)nodeB{
    
    if (_isStickPlaced) {
        
    }
    else{
        [_pole_long_short1 setVisible:TRUE];
        [_pole_long_short2 setVisible:TRUE];
        [nodeB setPhysicsBody:nil];
        [nodeB setVisible:FALSE];
        [_pole_long_short1.physicsBody setType:CCPhysicsBodyTypeDynamic];
        [_pole_long_short2.physicsBody setType:CCPhysicsBodyTypeDynamic];
        [_textBox setString:@"Wait. Don't you think previous stick is useful?"];

    }
    return TRUE;
    
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner cherryFall:(CCNode *)cherry{
    if (!_isCoinTriggered) {
        _cherry1.visible = TRUE;
        _cherry1.physicsBody.sensor = FALSE;
        _cherry1.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _cherry2.visible = TRUE;
        _cherry2.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _cherry2.physicsBody.sensor = FALSE;
        _cherry3.visible = TRUE;
        _cherry3.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _cherry3.physicsBody.sensor = FALSE;
        _cherry4.visible = TRUE;
        _cherry4.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _cherry4.physicsBody.sensor = FALSE;
        _isCherry3Triggered  = TRUE;
        _stick1.visible = TRUE;
        _stick1.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _stick1.physicsBody.sensor = FALSE;
        NSLog(@"Cherry begin falling");
        [_textBox setString:_tipsArray[2]];
        _isCoinTriggered = TRUE;
    }
    
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)_runner win:(CCNode *)winCherry{
   
    NSLog(@"Door comes up");
    _cherry4.physicsBody = nil;
    _cherry1.physicsBody = nil;
    _cherry2.physicsBody = nil;
    [self win];
    return TRUE;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair runner:(CCNode *)runner finalWin:(CCNode *)door{
    [self stop];
    if (isWin) {
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
   
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay2"];
  
    [[CCDirector sharedDirector] replaceScene:scene];
    
}

-(void)returnToMain{
    
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene];
    
}



@end
