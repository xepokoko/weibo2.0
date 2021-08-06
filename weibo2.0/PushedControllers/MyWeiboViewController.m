//
//  MyWeiboViewController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/24.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


#import "MyWeiboViewController.h"
#import "EPCollectionViewFlowLayout.h"
@interface MyWeiboViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PassImformation>

@end

@implementation MyWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statuses = [self getModelFromPlistWithFileName:@"mystatus.plist"];
    if (self.statuses==nil) {
        self.statuses = [[NSArray alloc]init];
    }
    
    self.collectionStatuses = [self getDictionaryFromPlistWithFileName:@"collecionStatus.plist"];
    if (self.collectionStatuses == nil) {
        self.collectionStatuses = [[NSMutableArray alloc]init];
    }
    //拿到对应的作者信息
    [self getUsers];

    [self layoutView];
}


- (void) layoutView
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    EPCollectionViewFlowLayout* layout = [[EPCollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass: [EPCollectionViewCell class] forCellWithReuseIdentifier:@"EPCell2"];
    [self.view addSubview:self.collectionView];
    
}


#pragma mark - collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.statuses.count;
}
//返回cell的样式
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPCell2" forIndexPath:indexPath];
    //设置微博数据
    EPStatuses* status = self.statuses[indexPath.row];
    EPUser* user = self.users[indexPath.row];
    
    //隐藏收藏按钮
    cell.collectionBtn.hidden = YES;
    
    cell.status = status;
    cell.status.users = user;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    
    //设置转发微博的数据
    EPStatuses* retWeet = [EPStatuses statusWithDic:status.retweeted_status];
    
    cell.textView.text = status.text;
    cell.textViewHeigth =[self.textViewHeigthArray[indexPath.row]floatValue];
 
    //设置创建时间
    status.created_at = status.created_atNumber;//将数据转化成created_at的getter方法得出来的结果
    cell.createdTimeLabel.text = [NSString stringWithFormat:@"%@",status.created_at];
    //设置用户名
    cell.screenNameLabel.text = [NSString stringWithFormat:@"%@",user.screen_name];
    //设置头像
    cell.profileImageUrl = [NSURL URLWithString: user.profile_image_url];
      
    
    //判定收藏按钮，还是防止复用池问题
    if(status.isCollection == NO)
    {
        [cell.collectionBtn setImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
    }
    
    if(retWeet.user!=nil)
        {
            cell.isHaveRetWeet = YES;
            cell.retWeetTextView.text = retWeet.text;
//            NSLog(@"------%@",cell.retWeetTextView.text);
            cell.retWeetTextHeight = [self.retWeetTextHeightArray[indexPath.row]floatValue];
            cell.retWeetTextView.hidden = NO;
        }
    else
    {
        cell.isHaveRetWeet = NO;
        cell.retWeetTextView.hidden = YES;
    }
    
    //设置转发
    cell.reposts_count.text = [NSString stringWithFormat:@"%lu",status.reposts_count];
 
    //设置评论
    cell.comments_count.text = [NSString stringWithFormat:@"%lu",status.comments_count];

    //设置点赞
    cell.attitudes_count.text = [NSString stringWithFormat:@"%lu",status.attitudes_count];
    
    //设置数据后再执行设置frame操作
    [cell setViewsFrame];
    return cell;
}

//设置每个cell的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EPStatuses* status = self.statuses[indexPath.row];
    EPStatuses* retWeet = [EPStatuses statusWithDic:status.retweeted_status];
    
    
    //这个方法全部执行完了以后，才会执行cellForItemAtIndexPath的代理，所以只有最后一个返回值有用
    self.textViewHeigth = [self heightForString:status.text andWidth:ScreenWidth andFont:14];
    NSNumber *number = [NSNumber numberWithFloat:self.textViewHeigth];
    if (self.textViewHeigthArray == nil)
    {
        self.textViewHeigthArray  = [[NSMutableArray alloc]init];
    }
    [self.textViewHeigthArray addObject:number];

    
    
    
    if(retWeet.user!=nil)
    {
        self.retWeetTextHeight = [self heightForString:retWeet.text andWidth:ScreenWidth andFont:12];
    }
    else
    {
        self.retWeetTextHeight = 0;
      
    }
    
    NSNumber *number2 = [NSNumber numberWithFloat:self.retWeetTextHeight];
    if (self.retWeetTextHeightArray == nil)
    {
        self.retWeetTextHeightArray  = [[NSMutableArray alloc]init];
    }
    [self.retWeetTextHeightArray addObject:number2];
    

    float height = self.textViewHeigth+self.retWeetTextHeight+60+30;//60是头像往上，30是评论往下

    return CGSizeMake(ScreenWidth, height);
        
   
}
#pragma mark -

//获取适应文本的高度
- (float) heightForString:(NSString *)str andWidth:(float)width andFont:(float)font
{
    UITextView* temp = [[UITextView alloc]init];
    temp.font = [UIFont systemFontOfSize:font];
    temp.text = str;
     CGSize sizeToFit = [temp sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
#pragma mark - 将document中的数据取出 然后转化成模型数组
- (NSMutableArray*)getModelFromPlist
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:@"mystatus.plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filepath];
    NSLog(@"取出成功");
    NSLog(@"%@",docpath);
    
    //字典转模型然后组成数组
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(NSDictionary* dic in tempArray)
    {
        [array addObject: [EPStatuses statusWithDic:dic]];
    }
    
    return array;
}
//拿字典数组
- (NSMutableArray*)getDictionaryFromPlist
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:@"mystatus.plist"];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:filepath];
 
//    NSLog(@"%@",docpath);
    
    
    return array;
}
#pragma mark-
//检测滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //------------2657.000000------3426.000000
    float refreshLine = scrollView.contentOffset.y+48+ScreenHeight/10;
    
    if (refreshLine<0&&self.canRefresh)
    {
        //将可刷新关闭，这样就只会刷新一下
        self.canRefresh = NO;
      
    }
    //回弹之后再将可刷新打开 并且在回弹之后再刷新
    if (scrollView.contentOffset.y+48==0&&self.canRefresh==NO) {
        
        self.canRefresh = YES;
        [self.textViewHeigthArray removeAllObjects];
        [self.retWeetTextHeightArray removeAllObjects];
        [self.collectionView reloadData];
      
        
       
    }

}

#pragma mark - cell 的 delegate
- (void)passBtnClick:(NSIndexPath *)indexPath
{
    
    EPStatuses* status = self.statuses[indexPath.row];//这种赋值是，地址传递。status改变，数组里面对应的数据也会改变
    EPUser* user = self.users[indexPath.row];
    status.users = user;
    if(status.isCollection==NO)
    {
        status.isCollection = YES;
        //设置收藏编号，方便删除
        status.collectionCount = [NSNumber numberWithUnsignedInteger:self.collectionStatuses.count];
        NSDictionary* statusDic = [EPStatuses dicWithModel:status];
        [self.collectionStatuses addObject:statusDic];
    }
    else
    {
        status.isCollection = NO;
 
        //这里删除根据的是存进去的序列号，但是当数组前面的元素被删后，后面元素的序列号还没有改变就出bug了,这个已用遍历解决
        [self.collectionStatuses removeObjectAtIndex: [status.collectionCount unsignedIntegerValue]];
        //如果不是删除最后一个，遍历数组，将NSNumber从新从小到大排列一遍
        if([status.collectionCount unsignedIntegerValue]<self.collectionStatuses.count)
        {
            NSNumber* tempNumber1 = [NSNumber numberWithInt:0];
            for(NSDictionary* statusDic in self.collectionStatuses)
            {
                [statusDic setValue:tempNumber1 forKey:@"collectionCount"];
                int i  = [tempNumber1 intValue];
                i++;
                tempNumber1 = [NSNumber numberWithInt:i];
            }
            
           //遍历所有status
            for(EPStatuses* tempStatus in self.statuses)
            {
                //判断是否已经被收藏
                if (tempStatus.isCollection==YES)
                {
                    //如果收藏的序列号大于被删除的收藏微博的序列号，那么全部减1
                    if([tempStatus.collectionCount intValue]>[status.collectionCount intValue])
                    {
                        int i =  [tempStatus.collectionCount intValue];
                        i--;
                        tempStatus.collectionCount = [NSNumber numberWithInt:i];
                    }
                    
                }
                
            }
            
        }
        
    }
    
    [self writeToFileWithStatusArray:self.collectionStatuses AndFileName:@"collecionStatus.plist"];
    
    
}

#pragma mark - 拿到本地对应的作者信息
- (void)getUsers
{
    self.users = [[NSMutableArray alloc]init];
    NSMutableArray* mutArray = [self getDictionaryFromPlist];
    
    for(NSDictionary* dic in mutArray)
    {
        NSDictionary* userDic = dic[@"user"];
        EPUser* user = [EPUser userWithDic:userDic];
        [self.users addObject: user];
    }
}

#pragma mark - 从本地拿字典数组
//拿字典数组
- (NSMutableArray*)getDictionaryFromPlistWithFileName:(NSString*)name
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:name];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:filepath];


    NSLog(@"===%@",docpath);
    
    return array;
}
#pragma mark - 从本地拿模型数组
- (NSMutableArray*)getModelFromPlistWithFileName:(NSString*)name
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:name];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filepath];
    NSLog(@"取出成功");
    
    //字典转模型然后组成数组
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(NSDictionary* dic in tempArray)
    {
        [array addObject: [EPStatuses statusWithDic:dic]];
    }
    
    return array;
}

#pragma  mark - 将数组写入本地的方法
- (void) writeToFileWithStatusArray:(NSMutableArray*)mutArray AndFileName:(NSString*)name

{
   NSArray* array = mutArray;
   NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//返回的是一个文件数组
NSString* filepath = [docpath stringByAppendingPathComponent:name];
   [array writeToFile:filepath atomically:YES];
}

@end
