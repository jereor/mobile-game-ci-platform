\# Dev Notes



\## 2026-04-19



\### Tasks

* Implement auto-versioning for Unity Android builds (versionCode + versionName)
* Add commit hash and build number to APK naming
* Refactor build script to construct output filenames dynamically
* Improve logging using BuildReport to surface real build errors



\### Bugs / issues

* Unity build failed with multiple errors but logs initially only showed error count
* versionCode defaulted to 0 → invalid for Android builds
* commitHash argument could be null → malformed APK filename
* Difficulty diagnosing issues due to insufficient logging



\### Thoughts / Ideas

* Always log detailed build errors from BuildReport, not just summary
* Validate all CLI inputs (versionCode, commitHash, buildNumber) with safe defaults
* Android builds have strict requirements (e.g. versionCode > 0)
* Build scripts should fail loudly and transparently for CI debugging







\## 2026-04-18



\### Tasks

* Set up Unity Android CI build via command line
* Implement Editor.BuildScript.PerformBuild
* Handle build output path and artifact directory
* Make build script CI-friendly (arguments, logging, exit handling)



\### Bugs / issues

* PowerShell error: Unity command not executed due to missing \&
* Unity build failed with exit code 1 and no clear error
* Output path passed as directory instead of .apk → collision error
* Existing build file/folder caused build failure → required cleanup before build
* Unity modifies project files during build:

  * AddressableAssetsData assets
  * UnityConnectSettings.asset



\### Thoughts / ideas

* Always use -batchmode -nographics in CI
* Build scripts should explicitly define:

  * scenes
  * output path (with extension)
* Normalize output paths in script (handle directory vs file)
* Delete existing build artifacts before building
* Use CLI args (e.g. -buildOutput) to control CI behavior
* Validate builds using BuildReport instead of assuming success
* Revert repo changes after build to keep CI clean
* Treat build outputs as artifacts, not source-controlled files

