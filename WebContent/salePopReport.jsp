<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
	%>

<title>促销商品销售日汇总</title>
<style>  
a:hover { 
	text-decoration: underline;
	color: red
}
</style>
<script>	 
		var now = new Date();
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'))
	    
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
		
		$(function(){
			$('#saleShopSummary').datagrid({	
			    title: '',	
				width:836,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',			
				showFooter:true,	
				remoteSort: true,	
				singleSelect: true,	
				loadMsg:'加载数据...',			
				columns:[[
					{field:'SGLMARKET',title:'门店编码',width:80,align:'center',sortable:true},
					{field:'SHPNAME',title:'门店名称',width:80,align:'center',sortable:true},
					{field:'SGLBARCODE',title:'商品条码',width:100,align:'center',sortable:true},
				    {field:'SGLGDID',title:'商品编码',width:100,align:'center',sortable:true},	
				    {field:'GBCNAME',title:'商品名称',width:200,align:'left',sortable:true},
				    <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					{field:'SGLSUPID',title:'供应商编码',width:100,align:'center',sortable:true},
					{field:'SUPNAME',title:'供应商名称',width:200,align:'center',sortable:true},
				    <%
					}
					%>
					{field:'SGLSL',title:'销售数量',width:80,align:'center',sortable:true},
					{field:'SGLXSSR',title:'销售收入',width:80,align:'center',sortable:true},
					{field:'SGLTOTZK',title:'总折扣',width:80,align:'center',sortable:true},
					{field:'SGLSUPZK',title:'供应商总折扣',width:80,align:'center',sortable:true},
					{field:'SGLPOPZK',title:'促销折扣',width:80,align:'center',sortable:true},
					{field:'SGLN1',title:'总毛利',width:80,align:'center',sortable:true}
						
				]],
				pagination:true,
				rownumbers:true	
			});
			
			//如果是零售商，就显示供应商输入框
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(836);
			}else{
				$("#supcodeDiv").hide();
			}
		});		
		
		
		//查询
		function reloadgrid ()  {  
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#supcode").val();
			}else{
				supcode = User.supcode;
			}  
	        //查询参数直接添加在queryParams中
	        $('#saleShopSummary').datagrid('options').url = 'JsonServlet';        
			$('#saleShopSummary').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsalepop',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),        //门店
							gsgdid : $('#gdgdid').attr('value'),        //商品代码
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value') 		// 结束时间
						}]
					}
				)
			};	
			$("#saledatagrid").show();
			$("#saleShopSummary").datagrid('reload');  
			$("#saleShopSummary").datagrid('resize');  
    	}
    	
    	function exportExcel(){
    		//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $("#supcode").val();
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getGoodsalepop',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,									
									enTitle: ['SGLMARKET','SHPNAME','SGLBARCODE','SGLGDID','GBCNAME','SGLSUPID','SUPNAME','SGLSL','SGLXSSR','SGLTOTZK','SGLSUPZK','SGLPOPZK','SGLN1'],
									cnTitle: ['门店编号','门店名称','商品条码','商品编码','商品名称','供应商编码','供应商名称','销售数量','销售收入','总折扣','供应商总折扣','促销折扣','总毛利'],
									sheetTitle: '商品销售明细查询',
									gssgcode : User.sgcode,
									supcode : supcode,
									gsmfid : $('#gsmfid').attr('value'),        //门店
									gsgdid : $('#gdgdid').attr('value'),        //商品代码
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
			}else{
				supcode = User.supcode;
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getGoodsalepop',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,									
									enTitle: ['SGLMARKET','SHPNAME','SGLBARCODE','SGLGDID','GBCNAME','SGLSUPID','SUPNAME','SGLSL','SGLXSSR','SGLTOTZK','SGLSUPZK','SGLPOPZK','SGLN1'],
									cnTitle: ['门店编号','门店名称','商品条码','商品编码','商品名称','供应商编码','供应商名称','销售数量','销售收入','总折扣','供应商总折扣','促销折扣','总毛利'],
									sheetTitle: '商品销售明细查询',
									gssgcode : User.sgcode,
									supcode : supcode,
									gsmfid : $('#gsmfid').attr('value'),        //门店
									gsgdid : $('#gdgdid').attr('value'),        //商品代码
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
			
    	}  	     	
	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">促销商品销售日汇总</td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">起始日期：<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">&nbsp;&nbsp;结束日期：<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" align="right" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店： <select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>所有门店</option>
		</select></td>
	</tr>
	<tr>
		<td width="250" style="border: none;">商品代码：<input type="text" id="gdgdid" name="gdgdid" width="110" value="" /></td>
		<td style="border: none;" align="left" >
			<div id="supcodeDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
				<div id="saleExportExcel" align="right" style="color: #336699; width: 850px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a>
				</div>
				<table id="saleShopSummary" width="786" ></table>
			</div>
		</td>
	</tr>
</table>
</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>





