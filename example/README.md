## Mean While

`this symbol` are comment and u can easily just find this 😃

## At First , in app.dart `just temporary test` can remove or edit.It just for testing to work.

## for FCM setup

- setup firebase option and check it out with
  firebaseCLI (https://firebase.google.com/docs/flutter/setup?platform=android)
- uncomment in main.dart (fcm setup for background) `fcm setup`
- uncomment in app.dart (For fcm setup) `fcm setup`

## UserLoginExpiredDate

in app.dart `just temporary test`

- i added some duration for expiredDate in case of testing
- in actually, it will setup after successfully log in after you setup this expiredDate, remove that
  code lines

## Plugin Config

- Check it plugins in pubspec.yaml and configure your android and ios by documentation of these
  plugins (
  eg.FlutterLocalNotification,Firebase,firebase_messaging,flutter_local_notifications,path_provider,)

## flutterNativeSplash and appIcon

In pubspec.yaml file , add these config. `remove_alpha_ios` is for only ios. It needs.

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/images/zds_app_icon.png"
  remove_alpha_ios: true

flutter_native_splash:
  color: "#ffffff"
  image: "assets/images/Zala-Flying.png"

```

## for FlutterLocalNotification with Sound

Android

- Create folder `raw` in -> android->app->src->main->res->raw
- and create your audio file in raw folder

iOS

- open xcode and create 'New Group' by clicking right click with the name of 'Resources'
- and create your audio file in this folder

## For camera widget to use

- At first, in your stateFulWidget, put it `late List<CameraDescription> firstCamera;`
- Init camera,

  ```dart
  Future<void> initCamera() async {
      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();

      // Get a specific camera from the list of available cameras.
      firstCamera = cameras;
  }
  ```

- and call this function in @initState method
- and then call JackCamera Widget and it will return uint8base data of image and file path

# TODO

in upgrade app u should take async function to fetch the version data. Camera is need to modify and
update Learn Animation controller

# Typography

| Sizing | Weight                 | Color        | Notes                                                            |
|--------|------------------------|--------------|------------------------------------------------------------------|
| 34     | Bold                   | Black or Any | Page Title Before Scrolled                                       |
| 17     | Semi bold              | Black or Any | Page AppBar Title after Scrolled                                 |
| 17     | Medium                 | Black or Any | Important highlight button <br/> bodyTitle,listTitle,dialogTitle |
| 17     | Regular                | Black or Any | BackNavButton,All Button, <br/> TextInput include                |
| 15     | Semi bold <br/> Medium | Black or Any | SegmentedControl(Small button) eg.(Images,Attachments)           |
| 15     | Regular                | Black        | Body Emphasize eg.(Replay:JackWill)                              |
| 15     | Regular                | Grey         | body,secondary text,date                                         |
| 13     | Regular                | Grey         | Captions,Description                                             |
| 10     | Medium                 | Grey or Any  | Tab bar,Action bar, (Don't go smaller than this)                 |
|        |                        |              |                                                                  |

- Bold (700)
- Semi Bold (600)
- Medium (500)
- Regular (400)

`Default line height => 120% - 145%`

| Size | Character Spacing |
|------|-------------------|
| 34   | 0.41              |
| 17   | -0.41             |
| 15   | -0.24             |
| 13   | -0.08             |
| 10   | 0.12              |
