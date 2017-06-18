注：get请求中中文均使用urlencode编码

# 用户相关
/api/user/
## user_token定义
1. 用户提交用户名和密码，实现登录（走https）；
2. 登录成功后，服务端返回一个 user_token，生成规则参考如下：
token=md5 ('用户id' + '当前时间' +'密钥')
服务端用用户表维护user_token的状态，表设计如下：

|字段名| 字段类型 |   注释|
|-----|:---------:|-------:|
|user_id| int| 用户ID|
|……|……|其他用户数据|
|user_token|  varchar(36)| 用户token|
|expire_time| int| 过期时间（Unix时间戳）|

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
|user_token    |stringn  |user_token|

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
|result    |int  |0无效，1有效|

## 上传录像 video.php

路径：
/video/user/project_name.mp4

### 参数

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|date|post|byte|视频数据,可通过$GLOBALS[HTTP_RAW_POST_DATA]获取|
|user_token|get|string|token|
|user_id|get|string|用户ID|
|project|get|string|项目名|
|ishw|get|int|是否是作业1是，0否|

获取视频数据代码参考

`
    $video =  $GLOBALS[HTTP_RAW_POST_DATA];
    if(empty($video)) {
        $video = file_get_contents('php://input');
    }
`
### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|result   |json  |0失败，1成功|
|message|json|信息|

## 上传项目 project.php?type=upload

路径：
/project/user_id/project_name.sb2

### 参数

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|date|post|byte|项目数据,可通过$GLOBALS[HTTP_RAW_POST_DATA]获取|
|user_token|get|string|token|
|user_id|get|string|用户ID|
|project|get|string|项目名（后缀为sb2）|


### 返回

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|result   |json  |0失败，1成功|
|message|json|信息|


## 获取当前用户项目 project.php?type=get

|参数名   |请求方法|类型      |说明     |
|---------|---------|:-------:|--------:|
|user_token|get|string|token|
|user_id|get|string|用户ID|

获取当前用户额项目列表+url

|返回     |类型     |说明     |
|---------|:-------:|--------:|
|projeces|json|项目列表(项目名+url)|
