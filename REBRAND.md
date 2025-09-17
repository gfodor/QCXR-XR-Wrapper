# PortalCraft Rebrand Checklist

## Applied Updates
- `QCXR-XR-Wrapper/ProjectSettings/ProjectSettings.asset`
  - Updated `companyName` to `Portal VR, Inc.`, `productName` to `PortalCraft`, and Android `applicationIdentifier` to `io.portalvr.portalcraft` (also updated `projectName`).
- `QCXR-XR-Wrapper/Assets/Scripts/{APIHandler.cs,InstanceManager.cs,LoadLog.cs,LoadReleases.cs,ModManager.cs,SkinHandler.cs}`
  - User-Agent strings now report `PortalVR/PortalCraft`.
- `QCXR-XR-Wrapper/Assets/Scripts/LoginText.cs`
  - Rebranded Microsoft auth error copy to reference PortalCraft.
- `QCXR-XR-Wrapper/Assets/Scripts/VersionChecker.cs`
  - Console/status output now references PortalCraft.
- `QCXR-XR-Wrapper/Assets/Scripts/{OpenWebURL.cs,WindowHandler.cs}`
  - Default website link retargeted to `https://portalvr.io`.
- `QCXR-XR-Wrapper/Assets/Localization/Tables/Main_*.asset`, `QCXR-XR-Wrapper/Assets/Resources/Crowdin/CrowdinTranslations.asset`, `QCXR-XR-Wrapper/Assets/Scenes/Main.unity`
  - Replaced QuestCraft/Digital Genesis branding strings with PortalCraft/Portal VR, Inc. (multiple languages + in-game EULA/UX copy). **Manual legal review required** to confirm wording and any jurisdictional statements.
- `Pojlib/src/main/java/pojlib/{API.java,util/JREUtils.java,util/download/DownloadUtils.java,util/json/MinecraftInstances.java,util/MCOptionUtils.java}`
  - Updated log lines, JVM flags, and download headers to use the PortalCraft name; maintained existing infrastructure URLs.
- `Pojlib/README.md`
  - Noted the PortalCraft rebrand when describing the library lineage.

## Brand Assets To Replace
- `QCXR-XR-Wrapper/Assets/Resources/Pojav_x_Vivecraft.png`
  - Currently drives the Unity splash screen (`m_SplashScreenLogos` / VR splash). Swap for PortalCraft-branded art and update meta if the replacement asset uses a different GUID.
- `QCXR-XR-Wrapper/Assets/Resources/Materials/export202201252311597020.png`
  - Assigned as the Android application icon in Player Settings (`m_BuildTargetIcons`). Provide new PortalCraft icon variants for all densities.
- Review the UI texture set under `QCXR-XR-Wrapper/Assets/Resources/UI/` (e.g., `Background.png`, `MainButton.png`, `Discord-Symbol-White.png`, `X Logo.png`) for QuestCraft-specific artwork and update as needed.
- Audit in-world textures such as `QCXR-XR-Wrapper/Assets/Resources/questerBackground.png` for embedded QuestCraft logos; replace if they surface branding in-game.

## External References Requiring Follow-Up
- `https://questcraft.org/open-source/` now points to `https://portalvr.io/open-source/` in localisation/EULA text—verify the new page exists or adjust to the accurate PortalCraft resource URL.
- Discord and social links remain pointed at legacy communities (`https://discord.com/invite/QuestCraft`, `https://discord.gg/questcraft`, `https://x.com/QuestCraftXR`). Supply the new Portal VR / PortalCraft destinations when they are ready and update `LoadLog.cs`, `APIHandler.cs` user agent contact text, `WindowHandler.cs`, and `OpenWebURL.cs` accordingly.
- Distribution/update checks still rely on QuestCraft GitHub endpoints (`https://github.com/QuestCraftPlusPlus/...`). Confirm whether the infrastructure is migrating; if so, update `LoadReleases.cs`, `InstanceHandler.java`, `Installer.java`, and related constants.

## Legal Content
- The in-app EULA and privacy acknowledgements (stored in `Assets/Scenes/Main.unity` and translated tables) were string-replaced to Portal VR, Inc. terminology. Please have counsel review the updated text against the official Terms of Service and Privacy Policy at `https://portalvr.io/terms` and `https://portalvr.io/privacy` to ensure compliance and to insert any company-specific clauses that differ from the QuestCraft version.

## Notes
- Build automation is available via `QCXR-XR-Wrapper/build.sh`; it already incorporates the rebranded package name and refreshed Pojlib artefact.
- Infrastructure references (GitHub branches `QuestCraft-6.0.0`, Modrinth loaders, etc.) were left untouched to avoid disrupting downloads; plan for a later migration if those resources are rehosted under Portal VR.
