
//
//  KeyIndexViewController.m
//  DEM
//
//  Created by 王宝 on 15/6/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "KeyIndexViewController.h"
#import "DEMDataSevice.h"

@interface KeyIndexViewController ()
{
    Segmented *_segment;
    UITableView *_tableView;
    
    NSMutableArray *shows;      //记录每组的展开状态
    NSMutableArray *_shows2d;    //记录二层table每组展开状态
    NSMutableArray *_heights;   //记录每组单元格的高度
    
    //记录每个指标打开状态
    NSMutableArray *states;
    
    //记录指标打开个数
    NSMutableArray *openCounts;
    
    NSString *_roomid;      //机房id
}
@end

@implementation KeyIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置关键指标";
    
    shows = [[NSMutableArray alloc] init];
    _shows2d = [[NSMutableArray alloc] init];
    _heights = [[NSMutableArray alloc] init];
    //记录指标打开状态数组
    states = [[NSMutableArray alloc] init];
    // 记录打开个数的数组
    openCounts = [[NSMutableArray alloc] init];
    
    [self initViews];
    
    [self loadSegment];
    
    [super showHUD:@"加载中"];
}

- (void)loadSegment {
    NSString *url = @"index/getRoomList";
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super setReLoadDataTap];
            [super hiddenHUD];
            return ;
        }
        
        @try {
            
            _roomList = [result objectForKey:@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in _roomList) {
                NSString *title = [dic objectForKey:@"title"];
                [array addObject:title];
            }
            
            //分段控件赋值
            //如果只有一个机房则不显示分段控件，并重新布局
            if (_roomList.count == 1) {
                [_segment removeFromSuperview];
                [_tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
            }
            else {
                if (_roomList.count>3) {
                    _segment.segmentCount = 3;
                }
                else {
                    _segment.segmentCount = (int)_roomList.count;
                }
                _segment.array = array;
            }
            
            //请求数据的初始化条件
            _roomid = [_roomList.firstObject objectForKey:@"id"];
            
            [self loadData];
            
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        
    } erro:^(id erro) {
        
    }];
}

- (void)loadData {
    
    NSString *url = @"index/showKeyTarget";
    NSDictionary *params = [NSDictionary dictionaryWithObject:_roomid forKey:@"room_id"];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            //刷新tableview
            _data = [data objectForKey:@"tree"];
            
            [self loadDataAfter];
            
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            self.alertView.message = msg;
            [self.alertView show];
        }
        @finally {
            
        }
        
        [super hiddenHUD];
        
    } erro:^(id erro) {
        [self.alertView show];
    }];
    
}

- (void)loadDataAfter {
    [shows removeAllObjects];
    [_shows2d removeAllObjects];
    [_heights removeAllObjects];
    [states removeAllObjects];
    [openCounts removeAllObjects];
    
    //一级数据
    for (NSDictionary *dic in _data) {
        
        //记录一级tableview的每组展开状态
        NSString *show = @"0";
        [shows addObject:show];
        NSMutableArray *height = [[NSMutableArray alloc] init];
        NSMutableArray *show2d = [[NSMutableArray alloc] init];
        
        //二级数据
        NSMutableArray *openCounts2d = [[NSMutableArray alloc] init];
        NSMutableArray *states2d = [[NSMutableArray alloc] init];
        NSArray *array = [dic objectForKey:@"child"];
        for (NSDictionary *dic2d in array) {
            
            //记录一级tableview每行高度
            [height addObject:[NSString stringWithFormat:@"%f",(kScreenHeight-49-64)*20/(568-49-64)]];
            //记录二级tableview每组展开状态
            [show2d addObject:@"0"];
            
            //三级数据
            int openCount = 0;
            NSMutableArray *states3d = [[NSMutableArray alloc] init];
            NSArray *array2d = [dic2d objectForKey:@"child"];
            for (NSDictionary *dic3d in array2d) {
                
                NSString *state = [dic3d objectForKey:@"state"];
                [states3d addObject:state];
                
                if ([state isEqualToString:@"1"] || state.intValue == 1) {
                    openCount++;
                }
                
            }
            
            [openCounts2d addObject:[NSString stringWithFormat:@"%d",openCount]];
            [states2d addObject:states3d];
        }
        
        [openCounts addObject:openCounts2d];
        [states addObject:states2d];
        [_shows2d addObject:show2d];
        [_heights addObject:height];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:states forKey:@"state"];
    [[NSUserDefaults standardUserDefaults] setObject:openCounts forKey:@"openCount"];
}

- (void)initViews {
    _segment = [[Segmented alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (kScreenHeight-49-64)*49/(568-49-64))];
    _segment.delegate = self;
    _segment.labelColor = RGBA(54, 125, 242, 1);
    _segment.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
    [self.view addSubview:_segment];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _segment.bottom, self.view.width, self.view.height-_segment.height-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionFooterHeight = 0;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [_data objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"child"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    static NSString *identity = @"keyindex";
    KeyIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[KeyIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.frame = CGRectMake(0, 0, self.view.width, 0);
        cell.delegate = self;
    }
     */
    
    KeyIndexCell *cell = [[KeyIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, 0, self.view.width, 0);
    cell.delegate = self;
    
    NSArray *shows2d = [_shows2d objectAtIndex:indexPath.section];
    
    NSDictionary *dic = [_data objectAtIndex:indexPath.section];
    
    NSArray *array = [dic objectForKey:@"child"];
    
    cell.data = [array objectAtIndex:indexPath.row];
    
    cell.show = [shows2d objectAtIndex:indexPath.row];
    
    cell.section = indexPath.section;
    
    cell.row = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *show = [shows objectAtIndex:indexPath.section];
    if ([show isEqualToString:@"0"] || show.intValue == 0) {
        return 0;
    }
    NSArray *heights = [_heights objectAtIndex:indexPath.section];
    return [[heights objectAtIndex:indexPath.row] floatValue];
}

#pragma mark 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [_data objectAtIndex:section];
    NSString *title = [dic objectForKey:@"name"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3, (kScreenHeight-49-64)*30/(568-49-64))];
    button.tag = section;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = RGBA(54, 125, 242, 1);
    button.titleLabel.textColor = [UIColor whiteColor];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = RGBA(31, 78, 154, 1).CGColor;
    bottomBorder.frame = CGRectMake(0, button.bottom-0.5, button.width, 0.5);
    [button.layer addSublayer:bottomBorder];
    
    return view;
}

- (void)buttonAction:(UIButton *)button {
    NSString *show = [shows objectAtIndex:button.tag];
    if ([show isEqualToString:@"0"] || show.intValue == 0) {
        show = @"1";
    }
    else {
        show = @"0";
    }
    [shows replaceObjectAtIndex:button.tag withObject:show];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (kScreenHeight-49-64)*30/(568-49-64);
}

#pragma mark KeyIndexDelegate
- (void)cellHeightChangeAtSection:(NSInteger)section Row:(NSInteger)row Height:(float)height State:(NSString *)showState{
    
    //改变行高
    NSMutableArray *heights = [_heights objectAtIndex:section];
    float hei = [[heights objectAtIndex:row] floatValue];
    hei += height;
    [heights replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%f",hei]];
    [_heights replaceObjectAtIndex:section withObject:heights];
    
    //改变二级tableview展开状态
    NSMutableArray *show2d = [_shows2d objectAtIndex:section];
    [show2d replaceObjectAtIndex:row withObject:showState];
    [_shows2d replaceObjectAtIndex:section withObject:show2d];
    
    [_tableView reloadData];
}

#pragma mark 分段协议
- (void)Segmented:(Segmented *)segmented DidSelectAtIndex:(NSInteger) index {
    _roomid = [[_roomList objectAtIndex:index] objectForKey:@"id"];
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"state"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"openCount"];
}


- (void)reLoadData {
    [super showHUD:@"加载中"];
    [self loadData];
    [super removeReLoadDataTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
