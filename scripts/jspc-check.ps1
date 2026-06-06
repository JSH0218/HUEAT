<#
.SYNOPSIS
  JSP precompilation gate - validate all JSPs (translation + Java compile) without
  running Tomcat or a DB.

.DESCRIPTION
  Uses Apache Jasper (org.apache.jasper.JspC) to translate every *.jsp under
  src/main/webapp into servlet .java and compile them (-compile). This catches what
  plain `javac` (which only checks src/main/java) cannot:
    - JSP translation errors: scriptlet/EL syntax, <%@ include %> variable
      redeclaration / scope clashes
    - JSP -> DAO call errors: a JSP calling a DAO method whose name/signature no
      longer exists (e.g. after a rename) - otherwise only surfaces at runtime.
  Use as a regression gate when doing structural JSP work (paging-scriptlet include
  extraction, hugesolist consolidation) in an environment where Tomcat runtime
  verification is unavailable.
  NOT covered (still needs a real run): runtime behavior - SQL results, redirect
  targets, AJAX URL correctness, session/login flow, DB-data-dependent screens.

  See scripts/README.md (Korean) for the full rationale.

.NOTES
  Prerequisites:
    - Java 17 (javac/java on PATH)
    - Apache Tomcat 9 install (provides Jasper). Set CATALINA_HOME, or edit $cands.
    - Internet (first run only): downloads ant.jar, cached under .jspc/lib.
      JspC links org.apache.tools.ant.Task, so ant.jar must be on the classpath.
  Run:  powershell -ExecutionPolicy Bypass -File scripts/jspc-check.ps1
  Exit: 0 = all JSPs pass, non-zero = failure (error log printed).

  ASCII-only on purpose: Windows PowerShell 5.1 reads a BOM-less .ps1 as the system
  ANSI codepage, which corrupts non-ASCII source. Korean docs live in README.md.

  Note: JspC returns exit code 0 even when JSPs fail to compile, so this script
  judges pass/fail by generated output (every .java must have a matching .class),
  not by the process exit code.
#>
# 'Continue' on purpose: under 'Stop', PS 5.1 promotes a native exe's stderr line
# (e.g. Jasper's TldScanner INFO log) to a terminating error. Control flow below
# relies on explicit checks, not $ErrorActionPreference.
$ErrorActionPreference = 'Continue'

# --- paths ---
$proj      = Split-Path -Parent $PSScriptRoot          # repo root (parent of scripts/)
$webapp    = Join-Path $proj 'src\main\webapp'
$weblibDir = Join-Path $webapp 'WEB-INF\lib'
$work      = Join-Path $proj '.jspc'                   # temp output (gitignored)
$classes   = Join-Path $work 'classes'
$gen       = Join-Path $work 'gen'
$libCache  = Join-Path $work 'lib'

# --- locate Tomcat 9 (CATALINA_HOME first, else known default) ---
$tom = $env:CATALINA_HOME
if (-not $tom -or -not (Test-Path (Join-Path $tom 'lib\jasper.jar'))) {
    $cands = @(
        'C:\ApacheTomcat\apache-tomcat-9.0.118'   # this machine; set CATALINA_HOME elsewhere
    )
    $tom = $cands | Where-Object { Test-Path (Join-Path $_ 'lib\jasper.jar') } | Select-Object -First 1
}
if (-not $tom) {
    Write-Output "[jspc] ERROR: Tomcat 9 not found. Set CATALINA_HOME to a Tomcat 9 install."
    exit 2
}
Write-Output "[jspc] Tomcat: $tom"

# --- reset work dirs ---
foreach ($d in @($classes, $gen, $libCache)) {
    if (Test-Path $d) { Remove-Item $d -Recurse -Force }
    New-Item -ItemType Directory $d | Out-Null
}

# --- ensure ant.jar (JspC links org.apache.tools.ant.Task); cached ---
$antJar = Join-Path $libCache 'ant-1.10.14.jar'
if (-not (Test-Path $antJar)) {
    Write-Output "[jspc] downloading ant.jar (first run only)..."
    try {
        Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/apache/ant/ant/1.10.14/ant-1.10.14.jar' `
            -OutFile $antJar -UseBasicParsing -TimeoutSec 120 -ErrorAction Stop
    } catch {
        Write-Output "[jspc] ERROR: ant.jar download failed: $($_.Exception.Message)"
        exit 3
    }
}

# --- 1) compile project java (needed so -compile can type-check JSP->DAO calls) ---
$servletApi = Join-Path $tom 'lib\servlet-api.jar'
$weblib = (Get-ChildItem $weblibDir -Filter *.jar | ForEach-Object FullName) -join ';'
$srcs = Get-ChildItem (Join-Path $proj 'src\main\java') -Recurse -Filter *.java | ForEach-Object FullName
Write-Output "[jspc] compiling project java..."
& javac -encoding UTF-8 -cp "$servletApi;$weblib" -d $classes $srcs
if ($LASTEXITCODE -ne 0) { Write-Output "[jspc] ERROR: javac failed (EXIT=$LASTEXITCODE)"; exit 1 }

# --- 2) run JspC (translate + compile entire webapp) ---
$tomcp = (((Get-ChildItem (Join-Path $tom 'lib') -Filter *.jar | ForEach-Object FullName)) `
    + (Join-Path $tom 'bin\tomcat-juli.jar') + $antJar) -join ';'
$appcp = "$classes;$weblib"
$log = Join-Path $work 'jspc.err'
Write-Output "[jspc] running JspC (translate + compile)..."
# -Duser.language=en: English JspC/JDT messages (avoid console locale mojibake).
& java '-Duser.language=en' -cp $tomcp org.apache.jasper.JspC -webapp $webapp -d $gen -javaEncoding UTF-8 -compile -classpath $appcp 2>$log 1>$null

# --- 3) verdict by output, NOT exit code (JspC exits 0 even on compile errors) ---
#   translation failure: #jsp > #generated .java
#   compile failure    : a generated X.java has no matching X.class
$jspCount = (Get-ChildItem $webapp -Recurse -Filter *.jsp | Measure-Object).Count
$javas = @(Get-ChildItem $gen -Recurse -Filter *.java)
$missing = @($javas | Where-Object { -not (Test-Path ([System.IO.Path]::ChangeExtension($_.FullName, 'class'))) })
$translationFail = $jspCount - $javas.Count

if ($missing.Count -eq 0 -and $translationFail -le 0) {
    Write-Output "[jspc] PASS - $jspCount JSP translated + compiled, 0 errors"
    exit 0
} else {
    Write-Output "[jspc] FAIL - translation failures: $translationFail, compile failures: $($missing.Count)"
    if ($missing.Count -gt 0) {
        Write-Output "[jspc] failed compiles (generated .java; names are JspC-mangled):"
        $missing | ForEach-Object { Write-Output ("  - " + $_.Name) }
    }
    Write-Output "[jspc] error log (key lines):"
    Get-Content $log | Where-Object { $_ -match '\.java:|ERROR|cannot|undefined|method|symbol|Unable' } | Select-Object -First 40
    Write-Output "[jspc] full log: $log"
    exit 1
}
