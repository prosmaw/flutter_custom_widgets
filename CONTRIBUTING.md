# Contributing to Flutter Custom Widgets
Thank you for considering contributing to Flutter Custom Widgets! Contributions are welcome and appreciated, whether they are bug reports, feature requests, code contributions, or documentation improvements.

Please follow the guidelines outlined below to ensure quality contribution.

## How to contribute

### 1. Fork The Repository

Create a fork of the repository on GitHub by clicking the **"Fork"** button.

### 2. Clone Your Fork

```bash
git clone https://github.com/your-username/flutter_custom_widgets.git
cd flutter_custom_widgets
```

### 3. Create a Branch
Use a descriptive name for your branch:

```bash
git checkout -b my-widget-name
```

### 4. Make Your Changes

Implement your changes or fixes locally. Ensure your code follows the project's coding standards.

**For a New Widget:**

  - Navigate to `lib/widgets`
    
  - Add a new Dart file for your widget. The file name should follow Dart naming convention (e.g. `my_widget.dart`)
    
  - Define your widget in the new file, ensuring proper documentation and reusability.

    ```dart
    // lib/widgets/my_widget.dart
    import 'package:flutter/material.dart';

    class MyWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Container(
        child: Text('Hello, this is MyWidget!'),
          );
      }
    }
    ```
    
  - Open `lib/pages/home_page.dart`
    
  - Import your new file :
    
    ```dart
    import '../widgets/my_widget.dart';
    ```
  - Add your widget to the `widgetsDemo` list:
    
    ```dart
    List<Demo> widgetsDemo = [
    ...
    Demo(builder: (context) => const MyWidget(), name: "MyWidget"),
    ];
    ```
### 5. Commit Your Changes

Add and commit your changes with a clear commit message:

```bash
git add .
git commit -m "Feat: Add MyWidget for displaying custom text"
```

### 6. Push to Your Fork
Push the changes to your forked repository:

```bash
git push origin my-widget-name
```

### 7. Open a Pull Request
Open a pull request (PR) from your fork to the main branch of this repository. Add a clear desciption of your changes.

Happy coding, and may your widgets always render flawlessly! 😄✨

