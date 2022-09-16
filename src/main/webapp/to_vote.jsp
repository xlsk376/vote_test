<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
Connection conn = null;

String url = "jdbc:oracle:thin:@localhost:1521:xe";
String id = "system";
String pw = "1234";

try{
	Class.forName("oracle.jdbc.OracleDriver");
	conn = DriverManager.getConnection(url, id, pw);
	System.out.println("DB 접속");
}catch(Exception e){
	e.printStackTrace();
}

String sql = "select m_no, m_name from tbl_member_202005";

PreparedStatement pstmt = conn.prepareStatement(sql);
ResultSet rs = pstmt.executeQuery();
ArrayList<String[]> viewList = new ArrayList<String[]>();

while(rs.next()){
	String[] view = new String[2];
	view[0] = rs.getString(1);
	view[1] = rs.getString(2);
	viewList.add(view);
}

pstmt.close();
conn.close();
rs.close();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript">
	function checkVal(){
		if(!document.vData.v_jumin.value){
			alert("주민번호를 입력하세요");
			document.vData.v_jumin.focus();
			return false;
		}else if(!document.vData.v_name.value){
			alert("이름을 입력하세요");
			document.vData.v_name.focus();
			return false;
		}else if(document.vData.m_no.value == "none"){
			alert("후보를 선택하세요");
			document.vData.m_no.focus();
			return false;
		}else if(!document.vData.v_time.value){
			alert("투표시간을 입력하세요");
			document.vData.v_time.focus();
			return false;
		}else if(!document.vData.v_area.value){
			alert("장소를 입력하세요");
			document.vData.v_area.focus();
			return false;
		}else if(document.getElementsByName("v_confirm")[0].checked != true &&
				document.getElementsByName("v_confirm")[1].checked != true){
			alert("유권자확인을 선택하세요");
			return false;
		}
		alert("투표가 정상적으로 등록되었습니다");
	}
	
	function re(){
		alert("정보를 지우고 처음부터 다시 입력합니다");
		
		document.vData.v_jumin.value = '';
		document.vData.v_name.value = '';
		document.vData.m_no.value = 'none';
		document.vData.v_time.value = '';
		document.vData.v_area.value = '';
		document.getElementsByName("v_confirm")[0].checked = false;
		document.getElementsByName("v_confirm")[1].checked = false;
		
		document.vData.v_jumin.focus();
	}
</script>
<title>투표관리</title>
</head>
<body>
	<jsp:include page="include/header.jsp"></jsp:include>
	<jsp:include page="include/nav.jsp"></jsp:include>
	<div class="section">
		<h3 class="title">후보자등수</h3>
		<form name="vData" method="post" action="index.jsp" onsubmit="return checkVal()">
			<table class="table_line">
				<tr>
					<th>주민번호</th>
					<td>
						<input type="text" name="v_jumin" size="20">
						<span>예 : 8901022200011</span>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td>
						<input type="text" name="v_name" size="20">
					</td>
				</tr>
				<tr>
					<th>투표번호</th>
					<td>
					<select name="m_no">
						<option value="none">후보선택</option>
						<%
							for(int i = 0; i < viewList.size(); i++){
						%>
						<option value="<%=viewList.get(i)[0] %>">[<%=viewList.get(i)[0] %>]
						<%=viewList.get(i)[1] %></option>
						
						<% } %>
					</select>
					</td>
				</tr>
				<tr>
					<th>투표시간</th>
					<td>
						<input type="text" name="v_time" size="20">
					</td>
				</tr>
				<tr>
					<th>투표장소</th>
					<td>
						<input type="text" name="v_area" size="20">
					</td>
				</tr>
				<tr>
					<th>유권자확인</th>
					<td>
					<input type="radio" name="v_confirm" value="Y">확인
					<input type="radio" name="v_confirm" value="N">미확인
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="투표하기">
						<input type="button" value="다시하기" onclick="re()">
					</td>
				</tr>
			</table>		
		</form>
	</div>
	<jsp:include page="include/footer.jsp"></jsp:include>

</body>
</html>