# Unity Build & Release Platform
A production-inspired CI/CD pipeline for Unity mobile games, focused on build automation, reliability, and developer experience.

# Problem
Modern mobile game teams ship updates continuously, but build pipelines often become bottlenecks:

- Long build times
- Flaky failures
- Manual distribution
- Poor visibility into build status

This project explores how to design a scalable build system that reduces friction and improves iteration speed.

# Goals
- Fully automated Unity Android builds
- Reproducible CI pipeline
- Build artifact management
- Clear build visibility and logs

# Non-goals
- Full iOS pipeline (intentionally scoped out)
- Production-grade security
- Multi-region infrastructure

# Architecture overview
Developer → Git Push → CI Pipeline → Unity Build → Artifact Storage

In short: Developer pushes changes to Git. Then CI Pipeline detects the changes, does a new Unity Build, and stores the new binaries in an Artifact Storage service.

# Pipeline breakdown
Stages:
1. Checkout - Checks out a branch from Git
2. Dependency restore - Installs the necessary dependencies for the project
3. Unity build - Executes a Unity build for Android
4. Artifact upload - Uploads the binaries to an Artifact Storage service

# Key design decisions
## GitHub Actions
Decision: Use GitHub Actions over Jenkins

Reason: Easier to set up and maintain, with pre-built actions and cloud-hosted runners

Tradeoff: Less control over build machines

# Local development
TODO: Write how to build locally

TODO: Write how to debug issues

# Observability
Current:
- CI logs via GitHub Actions

Future:
- Build status dashboard
- Failure classification

# Roadmap
Planned improvements:
- Build orchestration service
- Artifact distribution system
- Failure diagnostics
- Developer UI

# Lessons learned
TODO: Write 1st lesson
