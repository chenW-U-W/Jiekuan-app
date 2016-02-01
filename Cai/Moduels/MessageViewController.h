//
//  MessageViewController.h
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "MessageDetailViewController.h"
#import "MessageObj.h"
typedef void(^PushToMessageIntr) (NSString *);
@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property (nonatomic,strong) MessageDetailViewController *messageDeatilVC;
@property (nonatomic,strong) PullingRefreshTableView *unreadTableView;
@property (nonatomic,strong) PullingRefreshTableView *readedTableView;
@property (nonatomic,strong) MessageObj *messageObj;
@property (nonatomic,assign) BOOL needRefresh;
@property (nonatomic,strong) PushToMessageIntr pushToMessageIntrBlock;

- (void)postMessageWithBlock:(void(^)(id response,NSError *error))block withMessageId:(NSString *)messageID;
@end
