## 前端试题

### 1 回文字符

注：正序和倒叙一样，input为字符串。

input.split('').reverse().join('') === input;

### 2 水平垂直居中

	.box1{
	    position: relative;
	}
	.box1 .inner{
	    position: absolute;
	    left: 50%;
	    top: 50%;
	    margin-left: -50px;
	    margin-top: -50px;
	}

