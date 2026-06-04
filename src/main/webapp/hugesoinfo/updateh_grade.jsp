<%@page import="grade.model.GradeDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	// 로그인 사용자만 평점 갱신 가능
	if(!util.SecurityUtil.isLogin(session)){
		response.sendError(403); return;
	}
	// CSRF 토큰 검증(위조 요청 차단)
	if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
	// 위변조 방어: 클라이언트가 보낸 h_grade/h_gradecount를 신뢰하지 않고
	// grade 테이블에서 평균/개수를 서버에서 재계산한다(메인 "이달의 휴게소" 랭킹 조작 차단).
	String h_num=util.SecurityUtil.digitsOnly(request.getParameter("h_num"));
	if(h_num.isEmpty()){
		response.sendError(400); return;
	}

	GradeDao gdao=new GradeDao();
	String h_grade=gdao.avgGrade(h_num);          // 평균 평점(소수점 1자리), 평점이 없으면 "0.0"
	int h_gradecount=gdao.getG_myid(h_num).size(); // 평점 개수

	HugesoInfoDto dto=new HugesoInfoDto();
	dto.setH_num(h_num);
	dto.setH_grade(h_grade==null?"0.0":h_grade);
	dto.setH_gradecount(String.valueOf(h_gradecount));

	HugesoInfoDao dao = new HugesoInfoDao();
	dao.updateH_grade(dto);

%>
