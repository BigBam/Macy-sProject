//
//  MCSProduct.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCSProduct : NSObject
@property (assign, nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *regularPrice;
@property (nonatomic) NSString *salePrice;
@property (nonatomic) NSDictionary *stores;
@property (nonatomic) NSArray *colors;
- (id)initWithProduct:(NSUInteger)productID andName:(NSString*)productName andDescription:(NSString*)productDescription andRegularPrice:(NSString *)productRegularPrice andSalesPrice:(NSString *)productSalesPrice andImageURL:(NSString*)productImageURL andColors:(NSArray *)productColors andStores:(NSDictionary *)productStores;
@end
