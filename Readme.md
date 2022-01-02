# MockLoc

## Description

An app for mocking locations on Android. **This project is for Delphi 11 (or higher) only**

Dependent on the [Kastri library](https://github.com/DelphiWorlds/Kastri).

Compatible with [Embarcadero](https://wwww.embarcadero.com) [Delphi](https://www.embarcadero.com/products/delphi)

## How To Use MockLoc

Presently, MockLoc uses intent broadcasts only to set mock locations. This is by design, allowing locations to be mocked without operating the app, so the device might have another app in the foreground, or the screen might be locked, and locations can still be mocked.

To mock a location, use the [adb command](https://developer.android.com/studio/command-line/adb) from the host computer in this format:

```
adb [-s serial] shell am broadcast -a ACTION_MOCK_LOCATION --ez ACTIVE true --ef LATITUDE latitude --ef LONGITUDE longitude com.delphiworlds.MockLoc
```

to set a mock location, or:

```
adb [-s serial] shell am broadcast -a ACTION_MOCK_LOCATION --ez ACTIVE false
```

to turn off mocking. The parameters are:

* `serial` (optional) is the serial number of the device (useful when there is more than one device connected)
* `latitude` is the desired latitude
* `longitude` is the desired longitude

For example:

```
adb shell am broadcast -a ACTION_MOCK_LOCATION --ez ACTIVE true --ef LATITUDE -34.87654 --ef LONGITUDE 138.54321 com.delphiworlds.MockLoc
```

## Support

### Issues page

If you encounter an issue, or want to make a suggestion, please [visit the issues page](https://github.com/DelphiWorlds/MockLoc/issues) to report it.

### Slack Channel

The Delphi Worlds Slack workspace has a channel (#kastri) devoted to discussing Kastri, however this channel can also be used to discuss Playground topics.

If you would like to join the Delphi Worlds Slack workspace, [please visit this self-invite link](https://slack.delphiworlds.com)

## License

How To is licensed under MIT, and the license file is included in this folder.

![](https://tokei.rs/b1/github/DelphiWorlds/MockLoc)