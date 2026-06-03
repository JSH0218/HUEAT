<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="util.SecurityUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

String m_id   = request.getParameter("m_id");
String m_name = request.getParameter("m_name");
String m_hp2  = request.getParameter("m_hp2");
String m_newpass = request.getParameter("m_newpass");

MemInfoDao dao = new MemInfoDao();

// 서버 측 재검증: 신원 일치 + 비밀번호 최소 길이
boolean ok = dao.verifyMember(m_name, m_id, m_hp2)
		&& m_newpass != null && m_newpass.length() >= 6;

if (ok) {
	dao.resetPassword(m_id, SecurityUtil.hashPassword(m_newpass));
%>
<script type="text/javascript">
	alert("비밀번호가 변경되었습니다. 다시 로그인해 주세요.");
	location.href = "../index.jsp?main=member/loginform.jsp";
</script>
<%
} else {
%>
<script type="text/javascript">
	alert("비밀번호 변경에 실패했습니다. 정보를 다시 확인해 주세요.");
	history.back();
</script>
<%
}
%>
