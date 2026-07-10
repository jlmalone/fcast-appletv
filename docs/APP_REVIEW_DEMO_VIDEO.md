# App Review demo video (Guideline 2.1, Information Needed)

## Why this exists

OvrCast is an FCast *receiver*. It shows an idle screen and waits for an FCast
*sender* on the same Wi-Fi to discover it and cast media. App Review cannot
exercise that path without standing up a sender on their network, so for every
submission they request a demo video of the app on a physical Apple TV, pairing
and interacting with FCast.

Rejection reference: Submission ID `b5635831-79f5-4f4e-8ca7-fb791398fd6f`,
reviewed 2026-07-09, Guideline 2.1 (Information Needed), version 1.6 (3).

Apple's own note: once a valid video exists and the app is unchanged, later
submissions can reference the same recording by stating in the Notes field that
it remains valid for all storefronts. So this is mostly a one-time cost as long
as we keep a good master recording.

## What you need

1. A physical Apple TV (4th gen or later, tvOS 17+) with OvrCast build 1.6 (3)
   installed. Simulator footage is explicitly rejected.
2. An FCast sender on the same Wi-Fi. Easiest is the free FCast desktop app from
   fcast.org (macOS / Windows / Linux). Grayjay on Android also works.
3. A way to capture the Apple TV screen. tvOS has no built-in screen recording,
   so use one of:
   - Point a phone camera at the TV. Simplest, and it proves the app is on real
     hardware, which is exactly what Apple asked for.
   - An HDMI capture dongle (Apple TV HDMI out into a USB capture device,
     recorded on a Mac with QuickTime or OBS) for a clean feed. Note: QuickTime
     "New Movie Recording" cannot capture a modern Apple TV, so a capture card is
     the only clean-feed route.

## Shot list (aim for 2 to 4 minutes)

Record in this order. Narrate each step (voiceover or on-screen captions) so the
reviewer can follow.

1. First launch and permission prompt. If OvrCast is already installed and the
   permission was granted, delete and reinstall so the prompt appears fresh. On
   launch, tvOS shows the Local Network permission dialog:
   "OvrCast uses the local network to receive video and audio streams from
   FCast-compatible sender devices." Select Allow on camera. This is the only
   runtime permission the app requests.
2. Idle screen. Hold on it long enough to read the device name, local IP
   address, QR code, and the "Play Sample" button.
3. Discovery and pairing. Switch to the FCast sender. Show OvrCast (the Apple
   TV's name) appearing automatically in the sender's device list over mDNS, and
   connect to it. This is the pairing Apple asked to see.
4. Cast and play. In the sender, choose a video (an HLS `.m3u8` or MP4 works
   best) and cast it. Show playback starting on the Apple TV.
5. Transport controls. Using the Siri Remote and/or the sender, demonstrate
   pause, resume, seek, volume, and playback speed. Show the picture responding.
6. Format breadth (optional but recommended). Cast one more item of a different
   kind, for example an image (PNG or JPEG shows fullscreen) or an MKV/WebM
   (plays through the bundled VLC backend).
7. Built-in demo (optional). Back on the idle screen, select "Play Sample" to
   show playback with no sender attached.
8. End on the idle screen.

Note on camera and microphone: the app declares camera and microphone purpose
strings only because the embedded WebRTC framework references those APIs. The
app never captures camera or mic, so no camera or microphone permission prompt
will appear. There is nothing to record there.

## Notes field text (App Review Information, Notes)

Paste this with the real link filled in:

> OvrCast is a receiver for the open FCast casting protocol. It requires no
> account and collects no data.
>
> Demo video (physical Apple TV, tvOS): <VIDEO_URL>
>
> The video shows: the first-launch Local Network permission prompt and Allow;
> the idle screen (device name, IP, QR code, Play Sample); an FCast sender (the
> FCast desktop app from fcast.org) discovering the Apple TV over mDNS and
> pairing; casting a video and controlling playback (pause, resume, seek,
> volume, speed); and the built-in Play Sample demo. The only runtime permission
> requested is Local Network, used to receive streams from FCast senders. No
> companion device is needed to see playback, because the idle screen's Play
> Sample button streams a public-domain clip. This video is valid for all
> storefronts.

## Resolution Center reply

Reply to the reviewer's message in App Store Connect with:

> Thank you. We have added a demo video recorded on a physical Apple TV to the
> Notes field of the App Review Information section. It shows OvrCast on tvOS:
> the first-launch Local Network permission prompt, an FCast sender discovering
> and pairing with the Apple TV over mDNS, casting and controlling media
> playback, and the built-in Play Sample demo. Direct link: <VIDEO_URL>. The
> video is valid for all storefronts. Please let us know if anything further is
> needed.
