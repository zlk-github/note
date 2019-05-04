## 5 自定义组件

### 1 自定义全局组件

	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>Vue自定义全局组件</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
		</head>
		<body>
			<!--1自定义组件data要有返回值，自定义组件必须返回template-->
			<!--2可以在vue中使用自定义组件-->
			<!--3全局自定义组件可以多次使用-->
			<!--4自定义组件可以使用多次，函数内部数据是局部变量，不会相互影响（若要影响，声明全局变量）-->
			<div id="app">
				 <buttion-counter></buttion-counter>
				 <buttion-counter></buttion-counter>
			</div>
		</body>
		<script type="text/javascript">
			var myData = {count:0};
			
			//自定义组件buttion-counter（全局组件）,它支持Vue的data,methode,钩子函数等.必须在创建前定义.
			Vue.component("buttion-counter",{
				data:function(){
					/* return {
						//局部变量
						count:0
					} */
					//全局变量
					return myData;
				},
				//自定义组件 返回的标签与内容.只能返回一个根元素
				template:'<buttion v-on:click="count++">{{count}}</buttion>'
			})
			
			new Vue({
				el:"#app"
			});
		</script>
			
	</html>


### 2 自定义局部组件
		
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>Vue自定义局部组件</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
			<script type="text/template" id='temp'>
				<div>
					{{massage}}
					<ul>
						<li>第一部分</li>
						<li>第二部分</li>
					</ul>
				</div>
			</script>
		</head>
		<body>
			<!--全局组件-->
			<div id="app">
				<my_header></my_header>
			</div>
			
			<!--局部组件-->
			<div id="app1">
				<my_header>
					<button slot="left">left</button>
					<button slot="right">right</button>
				</my_header>
			</div>
		</body>
		<script type="text/javascript">
			Vue.component("my_header",{
				//自定义组件 返回的标签与内容.只能返回一个根元素
				template:'<div>全局组件</div>'
			});
			
			new Vue({
				el:'#app'
			});
			
			new Vue({
				el:'#app1',
				//局部组件优先,且只对当前有效
				components:{
					'my_header':{
						template:'<div><slot name="left"/>全局组件<slot name="right"/></div>',
						//javascript中定义
						/* template:'#temp',
						data:function(){
							return{
								massage:'这是一个局部组件'
							}
						} */
					}
				}
			})
		</script>
			
	</html>


### 参考

	官网地址： https://cn.vuejs.org/

	Ant Design of Vue地址：  https://vue.ant.design/docs/vue/introduce-cn/