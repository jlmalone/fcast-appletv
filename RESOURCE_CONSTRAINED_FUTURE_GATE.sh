#!/bin/sh
# Unverified future gate for the maintained OvrCast tvOS application.
set -eu

repo_name=opencast-tvos
repo_root=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
verify=0
allow_network=0
owner_device=0
owner_integration=0
owner_deploy=0

die() {
    printf '%s\n' "future gate: $*" >&2
    exit 1
}

usage() {
    printf '%s\n' "usage: ./RESOURCE_CONSTRAINED_FUTURE_GATE.sh --verify --allow-network [--owner-approved-integration] [--owner-approved-device] [--owner-approved-deploy]"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --verify) verify=1 ;;
        --allow-network) allow_network=1 ;;
        --owner-approved-integration) owner_integration=1 ;;
        --owner-approved-device) owner_device=1 ;;
        --owner-approved-deploy) owner_deploy=1 ;;
        --help) usage; exit 0 ;;
        *) die "unknown option: $1" ;;
    esac
    shift
done

[ "$(basename "$repo_root")" = "$repo_name" ] || die "expected repository basename $repo_name"
git_root=$(git -C "$repo_root" rev-parse --show-toplevel 2>/dev/null) || die "not a Git worktree"
[ "$git_root" = "$repo_root" ] || die "script must remain at the Git worktree root"

if [ "$verify" -ne 1 ]; then
    usage
    printf '%s\n' "plan only: requires a clean checkout, CocoaPods, Xcode 26+, tvOS simulator, and explicit --allow-network."
    exit 0
fi

[ "$allow_network" -eq 1 ] || die "pod install may resolve dependencies; rerun with --allow-network"
[ -z "$(git -C "$repo_root" status --porcelain)" ] || die "a clean checkout is required"
git -C "$repo_root" diff --check
command -v pod >/dev/null 2>&1 || die "CocoaPods is required"
command -v xcodebuild >/dev/null 2>&1 || die "Xcode is required"

cd "$repo_root"
pod install
xcodebuild \
    -workspace OvrCast.xcworkspace \
    -scheme OvrCast \
    -destination "platform=tvOS Simulator,name=Apple TV 4K (3rd generation)" \
    build

printf '%s\n' "No XCTest target is configured; no automated test command is claimed."
if [ "$owner_integration" -eq 1 ]; then
    printf '%s\n' "Integration gate: exercise an FCast v3 handshake, Bonjour discovery, Play Sample, and AVPlayer/TVVLCKit/WebRTC/image routing with authorized local senders."
fi
if [ "$owner_device" -eq 1 ]; then
    printf '%s\n' "Device gate: owner selects a signed Apple TV target in Xcode, installs deliberately, then repeats the FCast and playback checks. This script does not install or sign."
fi
if [ "$owner_deploy" -eq 1 ]; then
    printf '%s\n' "Deployment remains intentionally manual: follow APPLE_DELIVERY.md for archive, export, validation, and App Store Connect upload. This script does not archive, export, sign, or upload."
fi

printf '%s\n' "UNVERIFIED: future gate commands completed only if every invoked command above succeeds."
