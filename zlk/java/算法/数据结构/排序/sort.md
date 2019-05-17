## 排序算法

### 1 选择排序

n个记录的直接选择排序可经过n-1趟直接选择排序得到有序结果。（有序集 || 无序集） --不稳定（值相同时会出现）

**描述**：首先在未排序序列找到一个最小值，并将其存放在排序序列的第一个位置。接着从未排序序列中找到一个最小值将其放入排序序列的末尾。依次类推，直到序列排序完毕。（**当未排序序列中首位置不是最小时，将其与最小值的位置做交互，其余元素位置不变**）

例：3  , 5   ,2  , 4 ,  7

	第一次（3和2交换）     ：  2  || 5   3   4   7
	第二次（5和3交换）     ：  2  3  ||  5   4   7
	第三次（5和4交换）     ：  2  3  4   ||  5   7
	第四次（5最小，不交换） ：  2  3  4   5  ||   7

	注：剩余最后一个时，肯定最大，不需要再比。（||前为排序序列，||后为未排序）
	

**算法实现**：
	
需要比较的学生实体

	/**学生类
	 * @author  zhoulk
	 * date: 2019/5/17 0017
	 */
	@Getter
	@Setter
	public class Student implements Comparable{
	    /**姓名*/
	    private String name;
	    /**年龄*/
	    private Integer age;
	
	    public Student(String name, Integer age) {
	        this.name = name;
	        this.age = age;
	    }
	
	    @Override
	    public String toString() {
	        return "Student{" +
	                "name='" + name + '\'' +
	                ", age=" + age +
	                '}';
	    }
	
	    @Override
	    public int compareTo(Object o) {
	        if(this.age.compareTo(((Student)o).age)>0){
	            return 1;
	        }
	        if(this.age.compareTo(((Student)o).age)==0){
	            if(this.name.compareTo(((Student)o).name)>0){
	                return 1;
	            }
	        }
	        return 0;
	    }
	}

比较类

	/**desc:选择排序
	 * @author  zhoulk
	 * date: 2019/5/16 0016
	 */
	public class SelectSort<T> {
	
	    public static void main(String[] args) {
	        Integer[] arr = new Integer[]{1,4,5,2,1,8,13,6,9};
	        SelectSort<Integer[]> selectSort = new SelectSort();
	        Integer[] returnArr = selectSort.sortAll(arr);
	
	        System.out.println("直接使用引用对象-----------------------");
	        for (Integer v:arr) {
	            System.out.println(v+",");
	        }

	        System.out.println("使用泛型的返回值-----------------------");
	        for (Integer v:returnArr) {
	            System.out.println(v+",");
	        }

	        System.out.println("对象比较-----------------------");
	        Student[] students = { new Student("Zhang", 20),
	                new Student("Li", 23),
	                new Student("Wang", 50),
	                new Student("Liu", 17),
	                new Student("Aiu", 17),
	                new Student("Ma", 19)
	        };
	         selectSort.sortAll(students);
	        for (Student v:students) {
	            System.out.println(v+",");
	        }
	    }
	
	    /**
	     * 选择排序（从小到大）
	     * @param arr 需要排序数组
	     * @param <T> 结果
	     * @return
	     */
	    public <T extends Comparable<T>> T[]  sortAll(T[] arr){
	        if(arr==null||arr.length==0){
	           return null;
	        }
	
			//最后一次不需要再比
	        for(int i = 0;i<arr.length-1;i++){
               //记录未排序元素最小值下标
	           int minIndex = i;
	           for(int j = i+1;j<arr.length;j++){
	                if(arr[minIndex].compareTo(arr[j])>0){
	                    minIndex = j;
	                }
	           }
	
	            T temp = arr[i];
	            arr[i] = arr[minIndex];
	            arr[minIndex] = temp;
	        }
	        return arr;
	    }
	
	}


### 2 插入排序

描述：默认序列