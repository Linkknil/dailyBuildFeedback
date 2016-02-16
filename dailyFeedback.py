# -*- coding: UTF-8 -*-
'''
发送txt文本邮件
小五义：http://www.cnblogs.com/xiaowuyi
'''
import smtplib  
import sys
import json
import re
import os
from email.mime.text import MIMEText
mailto_list=["175703453@qq.com","549039398@qq.com"]
#mailto_list=["549039398@qq.com"]

mail_host="smtp.163.com"  #设置服务器
mail_user="iosapp_dev"    #用户名
mail_pass="iOSApp_Dev"   #口令
mail_postfix="163.com"  #发件箱的后缀

def send_mail(to_list,sub,content):
    me="Name:"+"<"+mail_user+"@"+mail_postfix+">"
    msg = MIMEText(content,_subtype='plain',_charset='gb2312')
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ";".join(to_list)
    try:
        server = smtplib.SMTP()
        server.connect(mail_host)
        server.login(mail_user,mail_pass)
        server.sendmail(me, to_list, msg.as_string())
        server.close()
        return True
    except Exception, e:
        print str(e)
        return False

#print "脚本名:",sys.argv[0]
params=''
for i in range(1,len(sys.argv)):
   params=params+sys.argv[i]+" "
print "======="
print params
print type(params)

sendMailStr=""
#参数为空的时候代表curl 超时没有返回信息等，也是打包失败
if params == '':
    sendMailStr="upload failed~~~"
    print "params is null"
    send_mail(mailto_list,"Notice:",sendMailStr)
    exit()
print "param has value"
#jsonStr=json.dumps(params)
jsonStr1 = json.loads(params)
print jsonStr1
print type(jsonStr1)
    #logging.debug("cmtDict=%s", cmtDict);
    #uploadCode="0"
uploadCode=jsonStr1['code']
print "11111111"
print type(uploadCode)
print uploadCode
print "22222"


if uploadCode == 0:
    #os.system('svn log -r {`date "+%Y-%m-%d"`}:{`date -v+1d "+%Y-%m-%d"`}') > log
    var=os.popen('svn log -r {`date "+%Y-%m-%d"`}:{`date -v+1d "+%Y-%m-%d"`}').read()
    #print "var===\n\n%s" %var
    sendMailStr=("长传成功~~~~\n"
                 "包具体地址：http://www.pgyer.com/Xclv \n"
                 "账号:549039398@163.com 密码:0123456"
                 "\n更新日志:\n\n%s ")%(var)
else:
    sendMailStr="upload failed~~~"
print sendMailStr

if __name__ == '__main__':  
    if send_mail(mailto_list,"Notice:",sendMailStr):
        print "自动打包已完成"
