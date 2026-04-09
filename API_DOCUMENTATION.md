# AIOS API 文档

## 1. API 概述

### 1.1 基本信息
- **API版本**：1.0
- **基础URL**：http://localhost:48080/admin-api
- **文档地址**：http://localhost:48080/doc.html
- **认证方式**：Bearer Token (Sa-Token)

### 1.2 认证机制
所有API请求都需要在Header中携带认证信息：

```http
Authorization: Bearer {token}
```

### 1.3 响应格式
```json
{
    "code": 0,
    "data": {},
    "msg": "success"
}
```

#### 响应码说明
- `0`: 成功
- `401`: 未认证
- `403`: 无权限
- `500`: 服务器错误

## 2. 系统管理API

### 2.1 用户管理

#### 获取用户列表
```http
GET /system/user/page
```

**请求参数：**
```json
{
    "pageNum": 1,
    "pageSize": 10,
    "username": "admin",
    "status": "0"
}
```

**响应示例：**
```json
{
    "code": 0,
    "data": {
        "total": 1,
        "list": [
            {
                "userId": 1,
                "username": "admin",
                "nickName": "管理员",
                "email": "admin@example.com",
                "phonenumber": "13800138000",
                "sex": "1",
                "status": "0",
                "createTime": "2023-01-01 12:00:00"
            }
        ]
    }
}
```

#### 获取用户详情
```http
GET /system/user/get/{id}
```

#### 新增用户
```http
POST /system/user/create
```

**请求参数：**
```json
{
    "username": "test",
    "password": "test123",
    "nickName": "测试用户",
    "email": "test@example.com",
    "phonenumber": "13900139000",
    "sex": "0",
    "status": "0"
}
```

#### 修改用户
```http
PUT /system/user/update
```

**请求参数：**
```json
{
    "userId": 2,
    "nickName": "测试用户修改",
    "email": "test2@example.com"
}
```

#### 删除用户
```http
DELETE /system/user/delete/{id}
```

#### 重置密码
```http
PUT /system/user/password/reset/{id}
```

### 2.2 角色管理

#### 获取角色列表
```http
GET /system/role/page
```

#### 获取角色详情
```http
GET /system/role/get/{id}
```

#### 新增角色
```http
POST /system/role/create
```

**请求参数：**
```json
{
    "roleName": "测试角色",
    "roleKey": "test",
    "roleSort": 1,
    "dataScope": "1",
    "status": "0"
}
```

#### 修改角色
```http
PUT /system/role/update
```

#### 删除角色
```http
DELETE /system/role/delete/{id}
```

#### 角色权限分配
```http
PUT /system/role/menu/{roleId}
```

**请求参数：**
```json
{
    "menuIds": [1, 2, 3]
}
```

### 2.3 菜单管理

#### 获取菜单树
```http
GET /system/menu/list
```

#### 获取菜单详情
```http
GET /system/menu/get/{id}
```

#### 新增菜单
```http
POST /system/menu/create
```

**请求参数：**
```json
{
    "menuName": "测试菜单",
    "parentId": 0,
    "orderNum": 1,
    "path": "test",
    "component": "Test",
    "menuType": "C",
    "visible": 1,
    "status": "0",
    "perms": "test:list"
}
```

#### 修改菜单
```http
PUT /system/menu/update
```

#### 删除菜单
```http
DELETE /system/menu/delete/{id}
```

### 2.4 部门管理

#### 获取部门列表
```http
GET /system/dept/list
```

#### 获取部门详情
```http
GET /system/dept/get/{id}
```

#### 新增部门
```http
POST /system/dept/create
```

**请求参数：**
```json
{
    "deptName": "测试部门",
    "parentId": 1,
    "orderNum": 1,
    "leader": "测试负责人",
    "phone": "13800138000",
    "email": "test@example.com",
    "status": "0"
}
```

#### 修改部门
```http
PUT /system/dept/update
```

#### 删除部门
```http
DELETE /system/dept/delete/{id}
```

## 3. 基础设施API

### 3.1 文件管理

#### 文件上传
```http
POST /infra/file/upload
```

**请求参数：**
- `file`: 文件对象

**响应示例：**
```json
{
    "code": 0,
    "data": {
        "url": "/api/files/20260408/123456.jpg",
        "name": "123456.jpg",
        "size": 1024000,
        "type": "image/jpeg"
    }
}
```

#### 文件下载
```http
GET /infra/file/download/{path}
```

### 3.2 代码生成

#### 获取生成配置
```http
GET /infra/codegen/get-generator-config
```

#### 生成代码
```http
POST /infra/codegen/generate-code
```

**请求参数：**
```json
{
    "tableName": "sys_user",
    "moduleName": "system",
    "businessName": "user",
    "className": "User",
    "author": "admin"
}
```

### 3.3 监控管理

#### 获取在线用户
```http
GET /monitor/online/list
```

#### 强退用户
```http
DELETE /monitor/online/force-logout/{tokenId}
```

#### 获取操作日志
```http
GET /monitor/operlog/list
```

#### 获取登录日志
```http
GET /monitor/logininfor/list
```

### 3.4 定时任务

#### 获取任务列表
```http
GET /monitor/job/list
```

#### 新增任务
```http
POST /monitor/job/create
```

**请求参数：**
```json
{
    "jobName": "测试任务",
    "jobGroup": "DEFAULT",
    "invokeTarget": "testJob.execute",
    "cronExpression": "0/5 * * * * ?",
    "misfirePolicy": "1",
    "concurrent": "1"
}
```

#### 修改任务
```http
PUT /monitor/job/update
```

#### 删除任务
```http
DELETE /monitor/job/delete/{jobId}
```

#### 启动任务
```http
PUT /monitor/job/run/{jobId}
```

#### 停止任务
```http
PUT /monitor/job/stop/{jobId}
```

## 4. 业务模块API

### 4.1 会员管理

#### 获取会员列表
```http
GET /member/user/page
```

#### 获取会员详情
```http
GET /member/user/get/{id}
```

#### 新增会员
```http
POST /member/user/create
```

**请求参数：**
```json
{
    "userId": 1,
    "nickname": "测试会员",
    "avatar": "/api/files/avatar.jpg",
    "levelId": 1,
    "points": 100,
    "balance": 100.00
}
```

#### 修改会员
```http
PUT /member/user/update
```

#### 删除会员
```http
DELETE /member/user/delete/{id}
```

### 4.2 商品管理

#### 获取商品列表
```http
GET /mall/product/page
```

#### 获取商品详情
```http
GET /mall/product/get/{id}
```

#### 新增商品
```http
POST /mall/product/create
```

**请求参数：**
```json
{
    "name": "测试商品",
    "spuCode": "TEST001",
    "categoryId": 1,
    "brandId": 1,
    "price": 99.99,
    "originalPrice": 199.99,
    "stock": 100,
    "status": 0,
    "image": "/api/products/test.jpg",
    "description": "商品描述"
}
```

#### 修改商品
```http
PUT /mall/product/update
```

#### 删除商品
```http
DELETE /mall/product/delete/{id}
```

#### 上下架商品
```http
PUT /mall/product/update-status
```

**请求参数：**
```json
{
    "ids": [1, 2, 3],
    "status": 0
}
```

### 4.3 订单管理

#### 获取订单列表
```http
GET /mall/trade/order/page
```

#### 获取订单详情
```http
GET /mall/trade/order/get/{id}
```

#### 创建订单
```http
POST /mall/trade/order/create
```

**请求参数：**
```json
{
    "items": [
        {
            "productId": 1,
            "skuId": 1,
            "quantity": 1
        }
    ],
    "addressId": 1,
    "remark": "订单备注"
}
```

#### 支付订单
```http
POST /mall/trade/order/pay
```

**请求参数：**
```json
{
    "orderId": 1,
    "paymentMethod": "alipay",
    "paymentChannel": "alipay_app"
}
```

#### 发货
```http
PUT /mall/trade/order/deliver
```

**请求参数：**
```json
{
    "orderId": 1,
    "logisticsNo": "SF1234567890",
    "logisticsCompany": "顺丰快递"
}
```

### 4.4 CRM管理

#### 客户列表
```http
GET /crm/customer/page
```

#### 客户详情
```http
GET /crm/customer/get/{id}
```

#### 新增客户
```http
POST /crm/customer/create
```

**请求参数：**
```json
{
    "name": "张三",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "company": "测试公司",
    "position": "经理",
    "source": "1",
    "level": "1",
    "status": "1"
}
```

#### 商机列表
```http
GET /crm/business/page
```

#### 新增商机
```http
POST /crm/business/create
```

## 5. 公共API

### 5.1 获取字典数据

#### 字典列表
```http
GET /system/dict/type/list
```

#### 字典数据
```http
GET /system/dict/data/type/{type}
```

### 5.2 获取验证码

#### 获取图片验证码
```http
GET /captcha/image
```

**响应示例：**
```json
{
    "code": 0,
    "data": {
        "uuid": "123456",
        "img": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUg..."
    }
}
```

#### 校验验证码
```http
POST /captcha/verify
```

**请求参数：**
```json
{
    "uuid": "123456",
    "code": "1234"
}
```

### 5.3 获取用户信息

#### 获取当前用户信息
```http
GET /system/user/profile/get
```

**响应示例：**
```json
{
    "code": 0,
    "data": {
        "userId": 1,
        "username": "admin",
        "nickName": "管理员",
        "email": "admin@example.com",
        "phonenumber": "13800138000",
        "sex": "1",
        "avatar": "/api/files/avatar.jpg",
        "roles": ["admin"],
        "permissions": ["*"]
    }
}
```

#### 修改用户信息
```http
PUT /system/user/profile/update
```

#### 修改密码
```http
PUT /system/user/profile/password
```

**请求参数：**
```json
{
    "oldPassword": "admin123",
    "newPassword": "newpass123"
}
```

### 5.4 文件上传

#### 本地上传
```http
POST /infra/file/upload
```

#### 阿里云OSS上传
```http
POST /infra/file/upload/oss
```

## 6. WebSocket API

### 6.1 连接WebSocket
```javascript
const ws = new WebSocket('ws://localhost:48080/infra/ws');
```

### 6.2 发送消息
```javascript
ws.send(JSON.stringify({
    type: 'message',
    content: '测试消息',
    timestamp: Date.now()
}));
```

### 6.3 接收消息
```javascript
ws.onmessage = function(event) {
    const data = JSON.parse(event.data);
    console.log('收到消息：', data);
};
```

## 7. 接口调用示例

### 7.1 使用curl调用示例
```bash
# 获取用户列表
curl -X GET "http://localhost:48080/admin-api/system/user/page" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{"pageNum": 1, "pageSize": 10}"

# 创建用户
curl -X POST "http://localhost:48080/admin-api/system/user/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "username": "test",
    "password": "test123",
    "nickName": "测试用户",
    "email": "test@example.com",
    "status": "0"
  }'
```

### 7.2 使用JavaScript调用示例
```javascript
// 获取用户列表
async function getUsers() {
  const response = await fetch('/admin-api/system/user/page', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    }
  });
  const result = await response.json();
  return result;
}

// 创建用户
async function createUser(userData) {
  const response = await fetch('/admin-api/system/user/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify(userData)
  });
  const result = await response.json();
  return result;
}
```

### 7.3 使用Postman调用示例
1. 设置Request URL：`http://localhost:48080/admin-api/system/user/page`
2. 设置Method：GET
3. 设置Headers：
   - Content-Type: application/json
   - Authorization: Bearer {token}
4. 设置Body（如果需要）：
   - 选择raw JSON
   - 输入参数
5. 点击Send发送请求

## 8. 接口规范

### 8.1 RESTful规范
- GET：查询数据
- POST：创建数据
- PUT：更新数据
- DELETE：删除数据

### 8.2 接口命名规范
- 列表查询：`/module/page`
- 详情查询：`/module/get/{id}`
- 创建：`/module/create`
- 更新：`/module/update`
- 删除：`/module/delete/{id}`
- 批量操作：`/module/batch-{operation}`

### 8.3 参数规范
- 路径参数：`/user/get/{id}`
- 查询参数：`/user/list?pageNum=1&pageSize=10`
- 请求体：JSON格式
- 分页参数：pageNum, pageSize

### 8.4 返回规范
- 成功：code=0
- 失败：code>0, msg包含错误信息
- 分页：包含total、list、pageNum、pageSize字段

## 9. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 0 | 成功 |
| 401 | 未认证 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 500 | 服务器错误 |
| 1001 | 参数错误 |
| 1002 | 用户名已存在 |
| 1003 | 邮箱已存在 |
| 1004 | 手机号已存在 |
| 2001 | 商品库存不足 |
| 2002 | 订单状态异常 |
| 2003 | 支付失败 |

---

*本文档最后更新时间：2026-04-08*