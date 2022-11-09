# Git Access

- Start the ssh-agent in the background `eval "$(ssh-agent -s)"`
- `ssh-keygen -t ed25519 -C "your_email@example.com"`
- First, check to see if your `open ~/.ssh/config` file exists in the default location.If not,
  create file
- add these line in this file

```
  Host *.github.com
  IgnoreUnknown UseKeychain
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/id_ed25519
```

- if u have error add `IgnoreUnknown UseKeychain`, if not `remove it`
- add ssh in ur keychain`ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
- copy ur keychain `nano ~/.ssh/id_ed25519.pub`
- If it fails, you can run this command to add GitHub to the list of known
  hosts: `ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts`

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

# To add `Widget` in between the List

Add this extension

```dart
extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<A extends T>(A item) =>
      isEmpty
          ? this
          : (fold([], (r, element) => [...r, element, item])
        ..removeLast());
}
```

# If u want to border radius top right corner,top left corner, bottom right corner and bottom left corner of List items

Make ur single list `Container` to this border radius

```
padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
borderRadius: BorderRadius.only(
  topLeft: item == itemList.first
      ? Radius.circular(8)
      : Radius.zero,
  topRight: item == itemList.first
      ? Radius.circular(8)
      : Radius.zero,
  bottomLeft: item == itemList.last
      ? Radius.circular(8)
      : Radius.zero,
  bottomRight: item == itemList.last
      ? Radius.circular(8)
      : Radius.zero,
),
```

# If u desire ur appBar by customization of constant height u can use `PreferredSizeWidget` to appBar (first Method) and if u want more check out `sliver_appBar.dart`

```dart
PreferredSizeWidget appBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size(double.infinity, 74),
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: CupertinoTheme
              .of(context)
              .scaffoldBackgroundColor
              .withOpacity(0.8),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        'assets/demo_image.jpeg',
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            '1 Photo selected',
                            style: CupertinoTheme
                                .of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                'Options',
                                style: CupertinoTheme
                                    .of(context)
                                    .textTheme
                                    .actionTextStyle
                                    .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                CupertinoIcons.right_chevron,
                                size: 14,
                                color:
                                CupertinoTheme
                                    .of(context)
                                    .primaryColor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 14),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemFill
                                .resolveFrom(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: CupertinoColors.systemFill
                                .resolveFrom(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                  ],
                ),
              ),
              Divider(height: 1),
            ],
          ),
        ),
      ),
    ),
  );
}
```

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
