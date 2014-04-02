//
//  MCSDataFetch.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSDataFetch.h"

#define JSON_URL "http://www.json-generator.com/j/bYFmFeCAZe?indent=4"

@implementation MCSDataFetch
- (NSArray *)fetch {
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@JSON_URL]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    self.parsedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return self.parsedResults;
}
@end
