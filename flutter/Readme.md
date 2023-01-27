@fourtimes 

_flutter installation on Ubuntu_

1. java required 
2. android app required
3. flutter binary required

_installation_

```bash
sudo snap install flutter --classic
sudo apt install default-jdk -y
```

_download the android sdk from official site_

https://docs.flutter.dev/get-started/install/linux#install-android-studio


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


