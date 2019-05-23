## 线程池

### 1 ThreadPoolExecutor

**1.1 介绍**

ThreadPoolExecutor继承了AbstractExecutorService类，并提供了四个构造器，前三个基于第四个实现。

参数：核心线程数，最大线程数，线程空闲时间，空闲时间的单位，阻塞队列（核心线程满时，任务进队列），线程工厂，拒绝策略。

	public class ThreadPoolExecutor extends AbstractExecutorService {
	    .....
	    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
	            BlockingQueue<Runnable> workQueue);
	 
	    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
	            BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory);
	 
	    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
	            BlockingQueue<Runnable> workQueue,RejectedExecutionHandler handler);
	 
	    public ThreadPoolExecutor(int corePoolSize,int maximumPoolSize,long keepAliveTime,TimeUnit unit,
	        BlockingQueue<Runnable> workQueue,ThreadFactory threadFactory,RejectedExecutionHandler handler);
	    ...
	}

**corePoolSize**：核心线程池大小，创建线程池时，线程池默认没有线程，当任务来时才会创建线程。除非调用了prestartAllCoreThreads()或者prestartCoreThread()方法，从这2个方法的名字就可以看出，是预创建线程的意思，即在没有任务到来之前就创建corePoolSize个线程或者一个线程。默认情况下，在创建了线程池后，线程池中的线程数为0，当有任务来之后，就会创建一个线程去执行任务，当线程池中的线程数目**达到corePoolSize后，就会把到达的任务放到缓存队列当中**；

**maximumPoolSize**：线程池最大线程数，线程池能创建的最大线程数。

**keepAliveTime**：线程空闲时间，表示线程没有任务执行时最多保持多久时间会终止。默认情况下，只有当线程池中的线程数大于corePoolSize时，keepAliveTime才会起作用，直到线程池中的线程数不大于corePoolSize，即当线程池中的线程数大于corePoolSize时，如果一个线程空闲的时间达到keepAliveTime，则会终止，直到线程池中的线程数不超过corePoolSize。但是如果调用了allowCoreThreadTimeOut(boolean)方法，在线程池中的线程数不大于corePoolSize时，keepAliveTime参数也会起作用，直到线程池中的线程数为0；

**unit**：参数keepAliveTime的时间单位，有7种取值，在TimeUnit类中有7种静态属性：
	
	TimeUnit.DAYS;               //天
	TimeUnit.HOURS;             //小时
	TimeUnit.MINUTES;           //分钟
	TimeUnit.SECONDS;           //秒
	TimeUnit.MILLISECONDS;      //毫秒
	TimeUnit.MICROSECONDS;      //微妙
	TimeUnit.NANOSECONDS;       //纳秒

**workQueue**：一个阻塞队列，用来存储等待执行的任务。

	ArrayBlockingQueue;
	LinkedBlockingQueue;
	SynchronousQueue;

ArrayBlockingQueue和PriorityBlockingQueue使用较少，一般使用LinkedBlockingQueue和Synchronous。线程池的排队策略与BlockingQueue有关。

**threadFactory**：线程工厂，主要用来创建线程；

**handler**：表示当拒绝处理任务时的策略，有以下四种取值：

	ThreadPoolExecutor.AbortPolicy:丢弃任务并抛出RejectedExecutionException异常。 
	ThreadPoolExecutor.DiscardPolicy：也是丢弃任务，但是不抛出异常。 
	ThreadPoolExecutor.DiscardOldestPolicy：丢弃队列最前面的任务，然后重新尝试执行任务（重复此过程）
	ThreadPoolExecutor.CallerRunsPolicy：由调用线程处理该任务 

ThreadPoolExecutor、AbstractExecutorService、ExecutorService和Executor

在ThreadPoolExecutor类中有几个非常重要的方法：

	execute()
	submit()
	shutdown()
	shutdownNow()

 　　**execute()**方法实际上是Executor中声明的方法，在ThreadPoolExecutor进行了具体的实现，这个方法是ThreadPoolExecutor的核心方法，通过这个方法可以向线程池提交一个任务，交由线程池去执行。

　　**submit()**方法是在ExecutorService中声明的方法，在AbstractExecutorService就已经有了具体的实现，在ThreadPoolExecutor中并没有对其进行重写，这个方法也是用来向线程池提交任务的，但是它和execute()方法不同，它能够**返回任务执行的结果**，去看submit()方法的实现，会发现它实际上还是调用的execute()方法，只不过它利用了Future来获取任务执行结果（Future相关内容将在下一篇讲述）。

　　**shutdown()和shutdownNow()**是用来关闭线程池的。

　　还有很多其他的方法：

　　比如：getQueue() 、getPoolSize() 、getActiveCount()、getCompletedTaskCount()等获取与线程池相关属性的方法，有兴趣的朋友可以自行查阅API。
..........

**创建流程**

如果当前线程池中的线程数目小于corePoolSize，则每来一个任务，就会创建一个线程去执行这个任务；

如果当前线程池中的线程数目>=corePoolSize，则每来一个任务，会尝试将其添加到任务缓存队列当中，若添加成功，则该任务会等待空闲线程将其取出去执行；若添加失败（一般来说是任务缓存队列已满），则会尝试创建新的线程去执行这个任务；

如果当前线程池中的线程数目达到maximumPoolSize，则会采取任务拒绝策略进行处理；

如果线程池中的线程数量大于 corePoolSize时，如果某线程空闲时间超过keepAliveTime，线程将被终止，直至线程池中的线程数目不大于corePoolSize；如果允许为核心池中的线程设置存活时间，那么核心池中的线程空闲时间超过keepAliveTime，线程也会被终止。


**线程池的监控**

	通过线程池提供的参数进行监控。线程池里有一些属性在监控线程池的时候可以使用
	
	taskCount：线程池需要执行的任务数量。
	completedTaskCount：线程池在运行过程中已完成的任务数量。小于或等于taskCount。
	largestPoolSize：线程池曾经创建过的最大线程数量。通过这个数据可以知道线程池是否满过。如等于线程池的最大大小，则表示线程池曾经满了。
	getPoolSize:线程池的线程数量。如果线程池不销毁的话，池里的线程不会自动销毁，所以这个大小只增不减。
	getActiveCount：获取活动的线程数。

查看：https://www.cnblogs.com/dolphin0520/p/3932921.html