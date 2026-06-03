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

// 신원 식별 항목은 모두 비어있지 않아야 한다(빈 값으로 인한 우회 차단)
boolean idFilled = m_id != null && !m_id.trim().isEmpty()
		&& m_name != null && !m_name.trim().isEmpty()
		&& m_hp2 != null && !m_hp2.trim().isEmpty();

// 서버 측 재검증: 신원 일치 + 비밀번호 최소 길이
// NOTE(보안 후속과제): 현재는 지식기반(이름+아이디+휴대폰) 재설정이라 PII 유출 시 취약하다.
//   정석은 이메일/SMS 일회성 토큰 검증. 1차로 회원검색(membersearch) 관리자 가드로 PII 대량유출을 차단했고,
//   재설정 성공 시 자동 로그인 없이 로그인 화면으로 보내 재인증을 강제한다.
boolean ok = idFilled
		&& dao.verifyMember(m_name, m_id, m_hp2)
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
