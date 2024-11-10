# CodeStyle

Is there a code style guide that you should follow?

Clearly, we should use the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

Seems like hard to remember all the rules? Don't worry! We can use a tool called `dartfmt` to help you format your code automatically.

Here is how you can use `dartfmt`:

## Android Studio/IntelliJ IDEA

1. Open your project in Android Studio/IntelliJ IDEA.
2. Install the Dart plugin if you haven't installed it.
3. Press `Ctrl + Alt + Shift + L` to format the code.
4. Done!

## Visual Studio Code

1. Open your project in Visual Studio Code.
2. Install the Dart plugin if you haven't installed it.
3. Press `Shift + Alt + F` to format the code.
4. Done!

## Other Editors

If you are using other editors, you can run the following command in the terminal to format the code:

```bash
dartfmt -w .
```

This command will format all Dart files in the current directory and its subdirectories.