<%@ page language="java" contentType="text/html; charset=GBK" import="java.text.SimpleDateFormat,java.util.Date"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>��ⵥ��ѯ</title>

<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		out.println("��ǰ�û��ѳ�ʱ,�����µ�½!");
		out.println("<a href='login.jsp' >��˵�¼</a>");
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
				loadMsg:'��������...',				
				columns:[[
				    {field:'BIHBILLNO',title:'�����',width:130,align:'center',sortable:true,
				    formatter:function(value,rec){
					    if(value=='�ϼ�')
					    	return "�ϼ�";
						else
							return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=RKDocDetail('"+rec.BIHBILLNO+"','"+rec.BIHSGCODE+"','"+rec.BIHSHMFID+"');>" + rec.BIHBILLNO + "</a>";
						}
					},
				    {field:'BIHSHMFID',title:'�ŵ���',width:100,align:'center',sortable:true},
				    {field:'SHOPNAME',title:'�ŵ�����',width:130,sortable:true},
				    {field:'BIHSHTIME',title:'�������',width:104,align:'center',sortable:true},				    
				    {field:'BIDSL',title:'����',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						else return formatNumber('0',{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					 }},
				     {field:'BIDHSJJJE',title:'���',width:100,align:'center',sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
						else return formatNumber('0',{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					 }}
						<%if("L".equals(userType)){%>
						,{field:'BIHSUPID',title:'��Ӧ�̱���',width:100,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:130,align:'center',sortable:true}
						<%}%>
						
				]],
				toolbar:[{
					text:'����Excel',
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
				loadMsg:'��������...',				
				columns:[[
					{field:'BIDGDID',title:'��Ʒ����',width:90,sortable:true,
				    	formatter:function(value,rec){
						    if(value=='�ϼ�')
						    	return "�ϼ�";
							else
								return value;
						}
					},
				    {field:'BARCODE',title:'��Ʒ����',width:100,align:'center',sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:110,align:'left',sortable:true},			
				    {field:'GDSPEC',title:'���',width:60,sortable:true},			
				    {field:'GDUNIT',title:'��λ',width:60,align:'center',sortable:true},
				    {field:'BIDSL',title:'�������',width:80,align:'center',sortable:true,formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
							else return formatNumber('0',{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
						{field:'BIDHSJJ',title:'��˰����',width:80,align:'center',sortable:true},
				        {field:'BIDHSJJJE',title:'��˰���۽��',width:80,align:'center',sortable:true},
						{field:'BIHSUPID',title:'��Ӧ�̱���',width:90,align:'center',sortable:true},	
						{field:'SUPNAME',title:'��Ӧ������',width:113,align:'center',sortable:true}
				]],
				pagination:true,
				rownumbers:true
			});
			//����ǹ�Ӧ���û������ع�Ӧ�̱�������򣬷�����ʾ
			if(User.sutype == 'S'){
				$("#sup").hide();
			}else{
				$("#sup").show();
			}
			$("#RKDocdatagrid").css("display","none");	
		});

		
		function reloadgrid ()  {
        	//��֤�û����������Ƿ�Ϸ���
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('����','�����뿪ʼ��������ڣ�����','error');
				return;
			} 
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#supcodequery').val();	
			}else {
				supcode = User.supcode;
			}
	        //��ѯ����ֱ�������queryParams��
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
							shopcode : $('#shopcode').val(),// �ŵ����
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
			
    		//��ѯ����ֱ�������queryParams��
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
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					           $("#orderno").html(n.BIHORDERNO);
					           $("#shopname").html(n.BIHSHMFID+'-'+n.SHOPNAME);
					           $("#supname").html(n.BIHSUPID+'-'+n.SUPNAME);
					           $("#memo").html(n.BIHMEMO);
					           $("#shtime").html(n.BIHSHTIME);
					           $("#BILLNO").html(n.BIHBILLNO);
					           
						        
						       });						        
                    	 }	                    	 
                    }else{ 
                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
                    } 
            	},
            	'json'
            );
				
    	}
    	function exportExcel(){
			//�����û��ǹ�Ӧ�̻��������̣���ȡ��Ӧ�̱���
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
								cnTitle: ['�����','�ŵ����','�ŵ�����','�������','����','���','��Ӧ�̱��','��Ӧ������'],
								<%}else{%>
								enTitle: ['BIHBILLNO','BIHSHMFID','SHOPNAME','BIHSHTIME','BIDSL','BIDHSJJJE' ],
								cnTitle: ['�����','�ŵ����','�ŵ�����','�������','����','���'],
								<%}%>
								sheetTitle: '��ⵥ��ѯ',
								sgcode : User.sgcode,
								supcode : supcode,
								shopcode : $('#shopcode').attr('value'),
								startDate : $('#startDate').attr('value'),	// ��ʼʱ��
								endDate : $('#endDate').attr('value') 		// ����ʱ��
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
		<td colspan="3" align="left" style="border: none; color: #4574a0;">��ⵥ��ѯ</td>
		<input type="hidden" id="hiddenbillno" />
		<input type="hidden" id="hiddenshopno" />
	</tr>
	<tr>
		<td  style="border: none;width:250">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺&nbsp;&nbsp;&nbsp;<select
			style="width: 154px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>

		<td width="250" style="border: none;">��ʼ���ڣ�<input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'
			<%if(currUser.getSgcode().equals("3018")&&currUser.getSutype().toString().equalsIgnoreCase("S")){ %>,minDate:'<%=startDate_%>'<% } %>});"size="20" /></td>
		<td width="250" style="border: none;">�������ڣ�<input type="text"
			id="endDate" name="endDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});" /></td>
	</tr>
	<tr>
		<td id="sup"  style="border:none;width:250px;">��Ӧ�̱��룺
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
			<!-- table ����ʾ�б����Ϣ -->
			<div id="RKDocdatagrid" >
				<table id="RKDoc"></table>
			</div>
		</td>
	</tr>

</table>

<table id="QueryDetailTable" width="800" style="line-height:20px; text-align:left; border:none;font-size: 12px;" >
         <tr>
               <td height="24" colspan="2" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">��ⵥ��ϸ</span></td>
           </tr>
             <tr>
               <td width="434" height="24" style="border:none;">�������� ��
               <span   id="orderno" name="orderno"></span>   
               </td>
               <td width="524" style="border:none;">��ⵥ�� �� 
                 <span   id="BILLNO" name="BILLNO"></span>             </td>
           </tr>
             <tr>
               <td height="27" style="border:none;"> ������� ��
               <span  id="shtime" name="shtime"></span></td>
               <td style="border:none;">�� Ӧ �� ��
               <span  id="supname" name="supname"></span>
                 </td>
           </tr>
             <tr>
               <td  height="13" style="border:none;">�ջ��ŵ� ��
               <span   id="shopname" name="shopname"></span>
               </td>
              <td style="border:none;"><font style="text-align:center;letter-spacing:25px">��ע</font> ��
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
// �����ŵ�
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>