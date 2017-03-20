//
//  Inbox+CoreDataProperties.h
//  
//
//  Created by Rafay Hasan on 3/20/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Inbox+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Inbox (CoreDataProperties)

+ (NSFetchRequest<Inbox *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSString *imageUrlStr;
@property (nullable, nonatomic, copy) NSString *messageId;
@property (nonatomic) BOOL status;
@property (nonatomic) double time;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
