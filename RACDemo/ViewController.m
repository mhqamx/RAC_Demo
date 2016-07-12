//
//  ViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/12.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) RACCommand  *commandDelete;
@property (nonatomic, strong) UIButton  *deleteButton;
@property (nonatomic, strong) UIButton  *loginButton;
@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;

@end

@implementation ViewController

#pragma mark - lazyInitilzation
- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 250, 100, 30)];
        _usernameTextField.placeholder = @"username";
        _usernameTextField.backgroundColor = [UIColor redColor];
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
        _passwordTextField.placeholder = @"pw";
        _passwordTextField.backgroundColor = [UIColor blackColor];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
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
    
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
    self.deleteButton.backgroundColor = [UIColor redColor];
    [self.deleteButton setTitle:@"RAC_Button" forState:(UIControlStateNormal)];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.deleteButton];
    
    /**
                                                使用RAC
     */
    
//------------------------------------------ TARGET-ACTION -----------------------------------------------//
    /**
     RAC下的button点击事件
     */
    self.deleteButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:self.commandDelete];
    }];
    
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    
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
    // 另一方面控制台输出了conpleted说明订阅信号部分的completed块下的方法也被执行了, 这是因为在创建signal后又发送了一个colpleted, 同理, error下的方法我们也可以这样调用
    
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

#pragma mark - UIAlterView - Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

@end
