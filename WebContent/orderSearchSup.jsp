<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>	
	<title>������Ϣ��ѯ</title>
	
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode = currUser.getSgcode();
	String sutype = currUser.getSutype() + "";
%>
<style>
	.underLine{
		border:0px;
		border-bottom:#000 1px solid;
		overflow:hidden;
	}
</style>
	<script type="text/javascript">
		$(function(){
			// ��䶩��ͷ�б�
			$('#orderSearchSupList').datagrid({
				nowrap: false,
				striped: true,			
				width:800,	
				sortOrder: 'desc',
				singleSelect : true,
				showFooter:true,
				remoteSort: true,
				fitColumns:false,
				idField: 'BOHBILLNO',
				loadMsg:'��������...',
				columns:[[
						{field:'BOHBILLNO',title:'�������',width:120,sortable:true,
							formatter:function(value,rec){
							var supname3=(rec.SUNAME+'').replace(/\ /g,'');
								return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showOrderDet("'+ rec.BOHBILLNO +'","'+rec.BOHMFID+'","'+rec.BOHSUPID+'","'+rec.SHPNAME+'","'+supname3+'","'+rec.BOHDHRQ+'","'+rec.BOHJHRQ+'","'+rec.BOHQXTIME+'");>' + value + '</a>';
							}
						},	
						{field:'BOHMFID',title:'�ŵ���',width:60,sortable:true},
						{field:'SHPNAME',title:'�ŵ�����',width:105,sortable:true},
						{field:'BOHDHRQ',title:'��������',width:100,sortable:true},
						{field:'BOHJHRQ',title:'�ͻ�����',width:100,sortable:true}
						<%if("L".equals(sutype)){%>
						,{field:'BOHSUPID',title:'��Ӧ�̱��',width:70,sortable:true},
						{field:'SUNAME',title:'��Ӧ������',width:215,sortable:true}
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
			
			// ��䶩����ϸ�б�
			$('#orderDetSupList').datagrid({
				width: 900,
				nowrap: false,
				striped: true,	
				url:'',			
				sortOrder: 'asc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'��������...',				
				showFooter:true,
				rownumbers:true,				
				columns:[[	
					{field:'BODGDID',title:'��Ʒ����',width:100,align:'left'},
					{field:'GDNAME',title:'��Ʒ����',width:300,align:'left'},
					{field:'GDBARCODE',title:'��������',width:100,align:'left'},
					{field:'GDSPEC',title:'��Ʒ���',width:70,align:'left'},
					{field:'GDUNIT',title:'��λ',width:70,align:'left'},
					{field:'BODSL',title:'����',width:60,align:'left'}, 
					{field:'BODTAX',title:'˰��',width:70,align:'left'},
					{field:'BODHSJJ',title:'��˰����',width:70,align:'left'},
					{field:'BODHSJJJE',title:'�ɱ����',width:70,align:'left'}		
				]]
			});
			
			//����������̣�����ʾ��Ӧ�������
			if(User.sutype == 'S'){
				$("#supcodeDiv").hide();
			}else{
				$("#supcodeDiv").show();
			} 
			clear();
		});
		
		
		function exportExcel(){
			var searchData = getFormData( 'orderSearchHTSearch' );
    		var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#bohsupid').val();
			}else {
				supcode = User.supcode;
			}  
			if(User.sutype == 'L'){
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ','BOHSUPID','SUNAME'];
			    searchData['cnTitle'] = ['�������','�ŵ���','�ŵ�����','��������','�ͻ�����','��Ӧ�̱��','��Ӧ������'];
			}else{
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ'];
				searchData['cnTitle'] = ['�������','�ŵ���','�ŵ�����','��������','�ͻ�����'];
			} 
			searchData['bohsupid'] = supcode;  		// ��Ӧ�̱���
			searchData['bohsgcode'] = User.sgcode;  // ʵ������
			searchData['exportExcel'] = true;
			searchData['sheetTitle'] = '������Ϣ��ѯ';
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'SearchYwBorderhead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderhead',
								ACTION_MANAGER : 'ywBorderhead',											 
								list:[searchData]
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
		
		function clear(){
			var now = new Date();
			var startDate = new Date();
			startDate.setDate( now.getDate() - 7 );
			$('#startDate').val( startDate.format('yyyy-MM-dd') );
			$('#endDate').val( now.format('yyyy-MM-dd') );
		}
		
		// ���ض���ͷ�б�
		function reloadgrid()  { 
        	var searchData = getFormData( 'orderSearchHTSearch' );
			var supcode = '';
			if(User.sutype == 'L'){
				supcode = $('#bohsupid').val();	
			}else {
				supcode = User.supcode;
			}  
			searchData['bohsupid'] = supcode;  		// ��Ӧ�̱���
			searchData['bohsgcode'] = User.sgcode;  // ʵ������
	        //��ѯ����ֱ�������queryParams��
	        $('#orderSearchSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderSearchSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchYwBorderhead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderhead',
						ACTION_MANAGER : 'ywBorderhead',
						optType : 'query',
						optContent : '��ѯ����',			 
						list:[	searchData	]
					}
				)
			};        
			$("#orderSearchSupListTD").show();			
			$("#orderSearchSupList").datagrid('reload');
			$("#orderSearchSupList").datagrid('resize'); 
			$('#bohsupid').combobox('setValue','');
			
        
    	}
    	
    	// ��ȥ������ϸ�ķ���
		function showOrderDet( bohbillc,shopid ,BOHSUPID,SHPNAME,SUNAME,dhrq,jhrq,qxrq){
			if(jhrq=="null"){
				jhrq="";
			}
			var data;
			$('#bohbillno_').empty().append(bohbillc); // �������
			$('#bohsupid_').empty().append(BOHSUPID);	// ��Ӧ�̱��
			$('#bohsupid_').append(SUNAME);				// ��Ӧ������
			$('#bohdhrq_').empty().append(dhrq); // ��������
			$('#bohjhrq_').empty().append(jhrq);	// �ͻ�����
			$('#bohqxrq_').empty().append(qxrq );	// ��Ч����
			$('#bohmfid_').empty().append(shopid);		// �ջ��ŵ���
			$('#bohmfid_').append(SHPNAME);				// �ջ��ŵ�����
			
			// ���������(��ӡ��)
			$('#bohbillno_hidden').val(bohbillc);
			$('#bohmfid_hidden').val(shopid);
					
	        //��ѯ����ֱ�������queryParams��
	        $('#orderDetSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderDetSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'SearchYwBorderdet',
						ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderdet',
						ACTION_MANAGER : 'ywBorderdet',		 
						list:[{
							bodbillno : bohbillc,
							bodsgcode : User.sgcode,
							bodshmfid :shopid
						}]
					}
				)
			};
			
			$( '#orderSearchHTSearch' ).hide();
			$( '#orderDetHT' ).show();			        
			$("#orderDetSupList").datagrid('reload');
			$("#orderDetSupList").datagrid('resize'); 
		}
		
		// ���ض���ͷҳ
		function returnFirst(){
			$( '#orderSearchHTSearch' ).show();
			$( '#orderDetHT' ).hide(); 
			reloadgrid();
		}
		
		// ���ò�ѯ���������
		function searchReset(){
			clear();
			$('#bohbillno').val( '' ); 	// �������
			$('#bohstatus').val( '' ); 	// ����״̬
			$('#bohmfid').val(''); 		// �ŵ�����
			$('#bohsupid').val('');		// ��Ӧ�̱���
			$('#state').val('');		// ����״̬���𿭴�3016��	
		}
		
		// ��ϸҳ��[��ӡ]��ť�¼�
		function printOrder(){
		var mfid = $('#bohmfid_hidden').val();
		
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ��ӡ��?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'addYwBorderstatus',
									ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderstatus',
									ACTION_MANAGER : 'ywBorderstatus',
									optType : 'update',
									optContent : '��ӡ����',	
									list:[{
										bohsgcode : User.sgcode,    			  // ʵ������
										bohbillno : $('#bohbillno_hidden').val(), // �������
										bohshmfid : mfid,   // �ŵ���
										bohstatus : ''      					  // ����״̬
									}]
							})
							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){	                    	 
		                    	
		                    }else{ 
		                        $.messager.alert('��ʾ','��ӡ����ʧ��!<br>ԭ��' + data.returnInfo,'error');
		                        return;
		                    } 
		            	},
		            	'json'
					);
				
				
	                var bodsgcode = User.sgcode; 					 // ʵ������
					var bodbillno = $('#bohbillno_hidden').val(); 	 // �������
					var bodshmfid = $('#bohmfid_hidden').val(); 	 // �ŵ���
	                //��url��ָ����ӡִ��ҳ��
	                var url = "print_order.jsp?bodsgcode=" + bodsgcode + "&bodbillno=" + bodbillno + "&bodshmfid=" + bodshmfid;					
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
				}
			});
		}		
		// �����ŵ�����������
		function loadSupShop( list ){ 
			if( $(list).attr('isLoad') == undefined ){
				$(list).attr('isLoad' , true );
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
	                    	 	$.each( data.rows, function(i, n) { 
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 
	                    }else{ 
	                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}	  
	</script>
</head>
<body align ="left" >
		<table id="orderSearchHTSearch" style="line-height:20px;border:none; font-size:12px;margin:auto;width:800px;" align="center"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">������Ϣ��ѯ</td> 
			</tr>
			 
			<tr> 
      			<td style="border:none;"> 
					��&nbsp;��&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="bohbillno" id="bohbillno" value="" width="110" /> 
				</td> 
				<td style="border:none;"> 
					��&nbsp;ʼ&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="startDate" id="startDate" value="" size="20"  onClick="WdatePicker();" /> 
				</td> 
				<td style="border:none;"> 
					��&nbsp;��&nbsp;��&nbsp;��&nbsp;��
					<input type="text" name="endDate" id="endDate" value="" size="20"  onClick="WdatePicker();" /> 
				</td>
  			</tr>
  			
  			<tr>
  				<td style="border:none;"> 
					��&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;��
					<select style="width:150px;" name='bohmfid' id="bohmfid" size='1' onclick="loadSupShop(this);">
              			<option value = ''>�����ŵ�</option>
      				</select>
      			</td>
      			<td style="border:none;"> 
					<div id="supcodeDiv" style="">��Ӧ�̱��룺&nbsp;&nbsp;<input type="text" id="bohsupid" name="bohsupid" value="" size="20" /></div>
      			</td>
      			<td style="border:none;">&nbsp;</td>
  			</tr>
			<tr> 
				<td colspan="3" style="border:none;"> 
					<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
					<a href="javascript:void(0);"><img src="images/back.jpg" border="0" onclick="searchReset();"/></a>
				</td> 
			</tr>
			<tr>
				<td id="orderSearchSupListTD" colspan="3" style="border: none;">
					<table id="orderSearchSupList"></table>
				</td>
			</tr> 
		</table>
		<!-- ��ѯ�����������  -->
		
	
	<!-- ��һ��ҳ�� �б�ҳ ����  -->
	
	<!-- �ڶ���ҳ�� ��ϸҳ ��ʼ display:none;-->		
		<!-- (2)��ϸ����ʼ -->
		<table id="orderDetHT" width="800" style="line-height:20px;border:none;font-size: 12;display: none" align="center">
			<tr><th colspan="3" style="align:center;font-size:24px;">������ϸ</th></tr>
            <tr>
              <td width="242" style="border:none;">������ţ�<span id="bohbillno_"></span></td>
              <td width="242" style="border:none;">�������ڣ�<span id="bohdhrq_"></span></td> 
              <%if(!"3018".equals(currUser.getSgcode())){ %>
              	<%if("3008".equals(currUser.getSgcode())){%>
              		<td width="242" style="border:none;">Ԥ�����գ�<span id="bohjhrq_"></span></td>
              	<%}else{%>
              		<td width="242" style="border:none;"><%="3004".equals(currUser.getSgcode()) ? "��" : "��" %>��<%="3016".equals(currUser.getSgcode())||"3010".equals(currUser.getSgcode()) ? "��ֹ" : "" %>���ڣ�<span id="bohjhrq_"></span></td>
              		<%}%> 
              <%}else{ %>
              	<td width="242" style="border:none;">��Ч���ڣ�<span id="bohqxrq_"></span></td>
              <%} %>
            </tr>
            <tr>
              <%if("3008".equals(currUser.getSgcode())){%>
              <td width="242" style="border:none;">��Ч���ڣ�<span id="bohqxrq_"></span></td>
              <%} %>
              <td width="242" style="border:none;">�ջ��ŵ꣺<span id="bohmfid_"></span></td>
              <td width="242" style="border:none;">��&nbsp;&nbsp;Ӧ&nbsp;&nbsp;�̣�<span id="bohsupid_"></span></td>
              <td style="border:none;">&nbsp;</td>
            </tr>
            <tr>
            	<td colspan="3" style="border:none;">

            	</td>
            </tr>
            <tr><td colspan="3"><table id="orderDetSupList"></table></td></tr>
            <tr>
            	<td colspan="3" style="border:none;">
            		<div style="color:#336699;width: 800px;" align="left">			
						<a href="javascript:void(0);"><img src="images/goback.jpg" border="0" onclick="returnFirst();"/></a>
						<a href="javascript:void(0);"><img src="images/print.jpg" border="0" onclick="printOrder();"/></a>			
					</div>
            	</td>
            </tr>
       </table>
          <!-- (2)��ϸ������ -->
	<!-- (1)���⿪ʼ -->
		<span id="detTitle" style="color:008CFF;font-size:20px"></span>
		<input type="hidden" id="bohbillno_hidden">
		<input type="hidden" id="bohmfid_hidden"><br>
		<!-- (1)������� -->
		
	
	<!-- �ڶ���ҳ�� ��ϸҳ ���� -->
	
</body>
</html>