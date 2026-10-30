// 실행 스모크 테스트 시나리오 (Playwright, scripts/runtime-smoke.sh가 실행한다)
//
// 실제로 띄운 Tomcat+DB에 브라우저로 접속해 주요 화면과 권한 흐름을 확인한다.
// 각 시나리오는 "[smoke] PASS/FAIL 이름"을 출력하며, 실패 수를 종료코드로 돌려준다.
// 외부 CDN(jQuery·카카오 지도 등) 로딩 실패는 판정에 쓰지 않는다. 같은 출처의 5xx 응답만 실패로 본다.
//
// 기능을 고치거나 추가하면 그 동작을 확인하는 시나리오를 여기에 추가한다.
const { chromium } = require('playwright');

const BASE = process.env.SMOKE_BASE || 'http://localhost:18080/HuEatProject/';
const results = [];
const record = (name, ok, detail) => {
  results.push(ok);
  console.log(`[smoke] ${ok ? 'PASS' : 'FAIL'} ${name}${ok || !detail ? '' : ' — ' + detail}`);
};

// 새 브라우저 컨텍스트(쿠키·세션 분리)와 페이지를 만든다. 안내창은 기록 후 자동 확인한다.
async function newPage(browser) {
  const ctx = await browser.newContext();
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

async function check(name, fn) {
  try {
    const r = await fn();
    record(name, r === true, typeof r === 'string' ? r : undefined);
  } catch (e) {
    record(name, false, e.message.split('\n')[0]);
  }
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
  for (const path of ['mypage/adminqnalist.jsp', 'mypage/adminnoticelist.jsp', 'mypage/admineventlist.jsp']) {
    await check(`비로그인 관리자 화면 차단 ${path}`, async () => {
      await open(anon, 'index.jsp?main=' + path);
      return anon.alerts.length > 0 && !anon.url().includes(path) ? true : `안내창 ${anon.alerts.length}개, URL ${anon.url()}`;
    });
  }
  // 회원 목록은 include 안에서 sendRedirect가 무시되어 빈 화면이 되므로, 회원 정보(PII)가 보이지 않는지로 판정한다
  await check('비로그인 회원 목록(PII) 차단', async () => {
    await open(anon, 'index.jsp?main=mypage/memberlist.jsp');
    return !(await anon.content()).includes('admin@hueat.local') ? true : '회원 이메일 노출';
  });
  await check('비로그인 Q&A 비밀글 차단', async () => {
    await open(anon, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    return !(await anon.content()).includes('비밀 내용') ? true : '비밀글 본문 노출';
  });

  // 3) 가입: 형식 위반 아이디 거부, 정상 아이디 가입 후 로그인
  const user = await newPage(browser);
  await check('형식 위반 아이디(1abc) 가입 거부', async () => {
    await signup(user, '1abc');
    return !(await login(user, '1abc', 'smokepw123')) ? true : '형식 위반 아이디로 로그인됨';
  });
  await check('정상 가입 후 로그인', async () => {
    await signup(user, 'smokeuser1');
    return (await login(user, 'smokeuser1', 'smokepw123')) ? true : '로그인 실패';
  });

  // 4) 일반 사용자: 관리자 화면·남의 비밀글 차단
  await check('일반 사용자 관리자 화면 차단', async () => {
    await open(user, 'index.jsp?main=mypage/adminqnalist.jsp');
    return user.alerts.length > 0 && !user.url().includes('adminqnalist') ? true : `URL ${user.url()}`;
  });
  await check('일반 사용자 남의 Q&A 비밀글 차단', async () => {
    await open(user, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    return !(await user.content()).includes('비밀 내용') ? true : '비밀글 본문 노출';
  });

  // 5) 관리자: 로그인 후 관리자 화면·비밀글 열람
  const admin = await newPage(browser);
  await check('관리자 로그인', async () => (await login(admin, 'admin', 'admin1234')) ? true : '로그인 실패');
  for (const path of ['mypage/adminqnalist.jsp', 'mypage/memberlist.jsp']) {
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
  await check('관리자 Q&A 비밀글 열람', async () => {
    await open(admin, 'index.jsp?main=qaboard/qaDetail.jsp?q_num=1');
    return (await admin.content()).includes('비밀 내용') ? true : '비밀글 본문이 보이지 않음';
  });

  await browser.close();
  const failed = results.filter(r => !r).length;
  console.log(`[smoke] 결과: ${results.length - failed}/${results.length} 통과`);
  process.exit(failed);
})();
