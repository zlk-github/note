

名词说明：
堆内存泄露：堆剩余内存不够对对象需要的内存，OutOfMemorError（OOM）
栈溢出：方法调用深度大于栈的最大深度。StackOverflowError(SOE)

**类加载**
虚拟机把描述类的数据从Class文件加载到内存。并对数据进行校验、转换解析和初始化，最终形成可以被虚拟机直接使用的Java类型，这就是虚拟机的类加载机制。其中类型加载、连接、初始化都在程序运行期间完成（增加了部分开销，但是增加了灵活性）。

**CAS**

	Compare and Swap，即比较再交换。jdk5增加了并发包java.util.concurrent.*,（如AtomicInteger.getAndIncrement()是原子操作）其下面的类使用CAS算法实现了区别于synchronouse同步锁的一种乐观锁。JDK 5之前Java语言是靠synchronized关键字保证同步的，这是一种独占锁，也是是悲观锁。

	CAS算法理解
	对CAS的理解，CAS是一种无锁算法，CAS有3个操作数，内存值V，旧的预期值A，要修改的新值B。当且仅当预期值A和内存值V相同时，将内存值V修改为B，否则什么都不做（实际失败涉及到重试）。

**复制算法原理** 

	Survivor区，一块叫From，一块叫To，对象存在Eden和From块。当进行GC时，Eden存活的对象全移到To块，而From中，存活的对象按年龄值确定去向，当达到一定值（年龄阈值，通过-XX:MaxTenuringThreshold可设置）的对象会移到年老代中，没有达到值的复制到To区，经过GC后，Eden和From被清空。
	  之后，From和To交换角色，新的From即为原来的To块，新的To块即为原来的From块，且新的To块中对象年龄加1。
![Alt text](./images/20200516001.PNG)