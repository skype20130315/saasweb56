<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品销售明细查询</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		String sucode= currUser.getSucode();
		//获得经营方式
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>
<style>
a:hover {
	text-decoration: underline;
	color: red
}
</style>
<script><!--
	    var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
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
		//获取所有品牌信息
		function loadAllBrand( list ){
			if( $(list).attr('isLoad') == undefined ){
				
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllBrand',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',	
								list:[{									
									sgcode : User.sgcode
								}]
						})
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.GDPPNAME + "'>" + n.GDPPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取品牌信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}
		
		$(function(){
			if("<%=sucode%>".substring(0,4) == "3005" || "<%=sucode%>".substring(0,4) == "3004"){
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'GDBARCODE',title:'商品条码',width:120,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '合计'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
				    },
				    {field:'GDID',title:'商品编码',width:60,align:'center',sortable:true},	
				    {field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'规格',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},
				    <%if(currUser.getSgcode().equals("3025")){%>			    
					{field:'GSXSSL',title:'销售数量',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if(currUser.getSgcode().equals("3031")){%>
					{field:'GSXSSL',title:'数量小计',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能
					<%}else{%>
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能					
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>
					<%if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSJE',title:'进价金额',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
					}}
					<%}else{%>
					{field:'GSXSJE',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>		
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
						if("3031".equals(currUser.getSgcode().toString())){%>
						,{field:'GSXSSR',title:'金额小计',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3009"){
			$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1010 : 888,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'GSRQ',title:'销售日期',width:80,align:'center',sortable:true},
				    {field:'GDBARCODE',title:'商品条码',width:60,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '合计'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
			        {field:'GDID',title:'商品编码',width:60,align:'center',sortable:true},
				    {field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'规格',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},	
				    <%if("3031".equals(currUser.getSgcode().toString())){%>
				    {field:'GSXSSL',title:'数量小计',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能
				    <%}else{%>
				    {field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能
				    <%}%>			    					
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if(value != null && value != undefined) 
							return (value+'').substring(0,3);
							return '';
						}},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3006") {
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'GSRQ',title:'销售日期',width:80,align:'center',sortable:true},
				    
			        {field:'GDID',title:'商品编码',width:100,align:'center',sortable:true//,
//			        	formatter:function(value,rec){
//			        		if (value == null || value == 'null')
//			        		{
//			        			return '';
//			        		}else
//			        		{
//			        			var gdid = "'" + rec.GDID + "'";
//			        			var supid = "'" + rec.GSSUPID + "'";
//			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
//			        		}						
//						}
			        },
				    {field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'规格',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3022" || "<%=sucode%>".substring(0,4) == "3024") {
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'GSRQ',title:'销售日期',width:80,align:'center',sortable:true},
				    {field:'GDBARCODE',title:'商品条码',width:60,align:'center',sortable:true},
			        {field:'GDID',title:'商品编码',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
				    {field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'规格',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}else if("<%=sucode%>".substring(0,4) == "3026") {///3026
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 660,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				    {field:'GSRQ',title:'销售日期',width:90,align:'center',sortable:true}, 
			        {field:'GDID',title:'商品编码',width:100,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
				    {field:'GDNAME',title:'商品名称',width:200,align:'center',sortable:true}, 
				    {field:'GDUNIT',title:'单位',width:80,align:'center',sortable:true},				    
					{field:'GSXSSL',title:'销售数量',width:90,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					{field:'GSXSJE',title:'进价成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:250,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			}////3026
			else{
				$('#saleDetail').datagrid({
				width:  User.sutype == 'L' ? 1110 : 850,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',		
				singleSelect: true,
				remoteSort: true,
				showFooter:true,
				loadMsg:'加载数据...',				
				columns:[[
				   <%if(!currUser.getSgcode().equals("3018")){%>
				    {field:'GSRQ',title:'销售日期',width:80,align:'center',sortable:true},
				    <%}%>
				    {field:'GDBARCODE',title:'商品条码',width:<%if(currUser.getSgcode().equals("3018")){%>190<%}else{%>110<%}%>,align:'center',sortable:true,
			        	formatter:function(value,rec){
			        		if (value == null || value == 'null')
			        		{
			        			return '';
			        		}else if(value == '合计'){
			        			return value;
			        		}			  
			        		else
			        		{
			        			var gdid = "'" + rec.GDID + "'";
			        			var supid = "'" + rec.GSSUPID + "'";
			        			if("<%=sucode%>".substring(0,4) == "3034"){
                                 return value;
                                }
			        			return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="reloadItemStockgrid(' + gdid + ','+supid+');">' + value + '</a>';
			        		}						
						}
			        },
			        {field:'GDID',title:'商品编码',width:60,align:'center',sortable:true},
				    {field:'GDNAME',title:'商品名称',width:200,align:'left',sortable:true},				    
				    {field:'GDSPEC',title:'规格',width:60,align:'center',sortable:true},
				    {field:'GDUNIT',title:'单位',width:60,align:'center',sortable:true},	
				    <%if("3031".equals(currUser.getSgcode().toString())){%>
				    {field:'GSXSSL',title:'数量小计',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
				    <%}else{%>
				    {field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能
				    <%}%>			    	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSJE',title:'含税成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{field:'GSXSSR',title:'含税销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					<%}if("3027".equals(currUser.getSgcode())){%>
						{field:'GSVENDREBATE',title:'供应商承担折扣',width:100,align:'center',sortable:true}
					<%}else if(!"3027".equals(currUser.getSgcode())){%>
					{field:'GSXSJE',title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else if("3031".equals(currUser.getSgcode().toString())){%>'进价金额'<%}else{%>'进价成本'<%}%>,width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					<%if(currUser.getSgcode().equals("3007")){%>
					,{field:'XSSR2',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{if(currUser.getSgcode().equals("3027")){%>
						,{field:'GSXSJE',title:'含税成本',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'GSXSSR',title:'含税销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else if(currUser.getSgcode().equals("3031")){%>
					,{field:'GSXSSR',title:'金额小计',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{%>
					,{field:'GSXSSR',title:'销售收入',width:100,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					<%}%>
						,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
			}
			
			
			//
			$('#itemStock').datagrid({
				width:  User.sutype == 'L' ? 935 : 685,
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
					{field:'KCRQ',title:'库存日期',width:100,align:'center',sortable:true},
					{field:'SHPCODE',title:'门店编码',width:100,align:'center',sortable:true},
				    {field:'SHPNAME',title:'门店名称',width:300,align:'center',sortable:true},	
				    <%if("3029".equals(currUser.getSgcode().toString()) && "S".equals(currUser.getSutype()+"")){%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true,formatter:function(value,rec){
							if(parseFloat(value)>0){
								return value;
							}else{
								return 0;
							}
						}},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined && parseFloat(value)>0){
								return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});
							}else{
								return 0;
							}
						}}
					<%}else{%>
						{field:'ZSKCSL',title:'库存数量',width:55,align:'center',sortable:true},
						{field:'ZSKCJE',title:'库存进价金额',width:150,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}%>
					 <%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
						,{field:'SSUPID',title:'供应商编码',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>	
				]],
				pagination:true,
				rownumbers:true
			});
			//如果是供应商用户就隐藏供应商编码输入框，否则显示
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(1110);
				$("#mainTab").width(1110);
				$("#mainTabTd").width(380);
				$("#mainTabStartDateTd").width(450);
			}else{
				$("#supcodeDiv").hide();
			}
		});		
		
		function exportExcel(){
			//根据用户是供应商还是零售商，获取供应商编码
		  var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'getSaleDetail',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3006".equals(currUser.getSgcode())){
									%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['销售日期','商品编码','商品名称','供应商编码','供应商名称','规格','单位','销售数量','销售收入','进价成本'],
									<%}else if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
										cnTitle: ['商品编码','商品名称','供应商编码','供应商名称','规格','单位','销售数量','销售收入','进价成本'],
									<%}else if("3026".equals(currUser.getSgcode())){%>
									enTitle: ['GDID','GDNAME','GSSUPID','SUPNAME','GDUNIT','GSXSSL','GSXSSR','GSXSJE' ],
									cnTitle: ['商品编码','商品名称','供应商编码','供应商名称','单位','销售数量','销售收入','进价成本'],
									<%}else if("3027".equals(currUser.getSgcode())){%>
									enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSXSJE','GSVENDREBATE' ],
									cnTitle: ['销售日期','商品编码','商品名称','商品条码','供应商编码','供应商名称','规格','单位','销售数量','含税销售收入','含税成本','供应商承担折扣'],
									<%
									}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDBARCODE','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['销售日期','商品编码','商品名称','商品条码','供应商编码','供应商名称','规格','单位','销售数量','售价','销售收入'],
									<%
									}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['销售日期','商品编码','商品名称','供应商编码','供应商名称','规格','单位','数量小计','金额小计'],
									<%}else{%>
										enTitle: ['GSRQ','GDID','GDNAME','GSSUPID','SUPNAME','GDSPEC','GDUNIT','GSXSSL','XSSR' ],
										cnTitle: ['销售日期','商品编码','商品名称','供应商编码','供应商名称','规格','单位','销售数量','销售收入'],
									<%
									}
									}else{
										if("3018".equals(currUser.getSgcode())){%>
										enTitle: ['GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['商品编码','商品名称','规格','单位','销售数量','进价成本'],
									<%}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE','GSVENDREBATE'],
											cnTitle: ['销售日期','商品编码','商品名称','规格','单位','销售数量','含税成本','供应商承担折扣'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','XSSR','GSVENDREBATE'],
											cnTitle: ['销售日期','商品编码','商品名称','规格','单位','销售数量','含税销售收入','供应商承担折扣'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','TEMP5','XSSR' ],
										cnTitle: ['销售日期','商品编码','商品名称','规格','单位','销售数量','售价','销售收入'],
									<%}else if("3031".equals(currUser.getSgcode())){%>
										enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
										cnTitle: ['销售日期','商品编码','商品名称','规格','单位','数量小计','金额小计'],
									<%}else{%>
											enTitle: ['GSRQ','GDID','GDNAME','GDSPEC','GDUNIT','GSXSSL','GSXSJE' ],
											cnTitle: ['销售日期','商品编码','商品名称','规格','单位','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>],
										<%}
									}
									}%>
									sheetTitle: '商品销售明细查询',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// 门店编码
									supcode : supcode,					// 供应商编码						
									gsgdid : $('#gsgdid').attr('value'), // 商品编码
									gsgdname : $('#gsgdname').attr('value'), // 商品名称
									gdbarcode : $('#gdbarcode').attr('value'), // 商品条码
									startDate : $('#startDate').attr('value'),//开始日期
									endDate : $('#endDate').attr('value')     //结束日期
									//,
									//category : $("#category").val() //品牌名称
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
		
		function reloadgrid ()  {
			//根据用户是供应商还是零售商，获取供应商编码  
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //查询参数直接添加在queryParams中
	        $('#saleDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							gssgcode : User.sgcode,
							supcode : supcode,
							gsmfid : $('#gsmfid').attr('value'),// 门店编码
							gsgdid : $('#gsgdid').attr('value'), // 商品编码
							gdbarcode : $('#gdbarcode').attr('value'), // 商品编码
							gsgdname : $('#gsgdname').attr('value'), // 商品编码
							startDate : $('#startDate').attr('value'),
							endDate : $('#endDate').attr('value')
						}]
					}
				)
			};		
			$("#itemStockdatagrid").hide();
			$("#saledatagrid").show();
			$("#saleDetail").datagrid('reload'); 
			$("#saleDetail").datagrid('resize'); 
			$('#supcode').combobox('setValue','');
			
    	}
    	
    	function reloadItemStockgrid (value,SUPID)  { 
    		//根据用户是供应商还是零售商，获取供应商编码 
    		//var supcode = '';
			//if(User.sutype == 'L'){
			//	supcode = $("#supcode").val();
			//}else{
			//	supcode = User.supcode;
			//}
	        //查询参数直接添加在queryParams中
	        $('#itemStock').datagrid('options').url = 'JsonServlet';        
			$('#itemStock').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getGoodsStock',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Stock',
						ACTION_MANAGER : 'saleSummary',		 
						list:[{
							sgcode : User.sgcode,
							supcode : SUPID,
							startDate : $('#startDate').attr('value'),	// 起始时间
							endDate : $('#endDate').attr('value'), 		// 结束时间
							zsmfid : $('#gsmfid').attr('value'),	
							zsgdid : value					
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#itemStockdatagrid").show();
			$("#itemStock").datagrid('reload');
			$("#itemStock").datagrid('resize');  
    	}
    	
    	function backgrid ()  {     		
    		$("#itemStockdatagrid").hide(); 
			$("#saledatagrid").show();    	 
    	}   
    	
    	
    		$(function() {
		
			$('#supcode').combobox('setValue','');
			
			if( !$('#supcode').data('isLoad') ){
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
	                    	 	$('#supcode').combobox('loadData', data.rows );
	                    	 }
	                    }else{ 
	                        $.messager.alert('提示','获取接收人失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}
		
		}	);	
    	   
 	--></script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="860" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售商品明细查询<%if(currUser.getSgcode().equals("3007")){%>( 说明：预估销售成本是以商品的最新进价进行核算,和月结后的成本可能不一样)<%}%></td>
	</tr>
	<tr>
		<td id="mainTabStartDateTd" width="280" style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;起始日期：<input
			type="text" id="startDate" required="true" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" /></td>
		<td width="280" style="border: none;">结束日期：<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
		<td id="mainTabTd" width="300" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：<select
			style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
			<option value=''>所有门店</option>
		</select></td>
	</tr>
	<tr>
		<td style="border: none;">&nbsp;&nbsp;&nbsp;&nbsp;商品编码：<input type="text" id="gsgdid" name="gsgdid"/></td>
		<td style="border: none;">商品名称：<input type="text" id="gsgdname" name="gsgdname"/></td>
		<td style="border: none;">商品条码：<input type="text" id="gdbarcode" name="gdbarcode"/></td>
	</tr>
	<tr>
		<td style="border: none;">
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">供应商编码：<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto"/></div>
			<%}else{%>
			<div id="supcodeDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	<tr>
		<td style="border: none;" align="left">
			<img src="images/sure.jpg" border="0" onClick="reloadgrid();" />
		</td>
		<td style="border: none;" ></td>
		<td style="border: none;"></td>
	</tr>
	
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;">
			<%if(!currUser.getSgcode().equals("3009")){%>
				<div id="saleExportExcel" align="right" style="color: #336699; width: 850px">
					<a href="javascript:exportExcel();">>>导出Excel表格</a></div>
					<%}%>
				<table id="saleDetail"></table>
			</div>
		</td>
	</tr>
	
	<tr>
		<td colspan="3">
			<div id="itemStockdatagrid" style="display: none;margin-left: 90px;">
				<table id="itemStock"></table>
				<div style="text-align: left; margin-top: 10px;">
					<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-back" onClick="backgrid();">返回</a>-->
					<img src="images/goback.jpg" border="0" onClick="backgrid();" />
				</div>
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