## 2 条件与循环

v-if指令绑定seen为true时，p标签内容可见，为false时不可见。

v-for指令可以绑定数组的数据来渲染一个项目列表
	
	<!DOCTYPE html>
	<html>
		<head>
			<meta charset="utf-8" />
			<title>v-if v-for</title>
			<script src="https://cdn.jsdelivr.net/npm/vue@2.6.10/dist/vue.js"></script>
		</head>
		<body>
			<div id="app" v-bind:title="vueTitle">
				<p v-if="seen">seen为true可见。</p>
				
				<ul>
					<li v-for="item in list">
						{{item.text}}
					</li>
				</ul>
			</div>
		</body>
		<script type="text/javascript">
			var app = new Vue({
				el:'#app',
				data:{
					seen:true,
					list:[{"text":111},{"text":222},{"text":333}]
				}
			})
		</script>
			
	</html>

### 参考

	官网地址： https://cn.vuejs.org/

	Ant Design of Vue地址：  https://vue.ant.design/docs/vue/introduce-cn/