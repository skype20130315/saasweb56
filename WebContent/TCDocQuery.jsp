<%@ page language="java" contentType="text/html; charset=GBK" import="java.text.SimpleDateFormat,java.util.Date"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>退厂单查询</title>

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
			$('#TCDoc').datagrid({
				width: 930,
				nowrap: false,
				striped: true,
				singleSelect: true,
				fitColumns:false,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',	
				columns:[[
				    {
				    field:'BTHBILLNO',title:'退厂单号',width:150,align:'center',sortable:true,
				    formatter:function(value,rec){
						if(value=='合计')
						return value;
						else
							return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=TCDocDetail('"+rec.BTHBILLNO+"','"+rec.BTHSGCODE+"','"+rec.BTHTHMFID+"');>" + rec.BTHBILLNO + "</a>";
						}
					},
				    {field:'BTHTHMFID',title:'门店编号',width:80,align:'center',sortable:true},
					{field:'SHPNAME',title:'门店名称',width:140,sortable:true},
				    {field:'BTHSHTIME',title:'审核日期',width:100,align:'center',sortable:true},	
					{field:'BTDSL',title:'数量',width:95,align:'center',sortable:true},
			        {field:'BTDHSJJJE',title:'金额',width:95,align:'center',sortable:true}
					<%if("L".equals(userType)){%>
					,{field:'BTHSUPID',title:'供应商编码',width:95,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:138,align:'center',sortable:true}
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

			$('#TCDocDetail').datagrid({
				width: 900,
				nowrap: false,
				striped: true,
				singleSelect: true,	
				fitColumns:false,
				remoteSort: true,	
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
					{field:'BTDGDID',title:'商品编码',width:140,sortable:true},
				    {field:'GDNAME',title:'商品名称',width:140,align:'left',sortable:true},			
				    {field:'GDSPEC',title:'规格',width:65,sortable:true},			
				    {field:'GDUNIT',title:'单位',width:65,align:'center',sortable:true},
				    {field:'BARCODE',title:'商品条码',width:65,align:'center',sortable:true},
				    {field:'BTDSL',title:'退厂数量',width:70,align:'center',sortable:true} ,
					{field:'BTDHSJJ',title:'含税进价',width:78,align:'center',sortable:true} ,
			        {field:'BTDHSJJJE',title:'含税进价金额',width:78,align:'center',sortable:true}
					<%if("L".equals(userType)){%>
					,{field:'BTHSUPID',title:'供应商编码',width:80,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:147,align:'center',sortable:true}	
					<%}%>
					
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
			$("#TCDocdatagrid").css("display","none");  
		});
	
	
		function reloadgrid ()  {
        	//验证用户输入日期是否合法？
        	var temp5 = "";
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('提示','请输入开始或结束日期！！！','info');
				return;
			} 
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcodequery').val();
			}else {
				supcode = User.supcode;
			}
	        $('#TCDoc').datagrid('options').url = 'JsonServlet';        
			$('#TCDoc').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getTCDocHead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
						ACTION_MANAGER : 'tcdocQueryManager',	
						list:[{
							sgcode : User.sgcode,
							supcode : supcode,
							shopcode : $('#shopcode').attr('value'),// 门店编码
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#TCDocdatagrid").css("display","");
			$("#QueryTable").css("display","");
			$("#QueryDetailTable").css("display","none");
			
			$("#TCDoc").datagrid('reload'); 
			$("#TCDoc").datagrid('resize'); 
			$('#supcodequery').combobox('setValue','');
    	}
    	function TCDocDetail(tcdcode,ssgcode,shopcode)
    	{
    		$("#hiddenbtllno").val(tcdcode);
    		$("#hiddenshopno").val(shopcode);

    		//查询参数直接添加在queryParams中
	        $('#TCDocDetail').datagrid('options').url = 'JsonServlet';        
			$('#TCDocDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
								ACTION_TYPE : 'getTCDocDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
								ACTION_MANAGER : 'tcdocQueryManager',	
								list:[{									
									sgcode : User.sgcode,
									BTLLNO : $("#hiddenbtllno").val(),
									shopcode:shopcode
								}]
					}
				)
			};	
			$("#QueryTable").css("display","none");
			$("#QueryDetailTable").css("display","");
            $("#TCDocDetail").datagrid('reload'); 
			$("#TCDocDetail").datagrid('resize'); 
			
			$.post( 'JsonServlet',				
				{
					data : obj2str({		
							ACTION_TYPE : 'getHead',
							ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
							ACTION_MANAGER : 'tcdocQueryManager',	
							list:[{									
								sgcode : User.sgcode,
								BTLLNO:$("#hiddenbtllno").val(),
								shopcode:shopcode
							}]
					})
					
				}, 
				function(data){ 
                    if(data.returnCode == '1' ){
                    	 if( data.rows != undefined && data.rows.length > 0 ){	   
                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
					           $("#shopname").html(n.BTHTHMFID+'-'+n.SHOPNAME);
					           $("#supname").html(n.BTHSUPID+'-'+n.SUPNAME);
					           $("#memo").html(n.BTHMEMO);
					           $("#shtime").html(n.BTHSHTIME);
					           $("#BTLLNO").html(n.BTHBILLNO);
					           
						        
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
								ACTION_TYPE : 'getTCDocHead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
								ACTION_MANAGER : 'tcdocQueryManager',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
									enTitle: ['BTHBILLNO','BTHTHMFID','BTHSHTIME','SHPNAME','BTDSL','BTDHSJJJE','BTHSUPID','SUPNAME'],
									cnTitle: ['退厂单号','门店编码','审核日期','门店名称','数量','金额','供应商编码','供应商名称'],
									<%}else{%>
									enTitle: ['BTHBILLNO','BTHTHMFID','BTHSHTIME','SHPNAME','BTDSL','BTDHSJJJE' ],
									cnTitle: ['退厂单号','门店编码','审核日期','门店名称','数量','金额'],
									<%}%>
									sheetTitle: '退厂单查询',
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

<table id="QueryTable" width="930" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">退厂单查询</td>
		<input type="hidden" id="hiddenbtllno" />
		<input type="hidden" id="hiddenshopno" />
	</tr>
	<tr>
		<td  style="border: none;width:250">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：&nbsp;&nbsp;&nbsp;<select
			style="width: 155px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>所有门店</option>
		</select></td>

		<td width="250" style="border: none;">起始日期：&nbsp;&nbsp;<input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'<%if(currUser.getSgcode().equals("3018")&&currUser.getSutype().toString().equalsIgnoreCase("S")){ %>,minDate:'<%=startDate_%>'<% } %>});"size="20" /></td>
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
			<div id="TCDocdatagrid" >
				<table id="TCDoc"></table>
			</div>
		</td>
	</tr>

</table>

<table id="QueryDetailTable" width="900" style="line-height:20px; text-align:left; border:none;font-size: 12px;">
         <tr>
               <td height="24" colspan="2" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">退厂单明细</span></td>
           </tr>
             <tr>
               <td width="180" style="border:none;">退厂单号 ： 
               <span   id="BTLLNO" name="BTLLNO"></span></td>
                <td width="180"  style="border:none;">审核日期 ： 
                 <span   id="shtime" name="shtime"></span></td>
           </tr>
            <tr>
               <td width="180"  style="border:none;">退货门店 ：
               <span   id="shopname" name="shopname"></span>   
               </td>
               
               <td width="180" style="border:none;"><font style="text-align:center;letter-spacing:25px">备注</font> ：
                 <span   id="memo" name="memo"></span>             </td>
           </tr>
             <tr>
               <td width="180"  style="border:none;">供&nbsp;&nbsp;应&nbsp;&nbsp;商&nbsp;&nbsp;：
               <span  id="supname" name="supname"></span>
               </td>
               <td></td>
           </tr>
           <tr><td colspan="2" style="text-align:right"></td></tr>
           <tr><td colspan="2">
           		<table id="TCDocDetail"></table>
           	   </td>
           </tr>
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