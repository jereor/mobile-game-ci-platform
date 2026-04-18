\# Dev Journal



\## 2026-04-18

* Did: I set up a Unity Android CI build pipeline using command line execution, implemented a custom BuildScript with argument handling, fixed PowerShell invocation issues, and made the build output configurable and CI-friendly. I also handled artifact paths, added cleanup for existing builds, and verified the build process end-to-end.
* Learned: Unity batch builds require explicit configuration — scenes, build target, and output paths must all be defined. CI pipelines should treat build outputs as artifacts and not rely on implicit defaults. Small details like CLI invocation (\& in PowerShell) or passing a directory instead of a file path can completely break automation. Unity also mutates certain project files during builds, so keeping the repo clean requires intentional handling.
* Stuck on: Debugging silent Unity build failures was tricky since the initial logs didn’t show the real error. Took time to realize issues were caused by missing scenes initializer in BuildPlayerOptions.

