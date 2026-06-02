package util;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 웹루트 외부에 저장된 업로드 이미지를 HTTP로 제공하는 서블릿.
 *
 * 사용: /fileview?type=notice&name=abc.jpg
 *  - type: 허용된 업로드 타입(notice/event/review/shop/hugeso)만 가능
 *  - name: 파일명. 경로 구분자/상위 경로 이동(..) 차단
 *
 * 업로드 디렉토리가 웹루트 밖에 있으므로 .jsp 등 실행 파일이 올라가도 직접 실행되지 않으며,
 * 본 서블릿은 이미지 외 요청을 거부한다.
 */
@WebServlet("/fileview")
public class ImageServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final List<String> ALLOWED_TYPES =
			Arrays.asList("notice", "event", "review", "shop", "hugeso");

	private static final List<String> ALLOWED_EXT =
			Arrays.asList("jpg", "jpeg", "png", "gif");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		String type = req.getParameter("type");
		String name = req.getParameter("name");

		// 타입 화이트리스트 검증
		if (type == null || !ALLOWED_TYPES.contains(type)) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		// 파일명 검증: 경로 조작 차단
		if (name == null || name.isBlank()
				|| name.contains("..") || name.contains("/") || name.contains("\\")) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		// 확장자 화이트리스트
		int dot = name.lastIndexOf('.');
		if (dot < 0 || !ALLOWED_EXT.contains(name.substring(dot + 1).toLowerCase())) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		File baseDir = new File(AppConfig.getUploadPath(type));
		File target = new File(baseDir, name);

		// 정규화 후 베이스 디렉토리 하위인지 재확인(이중 방어)
		String basePath = baseDir.getCanonicalPath();
		String targetPath = target.getCanonicalPath();
		if (!targetPath.startsWith(basePath + File.separator) && !targetPath.equals(basePath)) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		if (!target.exists() || !target.isFile()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		// Content-Type 설정
		String mime = getServletContext().getMimeType(target.getName());
		if (mime == null || !mime.startsWith("image/")) {
			mime = "application/octet-stream";
		}
		resp.setContentType(mime);
		resp.setContentLengthLong(target.length());

		try (OutputStream out = resp.getOutputStream()) {
			Files.copy(target.toPath(), out);
		}
	}
}
