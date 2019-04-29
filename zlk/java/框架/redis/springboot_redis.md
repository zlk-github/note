## Spring Boot2.0 整合 Redis做缓存

### 介绍

在实际开发中，对一些**访问量大，数据变化小**的数据。如果让其每次都查询数据库，会造成数据库连接资源的占用。甚至导致系统的性能问题。很多时候这种问题将采用缓存来解决。将查询出来的结果缓存起来，当访问接口时查询缓存中是否存在数据，存在则直接从缓存去。不存在再去数据库取数据，以减少数据库的查询次数。

使用缓存主要为三方面的问题：

	（1）怎么将数据存到缓存并取出来。
	（2）数据改变时怎么将缓存数据同步更新。
	（3）清空缓存。

下面围绕以上两个问题，使用Spring Boot集成Redis做数据缓存。以“**Spring Boot 2.0整合mybatis**”中的代码进行改造.(https://mp.csdn.net/postedit/89519031)

### 1 项目搭建

**1.1** pom.xml

pom中引入spring-boot-starter-redis

	<spring-boot-starter-redis-version>1.4.3.RELEASE</spring-boot-starter-redis-version>

	<!-- Spring Boot Reids 依赖 -->
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-redis</artifactId>
		<version>${spring-boot-starter-redis-version}</version>
	</dependency>


**1.2** application.yml

加入redis的配置。
	
	################ Redis 配置################
	redis:
	   ## Redis数据库索引（默认为0）
	  database: 0
	  ## Redis服务器地址
	  host: 127.0.0.1
	  ## Redis服务器连接端口
	  port: 6379
	  ## Redis服务器连接密码（默认为空）
	  password:
	  ## 连接池最大连接数（使用负值表示没有限制）
	  pool:
	    max-active: 8
	    ## 连接池最大阻塞等待时间（使用负值表示没有限制）
	    max-wait: -1
	    ## 连接池中的最大空闲连接
	    max-idle: 8
	    ## 连接池中的最小空闲连接
	    min-idle: 0
	  ## 连接超时时间（毫秒）
	  timeout: 0
	  #以下两项正式环境需要
	  #哨兵监听redis server名称
	#  sentinel:
	#     master: mymaster
	  #哨兵的配置列表
	#  sentinel:
	#    nodes: host:port,host2:port2
	
	

**1.3** 启动类

启动类上加@EnableCaching类启动缓存，否则缓存直解无效。如果有自定义的缓存配置类，使用@Import引入。该处RedisConfig配置类主要解决缓存数据在Redis的乱码问题。

	@SpringBootApplication
	//@ImportResource(locations = "classpath*:/*.sql")，此处不需要。
	@Import(RedisConfig.class)
	@EnableCaching
	public class DemoApplication {
	
		public static void main(String[] args) {
			SpringApplication.run(DemoApplication.class, args);
		}
	}

**1.4** Redis配置类

此处RedisConfig配置类主要解决缓存数据在Redis的乱码问题。

	@Configuration
	public class RedisConfig<T> {
	
	    @Bean
	    JedisConnectionFactory jedisConnectionFactory() {
	        return new JedisConnectionFactory();
	    }
	
	    @Bean
	    public RedisTemplate<String, T> redisTemplate(RedisConnectionFactory factory) {
	
	        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
	        ObjectMapper om = new ObjectMapper();
	        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
	        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
	        jackson2JsonRedisSerializer.setObjectMapper(om);
	
	        RedisTemplate<String,T> template = new RedisTemplate<>();
	        template.setConnectionFactory(jedisConnectionFactory());
	        //序列化key
	        template.setKeySerializer(new StringRedisSerializer());
	        //序列化value
	        template.setValueSerializer(jackson2JsonRedisSerializer);
	        //value hashmap序列化
	        template.setHashValueSerializer(jackson2JsonRedisSerializer);
	        return template;
	    }
	}

### 2 Service层改造

value值指定缓存到那片cache,key是缓存的键。（**数据在Redis的键，对应value+key的组合**），同时使用value和key才能精准定位到数据。

	@Service
	//@CacheConfig(cacheNames = "baseUser")
	public class BaseUserService {
	
	    private Logger logger = Logger.getLogger(getClass());
	
	    @Autowired
	    private BaseUserMapper baseUserMapper;
	    /**
	     * 查询用户信息列表
	     * @param baseUser 查询条件
	     * @return 用户信息列表
	     */
	    @Cacheable( value = "baseUser",key = "'#p0'")
	    public  List<BaseUser> queryUserList(BaseUser baseUser){
	        logger.info("查询数据库数据：");
	        return baseUserMapper.queryUserList(baseUser);
	    }
	
	    /**
	     * 新增用户
	     * @param baseUser 用户信息
	     */
	    @CachePut(value = "baseUser",key = "'#p0'")
	    public void insertUser(BaseUser baseUser){
	        baseUserMapper.insertUser(baseUser);
	        logger.info("新增成功！");
	    }
	
	    /**
	     * 修改用户
	     * @param baseUser 用户信息
	     */
	    @CachePut(value = "baseUser",key = "'#p0'")
	    public void updateUser(BaseUser baseUser)
	    {
	        baseUserMapper.updateUser(baseUser);
	        logger.info("更新成功！");
	    }
	
	    /**
	     * 删除用户
	     * @param baseUser 用户id
	     *
	     */
	    @CacheEvict(value="baseUser",allEntries=true)
	    public void deleteUser(BaseUser baseUser){
	        baseUserMapper.deleteUser(baseUser.getId());
	        logger.info("删除成功！");
	    }
	
	    /**
	     * 清空缓存
	     * allEntries是boolean类型，表示是否需要清除缓存中的所有元素。默认为false，表示不需要。当指定了allEntries为true时，Spring Cache将忽略指定的key。有的时候我们需要Cache一下清除所有的元素，这比一个一个清除元素更有效率。
	     * condition做筛选
	     * key为键
	     * value对应的cache
	     *oreInvocation属性清除操作默认是在对应方法成功执行之后触发的，即方法如果因为抛出异常而未能成功返回时也不会触发清除操作。使用beforeInvocation可以改变触发清除操作的时间，当我们指定该属性值为true时，Spring会在调用该方法之前清除缓存中的指定元素。
	     */
	    @CacheEvict(value="baseUser",allEntries=true)
	    //指定多个@Caching(evict={@CacheEvict(“a1”),@CacheEvict(“a2”,allEntries=true)})；
	    // @CacheEvict(value="users", beforeInvocation=true,key = "'#p0'")
	    public void cleanCache(BaseUser baseUser){
	        logger.info("清空缓存！！！！！！");
	    }
	
	}

### 3 Controller

	@RestController
	@RequestMapping("/baseUser")
	public class BaseUserController {
	
	    private Logger logger = Logger.getLogger(getClass());
	
	    @Autowired
	    private BaseUserService baseUserService;
	
	    /**
	     * 查询用户信息列表
	     * @CachePut(value = "user", key = "#root.targetClass + #result.username", unless = "#person eq null")
	     * @param baseUser 查询条件
	     * @return 用户信息列表
	     */
	    @RequestMapping("/queryUserList")
	    public  List<BaseUser> queryUserList(BaseUser baseUser)
	    {
	        List<BaseUser> list = baseUserService.queryUserList(baseUser);
	        return list;
	    }
	
	    /**
	     * 新增用户
	     * @param baseUser 用户信息
	     */
	    @RequestMapping("/insertUser")
	    public String insertUser(BaseUser baseUser){
	        baseUserService.insertUser(baseUser);
	        return "新增成功";
	    }
	
	    /**
	     * 修改用户
	     * @param baseUser 用户信息
	     */
	    @RequestMapping("/updateUser")
	    public String updateUser(BaseUser baseUser){
	        baseUserService.updateUser(baseUser);
	        return "修改成功";
	    }
	
	    /**
	     * 删除用户
	     * @param baseUser 用户
	     */
	    @RequestMapping("/deleteUser")
	    public String deleteUser(BaseUser baseUser){
	        baseUserService.deleteUser(baseUser);
	        return "删除成功";
	    }
	
	    /**
	     * 清除缓存
	     */
	    @RequestMapping("/cleanCache")
	    public String cleanCache(BaseUser baseUser){
	        baseUserService.cleanCache( baseUser);
	        return "缓存清除成功！";
	    }
	}


**测试说明**：当缓存清空时，将查询数据库，有sql输出。