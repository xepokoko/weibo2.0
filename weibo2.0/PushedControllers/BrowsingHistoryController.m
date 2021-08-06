//
//  BrowsingHistoryController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/26.
//  Copyright © 2021 谢恩平. All rights reserved.
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "BrowsingHistoryController.h"

@interface BrowsingHistoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,PassImformation>

@end

@implementation BrowsingHistoryController
- (NSMutableArray*)collectionStatuses
{
    if(_collectionStatuses==nil)
    {
        _collectionStatuses = [[NSMutableArray alloc]init];
    }
    return _collectionStatuses;
}

- (NSArray*)statuses
{
    if(_statuses==nil)
    {
        _statuses = [[NSArray alloc]init];
    }
    return _statuses;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionStatuses = [self getDictionaryFromPlistWithFileName:@"collecionStatus.plist"];
    self.statuses = [self getModelFromPlistWithFileName:@"browsingHistory.plist"];
    self.statuses = [[self.statuses reverseObjectEnumerator]allObjects];//倒序
    [self getUsers];
    self.users = (NSMutableArray*)[[self.users reverseObjectEnumerator]allObjects];//倒序
    
    [self layoutView];
}

- (void) layoutView
{
    self.view.backgroundColor = [UIColor whiteColor];
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
    cell.status = status;
    cell.user = user;
    cell.indexPath = indexPath;
    
    //设置转发微博的数据
    EPStatuses* retWeet = [EPStatuses statusWithDic:status.retweeted_status];
    
    cell.textView.text = status.text;
    cell.textViewHeigth =[self.textViewHeigthArray[indexPath.row]floatValue];
 
    //设置创建时间,判定一下是否为我的微博
    if(status.created_at == nil)
    {
        status.created_at = status.created_atNumber;
    }
    cell.createdTimeLabel.text = [NSString stringWithFormat:@"%@",status.created_at];
    
    //设置用户名
    cell.screenNameLabel.text = [NSString stringWithFormat:@"%@",user.screen_name];
    //设置头像
    cell.profileImageUrl = [NSURL URLWithString: user.profile_image_url];
    //设置代理
    cell.delegate = self;
      
    //判定是否有图片,防止复用池产生的问题
    if (status.original_pic!=nil)
    {
        cell.originalPic.hidden = NO;
        
    }
    else
    {
        cell.originalPic.hidden = YES;
    }

    
    if(retWeet.user!=nil)
        {
            cell.isHaveRetWeet = YES;
            cell.retWeetTextView.text = retWeet.text;

            cell.retWeetTextHeight = [self.retWeetTextHeightArray[indexPath.row]floatValue];
            cell.retWeetTextView.hidden=NO;//防止复用池 那个cell产生了不属于它的东西
        }
    else
    {
        cell.isHaveRetWeet = NO;
        cell.retWeetTextView.hidden = YES;//防止复用池 那个cell产生了不属于它的东西
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

    
    //这个方法全部执行完了以后，才会执行cellForItemAtIndexPath的代理
    self.textViewHeigth = [self heightForString:status.text andWidth:ScreenWidth andFont:14];
    NSNumber *number = [NSNumber numberWithFloat:self.textViewHeigth];
    if (self.textViewHeigthArray == nil)
    {
        self.textViewHeigthArray  = [[NSMutableArray alloc]init];
    }
    //组成文本高度数组
    [self.textViewHeigthArray addObject:number];

    //判定是否有图片
    if (status.original_pic!=nil)
    {
        self.originalPicHeight = 200;
        
    }
    else
    {
        self.originalPicHeight = 0;
    }
    
    
    
    //判断是否存在转发微博
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
    

    float height = self.textViewHeigth+self.retWeetTextHeight+self.originalPicHeight+60+30;//60是头像往上，30是评论往下

    return CGSizeMake(ScreenWidth, height);
        
}
#pragma mark -自适应文本高度

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

#pragma  mark - 将数组写入本地的方法
- (void) writeToFileWithStatusArray:(NSMutableArray*)mutArray AndFileName:(NSString*)name

{
   NSArray* array = mutArray;
   NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//返回的是一个文件数组
NSString* filepath = [docpath stringByAppendingPathComponent:name];
   [array writeToFile:filepath atomically:YES];
}

#pragma mark - 拿字典数组
- (NSMutableArray*)getDictionaryFromPlistWithFileName:(NSString*)name
{
    NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* filepath = [docpath stringByAppendingPathComponent:name];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:filepath];
    
    return array;
}
#pragma mark - 拿到本地对应的作者信息
- (void)getUsers
{
    self.users = [[NSMutableArray alloc]init];
    NSMutableArray* mutArray = [self getDictionaryFromPlistWithFileName:@"browsingHistory.plist"];
    
    for(NSDictionary* dic in mutArray)
    {
        NSDictionary* userDic = dic[@"user"];
        EPUser* user = [EPUser userWithDic:userDic];
        [self.users addObject: user];
    }
}

@end
