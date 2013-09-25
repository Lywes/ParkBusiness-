//
//  FAObservable.m
//  benesse
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FAObservable.h"

@implementation FAObservable

-(id)init {
    @synchronized(self) {
        if(self = [super init]) {
            observers = [[NSMutableSet alloc] init];
            observerLock = [[NSLock alloc] init];
        }
    }
    return self;
}

-(void)notifyObservers:(SEL)selector {
    @synchronized(self) {
        NSSet* observer_copy = [observers copy];
        //TODO, there has got to be a better way to avoid http://paste.pocoo.org/show/lNe6xjcgRjeDYOtl2jnX/
        for (id observer in observer_copy) {
            if([observer respondsToSelector: selector]) {
                [observer performSelector: selector];
            }
        }
        //[observer_copy release];
    }
}

-(void)notifyObservers:(SEL)selector withObject:(id)arg1 {
    @synchronized(self) {
        NSSet* observer_copy = [observers copy];
        for (id observer in observer_copy) {
            if([observer respondsToSelector: selector]) {
                [observer performSelector: selector withObject: arg1];
            }
        }
        //[observer_copy release];
    }
}

-(void)notifyObservers:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 {
    @synchronized(self) {
        NSSet* observer_copy = [observers copy];
        for (id observer in observer_copy) {
            if([observer respondsToSelector: selector]) {
                [observer performSelector: selector withObject: arg1 withObject: arg2];
            }
        }
        //[observer_copy release];
    }
}


-(void)addObserver:(id)observer {
    @synchronized(self) {
        [observers addObject: observer];
    }
}

-(void)removeObserver:(id)observer {
    @synchronized(self) {
        [observers removeObject: observer];
    }
}

-(void)removeObservers {
    @synchronized(self) {
        [observers removeAllObjects];
    }
}

-(int)countObservers {
    return [observers count];
}

@end