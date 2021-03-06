<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品库存明细查询</title>
<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		String suType = currUser.getSutype() + " " ;
	%>
	
	
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script type="text/javascript">

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
			$('#stockDetail').datagrid({
				width: User.sutype == 'L' ? 1022:817,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',
				sortOrder: 'desc',
				remoteSort: true,	
				singleSelect : true,
				fitColumns:false,
				showFooter:true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'ZSGXTIME',title:'库存统计日期',width:80,align:'center',sortable:true,
						   formatter:function(value,rec){
							if( value != null && value != undefined && value != '合计：' )
								return new Date(value.time).format('yyyy-MM-dd');
								else 
								return value;
						}
					},
					{field:'SHPCODE',title:'门店编码',width:60,align:'center',sortable:true}, 
					{field:'SHPNAME',title:'门店名称',width:188,align:'center',sortable:true},
					{field:'GDID',title:'商品编码',width:60,align:'center',sortable:true},
					{field:'GDBARCODE',title:'商品条码',width:100,align:'center',sortable:true},
					{field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},
					{field:'GDSPEC',title:'规格',width:45,align:'center',sortable:true},
					{field:'GDUNIT',title:'单位',width:45,align:'center',sortable:true},
					{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true},
					{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true}
					<%if("L".equals(suType)){%>
					,{field:'SUPID',title:'供应商编码',width:70,align:'center',sortable:true},	
					{field:'SUPNAME',title:'供应商名称',width:160,align:'center',sortable:true}
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
			if(User.sutype == 'L'){
				$("#zssupidDiv").show();
			}else{
				$("#zssupidDiv").hide();
			}
		});		
		
		function reloadgrid ()  {
		//根据用户是供应商还是零售商，获取供应商编码
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcode').val();
			}else {
				supcode = User.supcode;
			}
	        $('#stockDetail').datagrid('options').url = 'JsonServlet';        
			$('#stockDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'ywZrstockDetails',		 
						optType : 'query',
						optContent : '昨日库存商品明细查询',		 
						list:[{
						 sgcode : User.sgcode,
						 supcode : supcode,
						 zsmfid : $('#zsmfid').attr('value'),
						 zsgdid : $('#zsgdid').attr('value'),
						 zsgdname : $('#zsgdname').attr('value'),
						 gdbarcode :$('#gdbarcode').attr('value')
						}]
					}
				)
			};		
			
			document.getElementById("saledatagrid").style.display="";
			$("#stockDetail").datagrid('reload'); 
			$("#stockDetail").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
		
    	}
    	function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcode').val();
			}else {
				supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'datagrid',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
								ACTION_MANAGER : 'ywZrstockDetails',											 
								list:[{
									exportExcel : true,
									<%if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){%>
									enTitle: ['SHPCODE','ZSGXTIME','SHPNAME','GDID','GDBARCODE','GDNAME','GDSPEC','GDUNIT','SUPID','SUPNAME','ZSKCSL','ZSKCJE' ],
									cnTitle: ['门店编号','库存统计日期','门店名称','商品编码','商品条码','商品名称','规格','单位','供应商编码','供应商名称','库存数量','库存金额(不含税)'],
									<%}else{%>
									enTitle: ['SHPCODE','ZSGXTIME','SHPNAME','GDID','GDBARCODE','GDNAME','GDSPEC','GDUNIT','ZSKCSL','ZSKCJE' ],
									cnTitle: ['门店编号','库存统计日期','门店名称','商品编码','商品条码','商品名称','规格','单位','库存数量','库存金额(不含税)'],
									<%}%>
									sheetTitle: '昨日库存商品明细查询',
									sgcode : User.sgcode,
									supcode : supcode,
									zsmfid : $('#zsmfid').attr('value'),
									zsgdid : $('#zsgdid').attr('value'),
									zsgdname : $('#zsgdname').attr('value')
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
    	function reset(){
    	    $("#zsmfid").val('');
			$("#zsgdname").val('');
			$("#zsgdid").val('');
			$("#supcode").val('');
			
    	}   
 	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="900"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">昨日库存商品明细查询</td>
	</tr>
	<tr>
		<td width="300" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：<select
			style="width: 155px;" name='zsmfid' id="zsmfid" size='1'>
			<option value=''>所有门店</option>
		</select></td>
		<td width="300" style="border: none;">商品名称：<input
			type="text" id="zsgdname" name="zsgdname" value="" size="20"
			/></td>
		<td width="300" style="border: none;">商品编码：<input type="text"
			id="zsgdid" name="zsgdid" value="" size="20"
			/></td>
	</tr>

	<tr>
	
	<td width="300" style="border: none;">
		<div id="zssupidDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
	</td>
	<td width="300" style="border: none;">商品条码：<input type="text" id="gdbarcode" name="gdbarcode" value="" size="20" /></td>
	<td style="border: none;">&nbsp;</td>	
	</tr>
	<tr>
	<td style="border: none;">
		<img src="images/sure.jpg" border="0" onclick="reloadgrid();" />     
		<img src="images/back.jpg" border="0" onclick="reset();" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="saledatagrid" style="display: none;">
				<table id="stockDetail" ></table>
			</div>
		</td>
		</tr>
	
</table>

</center>
</body>
<script type="text/javascript">
// 加载门店
var obj = document.getElementById("zsmfid");
loadAllShop(obj);
</script>
</html>