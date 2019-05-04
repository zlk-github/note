### 7 Vue axios请求

### 1.data.json

	[{"name":"Tom","age":22},{"name":"Tim","age":22}]


### 2 Vue axios请求实例

	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>ajax</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
			<!--一般打包即可（$ npm install axios），不需要下面这句-->
			<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
		</head>
		<body>
			<div id="app">
				<table border="1" width="300">
					<tr v-for="item in result">
						<td>
							{{item.name}}
						</td>
						<td>
							{{item.age}}
						</td>
					</tr>
					
				</table>
			</div>
		</body>
		<script type="text/javascript">
			new Vue({
				el:'#app',
				data:{
					result:[]
				},
				created:function(){
					//var temp = this;
					axios({
					  method: 'get',
					  url: 'data.json',
					 //data: {},
					 //headers: { 'content-type': 'application/x-www-form-urlencoded' },
					
					 }).then(function (result) {
						 //成功回调
						console.info(result.data);
						//查看数据格式
						//console.info(typeof(result.data));
						//将数据转换为定义的格式,result:[]
						//console.info(eval(result.data));
						//这里的this不指向data中的对象,是指向ajax.使用bind(this)解决;或者var temp = this; temp..result=result.data;
				 		this.result=result.data;
				    }.bind(this)).catch(function (error) {
						//错误回调
					    console.log("错误信息:"+error);
					 });
					
				}
				
			})
		</script>
			
	</html>

### 3 总结
 
	axios中this指向ajax本身，如果需要绑定Vue中的data，需要使用.bind(this);
	ajax返回数据如果是字符串类型，可以使用eval()方法转换类型。
 

**附加**：

以下对ajax起效，对axios未测试（****）
	
	//同步,不支持该方式.对axios无效
	 async:false,
	
	// 跨域
	xhrFields: {
	  withCredentials: true
	},
	crossDomain: true, 
	
	 //跨域后台
	response.setHeader("Access-Control-Allow-Origin",  request.getHeader("Origin"));
	 response.addHeader("Access-Control-Allow-Credentials", "true"); 

### 参考

	https://github.com/axios/axios