-- 실행 스모크 테스트용 최소 시드 데이터 (db/schema.sql 적용 직후 실행)
-- 관리자 계정(admin / admin1234)은 schema.sql의 초기 INSERT가 만든다.
INSERT INTO hugesoinfo (h_name, h_xvalue, h_yvalue, h_photo, h_hp, h_addr, h_pyeon, h_gasolin, h_disel, h_lpg)
VALUES ('스모크휴게소', '127.0', '37.0', '없음.jpg', '02-000-0000', '서울시 테스트로 1', '화장실', '1600', '1500', '1000');

INSERT INTO noticeboard (n_myid, n_subject, n_content) VALUES ('admin', '스모크 공지', '공지 내용');
INSERT INTO eventboard (e_myid, e_subject, e_content) VALUES ('admin', '스모크 이벤트', '이벤트 내용');

-- Q&A는 모두 비밀글: 관리자가 쓴 글을 일반 사용자가 열람하지 못해야 한다
INSERT INTO qaboard (q_myid, q_category, q_subject, q_content) VALUES ('admin', '기타', '관리자 비밀글', '비밀 내용');

-- 저장형 XSS 확인용: 서버가 형식을 검사하지 않던 생년월일(VARCHAR(20))에 20자 스크립트를 넣은 회원
INSERT INTO meminfo (m_name, m_nick, m_id, m_pass, m_hp1, m_hp2, m_birth, m_email)
VALUES ('스모크XSS', 'xssnick', 'xssuser', 'x', 'SKT', '01099999999', '<svg onload=alert()>', 'xss@hueat.local');

-- 정상 흐름(장바구니 담기) 확인용 메뉴: 휴게소 1번의 푸드코트 메뉴
INSERT INTO food (h_num, f_name, f_photo, f_price) VALUES (1, '스모크메뉴', '없음.jpg', '5000');
