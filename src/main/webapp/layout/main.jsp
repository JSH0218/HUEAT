<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="event.model.EventDto"%>
<%@page import="event.model.EventDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="notice.model.NoticeDto"%>
<%@page import="java.util.List"%>
<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>홈페이지 메인</title>
<style type="text/css">
/* 모달 스타일 */
.modal {
    display: none;
    position: fixed;
    z-index: 1050; /* 모달 창이 나타날 z-index 값 */
    padding: 20px;
    border-radius: 10px;
}

.modal1 {
    transform: translate(20%, 10%);
    max-width: 390px; /* 모달 창 최대 너비 설정 */
}

.modal2 {
    transform: translate(110%, 10%);
    max-width: 390px; /* 모달 창 최대 너비 설정 */
}

.modal-content {
    background-color: #fefefe;
    padding: 20px;
    border: 1px solid #888;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* 오늘 하루 열지 않기 체크박스 스타일 */
.check-label {
    display: block;
    margin-top: 10px;
}

.category {
    margin-top: -13.2%;
    margin-left: 42%;
}

.title1 {
    text-align: center;
    margin-top: 10vh;
}

.subtitle {
    text-align: center;
    color: gray;
}

.title2 {
    text-align: center;
    margin-top: 12vh;
}

.subtitle1 {
    text-align: center;
    color: gray;
}

.bottom_img {
    width: 1500px;
    display: block;
    margin: 0 auto;
}

.caption {
    position: absolute;
    bottom: 280px;
    left: 50%;
    transform: translateX(-50%);
    padding: 10px;
}

h3 {
    text-align: center;
    margin: 0;
}

button.btn {
    position: absolute;
    bottom: 230px;
    transform: translateX(-50%);
    padding: 8px 16px;
}

button.col {
    background-color: #618E6E;
}
</style>
</head>
<%
//프로젝트 경로
String root = request.getContextPath();

//notice
NoticeDao ndao = new NoticeDao();
List<NoticeDto> list = ndao.getAllNotice();

//event
EventDao edao = new EventDao();
List<EventDto> elist = edao.getAllEvent();

//휴게소
HugesoInfoDao hdao = new HugesoInfoDao();
List<HugesoInfoDto> hlist = hdao.getAllGrade();
%>
<body>
<div id="total_main">
    <!-- 타이틀1 -->
    <div class="title1">
        <h2><b>고객소통</b></h2>
    </div>

    <div class="subtitle">
        <h5>항상 고객을 존중하며 고객의 눈높이에서 고객중심경영을 실현하기 위하여 최선을 다하겠습니다.</h5>
    </div>

    <!-- 공지사항 / 이벤트 -->
    <div style="margin-top: 4%;">
        <jsp:include page="../mainlayout/noticevent.jsp" />
    </div>

    <!-- 메뉴 카테고리 -->
    <div class="category">
        <jsp:include page="../mainlayout/menutag.jsp" />
    </div>

    <!-- 타이틀2 -->
    <div class="title2">
        <h2><b>이달의 소식</b></h2>
    </div>

    <div class="subtitle1">
        <h5>최고의 품질과 양으로 고객님들께 웃음을 드리도록 노력하겠습니다.</h5>
    </div>

    <div style="display: flex;">
        <!-- 이달의 휴게소 -->
        <div style="display: inline-block; margin-right: 20px; margin-top: 2%;">
            <jsp:include page="../mainlayout/hugesorank.jsp" />
        </div>

        <!-- 이달의 메뉴 -->
        <div style="display: inline-block; margin-left: -4%; margin-top: 2%;">
            <jsp:include page="../mainlayout/foodrank.jsp" />
        </div>
    </div>

    <!-- 쇼핑몰 -->
    <div style="text-align: center; position: relative; padding-top: 4%;">
        <img alt="" src="<%=root%>/image/main/main.jpg" class="bottom_img">
        <h2 class="caption">다양한 브랜드를 합리적인 가격으로 만나보세요</h2>
        <button class="btn btn-success col" onclick="location.href='index.jsp?main=shop/shopList.jsp'">
            자세히보기
        </button>
    </div>

    <!-- 모달 팝업1 -->
    <div class="modal modal1" id="myModal1">
        <div class="modal-content">
            <span class="close" onclick="closeModal1()">&times;</span><br>
            
            <!-- 팝업창 내용 -->
            <div style="cursor: pointer;">
             <img alt="" src="<%=root%>/image/modal/모달1.jpg" style="width:300px; height: 400px;"
             onclick="window.open('http://xn--bk1bl5qt2ck2idjbfys.kr/', '_blank')">
            </div>
            <!-- 오늘 하루 열지 않기 체크박스 -->
            <label class="check-label">
                <input type="checkbox" id="checkClose1"> 오늘 하루 열지 않기
            </label>
        </div>
    </div>
    
    <!-- 모달 팝업2 -->
    <div class="modal modal2" id="myModal2">
        <div class="modal-content">
            <span class="close" onclick="closeModal2()">&times;</span><br>
            
            <!-- 팝업창 내용 -->
            <div style="cursor: pointer;">
             <img alt="" src="<%=root%>/image/modal/모달4.jpg" style="width:300px; height: 400px;"
             onclick="location.href='index.jsp?main=hugesoinfo/hugesolist.jsp'">
            </div>
            <!-- 오늘 하루 열지 않기 체크박스 -->
            <label class="check-label">
                <input type="checkbox" id="checkClose2"> 오늘 하루 열지 않기
            </label>
        </div>
    </div>
</div>

<script>
    // 모달1 열기
    function openModal1() {
        const modal = document.getElementById("myModal1");
        modal.style.display = "block";
    }

    // 모달2 열기
    function openModal2() {
        const modal = document.getElementById("myModal2");
        modal.style.display = "block";
    }

    // 모달1 닫기
    function closeModal1() {
        const modal = document.getElementById("myModal1");
        modal.style.display = "none";
    }

    // 모달2 닫기
    function closeModal2() {
        const modal = document.getElementById("myModal2");
        modal.style.display = "none";
    }

    // "닫기" 버튼 클릭 시 모달1 닫기
    document.querySelector(".close").addEventListener("click", closeModal1);

    // 오늘 하루 열지 않기 기능 - 모달1
    const checkClose1 = document.getElementById("checkClose1");
    checkClose1.addEventListener("change", function() {
        if (checkClose1.checked) {
            localStorage.setItem("closeModal1", "true");
            closeModal1(); // 체크하면 바로 닫히도록
        } else {
            localStorage.removeItem("closeModal1");
        }
    });

    // 오늘 하루 열지 않기 기능 - 모달2
    const checkClose2 = document.getElementById("checkClose2");
    checkClose2.addEventListener("change", function() {
        if (checkClose2.checked) {
            localStorage.setItem("closeModal2", "true");
            closeModal2(); // 체크하면 바로 닫히도록
        } else {
            localStorage.removeItem("closeModal2");
        }
    });

    // 페이지 로드 후 모달 열기
    window.onload = function() {
        const closeModalFlag1 = localStorage.getItem("closeModal1");
        const closeModalFlag2 = localStorage.getItem("closeModal2");
        
        if (!closeModalFlag1) {
            openModal1();
        }
        
        if (!closeModalFlag2) {
            openModal2();
        }
    };
</script>
</body>
</html>
