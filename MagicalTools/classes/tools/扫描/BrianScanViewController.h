//
//  BrianScanViewController.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-5-17.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"

@interface BrianScanViewController : BaseViewController<ZBarReaderDelegate,ZBarReaderViewDelegate>

@property (nonatomic,strong) ZBarReaderView* readerView;
@property (nonatomic,strong) IBOutlet UIView* sacnSignView;

@end
