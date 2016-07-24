# GMailinator/Nostalgy4MailApp

Adds Gmail-esque keyboard shorcuts to Mail.app.  This is still very much a work
in progress. Tested with Mail for 10.11 and 10.12 Public Beta 2.

## Supported Shortcuts

<table>
  <tr><th>Key</th><th>Action</th></tr>
  <tr><td>c</td><td>Compose new message</td></tr>
  <tr><td>r</td><td>Reply All</td></tr>
  <tr><td>f</td><td>Forward</td></tr>
  <tr><td>s</td><td>Flag (Star)</td></tr>
  <tr><td>e</td><td>Archive</td></tr>
  <tr><td>l</td><td>Copy message to folder (opens dialog)</td></tr>
  <tr><td>m</td><td>Move message to folder (opens dialog)</td></tr>
  <tr><td>j</td><td>Go to previous message/thread</td></tr>
  <tr><td>k</td><td>Go to next message/thread</td></tr>
  <tr><td>g</td><td>Go to folder (opens dialog)</td></tr>
  <tr><td>/</td><td>Mailbox search</td></tr>
</table>

## How to install

1. Grab the latest build from the [Release page](https://github.com/jelmervdl/Nostalgy-4-Mail.app/releases), and unzip to `~/Library/Mail/Bundles`
2. Enable Mail.app plugins:
       `defaults write com.apple.mail EnableBundles -bool true`

## How to build

1. Load up the project in Xcode.
2. Run the build, this should automatically create `~/Library/Mail/Bundles` (but you may need to create this).
3. Enable Mail.app plugins:
       `defaults write com.apple.mail EnableBundles -bool true`
4. Relaunch Mail.

## Credits

The project has become a weird mix of both [Gmailinator](https://github.com/nompute/GMailinator) by [Michael Lai](https://github.com/nompute) and [Nostalgy-4-Mail.app](https://github.com/fxtentacle/Nostalgy-4-Mail.app) by [Hajo Nils Krabbenhöft](https://github.com/fxtentacle) and later [Marcin Pyla](https://github.com/cubbi). I somewhat merged both projects to my preferences and rewrote parts of it to be compatible with later versions of Apple's Mail.app.

Finally, this project could not have been maintained by me done without the invaluable [class-dump](http://stevenygard.com/projects/class-dump/) by Steve Nygard.