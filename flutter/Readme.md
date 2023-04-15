_Task_

1. install the basic software
2. create the dummy application

[Discussion](https://github.com/operation-unknown/proof-of-concepts/discussions/5#discussioncomment-4635200)

_Documentation_

flutter installation on Ubuntu

1. java required 
2. android app required
3. flutter binary required

_installation_

```bash
sudo snap install flutter --classic
sudo apt install default-jdk -y
```

download the android sdk from official site

https://docs.flutter.dev/get-started/install/linux#install-android-studio


_How can we create flutter project using Linux terminal?_

* flutter create app

_How to run the apps?_

* flutter run


```dart
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white70,
          appBar: AppBar(
            title: const Center(child: Text("I am Rich")),
            backgroundColor: Colors.blueGrey[900],
          ),
          body: const Center(
            child: Image(
              image: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            ),
          ),
        ),
      ),
    );

```

_stateless widget creation_

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: const Center(child: Text("Welcome")),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: Image(image: AssetImage("images/1.jpeg"))),
      ),
    );
  }
}

```


https://api.flutter.dev/flutter/widgets/Image-class.html

https://www.appicon.co/


