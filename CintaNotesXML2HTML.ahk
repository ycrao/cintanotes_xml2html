/*
脚本名称：	CintaNotesXML2HTML CintaNotes笔记导出器
脚本编码：	UTF-8(with BOM)
脚本说明：	CintaNotes是款小巧免费的绿色个人笔记文章资料管理软件，它只支持简单文本格式的笔记。
			CintaNotes免费版用户不能使用导出笔记为HTML文档功能，本软件能够间接实现该功能。
脚本版本：	2.6
脚本作者：	飞扬网络工作室 (fysoft)
作者官网：	[飞扬网络工作室官网]http://raoyc.com/fysoft/
			[软件使用说明]http://raoyc.com/fysoft/cintanotes_xml2html.html
			[github主页]https://github.com/ycrao/cintanotes_xml2html
交流Q群：	260655062
运行环境：	作者在编码或测试此脚本时所使用的运行环境为 Windows 7 SP1 + AutoHotkey(L) v1.1.09.04 + CintaNotes v2.6.1，其它相异于此运行环境的，请自行测试脚本兼容性问题
版权申明：	遵循MIT许可协议，在此脚本基础上所作出的修改，需保留原作者署名信息（作者名和官网链接）。
备注信息：	[更新日期]
				2013-07-25
			[更新历史]
				i)v2.0
					2012年11月27日，发布第1版，此版未经过多测试，故存在诸多BUG。版本号为
				ii)v2.1
					2012年11月29日，发布第2版，解决诸多BUG问题，增加打包为CHM文档功能。版本号为v2.1
					①解决IE6下目录页面每项笔记前不显示序号的BUG；
					②解决IE6下笔记页面正文不分段不换行贴合一起的BUG；
					（上述两条为低版本的IE浏览器不兼容HTML标准问题）
					③解决笔记页面特殊字符"<"与其它字符组合在一起，被当成HTML标签而不予显示的BUG；
					④增加导出笔记打包为CHM文档功能；
					⑤增加笔记页面顶栏上下笔记导航功能；
					⑥优化程序算法和逻辑，减少BUG出现几率。
				iii)v2.1_r04.02（r之后数字04.02代表程序编译和源码更新日期为4月2日）
					2013年4月2日，发布第3版，实现对CintaNotes最新稳定版v2.1的支持。
				iv)v2.6 因Google国内访问困难，fysoft项目整体迁移至github,请移至github[https://github.com/ycrao/cintanotes_xml2html]下载。
					2014年07月，发布新版，版本号定为2.6，跟CintaNotes主版本号一致，支持最新版CintaNotes(v2.6.1)。
*/


#NoEnv
#SingleInstance force
Menu, Tray, NoStandard
Menu, Tray, Add, 显示, ShowGUI
Menu, Tray, Add, 官方网站, OpenOfficialWebsite
Menu, Tray, Add, 关于,ShowInfo
Menu, Tray, Add, 帮助, GetHelp
Menu,Tray, Add, 退出, Exit

tpltpath = %A_ScriptDir%\tplt
notehtmlpath = %A_ScriptDir%\notes

Gui, Add, Text, x50 y10 w200 h20, 点击文件按钮来选定待转换文件:
Gui, Add, Edit, x50 y30 w180 h20 vFilePath
Gui, Add, Button, x240 y30 w60 h20 gImportFile, 文件...
Gui, Add, Text, x50 y70 w350 h60, 本软件可将CintaNotes导出的XML笔记，转换为带目录索引的多个HTML文档，并打包成CHM文档。
Gui, Add, Button, x310 y30 w80 h20 gXML2HTML, 转换导出
Gui, Show, w450 h150, CintaNotes XML2HTML/CintaNotes笔记导出器
return

ImportFile:
FileSelectFile,import_filename, , , ,CinaNotes导出的XML笔记文件(*.xml;)
if import_filename
	GuiControl,,FilePath,% import_filename
return

XML2HTML:
Gui,Submit,nohide
article_data := Object()
linktitle := Object()
section_data := Object()
m:=0
n:=0
if (FilePath="") 
	MsgBox ,路径不能为空，请选定CintaNotes导出的XML笔记文件
FileRead, xml, %FilePath%

id_pos := 1
Loop
{
	id_pos := RegExMatch(xml, "simU)<section\sid=""(\d+)""\snum=""(\d+)""\sname=""(.*)""\scolor=""([0-9a-z\#]{7})""\s/>", section_, id_pos)
	if !id_pos
		break
	id_pos ++
	if !section_
	{
	}
	else
	{
		m++
		if(section_1 != "")
		{
			section_data_%section_1% := section_3
		}
	}

}

pos := 1
;<note\suid=".*"\stitle="(.*)"\screated="(\w+)"\smodified="(\w+)"\ssource="(?:.*)"\slink="(.*)"\sremarks="(.*)"\stags="(.*)"\ssection="(\d+)"((\splainText="(\d)")?)>(.*)</note>
loop
{
	;pos := RegExMatch(xml, "simU)<note uid="".*""\stitle=""(.*)""\screated=""(\w+)""\smodified=""(\w+)""\ssource=""(?:.*)""\slink=""(.*)""\stags=""(.*)""\ssection=""(\d+)""((\splainText=""(\d)"")?)>(.*)</note>", article_, pos)
	pos := RegExMatch(xml, "simU)<note\suid="".*""\stitle=""(.*)""\screated=""(\w+)""\smodified=""(\w+)""\ssource=""(?:.*)""\slink=""(.*)""\sremarks=""(?:.*)""\stags=""(.*)""\ssection=""(\d+)""((\splainText=""(\d)"")?)>(.*)</note>", article_, pos)
	/*
	MsgBox, %article_%
	MsgBox, %article_1% ;title
	MsgBox, %article_2% ;created
	MsgBox, %article_3% ;modified
	MsgBox, %article_4% ;link
	MsgBox, %article_5% ;tags
	MsgBox, %article_6% ;section
	MsgBox, %article_7% ; " plainText="1""
	MsgBox, %article_8% ; " plainText="1""
	MsgBox, %article_9% ;plainText="1"
	MsgBox, %article_10% ;<!CDATA[ ]]>
	*/
	if !pos
		break
	pos++
	if !article_
	{
	}
	else
	{
		n++
		/*
		article_data[n, 1] := article_1 ;title
		article_data[n, 2] := article_2 ;created
		article_data[n, 3] := article_3 ;modified
		article_data[n, 4] := article_4 ;link
		article_data[n, 5] := article_5 ;tags
		article_data[n, 6] := article_9 ;plainText
		article_data[n, 7] := article_10 ;content
		article_data[n, 8] := htmltmp ;save html content
		article_data[n, 9] := article_6 ;section
		*/
		if(!article_1) 
		{
			title := "无标题"
			article_data[n, 1] := "无标题" ;title
		}
		else
		{
			;StringReplace, article_title, article_1, %A_Tab%, , All
			;StringReplace, article_title, article_title, %A_Space%, , All
			article_title := Trim(article_1)
			title := !article_title ? "无标题":article_1
			article_data[n, 1] := !article_title ? "无标题":article_1 ;title
		}
		StringReplace, created, article_2, T, , All
		article_data[n, 2] := created ;created
		StringReplace, modified, article_3, T, , All
		article_data[n, 3] := modified ;modified
		Year1 := SubStr(created, 1, 4)
		Month1 := SubStr(created, 5, 2)
		Day1 := SubStr(created, 7, 2)
		Hour1 := SubStr(created, 9, 2)
		Min1 := SubStr(created, 11, 2)
		Second1 := SubStr(modified, 13, 2)
		Year2 := SubStr(modified, 1, 4)
		Month2 := SubStr(modified, 5, 2)
		Day2 := SubStr(modified, 7, 2)
		Hour2 := SubStr(modified, 9, 2)
		Min2 := SubStr(modified, 11, 2)
		Second2 := SubStr(modified, 13, 2)
		createdtime = %Year1%年%Month1%月%Day1%日 %Hour1%时%Min1%分%Second1%秒
		modifiedtime = %Year2%年%Month2%月%Day2%日 %Hour2%时%Min2%分%Second2%秒
		StringReplace, article_4, article_4, %A_Tab%, , All
		StringReplace, article_4, article_4, %A_Space%, , All
		from := !article_4 ? "无来源":article_4
		tags := !article_5 ? "无标签":article_5
		linkurl := !article_4 ? "#":article_4
		article_data[n, 4] := !article_4 ? "无来源":article_4 ;link
		article_data[n, 5] := !article_5 ? "无标签":article_5 ;tags
		linktitle[n] := "<li><a href=""" . created . ".html"">" . title . "</a></li>"
		StringReplace, keywords, tags, %A_Space%, `,, All
		article_data[n, 6] := article_9 ;plainText
		if(!article_9)
		{
			StringReplace, article_10, article_10,<![CDATA[, , All
			StringReplace, article_10, article_10, ]]>, , All
			StringReplace, article_10, article_10, <<, &lt;, All 	; in html: "&lt;" = "<"  "&gt;"=">"
		}
		else
		{
			StringReplace, article_10, article_10,<![CDATA[, , All
			StringReplace, article_10, article_10, ]]>, , All
			StringReplace, article_10, article_10, <, &lt;, All 	; in html: "&lt;" = "<"  "&gt;"=">"
			StringReplace, article_10, article_10, >, &gt;, All 	; in html: "&lt;" = "<"  "&gt;"=">"
		}
		article_data[n, 7] := article_10 ;content
		;article_data[n, 9] := section_data[article_6] ;section
		sec := section_data_%article_6%
		;MsgBox, %sec%
		FileRead, htmltmp, *P65001 %tpltpath%\notes.tplt
		StringReplace, htmltmp, htmltmp, #title#, %title%, All
		StringReplace, htmltmp, htmltmp, _title_, %title%, All
		StringReplace, htmltmp, htmltmp, _tags_, %keywords%, All
		StringReplace, htmltmp, htmltmp, #thecreatedtime#, %createdtime%, All
		StringReplace, htmltmp, htmltmp, #themodifiedtime#, %modifiedtime%, All
		StringReplace, htmltmp, htmltmp, #link~, %linkurl%, All
		StringReplace, htmltmp, htmltmp, #link#, %from%, All
		StringReplace, htmltmp, htmltmp, #tags#, %tags%, All
		StringReplace, htmltmp, htmltmp, #section#, %sec%, All
		StringReplace, htmltmp, htmltmp, #article_content#, %article_10%, All
		StringReplace, htmltmp, htmltmp, @themodifiedtime@, %article_3%, All
		StringReplace, htmltmp, htmltmp, @thecreatedtime@, %article_2%, All
		article_data[n, 8] := htmltmp ;notes_html
		
		;MsgBox, % article_data[n, 8]
		;FileDelete, %notehtmlpath%\%created%.html
		;FileAppend, %htmltmp%, %notehtmlpath%\%created%.html, UTF-8
	}
}

;output : chmfile

;output hhp file
/*
;CintaNotes.hhp
[OPTIONS]
Compatibility=1.1 or later
Compiled file=CintaNotes导出笔记.chm
Contents file=CintaNotes.hhc
Default Font=微软雅黑,9,134
Default topic=notes_index.html
Display compile progress=No
Enhanced decompilation=Yes
Full-text search=Yes
Index file=CintaNotes.hhk
Language=0x804 中文(中国)
Title=CintaNotes导出笔记

[FILES]
notes_index.html

[INFOTYPES]
*/
hhp =
(
[OPTIONS]
Compatibility=1.1 or later
Compiled file=CintaNotes导出笔记.chm
Contents file=CintaNotes.hhc
Default Font=微软雅黑,9,134
Default topic=notes_index.html
Display compile progress=No
Enhanced decompilation=Yes
Full-text search=No
Language=0x804 中文(中国)
Title=CintaNotes导出笔记

[FILES]
notes_index.html

[INFOTYPES]
)
FileDelete, CintaNotes.hhp
FileAppend, %hhp%, CintaNotes.hhp

;output notes_index html
cover =
(
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<title>CintaNotes导出笔记</title>
</head>
<body>

<center>
<img src="notes/img/logo.png" />
<h1>CintaNotes导出笔记</h1>
<p>点击此处进入<a href="notes/index.html">目录</a>页</p>
</center>

</body>
</html>
)
FileDelete, notes_index.html
FileAppend, %cover%, notes_index.html, UTF-8
;output hhc file
/*
;CintaNotes.hhc
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
<HEAD>
<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
<!-- Sitemap 1.0 -->
</HEAD><BODY>
<object type="text/site properties">
<param name="ImageType" value="folder">
<param name="Window Styles" value="0x800025">
</object>
<UL>
	<LI> <OBJECT type="text/sitemap">
		<param name="Name" value="CintaNotes导出笔记">
		<param name="Local" value="notes_index.html">
		</OBJECT>
		<UL>
			<LI> <OBJECT type="text/sitemap">
			<param name="Name" value="目录">
			<param name="Local" value="notes\index.html">
			</OBJECT>
				<UL>
					<LI> <OBJECT type="text/sitemap">
						<param name="Name" value="笔记页面1">
						<param name="Local" value="notes\note1.html">
						</OBJECT>
					<LI>  <OBJECT type="text/sitemap"> 
						<param name="Name" value="笔记页面2">
						<param name="Local" value="notes\note2.html">
						</OBJECT>
				</UL>
</UL>
</BODY></HTML>
*/
hhc =
(
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
<HEAD>
<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
<!-- Sitemap 1.0 -->
</HEAD><BODY>
<object type="text/site properties">
<param name="ImageType" value="folder">
<param name="Window Styles" value="0x800025">
</object>
<UL>
	<LI> <OBJECT type="text/sitemap">
		<param name="Name" value="CintaNotes导出笔记">
		<param name="Local" value="notes_index.html">
		</OBJECT>
		<UL>
			<LI> <OBJECT type="text/sitemap">
			<param name="Name" value="目录">
			<param name="Local" value="notes\index.html">
			</OBJECT>
				<UL>
<!--@add_notes_page_info@-->
				</UL>
</UL>
</BODY></HTML>
)
;output : single note page
for index, element in article_data
{
	notehtml := article_data[index, 8] ;notes_html
	filename := article_data[index, 2] ;created
	title := article_data[index, 1] ;title
	if( n = 1)
	{
		StringReplace, hhc, hhc, <!--@add_notes_page_info@-->, %A_Tab%%A_Tab%%A_Tab%%A_Tab%<LI> <OBJECT type="text/sitemap">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Name" value="%title%">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Local" value="notes\%filename%.html">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%</OBJECT>, All
	}
	else
	{
		if(index = 1)
		{
			next := article_data[index+1, 2]
			StringReplace, notehtml, notehtml, #next~, %next%, All
			StringReplace, hhc, hhc, <!--@add_notes_page_info@-->, %A_Tab%%A_Tab%%A_Tab%%A_Tab%<LI> <OBJECT type="text/sitemap">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Name" value="%title%">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Local" value="notes\%filename%.html">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%</OBJECT>`r`n<!--@add_notes_page_info@-->, All
		}
		else if(index = n)
		{
			prev := article_data[index-1, 2]
			StringReplace, notehtml, notehtml,  #prev~, %prev%, All
			StringReplace, hhc, hhc, <!--@add_notes_page_info@-->, %A_Tab%%A_Tab%%A_Tab%%A_Tab%<LI> <OBJECT type="text/sitemap">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Name" value="%title%">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Local" value="notes\%filename%.html">%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%</OBJECT>, All
		}
		else
		{
			prev := article_data[index-1, 2]
			next := article_data[index+1, 2]
			StringReplace, notehtml, notehtml,  #prev~, %prev%, All
			StringReplace, notehtml, notehtml, #next~, %next%, All
			StringReplace, hhc, hhc, <!--@add_notes_page_info@-->, %A_Tab%%A_Tab%%A_Tab%%A_Tab%<LI> <OBJECT type="text/sitemap">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Name" value="%title%">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%<param name="Local" value="notes\%filename%.html">`r`n%A_Tab%%A_Tab%%A_Tab%%A_Tab%%A_Tab%</OBJECT>`r`n<!--@add_notes_page_info@-->, All
		}
	}
	FileDelete, %notehtmlpath%\%filename%.html
	FileAppend, %notehtml%, %notehtmlpath%\%filename%.html, UTF-8
}
;output hhc file
FileDelete, CintaNotes导出笔记.chm
FileDelete, CintaNotes.hhc
FileAppend, %hhc%, CintaNotes.hhc
RunWait, hhc.exe ..\CintaNotes.hhp, %A_Scriptdir%\bin, Hide UseErrorLevel
;output : index.html
FileRead, notestmp, *P65001 %tpltpath%\index.tplt
for index, element in linktitle
{
	StringReplace, notestmp, notestmp, <!--@add_ol_li@-->, %element%`r`n<!--@add_ol_li@-->, All
}
FileDelete, %notehtmlpath%\index.html
FileAppend, %notestmp%, %notehtmlpath%\index.html, UTF-8
Run, %notehtmlpath%\index.html
return


ShowGUI:
Gui, Show
return
ShowInfo:
MsgBox, 32, 欢迎使用CintaNotes XMl2HTML, 您当前正在使用的版本为 v2.6 `n获取最新版或反馈意见和建议请进官方QQ群260655062
return

GetHelp:
IfNotExist, README.html
	MsgBox, 本地帮助文档好像已经被删除，请点击托盘菜单 官方网站 打开官网帮助
else run README.html
return

OpenOfficialWebsite:
run https://github.com/ycrao/cintanotes_xml2html
return

GuiClose:
MsgBox, 4, 是否关闭CintaNotes XML2HTML程序, 点击是，关闭程序；否，最小化到托盘
IfMsgBox Yes
	ExitApp
else 
{
	Gui,hide
	TrayTip, CintaNotes XML2HTML, 已最小化到托盘，点击托盘菜单 显示 可以再次启用, 5, 1
}
return

EXIT:
ExitApp