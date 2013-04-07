<%@ page language="java" contentType="text/html; charset=GBK" import="java.text.SimpleDateFormat,java.util.Date"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>入库单查询</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String userType = currUser.getSutype() + "";
	String sgcode = currUser.getSgcode();
	String supcode = currUser.getSupcode();
	Date date=new Date();
	String startDate_= new SimpleDateFormat("yyyy-MM-dd").format(date);
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		
		$(function(){
			$("#QueryDetailTable").css("display","none");
			$('#RKDoc').datagrid({
				width: 930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'BIHBILLNO',title:'入库编号',width:130,align:'center',sortable:true,
				    formatter:function(value,rec){
					    if(value=='合计')
					    	return "合计";
						else
							return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=RKDocDetail('"+rec.BIHBILLNO+"','"+rec.BIHSGCODE+"','"+rec.BIHSHMFID+"');>" + rec.BIHBILLNO + "</a>";
						}
					},
				    {field:'BIHSHMFID',title:'门店编号',width:100,align:'center',sortable:true},
				    {field:'SHOPNAME',title:'门店名称',width:130,sortable:true},
				    {field:'BIHSHTIME',title:'审核日期',width:104,align:'center',sortable:true},				    
				    {field:'BIDSL',title:'数量',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						else return formatNumber('0',{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					 }},
				     {field:'BIDHSJJJE',title:'金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						else return formatNumber('0',{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					 }}
						<%if("L".equals(userType)){%>
						,{field:'BIHSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:130,align:'center',sortable:true}
						<%}%>
						
				]],
				toolbar:[{
					text:'导出Excel',
					iconCls:'icon-redo',
					handler:function(){
						exportExcel();
					}
				}],
				pagination:true,
				rownumbers:true
			});

			$('#RKDocDetail').datagrid({
				width: 800,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'BIDGDID',title:'商品编码',width:90,sortable:true,
				    	formatter:function(value,rec){
						    if(value=='合计')
						    	return "合计";
							else
								return value;
						}
					},
				    {field:'BARCODE',title:'商品条码',width:100,align:'center',sortable:true},
				    {field:'GDNAME',title:'商品名称',width:110,align:'left',sortable:true},			
				    {field:'GDSPEC',title:'规格',width:60,sortable:true},			
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},
				    {field:'BIDSL',title:'入库数量',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BIDHSJJ',title:'含税进价',width:80,align:'center',sortable:true},
				        {field:'BIDHSJJJE',title:'含税进价金额',width:80,align:'center',sortable:true},
						{field:'BIHSUPID',title:'供应商编码',width:90,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:113,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true
			});
			//如果是供应商用户就隐藏供应商编码输入框，否则显示
			if(User.sutype == 'S'){
				$("#sup").hide();
			}else{
				$("#sup").show();
			}
			$("#RKDocdatagrid").css("display","none");	
		});

		
		function reloadgrid ()  {
        	//验证用户输入日期是否合法？
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('错误','请输入开始或结束日期！！！','error');
				return;
			} 
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcodequery').val();	
			}else {
				supcode = User.supcode;
			}
	        //查询参数直接添加在queryParams中
	        $('#RKDoc').datagrid('options').url = 'JsonServlet';        
			$('#RKDoc').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getRKDocHead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.RKDocQuery',
						ACTION_MANAGER : 'rkdocQueryManager',	
						list:[{
							sgcode : User.sgcode,
							supcode : supcode,
							shopcode : $('#shopcode').val(),// 门店编码
							startDate : $('#startDate').val(),
							endDate : $('#endDate').val()
						}]
					}
				)
			};		
			$("#RKDocdatagrid").css("display","");
			$("#QueryTable").css("display","");
			$("#QueryDetailTable").css("display","none");
			$("#RKDoc").css("display","");
			$("#RKDoc").datagrid('reload'); 
			$("#RKDoc").datagrid('resize'); 
			$('#supcodequery').combobox('setValue','');
    	}
		
    	function RKDocDetail(rkdcode,ssgcode,shopcode)
    	{
    		$("#hiddenbillno").val(rkdcode);
    		$("#hiddenshopno").val(shopcode);
			
    		//查询参数直接添加在queryParams中
	        $('#RKDocDetail').datagrid('options').url = 'JsonServlet';        
			$('#RKDocDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
								ACTION_TYPE : 'getRKDocDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.RKDocQuery',
								ACTION_MANAGER : 'rkdocQueryManager',	
								list:[{									
									sgcode : User.sgcode,
									BILLNO:rkdcode,
									shopcode:shopcode									
								}]
					}
				)
			};	
			$("#QueryTable").css("display","none");
			$("#QueryDetailTable").css("display","");
			$("#RKDocDetail").datagrid('reload'); 
			$("#RKDocDetail").datagrid('resize'); 
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getHead',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.RKDocQuery',
							ACTION_MANAGER : 'rkdocQueryManager',	
							list:[{									
								sgcode : User.sgcode,
								BILLNO:rkdcode,
								shopcode:shopcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	 if( data.rows != undefined && data.rows.length > 0 ){	   
                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					           $("#orderno").html(n.BIHORDERNO);
					           $("#shopname").html(n.BIHSHMFID+'-'+n.SHOPNAME);
					           $("#supname").html(n.BIHSUPID+'-'+n.SUPNAME);
					           $("#memo").html(n.BIHMEMO);
					           $("#shtime").html(n.BIHSHTIME);
					           $("#BILLNO").html(n.BIHBILLNO);
					           
						        
						       });						        
                    	 }	                    	 
                    }else{ 
                        $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
				
    	}
    	function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcodequery').val();
			}else {
				supcode = User.supcode;
			}
			$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'getRKDocHead',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.RKDocQuery',
							ACTION_MANAGER : 'rkdocQueryManager',										 
							list:[{
								exportExcel : true,
								<%
								if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
								%>
								enTitle: ['BIHBILLNO','BIHSHMFID','SHOPNAME','BIHSHTIME','BIDSL','BIDHSJJJE','BIHSUPID','SUPNAME'],
								cnTitle: ['入库编号','门店编码','门店名称','审核日期','数量','金额','供应商编号','供应商名称'],
								<%}else{%>
								enTitle: ['BIHBILLNO','BIHSHMFID','SHOPNAME','BIHSHTIME','BIDSL','BIDHSJJJE' ],
								cnTitle: ['入库编号','门店编码','门店名称','审核日期','数量','金额'],
								<%}%>
								sheetTitle: '入库单查询',
								sgcode : User.sgcode,
								supcode : supcode,
								shopcode : $('#shopcode').attr('value'),
								startDate : $('#startDate').attr('value'),	// 起始时间
								endDate : $('#endDate').attr('value') 		// 结束时间
							}]
						}
					)						
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	location.href = data.returnInfo;	                    	 
                    }else{ 
                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
		} 
		
	   //获取所有门店信息
		function loadAllShop( list ){
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Shop',
								ACTION_MANAGER : 'shopManager',	
								list:[{									
									sgcode : User.sgcode
								}]
						})
						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
	   
    	function backgrid ()  {     		
    		$("#QueryTable").css("display","");
    		$("#QueryDetailTable").css("display","none");
    	} 		  
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">入库单查询</td>
		<input type="hidden" id="hiddenbillno" />
		<input type="hidden" id="hiddenshopno" />
	</tr>
	<tr>
		<td  style="border: none;width:250">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：&nbsp;&nbsp;&nbsp;<select
			style="width: 154px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>所有门店</option>
		</select></td>

		<td width="250" style="border: none;">起始日期：<input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'
			<%if(currUser.getSgcode().equals("3018")&&currUser.getSutype().toString().equalsIgnoreCase("S")){ %>,minDate:'<%=startDate_%>'<% } %>});"size="20" /></td>
		<td width="250" style="border: none;">结束日期：<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
		<td id="sup"  style="border:none;width:250px;">供应商编码：
			<input type="text" id="supcodequery" name="supcodequery" size="20"/>
		</td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>

	<tr>
		<td style="border: none;"><img src="images/sure.jpg" border="0"
			onclick="reloadgrid();" /></td>
		<td style="border: none;"></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="RKDocdatagrid" >
				<table id="RKDoc"></table>
			</div>
		</td>
	</tr>

</table>

<table id="QueryDetailTable" width="800" style="line-height:20px; text-align:left; border:none;font-size: 12px;" >
         <tr>
               <td height="24" colspan="2" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">入库单明细</span></td>
           </tr>
             <tr>
               <td width="434" height="24" style="border:none;">订单号码 ：
               <span   id="orderno" name="orderno"></span>   
               </td>
               <td width="524" style="border:none;">入库单号 ： 
                 <span   id="BILLNO" name="BILLNO"></span>             </td>
           </tr>
             <tr>
               <td height="27" style="border:none;"> 审核日期 ：
               <span  id="shtime" name="shtime"></span></td>
               <td style="border:none;">供 应 商 ：
               <span  id="supname" name="supname"></span>
                 </td>
           </tr>
             <tr>
               <td  height="13" style="border:none;">收货门店 ：
               <span   id="shopname" name="shopname"></span>
               </td>
              <td style="border:none;"><font style="text-align:center;letter-spacing:25px">备注</font> ：
             <span   id="memo" name="memo"></span>
             </td>
           </tr>
           <tr><td colspan="2" style="text-align:right"></td></tr>
           <tr><td colspan="2"><table id="RKDocDetail"></table></td></tr>
           <tr><td colspan="2" style="text-align:left"></td></tr>
           <tr>
           	   <td colspan="2" style="text-align:left">
           	 	<img src="images/goback.jpg" border="0" onclick="backgrid();" />
           	   </td>
           </tr>
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>