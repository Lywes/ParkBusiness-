/*
 
 */

#import <Foundation/Foundation.h>

@interface FAObservable : NSObject {
    NSMutableSet* observers;
    NSLock* observerLock;
}

-(void)notifyObservers:(SEL)selector;
-(void)notifyObservers:(SEL)selector withObject:(id)arg1;
-(void)notifyObservers:(SEL)selector withObject:(id)arg1 withObject:(id)arg2;
-(void)addObserver:(id)observer;
-(void)removeObserver:(id)observer;
-(void)removeObservers;
-(int)countObservers;

@end
