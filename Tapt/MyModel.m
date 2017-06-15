//
//  MyModel.m
//  DragAndDropDemo
//
//  Created by Son Ngo on 2/9/14.
//  Copyright (c) 2014 Son Ngo. All rights reserved.
//

#import "MyModel.h"

#pragma mark - 
@implementation MyModel

- (instancetype)initWithValue:(int)value url:(NSString *)imgUrl fname:(NSString *)firstName lname:(NSString *)lastName {
  if (self = [super init]) {
      self.value = value;
      self.firstName=firstName;
      self.lastName=lastName;
      self.imgUrl=imgUrl;
      
      
      
  }
  return self;
}

@end
