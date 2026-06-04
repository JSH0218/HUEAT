<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Myeongjo&family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <link rel="icon" type="image/png" href="image/mainbanner/logo1.png" sizes="32x32">
<title>HUEAT</title>
<style type="text/css">


  div.title {
    border-bottom: 1px solid #ddd; 
    position: sticky;
     top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    background-color: white;
    font-family: 'Noto Sans KR';

  }
  
  div.banner {
    border: 0px solid yellow;
    display: none;
    font-family: 'Noto Sans KR';
  }
  
  div.main {
    border: 0px solid red;
    font-family: 'Noto Sans KR';
    min-height: calc(100vh - 10rem);
  }
  
  div.info {
    border: 0px solid blue;
    background-color: gray;
    font-family: 'Noto Sans KR';
  }

</style>
</head>
<%
   //1. 기본페이지 main 페이지 지정
   String main = "layout/main.jsp"; //기본페이지
   
   //2. url을 통해서 main값을 읽어서 메인페이지에 출력
   //   단, 화이트리스트에 있는 페이지만 허용(임의 경로 include로 인한 LFI/경로조작 차단)
   String requestedMain = request.getParameter("main");
   if(requestedMain != null) {
      if(util.SecurityUtil.isAllowedMainPage(requestedMain)){
         main = requestedMain;
      }
      // 미허용 값이면 기본 페이지(layout/main.jsp) 유지
   }else{
      %>
      <script type="text/javascript">
         $(function(){
            $("div.banner").show();
         });
      </script>
      <%
   }
%>
<body>

  <div class="layout title"><jsp:include page="layout/title.jsp"/></div>
  <div class="layout banner"><jsp:include page="layout/banner.jsp"/></div>
  <div class="layout main"><jsp:include page="<%=main %>"/></div>
  <div class="layout info"><jsp:include page="layout/info.jsp"/></div>



  <script type="text/javascript">
  // CSRF: 모든 동일출처 jQuery AJAX 요청에 _csrf 토큰을 자동 첨부한다(상태변경 위조 차단).
  // 각 페이지가 jQuery를 다시 로드하므로 모든 include 이후(본문 끝)에서 최종 jQuery에 등록한다.
  (function(){
    if(typeof jQuery === "undefined"){ return; }
    var _csrf = "<%=util.SecurityUtil.csrfToken(session)%>";
    jQuery.ajaxPrefilter(function(options){
      if(options.crossDomain){ return; }
      var d = options.data;
      if(typeof FormData !== "undefined" && d instanceof FormData){
        if(!d.has("_csrf")){ d.append("_csrf", _csrf); }
      } else if(typeof d === "string"){
        if(d.indexOf("_csrf=") === -1){ options.data = d + (d.length ? "&" : "") + "_csrf=" + encodeURIComponent(_csrf); }
      } else if(d && typeof d === "object"){
        if(!("_csrf" in d)){ d._csrf = _csrf; }
      } else {
        options.data = "_csrf=" + encodeURIComponent(_csrf);
      }
    });

    // 링크형 상태변경(삭제 등)을 GET이 아닌 POST로 전송하기 위한 헬퍼.
    // 숨김 폼을 만들어 _csrf와 파라미터를 함께 POST 제출한다.
    window.postNav = function(url, params){
      var f = document.createElement("form");
      f.method = "post";
      f.action = url;
      params = params || {};
      if(!("_csrf" in params)){ params._csrf = _csrf; }
      for(var k in params){
        if(!Object.prototype.hasOwnProperty.call(params, k)){ continue; }
        var i = document.createElement("input");
        i.type = "hidden";
        i.name = k;
        i.value = params[k];
        f.appendChild(i);
      }
      document.body.appendChild(f);
      f.submit();
    };
  })();
  </script>

</body>
</html>
