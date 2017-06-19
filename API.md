注：get请求中中文均使用urlencode编码
目录：/api/
## user_token定义
1. 用户提交用户名和密码，实现登录（走https）；
2. 登录成功后，服务端返回一个 user_token，生成规则参考如下：
token=md5 ('用户id' + '当前时间' +'密钥')
服务端用Yii的cache维护user_token的状态

服务端生成 user_token 后，返回给客户端存储，客户端每次接口请求时，如果接口需要用户登录才能访问，则需要把 user_id 与 user_token 传回给服务端，服务端接受到这2个参数后，需要做以下几步：
1. 检测 api_token的有效性；
2. 删除过期的 user_token 表记录；
3. 根据 user_id，user_token获取表记录，如果表记录不存在，直接返回错误，如果记录存在，则进行下一步；
4. 更新 user_token 的过期时间（延期，保证其有效期内连续操作不掉线）；
5. 返回接口数据

## 获取user_token（登录）

| 请求方式        | 地址         |
| ------------- |:-------------:|
| post      | token.php?tpye=get |

### 参数

|参数名   |类型      |说明     |
|---------|:-------:|--------:|
|user     |string   |用户名    |
|password |string   |密码(md5)|
|null     |null     |参数为空时根据session获取token|

### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|user_token    |string  |user_token|

## 验证token
| 请求方式        | 地址         |
| ------------- |:-------------:|
| post      | token.php?tpye=verify |

### 参数

|参数名   |类型      |说明     |
|---------|:-------:|--------:|
|user_token|string|token值|
|user_id|string|用户ID|

### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|url    |string  |返回视频的播放分享页面|

## 上传录像 video.php

路径：
/video/{user_id}/{filename}_{timestamp}.mp4

### 参数

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|data|post|byte|视频数据|
|user_token|get|string|token|
|user_id|get|string|用户ID|
|filename|get|string|文件名|
|ishw|get|int|是作为作业：1是，0否，默认0|

post中data数据可通过$GLOBALS[HTTP_RAW_POST_DATA]获取
参考代码：

`
    $video =  $GLOBALS[HTTP_RAW_POST_DATA];
    if(empty($video)) {
        $video = file_get_contents('php://input');
    }
`
### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|url    |string  |成功则返回视频的播放分享页面|

## 上传项目 project.php?type=upload

路径：
/project/{user_id}/{project_name}_{Y-M-D H:M:S}.sb2

### 参数

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|data|post|byte|项目数据|
|user_token|get|string|token|
|user_id|get|string|用户ID|
|project_name|get|string|项目名|


### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|result   |int  |0失败，1成功|


## 获取当前用户项目 project.php?type=get

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|user_token|get|string|token|
|user_id|get|string|用户ID|

获取当前用户额项目列表+url

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|projeces|json|项目列表(项目名+url)|

## 上传截屏（求助） screenshot.php

路径：
/screenshot/{user_id}/{timestramp}.jpg


|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|data|post|byte|截屏数据|
|user_token|get|string|token|
|user_id|get|string|用户ID|
|title|get|string|问题|
