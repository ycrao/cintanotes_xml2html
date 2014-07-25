#模版页面标签替换说明
----

**可显示的变量元素**，一般指放在HTML开闭标记(即tag)中间的内容，如`<p>Hello World</p>`，`Hello World`即为可显示的元素。  
模板会用形如“`#item#`”的变量来代替这类元素，同AHK变量形式，如：  

`<p>#paragraph#</p>`  


**不可显示的变量元素**，一般为HTML标记(tag)及其属性值，如`<div id="article_content"></div>`，`article_content`即为不可显示元素。  
模板会用形如“`_item_`”的变量来代替这类元素，如：  

`<div id="_div_id_name_"></div>`  

**超链接变量元素**，一般指HTTP/FTP/IMG/EMAIL等链接，如`<a href="http://www.google.com/">Google</a>`，`http://www.google.com/`即为超链接元素。  
模板会用形如“`#item~`”的变量来代替这类元素，如：  

`<a href="#google_link~">Google</a>`  

超链接推荐使用带“#”前缀的形式，因为“#”号可以表示当前HTML文档内部锚点。  

**注释内容**，HTML注释一般放在“`<!--`”和“`-->`”中间，为了与其他普通注释区分故再添加特殊符号“@”。  

`<!--@item@-->`  

一般这类标记可以用来捕捉或添加特定内容到HTML文档中。  

**静变量：**一般在ini配置中确定，只要配置文件不改，以后每次运行值都不变，在名字前添加&前缀即可，如：  

`_&item_`,`#&title#`,`#&link~`  

**动变量：**默认变量类型，表示每次运行值可能发生变化，默认情况下上述所有不带&前缀的变量均为动变量。  

以上标记是本人HTML模板的规定，以区分各种不同类型的替换元素，各位可根据实际需要自行修改。  

下面展示notes模版页面(位于tplt/notes.tplt)标签代码：

```
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<title>#title# - CintaNotes导出笔记</title>
	<meta name="description" content="CintaNotes导出笔记: _title_" />
	<meta name="keywords" content="_tags_" />
	<meta name="author" content="http://raoyc.com/fysoft" />
	<meta name="generator" content="CintaNotes XML2HTML" />
	<link rel="stylesheet" href="css/simple.css" type="text/css" media="screen" charset="utf-8" />
	<!--处理CintaNotes自定义标签 START-->
	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$('notelink').click(
				function(){
					var path = $(this).attr('path');
					if(path.indexOf('cintanotes:///url/')!==1)
					{
						$(this).attr('title', path);
						var href = path.substr(18);
						window.open(href);
					}
				}
			);
		});
	</script>
	<!--处理CintaNotes自定义标签 END-->
</head>
<body>
	<div id="wrapper">
		<div id="nav">
		<p>CintaNotes导出笔记：<a href="#prev~.html">上一笔记</a> | <a href="index.html">目录</a> | <a href="#next~.html">下一笔记</a></p>
		</div>
		<div id="content">
		<h1><strong>#title#</strong></h1>
			<div class="article_info">
	创建时间：<i>#thecreatedtime#</i>
	修改时间：<i>#themodifiedtime#</i>
	来源：<a href="#link~"><i>#link#</i></a>
	标签：<i>#tags#</i>
	分类：<i>#section#</i>
			</div>
#article_content#
		</div>
		<div id="footer">
		<p><b>&copy; Copyright 2011-2014 笔记大部分摘编自网络，由<a href="https://github.com/ycrao/cintanotes_xml2html">CinaNotes XML2HTML</a>工具创建</b></p>
		<p>笔记驱动：<a href="http://cintanotes.com/">CintaNotes</a> | 转换驱动：<a href="http://www.autohotkey.com/">AutoHotkey</a> <a href="http://ahkscript.org/">AHK L</a> | 脚本反馈：<a href="mailto:ryc-sunshine@qq.com">Email</a> | 官方Q群:260655062</p>
		</div>
	</div>
</body>
</html>
<!--FileModifiedTime : @themodifiedtime@-->
<!--FileCreatedTime(as HTML FileName) : @thecreatedtime@-->
```
