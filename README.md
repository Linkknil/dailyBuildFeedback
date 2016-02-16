# dailyBuildFeedback
1、dailybuild.sh
是每天打包的shell脚本，
里面包括
---Xcode的编译，xcodebuild指令
---自动打包，xcrun指令
---上传到蒲公英，curl -F上传

2、dailyFeedback.py
是python执行文件
里面包括
----自动发邮件
----显示当天的svn log（changeLog）

具体项目使用
首先要修改dailybuild.sh中的工程配置信息和签名等
然后直接终端执行
./dailybuild.sh 即可