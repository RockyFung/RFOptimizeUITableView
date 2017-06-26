//
//  CustomTableView.m
//  RFOptimizeUITableView
//
//  Created by rocky on 2017/6/26.
//  Copyright © 2017年 rocky. All rights reserved.
//

#import "CustomTableView.h"
#import "CustomModel.h"
#import "CustomCell.h"

@interface CustomTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *needLoadDatas;
@property (nonatomic, assign) BOOL scrollToTop;
@end
@implementation CustomTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        
        self.dataArray = [NSMutableArray array];
        self.needLoadDatas = [NSMutableArray array];
        [self loadData];

    }
    return self;
}

- (void)loadData{
    
    for (int i = 0; i < 100; i++) {
        CustomModel *model = [[CustomModel alloc]init];
        model.title = [NSString stringWithFormat:@"这是第 %d 行",i];
        [self.dataArray addObject:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [self configueCell:cell widthIndexPath:indexPath];
    return cell;
}
- (void)configueCell:(CustomCell *)cell widthIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell clear];
    cell.model = self.dataArray[indexPath.row];
    if (self.needLoadDatas.count>0&&[self.needLoadDatas indexOfObject:indexPath]==NSNotFound) {
        [cell clear];
        return;
    }
}

//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row)>skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.frame.size.width, self.frame.size.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row+3<self.dataArray.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [self.needLoadDatas addObjectsFromArray:arr];
    }
}
//用户触摸时第一时间加载内容

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (!self.scrollToTop) {
        [self.needLoadDatas removeAllObjects];
        [self loadContent];
        
    }
    return [super hitTest:point withEvent:event];
    
}

- (void)loadContent{
    if (self.scrollToTop) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells&&self.visibleCells.count>0) {
        for (id temp in [self.visibleCells copy]) {
            CustomCell *cell = (CustomCell *)temp;
            [cell loadData];
        }
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    self.scrollToTop = YES;
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.scrollToTop = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    self.scrollToTop = NO;
    [self loadContent];
}
@end
