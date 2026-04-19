\# Dev Journal



\## 2026-04-19

* Did: I implemented auto-versioning and dynamic APK naming in my Unity build pipeline, using commit hashes and build numbers from CLI arguments. I also improved my build script to generate filenames programmatically and added more detailed logging using Unity’s BuildReport system.
* Learned: Unity’s build system can fail silently if you don’t explicitly log detailed errors. Android builds have strict constraints like requiring a versionCode greater than zero, and even small issues like null arguments can break the build. Good CI scripts need strong validation and clear logging to be debuggable.
* Stuck on: Deciding how to structure versioning and artifact naming long-term (e.g. combining semantic versioning, build numbers, and commit hashes in a clean and scalable way).







\## 2026-04-18

* Did: I set up a Unity Android CI build pipeline using command line execution, implemented a custom BuildScript with argument handling, fixed PowerShell invocation issues, and made the build output configurable and CI-friendly. I also handled artifact paths, added cleanup for existing builds, and verified the build process end-to-end.
* Learned: Unity batch builds require explicit configuration — scenes, build target, and output paths must all be defined. CI pipelines should treat build outputs as artifacts and not rely on implicit defaults. Small details like CLI invocation (\& in PowerShell) or passing a directory instead of a file path can completely break automation. Unity also mutates certain project files during builds, so keeping the repo clean requires intentional handling.
* Stuck on: Debugging silent Unity build failures was tricky since the initial logs didn’t show the real error. Took time to realize issues were caused by missing scenes initializer in BuildPlayerOptions.

