<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>优惠单查询</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("当前用户已超时,请重新登陆!");
		out.println("<a href='login.jsp' >点此登录</a>");
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sucode= currUser.getSucode();
%>
<script type="text/javascript">
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val( now.format('yyyy-MM-dd') );
		$("#endDate").attr("value",new Date().format('yyyy-MM-dd'));
		$("#POPdatagrid").hide();
		
		$(function(){
			$('#POP').datagrid({
				//width:930,
				width: User.sutype == 'S' ? 830 : 930,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'POPSEQUECE',title:'优惠单号',width:110,align:'center',sortable:true},
				     <%
					if("3015".equalsIgnoreCase( currUser.getSgcode())){
					%>
						{field:'PPLB',title:'促销类型',width:70,align:'center',sortable:true},
					<%}%>
				    <%
					if("3004".equalsIgnoreCase( currUser.getSgcode()) || "3023".equalsIgnoreCase( currUser.getSgcode())){
					%>
						{field:'DZLX',title:'打折类型',width:70,align:'center',sortable:true},
					<%}else if("3006".equalsIgnoreCase( currUser.getSgcode())){
					%>	
						{field:'PPMARKET',title:'门店编号',width:100,align:'center',sortable:true},
					<%	
					}else{%>
						{field:'PPMARKET',title:'门店编号',width:60,align:'center',sortable:true},
				    	{field:'SHOPNAME',title:'门店名称',width:100,align:'center',sortable:true},
					<%}%>
				    
				    {field:'PPGDID',title:'商品编码',width:100,sortable:true},				
				
				    <%if("3010".equalsIgnoreCase( currUser.getSgcode())){%>
				     {field:'BARCODE',title:'商品条码',width:80,sortable:true},<%}%>
				    {field:'GDNAME',title:'商品名称',width:100,sortable:true},
				    {field:'PPKSRQ',title:'开始日期',width:65,align:'center',sortable:true},
				    {field:'PPJSRQ',title:'结束日期',width:65,align:'center',sortable:true},
				    {field:'PPCXSJ',title:'促销售价',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
				    
				     {field:'PPYSSJ',title:'原销售单价',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'PPSUPID',title:'供应商编码',width:80,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:100,align:'center',sortable:true}
					<%}%>
				]],
				pagination:true,
				rownumbers:true
			});
			
			//如果是供应商用户就隐藏供应商编码输入框，否则显示
			if(User.sutype == 'L'){
				$("#sup").show();
			}else{
				$("#sup").hide();
			}
			
			if(User.sgcode=='3018'){
			 $('#supcodequery').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
		}
		);
        
		function reloadgrid ()  {
        	//验证用户输入日期是否合法？
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('提示','请输入开始或结束日期！！！','info');
				return;
			} 
			//根据用户是供应商还是零售商，获取供应商编码  
			//alert(User.sgcode);
			
			
			
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcodequery').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcodequery').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //查询参数直接添加在queryParams中
	        $('#POP').datagrid('options').url = 'JsonServlet';        
			$('#POP').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getPOP',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
						ACTION_MANAGER : 'popQueryManager',	
						list:[{
							sgcode : User.sgcode,
							popsupcode : supcode,
							popgdid : $('#gdid').attr('value'),//商品编码
							popgdname : $('#gdname').attr('value'),//商品名称
							popmarket : $('#shopcode').attr('value'),// 门店编码
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#POPdatagrid").show();
			$("#POP").css("display","");
			$("#POP").datagrid('reload'); 
			$("#POP").datagrid('resize'); 
				$('#supcodequery').combobox('setValue','');
    	}
    	
	    function padLeft(str, lenght) {
            if (str.length >= lenght)
                return str;
            else
                return padLeft("0" + str, lenght);
        }   
  
    	function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcodequery').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcodequery').val();
				
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getPOP',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.POPQuery',
								ACTION_MANAGER : 'popQueryManager',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
									enTitle: ['POPSEQUECE'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'PPLB'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'DZLX'" : ",'PPMARKET'"%>,'PPGDID','GDNAME','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ','PPSUPID','SUPNAME'],
									cnTitle: ['优惠单号'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'促销类型'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'打折类型'" : ",'门店编码'"%>,'商品编码','商品名称','开始日期','金结束日期','促销售价','原销售单价','供应商编码','供应商名称'],
									<%}else{%>
									enTitle: ['POPSEQUECE'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'PPLB'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'DZLX'" : ",'PPMARKET'"%>,'PPGDID','GDNAME','PPKSRQ','PPJSRQ','PPCXSJ','PPYSSJ' ],
									cnTitle: ['优惠单号'<%="3015".equalsIgnoreCase(currUser.getSgcode()) ? ",'促销类型'" : ""%><%="3004".equalsIgnoreCase(currUser.getSgcode()) || "3023".equalsIgnoreCase(currUser.getSgcode()) ? ",'打折类型'" : ",'门店编码'"%>,'商品编码','商品名称','开始日期','金结束日期','促销售价','原销售单价'],
									<%}%>
									sheetTitle: '商品优惠单查询',
									sgcode : User.sgcode,
									popsupcode : supcode,
									popgdid : $('#gdid').attr('value'),//商品编码
									popgdname : $('#gdname').attr('value'),//商品名称
									popmarket : $('#shopcode').attr('value'),// 门店编码 
									startDate : $('#startDate').attr('value'),
									endDate : $('#endDate').attr('value')
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
		$().ready(function(){
			if("<%=sucode%>".substring(0,4) == "3006"){
				$("#MD").css("display","none");
			}
		});
		
		
		$(function(){
		
		
			
			if( !$('#supcodequery').data('isLoad') ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getReceivers',
								ACTION_CLASS : 'com.bfuture.app.saas.model.MsgMessage',
								ACTION_MANAGER : 'msgManager',
								list:[{
									id : ''
								}]
						})
						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){ 
	                    	 if( data.rows ){
	                    	 	$('#supcodequery').combobox('loadData', data.rows );
	                    	 }
	                    }else{ 
	                        $.messager.alert('提示','获取接收人失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}
		
		}	);	
 	</script>
</head>
<body>
<center>

<table id="QueryTable" width="960" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">商品优惠单查询</td>
	</tr>
	<tr>
		<td id="MD" style="border: none;width:250"><font style="text-align:center;letter-spacing:25px">门店</font>： <select
			style="width: 154px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>所有门店</option>
		</select></td>

		<td  style="border: none;width:250">起始日期： <input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20" /></td>
		<td  style="border: none;width:280"><font style="text-align:center;letter-spacing:3px">结束日期：</font> <input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
			<td  style="border:none;width: 250px;">商品编码：
			<input type="text" id="gdid" name="gdid" size="20"/>
        	</td>
	        <td  style="border:none;width: 250px;">商品名称：
	        <input type="text" id="gdname" name="gdname" size="20"/>
	        </td>
	        <%if("3018".equals(currUser.getSgcode())){%>
		    <td id="sup"  style="border:none;width:250px;">供应商编码：
			<input class="easyui-combobox"  id="supcodequery" name="supcodequery" size="20" panelHeight="auto"/>
			
			</td>
			<%}else{%>
			 <td id="sup"  style="border:none;width:250px;">供应商编码：
			<input type="text" id="supcodequery" name="supcodequery" size="20"/></td>
			<%} %>
			
	
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
			<div id="POPdatagrid" >
				<div  align="right" style="color: #336699; width: <%="S".equalsIgnoreCase(currUser.getSutype().toString()) ? "750" : "930" %>px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a></div>
				<table id="POP"></table>
			</div>
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