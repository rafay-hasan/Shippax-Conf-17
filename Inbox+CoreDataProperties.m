//
//  Inbox+CoreDataProperties.m
//  
//
//  Created by Rafay Hasan on 3/20/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Inbox+CoreDataProperties.h"

@implementation Inbox (CoreDataProperties)

+ (NSFetchRequest<Inbox *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Inbox"];
}

@dynamic details;
@dynamic imageUrlStr;
@dynamic messageId;
@dynamic status;
@dynamic time;
@dynamic title;

@end
