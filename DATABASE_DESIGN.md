# AIOS 数据库设计文档

## 1. 数据库概述

### 1.1 数据库信息
- **数据库名称**：ry_vue
- **字符集**：utf8mb4
- **排序规则**：utf8mb4_unicode_ci
- **存储引擎**：InnoDB

### 1.2 数据库版本
- **MySQL版本**：8.0+
- **最低兼容版本**：5.7+

### 1.3 数据库表统计
- **总表数**：68个表
- **核心表数**：12个核心业务表
- **字典表数**：10个字典表
- **日志表数**：6个日志表

## 2. 核心表结构

### 2.1 用户管理相关表

#### 用户表 (sys_user)
```sql
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` tinyint NOT NULL DEFAULT '1' COMMENT '用户类型',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '性别',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '帐号状态',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB COMMENT='用户信息表';
```

#### 角色表 (sys_role)
```sql
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) NOT NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint NOT NULL DEFAULT '1' COMMENT '菜单树选择项关联显示',
  `dept_check_strictly` tinyint NOT NULL DEFAULT '1' COMMENT '部门树选择项关联显示',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '角色状态',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB COMMENT='角色信息表';
```

#### 用户角色关联表 (sys_user_role)
```sql
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB COMMENT='用户和角色关联表';
```

#### 权限菜单表 (sys_menu)
```sql
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` int DEFAULT '1' COMMENT '菜单状态（0隐藏 1显示）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB COMMENT='菜单权限表';
```

### 2.2 部门管理相关表

#### 部门表 (sys_dept)
```sql
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `dept_name` varchar(30) NOT NULL COMMENT '部门名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门ID',
  `ancestors` varchar(500) DEFAULT '' COMMENT '祖级列表',
  `order_num` int NOT NULL DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT '' COMMENT '负责人',
  `phone` varchar(11) DEFAULT '' COMMENT '联系电话',
  `email` varchar(50) DEFAULT '' COMMENT '邮箱',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) NOT NULL DEFAULT '0' COMMENT '删除标志',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB COMMENT='部门表';
```

### 2.3 字典管理相关表

#### 字典类型表 (sys_dict_type)
```sql
CREATE TABLE `sys_dict_type` (
  `dict_type_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`dict_type_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB COMMENT='字典类型表';
```

#### 字典数据表 (sys_dict_data)
```sql
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NOT NULL DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT '' COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT '' COMMENT '表格字典样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB COMMENT='字典数据表';
```

### 2.4 系统配置相关表

#### 参数配置表 (sys_config)
```sql
CREATE TABLE `sys_config` (
  `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `config_group` varchar(100) DEFAULT '' COMMENT '配置分组',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB COMMENT='参数配置表';
```

## 3. 业务模块表结构

### 3.1 会员模块表

#### 会员表 (member_user)
```sql
CREATE TABLE `member_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会员ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `nickname` varchar(50) NOT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `level_id` bigint DEFAULT '1' COMMENT '会员等级ID',
  `points` int DEFAULT '0' COMMENT '积分',
  `balance` decimal(10,2) DEFAULT '0.00' COMMENT '余额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0-正常 1-禁用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB COMMENT='会员表';
```

#### 会员等级表 (member_level)
```sql
CREATE TABLE `member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '等级ID',
  `name` varchar(50) NOT NULL COMMENT '等级名称',
  `level` int NOT NULL COMMENT '等级',
  `points_required` int NOT NULL DEFAULT '0' COMMENT '所需积分',
  `discount` decimal(3,2) DEFAULT '1.00' COMMENT '折扣率',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0-正常 1-停用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='会员等级表';
```

### 3.2 商品模块表

#### 商品表 (product)
```sql
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `spu_code` varchar(50) NOT NULL COMMENT '商品编码',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `brand_id` bigint NOT NULL COMMENT '品牌ID',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `original_price` decimal(10,2) DEFAULT '0.00' COMMENT '原价',
  `cost_price` decimal(10,2) DEFAULT '0.00' COMMENT '成本价',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` int NOT NULL DEFAULT '0' COMMENT '销量',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态（0-上架 1-下架）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `image` varchar(255) DEFAULT '' COMMENT '主图',
  `description` text COMMENT '商品描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_spu_code` (`spu_code`)
) ENGINE=InnoDB COMMENT='商品表';
```

#### 商品SKU表 (product_sku)
```sql
CREATE TABLE `product_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'SKU ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `sku_name` varchar(100) NOT NULL COMMENT 'SKU名称',
  `sku_code` varchar(50) NOT NULL COMMENT 'SKU编码',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存',
  `sales` int NOT NULL DEFAULT '0' COMMENT '销量',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
  `sku_spec` varchar(500) DEFAULT '' COMMENT '规格属性',
  `image` varchar(255) DEFAULT '' COMMENT '图片',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sku_code` (`sku_code`)
) ENGINE=InnoDB COMMENT='商品SKU表';
```

### 3.3 订单模块表

#### 订单表 (trade_order)
```sql
CREATE TABLE `trade_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_amount` decimal(10,2) NOT NULL COMMENT '订单金额',
  `pay_amount` decimal(10,2) NOT NULL COMMENT '支付金额',
  `discount_amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠金额',
  `freight_amount` decimal(10,2) DEFAULT '0.00' COMMENT '运费',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态（0-待支付 1-待发货 2-已发货 3-已完成 4-已取消）',
  `payment_method` varchar(20) DEFAULT '' COMMENT '支付方式',
  `payment_channel` varchar(20) DEFAULT '' COMMENT '支付渠道',
  `logistics_no` varchar(50) DEFAULT '' COMMENT '物流单号',
  `logistics_company` varchar(50) DEFAULT '' COMMENT '物流公司',
  `receiver_name` varchar(50) DEFAULT '' COMMENT '收货人',
  `receiver_phone` varchar(20) DEFAULT '' COMMENT '收货人电话',
  `receiver_address` varchar(255) DEFAULT '' COMMENT '收货地址',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB COMMENT='订单表';
```

#### 订单详情表 (trade_order_item)
```sql
CREATE TABLE `trade_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `sku_id` bigint NOT NULL COMMENT 'SKU ID',
  `product_name` varchar(100) NOT NULL COMMENT '商品名称',
  `sku_name` varchar(100) NOT NULL COMMENT 'SKU名称',
  `price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `quantity` int NOT NULL COMMENT '购买数量',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='订单详情表';
```

## 4. 系统日志表

### 4.1 操作日志表

#### 操作日志表 (sys_oper_log)
```sql
CREATE TABLE `sys_oper_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '操作模块',
  `business_type` int NOT NULL DEFAULT '0' COMMENT '业务类型（0=其它,1=新增,2=修改,3=删除）',
  `method` varchar(100) DEFAULT '' COMMENT '请求方法',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int NOT NULL DEFAULT '0' COMMENT '操作类别（0=其它,1=后台用户,2=手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '操作地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int NOT NULL DEFAULT '0' COMMENT '操作状态（0=正常,1=异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间(毫秒)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='操作日志记录';
```

### 4.2 登录日志表

#### 登录日志表 (sys_login_log)
```sql
CREATE TABLE `sys_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `username` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0=成功 1=失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='系统记录';
```

## 5. 索引设计

### 5.1 主键索引
所有表都使用自增主键，确保查询效率。

### 5.2 唯一索引
```sql
-- 用户名唯一
CREATE UNIQUE INDEX idx_sys_user_username ON sys_user(username);

-- 角色键唯一
CREATE UNIQUE INDEX idx_sys_role_role_key ON sys_role(role_key);

-- 字典类型唯一
CREATE UNIQUE INDEX idx_sys_dict_type_dict_type ON sys_dict_type(dict_type);

-- 商品编码唯一
CREATE UNIQUE INDEX idx_product_spu_code ON product(spu_code);
```

### 5.3 普通索引
```sql
-- 用户状态索引
CREATE INDEX idx_sys_user_status ON sys_user(status);

-- 角色状态索引
CREATE INDEX idx_sys_role_status ON sys_role(status);

-- 部门状态索引
CREATE INDEX idx_sys_dept_status ON sys_dept(status);

-- 商品状态索引
CREATE INDEX idx_product_status ON product(status);
```

## 6. 数据库优化建议

### 6.1 表设计优化
1. **合理使用字段类型**：根据业务需求选择合适的字段类型
2. **避免过多字段**：单表字段数控制在20个以内
3. **适当冗余**：在查询性能和存储空间之间找到平衡

### 6.2 索引优化
1. **复合索引**：根据查询条件创建合适的复合索引
2. **避免过度索引**：索引过多会影响写入性能
3. **定期维护**：定期优化和重建索引

### 6.3 查询优化
1. **使用覆盖索引**：减少回表操作
2. **避免全表扫描**：合理的WHERE条件
3. **分页查询**：使用LIMIT分页

### 6.4 分库分表
当数据量达到以下阈值时，考虑分库分表：
- 用户表：1000万+
- 订单表：500万+
- 商品表：100万+

## 7. 数据备份策略

### 7.1 备份方式
1. **全量备份**：每天凌晨2点
2. **增量备份**：每小时一次
3. **二进制日志备份**：实时同步

### 7.2 备份保留
- 全量备份：保留7天
- 增量备份：保留24小时
- 二进制日志：保留3天

### 7.3 恢复策略
1. **误删数据**：通过二进制日志恢复
2. **数据库损坏**：使用全量备份+增量备份恢复
3. **机房故障**：通过异地备份恢复

---

*本文档最后更新时间：2026-04-08*