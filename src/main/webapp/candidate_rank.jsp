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

String sql = "select m.m_no, m.m_name, count(v.m_no) from tbl_vote_202005 v, tbl_member_202005 m where m.m_no=v.m_no ";
sql += " and v.v_confirm='Y' group by m.m_no, m.m_name order by count(v.m_no) desc";

PreparedStatement pstmt = conn.prepareStatement(sql);
ResultSet rs = pstmt.executeQuery();
ArrayList<String[]> viewList = new ArrayList<String[]>();

while(rs.next()){
	String[] view = new String[3];
	view[0] = rs.getString(1);
	view[1] = rs.getString(2);
	view[2] = rs.getString(3);
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
<title>투표관리</title>
</head>
<body>
	<jsp:include page="include/header.jsp"></jsp:include>
	<jsp:include page="include/nav.jsp"></jsp:include>
	<div class="section">
		<h3 class="title">후보자등수</h3>
			<table class="table_line">
				<tr>
					<th>후보번호</th>
					<th>성명</th>
					<th>총투표건수</th>
				</tr>
				<%
					for(int i = 0; i < viewList.size(); i++){
				%>
				<tr>
					<td><%=viewList.get(i)[0] %></td>
					<td><%=viewList.get(i)[1] %></td>
					<td><%=viewList.get(i)[2] %></td>
				</tr>
				<% } %>
			</table>
		
		
	</div>
	<jsp:include page="include/footer.jsp"></jsp:include>

</body>
</html>