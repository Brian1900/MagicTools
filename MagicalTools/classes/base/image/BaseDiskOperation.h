//
//  BaseDiskOperation.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownTaskOperation.h"
#import "BaseDownloaderCache.h"

typedef enum {
    eCTDiskOperationTypeRead,
    eCTDiskOperationTypeWrite,
    eCTDiskOperationTypeDelete,
} eCTDiskOperationType;

@interface BaseDiskOperation : BaseDownTaskOperation


///**	是否存储压缩缓存 */
//@property (nonatomic, assign) BOOL isSmallCache;
///**	压缩缓存大小 */
//@property (nonatomic, assign) CGSize smallCacheSize;
/**	物理文件操作类型 */
@property (nonatomic, assign) eCTDiskOperationType diskOperationType;

@end
