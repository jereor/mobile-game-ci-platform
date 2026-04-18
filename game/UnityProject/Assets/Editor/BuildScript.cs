using System.Diagnostics;
using System.Linq;
using UnityEditor;

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
                throw new System.Exception("No scenes in Build Settings!");
            }
            
            var buildOutputPath = GetArg("-buildOutput") ?? "Builds/Android/game.apk";
            
            if (!buildOutputPath.EndsWith(".apk") && !buildOutputPath.EndsWith(".aab"))
            {
                buildOutputPath = System.IO.Path.Combine(buildOutputPath, "game.apk");
            }
            
            var dir = System.IO.Path.GetDirectoryName(buildOutputPath);
            if (!System.IO.Directory.Exists(dir))
            {
                Debug.Assert(dir != null, nameof(dir) + " != null");
                System.IO.Directory.CreateDirectory(dir);
            }
            
            if (System.IO.File.Exists(buildOutputPath))
            {
                UnityEngine.Debug.Log($"Deleting existing build at: {buildOutputPath}");
                System.IO.File.Delete(buildOutputPath);
            }

            var options = new BuildPlayerOptions
            {
                scenes = scenes,
                target = BuildTarget.Android,
                locationPathName = buildOutputPath
            };
            
            var report = BuildPipeline.BuildPlayer(options);

            var summary = report.summary;

            UnityEngine.Debug.Log($"Result: {summary.result}");
            UnityEngine.Debug.Log($"Errors: {summary.totalErrors}");
            UnityEngine.Debug.Log($"Warnings: {summary.totalWarnings}");

            if (summary.result != UnityEditor.Build.Reporting.BuildResult.Succeeded)
            {
                throw new System.Exception("Build failed with " + summary.totalErrors + " errors");
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