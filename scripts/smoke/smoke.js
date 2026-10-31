// 실행 스모크 테스트 시나리오 (Playwright, scripts/runtime-smoke.sh가 실행한다)
//
// 실제로 띄운 Tomcat+DB에 브라우저로 접속해 주요 화면과 권한 흐름을 확인한다.
// 각 시나리오는 "[smoke] PASS/FAIL 이름"을 출력한다. 실패한 시나리오가 하나라도 있으면 종료코드 1, 모두 통과하면 0이다
// (실패 수를 종료코드로 쓰면 "2 이상 = 환경 문제"와 겹치므로 쓰지 않는다).
// 끝까지 실행되면 실패한 시나리오 이름을 SMOKE_FAILED_OUT 파일에 한 줄씩 쓴다(파일이 없으면 중간에 끝난 것).
// 외부 CDN(jQuery·카카오 지도 등) 로딩 실패는 판정에 쓰지 않는다. 같은 출처의 5xx 응답만 실패로 본다.
// 컨테이너에서는 외부 CDN이 막혀 있으므로, 화면이 쓰는 jQuery 3.7.0은 SMOKE_JQUERY 경로의 같은 버전 파일로 대신 응답하고
// 그 밖의 외부 요청(카카오 지도·폰트·Bootstrap 등)은 즉시 차단해 결과가 매번 같게 한다.
//
// 기능을 고치거나 추가하면 그 동작을 확인하는 시나리오를 여기에 추가한다.
const { chromium } = require('playwright');
const { spawnSync } = require('child_process');

const BASE = process.env.SMOKE_BASE || 'http://localhost:18080/HuEatProject/';
const DB = process.env.SMOKE_DB || 'hueat_smoke';
const JQUERY = process.env.SMOKE_JQUERY;

// 스모크 DB에 SQL을 실행해 결과(탭 구분 텍스트)를 돌려준다. 정상 흐름이 DB에 실제로 반영됐는지 확인할 때 쓴다.
function db(sql) {
  const r = spawnSync('mysql', ['-uroot', '-N', '-B', '--default-character-set=utf8mb4', DB, '-e', sql], { encoding: 'utf8' });
  if (r.status !== 0) throw new Error('DB 조회 실패: ' + (r.stderr || '').trim());
  return r.stdout.trim();
}
const sqlStr = v => "'" + String(v).replace(/\\/g, '\\\\').replace(/'/g, "''") + "'";

// 같은 세션(쿠키)으로 요청해 원본 HTML을 받는다. 안내창·이동 스크립트가 실행되기 전의 응답이므로,
// 차단 가드보다 앞에서 데이터나 관리자 기능이 출력되면 여기서 드러난다.
async function raw(page, path) {
  const r = await page.context().request.get(BASE + path);
  return r.text();
}
const results = [];
const failedNames = [];
const record = (name, ok, detail) => {
  results.push(ok);
  if (!ok) failedNames.push(name);
  console.log(`[smoke] ${ok ? 'PASS' : 'FAIL'} ${name}${ok || !detail ? '' : ' — ' + detail}`);
};

// 새 브라우저 컨텍스트(쿠키·세션 분리)와 페이지를 만든다. 안내창은 기록 후 자동 확인한다.
async function newPage(browser) {
  const ctx = await browser.newContext();
  // 같은 출처 요청은 가로채지 않는다(폼 POST 본문이 빠지지 않게). 외부 요청만 jQuery 대체 또는 차단
  await ctx.route(u => !u.href.startsWith(BASE), route => {
    const url = route.request().url();
    if (JQUERY && /code\.jquery\.com\/jquery-3\.7\.0(\.min)?\.js/.test(url)) {
      return route.fulfill({ path: JQUERY, contentType: 'application/javascript' });
    }
    return route.abort();
  });
  const page = await ctx.newPage();
  page.alerts = [];
  page.errors5xx = [];
  page.on('dialog', d => { page.alerts.push(d.message()); d.accept().catch(() => {}); });
  page.on('response', r => {
    if (r.url().startsWith(BASE) && r.status() >= 500) page.errors5xx.push(`${r.status()} ${r.url()}`);
  });
  return page;
}

async function open(page, path) {
  page.alerts = [];
  page.errors5xx = [];
  const resp = await page.goto(BASE + path, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(800); // 인라인 스크립트의 안내창·이동을 기다린다
  return resp;
}

async function login(page, id, pass) {
  await open(page, 'member/loginform.jsp');
  await page.fill('input[name=m_id]', id);
  await page.fill('input[name=m_pass]', pass);
  await page.locator('form[action="loginaction.jsp"]').evaluate(f => f.submit());
  await page.waitForLoadState('load');
  await page.waitForTimeout(800);
  await open(page, 'index.jsp');
  return (await page.content()).includes('로그아웃');
}

// 가입 폼을 채워 제출한다(클라이언트 검사는 건너뛰고 서버 검증을 확인한다)
async function signup(page, id) {
  await open(page, 'member/gaipform.jsp');
  const fill = async (sel, v) => { if (await page.locator(sel).count()) await page.fill(sel, v); };
  await fill('input[name=m_id]', id);
  await fill('input[name=m_nick]', 'smoke');
  await fill('input[name=m_pass]', 'smokepw123');
  await fill('input[name=m_pass2]', 'smokepw123');
  await fill('input[name=m_email]', 'smoke@hueat.local');
  await fill('input[name=m_name]', '스모크');
  await fill('input[name=m_hp2]', '01012345678');
  await page.locator('#frm').evaluate(f => f.submit());
  await page.waitForLoadState('load');
  await page.waitForTimeout(800);
}

// 폼 제출·버튼 클릭이 일으키는 페이지 이동이 끝날 때까지 기다린다(이미 로드된 현재 페이지 기준으로 바로 끝나는 경쟁 상태 방지)
async function submitAndWait(page, action) {
  await Promise.all([page.waitForNavigation({ waitUntil: 'load', timeout: 30000 }), action()]);
  await page.waitForTimeout(500);
}

// 시나리오를 실행한다. 실패하면 한 번 더 시도해(고정 대기 때문에 생기는 흔들림 완화) 두 번 모두 실패할 때만 FAIL로 기록한다.
async function check(name, fn) {
  let detail;
  for (let attempt = 1; attempt <= 2; attempt++) {
    try {
      const r = await fn();
      if (r === true) { record(name, true); return; }
      detail = typeof r === 'string' ? r : undefined;
    } catch (e) {
      detail = e.message.split('\n')[0];
    }
  }
  record(name, false, detail);
}

(async () => {
  const browser = await chromium.launch();

  // 1) 공개 화면: 200 응답, 같은 출처 5xx 없음, 오류 페이지 아님
  const publicPages = [
    'index.jsp',
    'index.jsp?main=intro/intro.jsp',
    'index.jsp?main=hugesoinfo/hugesomap.jsp',
    'index.jsp?main=hugesoinfo/hugesolist.jsp',
    'index.jsp?main=hugesoinfo/hugesolist2.jsp',
    'index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=1',
    'index.jsp?main=foodcourt/choicehuegeso.jsp',
    'index.jsp?main=shop/shopList.jsp',
    'index.jsp?main=noticeboard/noticeList.jsp',
    'index.jsp?main=noticeboard/noticeDetail.jsp?n_num=1',
    'index.jsp?main=eventboard/eventList.jsp',
    'index.jsp?main=eventboard/eventDetail.jsp?e_num=1',
    'index.jsp?main=qaboard/qaList.jsp',
    'index.jsp?main=reviewboard/reviewList.jsp',
    'member/loginform.jsp',
    'member/gaipform.jsp',
  ];
  const anon = await newPage(browser);
  for (const path of publicPages) {
    await check(`공개 화면 ${path}`, async () => {
      const resp = await open(anon, path);
      const body = await anon.content();
      if (resp.status() !== 200) return `HTTP ${resp.status()}`;
      if (anon.errors5xx.length) return anon.errors5xx.join(', ');
      if (/요청을 처리하는 중 문제가 발생했습니다|Exception|HTTP Status 5\d\d/.test(body)) return '오류 페이지 표시';
      return true;
    });
  }

  // 2) 비로그인 사용자: 관리자 화면·비밀글 차단
  // 관리자 글쓰기·수정 폼(공지·이벤트·상품·휴게소)
  const adminForms = ['noticeboard/noticeForm.jsp', 'noticeboard/noticeUpdateForm.jsp?n_num=1',
    'eventboard/eventForm.jsp', 'eventboard/eventUpdateForm.jsp?e_num=1', 'shop/shopForm.jsp',
    'hugesoinfo/hugesoaddform.jsp', 'hugesoinfo/hugesoupdateform.jsp?h_num=1'];
  // 관리자 화면이 출력하는 관리자 전용 액션 경로. 차단된 사용자의 원본 응답에 있으면 가드보다 앞에서 화면이 출력된 것이다
  const adminMarker = {
    // 목록 화면은 가드 앞 정적 스크립트에 삭제 경로가 있으므로 실제 데이터(시드의 비밀글 제목)로 본다.
    // 공지·이벤트 목록은 공개 데이터라 표식 없이 안내창·이동만 본다
    'mypage/adminqnalist.jsp': '관리자 비밀글',
    'noticeboard/noticeForm.jsp': 'noticeAction.jsp', 'noticeboard/noticeUpdateForm.jsp?n_num=1': 'noticeUpdateAction.jsp',
    'eventboard/eventForm.jsp': 'eventAction.jsp', 'eventboard/eventUpdateForm.jsp?e_num=1': 'eventUpdateAction.jsp',
    'shop/shopForm.jsp': 'shopAction.jsp', 'hugesoinfo/hugesoaddform.jsp': 'hugesoaddaction.jsp',
    'hugesoinfo/hugesoupdateform.jsp?h_num=1': 'hugesoupdateaction.jsp',
  };
  const blocked = async (page, path) => {
    const html = await raw(page, 'index.jsp?main=' + path);
    if (adminMarker[path] && html.includes(adminMarker[path])) return `원본 응답에 관리자 기능(${adminMarker[path]}) 노출`;
    await open(page, 'index.jsp?main=' + path);
    return page.alerts.length > 0 && !page.url().includes(path) ? true : `안내창 ${page.alerts.length}개, URL ${page.url()}`;
  };
  for (const path of ['mypage/adminqnalist.jsp', 'mypage/adminnoticelist.jsp', 'mypage/admineventlist.jsp', ...adminForms]) {
    await check(`비로그인 관리자 화면 차단 ${path}`, () => blocked(anon, path));
  }
  // 회원 목록은 include 안에서 sendRedirect가 무시되어 빈 화면이 되므로, 회원 정보(PII)가 보이지 않는지로 판정한다
  await check('비로그인 회원 목록(PII) 차단', async () => {
    return !(await raw(anon, 'index.jsp?main=mypage/memberlist.jsp')).includes('admin@hueat.local') ? true : '회원 이메일 노출(원본 응답)';
  });
  await check('비로그인 Q&A 비밀글 차단', async () => {
    return !(await raw(anon, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1')).includes('비밀 내용') ? true : '비밀글 본문 노출(원본 응답)';
  });

  // 3) 가입: 형식 위반 아이디 거부, 정상 아이디 가입 후 로그인
  const user = await newPage(browser);
  await check('형식 위반 아이디(1abc) 가입 거부', async () => {
    await signup(user, '1abc');
    return !(await login(user, '1abc', 'smokepw123')) ? true : '형식 위반 아이디로 로그인됨';
  });
  // 휴대폰(숫자 11자)·생년월일(실제 날짜 yyyy-MM-dd) 형식 위반은 서버가 가입을 거부해야 한다(클라이언트 검사는 form.submit()으로 우회)
  const signupWith = async (id, hp2, birth) => {
    await open(user, 'member/gaipform.jsp');
    for (const [sel, v] of [['input[name=m_id]', id], ['input[name=m_nick]', 'smoke'], ['input[name=m_pass]', 'smokepw123'],
      ['input[name=m_pass2]', 'smokepw123'], ['input[name=m_email]', 'smoke@hueat.local'], ['input[name=m_name]', '스모크']]) {
      if (await user.locator(sel).count()) await user.fill(sel, v);
    }
    await user.locator('#frm').evaluate((f, v) => { f.m_hp2.value = v.hp2; f.m_birth.type = 'text'; f.m_birth.value = v.birth; f.submit(); }, { hp2, birth });
    await user.waitForLoadState('load');
    await user.waitForTimeout(800);
  };
  await check('형식 위반 휴대폰(010.1234.5678) 가입 거부', async () => {
    await signupWith('badphone1', '010.1234.5678', '1990-01-01');
    return !(await login(user, 'badphone1', 'smokepw123')) ? true : '형식 위반 휴대폰으로 가입됨';
  });
  await check('형식 위반 생년월일(<svg onload=alert()>) 가입 거부', async () => {
    await signupWith('badbirth1', '01012345678', '<svg onload=alert()>');
    return !(await login(user, 'badbirth1', 'smokepw123')) ? true : '형식 위반 생년월일로 가입됨';
  });
  await check('정상 가입 후 로그인', async () => {
    await signup(user, 'smokeuser1');
    return (await login(user, 'smokeuser1', 'smokepw123')) ? true : '로그인 실패';
  });

  // 4) 일반 사용자: 관리자 화면·남의 비밀글 차단
  await check('일반 사용자 관리자 화면 차단', () => blocked(user, 'mypage/adminqnalist.jsp'));
  for (const path of adminForms) {
    await check(`일반 사용자 관리자 폼 차단 ${path}`, () => blocked(user, path));
  }
  await check('일반 사용자 남의 Q&A 비밀글 차단', async () => {
    return !(await raw(user, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1')).includes('비밀 내용') ? true : '비밀글 본문 노출(원본 응답)';
  });

  // 5) 관리자: 로그인 후 관리자 화면·비밀글 열람
  const admin = await newPage(browser);
  await check('관리자 로그인', async () => (await login(admin, 'admin', 'admin1234')) ? true : '로그인 실패');
  for (const path of ['mypage/adminqnalist.jsp', 'mypage/memberlist.jsp', ...adminForms]) {
    await check(`관리자 화면 접근 ${path}`, async () => {
      const resp = await open(admin, 'index.jsp?main=' + path);
      if (resp.status() !== 200 || admin.errors5xx.length) return `HTTP ${resp.status()} ${admin.errors5xx.join(', ')}`;
      return admin.alerts.length === 0 && admin.url().includes(path) ? true : `안내창 ${admin.alerts.join(' / ')}`;
    });
  }
  await check('관리자 회원 목록 열람', async () => {
    await open(admin, 'index.jsp?main=mypage/memberlist.jsp');
    return (await admin.content()).includes('admin@hueat.local') ? true : '회원 정보가 보이지 않음';
  });
  // 생년월일에 스크립트를 넣은 회원(seed.sql)이 관리자 화면에서 실행되지 않아야 한다
  await check('관리자 회원 목록 저장형 XSS 차단', async () => {
    await open(admin, 'index.jsp?main=mypage/memberlist.jsp');
    const html = await admin.content();
    if (admin.alerts.length) return `안내창 ${admin.alerts.length}개(스크립트 실행)`;
    return html.includes('스모크XSS') && !html.includes('<svg onload') ? true : '악성 생년월일이 태그로 출력됨';
  });
  await check('관리자 회원 검색 응답 XSS 이스케이프', async () => {
    const body = await admin.evaluate(() => fetch('mypage/membersearch.jsp?m_name=' + encodeURIComponent('스모크XSS')).then(r => r.text()));
    return body.includes('xssuser') && !body.includes('<svg') ? true : `검색 응답: ${body.trim().slice(0, 120)}`;
  });
  await check('관리자 Q&A 비밀글 열람', async () => {
    await open(admin, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    return (await admin.content()).includes('비밀 내용') ? true : '비밀글 본문이 보이지 않음';
  });

  // 6) 정상 흐름: 보안 수정이 정상 기능(폼 제출·AJAX·CSRF 토큰 전달)을 깨뜨리지 않았는지 실제 화면에서 제출해 확인한다
  const stamp = Date.now();
  const noticeSubject = `SMOKE_NOTICE_${stamp}`;
  await check('관리자 공지 작성(화면 제출 → 목록 노출)', async () => {
    await open(admin, 'index.jsp?main=noticeboard/noticeForm.jsp');
    await admin.fill('input[name=n_subject]', noticeSubject);
    await admin.fill('textarea[name=n_content]', '스모크 공지 본문');
    await submitAndWait(admin, () => admin.locator('form[action="noticeboard/noticeAction.jsp"]').evaluate(f => f.submit()));
    if (db(`select count(*) from noticeboard where n_subject=${sqlStr(noticeSubject)}`) === '0') return 'DB에 공지가 저장되지 않음';
    await open(admin, 'index.jsp?main=noticeboard/noticeList.jsp');
    return (await admin.content()).includes(noticeSubject) ? true : '공지 목록에 보이지 않음';
  });
  await check('관리자 공지 삭제(상세 화면 삭제 버튼 → POST)', async () => {
    const n = db(`select n_num from noticeboard where n_subject=${sqlStr(noticeSubject)} limit 1`);
    if (!n) return '삭제할 공지가 없음(작성 실패)';
    await open(admin, `index.jsp?main=noticeboard/noticeDetail.jsp?n_num=${n}&currentPage=1`);
    await submitAndWait(admin, () => admin.locator('button', { hasText: '삭제' }).first().click());
    return db(`select count(*) from noticeboard where n_num=${n}`) === '0' ? true : 'DB에서 공지가 지워지지 않음';
  });
  // Q&A 답변: 정상 등록은 저장되고, 공백만 있는 등록·빈 값 수정은 서버가 거부해야 한다(관리자, 토큰은 ajaxPrefilter가 붙인다)
  const answerText = `SMOKE_ANSWER_${stamp}`;
  await check('관리자 Q&A 답변 등록(입력 → 저장 버튼 AJAX)', async () => {
    await open(admin, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    await admin.fill('#qa_content', answerText);
    await admin.locator('#btnsend').click();
    await admin.waitForTimeout(1500);
    return db(`select count(*) from qaanswerboard where q_num=1 and qa_content=${sqlStr(answerText)}`) !== '0' ? true : 'DB에 답변이 저장되지 않음';
  });
  const postAsAdmin = (url, data) => admin.evaluate(([u, d]) => new Promise(r => $.post(u, d).always(() => r())), [url, data]);
  await check('공백만 있는 Q&A 답변 등록 POST 거부', async () => {
    const before = db("select count(*) from qaanswerboard where q_num=1 and trim(coalesce(qa_content,''))=''");
    await open(admin, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    await postAsAdmin('qaanswer/qaAnswerInsertAction.jsp', { q_num: '1', qa_content: '   ' });
    return db("select count(*) from qaanswerboard where q_num=1 and trim(coalesce(qa_content,''))=''") === before ? true : '빈 답변이 저장됨';
  });
  await check('Q&A 답변을 빈 값으로 수정하는 POST 거부', async () => {
    const qa = db(`select qa_num from qaanswerboard where q_num=1 and qa_content=${sqlStr(answerText)} limit 1`);
    if (!qa) return '수정할 답변이 없음(등록 실패)';
    await open(admin, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    await postAsAdmin('qaanswer/qaAnswerUpdateAction.jsp', { q_num: '1', qa_num: qa, qa_content: '' });
    return db(`select qa_content from qaanswerboard where q_num=1 and qa_num=${qa}`) === answerText ? true : '답변이 빈 값으로 덮어써짐';
  });
  await check('CSRF 토큰 없는 공지 작성 POST 차단', async () => {
    const subject = `SMOKE_NOCSRF_${Date.now()}`;
    await admin.context().request.post(BASE + 'noticeboard/noticeAction.jsp',
      { multipart: { n_subject: subject, n_content: 'x' }, maxRedirects: 0 });
    return db(`select count(*) from noticeboard where n_subject=${sqlStr(subject)}`) === '0' ? true : '토큰 없이 공지가 저장됨';
  });
  await check('회원 Q&A 작성(화면 제출 → 본인 열람)', async () => {
    const subject = `SMOKE_QA_${Date.now()}`;
    await open(user, 'index.jsp?main=qaboard/qaForm.jsp');
    await user.locator('select[name=q_category]').selectOption({ index: 1 }).catch(() => {});
    await user.fill('input[name=q_subject]', subject);
    await user.fill('textarea[name=q_content]', '스모크 문의 본문');
    await submitAndWait(user, () => user.locator('form[action="qaboard/qaAction.jsp"]').evaluate(f => f.submit()));
    const q = db(`select q_num from qaboard where q_subject=${sqlStr(subject)} and q_myid='smokeuser1' limit 1`);
    if (!q) return 'DB에 문의가 저장되지 않음';
    await open(user, `index.jsp?main=qaboard/qaDetail.jsp?q_num=${q}`);
    return (await user.content()).includes('스모크 문의 본문') ? true : '작성자 본인이 문의 본문을 볼 수 없음';
  });
  await check('회원 장바구니 담기(메뉴 클릭 → AJAX)', async () => {
    const m = db("select m_num from meminfo where m_id='smokeuser1'");
    const before = Number(db(`select count(*) from foodcart where m_num=${m}`));
    await open(user, 'index.jsp?main=foodcourt/foodmenu.jsp?h_num=1');
    await user.locator('a.menuchoice').first().click();
    await user.waitForTimeout(1500);
    return Number(db(`select count(*) from foodcart where m_num=${m}`)) > before ? true : 'DB 장바구니에 담기지 않음';
  });
  await check('회원 휴게소 평점 등록(별점 선택 → AJAX)', async () => {
    const before = Number(db("select count(*) from grade where g_myid='smokeuser1' and h_num=1"));
    await open(user, 'index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=1');
    await user.evaluate(() => {
      const r = document.querySelector('input[name=g_grade][value="4"]');
      r.checked = true;
      document.getElementById('btnasend').click();
    });
    await user.waitForTimeout(1500);
    return Number(db("select count(*) from grade where g_myid='smokeuser1' and h_num=1")) > before ? true : 'DB에 평점이 저장되지 않음';
  });

  // 7) 업로드·파일 제공·include 화이트리스트·토큰 없는 POST: 정적 분석이 JSP에서 잡기 어려운 방어를 실제 요청으로 확인한다
  // 후기 작성 폼에 파일을 붙여 제출한다(파일이 없으면 첨부하지 않음)
  const submitReview = async (content, file) => {
    await open(user, 'index.jsp?main=reviewboard/reviewList.jsp'); // 작성 폼은 로그인 시 목록 화면에 include된다
    await user.fill('textarea[name=r_content]', content);
    if (file) await user.setInputFiles('input[name=r_image]', file);
    await submitAndWait(user, () => user.locator('form[action="reviewboard/reviewAction.jsp"]').evaluate(f => f.submit()));
  };
  const reviewCount = content => db(`select count(*) from reviewboard where r_content=${sqlStr(content)}`);
  const reviewText = `SMOKE_REVIEW_${stamp}`;
  await check('회원 후기 작성(화면 제출 → DB 저장)', async () => {
    if (reviewCount(reviewText) === '0') await submitReview(reviewText);
    return reviewCount(reviewText) !== '0' ? true : 'DB에 후기가 저장되지 않음';
  });
  // 확장자가 이미지가 아닌 파일과, 확장자만 이미지인 텍스트 파일은 모두 거부되고 저장된 파일도 지워져야 한다
  for (const [label, name] of [['확장자 jsp', 'smoke_evil.jsp'], ['내용이 이미지가 아닌 png', 'smoke_evil.png']]) {
    await check(`이미지가 아닌 업로드 거부(${label})`, async () => {
      const content = `SMOKE_UPLOAD_${name}_${stamp}`;
      await submitReview(content, { name, mimeType: 'image/png', buffer: Buffer.from('<% out.print("smoke"); %>\n') });
      if (reviewCount(content) !== '0') return '후기가 저장됨';
      const r = await user.context().request.get(BASE + 'fileview?type=review&name=' + encodeURIComponent(name));
      return r.status() !== 200 ? true : '업로드 파일이 남아 제공됨';
    });
  }
  // 이미지 제공 서블릿: 업로드 폴더 밖(설정 파일 등)을 읽는 경로조작과 허용 목록 밖 type은 400이어야 한다
  for (const q of ['type=review&name=' + encodeURIComponent('../../db.properties'), 'type=review&name=' + encodeURIComponent('..\\..\\db.properties'),
    'type=' + encodeURIComponent('../review') + '&name=a.png', 'type=WEB-INF&name=web.xml']) {
    await check(`fileview 경로조작 거부 ${q}`, async () => {
      const r = await anon.context().request.get(BASE + 'fileview?' + q);
      const body = await r.text();
      if (body.includes('db.password') || body.includes('<web-app')) return '파일 내용 노출';
      return r.status() === 400 ? true : `HTTP ${r.status()}`;
    });
  }
  // index.jsp의 include 화이트리스트: 목록 밖 경로는 내용을 include하지 않고 메인 화면으로 폴백해야 한다
  for (const path of ['WEB-INF/web.xml', 'mypage/../WEB-INF/web.xml', '/WEB-INF/web.xml']) {
    await check(`화이트리스트 밖 main= 폴백 ${path}`, async () => {
      const r = await anon.context().request.get(BASE + 'index.jsp?main=' + encodeURIComponent(path));
      const body = await r.text();
      if (body.includes('<web-app') || body.includes('servlet-mapping')) return '설정 파일 내용 노출';
      return r.status() === 200 ? true : `HTTP ${r.status()}`;
    });
  }
  // 토큰 없는 상태변경 POST(로그인 회원 세션): 저장·삭제가 일어나지 않아야 한다
  const memberNum = () => db("select m_num from meminfo where m_id='smokeuser1'");
  // 대상이 없으면 "바뀌지 않음"이 당연히 성립하므로 통과로 보지 않는다
  const need = (v, what) => { if (!v) throw new Error(`대상 ${what} 없음(앞 시나리오 실패 또는 이미 바뀜)`); return v; };
  const noCsrf = [
    ['Q&A 작성', 'qaboard/qaAction.jsp', { q_category: '기타', q_subject: `SMOKE_NOCSRF_QA_${stamp}`, q_content: 'x' },
      () => db(`select count(*) from qaboard where q_subject=${sqlStr(`SMOKE_NOCSRF_QA_${stamp}`)}`)],
    ['장바구니 담기', 'foodcourt/foodcartaddaction.jsp', () => ({ f_num: need(db("select f_num from food where f_name='스모크메뉴' limit 1"), '메뉴'), h_num: '1', cart_cnt: '1' }),
      () => db(`select count(*) from foodcart where m_num=${memberNum()}`)],
    ['휴게소 평점 등록', 'grade/insertgrade.jsp', { h_num: '1', g_grade: '5', g_content: '시설이 깨끗해요' },
      () => db("select count(*) from grade where g_myid='smokeuser1'")],
    ['후기 삭제', 'reviewboard/reviewDelete.jsp', () => ({ r_num: need(db(`select r_num from reviewboard where r_content=${sqlStr(reviewText)} limit 1`), '후기'), currentPage: '1' }),
      () => reviewCount(reviewText)],
  ];
  for (const [label, url, data, count] of noCsrf) {
    await check(`CSRF 토큰 없는 ${label} POST 차단`, async () => {
      const before = count();
      await user.context().request.post(BASE + url, { form: typeof data === 'function' ? data() : data, maxRedirects: 0 });
      return count() === before ? true : '토큰 없이 DB가 바뀜';
    });
  }
  await check('회원 후기 삭제(목록 휴지통 → postNav POST)', async () => {
    const r = db(`select r_num from reviewboard where r_content=${sqlStr(reviewText)} limit 1`);
    if (!r) return '삭제할 후기가 없음(작성 실패)';
    await open(user, 'index.jsp?main=reviewboard/reviewList.jsp');
    // 아이콘 글꼴(외부 CDN)이 차단돼 <i>의 크기가 0이므로 화면 클릭 대신 요소의 click 이벤트로 누른다
    await submitAndWait(user, () => user.locator(`i.del[r_num="${r}"]`).evaluate(el => el.click()));
    return db(`select count(*) from reviewboard where r_num=${r}`) === '0' ? true : 'DB에서 후기가 지워지지 않음';
  });

  // 가입 폼 중복확인: '사용 불가' 결과나 확인 뒤 아이디 변경이면 제출 시 다시 확인을 요구해야 한다(성공 안내가 먼저 뜨지 않음)
  const gaip = await newPage(browser);
  const fillGaip = async id => {
    await open(gaip, 'member/gaipform.jsp');
    for (const [sel, v] of [['input[name=m_nick]', 'smoke'], ['input[name=m_pass]', 'smokepw123'], ['input[name=m_pass2]', 'smokepw123'],
      ['input[name=m_email]', 'smoke@hueat.local'], ['input[name=m_name]', '스모크'], ['input[name=m_hp2]', '01012345678']]) {
      if (await gaip.locator(sel).count()) await gaip.fill(sel, v);
    }
    await gaip.fill('#m_id', id);
    await gaip.locator('#btnidcheck').click();
    await gaip.waitForTimeout(1200);
  };
  await check('가입 폼: 사용 불가 아이디 중복확인 결과 표시와 입력란 비움', async () => {
    await fillGaip('xssuser');
    const msg = await gaip.locator('#check_id').innerText().catch(() => '');
    const val = await gaip.inputValue('#m_id');
    return msg.includes('사용할 수 없는') && val === '' ? true : `결과 '${msg}', 입력란 '${val}'`;
  });
  await check('가입 폼: 사용 가능 아이디 중복확인 결과 표시(단독 화면에서 CSRF 토큰 전달)', async () => {
    await fillGaip('okid' + String(stamp).slice(-6));
    const msg = await gaip.locator('#check_id').innerText().catch(() => '');
    return msg.includes('사용 가능한') ? true : `결과 '${msg}'`;
  });
  await check('가입 폼: 중복확인 뒤 아이디를 바꾸면 제출 시 재확인 요구', async () => {
    await fillGaip('freshid' + String(stamp).slice(-6));
    await gaip.fill('#m_id', 'changedid' + String(stamp).slice(-6));
    gaip.alerts = [];
    await gaip.locator('button.btninsert').click();
    await gaip.waitForTimeout(800);
    return gaip.alerts.some(m => m.includes('아이디 중복 확인')) ? true : `안내창 ${JSON.stringify(gaip.alerts)}`;
  });
  // 마이페이지 화면: 비로그인으로 열면 오류(5xx)나 빈 화면 대신 로그인 안내로 이동해야 한다
  const anonMy = await newPage(browser);
  for (const f of ['updateform', 'deleteform', 'favlist', 'myqnalist', 'myreviewlist', 'updatepassform']) {
    await check(`마이페이지 비로그인 접근: ${f}.jsp는 로그인 안내`, async () => {
      const r = await anonMy.context().request.get(BASE + `index.jsp?main=mypage/${f}.jsp`);
      const body = await r.text();
      return r.status() < 500 && body.includes('로그인 후 이용할 수 있습니다.') ? true : `상태 ${r.status()}, 안내 없음`;
    });
  }
  await browser.close();
  const failed = results.filter(r => !r).length;
  console.log(`[smoke] 결과: ${results.length - failed}/${results.length} 통과`);
  if (process.env.SMOKE_FAILED_OUT) {
    require('fs').writeFileSync(process.env.SMOKE_FAILED_OUT, failedNames.map(n => n + '\n').join(''));
  }
  process.exit(failed > 0 ? 1 : 0);
})();
