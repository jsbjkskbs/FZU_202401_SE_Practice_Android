# 代码风格

是否有代码风格指南需要遵循？

显然，我们应该使用官方的[Dart风格指南](https://dart.dev/guides/language/effective-dart/style)。

似乎很难记住所有规则？别担心！我们可以使用一个名为`dartfmt`的工具来帮助你自动格式化代码。

以下是如何使用`dartfmt`：

## Android Studio/IntelliJ IDEA

1. 在Android Studio/IntelliJ IDEA中打开你的项目。
2. 如果你还没有安装Dart插件，请安装它。
3. 按`Ctrl + Alt + Shift + L`来格式化代码。
4. 完成！

## Visual Studio Code

1. 在Visual Studio Code中打开你的项目。
2. 如果你还没有安装Dart插件，请安装它。
3. 按`Shift + Alt + F`来格式化代码。
4. 完成！

## 其他编辑器

如果你使用其他编辑器，可以在终端中运行以下命令来格式化代码：

```bash
dartfmt -w .
```

这个命令将格式化当前目录及其子目录中的所有Dart文件。