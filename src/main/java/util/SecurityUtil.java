package util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.List;

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
			if (mime == null) {
				// 일부 환경에서 MIME 추정 실패 → 확장자 검증으로 대체 허용
				return true;
			}
			return mime.startsWith("image/");
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
}
