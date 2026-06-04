<%@page import="org.json.simple.JSONObject"%>
<%@page import="review.model.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    // 상태변경(추천수 +1)이므로 POST + 로그인 + CSRF를 강제한다.
    if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.isLogin(session)
          || !util.SecurityUtil.checkCsrf(request)){
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }

    //num 읽기
    String r_num = util.SecurityUtil.digitsOnly(request.getParameter("r_num"));

    ReviewDao dao = new ReviewDao();
    dao.updateReviewChu(r_num);
    
    //증가된 chu 값 json 형태로 보내기
    int chu = dao.getDataReview(r_num).getR_chu();
    
    JSONObject ob = new JSONObject();
    ob.put("chu", chu);
    
    %>
    
    <%=ob.toString()%>