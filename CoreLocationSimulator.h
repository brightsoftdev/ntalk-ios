//
//  CoreLocationSimulator.h
//  ntalkapp
//
//  Created by Jeduan Cornejo Legorreta on 02/10/11.
//  Copyright 2011 N-talk. All rights reserved.
//

#ifdef TARGET_IPHONE_SIMULATOR 

@interface CLLocationManager (Simulator)
@end

@implementation CLLocationManager (Simulator)

-(void)startUpdatingLocation {
    CLLocation *atemoztli = [[[CLLocation alloc] initWithLatitude:19.69905799 longitude:-99.22672754] autorelease];
    [self.delegate locationManager:self
               didUpdateToLocation:atemoztli
                      fromLocation:atemoztli];    
}

@end

#endif // TARGET_IPHONE_SIMULATOR
