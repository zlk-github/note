## Mybatis报错（一）:java.lang.IllegalArgumentException: Result Maps collection does not contain value for com.common.ticket.mapper.TicketDetailMapper.confDatabaseFrameResult

### 1 异常截图
	org.apache.ibatis.builder.IncompleteElementException: Could not find result map com.common.ticket.mapper.TicketDetailMapper.confDatabaseFrameResult
		at org.apache.ibatis.builder.MapperBuilderAssistant.getStatementResultMaps(MapperBuilderAssistant.java:346)
		at org.apache.ibatis.builder.MapperBuilderAssistant.addMappedStatement(MapperBuilderAssistant.java:290)
		at org.apache.ibatis.builder.xml.XMLStatementBuilder.parseStatementNode(XMLStatementBuilder.java:109)
		at org.apache.ibatis.session.Configuration.buildAllStatements(Configuration.java:788)
		at org.apache.ibatis.session.Configuration.hasStatement(Configuration.java:758)
		at org.apache.ibatis.session.Configuration.hasStatement(Configuration.java:753)
		at org.apache.ibatis.binding.MapperMethod$SqlCommand.resolveMappedStatement(MapperMethod.java:247)
		at org.apache.ibatis.binding.MapperMethod$SqlCommand.<init>(MapperMethod.java:217)
		at org.apache.ibatis.binding.MapperMethod.<init>(MapperMethod.java:48)
		at org.apache.ibatis.binding.MapperProxy.cachedMapperMethod(MapperProxy.java:65)
		at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:58)
		at com.sun.proxy.$Proxy70.pageList(Unknown Source)
		at com.common.managercentre.service.ConfDatabaseService.pageList(ConfDatabaseService.java:37)
		at com.common.managercentre.controller.ConfDatabaseController.pageList(ConfDatabaseController.java:51)
		at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
		at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
		at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
		at java.lang.reflect.Method.invoke(Method.java:601)
		at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
		at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
		at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
		at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
		at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
		at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
		at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:967)
		at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:901)
		at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
		at org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
		at javax.servlet.http.HttpServlet.service(HttpServlet.java:635)
		at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
		at javax.servlet.http.HttpServlet.service(HttpServlet.java:742)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:231)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:52)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:99)
		at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.springframework.web.filter.HttpPutFormContentFilter.doFilterInternal(HttpPutFormContentFilter.java:105)
		at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.springframework.web.filter.HiddenHttpMethodFilter.doFilterInternal(HiddenHttpMethodFilter.java:81)
		at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
		at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
		at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
		at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)
		at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:198)
		at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:96)
		at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:478)
		at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:140)
		at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:80)
		at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:87)
		at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)
		at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:799)
		at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:66)
		at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:868)
		at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1455)
		at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
		at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
		at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
		at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
		at java.lang.Thread.run(Thread.java:722)
	Caused by: java.lang.IllegalArgumentException: Result Maps collection does not contain value for com.common.ticket.mapper.TicketDetailMapper.confDatabaseFrameResult
		at org.apache.ibatis.session.Configuration$StrictMap.get(Configuration.java:888)
		at org.apache.ibatis.session.Configuration.getResultMap(Configuration.java:640)
		at org.apache.ibatis.builder.MapperBuilderAssistant.getStatementResultMaps(MapperBuilderAssistant.java:344)
		... 67 more

2 异常提示

	org.apache.ibatis.builder.IncompleteElementException: Could not find result map com.common.ticket.mapper.TicketDetailMapper.confDatabaseFrameResult

	Caused by: java.lang.IllegalArgumentException: Result Maps collection does not contain value for com.common.ticket.mapper.TicketDetailMapper.confDatabaseFrameResult

初步定位应该是TicketDetailMapper接口相关方法或者TicketDetailMapper.xml存在问题。

3 解决方案
 
***网上查询后很多结果显示可能是xml内容文件重复，存在相同的id造成。我查询后并没有重复的名称，包也能扫描到。排出此错误。

错误出现复现：项目能正常启动，但是调项目中之前调通的接口，同样会报以上错误日志。因此定位问题应该是出在TicketDetailMapper.xml

3.1 报错前配置TicketDetailMapper.xml

	<mapper namespace="com.common.ticket.mapper.TicketDetailMapper">
		<parameterMap type="com.common.ticket.bean.TicketDetail"    id="ticketDetailParameter"></parameterMap>
		<parameterMap type="com.common.util.Page"    id="pageParameter"></parameterMap>
		<resultMap type="com.common.ticket.bean.TicketDetail"   id="ticketDetailResult"></resultMap>
	
		<!--查询场景id对应话单详情-->
		<select  id="pageList"    parameterMap="pageParameter"    resultMap="confDatabaseFrameResult" >
			SELECT td.id id,
				   td.scene_id sceneId,
				   td.ticket ticket
			FROM ticket_detail td
			WHERE td.scene_id=#{condition.sceneId}	
			<if test="startNum != null and pageSize != null">
				limit  #{startNum}, #{pageSize}
			</if>
		</select>
	</mapper>

**哈哈哈，有没有注意到，一个好低级的错误。复制过来忘记改了。定义的的resultMap为ticketDetailResult。结果返回的resultMap为confDatabaseFrameResult。问题是根本在这个xml中没有对应的resultMap。**

3.1 修改后配置TicketDetailMapper.xml

	<mapper namespace="com.common.ticket.mapper.TicketDetailMapper">
		<parameterMap type="com.common.ticket.bean.TicketDetail"    id="ticketDetailParameter"></parameterMap>
		<parameterMap type="com.common.util.Page"    id="pageParameter"></parameterMap>
		<resultMap type="com.common.ticket.bean.TicketDetail"   id="ticketDetailResult"></resultMap>
	
		<!--查询场景id对应话单详情-->
		<select  id="pageList"    parameterMap="pageParameter"    resultMap="ticketDetailResult" >
			SELECT td.id id,
				   td.scene_id sceneId,
				   td.ticket ticket
			FROM ticket_detail td
			WHERE td.scene_id=#{condition.sceneId}	
			<if test="startNum != null and pageSize != null">
				limit  #{startNum}, #{pageSize}
			</if>
		</select>
		
	</mapper>