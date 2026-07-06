<!-- ATTRIBUTION-GUARD:v1 -->
> ⛔ **NO ATTRIBUTION (non-negotiable).** Never write authorship or credit of any kind into commits, PRs, code, or docs: no `Co-Authored-By`, no AI / model / agent name, no `🤖 Generated with…`, no `Author:` / `Prepared by:` / `Reviewed by:`. Say nothing about attribution at all. If this repo already contains any, flag it. Full rule: top of `~/AI.md`.

# CLAUDE.md - OvrCast (FCast-compatible receiver for Apple TV)

## Overview
Native tvOS application implementing the FCast protocol v3 for receiving cast video/audio streams from Grayjay and FCast desktop senders. Built with SwiftUI for Apple TV.

**Trademark:** FCast is a registered trademark of FUTO. This is an independent community implementation, not affiliated with FUTO. Per FUTO's trademark policy, the app uses its own unique name ("OvrCast") and original icon, with "FCast-compatible" used only to describe protocol compatibility.

## Key Features
- **FCast Protocol v3**: Full implementation of the open casting standard
- **Bonjour Discovery**: Automatic network discovery so senders find this receiver
- **Real-time Playback Control**: Play, pause, seek, volume from sender apps
- **Multi-Backend Playback**: AVPlayer (HLS/MP4/MOV), TVVLCKit (MKV/WebM/AVI/TS), WebRTC (WHEP screen mirror), Image display
- **Playlist Support**: Opcodes 15 (playUpdate) and 16 (setPlaylistItem)
- **WHEP Screen Mirroring**: Advertises `experimentalCapabilities.av.livestream.whep=true`, implements WebRTC/WHEP client for VP8 streams
- **Demo Mode**: "Play Sample" button on idle screen for App Store reviewers and first-time users

## Project Structure
```
OvrCast/
├── OvrCastApp.swift               # App entry point
├── OvrCast-Bridging-Header.h      # TVVLCKit Obj-C bridge
├── PrivacyInfo.xcprivacy               # App Store privacy manifest
├── Protocol/
│   ├── FCastPackets.swift              # Opcodes, message types, capabilities
│   ├── FCastSession.swift              # TCP session with binary framing
│   └── FCastServer.swift               # TCP server + Bonjour + message dispatch
├── Player/
│   ├── PlayerManager.swift             # Multi-backend player (AVPlayer/VLC/WebRTC/Image)
│   └── WHEPClient.swift                # WebRTC WHEP client for screen mirroring
├── UI/
│   ├── ContentView.swift               # Root view with backend switch
│   ├── IdleView.swift                  # Idle screen with QR code + Play Sample
│   ├── PlayerView.swift                # AVPlayer wrapper
│   ├── VLCPlayerView.swift             # VLC wrapper with Siri Remote controls
│   ├── WebRTCPlayerView.swift          # WebRTC video renderer (RTCMTLVideoView)
│   ├── ImageDisplayView.swift          # AsyncImage for cast images
│   └── AboutView.swift                 # Credits + VLC + trademark attribution
├── Utilities/
│   └── NetworkHelper.swift
└── Assets.xcassets/
```

## Dependencies
- **TVVLCKit** (~> 3.6.0): Universal format playback (MKV, WebM, AVI, etc.) — via CocoaPods
- **WebRTC** (webrtc-sdk/Specs 137.7151.00): WHEP/WebRTC screen mirroring — via SPM
  - NOTE: versions 137.7151.01+ are broken (`.visionOS(.v2)` with swift-tools-version:5.9)
- Build with `.xcworkspace` (not .xcodeproj) due to CocoaPods integration

## Build
```bash
pod install  # first time only
xcodebuild -workspace OvrCast.xcworkspace -scheme OvrCast -destination "platform=tvOS Simulator,name=Apple TV 4K (3rd generation)" build
```

## Format Routing (PlayerManager.selectBackend)
| MIME Type | Backend | View |
|-----------|---------|------|
| `application/x-whep` | `.webrtc` | WebRTCPlayerView |
| `image/*` | `.image` | ImageDisplayView |
| `application/x-mpegURL`, `.m3u8` | `.avPlayer` | PlayerView |
| `video/mp4`, `video/quicktime`, `audio/*` | `.avPlayer` | PlayerView |
| Everything else (MKV, WebM, AVI, TS) | `.vlc` | VLCPlayerView |

## Current Status (v1.6 build 3, 2026-07-05)
- **Media casting**: WORKING (verified E2E on tvOS 26.5 simulator: FCast handshake + MP4 playback via tools/fcast-sender.py)
- **Apple delivery issues from 1.5(2) all fixed**: ITMS-90683 (camera+mic purpose strings in Info.plist), ITMS-90994 (built with tvOS 26.5 SDK / Xcode 26.6), ITMS-90471 (2x top shelf images added, verified in Assets.car)
- **Demo mode**: "Play Sample" now has an ordered mirror list (googleapis + blender.org) with automatic fallback on host failure
- **Trademark compliance**: unique name (OvrCast) + original icon; FUTO's suggested disclaimer in About, README, store listing, and privacy page; GitHub repo description leads with OvrCast; LICENSE (MIT) added
- **ASC state**: version 1.6 PREPARE_FOR_SUBMISSION with description/keywords/subtitle/privacy URL+text/categories/age rating/review notes/screenshots all set; privacy page live at https://jlmalone.github.io/opencast-tvos/ (GitHub Pages from /docs)
- **1.6(3) build validated and uploaded**; owner actions: pick the build + submit for review in ASC, and remove the old rejected "FCastReceiver" app record (Apple ID 6759440031) via ASC UI (API cannot delete app records)

## App Store Submission Notes
- **Bundle ID**: vision.salient.opencast (ASC app ID 6760440913)
- **Team**: 44SCLSYCZZ
- **Signing**: Manual — profile "OpenCast App Store 2026" (embeds cert D9RMVPNY6M, expires 2027-05-28); unlock keychain first: `~/.appstoreconnect/kulus_unlock_signing.sh`
- **Archive**: `xcodebuild -workspace OvrCast.xcworkspace -scheme OvrCast -destination 'generic/platform=tvOS' archive -scmProvider system` (`-scmProvider system` stops SPM from poking the login keychain for github.com)
- **Export**: run with `env PATH="/usr/bin:/bin:/usr/sbin:/sbin"` — Homebrew rsync 3.4.4 breaks IDEDistributionCreateIPAStep ("Copy failed"; Xcode passes openrsync-only flags); plus `-exportOptionsPlist ~/.appstoreconnect/opencast_ExportOptions.plist -allowProvisioningUpdates` and the ASC API key auth flags (key D5XN56FV5J)
- **Podfile gotcha**: TVVLCKit ships as an xcframework; the bitcode-strip post_install hook globs both framework layouts — verify with `otool -l ... | grep -c __LLVM` (must be 0) after any `pod install`
- **Privacy**: No data collected, no tracking, no analytics. PrivacyInfo.xcprivacy included.
- **ATS**: `NSAllowsArbitraryLoadsForMedia` + `NSAllowsLocalNetworking` (media receiver plays sender-provided URLs)
- **LGPL**: TVVLCKit is dynamically linked via `use_frameworks!` (LGPL 2.1 compliant)
- **Review notes**: Include instructions to use "Play Sample" button since reviewers won't have an FCast sender

## Test Tools
- `tools/fcast-sender.py` — Python FCast protocol sender for testing
- `tools/fcast-sender.main.kts` — Kotlin version (requires `brew install kotlin`)

## Related Projects
- **Grayjay** (external): Primary sender app that casts to this receiver
- **FCast Desktop** (external): Desktop sender application
- **fightandflowtv** (`~/ios_code/fightandflowtv`): Another tvOS app in the portfolio (different purpose — fitness video)

## Platform
- **Target**: tvOS 17.0+ (Apple TV)
- **Framework**: SwiftUI
- **Media**: AVKit / AVFoundation / TVVLCKit / WebRTC
- **Networking**: Network.framework + Bonjour (NWListener)

## Roadmap
- Subtitle track selection
- Background audio playback
- Event subscription opcodes (17/18/19)
- Migrate TVVLCKit from CocoaPods to SPM (when available)
