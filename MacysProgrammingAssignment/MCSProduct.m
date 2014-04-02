//
//  MCSProduct.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProduct.h"

@implementation MCSProduct

- (id)initWithProduct:(NSUInteger)productID andName:(NSString*)productName andDescription:(NSString*)productDescription andRegularPrice:(NSString *)productRegularPrice andSalesPrice:(NSString *)productSalesPrice andImageURL:(NSString*)productImageURL andColors:(NSArray *)productColors andStores:(NSDictionary *)productStores
{
    self = [super init];
    
    if(self){
        
        self.id = productID;
        self.name = productName;
        self.description = productDescription;
        self.regularPrice = productRegularPrice;
        self.salePrice = productSalesPrice;
        self.imageURL = productImageURL;
        self.colors = productColors;
        self.stores = productStores;
    }
    
    return self;
}
@end
