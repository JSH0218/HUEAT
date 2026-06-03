package util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * 애플리케이션 외부 설정 로더.
 *
 * DB 접속 정보와 업로드 경로 등 민감/환경별 설정을 소스코드/웹루트 밖의
 * properties 파일에서 읽는다. 설정 파일 위치 결정 순서:
 *   1) 환경변수 HUEAT_CONFIG (파일 절대경로)
 *   2) 시스템 프로퍼티 hueat.config (-Dhueat.config=...)
 *   3) ${user.home}/.hueat/db.properties (기본 폴백)
 *
 * 사용 키: db.url, db.user, db.password, db.driver, upload.dir
 */
public class AppConfig {

	private static final Properties PROPS = new Properties();
	private static volatile boolean loaded = false;
	private static String loadedFrom = "(미로딩)";

	private AppConfig() {
	}

	private static synchronized void load() {
		if (loaded) {
			return;
		}
		Path path = resolveConfigPath();
		if (path == null || !Files.isReadable(path)) {
			throw new IllegalStateException(
					"HUEAT 설정 파일을 찾을 수 없습니다. 환경변수 HUEAT_CONFIG 또는 "
							+ System.getProperty("user.home") + "/.hueat/db.properties 를 확인하세요. (시도 경로: "
							+ (path == null ? "null" : path.toString()) + ")");
		}
		try (InputStream in = new FileInputStream(path.toFile())) {
			PROPS.load(in);
			loadedFrom = path.toString();
			loaded = true;
			System.out.println("[HUEAT] 설정 로드 성공: " + loadedFrom);
		} catch (IOException e) {
			throw new IllegalStateException("HUEAT 설정 파일 로드 실패: " + path, e);
		}
	}

	private static Path resolveConfigPath() {
		String env = System.getenv("HUEAT_CONFIG");
		if (env != null && !env.isBlank()) {
			return Paths.get(env.trim());
		}
		String sys = System.getProperty("hueat.config");
		if (sys != null && !sys.isBlank()) {
			return Paths.get(sys.trim());
		}
		return Paths.get(System.getProperty("user.home"), ".hueat", "db.properties");
	}

	public static String get(String key) {
		load();
		return PROPS.getProperty(key);
	}

	public static String get(String key, String defaultValue) {
		load();
		return PROPS.getProperty(key, defaultValue);
	}

	public static String getRequired(String key) {
		String v = get(key);
		if (v == null || v.isBlank()) {
			throw new IllegalStateException("필수 설정 키 누락: " + key + " (설정 파일: " + loadedFrom + ")");
		}
		return v.trim();
	}

	// 편의 접근자
	public static String getDbUrl() {
		return getRequired("db.url");
	}

	public static String getDbUser() {
		return getRequired("db.user");
	}

	public static String getDbPassword() {
		return getRequired("db.password");
	}

	public static String getDbDriver() {
		return get("db.driver", "com.mysql.cj.jdbc.Driver");
	}

	/**
	 * 업로드 파일이 저장되는 웹루트 외부 베이스 디렉토리.
	 */
	public static String getUploadDir() {
		return getRequired("upload.dir");
	}

	/**
	 * 업로드 타입별(notice/event/review/shop/hugeso) 저장 경로를 반환한다.
	 * 디렉토리가 없으면 생성한다.
	 */
	public static String getUploadPath(String type) {
		java.io.File dir = new java.io.File(getUploadDir(), type);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		return dir.getAbsolutePath();
	}
}
