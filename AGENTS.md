# AGENTS.md

Authoritative repository instructions for OvrCast.

Read `/Users/joseph.malone/AGENTS.md` first.

## Product

OvrCast is an independent SwiftUI tvOS receiver for FCast protocol v3. It accepts media from Grayjay
and FCast desktop senders.

FCast is a FUTO trademark. Keep the OvrCast name and original icon. Use "FCast-compatible" only as a
protocol description and retain the independent-project disclaimer in product and store surfaces.

## Architecture

- SwiftUI app targeting tvOS 17 and later
- Network.framework and Bonjour discovery
- AVPlayer for HLS, MP4, MOV, and audio
- TVVLCKit for MKV, WebM, AVI, and TS
- WebRTC WHEP client for screen mirroring
- image display for image MIME types
- playlist opcodes 15 and 16

Build the workspace, not the project, because TVVLCKit uses CocoaPods:

```bash
pod install
xcodebuild \
  -workspace OvrCast.xcworkspace \
  -scheme OvrCast \
  -destination "platform=tvOS Simulator,name=Apple TV 4K (3rd generation)" \
  build
```

WebRTC is pinned to the compatible package release recorded in `Package.resolved`. Do not bump it
without verifying Swift tools and tvOS support.

## Playback routing

| Input | Backend |
|---|---|
| `application/x-whep` | WebRTC |
| `image/*` | image display |
| HLS, MP4, QuickTime, audio | AVPlayer |
| Other supported media containers | TVVLCKit |

Preserve the reviewer-facing "Play Sample" path and its fallback mirrors.

## Apple delivery

Read:

`/Users/joseph.malone/IdeaProjects/organiser/runbooks/APPLE_DELIVERY.md`

Repository-specific requirements:

- Unlock the signing keychain before archive or export.
- Archive with `-scmProvider system` to avoid login-keychain source-control prompts.
- Export with the system tool path if Homebrew rsync still breaks Xcode distribution.
- TVVLCKit ships as an xcframework. Keep the Podfile bitcode-strip hook compatible with both layouts.
- Verify the exported binary contains no `__LLVM` segment.
- Include self-contained Play Sample instructions in App Review notes.
- The app declares no analytics, tracking, or collected user data.
- Keep local-network and sender-provided-media transport exceptions required by receiver behavior.
- Keep TVVLCKit dynamically linked for LGPL compliance.

Use App Store Connect APIs and command-line tools where supported. Interactive App Store Connect
work requires current-session browser permission.

## Verification

- Build the tvOS workspace.
- Exercise an FCast handshake and sample playback with repository test tools.
- Verify Bonjour discovery and the relevant backend switch.
- Validate the archive before upload.
- Query App Store Connect rather than relying on old review-state prose.

Current cross-session state:

`/Users/joseph.malone/IdeaProjects/organiser/work/ovrcast.md`
