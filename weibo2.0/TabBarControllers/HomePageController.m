//
//  HomePageController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/15.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "HomePageController.h"
#import "Oauth2ViewController.h"
#import "WebViewController.h"
#import "EPStatuses.h"
#import "EPUser.h"
#import "EPPicture.h"
#import "EPCollectionViewCell.h"
#import "EPCollectionViewFlowLayout.h"
#import <AFNetworking/AFNetworking.h>
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


@interface HomePageController ()<UICollectionViewDelegate,UICollectionViewDataSource,PassImformation,UISearchResultsUpdating>

@end

@implementation HomePageController
//切换tabbarcontroller也会调用
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.browsingHistoryStatuse = [self getDictionaryFromPlistWithFileName:@"browsingHistory.plist"];
   
    self.collectionStatuses = [self getDictionaryFromPlistWithFileName:@"collecionStatus.plist"];
   
    self.myStatuses = [self getModelFromPlistWithFileName:@"mystatus.plist"];
    self.myStatuses = (NSMutableArray*)[[self.myStatuses reverseObjectEnumerator]allObjects];//倒一下排序，让更迟的在上面
    [self getMyUsers];
    self.myUsers = (NSMutableArray*)[[self.myUsers reverseObjectEnumerator]allObjects];//倒一下排序
    
    
    
    [self loadNewStatuses];

    [self layOutMainView];

//    [self layOutLogInView];
    //初始化是否能刷新
    self.canRefresh = YES;
}
#pragma mark - 懒加载
-(NSMutableArray*)textViewHeigthArray
{
    if(_textViewHeigthArray==nil)
    {
        _textViewHeigthArray = [[NSMutableArray alloc]init];
    }
    return _textViewHeigthArray;
}
-(NSMutableArray*)retWeetTextHeightArray
{
    if(_retWeetTextHeightArray==nil)
    {
        _retWeetTextHeightArray = [[NSMutableArray alloc]init];
    }
    return _retWeetTextHeightArray;
}
-(NSMutableArray*)searchListArray
{
    if(_searchListArray==nil)
    {
        _searchListArray = [[NSMutableArray alloc]init];
    }
    return _searchListArray;
}
- (NSMutableArray*)browsingHistoryStatuse
{
    if(_browsingHistoryStatuse==nil)
    {
        _browsingHistoryStatuse = [[NSMutableArray alloc]init];
    }
    return _browsingHistoryStatuse;
}
- (NSMutableArray*)collectionStatuses
{
    if(_collectionStatuses==nil)
    {
        _collectionStatuses  = [[NSMutableArray alloc]init];
    }
    return _collectionStatuses;
}
-(NSMutableArray*)allStatuses{
    if (_allStatuses==nil) {
        _allStatuses = [[NSMutableArray alloc]init];
    }
    return _allStatuses;
}
-(NSMutableArray*)allUsers
{
    if(_allUsers==nil)
    {
        _allUsers = [[NSMutableArray alloc]init];
    }
    return _allUsers;
}
-(NSMutableArray*)myStatuses
{
    if(_myStatuses==nil)
    {
        _myStatuses = [[NSMutableArray alloc]init];
    }
    return _myStatuses;
}
-(NSMutableArray*)myUsers
{
    if(_myUsers==nil)
    {
        _myUsers = [[NSMutableArray alloc]init];
    }
    return _myUsers;
}



#pragma mark - 登录时的界面
- (void) layOutLogInView
{
//最上面的微博标志
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight/8, 128, 128)];
    imageView.image = [UIImage imageNamed:@"weibo"];
    [self.view addSubview:imageView];
    
    //两行label
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-60, ScreenHeight/8+140,120, 20)];
    label1.text = @"登陆微博";
    label1.textAlignment = NSTextAlignmentCenter;//居中显示
    label1.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label1];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-70, ScreenHeight/8+170,140, 20)];
    label2.text = @"分享生活 发现世界";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font  = [UIFont systemFontOfSize:15];
    [label2 setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:label2];
    [self setButtons];
    
}

- (void) setButtons
{
    //登陆按钮
    UIButton* logInButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, ScreenHeight*2/3,300 , 50)];
    [logInButton setTitle:@"登陆" forState:UIControlStateNormal];
    [logInButton setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
    logInButton.layer.cornerRadius = 10;
    logInButton.clipsToBounds = YES;
    [self.view addSubview:logInButton];
    
    [logInButton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

#pragma mark - 登陆方法
- (void)logIn
{
    [self.navigationController pushViewController:[[Oauth2ViewController alloc]init] animated:YES];

}



#pragma mark - 加载最新的statuses
-(void) loadNewStatuses
{
    //创建AFN管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置url
    NSString* baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"access_token"] = @"2.002bZvfG76EftBc8b45ca675cadPOB";
    
    //GET请求方法
    [manager GET:baseURL parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //将返回的字典数组resposeObject抽离出statuses字典数组
            NSArray* dicArray = responseObject[@"statuses"];
            //将字典数组转化为模型数组
            self.statuses=[self statusArrayWithDictionaryArray:dicArray];
            //将我的微博和网络数据拼接起来
            [self.allStatuses addObjectsFromArray:self.myStatuses];
            [self.allStatuses addObjectsFromArray:self.statuses];
            
            //将作者拼起来
            [self.allUsers addObjectsFromArray:self.myUsers];
            [self.allUsers addObjectsFromArray:self.users];
            NSInteger i =0;
            for(EPStatuses* status in self.allStatuses)
            {
                status.users = self.allUsers[i];
                i++;
            }
            //在主线程中做信息更新，不然会报错。
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"连接失败，失败原因---%@",error);
        }];
    /*
    NSURL* url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.002bZvfGlhZb1C3a01768d7d0F8JKg"];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
     {
        
        //这个runloop是用来等待异步加载完毕后再执行其它代码的一个循环，我用来防止：网速慢，还没加载出数组，那边就要取数组数据了，导致崩溃。
//        CFRunLoopStop(CFRunLoopGetMain());//改变runloop模式
        
        NSDictionary* statusesDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* dicArray = statusesDic[@"statuses"];
        //将字典数组转化为模型数组
        self.statuses=[self statusArrayWithDictionaryArray:dicArray];
        //将我的微博和网络数据拼接起来
        [self.allStatuses addObjectsFromArray:self.myStatuses];
        [self.allStatuses addObjectsFromArray:self.statuses];
        
        //将作者拼起来
        [self.allUsers addObjectsFromArray:self.myUsers];
        [self.allUsers addObjectsFromArray:self.users];
        NSInteger i =0;
        for(EPStatuses* status in self.allStatuses)
        {
            status.users = self.allUsers[i];
            i++;
        }
        
        
        //在主线程中做信息更新，不然会报错。
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
    [dataTask resume];
    
//    CFRunLoopRun();//恢复runloop
     */
}
#pragma mark - 设置登录后用的view
-(void)layOutMainView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //设置搜索控制器
    UISearchController* search = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    search.searchResultsUpdater = self;
    search.dimsBackgroundDuringPresentation = NO;
    search.hidesNavigationBarDuringPresentation = YES;
    self.searchController = search;
    self.searchController.searchBar.frame = CGRectMake(0,92.5, ScreenWidth, 44.0);
    self.searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchController.searchBar];
    
    
    
    //设置流式布局
    EPCollectionViewFlowLayout* layout = [[EPCollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;//纵向滑动
    //设置collectionview
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 93+44, ScreenWidth, ScreenHeight-self.navigationController.navigationBar.frame.size.height) collectionViewLayout:layout];//这里整体减去了navigationbar的高度。
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;//斯滑
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.showsVerticalScrollIndicator = YES;//是否显示滚动条
    [self.collectionView registerClass: [EPCollectionViewCell class] forCellWithReuseIdentifier:@"EPCell"];
    //设置delegate
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    //设置tabbaritem的按钮
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shuaxin"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshCell)];
    [btnItem setWidth:50];
    self.navigationItem.rightBarButtonItem = btnItem;
    
}
#pragma mark - collectionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.searchController.active)
    {
        return self.searchListArray.count;
    }
    
    return self.allStatuses.count;
}
//返回cell的样式
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    EPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EPCell" forIndexPath:indexPath];
    //设置微博数据
    EPStatuses* status = [[EPStatuses alloc]init];

    if(self.allStatuses.count!=0){
        status = self.allStatuses[indexPath.row];
    }
        
    EPUser* user = status.users;
    if (self.searchController.active)
    {
        status = self.searchListArray[indexPath.row];
        user = status.users;
    }
    
    status.picUrlStringArray = [self picArrayWithDictionaryArray:status.pic_urls];//转成字符串数组
    
    cell.status = status;
    cell.user = user;
    cell.indexPath = indexPath;
    if(self.picHeightArray.count!=0)//防止加载更多微博时，滑得过快或者回弹的数组为空的bug
    {
    cell.picHeight = [self.picHeightArray[indexPath.row]floatValue];
    cell.textViewHeigth =[self.textViewHeigthArray[indexPath.row]floatValue];
    }
    //设置转发微博的数据
    EPStatuses* retWeet = [EPStatuses statusWithDic:status.retweeted_status];
    
    cell.textView.text = status.text;
    
 
    //设置创建时间,判定一下是否为我的微博
    if(status.created_at == nil)
    {
        status.created_at = status.created_atNumber;
    }
    cell.createdTimeLabel.text = [NSString stringWithFormat:@"%@",status.created_at];
    
    //设置用户名
    cell.screenNameLabel.text = [NSString stringWithFormat:@"%@",user.screen_name];
    //设置头像
    cell.headPicture.image = [UIImage imageNamed:@"touxiang"];//复用后的初始化图片，防止头像乱跑
    cell.profileImageUrl = [NSURL URLWithString: user.profile_image_url];
    //设置代理
    cell.delegate = self;
      
    //判定是否有第一张图片,防止复用池产生的问题
    if (status.original_pic!=nil)
    {
        cell.originalPic.image = [UIImage imageNamed:@"图片背景图"];
        cell.originalPic.hidden = NO;
    }
    else
    {
        cell.originalPic.hidden = YES;
    }
    //还是复用池问题，隐藏冗余的多图
    if (status.pic_urls.count<=1)
    {
        for(UIImageView* imageView in cell.picsArray)
        {
            imageView.hidden = YES;
        }
    }
    else
    {
        cell.originalPic.hidden = YES;//多图的时候单图也要隐藏
        //
        for (NSUInteger i = status.pic_urls.count; i<=8; i++)
        {
            UIImageView* imageView = cell.picsArray[i];
            imageView.hidden = YES;
        }
        for (NSInteger j = status.pic_urls.count-1;j>=0;j--)
        {
            UIImageView* imageView = cell.picsArray[j];
            imageView.image = [UIImage imageNamed:@"图片背景图"];
            imageView.hidden = NO;
        }
        
    }
    
    
    
    //判定收藏按钮，还是防止复用池问题
    if(status.isCollection == NO)
    {
        [cell.collectionBtn setImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
    }
    
    if(retWeet.user!=nil)
        {
            cell.isHaveRetWeet = YES;
            cell.retWeetTextView.text = retWeet.text;
            if (self.retWeetTextHeightArray.count!=0)//防止加载更多微博时，滑得过快或者回弹的数组为空的bug
            {
            cell.retWeetTextHeight = [self.retWeetTextHeightArray[indexPath.row]floatValue];
            }
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
//这个方法全部执行完了以后，才会执行cellForItemAtIndexPath的代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EPStatuses* status = self.allStatuses[indexPath.row];
    EPStatuses* retWeet = [EPStatuses statusWithDic:status.retweeted_status];

    
    
    self.textViewHeigth = [self heightForString:status.text andWidth:ScreenWidth andFont:14];
    NSNumber *number = [NSNumber numberWithFloat:self.textViewHeigth];
    if (self.textViewHeigthArray == nil)
    {
        self.textViewHeigthArray  = [[NSMutableArray alloc]init];
    }
    //组成文本高度数组
    [self.textViewHeigthArray addObject:number];

    //判定是否只有一张或者没有图片
    if(status.pic_urls.count<=1)
    {
        if (status.original_pic!=nil)
        {
            self.picHeight = 200;
        }
        else
        {
            self.picHeight = 0;
        }
    }
    else
    {
        CGFloat margin = 5;//图片间距
        CGFloat width = (ScreenWidth-2*margin)/3.0;//图片宽度
        if(status.pic_urls.count<=9)
        {
            self.picHeight = ((status.pic_urls.count-1)/3+1)*(margin+width);//九宫格算法返回高度
        }
        else
        {
            self.picHeight = 3*(width+margin);
        }
    }
    NSNumber* number3 = [NSNumber numberWithFloat:self.picHeight];
    if(self.picHeightArray==nil)
    {
        self.picHeightArray = [[NSMutableArray alloc]init];
    }
    [self.picHeightArray addObject:number3];
     
    
    //判断是否存在转发微博
    if(retWeet.user!=nil)
    {
        self.retWeetTextHeight = [self heightForString:retWeet.text andWidth:ScreenWidth andFont:12];
        self.retWeetPicHeight = 0;
    }
    else
    {
        self.retWeetTextHeight = 0;
        self.retWeetPicHeight = 0;
    }
    
    NSNumber *number2 = [NSNumber numberWithFloat:self.retWeetTextHeight];
    if (self.retWeetTextHeightArray == nil)
    {
        self.retWeetTextHeightArray  = [[NSMutableArray alloc]init];
    }
    [self.retWeetTextHeightArray addObject:number2];
    

    CGFloat height = self.textViewHeigth+self.retWeetTextHeight+self.picHeight+60+30;//60是头像往上，30是评论往下

    return CGSizeMake(ScreenWidth, height);
        
}
//cell被点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EPStatuses* status = self.allStatuses[indexPath.row];
    EPUser* user = self.allUsers[indexPath.row];
    status.users = user;
    if(status.isBrowsed==NO)
    {
        status.isBrowsed = YES;
        //设置浏览编号，方便交换位置
        status.browsingCount = [NSNumber numberWithUnsignedInteger:self.browsingHistoryStatuse.count];
        NSDictionary* statusDic = [EPStatuses dicWithModel:status];
        [self.browsingHistoryStatuse addObject:statusDic];
    }
    else
    {
        //交换浏览记录位置
        if([status.browsingCount integerValue] != self.browsingHistoryStatuse.count-1 )
        {
            [self.browsingHistoryStatuse exchangeObjectAtIndex:[status.browsingCount integerValue] withObjectAtIndex:self.browsingHistoryStatuse.count-1];
            
        }
        

    }
    
    [self writeToFileWithStatusArray:self.browsingHistoryStatuse AndFileName:@"browsingHistory.plist"];
    
    
}
#pragma mark -滑动刷新和加载
//检测滑动 用来下拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //------------2657.000000------3426.000000
    float refreshLine = scrollView.contentOffset.y+48+ScreenHeight/10;//ScreenHeight/10是超出屏幕上方的距离
    float loadMoreLine = scrollView.contentSize.height-scrollView.contentOffset.y-769-500;//500是距离屏幕下方的距离

    //回弹之后再将可刷新打开 并且在回弹之后再刷新
    if (refreshLine>0&&self.canRefresh==NO)
    {
        self.canRefresh = YES;
        [self refreshCell];
    }
    
    //下拉加载，拉一次只加载一次
    if(loadMoreLine<=0&&self.canLoadMore&&scrollView.contentSize.height>0)
    {
        self.canLoadMore = NO;
        [self loadMoreStatus];
    }
    //加载后将bool调回来
    if (loadMoreLine>0&&self.canLoadMore==NO&&refreshLine>0) {
        self.canLoadMore = YES;
    }
 
}
//停止拖拽再判定是否要刷新
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float refreshLine = scrollView.contentOffset.y+48+ScreenHeight/10;//ScreenHeight/10是超出屏幕上方的距离
    if (refreshLine<0&&self.canRefresh)
    {
        self.canRefresh = NO;
        
    }
    
}


#pragma mark -  字典数组转模型数组方法
- (NSArray*)statusArrayWithDictionaryArray: (NSArray*)dicArray
{
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    NSMutableArray* tempArray2 = [[NSMutableArray alloc]init];
    
    for (NSDictionary* status in dicArray)
    {
        [tempArray addObject: [EPStatuses statusWithDic:status]];
        [tempArray2 addObject: status[@"user"]];//把user单独抽出来组成一个字典数组
        self.users = [self userArrayWithDictionaryArray:tempArray2];//再字典数组转模型数组
        
    }
    return tempArray;
}

//作者字典数组转模型数组
- (NSArray*)userArrayWithDictionaryArray: (NSArray*)dicArray
{
        NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary* user in dicArray)
    {
        [tempArray addObject: [EPUser userWithDic:user]];
    }
    return tempArray;
}

- (NSArray*)picArrayWithDictionaryArray: (NSArray*)dicArray
{
    
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];

    for (NSDictionary* pic_url in dicArray)
    {
        NSString* urlStr = pic_url[@"thumbnail_pic"];
        [tempArray addObject: urlStr];
    }
    return tempArray;
}




#pragma mark - cell delegate
- (void)passUrlwith:(NSString*)str
{
    WebViewController* webController = [[WebViewController alloc]init];
    webController.str = str;
    
    [self.navigationController pushViewController:webController animated:YES];
}
//收藏按钮点击的实现
- (void)passBtnClick:(NSIndexPath *)indexPath
{
    
    EPStatuses* status = self.allStatuses[indexPath.row];//这种赋值是，地址传递。status改变，数组里面对应的数据也会改变
    EPUser* user = self.allUsers[indexPath.row];
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
        //如果不是删除最后一个，遍历数组，将NSNumber重新从小到大排列一遍
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
            for(EPStatuses* tempStatus in self.allStatuses)
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

#pragma mark - searchcontroller的delegat
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取搜索框中用户输入的字符串
       NSString *searchString = [self.searchController.searchBar text];
       //指定过滤条件
       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text CONTAINS %@ or users.screen_name CONTAINS %@", searchString,searchString];
       //如果搜索数组中存在对象，即上次搜索的结果，则清除这些对象
       if (self.searchListArray!= nil) {
           [self.searchListArray removeAllObjects];
       }
       //通过过滤条件过滤数据
       self.searchListArray= [NSMutableArray arrayWithArray:[self.allStatuses filteredArrayUsingPredicate:predicate]];
      if(self.searchListArray.count!=0||!self.searchController.active)
      {
          //刷新表格
          [self.collectionView reloadData];
      }
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




//设置富文本
-(void) setArrtibuteText
{
    NSString* str = @"测试测试ceshiceshi 用力测试";
    NSMutableAttributedString* attrbuteStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attrbuteStr addAttribute:NSFontAttributeName value:[ UIFont systemFontOfSize:15 ]range: NSMakeRange(4, 5)];
    
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


#pragma mark - 拿到本地对应的作者信息
- (void)getMyUsers
{
    self.myUsers = [[NSMutableArray alloc]init];
    NSMutableArray* mutArray = [self getDictionaryFromPlistWithFileName:@"mystatus.plist"];
    
    for(NSDictionary* dic in mutArray)
    {
        NSDictionary* userDic = dic[@"user"];
        EPUser* user = [EPUser userWithDic:userDic];
        [self.myUsers addObject: user];
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

#pragma  mark - 将数组写入本地的方法
- (void) writeToFileWithStatusArray:(NSMutableArray*)mutArray AndFileName:(NSString*)name
{
   NSArray* array = mutArray;
   NSString* docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//返回的是一个文件数组
NSString* filepath = [docpath stringByAppendingPathComponent:name];
   [array writeToFile:filepath atomically:YES];
}


#pragma mark - 刷新方法

- (void) refreshCell
{
    [self.allStatuses removeAllObjects];
    [self.allUsers removeAllObjects];
    [self.textViewHeigthArray removeAllObjects];
    [self.retWeetTextHeightArray removeAllObjects];
    [self.picHeightArray removeAllObjects];
    //重新获取本地数据
    self.myStatuses = [self getModelFromPlistWithFileName:@"mystatus.plist"];
    self.myStatuses = (NSMutableArray*)[[self.myStatuses reverseObjectEnumerator]allObjects];//倒一下排序，让更迟的在上面
    [self getMyUsers];
    self.myUsers = (NSMutableArray*)[[self.myUsers reverseObjectEnumerator]allObjects];
    [self loadNewStatuses];
}

//下拉加载更多
- (void) loadMoreStatus
{
    //去除原本的高度数据
    [self.textViewHeigthArray removeAllObjects];
    [self.retWeetTextHeightArray removeAllObjects];
    [self.picHeightArray removeAllObjects];
    
    //创建AFN管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置url
    NSString* baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"access_token"] = @"2.002bZvfG76EftBc8b45ca675cadPOB";
    [manager GET:baseURL parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray* dicArray = responseObject[@"statuses"];
            //将字典数组转化为模型数组
            self.statuses=[self statusArrayWithDictionaryArray:dicArray];
        
            //将原本的微博和新的网络数据拼接起来
            [self.allStatuses addObjectsFromArray:self.statuses];
            //将作者拼起来
            [self.allUsers addObjectsFromArray:self.users];
            NSInteger i =0;
            for(EPStatuses* status in self.allStatuses)
            {
                status.users = self.allUsers[i];
                i++;
            }
            //在主线程中做信息更新，不然会报错。
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误原因如下：%@",error);
        }];
    
            
}




@end

