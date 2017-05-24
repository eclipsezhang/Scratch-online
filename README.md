## Scratch 2.0 在线版
### Building

scratch2.0构建使用[gradle](http://gradle.org/)来简化构建过程，Flex sdk将为您自动安装。

有两个版本的2.0编辑器。见下表来确定用什么命令对应的版本。

Required Flash version | Features | Command
--- | --- | ---
11.6 or above | 3D-accelerated rendering | `./gradlew build -Ptarget=11.6`
10.2 - 11.5 | Compatibility with older Flash (Linux, older OS X, etc.) | `./gradlew build -Ptarget=10.2`

成功构建将提示以下信息

```sh
$ ./gradlew build -Ptarget=11.6
Defining custom 'build' task when using the standard Gradle lifecycle plugins has been deprecated and is scheduled to be removed in Gradle 3.0
Target is: 11.6
Commit ID for scratch-flash is: e6df4f4
:copyresources
:compileFlex
WARNING: The -library-path option is being used internally by GradleFx. Alternative: specify the library as a 'merged' Gradle dependendency
:copytestresources
:test
Skipping tests since no tests exist
:build

BUILD SUCCESSFUL

Total time: 13.293 secs
```
在build目录中可以找生成的swf文件
```
