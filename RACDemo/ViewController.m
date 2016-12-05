//
//  ViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/12.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "ViewController.h"
#import "MXMainViewController.h"
#import <ReactiveCocoa.h>
@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) RACCommand  *commandDelete;
@property (nonatomic, strong) UIButton  *deleteButton;
@property (nonatomic, strong) UIButton  *loginButton;
@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton  *button;


@end

@implementation ViewController

#pragma mark - lazyInitilzation
- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 250, 100, 30)];
        _usernameTextField.placeholder = @"username";
        _usernameTextField.backgroundColor = [UIColor redColor];
        _usernameTextField.textColor = [UIColor whiteColor];
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
        _passwordTextField.placeholder = @"pw";
        _passwordTextField.backgroundColor = [UIColor blackColor];
        _passwordTextField.textColor = [UIColor whiteColor];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 100, 30)];
        [_loginButton setTitle:@"login" forState:(UIControlStateNormal)];
        _loginButton.backgroundColor = [UIColor orangeColor];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_loginButton addTarget:self action:@selector(buttonOnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginButton;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 30)];
        _button.backgroundColor = [UIColor cyanColor];
        [_button setTitle:@"push" forState:(UIControlStateNormal)];
        [_button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _button;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    
    [self RACWithDelegate];
    
    [self RACWithNotification];
    
    [self RACWithKVO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *dataArr = @[@"1", @"2", @"3"].mutableCopy;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:dataArr];
}

#pragma mark - private methods
- (void)configUI {
    /**
     原生的方法 target-action
    */
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    [myButton addTarget:self action:@selector(myAction) forControlEvents:(UIControlEventTouchUpInside)];
    myButton.backgroundColor = [UIColor blackColor];
    [myButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [myButton setTitle:@"native_Button" forState:(UIControlStateNormal)];
    [self.view addSubview:myButton];
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 200, 100, 30)];
    self.deleteButton.backgroundColor = [UIColor redColor];
    [self.deleteButton setTitle:@"RAC_Button" forState:(UIControlStateNormal)];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.deleteButton];
    
    
    
    /**
     *  RAC中button的点击事件响应
     *  rac_signalForControlEvents 内部方法:
     
         - (RACSignal *)rac_signalForControlEvents:(UIControlEvents)controlEvents {
         @weakify(self);
         
         return [[RACSignal
         createSignal:^(id<RACSubscriber> subscriber) {
         @strongify(self);
         
         [self addTarget:subscriber action:@selector(sendNext:) forControlEvents:controlEvents];
         [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
         [subscriber sendCompleted];
         }]];
         
         return [RACDisposable disposableWithBlock:^{
         @strongify(self);
         [self removeTarget:subscriber action:@selector(sendNext:) forControlEvents:controlEvents];
         }];
         }]
         setNameWithFormat:@"%@ -rac_signalForControlEvents: %lx", self.rac_description, (unsigned long)controlEvents];
         }

     可见, rac_方法在内部创建了一个signal信号来响应button的点击事件, 并且还一并创建了dealloc方法
     rac_这类方法好像可以响应一些系统自带的控件状态变化的macro, 用这个方法可以控制集成UIControl的部分控件
     
     */
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        NSLog(@"button ---- %@", [x class]);
        [self.navigationController pushViewController:[MXMainViewController new] animated:YES];
    }];
    
    /**
                                                使用RAC
     */
    
//------------------------------------------ TARGET-ACTION -----------------------------------------------//
    
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.button];
    
    /**
     RAC下的button点击事件
     */
    self.deleteButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"RAC --- Action");
        return [RACSignal return:self.commandDelete];
    }];
    

    
    /**
     *  RAC下监听textfield的状态, 这个效果可以用来输入密码之后自动登录
     *
     *  @param self.loginButton 登录按钮
     *  @param combineLatest    信号联合
     *  @param enabled          RAC(self.logInButton, enabled)接受返回值, 判断当前按钮是否可以被点击
     *  @param reduce           判断当前的输入是否合法
     */
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal,
                                                                self.passwordTextField.rac_textSignal]
                                                       reduce:^(NSString *username, NSString *password){
                                                           NSLog(@"username - %@, password -- %@", username, password);
                                                                    return @(username.length > 0 && password.length > 0);
                                                                }];
    /**
     *  类似Native中的KVO, 直接监听UITextField状态的改变
     *
     *  @param UIControlEventEditingChanged UITextField提供的marco
     *  @param subscribeNext  从字面来理解就是监听之后的再描述 RAC的命名非常能让人理解方法的用意
     */
    [[self.usernameTextField rac_signalForControlEvents:(UIControlEventEditingChanged)] subscribeNext:^(id x) {
        NSLog(@"%@", self.usernameTextField.text);
    }];
    
    /**
     *  也是监听TextField的一种方法 直接用rac_textSignal来代替了rac_signalForControlEvents:(UIControlEventEditingChanged)
     *
     *  @param x 填入TextField的参数
     *
     */
    [[self.passwordTextField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"x ------ %@", x);
    }];
    
    
    /**
     RAC 将UIKit中的对象都加了一层封装 使得所有的UIKit控件都有相应的RAC相应方法
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"tap ---- %@", x);
    }];
    [self.view addGestureRecognizer:tap];
    
    
    
    
    /* UITextView+RACSignalSupport
     * param defer RACSingal的一个类方法, 返回的一个延迟信号.如果不被订阅就是冷信号, 订阅责成热信号
     * param concat contact连接的是UITextField的UIControlEventAllEditingEvents信号
     * param map 把当前信号映射成x.text
     * param takeUntil 看名字大概能看懂, 就是在某个时间之前一直获取当前信号
     * param rac_willDeallocSingal 意思就是在UITextField销毁之前一直获取当前输入信号
    - (RACSignal *)rac_textSignal {
        @weakify(self);
        RACSignal *signal = [[[[[RACSignal
                                 defer:^{
                                     @strongify(self);
                                     return [RACSignal return:RACTuplePack(self)];
                                 }]
                                concat:[self.rac_delegateProxy signalForSelector:@selector(textViewDidChange:)]]
                               reduceEach:^(UITextView *x) {
                                   return x.text;
                               }]
                              takeUntil:self.rac_willDeallocSignal]
                             setNameWithFormat:@"%@ -rac_textSignal", self.rac_description];
        
        RACUseDelegateProxy(self);
        
        return signal;
    }
     */
    
    // 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signal"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@" x === %@", x);
    } error:^(NSError *error) {
        NSLog(@"error === %@", error);
    } completed:^{
        NSLog(@"complete");
    }];
    // 可以看到, 创建信号时我们sent了一个signal, 在我们订阅subscribeNext时储存在x中的就是这个字符串signal.从这里看出来, 不但我们可以给订阅者传递字符串, 只要是一个类一个对象我们都可以传递
    // 另一方面控制台输出了completed说明订阅信号部分的completed块下的方法也被执行了, 这是因为在创建signal后又发送了一个comlpleted, 同理, error下的方法我们也可以这样调用
    
    /**
     *  信号的处理
     */
    // 1.map 映射, 创建一个订阅者的映射并且返回数据
    [[self.usernameTextField.rac_textSignal map:^id(id value) {
        NSLog(@"value --- %@", value);
        return @1;
    }] subscribeNext:^(id x) {
        NSLog(@"x === %@", x);
    }];
    // 还是监听textfield的状态变化, 可以看到当信号被订阅变成热信号后, 这里的map构造的映射块value就是textfield控件中的字符串变化, 但是订阅者X的值就是映射者的返回值1
    // 根据这个功能我们就可以对我们监测的东西和我们需要的东西进行转换, 比如监听了字符串变化, 我们需要的时间变化后的字符串长度而不是字符串变化本身, 则可以在map的返回值中返回text.length, 就可以实现捕获到的字符串长度, 甚至做一个映射表, 将各个变化进行一对一或者一对多的处理
    
    // 2.filter
    // filter就是过滤, 它可以筛选出需要的信号变化
    [[self.passwordTextField.rac_textSignal filter:^BOOL(NSString *value) {
        return [value length] > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
    }];
    // 过滤 当self.password的字符串长度大于三是它的过滤条件, 达到过滤条件再执行subscribeNext块中的语法
    
    // 3.take/skip/repeat
    // take是获取, skip是跳过, 这两个方法后面跟着的都是NSInteger, 所以take:2就是获取前两个信号, skip:2就是跳过前两个, repeat是重复发送信号
    RACSignal *signal2 = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendNext:@"4"];
        [subscriber sendNext:@"5"];
        [subscriber sendCompleted];
        return nil;
    }] take:2];
    
    [signal2 subscribeNext:^(id x) {
        NSLog(@"signal2 ---- %@", x);
    } completed:^{
        NSLog(@"completed");
    }];
    // 这个demo只会输出前两个信号1和2还有完成信号completed, skip, repeat同理
    // 相似的还有takeLast, takeUntil, takeWhileBlock, skipWillBlock, skipUntilBlock, repeatWhileBlock 都可以根据字面意思来理解
    
    // 4.delay
    // 延时信号, 顾名思义, 既是延迟发送信号
    
    RACSignal *delaySingal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"dalay"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2];
    
    NSLog(@"tag");
    
    [delaySingal subscribeNext:^(id x) {
        NSLog(@"delaySingal == %@", x);
    }];
    //2016-07-13 10:27:00.693 RACDemo[3129:309439] tag
    //2016-07-13 10:27:02.886 RACDemo[3129:309439] delaySingal == dalay
    
    // 看时间可以发现订阅的信号延时2秒之后才收到信号打印出X的值, 还有0.1秒的误差是因为运行到不同代码的时间差
    
    // 5.throttle
    // 节流, 在我们做搜索框的时候, 有时候需求的实时搜索, 即用户每输入字符, view都需求展现搜索结果, 这时如果用户搜索的字符串较长, 那么由于网络请求的延时可能造成UI显示错误, 并且多次不必要的请求还会加大服务器的压力, 这显然是不合理的, 此时我们就需要用到节流
    [[[self.usernameTextField rac_textSignal] throttle:0.5] subscribeNext:^(id x) {
        NSLog(@"throttle --- %@", x);
    }];
    // 加了节流管道, 后面跟上了类型为NSTimeInterval的参数后, 只有0.5s内信号不产生变化才会发送请求, 这样快速的输入也不会造成多次输出
    
    // 6.distinctUntilChanged
    // 网络请求中为了减轻服务器压力, 无用的请求我们应该尽可能不发送, distinctUntilChanged的作用是使RAC不会连续发送两次相同的信号, 这样就解决了这个问题
    [[[self.passwordTextField rac_textSignal] distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChangde --- %@", x);
    }];
    
    // 7.timeout
    // 超时信号, 当超时限定时间后会给订阅者发送error信号
    
    RACSignal *timeoutSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"dalay"];
            [subscriber sendCompleted];
        }];
        return nil;
    }] timeout:2 onScheduler:[RACScheduler mainThreadScheduler]];
    
    [timeoutSignal subscribeNext:^(id x) {
        NSLog(@"timeoutSignal --- %@", x);
    } error:^(NSError *error) {
        NSLog(@"error ---- %@", error);
    }];
    // 延时信号的衍生 在RAC的主线程里注册一个信号, 延时3秒钟, 但是加了timeout:2秒的限定, 所以内部主线程的信号是一个超时信号, 这个信号被订阅后由于超时, 不会执行订阅成功的输出X方法, 而是跳到error的快输出了错误信息, timeout再用RAC封装网络请求的同时可以节省不少的代码量
    
    // 8.ignore
    // 忽略信号 制定一个任意类型的两, 当需要发送信号是将进行判断, 若相同该信号会被忽略发送
    [[[self.passwordTextField rac_textSignal] ignore:@"good"] subscribeNext:^(NSString *value) {
        NSLog(@"ignore --- %@", value);
    }];
    
    
}

//------------------------------------------ DELEGATE -----------------------------------------------//
- (void)RACWithDelegate {
    /**
     * RAC中监听UIKit中控件的delegate
     * @selector是指这次事件监听的方法fromprotool指里来的代理, 这里block中有一个RACTuple, 它相当于一个集合类, 他下面的first, second third就等于个各类的参数, 我这里点击了AlterView的第一个按钮输出如下
     
2016-07-12 14:37:50.497 RACDemo[6616:907061] first --- <UIAlertView: 0x7fdc81426c80; frame = (0 0; 0 0); layer = <CALayer: 0x7fdc8142fab0>>
2016-07-12 14:37:50.497 RACDemo[6616:907061] second --- 0
2016-07-12 14:37:50.497 RACDemo[6616:907061] third --- (null)
     
     可以看出来tuple的second参数就是点击的button的序号, 那么对于多个按钮就可以通过switch来给各个button添加方法, 这样的代码看起来更容易理解, 后期也更好维护
     */
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"RAC-TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        NSLog(@"first --- %@", tuple.first);
        NSLog(@"second --- %@", tuple.second);
        NSLog(@"third --- %@", tuple.third);
    }];
    
    // alter代理简化
    // 这里的^(id x)直接就是点击button的index
    [[alterView rac_buttonClickedSignal] subscribeNext:^(id x) {
        NSLog(@"rac_buttonClickedSignal ----- %@", x);
    }];
    
    [alterView show];
}

//------------------------------------------ NOTIFICATION -----------------------------------------------//
- (void)RACWithNotification {

    /**
     *  利用RAC来拿到通知中心传递的参数
     *  可见, notification.object就是我们想要得到的数组, 当然我们也可以传一些model, 值得一提的是, RAC中的通知不需要 remove obbsever, 因为在rac_add方法中已经写好了remove
     */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil] subscribeNext:^(NSNotification *notification) {
        NSLog(@"name --- %@", notification.name);
        NSLog(@"object --- %@", notification.object);
    }];
}

//------------------------------------------ KVO -----------------------------------------------//
- (void)RACWithKVO {
    /**
     *  RAC中的KVO大部分都是宏定义, 所以代码异常简洁, 简单来说就是RACObserve(TARGET, KEYPATH)这种形式, TARGET是监听目标, KEYPATH的要观察的属性值, 这里举一个很简单的例子, 如果UIScrollView滚动则输出success
     */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 200, 150)];
    scrollView.contentSize = CGSizeMake(200, 300);
    scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    [RACObserve(scrollView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


#pragma mark - response methods
- (void)myAction {
    NSLog(@"%s", __func__);
}

- (void)buttonOnClick {
    NSLog(@"%s", __func__);
}

- (RACCommand *)commandDelete {
    NSLog(@"%s",__func__);
    if (!_commandDelete) {
        _commandDelete = self.deleteButton.rac_command;
    }
    return _commandDelete;
}

#pragma mark ------- 2016.9.13
// 就要过中秋节了 祝大家都和家人团团圆圆 中秋快乐 吃月饼 螃蟹啦

#pragma mark - dev分支创建

#pragma mark - 测试branch分支 --- 9:31
// 测试一下git分支

#pragma mark - 测试分支的合并 --- 10:59

@end
