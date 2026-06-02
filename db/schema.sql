-- =====================================================================
-- HUEAT 전체 데이터베이스 스키마 (단일 소스)
-- ---------------------------------------------------------------------
-- 프로젝트의 모든 테이블 DDL을 한 곳에 모은 파일이다.
-- DAO의 실제 SQL(INSERT 컬럼 순서/타입/관계)을 기준으로 복원했다.
--
-- 적용:
--   mysql -u <user> -p < db/schema.sql
--   (DB가 없으면 먼저)  CREATE DATABASE hueat DEFAULT CHARSET utf8mb4;  USE hueat;
--
-- 규칙:
--   * 엔진 InnoDB, 문자셋 utf8mb4
--   * 각 테이블의 *_num PK는 AUTO_INCREMENT (단, qaanswerboard.qa_num 제외 — 본문 참조)
--   * 게시판의 *_myid 는 작성자 m_id 문자열을 저장(외래키 미적용: 회원 삭제와 독립적으로 글 유지)
--   * 숫자 관계 컬럼(h_num/m_num/f_num 등)은 FK로 연결, 부모 삭제 시 CASCADE
--
-- 생성 순서는 FK 의존성에 맞춰 부모 → 자식 순이다.
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- =========================== 1. 회원 ===========================
-- 보안: m_pass = BCrypt 해시(60자), m_role = USER/ADMIN(관리자 판별 기준)
CREATE TABLE IF NOT EXISTS meminfo (
  m_num     INT AUTO_INCREMENT PRIMARY KEY,
  m_name    VARCHAR(50)  NOT NULL,
  m_nick    VARCHAR(50)  NOT NULL,
  m_id      VARCHAR(50)  NOT NULL UNIQUE,
  m_pass    VARCHAR(60)  NOT NULL,                  -- BCrypt 해시
  m_hp1     VARCHAR(20),
  m_hp2     VARCHAR(20),
  m_birth   VARCHAR(20),
  m_email   VARCHAR(100),
  m_role    VARCHAR(10)  NOT NULL DEFAULT 'USER',   -- USER / ADMIN
  m_gaipday DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================= 2. 휴게소 정보 =========================
-- h_grade/h_gradecount 는 grade 테이블 평가를 집계해 갱신되는 값
CREATE TABLE IF NOT EXISTS hugesoinfo (
  h_num        INT AUTO_INCREMENT PRIMARY KEY,
  h_name       VARCHAR(100) NOT NULL,
  h_xvalue     VARCHAR(30),                          -- 좌표 X(경도)
  h_yvalue     VARCHAR(30),                          -- 좌표 Y(위도)
  h_photo      VARCHAR(255),
  h_hp         VARCHAR(30),                          -- 전화번호
  h_addr       VARCHAR(255),
  h_pyeon      VARCHAR(255),                         -- 편의시설
  h_gasolin    VARCHAR(20),                          -- 휘발유가
  h_disel      VARCHAR(20),                          -- 경유가
  h_lpg        VARCHAR(20),                          -- LPG가
  h_grade      DECIMAL(3,2) NOT NULL DEFAULT 0,      -- 평균 별점
  h_gradecount INT          NOT NULL DEFAULT 0       -- 평가 수
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================== 3. 즐겨찾기 ===========================
CREATE TABLE IF NOT EXISTS favorite (
  f_num INT AUTO_INCREMENT PRIMARY KEY,
  m_num INT NOT NULL,
  h_num INT NOT NULL,
  UNIQUE KEY uq_favorite (m_num, h_num),
  CONSTRAINT fk_fav_mem  FOREIGN KEY (m_num) REFERENCES meminfo(m_num)   ON DELETE CASCADE,
  CONSTRAINT fk_fav_huge FOREIGN KEY (h_num) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================ 4. 브랜드 ============================
CREATE TABLE IF NOT EXISTS brand (
  b_num   INT AUTO_INCREMENT PRIMARY KEY,
  h_num   INT NOT NULL,
  b_name  VARCHAR(100) NOT NULL,
  b_photo VARCHAR(255),
  b_addr  VARCHAR(255),
  CONSTRAINT fk_brand_huge FOREIGN KEY (h_num) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================== 5. 음식 메뉴 ==========================
-- f_grade 는 foodgrade 평가를 집계해 갱신되는 평균값
CREATE TABLE IF NOT EXISTS food (
  f_num   INT AUTO_INCREMENT PRIMARY KEY,
  h_num   INT NOT NULL,
  f_name  VARCHAR(100) NOT NULL,
  f_photo VARCHAR(255),
  f_price VARCHAR(20),
  f_grade DECIMAL(3,2) NOT NULL DEFAULT 0,
  CONSTRAINT fk_food_huge FOREIGN KEY (h_num) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================== 6. 음식 평점 ==========================
CREATE TABLE IF NOT EXISTS foodgrade (
  fg_num      INT AUTO_INCREMENT PRIMARY KEY,
  fg_foodnum  INT NOT NULL,
  fg_hugesonum INT NOT NULL,
  fg_myid     VARCHAR(50) NOT NULL,
  fg_grade    INT NOT NULL,                          -- 1~5
  CONSTRAINT fk_fg_food FOREIGN KEY (fg_foodnum)   REFERENCES food(f_num)       ON DELETE CASCADE,
  CONSTRAINT fk_fg_huge FOREIGN KEY (fg_hugesonum) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================= 7. 푸드코트 장바구니 =======================
CREATE TABLE IF NOT EXISTS foodcart (
  cart_idx INT AUTO_INCREMENT PRIMARY KEY,
  h_num    INT NOT NULL,
  f_num    INT NOT NULL,
  m_num    INT NOT NULL,
  cart_cnt INT NOT NULL DEFAULT 1,
  cartday  DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cart_huge FOREIGN KEY (h_num) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE,
  CONSTRAINT fk_cart_food FOREIGN KEY (f_num) REFERENCES food(f_num)       ON DELETE CASCADE,
  CONSTRAINT fk_cart_mem  FOREIGN KEY (m_num) REFERENCES meminfo(m_num)    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================== 8. 휴게소 평점 ==========================
CREATE TABLE IF NOT EXISTS grade (
  g_num     INT AUTO_INCREMENT PRIMARY KEY,
  h_num     INT NOT NULL,
  g_myid    VARCHAR(50) NOT NULL,
  g_content VARCHAR(255),                            -- 한줄 평/태그
  g_grade   INT NOT NULL,                            -- 1~5
  g_writeday DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_grade_huge FOREIGN KEY (h_num) REFERENCES hugesoinfo(h_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================== 9. 공지사항 ===========================
CREATE TABLE IF NOT EXISTS noticeboard (
  n_num      INT AUTO_INCREMENT PRIMARY KEY,
  n_myid     VARCHAR(50)  NOT NULL,
  n_subject  VARCHAR(255) NOT NULL,
  n_content  TEXT,
  n_image    VARCHAR(255),
  n_readcount INT NOT NULL DEFAULT 0,
  n_chu      INT NOT NULL DEFAULT 0,
  n_writeday DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================== 10. 이벤트 ===========================
CREATE TABLE IF NOT EXISTS eventboard (
  e_num      INT AUTO_INCREMENT PRIMARY KEY,
  e_myid     VARCHAR(50)  NOT NULL,
  e_subject  VARCHAR(255) NOT NULL,
  e_content  TEXT,
  e_image    VARCHAR(255),
  e_readcount INT NOT NULL DEFAULT 0,
  e_chu      INT NOT NULL DEFAULT 0,
  e_writeday DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================= 11. 고객문의(Q) =========================
CREATE TABLE IF NOT EXISTS qaboard (
  q_num      INT AUTO_INCREMENT PRIMARY KEY,
  q_myid     VARCHAR(50)  NOT NULL,
  q_category VARCHAR(50),
  q_subject  VARCHAR(255) NOT NULL,
  q_content  TEXT,
  q_readcount INT NOT NULL DEFAULT 0,
  q_writeday DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================= 12. 고객문의 답변(A) =======================
-- qa_num 은 전역 AUTO_INCREMENT가 아니라 q_num별로 (MAX+1)로 매겨진다.
-- 따라서 (q_num, qa_num) 복합 PK이며 qa_num에 AUTO_INCREMENT를 두지 않는다.
CREATE TABLE IF NOT EXISTS qaanswerboard (
  q_num      INT NOT NULL,
  qa_num     INT NOT NULL,
  qa_myid    VARCHAR(50) NOT NULL,
  qa_content VARCHAR(1000),
  qa_writeday DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (q_num, qa_num),
  CONSTRAINT fk_qaans_qa FOREIGN KEY (q_num) REFERENCES qaboard(q_num) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================== 13. 리뷰 ===========================
CREATE TABLE IF NOT EXISTS reviewboard (
  r_num      INT AUTO_INCREMENT PRIMARY KEY,
  r_myid     VARCHAR(50) NOT NULL,
  r_category VARCHAR(50),
  r_content  TEXT,
  r_image    VARCHAR(255),
  r_chu      INT NOT NULL DEFAULT 0,
  r_writeday DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================== 14. 쇼핑몰 ===========================
CREATE TABLE IF NOT EXISTS shop (
  s_num     INT AUTO_INCREMENT PRIMARY KEY,
  s_category VARCHAR(50),
  s_site    VARCHAR(255),                            -- 외부 쇼핑 링크
  s_image   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
-- 초기 관리자 계정 (필수)
-- 관리자 판별이 role 기반이므로 m_role='ADMIN' 행이 반드시 하나 있어야 한다.
-- 아래 해시는 평문 'admin1234'의 BCrypt 해시다. 최초 로그인 후 변경할 것.
-- =====================================================================
INSERT INTO meminfo (m_name, m_nick, m_id, m_pass, m_hp1, m_hp2, m_birth, m_email, m_role)
SELECT '관리자', 'admin', 'admin',
       '$2a$12$GF3IbefsD0JCORTJdG/iK.krwpz.Oz.phK0hZ0slrHZIRQGiKJzby',
       'SKT', '01000000000', '2000-01-01', 'admin@hueat.local', 'ADMIN'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM meminfo WHERE m_id = 'admin');
