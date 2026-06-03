package util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLConnection;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.oreilly.servlet.MultipartRequest;

/**
 * 보안 공용 유틸리티.
 * - XSS 방지를 위한 출력 이스케이프(escapeHtml/escapeJs/nl2brEscaped)
 * - 비밀번호 BCrypt 해싱/검증(hashPassword/checkPassword)
 * - 예약 아이디 차단(isReservedId)
 * - 업로드 이미지 검증(isAllowedImage)
 *
 * 프레임워크(JSTL/Spring) 미사용 코드베이스이므로 JSP의 &lt;%= %&gt; 표현식에서
 * 직접 호출하여 사용한다.
 */
public class SecurityUtil {

	private SecurityUtil() {
	}

	// ===== XSS 방지 =====

	/**
	 * HTML 본문/속성 출력용 이스케이프. null 안전.
	 */
	public static String escapeHtml(String s) {
		if (s == null) {
			return "";
		}
		StringBuilder sb = new StringBuilder(s.length() + 16);
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			switch (c) {
				case '&':
					sb.append("&amp;");
					break;
				case '<':
					sb.append("&lt;");
					break;
				case '>':
					sb.append("&gt;");
					break;
				case '"':
					sb.append("&quot;");
					break;
				case '\'':
					sb.append("&#39;");
					break;
				case '/':
					sb.append("&#47;");
					break;
				default:
					sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * JavaScript 문자열/JSON 컨텍스트 출력용 이스케이프. null 안전.
	 * 서버에서 JSON 값에 담거나 인라인 스크립트에 출력할 때 사용한다.
	 */
	public static String escapeJs(String s) {
		if (s == null) {
			return "";
		}
		StringBuilder sb = new StringBuilder(s.length() + 16);
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			switch (c) {
				case '\\':
					sb.append("\\\\");
					break;
				case '"':
					sb.append("\\\"");
					break;
				case '\'':
					sb.append("\\'");
					break;
				case '<':
					sb.append("\\u003C");
					break;
				case '>':
					sb.append("\\u003E");
					break;
				case '&':
					sb.append("\\u0026");
					break;
				case '\n':
					sb.append("\\n");
					break;
				case '\r':
					sb.append("\\r");
					break;
				case '\t':
					sb.append("\\t");
					break;
				default:
					sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * 본문 출력용: 먼저 HTML 이스케이프한 뒤 개행(\n)을 &lt;br&gt;로 변환한다.
	 * 기존 코드의 content.replace("\n","&lt;br&gt;")는 이스케이프를 거치지 않아
	 * XSS에 노출되므로 반드시 이 메서드로 대체한다.
	 */
	public static String nl2brEscaped(String s) {
		if (s == null) {
			return "";
		}
		return escapeHtml(s).replace("\n", "<br>");
	}

	/**
	 * 숫자 ID/페이지 번호 파라미터 정규화. 입력이 0~9로만 구성된 경우 그대로 반환하고,
	 * 그 외(null/빈값/비숫자)는 빈 문자열을 반환한다.
	 * 반사형 XSS 방지: 숫자 파라미터를 인라인 JS/속성에 출력하기 전 이 메서드로 정규화한다.
	 * (인라인 onclick은 HTML 디코딩 후 JS 실행되므로 escapeHtml만으로는 불충분 → 숫자 강제)
	 */
	public static String digitsOnly(String s) {
		if (s == null || s.isEmpty()) {
			return "";
		}
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			if (c < '0' || c > '9') {
				return "";
			}
		}
		return s;
	}

	/**
	 * href 속성에 출력할 외부 링크 URL을 검증한다.
	 * http/https 절대경로만 허용하고, javascript:/data:/vbscript: 등 위험 스킴은 차단한다.
	 * 허용 시 HTML 이스케이프한 값을, 미허용/null 시 "#"을 반환한다.
	 * (관리자 입력 링크라도 스킴 검증으로 XSS·정책 위반을 방지)
	 */
	public static String safeUrl(String url) {
		if (url == null) {
			return "#";
		}
		String trimmed = url.trim();
		String lower = trimmed.toLowerCase();
		if (lower.startsWith("http://") || lower.startsWith("https://")) {
			return escapeHtml(trimmed);
		}
		return "#";
	}

	/**
	 * URL 쿼리 파라미터용 인코딩(이미지 파일명이 한글 등 비ASCII일 수 있음). null 안전.
	 */
	public static String urlEncode(String s) {
		if (s == null) {
			return "";
		}
		try {
			return java.net.URLEncoder.encode(s, "UTF-8");
		} catch (Exception e) {
			return "";
		}
	}

	// ===== 비밀번호 해싱 =====

	/**
	 * 평문 비밀번호를 BCrypt 해시로 변환한다. 결과는 60자 문자열.
	 */
	public static String hashPassword(String plain) {
		if (plain == null) {
			plain = "";
		}
		return BCrypt.hashpw(plain, BCrypt.gensalt(12));
	}

	/**
	 * 평문 비밀번호와 저장된 BCrypt 해시가 일치하는지 검증한다.
	 */
	public static boolean checkPassword(String plain, String hashed) {
		if (plain == null || hashed == null || hashed.isEmpty()) {
			return false;
		}
		try {
			return BCrypt.checkpw(plain, hashed);
		} catch (IllegalArgumentException e) {
			// 저장된 값이 BCrypt 형식이 아닌 경우(예: 잘못된 데이터)
			return false;
		}
	}

	// ===== 예약 아이디 =====

	private static final List<String> RESERVED_IDS = Arrays.asList(
			"admin", "administrator", "root", "system", "superuser", "sysadmin", "manager");

	/**
	 * 회원가입 시 차단해야 하는 예약 아이디인지 판별한다(대소문자 무시).
	 */
	public static boolean isReservedId(String id) {
		if (id == null) {
			return false;
		}
		return RESERVED_IDS.contains(id.trim().toLowerCase());
	}

	// ===== 업로드 이미지 검증 =====

	private static final List<String> ALLOWED_IMAGE_EXT = Arrays.asList("jpg", "jpeg", "png", "gif");

	/**
	 * 업로드된 파일이 허용 이미지인지 검증한다.
	 * 확장자 화이트리스트 + 실제 콘텐츠 시그니처(MIME) 이중 검증.
	 *
	 * @param filename  검증할 파일명(원본 또는 저장명)
	 * @param savedFile 디스크에 저장된 실제 파일(콘텐츠 검사용). null이면 확장자만 검사.
	 */
	public static boolean isAllowedImage(String filename, File savedFile) {
		if (filename == null) {
			return false;
		}
		int dot = filename.lastIndexOf('.');
		if (dot < 0 || dot == filename.length() - 1) {
			return false;
		}
		String ext = filename.substring(dot + 1).toLowerCase();
		if (!ALLOWED_IMAGE_EXT.contains(ext)) {
			return false;
		}

		if (savedFile == null || !savedFile.exists()) {
			// 콘텐츠 검사 불가 시 확장자 통과만으로 판단
			return true;
		}

		try (InputStream in = new FileInputStream(savedFile)) {
			String mime = URLConnection.guessContentTypeFromStream(in);
			if (mime != null) {
				return mime.startsWith("image/");
			}
			// MIME 추정 실패 시 확장자만으로 통과하지 않고, 매직바이트(파일 시그니처)를 직접 검사한다.
			return hasImageMagicBytes(savedFile);
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 파일 앞부분의 매직바이트로 실제 이미지(JPEG/PNG/GIF/BMP/WEBP)인지 검사한다.
	 * URLConnection.guessContentTypeFromStream이 null을 반환하는 환경에서의 보강 검증.
	 */
	private static boolean hasImageMagicBytes(File f) {
		try (InputStream in = new FileInputStream(f)) {
			byte[] b = new byte[12];
			int n = in.read(b);
			if (n < 4) {
				return false;
			}
			int b0 = b[0] & 0xFF, b1 = b[1] & 0xFF, b2 = b[2] & 0xFF, b3 = b[3] & 0xFF;
			// JPEG: FF D8 FF
			if (b0 == 0xFF && b1 == 0xD8 && b2 == 0xFF) {
				return true;
			}
			// PNG: 89 50 4E 47
			if (b0 == 0x89 && b1 == 0x50 && b2 == 0x4E && b3 == 0x47) {
				return true;
			}
			// GIF: 47 49 46 38 (GIF8)
			if (b0 == 0x47 && b1 == 0x49 && b2 == 0x46 && b3 == 0x38) {
				return true;
			}
			// BMP: 42 4D (BM)
			if (b0 == 0x42 && b1 == 0x4D) {
				return true;
			}
			// WEBP: "RIFF"...."WEBP"
			if (n >= 12 && b0 == 0x52 && b1 == 0x49 && b2 == 0x46 && b3 == 0x46
					&& (b[8] & 0xFF) == 0x57 && (b[9] & 0xFF) == 0x45
					&& (b[10] & 0xFF) == 0x42 && (b[11] & 0xFF) == 0x50) {
				return true;
			}
			return false;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 업로드 직후 검증 헬퍼.
	 * COS MultipartRequest는 파일을 즉시 디스크에 기록하므로, 저장된 파일을 검증해
	 * 허용 이미지가 아니면 삭제한다.
	 *
	 * @param dir      파일이 저장된 디렉토리
	 * @param filename multi.getFilesystemName(...) 결과(미첨부 시 null)
	 * @return 첨부가 없거나(허용) 검증 통과 시 true, 위반 파일이라 삭제했으면 false
	 */
	public static boolean validateOrDelete(String dir, String filename) {
		if (filename == null) {
			return true; // 파일 미첨부 — 허용
		}
		File f = new File(dir, filename);
		if (isAllowedImage(filename, f)) {
			return true;
		}
		if (f.exists()) {
			f.delete();
		}
		return false;
	}

	/**
	 * MultipartRequest로 저장된 모든 업로드 파일을 검증한다.
	 * 하나라도 허용 이미지가 아니면 저장된 모든 업로드 파일을 삭제하고 false를 반환한다.
	 * (여러 개의 파일 필드를 사용하는 업로드 폼에 사용)
	 *
	 * @param multi 업로드 처리에 사용된 MultipartRequest
	 * @param dir   파일이 저장된 디렉토리
	 */
	public static boolean validateAllUploads(MultipartRequest multi, String dir) {
		List<String> saved = new ArrayList<>();
		Enumeration<?> fields = multi.getFileNames();
		while (fields.hasMoreElements()) {
			String field = (String) fields.nextElement();
			String fname = multi.getFilesystemName(field);
			if (fname != null) {
				saved.add(fname);
			}
		}

		boolean allOk = true;
		for (String fname : saved) {
			if (!isAllowedImage(fname, new File(dir, fname))) {
				allOk = false;
				break;
			}
		}

		if (!allOk) {
			for (String fname : saved) {
				File f = new File(dir, fname);
				if (f.exists()) {
					f.delete();
				}
			}
		}
		return allOk;
	}

	// ===== 접근 제어(인증/권한) 가드 =====
	// 프레임워크(서블릿 필터/Spring Security) 미사용이므로 각 액션 JSP 진입부에서
	// 아래 boolean 헬퍼를 호출하고, false면 직접 sendRedirect + return 한다.
	// (JSP 페이지에서 return해야 하므로 헬퍼는 응답을 종료하지 않고 판별만 한다.)

	/**
	 * 현재 세션이 관리자(role=ADMIN)인지 판별한다. null 세션 안전.
	 */
	public static boolean isAdmin(HttpSession session) {
		return session != null && "ADMIN".equals(session.getAttribute("role"));
	}

	/**
	 * 현재 세션이 로그인 상태인지 판별한다(loginok=yes). null 세션 안전.
	 */
	public static boolean isLogin(HttpSession session) {
		return session != null && "yes".equals(session.getAttribute("loginok"));
	}

	/**
	 * 현재 로그인 사용자 아이디(myid)를 반환한다. 비로그인/null 세션이면 null.
	 */
	public static String currentId(HttpSession session) {
		if (session == null) {
			return null;
		}
		return (String) session.getAttribute("myid");
	}

	/**
	 * 소유자 본인이거나 관리자인지 판별한다(게시글 수정/삭제 권한 검사용).
	 *
	 * @param session 현재 세션
	 * @param ownerId 자원 소유자 아이디(DB에서 조회한 작성자)
	 */
	public static boolean isOwnerOrAdmin(HttpSession session, String ownerId) {
		if (isAdmin(session)) {
			return true;
		}
		String myid = currentId(session);
		return myid != null && myid.equals(ownerId);
	}

	// ===== CSRF 토큰 =====

	public static final String CSRF_SESSION_KEY = "_csrfToken";
	public static final String CSRF_PARAM = "_csrf";
	private static final SecureRandom CSRF_RANDOM = new SecureRandom();

	/**
	 * 현재 세션의 CSRF 토큰을 반환한다. 없으면 새로 생성해 세션에 저장한다.
	 * 폼에 &lt;input type="hidden" name="_csrf" value="..."&gt;로 출력한다.
	 */
	public static String csrfToken(HttpSession session) {
		if (session == null) {
			return "";
		}
		String token = (String) session.getAttribute(CSRF_SESSION_KEY);
		if (token == null || token.isEmpty()) {
			byte[] buf = new byte[32];
			CSRF_RANDOM.nextBytes(buf);
			StringBuilder sb = new StringBuilder(buf.length * 2);
			for (byte b : buf) {
				sb.append(Character.forDigit((b >> 4) & 0xF, 16));
				sb.append(Character.forDigit(b & 0xF, 16));
			}
			token = sb.toString();
			session.setAttribute(CSRF_SESSION_KEY, token);
		}
		return token;
	}

	/**
	 * 요청 파라미터 _csrf가 세션 토큰과 일치하는지 상수시간 비교로 검증한다.
	 * 상태 변경(POST) 액션 진입부에서 호출하고, false면 요청을 거부한다.
	 */
	public static boolean checkCsrf(HttpServletRequest request) {
		if (request == null) {
			return false;
		}
		HttpSession session = request.getSession(false);
		if (session == null) {
			return false;
		}
		String expected = (String) session.getAttribute(CSRF_SESSION_KEY);
		String actual = request.getParameter(CSRF_PARAM);
		if (expected == null || actual == null) {
			return false;
		}
		return constantTimeEquals(expected, actual);
	}

	private static boolean constantTimeEquals(String a, String b) {
		if (a.length() != b.length()) {
			return false;
		}
		int diff = 0;
		for (int i = 0; i < a.length(); i++) {
			diff |= a.charAt(i) ^ b.charAt(i);
		}
		return diff == 0;
	}

	// ===== index.jsp 동적 include 화이트리스트 =====
	// 사용자가 main 파라미터로 임의 경로를 include하지 못하도록(LFI/경로조작/소스노출 차단)
	// 합법적으로 도달 가능한 페이지만 허용한다. 미허용 시 호출부에서 기본 페이지로 폴백한다.

	// 비교는 대소문자 무시(소문자)로 한다. Windows의 대소문자 무시 파일시스템에서
	// 일부 링크가 대소문자 불일치(예: myreviewList.jsp)로 동작하던 것을 깨지 않기 위함.
	private static final java.util.Set<String> ALLOWED_MAIN_PAGES = new java.util.HashSet<>(Arrays.asList(
			"layout/main.jsp",
			"intro/intro.jsp",
			// 회원/마이페이지
			"member/loginform.jsp", "member/gaipform.jsp", "member/idsearchform.jsp", "member/passSearchform.jsp",
			"mypage/updateform.jsp", "mypage/deleteform.jsp", "mypage/updatepassform.jsp",
			"mypage/memberlist.jsp", "mypage/favlist.jsp",
			"mypage/myqnalist.jsp", "mypage/myreviewlist.jsp",
			"mypage/adminqnalist.jsp", "mypage/adminnoticelist.jsp", "mypage/admineventlist.jsp",
			// 휴게소
			"hugesoinfo/hugesomap.jsp", "hugesoinfo/hugesolist.jsp", "hugesoinfo/hugesolist2.jsp",
			"hugesoinfo/hugesolistsearch.jsp", "hugesoinfo/hugesolist2search.jsp",
			"hugesoinfo/hugesodetail.jsp", "hugesoinfo/hugesoaddform.jsp", "hugesoinfo/hugesoupdateform.jsp",
			// 푸드코트/쇼핑
			"foodcourt/choicehuegeso.jsp", "foodcourt/foodmenu.jsp",
			"shop/shopList.jsp", "shop/shopForm.jsp",
			// 게시판
			"noticeboard/noticeList.jsp", "noticeboard/noticeDetail.jsp", "noticeboard/noticeForm.jsp", "noticeboard/noticeUpdateForm.jsp",
			"eventboard/eventList.jsp", "eventboard/eventDetail.jsp", "eventboard/eventForm.jsp", "eventboard/eventUpdateForm.jsp",
			"qaboard/qaList.jsp", "qaboard/qaDetail.jsp", "qaboard/qaForm.jsp", "qaboard/qaUpdateForm.jsp",
			"reviewboard/reviewList.jsp", "reviewboard/reviewUpdateForm.jsp"));

	/**
	 * index.jsp의 main 파라미터로 include 허용된 페이지인지 검증한다.
	 * 중첩 쿼리스트링(예: "qaboard/qaDetail.jsp?q_num=5")이 올 수 있으므로 '?' 앞부분만 비교한다.
	 *
	 * @param mainParam request.getParameter("main") 원본 값
	 * @return 허용된 페이지면 true
	 */
	public static boolean isAllowedMainPage(String mainParam) {
		if (mainParam == null) {
			return false;
		}
		String pagePath = mainParam;
		int q = pagePath.indexOf('?');
		if (q >= 0) {
			pagePath = pagePath.substring(0, q);
		}
		String lower = pagePath.toLowerCase();
		for (String allowed : ALLOWED_MAIN_PAGES) {
			if (allowed.toLowerCase().equals(lower)) {
				return true;
			}
		}
		return false;
	}
}
