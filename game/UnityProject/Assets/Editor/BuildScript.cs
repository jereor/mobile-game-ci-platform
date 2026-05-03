using System;
using System.IO;
using UnityEditor.Build.Reporting;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace Editor
{
    class BuildScript
    {
        static void PerformBuild()
        {
            var scenes = EditorBuildSettings.scenes
                .Where(s => s.enabled)
                .Select(s => s.path)
                .ToArray();
            
            if (scenes.Length == 0)
            {
                throw new Exception("No scenes in Build Settings!");
            }
            
            var buildOutputPath = GetArg("-ciBuildOutput") ?? "Builds";

            if (Directory.Exists(buildOutputPath))
            {
                Debug.Log($"Deleting existing build directory: {buildOutputPath}");
                Directory.Delete(buildOutputPath, true);
            }
            
            Directory.CreateDirectory(buildOutputPath);
            Debug.Log($"Building to: {buildOutputPath}");
            
            // TODO: Refactor to support multiple platforms (iOS)
            var androidVersionCode = int.TryParse(GetArg("-ciAndroidVersionCode"), out var code) ? code : 1;
            PlayerSettings.Android.bundleVersionCode = androidVersionCode;
            Debug.Log($"Bundle Version Code: {PlayerSettings.Android.bundleVersionCode}");
            
            var androidVersionName = $"{GetArg("-ciAndroidVersion") ?? "1.0"}.{androidVersionCode}";
            PlayerSettings.bundleVersion = androidVersionName;
            Debug.Log($"Bundle Version: {PlayerSettings.bundleVersion}");
            
            var commitHash = GetArg("-ciCommitHash") ?? "local";
            Debug.Log($"Commit Hash: {commitHash}");
            
            var buildId = long.TryParse(GetArg("-ciBuildId"), out var number) ? number : 1;
            Debug.Log($"Build ID: {buildId}");
            
            var fileName = $"game-{commitHash}-{buildId}.apk";
            Debug.Log($"File Name: {fileName}");
            
            var options = new BuildPlayerOptions
            {
                scenes = scenes,
                target = BuildTarget.Android,
                locationPathName = Path.Combine(buildOutputPath, fileName)
            };
            
            var report = BuildPipeline.BuildPlayer(options);

            var summary = report.summary;

            Debug.Log($"Result: {summary.result}");
            Debug.Log($"Errors: {summary.totalErrors}");
            Debug.Log($"Warnings: {summary.totalWarnings}");

            if (summary.result != BuildResult.Succeeded)
            {
                throw new Exception("Build failed with " + summary.totalErrors + " errors");
            }
            
            var steps = report.steps;

            foreach (var step in steps)
            {
                foreach (var message in step.messages)
                {
                    switch (message.type)
                    {
                        case LogType.Error:
                            Debug.LogError($"[BUILD ERROR] {message.content}");
                            break;
                        case LogType.Warning:
                            Debug.LogWarning($"[BUILD WARNING] {message.content}");
                            break;
                    }
                }
            }
        }

        private static string GetArg(string name)
        {
            var args = System.Environment.GetCommandLineArgs();
            for (var i = 0; i < args.Length; i++)
            {
                if (args[i] == name && i + 1 < args.Length)
                    return args[i + 1];
            }
            return null;
        }
    }
}