<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<style>

	.sns_btn{
		border: none; 
		background: none; 
		cursor: pointer;
		width:40px; 
		height:40px;
	}
</style>

<script type="text/javascript">

// NAVER
function shareNaver() {
  const title = "HUEAT";
  var thisUrl = document.URL; 
  window.open(
    "https://share.naver.com/web/shareView?url=" + encodeURIComponent(thisUrl) + "&title=" + encodeURIComponent(title)
  );
}

// Facebook
function shareFacebook() {
  const title = "HUEAT";
  var thisUrl = document.URL; 
  window.open(
    "http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(thisUrl) + "&title=" + encodeURIComponent(title)
  );
}

// Twitter
function shareTwitter() {
  const text = "HUEAT";
  var thisUrl = document.URL; 
  window.open(
    "https://twitter.com/intent/tweet?text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(thisUrl)
  );
}

// Kakao Talk
function shareKakao() {
  Kakao.init("5a77ce427996f7b3cb3de14e9a4e0444");
  var thisUrl = document.URL; 
  Kakao.Link.sendDefault({
    objectType: 'feed',
    content: {
      title: "HUEAT",
      description: "휴게소 홈페이지",
      imageUrl: "preview_image.png (1000*1000)",
      link: {
        mobileWebUrl: thisUrl,
        webUrl: thisUrl,
      },
    },
  });
}
</script>
</head>

<body>
      <!-- Kakao -->
      <button type="button"class="sns_btn">
        <a id="kakao-link-btn" href="javascript:shareKakao()">
          <img src="image/icon/kakao.png" alt="카카오톡 공유하기">
        </a>
      </button>
      
      <!-- NAVER -->
      <button type="button" class="sns_btn" onclick="shareNaver()" >
        <img src="image/icon/naver.png" alt="네이버 공유하기">
      </button>
      
      <!-- Facebook -->
      <!-- facebook은 공유하려는 페이지에 meta og 설정 -->
      <button type="button" class="sns_btn" onclick="shareFacebook()">
        <img src="image/icon/facebook.png" alt="페이스북 공유하기">
      </button>
      
      <!-- Twitter -->
      <!-- script 작성 시 -->
      <button type="button" class="sns_btn" onclick="shareTwitter()">
        <img src="image/icon/twitter.png" alt="트위터 공유하기">
      </button>

</body>
</html>
