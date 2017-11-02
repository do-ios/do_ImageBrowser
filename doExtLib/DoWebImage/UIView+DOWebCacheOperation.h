//
//  UIView+DOWebCacheOperation.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DOWebImageManager.h"

@interface UIView (DOWebCacheOperation)

/**
 *  Set the image load operation (storage in a UIView based dictionary)
 *
 *  @param operation the operation
 *  @param key       key for storing the operation
 */
- (void)sd_setImageLoadOperation:(id)operation forKey:(NSString *)key;

/**
 *  Cancel all operations for the current UIView and key
 *
 *  @param key key for identifying the operations
 */
- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key;

/**
 *  Just remove the operations corresponding to the current UIView and key without cancelling them
 *
 *  @param key key for identifying the operations
 */
- (void)sd_removeImageLoadOperationWithKey:(NSString *)key;

@end
