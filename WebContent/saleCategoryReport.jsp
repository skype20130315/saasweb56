<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>商品销售类别明细查询</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		//获得经营方式
		String jyfs = currUser.getSuflag() + "";
		System.out.print("---------"+jyfs);
	%>
<style>
a:hover { 
	text-decoration: underline;
	color: red
}
body{
	font-size: 9px;
}
</style>
<script>
		var now = new Date();
		now.setDate( now.getDate() - 7 );
		$("#startDate").val(now.format('yyyy-MM-dd'));	
        $("#endDate").val(new Date().format('yyyy-MM-dd'));
        
		$(function(){
			$('#saleCategory').datagrid({
				width: User.sutype == 'L' ? 778:(User.sgcode=='3009'?594:448),
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'加载数据...',				
				columns:[[
					{field:'GCID',title:'类别编号',width:120,align:'center',sortable:true,formatter:function(value,rec){
					           var gcid = "'" + rec.GCID + "'";
								var supid = "'" + rec.GSSUPID + "'";
						if(User.sgcode=='3009'&&rec.GCID!=null&&rec.GCID!=undefined&&rec.GCID!='合计'){
							return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="showDetail(' + gcid + ','+supid+');">' + value + '</a>';
						}else{
						return value;
						}
						}},
					{field:'GCNAME',title:'类别名称',width:150,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}, // ,sortable:true 排序功能
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'数量小计',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}else{%>
					{field:'GSXSSL',title:'销售数量',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>								
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{
						field:'GSHSJJJE',
						title:'含税成本',
						width:80,
						sortable:true,
						align:'center',
						formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
					},
					<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{
						field:'GSXSSR',
						title:'含税销售收入',
						width:80,
						sortable:true,
						align:'center',
						formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
						}
					<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
						{
						field:'GSXSSR',
						title:'销售金额',
						width:80,
						sortable:true,
						align:'center',
						formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
						}
					<%}else if(!"3027".equals(currUser.getSgcode())){%>
						{
						field:'GSHSJJJE',
						title:<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else if("3031".equals(currUser.getSgcode().toString())){%>'进价金额'<%}else{%>'进价成本'<%}%>,
						width:80,
						sortable:true,
						align:'center',
						formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
						}
					<%}%>
					<%if("3009".equals(currUser.getSgcode().toString())&&"S".equalsIgnoreCase( currUser.getSutype().toString())){%>
					,{field:'GSXSSR',title:'售价金额',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
					<%}%>
					<%if("3027".equals(currUser.getSgcode().toString())){%>
					{field:'GSVENDREBATE',title:'供应商承担折扣',width:70,align:'center',sortable:true}
					<%}%>
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					<%if(currUser.getSgcode().equals("3007")){%>
					,{field:'XSSR',title:'售价金额',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{
						if(currUser.getSgcode().equals("3027")){%>
							,{field:'GSHSJJJE',title:'进价成本',width:80,sortable:true,align:'center',formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});}}
							,{field:'GSXSSR',title:'含税销售收入',width:80,sortable:true,align:'center',formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});}}
						<%}else if(currUser.getSgcode().equals("3031")){%>
						,{field:'GSXSSR',title:'金额小计',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'售价金额',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
					<%}%>
					<%if(("3009".equals(currUser.getSgcode().toString()))){%>
					,{field:'MLL',title:'毛利率',width:70,align:'center',sortable:true}
					<%}%>
					,{field:'GSSUPID',title:'供应商编码',width:100,align:'center',sortable:true,formatter:function(value,rec){
						<%if(currUser.getSgcode().equals("3009")){%>
						if( value != null && value != undefined )
						return (value+'').substring(0,3);
						return '';
						<%}else{%>
						return value;
						<%}%>
					}},	
					{field:'SUPNAME',title:'供应商名称',width:150,align:'center',sortable:true}
					<%
					}
					%>
				]],
				pagination:true,
				rownumbers:true
			});
			
			$('#saleCategoryDetail').datagrid({
				width: 769,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',	
				remoteSort: true,	
				showFooter:true,	
				loadMsg:'加载数据...',				
				columns:[[
					
				    <%if(currUser.getSgcode().equals("3025") || currUser.getSgcode().equals("3033")){%>
				    {field:'GSGDID',title:'商品编码',width:80,align:'center',sortable:true,formatter:function(value,rec){
						return padLeft(value, 6);
					 }},
				    <%}else{%>
				    {field:'GSGDID',title:'商品编码',width:80,align:'center',sortable:true},
				    <%}%>					
					{field:'GDNAME',title:'商品名称',width:150,align:'left',sortable:true},
					{field:'GCNAME',title:'商品类别',width:100,align:'center',sortable:true},
					{field:'GSXSSL',title:'销售数量',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'售价',width:70,align:'center',sortable:true},
					<%}%>				
					{
						field:'GSHSJJJE',title:'进价成本',width:60,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
					}
					,{field:'GSXSSR',title:'售价金额',width:60,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'毛利率',width:60,align:'center',sortable:true}
						,{field:'SUPID',title:'供应商编码',width:80,align:'center',sortable:true},	
						{field:'SUPNAME',title:'供应商名称',width:80,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true
			});
			//如果是供应商用户就隐藏供应商编码输入框，否则显示
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#saleExportExcel").width(778);
				$("#mainTab").width(778);
				$("#mainTabTd").width(318);
				$("#mainTabTdStartDate").width(250);
				$("#mainTabTd").attr("align","right");
				$("#mainTabTd2").attr("align","right");
				$("#saledatagrid").attr("style","margin-left: 0px;display: none;");
			}else{
				$("#supcodeDiv").hide();
			}
			
			
			if(User.sgcode=='3018'){
			 $('#supcode').combobox({
				width: 154,
				valueField:'SUPCODE',
				textField:'SUNAME'
			});	 
			}  
		});
		
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
								ACTION_TYPE : 'getSaleCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
										if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价','售价金额','进价成本','供应商编码','供应商名称'],
										<%}else if("3027".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
											cnTitle: ['类别编号','类别名称','销售数量','含税销售收入','含税成本','供应商编码','供应商名称','供应商承担折扣'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价金额',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价成本'<%}%>,'供应商编码','供应商名称'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['类别编号','类别名称','销售数量','含税成本','供应商承担折扣'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSVENDREBATE'],
											cnTitle: ['类别编号','类别名称','销售数量','含税销售收入','供应商承担折扣'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR' ],
											cnTitle: ['类别编号','类别名称','销售数量','售价','销售金额'],
										<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR' ],
											cnTitle: ['类别编号','类别名称','销售数量','销售金额'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE' ],
											cnTitle: ['类别编号','类别名称','销售数量',<%if("3007".equals(currUser.getSgcode().toString())){%>'预估销售成本'<%}else{%>'进价金额'<%}%>],
										<%}
									}%>
									sheetTitle: '商品销售类别明细查询',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// 门店编码
									supcode : supcode,					// 供应商编码
									userType : User.sutype,				// 用户类型
									gsgcid : $('#gsgcid').attr('value'), // 类别编码
									gsgcname : $('#gsgcname').attr('value'), // 类别名称						
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
	        $('#saleCategory').datagrid('options').url = 'JsonServlet';        
			$('#saleCategory').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategory',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#gsmfid').attr('value'),// 门店编码
							supcode : supcode,					// 供应商编码
							gsgcid : $('#gsgcid').attr('value'), // 类别编码
							userType : User.sutype,				// 用户类型
							gsgcname : $('#gsgcname').attr('value'), // 类别名称							
							startDate : $('#startDate').attr('value'), // 开始日期
							endDate : $('#endDate').attr('value')      // 结束日期
						}]
					}
				)
			};
			$("#saledatagrid").show();         
			$("#saleCategory").datagrid('reload');        
			$("#saleCategory").datagrid('resize');
			$('#shopid_').val('').val($('#gsmfid').val());
			$('#startdate_').val('').val($('#startDate').val());
			$('#enddate_').val('').val($('#endDate').val());
			$('#supcode').combobox('setValue','');  
			
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

		//获取所有类别信息(编码)
		function loadAllCategoryID( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategory',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.CODE + "'>" + n.CODE + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取类别信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		} 		
		
		//获取所有类别信息(名字)
		function loadAllCategory( list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllCategoryname',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.NAME + "'>" + n.NAME + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取类别信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		}   
		
		
			$(function() {
		
			
			
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

		
		//获取所有大类别编码信息（3018需求）
		function loadAllCatId(list ){	
			if( $(list).attr('isLoad') == undefined ){
				$.post( 'JsonServlet',				
					{
						data : obj2str({		
								ACTION_TYPE : 'getAllBigCat',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
								ACTION_MANAGER : 'saleSummary',		 
								list:[{
									gssgcode : User.sgcode
								}]
						})
					}, 
					function(data){
	                    if(data.returnCode == '1' ){	                         
	                    	 if( data.rows != undefined && data.rows.length > 0 ){
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
						            var html = "<option value='" + n.GCID + "'>" + n.GCID + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('提示','获取类别信息失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	
		}   	
		$().ready(function(){
			if("<%=currUser.getSucode()%>".substring(0,4) == "3006"){
				$("#mainTabTd").css("display","none");
				$("#gsgcid11").css("display","none");
				$("#gsgcname11").css("display","none");
				$("#mainTabTd2").css("display","none");
			}
		});
		
		  function backgrid ()  {     		
    		$("#saledatagrid").show(); 
    		$("#sure_button").show();
			$("#saleCategoryDetail2").hide();    	 
    	}  
    	function showDetail(gcid,supid){
    	
    	  $('#saleCategoryDetail').datagrid('options').url = 'JsonServlet';        
			$('#saleCategoryDetail').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategoryDetail',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#shopid_').val(),// 门店编码
							supcode : supid,					// 供应商编码
							gsgcid :gcid, // 类别编码
							startDate : $('#startdate_').val(), // 开始日期
							endDate : $('#enddate_').val()      // 结束日期
						}]
					}
				)
			};
			$("#saledatagrid").hide();
			$("#sure_button").hide();
			$("#saleCategoryDetail2").show();                  
			$("#saleCategoryDetail").datagrid('reload');        
			$("#saleCategoryDetail").datagrid('resize');
    	} 
	</script>
</head>
<body>
<center>
<!-- ---------- 查询条件输入区开始 ---------- -->
<table width="740" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">销售商品类别查询<%if(currUser.getSgcode().equals("3007")){%>( 说明：预估销售成本是以商品的最新进价进行核算,和月结后的成本可能不一样)<%}%></td>
	</tr>
	<tr>
		<td width="230" id="mainTabTdStartDate" style="border: none;">
			起始日期：<input type="text" id="startDate" name="startDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" />
		</td>
		<td width="230" style="border: none;">
			结束日期：<input type="text" id="endDate" name="endDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td id="mainTabTd" width="280" style="border: none;">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：
			<select style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
				<option value=''>所有门店</option>
			</select>
		</td>
	</tr>
	<tr>
		<td style="border: none;" id="gsgcid11">
			类别编码：
			<%if("3018".equals(currUser.getSgcode())){%>
				<select style="width: 150px;" id="gsgcid" name="gsgcid" size="1" onclick="loadAllCatId(this);">
				<option>所有类别</option>
				</select>
			<%}else if("3034".equals(currUser.getSgcode())){%>
                <select style="width: 150px;" id="gsgcid" name="gsgcid" size="1" onclick="loadAllCategoryID(this);">
				<option value=''>所有类别</option>
				</select>			
			<%}else{%>
				<input type="text" id="gsgcid" name="gsgcid" width="110" value="" />
			<%}%>
			
		</td>
		  <td id='gsgcname11' style="border: none;" style="border: none;">
		   类别名称：
		  <%if("3034".equals(currUser.getSgcode())){%>
            <select style="width: 150px;" name='gsgcname' id="gsgcname" size='1' onclick="loadAllCategory(this);">
				<option value=''>所有类别</option>
			</select>
		  <%}else{%>
		    <input type="text" name='gsgcname' id='gsgcname' />
		  <%} %>
		</td>
		<td style="border: none;" id="mainTabTd2">
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">供应商编码：<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto" /></div>
			<%}else{%>
			<div id="supcodeDiv" style="">供应商编码：<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
			<%} %>
		</td>
	</tr>
	<tr>
		<td colspan="3" style="border: none;" align="left">
		    <img src="images/sure.jpg" border="0" onclick="reloadgrid();" />
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- table 中显示列表的信息 -->
			<div id="saledatagrid" style="display: none;margin-left: 70px;">
			<%if(!currUser.getSgcode().equals("3009")){ %>
				<div id="saleExportExcel" align="right" style="color: #336699; width: 448px;">
					<a href="javascript:exportExcel();">>>导出Excel表格</a>
				</div>
				<%}%>
				<table id="saleCategory"></table>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
		    <div id="shopid_" style="display: none"></div>
			<div id="startdate_" style="display: none"></div>
			<div id="enddate_" style="display: none"></div>
			<div id="saleCategoryDetail2" style="display: none;">
				<table id="saleCategoryDetail"></table>
				<div style="text-align: left; margin-top: 10px;">
					<img src="images/goback.jpg" border="0" onclick="backgrid();" />
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