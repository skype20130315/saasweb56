<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��Ʒ���������ϸ��ѯ</title>
	<%
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
		//��þ�Ӫ��ʽ
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
				loadMsg:'��������...',				
				columns:[[
					{field:'GCID',title:'�����',width:120,align:'center',sortable:true,formatter:function(value,rec){
					           var gcid = "'" + rec.GCID + "'";
								var supid = "'" + rec.GSSUPID + "'";
						if(User.sgcode=='3009'&&rec.GCID!=null&&rec.GCID!=undefined&&rec.GCID!='�ϼ�'){
							return '<a href="#" style="color:#4574a0; font-weight:bold;" onClick="showDetail(' + gcid + ','+supid+');">' + value + '</a>';
						}else{
						return value;
						}
						}},
					{field:'GCNAME',title:'�������',width:150,align:'center',sortable:true},
					<%if("3025".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}, // ,sortable:true ������
					<%}else if("3031".equals(currUser.getSgcode().toString())){%>
					{field:'GSXSSL',title:'����С��',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}else{%>
					{field:'GSXSSL',title:'��������',width:70,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 3,thousandsSeparator :','
								});
						}},
					<%}%>	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>								
					<%if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
						{
						field:'GSHSJJJE',
						title:'��˰�ɱ�',
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
						title:'��˰��������',
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
						title:'���۽��',
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
						title:<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else if("3031".equals(currUser.getSgcode().toString())){%>'���۽��'<%}else{%>'���۳ɱ�'<%}%>,
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
					,{field:'GSXSSR',title:'�ۼ۽��',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
					<%}%>
					<%if("3027".equals(currUser.getSgcode().toString())){%>
					{field:'GSVENDREBATE',title:'��Ӧ�̳е��ۿ�',width:70,align:'center',sortable:true}
					<%}%>
					<%
					if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
					%>
					<%if(currUser.getSgcode().equals("3007")){%>
					,{field:'XSSR',title:'�ۼ۽��',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
					<%}else{
						if(currUser.getSgcode().equals("3027")){%>
							,{field:'GSHSJJJE',title:'���۳ɱ�',width:80,sortable:true,align:'center',formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});}}
							,{field:'GSXSSR',title:'��˰��������',width:80,sortable:true,align:'center',formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{decimalPlaces: 2,thousandsSeparator :','});}}
						<%}else if(currUser.getSgcode().equals("3031")){%>
						,{field:'GSXSSR',title:'���С��',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}else{%>
						,{field:'GSXSSR',title:'�ۼ۽��',width:80,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						<%}%>
					<%}%>
					<%if(("3009".equals(currUser.getSgcode().toString()))){%>
					,{field:'MLL',title:'ë����',width:70,align:'center',sortable:true}
					<%}%>
					,{field:'GSSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true,formatter:function(value,rec){
						<%if(currUser.getSgcode().equals("3009")){%>
						if( value != null && value != undefined )
						return (value+'').substring(0,3);
						return '';
						<%}else{%>
						return value;
						<%}%>
					}},	
					{field:'SUPNAME',title:'��Ӧ������',width:150,align:'center',sortable:true}
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
				loadMsg:'��������...',				
				columns:[[
					
				    <%if(currUser.getSgcode().equals("3025") || currUser.getSgcode().equals("3033")){%>
				    {field:'GSGDID',title:'��Ʒ����',width:80,align:'center',sortable:true,formatter:function(value,rec){
						return padLeft(value, 6);
					 }},
				    <%}else{%>
				    {field:'GSGDID',title:'��Ʒ����',width:80,align:'center',sortable:true},
				    <%}%>					
					{field:'GDNAME',title:'��Ʒ����',width:150,align:'left',sortable:true},
					{field:'GCNAME',title:'��Ʒ���',width:100,align:'center',sortable:true},
					{field:'GSXSSL',title:'��������',width:60,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},	
					<%if("3011".equals(currUser.getSgcode().toString())){%>
						{field:'TEMP5',title:'�ۼ�',width:70,align:'center',sortable:true},
					<%}%>				
					{
						field:'GSHSJJJE',title:'���۳ɱ�',width:60,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
							});
						}
					}
					,{field:'GSXSSR',title:'�ۼ۽��',width:60,sortable:true,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
						,{field:'MLL',title:'ë����',width:60,align:'center',sortable:true}
						,{field:'SUPID',title:'��Ӧ�̱���',width:80,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:80,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true
			});
			//����ǹ�Ӧ���û������ع�Ӧ�̱�������򣬷�����ʾ
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
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���  
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
											cnTitle: ['�����','�������','��������','�ۼ�','�ۼ۽��','���۳ɱ�','��Ӧ�̱���','��Ӧ������'],
										<%}else if("3027".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME','GSVENDREBATE' ],
											cnTitle: ['�����','�������','��������','��˰��������','��˰�ɱ�','��Ӧ�̱���','��Ӧ������','��Ӧ�̳е��ۿ�'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSHSJJJE','GSSUPID','SUPNAME' ],
											cnTitle: ['�����','�������','��������','�ۼ۽��',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۳ɱ�'<%}%>,'��Ӧ�̱���','��Ӧ������'],
										<%}
									}else{
										if("3027".equals(currUser.getSgcode()) && ("J".equals(jyfs) || ("D".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE','GSVENDREBATE'],
											cnTitle: ['�����','�������','��������','��˰�ɱ�','��Ӧ�̳е��ۿ�'],
										<%}else if("3027".equals(currUser.getSgcode()) && ("L".equals(jyfs) || ("Z".equals(jyfs))) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR','GSVENDREBATE'],
											cnTitle: ['�����','�������','��������','��˰��������','��Ӧ�̳е��ۿ�'],
										<%}else if("3011".equals(currUser.getSgcode())){%>
											enTitle: ['GCID','GCNAME','GSXSSL','TEMP5','GSXSSR' ],
											cnTitle: ['�����','�������','��������','�ۼ�','���۽��'],
										<%}else if("3034".equals(currUser.getSgcode()) && "S".equals(currUser.getSutype()+"")){%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSXSSR' ],
											cnTitle: ['�����','�������','��������','���۽��'],
										<%}else{%>
											enTitle: ['GCID','GCNAME','GSXSSL','GSHSJJJE' ],
											cnTitle: ['�����','�������','��������',<%if("3007".equals(currUser.getSgcode().toString())){%>'Ԥ�����۳ɱ�'<%}else{%>'���۽��'<%}%>],
										<%}
									}%>
									sheetTitle: '��Ʒ���������ϸ��ѯ',
									gssgcode : User.sgcode,
									gsmfid : $('#gsmfid').attr('value'),// �ŵ����
									supcode : supcode,					// ��Ӧ�̱���
									userType : User.sutype,				// �û�����
									gsgcid : $('#gsgcid').attr('value'), // ������
									gsgcname : $('#gsgcname').attr('value'), // �������						
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
	                        $.messager.alert('��ʾ','����Excelʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		}
		
		function reloadgrid ()  {  
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���  
			var supcode = '';
			if(User.sutype == 'L' && User.sgcode=='3018'){
				supcode = $('#supcode').combobox('getValue');
				
			}else if(User.sutype == 'L' && User.sgcode!=='3018'){
			supcode = $('#supcode').val();
				
			}else {
			supcode = User.supcode;
			}  
	        //��ѯ����ֱ�������queryParams��
	        $('#saleCategory').datagrid('options').url = 'JsonServlet';        
			$('#saleCategory').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'getSaleCategory',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.SaleReport',
						ACTION_MANAGER : 'saleSummary',			 
						list:[{
							gssgcode : User.sgcode,
							gsmfid : $('#gsmfid').attr('value'),// �ŵ����
							supcode : supcode,					// ��Ӧ�̱���
							gsgcid : $('#gsgcid').attr('value'), // ������
							userType : User.sutype,				// �û�����
							gsgcname : $('#gsgcname').attr('value'), // �������							
							startDate : $('#startDate').attr('value'), // ��ʼ����
							endDate : $('#endDate').attr('value')      // ��������
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
    	
    	//��ȡ�����ŵ���Ϣ
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
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}

		//��ȡ���������Ϣ(����)
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
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.CODE + "'>" + n.CODE + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}	

		} 		
		
		//��ȡ���������Ϣ(����)
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
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.NAME + "'>" + n.NAME + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
	                        $.messager.alert('��ʾ','��ȡ������ʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			}
		
		}	);

		
		//��ȡ���д���������Ϣ��3018����
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
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
						            var html = "<option value='" + n.GCID + "'>" + n.GCID + "</option>";		  
						            
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 $(list).attr('isLoad' , true );
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�����Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
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
							gsmfid : $('#shopid_').val(),// �ŵ����
							supcode : supid,					// ��Ӧ�̱���
							gsgcid :gcid, // ������
							startDate : $('#startdate_').val(), // ��ʼ����
							endDate : $('#enddate_').val()      // ��������
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
<!-- ---------- ��ѯ������������ʼ ---------- -->
<table width="740" id="mainTab"
	style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">������Ʒ����ѯ<%if(currUser.getSgcode().equals("3007")){%>( ˵����Ԥ�����۳ɱ�������Ʒ�����½��۽��к���,���½��ĳɱ����ܲ�һ��)<%}%></td>
	</tr>
	<tr>
		<td width="230" id="mainTabTdStartDate" style="border: none;">
			��ʼ���ڣ�<input type="text" id="startDate" name="startDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});" />
		</td>
		<td width="230" style="border: none;">
			�������ڣ�<input type="text" id="endDate" name="endDate" required="true" value="" size="20" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" />
		</td>
		<td id="mainTabTd" width="280" style="border: none;">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
			<select style="width: 154px;" name='gsmfid' id="gsmfid" size='1'>
				<option value=''>�����ŵ�</option>
			</select>
		</td>
	</tr>
	<tr>
		<td style="border: none;" id="gsgcid11">
			�����룺
			<%if("3018".equals(currUser.getSgcode())){%>
				<select style="width: 150px;" id="gsgcid" name="gsgcid" size="1" onclick="loadAllCatId(this);">
				<option>�������</option>
				</select>
			<%}else if("3034".equals(currUser.getSgcode())){%>
                <select style="width: 150px;" id="gsgcid" name="gsgcid" size="1" onclick="loadAllCategoryID(this);">
				<option value=''>�������</option>
				</select>			
			<%}else{%>
				<input type="text" id="gsgcid" name="gsgcid" width="110" value="" />
			<%}%>
			
		</td>
		  <td id='gsgcname11' style="border: none;" style="border: none;">
		   ������ƣ�
		  <%if("3034".equals(currUser.getSgcode())){%>
            <select style="width: 150px;" name='gsgcname' id="gsgcname" size='1' onclick="loadAllCategory(this);">
				<option value=''>�������</option>
			</select>
		  <%}else{%>
		    <input type="text" name='gsgcname' id='gsgcname' />
		  <%} %>
		</td>
		<td style="border: none;" id="mainTabTd2">
			<%if("3018".equals(currUser.getSgcode())){%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input class="easyui-combobox" id="supcode" name="supcode" value="" size="20" panelHeight="auto" /></div>
			<%}else{%>
			<div id="supcodeDiv" style="">��Ӧ�̱��룺<input type="text" id="supcode" name="supcode" value="" size="20" /></div>
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
			<!-- table ����ʾ�б����Ϣ -->
			<div id="saledatagrid" style="display: none;margin-left: 70px;">
			<%if(!currUser.getSgcode().equals("3009")){ %>
				<div id="saleExportExcel" align="right" style="color: #336699; width: 448px;">
					<a href="javascript:exportExcel();">>>����Excel���</a>
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
// �����ŵ�
var obj = document.getElementById("gsmfid");
loadAllShop(obj);
</script>
</html>