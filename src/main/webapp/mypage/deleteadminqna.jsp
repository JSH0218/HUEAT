<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Single+Day&family=Stylish&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
    // nums를 읽기
    String nums = request.getParameter("nums");
    // 쉼표로 구분된 각 숫자 쌍을 분리
    String[] numArray = nums.split(",");
    QaanswerDao dao = new QaanswerDao();
    // 배열의 각 요소에 대해
    for (int i = 0; i < numArray.length; i += 2) {
        String qNum = numArray[i]; // 짝수 인덱스는 q_num 값
        String qaNum = numArray[i + 1]; // 홀수 인덱스는 qa_num 값
        // Q_num과 qa_num에 해당하는 데이터 삭제
        dao.deleteQna(qNum, qaNum);
    }
    // 목록으로 이동
    response.sendRedirect("../index.jsp?main=mypage/adminqnalist.jsp");
%>
</body>
</html>