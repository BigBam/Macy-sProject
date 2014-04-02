//
//  MCSDataFetch.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCSDataFetch : NSObject
@property (nonatomic) NSArray *parsedResults;
- (NSArray *)fetch;
@end
