using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Build.Reporting;

public static class CommandLineBuild
{
    private const string BuildPathArg = "buildPath";
    private const string DevelopmentArg = "development";

    public static void BuildAndroid()
    {
        var scenes = EditorBuildSettings.scenes
            .Where(scene => scene.enabled)
            .Select(scene => scene.path)
            .ToArray();
        if (scenes.Length == 0)
        {
            throw new InvalidOperationException("No enabled scenes found for the build.");
        }

        var buildPath = GetArg(BuildPathArg);
        if (string.IsNullOrEmpty(buildPath))
        {
            buildPath = Path.Combine("Builds", "Android", "QCXR.apk");
        }

        var directory = Path.GetDirectoryName(buildPath);
        if (!string.IsNullOrEmpty(directory))
        {
            Directory.CreateDirectory(directory);
        }

        EditorUserBuildSettings.buildAppBundle = false;
        EditorUserBuildSettings.androidBuildSystem = AndroidBuildSystem.Gradle;
        EditorUserBuildSettings.exportAsGoogleAndroidProject = false;

        var options = new BuildPlayerOptions
        {
            scenes = scenes,
            locationPathName = buildPath,
            target = BuildTarget.Android,
            options = IsDevelopmentBuild()
                ? BuildOptions.Development | BuildOptions.ConnectWithProfiler
                : BuildOptions.None
        };

        var report = BuildPipeline.BuildPlayer(options);
        if (report.summary.result != BuildResult.Succeeded)
        {
            throw new Exception($"Android build failed: {report.summary.result} ({report.summary.totalErrors} errors)");
        }

        Console.WriteLine($"Android build succeeded: {buildPath}");
    }

    private static bool IsDevelopmentBuild()
    {
        var value = GetArg(DevelopmentArg);
        return !string.IsNullOrEmpty(value) &&
               (value.Equals("1", StringComparison.OrdinalIgnoreCase) ||
                value.Equals("true", StringComparison.OrdinalIgnoreCase));
    }

    private static string GetArg(string name)
    {
        var args = Environment.GetCommandLineArgs();
        var key = "-" + name;
        for (var i = 0; i < args.Length; i++)
        {
            if (args[i] == key && i + 1 < args.Length)
            {
                return args[i + 1];
            }

            if (args[i].StartsWith(key + "="))
            {
                return args[i].Substring(key.Length + 1);
            }
        }

        return null;
    }
}
