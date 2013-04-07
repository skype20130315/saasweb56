<%@ page language="java" contentType="text/html; charset=GBK" import="java.text.SimpleDateFormat,java.util.Date"
	pageEncoding="GBK"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="x-ua-compatible" content="ie=8"/ >
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�˳�����ѯ</title>

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
			$('#TCDoc').datagrid({
				width: 930,
				nowrap: false,
				striped: true,
				singleSelect: true,
				fitColumns:false,
				remoteSort: true,
				showFooter:true,
				loadMsg:'��������...',	
				columns:[[
				    {
				    field:'BTHBILLNO',title:'�˳�����',width:150,align:'center',sortable:true,
				    formatter:function(value,rec){
						if(value=='�ϼ�')
						return value;
						else
							return "<a href=javascript:void(0) style='color:#4574a0; font-weight:bold;' onclick=TCDocDetail('"+rec.BTHBILLNO+"','"+rec.BTHSGCODE+"','"+rec.BTHTHMFID+"');>" + rec.BTHBILLNO + "</a>";
						}
					},
				    {field:'BTHTHMFID',title:'�ŵ���',width:80,align:'center',sortable:true},
					{field:'SHPNAME',title:'�ŵ�����',width:140,sortable:true},
				    {field:'BTHSHTIME',title:'�������',width:100,align:'center',sortable:true},	
					{field:'BTDSL',title:'����',width:95,align:'center',sortable:true},
			        {field:'BTDHSJJJE',title:'���',width:95,align:'center',sortable:true}
					<%if("L".equals(userType)){%>
					,{field:'BTHSUPID',title:'��Ӧ�̱���',width:95,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:138,align:'center',sortable:true}
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

			$('#TCDocDetail').datagrid({
				width: 900,
				nowrap: false,
				striped: true,
				singleSelect: true,	
				fitColumns:false,
				remoteSort: true,	
				showFooter:true,
				loadMsg:'��������...',				
				columns:[[
					{field:'BTDGDID',title:'��Ʒ����',width:140,sortable:true},
				    {field:'GDNAME',title:'��Ʒ����',width:140,align:'left',sortable:true},			
				    {field:'GDSPEC',title:'���',width:65,sortable:true},			
				    {field:'GDUNIT',title:'��λ',width:65,align:'center',sortable:true},
				    {field:'BARCODE',title:'��Ʒ����',width:65,align:'center',sortable:true},
				    {field:'BTDSL',title:'�˳�����',width:70,align:'center',sortable:true} ,
					{field:'BTDHSJJ',title:'��˰����',width:78,align:'center',sortable:true} ,
			        {field:'BTDHSJJJE',title:'��˰���۽��',width:78,align:'center',sortable:true}
					<%if("L".equals(userType)){%>
					,{field:'BTHSUPID',title:'��Ӧ�̱���',width:80,align:'center',sortable:true},	
					{field:'SUPNAME',title:'��Ӧ������',width:147,align:'center',sortable:true}	
					<%}%>
					
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
			$("#TCDocdatagrid").css("display","none");  
		});
	
	
		function reloadgrid ()  {
        	//��֤�û����������Ƿ�Ϸ���
        	var temp5 = "";
			var startDate = $("#startDate").attr("value");   
			var endDate = $("#endDate").attr("value");
			if(startDate == '' || endDate == ''){
				$.messager.alert('��ʾ','�����뿪ʼ��������ڣ�����','info');
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
							shopcode : $('#shopcode').attr('value'),// �ŵ����
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

    		//��ѯ����ֱ�������queryParams��
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
                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
					           $("#shopname").html(n.BTHTHMFID+'-'+n.SHOPNAME);
					           $("#supname").html(n.BTHSUPID+'-'+n.SUPNAME);
					           $("#memo").html(n.BTHMEMO);
					           $("#shtime").html(n.BTHSHTIME);
					           $("#BTLLNO").html(n.BTHBILLNO);
					           
						        
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
								ACTION_TYPE : 'getTCDocHead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.TCDocQuery',
								ACTION_MANAGER : 'tcdocQueryManager',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
									enTitle: ['BTHBILLNO','BTHTHMFID','BTHSHTIME','SHPNAME','BTDSL','BTDHSJJJE','BTHSUPID','SUPNAME'],
									cnTitle: ['�˳�����','�ŵ����','�������','�ŵ�����','����','���','��Ӧ�̱���','��Ӧ������'],
									<%}else{%>
									enTitle: ['BTHBILLNO','BTHTHMFID','BTHSHTIME','SHPNAME','BTDSL','BTDHSJJJE' ],
									cnTitle: ['�˳�����','�ŵ����','�������','�ŵ�����','����','���'],
									<%}%>
									sheetTitle: '�˳�����ѯ',
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

<table id="QueryTable" width="930" style="line-height: 20px; text-align: left; border: none; font-size: 12px;">
	<tr>
		<td colspan="3" align="left" style="border: none; color: #4574a0;">�˳�����ѯ</td>
		<input type="hidden" id="hiddenbtllno" />
		<input type="hidden" id="hiddenshopno" />
	</tr>
	<tr>
		<td  style="border: none;width:250">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺&nbsp;&nbsp;&nbsp;<select
			style="width: 155px;" name='shopcode' id="shopcode" size='1'>
			<option value=''>�����ŵ�</option>
		</select></td>

		<td width="250" style="border: none;">��ʼ���ڣ�&nbsp;&nbsp;<input
			type="text" id="startDate" name="startDate" value="" size="20"
			onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'<%if(currUser.getSgcode().equals("3018")&&currUser.getSutype().toString().equalsIgnoreCase("S")){ %>,minDate:'<%=startDate_%>'<% } %>});"size="20" /></td>
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
			<div id="TCDocdatagrid" >
				<table id="TCDoc"></table>
			</div>
		</td>
	</tr>

</table>

<table id="QueryDetailTable" width="900" style="line-height:20px; text-align:left; border:none;font-size: 12px;">
         <tr>
               <td height="24" colspan="2" align="left" style="border:none; color:#33CCFF;"><span class="STYLE4">�˳�����ϸ</span></td>
           </tr>
             <tr>
               <td width="180" style="border:none;">�˳����� �� 
               <span   id="BTLLNO" name="BTLLNO"></span></td>
                <td width="180"  style="border:none;">������� �� 
                 <span   id="shtime" name="shtime"></span></td>
           </tr>
            <tr>
               <td width="180"  style="border:none;">�˻��ŵ� ��
               <span   id="shopname" name="shopname"></span>   
               </td>
               
               <td width="180" style="border:none;"><font style="text-align:center;letter-spacing:25px">��ע</font> ��
                 <span   id="memo" name="memo"></span>             </td>
           </tr>
             <tr>
               <td width="180"  style="border:none;">��&nbsp;&nbsp;Ӧ&nbsp;&nbsp;��&nbsp;&nbsp;��
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
// �����ŵ�
var obj = document.getElementById("shopcode");
loadAllShop(obj);
</script>
</html>