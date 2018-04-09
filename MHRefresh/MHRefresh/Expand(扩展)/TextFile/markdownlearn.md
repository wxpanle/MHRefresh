<table>
		<tr>
			<td>Foo</td>
		</tr>
</table>

< & 需要特殊处理  < 符号用于起始标签  & 符号则用于标记HTML实体
如果要显示这个字符的原型 必须使用  &lt &amp

  //段落和换行  

//类Selexct效果  标题
这是一个标题
==========
这是一个标题
----------


//类atx效果标题
# 这是标题1
## 这是标题2
### 这是标题3
#### 这是标题4
##### 这是标题5
###### 这是标题6

//引用
>这是一个引用，当引用存在的时候  
>
>空行引用
>>嵌套引用
>
>这是第一个引用的结束
>##这是一个标题



//列表  
//无序列表使用  * + - 作为标记  
*  Red  
*  Green  
*  Blue  
  
+ Red  
+ Green  
+ Blue  

- Red
- Green
- Blue

//有序列表则使用数字接着一个英文标点  
1.Red  
2.Green  
3.Blue  

*	dsgkldgjkldsjglkdjslgkdjgkldfjg  
	sdgjlkdsjglkdsjgklsdglljl
	
	>这是一个引用  
	
	
1986\. What is a great season

//代码区块
这是一个普通段落  
    这是一个代码块
	
	
	
//分割线
* * *  
***  


*****  

- - - 

//区段元素  
//行内式  
This is [an example](https:www.baidu.com) inline link.  
//相对路径  
See my [About](/about/) page for details.  
//参数式的链接实在链接文字的括号后面再接上另一个方括号，而在第二个方括号里面要填入用以辨识链接的标记  
This is [an example][id] reference-style link.  
This is [an example] [id] reference-style link.  
[id]: http://www.baidu.com "Optional Title Here"  

//链接内容形式的定义是  
    +	方括号（前面可以选择性地加上至多三个空格开缩进），里面输入链接文字  
    + 	接着一个冒号  
    +  接着一个以上的空格或制表符  
    +  接着链接的网址  
    +  选择性地接着title内容，可以用单引号 双引号 或者是（）  

[foo]:	https:www.baidu.com/ "111"  
[foo]: https:www.baidu.com/ '111' 
[foo]:	https:www.baidu.com/  (111)  

//强调  
// * _ 作为标记强调字词的符号，  
*这是一个\*的强调*  
_这是一个\_的强调_  
这是一个插在*文字中间*的强调  

Use the `printf()` function.  
``There is a literal backtick (`) here``  

A single backtick in a code spam: `` ` ``  
A backtick-delimited string in a code span: `` `foo` ``  
Please don't use any `<blink>` tags.  
`&#8212;` is the decimal-encoded equivalent of `&mdash;`.  
//图片  
![Alt text](/path/to/img.jpg)
![Alt text](/path/to/img.jog "11111")  
//![Alt function][id] 
[id]: url/to/image  
//其它  自动链接  
<http://example.com/>  
<3225715929@qq.com> 


**粗体**  
*斜体*  
_斜体_  
***加粗斜体***  
~删除线~  

//反斜杠  
\*我开始强调\*  
 欢迎进入[卿颜淡墨](https://www.baidu.com)  
 欢迎进入[卿颜淡墨](https://www.baidu.com "卿颜淡墨")  


我经常去的几个网站[Goodle][1]、[baidu][2]以及[自己的博客][3]  
[Leanote 笔记][2]是一个不错的[网站][].  

[1]: http://www.google.com "Google"  
[2]: http://www.leanote.com "Leanote"  
[3]: http://www.blog.leanote.com/freewalk "卿颜淡墨"  
[网站]: http://www.baidu.com  


<http://example.com/>  
<3225715929@qq.com>  


//锚点  
网页中锚点其实就是业内超链接，也就是链接本文档内部的某些元素，实现当前页面中的跳转。  
## 0. 目录{#index}  

跳转到[目录](#index)  


//列表  
//无序列表  
- 无序列表  
- 无序列表  
- 无序列表      

//定义型列表  
Markdown  
: 轻量级文本标记语言  
代码块2  
:  这是代码块的定义  
		代码块  
		
		
列表缩进  

		<代码>
