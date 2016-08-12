//
//  MXMethodsViewController.m
//  RACDemo
//
//  Created by YISHANG on 16/7/29.
//  Copyright © 2016年 MAXIAO. All rights reserved.
//

#import "MXMethodsViewController.h"
#import <ReactiveCocoa.h>
@interface MXMethodsViewController ()

@end

@implementation MXMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RAC常用方法合集";
}

- (void)content {
    /**
     *  常见类
     */
    // 1.RACsignal类
    
    // RACEmptySignal ：空信号，用来实现 RACSignal 的 +empty 方法；
    // RACReturnSignal ：一元信号，用来实现 RACSignal 的 +return: 方法；
    // RACDynamicSignal ：动态信号，使用一个 block - 来实现订阅行为，我们在使用 RACSignal 的 +createSignal: 方法时创建的就是该类的实例；
    // RACErrorSignal ：错误信号，用来实现 RACSignal 的 +error: 方法；
    // RACChannelTerminal ：通道终端，代表 RACChannel 的一个终端，用来实现双向绑定。
    
    // 2.RACSubscriber 订阅者
    
    // 3.RACDisposable 用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
    
    // RACSerialDisposable ：作为 disposable 的容器使用，可以包含一个 disposable 对象，并且允许将这个 disposable 对象通过原子操作交换出来；
    // RACKVOTrampoline ：代表一次 KVO 观察，并且可以用来停止观察；
    // RACCompoundDisposable ：它可以包含多个 disposable 对象，并且支持手动添加和移除 disposable 对象
    // RACScopedDisposable ：当它被 dealloc 的时候调用本身的 -dispose 方法。
    
    // 4、RACSubject 信号提供者，自己可以充当信号，又能发送信号。
    
    // RACGroupedSignal ：分组信号，用来实现 RACSignal 的分组功能；
    // RACBehaviorSubject ：重演最后值的信号，当被订阅时，会向订阅者发送它最后接收到的值；
    // RACReplaySubject ：重演信号，保存发送过的值，当被订阅时，会向订阅者重新发送这些值。
    
    // 5、RACTuple 元组类,类似NSArray,用来包装值.
    
    // 6、RACSequence RAC中的集合类
    
    // 7、RACCommand RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
    
    // 8、RACMulticastConnection 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
    
    // 9、RACScheduler RAC中的队列，用GCD封装的
    
    // RACImmediateScheduler ：立即执行调度的任务，这是唯一一个支持同步执行的调度器；
    // RACQueueScheduler ：一个抽象的队列调度器，在一个 GCD 串行列队中异步调度所有任务；
    // RACTargetQueueScheduler ：继承自 RACQueueScheduler ，在一个以一个任意的 GCD 队列为 target 的串行队列中异步调度所有任务；
    // RACSubscriptionScheduler ：一个只用来调度订阅的调度器。
    
    /**
     *  常见用法
     */
    // rac_signalForSelector : 代替代理
    // rac_valuesAndChangesForKeyPath: KVO
    // rac_signalForControlEvents:监听事件
    // rac_addObserverForName 代替通知
    // rac_textSignal：监听文本框文字改变
    // rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
    
    /**
     *  常见宏
     */
    // RAC(TARGET, [KEYPATH, [NIL_VALUE]])：用于给某个对象的某个属性绑定
    // RACObserve(self, name) ：监听某个对象的某个属性,返回的是信号。
    // @weakify(Obj)和@strongify(Obj)
    // RACTuplePack ：把数据包装成RACTuple（元组类）
    // RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
    // RACChannelTo 用于双向绑定的一个终端
    
    /**
     *  常用操作方法
     */
    // flattenMap map 用于把源信号内容映射成新的内容。
    // concat 组合 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
    // then 用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
    // merge 把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    // zipWith 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
    // combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
    // reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
    // filter:过滤信号，使用它可以获取满足条件的信号.
    // ignore:忽略完某些值的信号.
    // distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
    // take:从开始一共取N次的信号
    // takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
    // takeUntil:(RACSignal *):获取信号直到某个信号执行完成
    // skip:(NSUInteger):跳过几个信号,不接受。
    // switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    // doNext: 执行Next之前，会先执行这个Block
    // doCompleted: 执行sendCompleted之前，会先执行这个Block
    // timeout：超时，可以让一个信号在一定的时间后，自动报错。
    // interval 定时：每隔一段时间发出信号
    // delay 延迟发送next。
    // retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    // replay重放：当一个信号被多次订阅,反复播放内容
    // throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
    
    /**
     *  UI-Category(常用汇总)
     */
    // 1、rac_prepareForReuseSignal： 需要复用时用
    // 相关UI: MKAnnotationView、UICollectionReusableView、UITableViewCell、UITableViewHeaderFooterView
    
    // 2、rac_buttonClickedSignal：点击事件触发信号
    // 相关UI：UIActionSheet、UIAlertView
    
    // 3、rac_command：button类、刷新类相关命令替换
    // 相关UI：UIBarButtonItem、UIButton、UIRefreshControl
    
    // 4、rac_signalForControlEvents: control event 触发
    // 相关UI：UIControl

    // 5、rac_gestureSignal UIGestureRecognizer 事件处理信号
    // 相关UI：UIGestureRecognizer
    
    // 6、rac_imageSelectedSignal 选择图片的信号
    // 相关UI：UIImagePickerController
    
    // 7、rac_textSignal
    // 相关UI：UITextField、UITextView
    
    // 8、可实现双向绑定的相关API
    // rac_channelForControlEvents: key: nilValue:
    // 相关UI：UIControl类
    
    // rac_newDateChannelWithNilValue
    // 相关UI：UIDatePicker
    
    // rac_newSelectedSegmentIndexChannelWithNilValue:
    // 相关UI：UISegmentedControl
    
    // rac_newValueChannelWithNilValue:
    // 相关UI：UISlider、UIStepper
    
    // rac_newOnChannel
    // 相关UI：UISwitch
    
    // rac_newTextChannel
    // 相关UI：UITextField
    
    /**
     *  Foundation - Category （常用汇总）
     */
    // 1、NSArray
    // rac_sequence 信号集合
    
    // 2、NSData
    // rac_readContentsOfURL: options: scheduler: 比oc多出线程设置
    
    // 3、NSDictionary
    // rac_sequence 不解释
    // rac_keySequence key 集合
    // rac_valueSequence value 集合
    
    // 4、NSEnumerator
    // rac_sequence 不解释
    
    // 5、NSFileHandle
    // rac_readInBackground 见名知意

    // 6、NSIndexSet
    // rac_sequence 不解释
    
    // 7、NSInvocation
    // rac_setArgument: atIndex: 设置参数
    // rac_argumentAtIndex 取某个参数
    // rac_returnValue 所关联方法的返回值
    
    // 8、NSNotificationCenter
    // rac_addObserverForName: object:注册通知
    
    // 9、NSObject
    // rac_willDeallocSignal 对象销毁时发动的信号
    // rac_description debug用
    // rac_observeKeyPath: options: observer: block:监听某个事件
    // rac_liftSelector: withSignals: 全部信号都next在执行
    // rac_signalForSelector: 代替某个方法
    // rac_signalForSelector:(SEL)selector fromProtocol:代替代理
    
    // 10、NSOrderedSet
    // rac_sequence 不解释
    
    // 11、NSSet
    // rac_sequence 不解释
    
    // 12、NSString
    // rac_keyPathComponents 获取一个路径所有的部分
    // rac_keyPathByDeletingLastKeyPathComponent 删除路径最后一部分
    // rac_keyPathByDeletingFirstKeyPathComponent 删除路径第一部分
    // rac_sequence 不解释 (character)
    // rac_readContentsOfURL: usedEncoding: scheduler: 比之OC多线程调用
    
    // 13、NSURLConnection
    // rac_sendAsynchronousRequest 发起异步请求
    
    // 14、NSUserDefaults
    // rac_channelTerminalForKey 用于双向绑定，此乃
    
    // 15. 待续
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
