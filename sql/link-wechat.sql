/*
Navicat MySQL Data Transfer

Source Server         : link-wechat
Source Server Version : 50731
Source Host           : 146.56.222.200:3306
Source Database       : link-wechat

Target Server Type    : MYSQL
Target Server Version : 50731
File Encoding         : 65001

Date: 2020-11-08 22:51:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COMMENT='代码生成业务表';

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES ('22', 'we_allocate_customer', '离职分配的客户列表', 'WeAllocateCustomer', 'crud', 'com.linkwechat.wecom', 'wecom', 'customer', '离职分配的客户列', 'ruoyi', '0', '/', '{}', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:30', null);
INSERT INTO `gen_table` VALUES ('23', 'we_allocate_group', '分配的群租', 'WeAllocateGroup', 'crud', 'com.linkwechat.wecom', 'wecom', 'group', '分配的群租', 'ruoyi', '0', '/', '{}', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41', null);
INSERT INTO `gen_table` VALUES ('25', 'we_message_push', '消息发送的表', 'WeMessagePush', 'crud', 'com.ruoyi.system', 'system', 'push', '消息发送的', 'ruoyi', '0', '/', null, 'admin', '2020-10-28 13:58:22', '', null, null);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` varchar(64) DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8mb4 COMMENT='代码生成业务表字段';

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES ('156', '22', 'id', null, 'bigint', 'Long', 'id', '1', '0', null, '1', null, null, null, 'EQ', 'input', '', '1', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:30');
INSERT INTO `gen_table_column` VALUES ('157', '22', 'takeover_userid', '接替成员的userid', 'varchar(32)', 'String', 'takeoverUserid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '2', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:30');
INSERT INTO `gen_table_column` VALUES ('158', '22', 'external_userid', '被分配的客户id', 'varchar(32)', 'String', 'externalUserid', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '3', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:31');
INSERT INTO `gen_table_column` VALUES ('159', '22', 'allocate_time', '分配时间', 'datetime', 'Date', 'allocateTime', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'datetime', '', '4', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:31');
INSERT INTO `gen_table_column` VALUES ('160', '22', 'handover_userid', '原跟进成员的userid', 'varchar(32)', 'String', 'handoverUserid', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '5', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:31');
INSERT INTO `gen_table_column` VALUES ('161', '23', 'id', null, 'bigint', 'Long', 'id', '1', '0', null, '1', null, null, null, 'EQ', 'input', '', '1', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41');
INSERT INTO `gen_table_column` VALUES ('162', '23', 'chat_id', '分配的群id', 'varchar(32)', 'String', 'chatId', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '2', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41');
INSERT INTO `gen_table_column` VALUES ('163', '23', 'new_owner', '新群主', 'varchar(32)', 'String', 'newOwner', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '3', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41');
INSERT INTO `gen_table_column` VALUES ('164', '23', 'old_owner', '原群主', 'varchar(32)', 'String', 'oldOwner', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '4', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41');
INSERT INTO `gen_table_column` VALUES ('165', '23', 'allocate_time', '分配时间', 'datetime', 'Date', 'allocateTime', '0', '0', null, '1', '1', '1', '1', 'EQ', 'datetime', '', '5', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41');
INSERT INTO `gen_table_column` VALUES ('179', '25', 'message_push_id', '主键id', 'bigint(20)', 'Long', 'messagePushId', '1', '0', null, '1', null, null, null, 'EQ', 'input', '', '1', 'admin', '2020-10-28 13:58:22', '', null);
INSERT INTO `gen_table_column` VALUES ('180', '25', 'push_type', '群发类型 0 发给客户 1 发给客户群', 'int(1)', 'Integer', 'pushType', '0', '0', null, '1', '1', '1', '1', 'EQ', 'select', '', '2', 'admin', '2020-10-28 13:58:22', '', null);
INSERT INTO `gen_table_column` VALUES ('181', '25', 'message_type', '消息类型 0 文本消息  1 图片消息 2 语音消息  3 视频消息    4 文件消息 5 文本卡片消息 6 图文消息\r\n7 图文消息（mpnews） 8 markdown消息 9 小程序通知消息 10 任务卡片消息', 'varchar(2)', 'String', 'messageType', '0', '0', null, '1', '1', '1', '1', 'EQ', 'select', '', '3', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('182', '25', 'to_user', '指定接收消息的成员', 'varchar(1000)', 'String', 'toUser', '0', '0', null, '1', '1', '1', '1', 'EQ', 'textarea', '', '4', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('183', '25', 'to_party', '指定接收消息的部门', 'varchar(255)', 'String', 'toParty', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '5', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('184', '25', 'to_tag', '指定接收消息的标签', 'varchar(255)', 'String', 'toTag', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '6', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('185', '25', 'message_json', '消息体', 'text', 'String', 'messageJson', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '7', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('186', '25', 'push_range', '消息范围 0 全部客户  1 指定客户', 'varchar(1)', 'String', 'pushRange', '0', '0', null, '1', '1', '1', '1', 'EQ', 'input', '', '8', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('187', '25', 'create_by', null, 'varchar(64)', 'String', 'createBy', '0', '0', null, '1', null, null, null, 'EQ', 'input', '', '9', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('188', '25', 'create_time', null, 'datetime', 'Date', 'createTime', '0', '0', null, '1', null, null, null, 'EQ', 'datetime', '', '10', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('189', '25', 'update_by', null, 'varchar(64)', 'String', 'updateBy', '0', '0', null, '1', '1', null, null, 'EQ', 'input', '', '11', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('190', '25', 'update_time', null, 'datetime', 'Date', 'updateTime', '0', '0', null, '1', '1', null, null, 'EQ', 'datetime', '', '12', 'admin', '2020-10-28 13:58:23', '', null);
INSERT INTO `gen_table_column` VALUES ('191', '25', 'del_flag', '0 未删除 1 已删除', 'int(1)', 'Integer', 'delFlag', '0', '0', null, '1', null, null, null, 'EQ', 'input', '', '13', 'admin', '2020-10-28 13:58:23', '', null);

-- ----------------------------
-- Table structure for QRTZ_BLOB_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;
CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `blob_data` blob,
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_BLOB_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CALENDARS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CALENDARS`;
CREATE TABLE `QRTZ_CALENDARS` (
  `sched_name` varchar(120) NOT NULL,
  `calendar_name` varchar(200) NOT NULL,
  `calendar` blob NOT NULL,
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_CALENDARS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_CRON_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;
CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `cron_expression` varchar(200) NOT NULL,
  `time_zone_id` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_CRON_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_CRON_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', '0/10 * * * * ?', 'Asia/Shanghai');
INSERT INTO `QRTZ_CRON_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', '0/15 * * * * ?', 'Asia/Shanghai');
INSERT INTO `QRTZ_CRON_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', '0/20 * * * * ?', 'Asia/Shanghai');

-- ----------------------------
-- Table structure for QRTZ_FIRED_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;
CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `entry_id` varchar(95) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `instance_name` varchar(200) NOT NULL,
  `fired_time` bigint(13) NOT NULL,
  `sched_time` bigint(13) NOT NULL,
  `priority` int(11) NOT NULL,
  `state` varchar(16) NOT NULL,
  `job_name` varchar(200) DEFAULT NULL,
  `job_group` varchar(200) DEFAULT NULL,
  `is_nonconcurrent` varchar(1) DEFAULT NULL,
  `requests_recovery` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_FIRED_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_JOB_DETAILS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;
CREATE TABLE `QRTZ_JOB_DETAILS` (
  `sched_name` varchar(120) NOT NULL,
  `job_name` varchar(200) NOT NULL,
  `job_group` varchar(200) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  `job_class_name` varchar(250) NOT NULL,
  `is_durable` varchar(1) NOT NULL,
  `is_nonconcurrent` varchar(1) NOT NULL,
  `is_update_data` varchar(1) NOT NULL,
  `requests_recovery` varchar(1) NOT NULL,
  `job_data` blob,
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_JOB_DETAILS
-- ----------------------------
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F770800000175A8571CBC787400013174000E302F3130202A202A202A202A203F74001172795461736B2E72794E6F506172616D7374000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000001740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E697A0E58F82EFBC8974000133740001317800);
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F770800000175A8571CBD787400013174000E302F3135202A202A202A202A203F74001572795461736B2E7279506172616D7328277279272974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000002740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E69C89E58F82EFBC8974000133740001317800);
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F770800000175A8571CBD787400013174000E302F3230202A202A202A202A203F74003872795461736B2E72794D756C7469706C65506172616D7328277279272C20747275652C20323030304C2C203331362E3530442C203130302974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000003740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E5A49AE58F82EFBC8974000133740001317800);

-- ----------------------------
-- Table structure for QRTZ_LOCKS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_LOCKS`;
CREATE TABLE `QRTZ_LOCKS` (
  `sched_name` varchar(120) NOT NULL,
  `lock_name` varchar(40) NOT NULL,
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_LOCKS
-- ----------------------------
INSERT INTO `QRTZ_LOCKS` VALUES ('RuoyiScheduler', 'STATE_ACCESS');
INSERT INTO `QRTZ_LOCKS` VALUES ('RuoyiScheduler', 'TRIGGER_ACCESS');

-- ----------------------------
-- Table structure for QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_PAUSED_TRIGGER_GRPS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SCHEDULER_STATE
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;
CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `sched_name` varchar(120) NOT NULL,
  `instance_name` varchar(200) NOT NULL,
  `last_checkin_time` bigint(13) NOT NULL,
  `checkin_interval` bigint(13) NOT NULL,
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_SCHEDULER_STATE
-- ----------------------------
INSERT INTO `QRTZ_SCHEDULER_STATE` VALUES ('RuoyiScheduler', 'instance-t01a0gzc1604500988537', '1604847111072', '15000');
INSERT INTO `QRTZ_SCHEDULER_STATE` VALUES ('RuoyiScheduler', 'K7KEKXVIOKB87SK1604847082459', '1604847116686', '15000');

-- ----------------------------
-- Table structure for QRTZ_SIMPLE_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `repeat_count` bigint(7) NOT NULL,
  `repeat_interval` bigint(12) NOT NULL,
  `times_triggered` bigint(10) NOT NULL,
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_SIMPLE_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_SIMPROP_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;
CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `str_prop_1` varchar(512) DEFAULT NULL,
  `str_prop_2` varchar(512) DEFAULT NULL,
  `str_prop_3` varchar(512) DEFAULT NULL,
  `int_prop_1` int(11) DEFAULT NULL,
  `int_prop_2` int(11) DEFAULT NULL,
  `long_prop_1` bigint(20) DEFAULT NULL,
  `long_prop_2` bigint(20) DEFAULT NULL,
  `dec_prop_1` decimal(13,4) DEFAULT NULL,
  `dec_prop_2` decimal(13,4) DEFAULT NULL,
  `bool_prop_1` varchar(1) DEFAULT NULL,
  `bool_prop_2` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `QRTZ_TRIGGERS` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_SIMPROP_TRIGGERS
-- ----------------------------

-- ----------------------------
-- Table structure for QRTZ_TRIGGERS
-- ----------------------------
DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;
CREATE TABLE `QRTZ_TRIGGERS` (
  `sched_name` varchar(120) NOT NULL,
  `trigger_name` varchar(200) NOT NULL,
  `trigger_group` varchar(200) NOT NULL,
  `job_name` varchar(200) NOT NULL,
  `job_group` varchar(200) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  `next_fire_time` bigint(13) DEFAULT NULL,
  `prev_fire_time` bigint(13) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `trigger_state` varchar(16) NOT NULL,
  `trigger_type` varchar(8) NOT NULL,
  `start_time` bigint(13) NOT NULL,
  `end_time` bigint(13) DEFAULT NULL,
  `calendar_name` varchar(200) DEFAULT NULL,
  `misfire_instr` smallint(2) DEFAULT NULL,
  `job_data` blob,
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `QRTZ_JOB_DETAILS` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of QRTZ_TRIGGERS
-- ----------------------------
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', 'TASK_CLASS_NAME1', 'DEFAULT', null, '1604847090000', '-1', '5', 'PAUSED', 'CRON', '1604847082000', '0', null, '2', '');
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', 'TASK_CLASS_NAME2', 'DEFAULT', null, '1604847090000', '-1', '5', 'PAUSED', 'CRON', '1604847083000', '0', null, '2', '');
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', 'TASK_CLASS_NAME3', 'DEFAULT', null, '1604847100000', '-1', '5', 'PAUSED', 'CRON', '1604847083000', '0', null, '2', '');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES ('1', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES ('2', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '初始化密码 123456');
INSERT INTO `sys_config` VALUES ('3', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '深色主题theme-dark，浅色主题theme-light');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES ('100', '0', '0', '若依科技', '0', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('101', '100', '0,100', '深圳总公司', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('102', '100', '0,100', '长沙分公司', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('103', '101', '0,100,101', '研发部门', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('104', '101', '0,100,101', '市场部门', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('105', '101', '0,100,101', '测试部门', '3', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('106', '101', '0,100,101', '财务部门', '4', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('107', '101', '0,100,101', '运维部门', '5', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('108', '102', '0,100,102', '市场部门', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');
INSERT INTO `sys_dept` VALUES ('109', '102', '0,100,102', '财务部门', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(11) DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES ('1', '1', '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '性别男');
INSERT INTO `sys_dict_data` VALUES ('2', '2', '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '性别女');
INSERT INTO `sys_dict_data` VALUES ('3', '3', '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '性别未知');
INSERT INTO `sys_dict_data` VALUES ('4', '1', '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '显示菜单');
INSERT INTO `sys_dict_data` VALUES ('5', '2', '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES ('6', '1', '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '正常状态');
INSERT INTO `sys_dict_data` VALUES ('7', '2', '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '停用状态');
INSERT INTO `sys_dict_data` VALUES ('8', '1', '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '正常状态');
INSERT INTO `sys_dict_data` VALUES ('9', '2', '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '停用状态');
INSERT INTO `sys_dict_data` VALUES ('10', '1', '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '默认分组');
INSERT INTO `sys_dict_data` VALUES ('11', '2', '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统分组');
INSERT INTO `sys_dict_data` VALUES ('12', '1', '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统默认是');
INSERT INTO `sys_dict_data` VALUES ('13', '2', '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统默认否');
INSERT INTO `sys_dict_data` VALUES ('14', '1', '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '通知');
INSERT INTO `sys_dict_data` VALUES ('15', '2', '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '公告');
INSERT INTO `sys_dict_data` VALUES ('16', '1', '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '正常状态');
INSERT INTO `sys_dict_data` VALUES ('17', '2', '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '关闭状态');
INSERT INTO `sys_dict_data` VALUES ('18', '1', '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '新增操作');
INSERT INTO `sys_dict_data` VALUES ('19', '2', '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '修改操作');
INSERT INTO `sys_dict_data` VALUES ('20', '3', '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '删除操作');
INSERT INTO `sys_dict_data` VALUES ('21', '4', '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '授权操作');
INSERT INTO `sys_dict_data` VALUES ('22', '5', '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '导出操作');
INSERT INTO `sys_dict_data` VALUES ('23', '6', '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '导入操作');
INSERT INTO `sys_dict_data` VALUES ('24', '7', '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '强退操作');
INSERT INTO `sys_dict_data` VALUES ('25', '8', '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '生成操作');
INSERT INTO `sys_dict_data` VALUES ('26', '9', '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '清空操作');
INSERT INTO `sys_dict_data` VALUES ('27', '1', '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '正常状态');
INSERT INTO `sys_dict_data` VALUES ('28', '2', '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES ('1', '用户性别', 'sys_user_sex', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '用户性别列表');
INSERT INTO `sys_dict_type` VALUES ('2', '菜单状态', 'sys_show_hide', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES ('3', '系统开关', 'sys_normal_disable', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统开关列表');
INSERT INTO `sys_dict_type` VALUES ('4', '任务状态', 'sys_job_status', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '任务状态列表');
INSERT INTO `sys_dict_type` VALUES ('5', '任务分组', 'sys_job_group', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '任务分组列表');
INSERT INTO `sys_dict_type` VALUES ('6', '系统是否', 'sys_yes_no', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统是否列表');
INSERT INTO `sys_dict_type` VALUES ('7', '通知类型', 'sys_notice_type', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '通知类型列表');
INSERT INTO `sys_dict_type` VALUES ('8', '通知状态', 'sys_notice_status', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '通知状态列表');
INSERT INTO `sys_dict_type` VALUES ('9', '操作类型', 'sys_oper_type', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '操作类型列表');
INSERT INTO `sys_dict_type` VALUES ('10', '系统状态', 'sys_common_status', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='定时任务调度表';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES ('1', '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_job` VALUES ('2', '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_job` VALUES ('3', '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='定时任务调度日志表';

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(50) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1388 DEFAULT CHARSET=utf8mb4 COMMENT='系统访问记录';

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES ('443', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:22:19');
INSERT INTO `sys_logininfor` VALUES ('444', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:23:24');
INSERT INTO `sys_logininfor` VALUES ('445', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:23:34');
INSERT INTO `sys_logininfor` VALUES ('446', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:23:47');
INSERT INTO `sys_logininfor` VALUES ('447', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:23:52');
INSERT INTO `sys_logininfor` VALUES ('448', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:24:25');
INSERT INTO `sys_logininfor` VALUES ('449', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:24:32');
INSERT INTO `sys_logininfor` VALUES ('450', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:25:12');
INSERT INTO `sys_logininfor` VALUES ('451', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:25:18');
INSERT INTO `sys_logininfor` VALUES ('452', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-28 07:30:22');
INSERT INTO `sys_logininfor` VALUES ('453', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '退出成功', '2020-10-28 07:31:27');
INSERT INTO `sys_logininfor` VALUES ('454', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-28 07:31:34');
INSERT INTO `sys_logininfor` VALUES ('455', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:31:53');
INSERT INTO `sys_logininfor` VALUES ('456', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:31:59');
INSERT INTO `sys_logininfor` VALUES ('457', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:32:37');
INSERT INTO `sys_logininfor` VALUES ('458', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:32:48');
INSERT INTO `sys_logininfor` VALUES ('459', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:40:23');
INSERT INTO `sys_logininfor` VALUES ('460', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 07:41:08');
INSERT INTO `sys_logininfor` VALUES ('461', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 07:41:13');
INSERT INTO `sys_logininfor` VALUES ('462', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 09:21:45');
INSERT INTO `sys_logininfor` VALUES ('463', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 09:36:18');
INSERT INTO `sys_logininfor` VALUES ('464', 'admin', '223.244.118.197', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 10:54:05');
INSERT INTO `sys_logininfor` VALUES ('465', 'admin', '183.160.214.53', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 12:30:02');
INSERT INTO `sys_logininfor` VALUES ('466', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 12:51:26');
INSERT INTO `sys_logininfor` VALUES ('467', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 13:40:28');
INSERT INTO `sys_logininfor` VALUES ('468', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 14:35:13');
INSERT INTO `sys_logininfor` VALUES ('469', 'admin', '183.160.225.219', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 14:55:05');
INSERT INTO `sys_logininfor` VALUES ('470', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 15:06:33');
INSERT INTO `sys_logininfor` VALUES ('471', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-10-28 15:15:58');
INSERT INTO `sys_logininfor` VALUES ('472', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 15:16:01');
INSERT INTO `sys_logininfor` VALUES ('473', 'admin', '114.100.66.114', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-28 15:22:31');
INSERT INTO `sys_logininfor` VALUES ('474', 'admin', '180.161.100.81', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-28 15:26:30');
INSERT INTO `sys_logininfor` VALUES ('475', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 15:26:30');
INSERT INTO `sys_logininfor` VALUES ('476', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 15:26:39');
INSERT INTO `sys_logininfor` VALUES ('477', 'test', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 15:26:48');
INSERT INTO `sys_logininfor` VALUES ('478', 'test', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 15:26:56');
INSERT INTO `sys_logininfor` VALUES ('479', 'admin', '114.100.66.114', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '退出成功', '2020-10-28 15:50:38');
INSERT INTO `sys_logininfor` VALUES ('480', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-10-28 15:56:19');
INSERT INTO `sys_logininfor` VALUES ('481', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 15:56:23');
INSERT INTO `sys_logininfor` VALUES ('482', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-28 15:57:09');
INSERT INTO `sys_logininfor` VALUES ('483', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 15:57:18');
INSERT INTO `sys_logininfor` VALUES ('484', 'admin', '183.160.224.249', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-28 15:57:28');
INSERT INTO `sys_logininfor` VALUES ('485', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 16:27:35');
INSERT INTO `sys_logininfor` VALUES ('486', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 16:27:39');
INSERT INTO `sys_logininfor` VALUES ('487', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 16:27:46');
INSERT INTO `sys_logininfor` VALUES ('488', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码已失效', '2020-10-28 16:32:50');
INSERT INTO `sys_logininfor` VALUES ('489', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-28 16:32:54');
INSERT INTO `sys_logininfor` VALUES ('490', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-10-28 16:33:04');
INSERT INTO `sys_logininfor` VALUES ('491', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-28 16:33:08');
INSERT INTO `sys_logininfor` VALUES ('492', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 01:07:26');
INSERT INTO `sys_logininfor` VALUES ('493', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 01:07:31');
INSERT INTO `sys_logininfor` VALUES ('494', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 01:07:39');
INSERT INTO `sys_logininfor` VALUES ('495', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 01:07:52');
INSERT INTO `sys_logininfor` VALUES ('496', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-10-29 01:11:34');
INSERT INTO `sys_logininfor` VALUES ('497', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 01:11:40');
INSERT INTO `sys_logininfor` VALUES ('498', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 01:12:13');
INSERT INTO `sys_logininfor` VALUES ('499', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 01:12:21');
INSERT INTO `sys_logininfor` VALUES ('500', 'admin', '58.243.250.56', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 01:30:47');
INSERT INTO `sys_logininfor` VALUES ('501', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 01:32:21');
INSERT INTO `sys_logininfor` VALUES ('502', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '退出成功', '2020-10-29 01:47:38');
INSERT INTO `sys_logininfor` VALUES ('503', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 01:47:51');
INSERT INTO `sys_logininfor` VALUES ('504', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 01:58:40');
INSERT INTO `sys_logininfor` VALUES ('505', 'test', '222.185.238.221', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 01:59:12');
INSERT INTO `sys_logininfor` VALUES ('506', 'test', '183.14.132.205', 'XX XX', 'Chrome 39', 'Windows 7', '0', '登录成功', '2020-10-29 01:59:17');
INSERT INTO `sys_logininfor` VALUES ('507', 'test', '183.14.132.205', 'XX XX', 'Chrome', 'Linux', '0', '登录成功', '2020-10-29 01:59:38');
INSERT INTO `sys_logininfor` VALUES ('508', 'test', '112.64.119.240', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-29 01:59:55');
INSERT INTO `sys_logininfor` VALUES ('509', 'test', '27.8.44.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 02:00:21');
INSERT INTO `sys_logininfor` VALUES ('510', 'test', '110.81.248.7', 'XX XX', 'Internet Explorer 11', 'Windows 7', '0', '登录成功', '2020-10-29 02:00:22');
INSERT INTO `sys_logininfor` VALUES ('511', 'test', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '退出成功', '2020-10-29 02:00:41');
INSERT INTO `sys_logininfor` VALUES ('512', 'test', '49.80.249.162', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 02:00:42');
INSERT INTO `sys_logininfor` VALUES ('513', 'test', '27.8.44.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-29 02:03:13');
INSERT INTO `sys_logininfor` VALUES ('514', 'test', '61.154.103.16', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-29 02:04:41');
INSERT INTO `sys_logininfor` VALUES ('515', 'admin', '58.243.250.56', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 02:06:46');
INSERT INTO `sys_logininfor` VALUES ('516', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 02:07:29');
INSERT INTO `sys_logininfor` VALUES ('517', 'test', '113.76.111.225', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 02:11:31');
INSERT INTO `sys_logininfor` VALUES ('518', 'test', '220.195.67.63', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-29 02:12:35');
INSERT INTO `sys_logininfor` VALUES ('519', 'test', '116.249.73.88', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 02:13:05');
INSERT INTO `sys_logininfor` VALUES ('520', 'admin', '183.160.214.15', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 02:21:09');
INSERT INTO `sys_logininfor` VALUES ('521', 'test', '124.74.132.218', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 02:26:06');
INSERT INTO `sys_logininfor` VALUES ('522', 'test', '27.42.109.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 02:27:05');
INSERT INTO `sys_logininfor` VALUES ('523', 'test', '43.243.136.106', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 02:34:39');
INSERT INTO `sys_logininfor` VALUES ('524', 'test', '115.60.147.40', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 02:35:06');
INSERT INTO `sys_logininfor` VALUES ('525', 'test', '222.173.28.150', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 02:38:17');
INSERT INTO `sys_logininfor` VALUES ('526', 'test', '171.15.105.52', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 03:17:18');
INSERT INTO `sys_logininfor` VALUES ('527', 'test', '210.22.133.173', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 03:17:26');
INSERT INTO `sys_logininfor` VALUES ('528', 'test', '210.22.133.173', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 03:17:32');
INSERT INTO `sys_logininfor` VALUES ('529', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '1', '验证码错误', '2020-10-29 03:19:17');
INSERT INTO `sys_logininfor` VALUES ('530', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-29 03:19:24');
INSERT INTO `sys_logininfor` VALUES ('531', 'test', '120.197.59.234', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-29 03:23:32');
INSERT INTO `sys_logininfor` VALUES ('532', 'test', '120.197.59.234', 'XX XX', 'Safari', 'Mac OS X', '0', '退出成功', '2020-10-29 03:24:28');
INSERT INTO `sys_logininfor` VALUES ('533', 'test', '175.12.242.92', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 03:35:42');
INSERT INTO `sys_logininfor` VALUES ('534', 'test', '59.46.232.120', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 03:57:57');
INSERT INTO `sys_logininfor` VALUES ('535', 'test', '175.162.9.177', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 04:23:23');
INSERT INTO `sys_logininfor` VALUES ('536', 'admin', '123.232.37.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 05:08:25');
INSERT INTO `sys_logininfor` VALUES ('537', 'admin', '123.232.37.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 05:08:36');
INSERT INTO `sys_logininfor` VALUES ('538', 'test', '123.232.37.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 05:09:54');
INSERT INTO `sys_logininfor` VALUES ('539', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-29 05:45:38');
INSERT INTO `sys_logininfor` VALUES ('540', 'admin', '183.66.41.34', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 05:47:42');
INSERT INTO `sys_logininfor` VALUES ('541', 'test', '114.217.138.78', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 05:49:03');
INSERT INTO `sys_logininfor` VALUES ('542', 'test', '116.231.179.170', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 06:01:24');
INSERT INTO `sys_logininfor` VALUES ('543', 'test', '116.54.77.172', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 06:17:18');
INSERT INTO `sys_logininfor` VALUES ('544', 'test', '111.205.198.3', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 06:23:20');
INSERT INTO `sys_logininfor` VALUES ('545', 'test', '183.162.30.86', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 06:39:29');
INSERT INTO `sys_logininfor` VALUES ('546', 'test', '218.18.152.98', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 06:52:04');
INSERT INTO `sys_logininfor` VALUES ('547', 'test', '61.144.97.187', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-29 06:59:38');
INSERT INTO `sys_logininfor` VALUES ('548', 'test', '116.113.71.222', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:07:00');
INSERT INTO `sys_logininfor` VALUES ('549', 'test', '115.60.189.47', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-10-29 07:07:32');
INSERT INTO `sys_logininfor` VALUES ('550', 'admin', '14.18.190.194', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 07:16:44');
INSERT INTO `sys_logininfor` VALUES ('551', 'admin', '14.18.190.194', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 07:16:50');
INSERT INTO `sys_logininfor` VALUES ('552', 'admin', '14.18.190.194', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 07:16:56');
INSERT INTO `sys_logininfor` VALUES ('553', 'test', '222.185.62.142', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 07:17:05');
INSERT INTO `sys_logininfor` VALUES ('554', 'test', '222.222.64.111', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 07:20:10');
INSERT INTO `sys_logininfor` VALUES ('555', 'admin', '103.38.233.19', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 07:21:26');
INSERT INTO `sys_logininfor` VALUES ('556', 'admin', '103.38.233.19', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 07:21:35');
INSERT INTO `sys_logininfor` VALUES ('557', 'admin', '103.38.233.19', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 07:21:42');
INSERT INTO `sys_logininfor` VALUES ('558', 'test', '101.85.202.186', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:23:13');
INSERT INTO `sys_logininfor` VALUES ('559', 'test', '103.38.233.19', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:33:24');
INSERT INTO `sys_logininfor` VALUES ('560', 'test', '221.238.143.170', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 07:49:13');
INSERT INTO `sys_logininfor` VALUES ('561', 'test', '221.238.143.170', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:49:24');
INSERT INTO `sys_logininfor` VALUES ('562', 'test', '180.169.76.210', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:49:34');
INSERT INTO `sys_logininfor` VALUES ('563', 'admin', '122.235.241.170', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 07:53:03');
INSERT INTO `sys_logininfor` VALUES ('564', 'test', '183.234.184.135', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:54:36');
INSERT INTO `sys_logininfor` VALUES ('565', 'test', '122.235.241.170', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 07:54:45');
INSERT INTO `sys_logininfor` VALUES ('566', 'admin', '14.105.34.83', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 08:11:13');
INSERT INTO `sys_logininfor` VALUES ('567', 'admin', '14.105.34.83', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 08:11:25');
INSERT INTO `sys_logininfor` VALUES ('568', 'test', '116.54.77.172', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 08:16:44');
INSERT INTO `sys_logininfor` VALUES ('569', 'test', '210.22.163.214', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-29 08:20:17');
INSERT INTO `sys_logininfor` VALUES ('570', 'test', '210.22.163.214', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 08:20:20');
INSERT INTO `sys_logininfor` VALUES ('571', 'test', '180.212.65.152', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 08:30:46');
INSERT INTO `sys_logininfor` VALUES ('572', 'test', '218.13.14.220', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 08:35:37');
INSERT INTO `sys_logininfor` VALUES ('573', 'test', '183.160.104.245', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 08:40:20');
INSERT INTO `sys_logininfor` VALUES ('574', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 08:54:39');
INSERT INTO `sys_logininfor` VALUES ('575', 'test', '14.23.152.194', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 08:55:20');
INSERT INTO `sys_logininfor` VALUES ('576', 'test', '171.221.227.116', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 09:00:27');
INSERT INTO `sys_logininfor` VALUES ('577', 'test', '116.236.235.50', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 09:01:13');
INSERT INTO `sys_logininfor` VALUES ('578', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 09:01:40');
INSERT INTO `sys_logininfor` VALUES ('579', 'test', '117.22.144.100', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 09:17:18');
INSERT INTO `sys_logininfor` VALUES ('580', 'test', '14.23.157.66', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 09:41:54');
INSERT INTO `sys_logininfor` VALUES ('581', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-29 09:52:47');
INSERT INTO `sys_logininfor` VALUES ('582', 'admin', '36.5.155.87', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 09:52:55');
INSERT INTO `sys_logininfor` VALUES ('583', 'test', '115.195.128.177', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 09:54:18');
INSERT INTO `sys_logininfor` VALUES ('584', 'test', '115.195.128.177', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-29 09:55:00');
INSERT INTO `sys_logininfor` VALUES ('585', 'test', '183.222.135.66', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 09:55:13');
INSERT INTO `sys_logininfor` VALUES ('586', 'test', '1.83.232.155', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-10-29 10:02:13');
INSERT INTO `sys_logininfor` VALUES ('587', 'test', '106.121.10.4', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 10:15:34');
INSERT INTO `sys_logininfor` VALUES ('588', 'test', '106.121.10.4', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-29 10:15:47');
INSERT INTO `sys_logininfor` VALUES ('589', 'test', '106.121.10.4', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 10:16:47');
INSERT INTO `sys_logininfor` VALUES ('590', 'test', '58.48.177.106', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-29 11:03:18');
INSERT INTO `sys_logininfor` VALUES ('591', 'test', '171.221.129.34', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 11:08:36');
INSERT INTO `sys_logininfor` VALUES ('592', 'test', '110.184.30.254', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 11:10:06');
INSERT INTO `sys_logininfor` VALUES ('593', 'test', '121.37.50.176', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 11:25:02');
INSERT INTO `sys_logininfor` VALUES ('594', 'test', '223.72.71.128', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-29 11:32:48');
INSERT INTO `sys_logininfor` VALUES ('595', 'test', '124.65.65.190', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 11:44:37');
INSERT INTO `sys_logininfor` VALUES ('596', 'test', '36.5.72.26', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 14:09:37');
INSERT INTO `sys_logininfor` VALUES ('597', 'test', '112.115.151.1', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-10-29 14:33:11');
INSERT INTO `sys_logininfor` VALUES ('598', 'admin', '112.32.119.147', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 14:47:25');
INSERT INTO `sys_logininfor` VALUES ('599', 'admin', '223.244.118.93', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 14:48:16');
INSERT INTO `sys_logininfor` VALUES ('600', 'test', '171.91.65.35', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 14:51:40');
INSERT INTO `sys_logininfor` VALUES ('601', 'test', '111.192.105.80', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-29 15:23:33');
INSERT INTO `sys_logininfor` VALUES ('602', 'test', '183.222.23.250', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 15:46:10');
INSERT INTO `sys_logininfor` VALUES ('603', 'test', '125.120.21.0', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 15:48:27');
INSERT INTO `sys_logininfor` VALUES ('604', 'test', '119.126.30.24', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 16:00:11');
INSERT INTO `sys_logininfor` VALUES ('605', 'test', '183.160.24.171', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-29 16:20:49');
INSERT INTO `sys_logininfor` VALUES ('606', 'test', '114.82.36.80', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-29 16:38:18');
INSERT INTO `sys_logininfor` VALUES ('607', 'test', '120.235.14.86', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-29 17:14:25');
INSERT INTO `sys_logininfor` VALUES ('608', 'test', '119.130.161.126', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-10-29 18:59:27');
INSERT INTO `sys_logininfor` VALUES ('609', 'test', '120.244.14.5', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '验证码错误', '2020-10-30 00:11:52');
INSERT INTO `sys_logininfor` VALUES ('610', 'test', '120.244.14.5', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-30 00:11:58');
INSERT INTO `sys_logininfor` VALUES ('611', 'test', '120.244.14.5', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-30 00:15:27');
INSERT INTO `sys_logininfor` VALUES ('612', 'test', '36.158.33.233', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 01:05:39');
INSERT INTO `sys_logininfor` VALUES ('613', 'admin', '14.152.102.142', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-10-30 01:24:17');
INSERT INTO `sys_logininfor` VALUES ('614', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '验证码已失效', '2020-10-30 01:25:41');
INSERT INTO `sys_logininfor` VALUES ('615', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 01:26:15');
INSERT INTO `sys_logininfor` VALUES ('616', 'test', '14.152.102.142', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 01:27:51');
INSERT INTO `sys_logininfor` VALUES ('617', 'test', '1.80.146.92', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 01:31:29');
INSERT INTO `sys_logininfor` VALUES ('618', 'test', '14.25.132.147', 'XX XX', 'Chrome 8', 'Linux', '0', '登录成功', '2020-10-30 01:33:21');
INSERT INTO `sys_logininfor` VALUES ('619', 'test', '125.118.7.122', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 01:59:41');
INSERT INTO `sys_logininfor` VALUES ('620', 'test', '36.5.79.198', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-30 02:01:26');
INSERT INTO `sys_logininfor` VALUES ('621', 'test', '36.5.79.198', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 02:01:31');
INSERT INTO `sys_logininfor` VALUES ('622', 'admin', '183.239.241.164', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 02:04:04');
INSERT INTO `sys_logininfor` VALUES ('623', 'test', '119.139.136.241', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-10-30 02:11:21');
INSERT INTO `sys_logininfor` VALUES ('624', 'test', '119.139.136.241', 'XX XX', 'Chrome', 'Windows 7', '0', '退出成功', '2020-10-30 02:13:01');
INSERT INTO `sys_logininfor` VALUES ('625', 'admin', '119.139.136.241', 'XX XX', 'Chrome', 'Windows 7', '1', '用户不存在/密码错误', '2020-10-30 02:13:15');
INSERT INTO `sys_logininfor` VALUES ('626', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 02:13:38');
INSERT INTO `sys_logininfor` VALUES ('627', 'test', '27.8.44.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 02:16:32');
INSERT INTO `sys_logininfor` VALUES ('628', 'test', '140.243.194.10', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-30 02:33:57');
INSERT INTO `sys_logininfor` VALUES ('629', 'test', '219.136.99.4', 'XX XX', 'Chrome 8', 'Linux', '0', '登录成功', '2020-10-30 02:43:01');
INSERT INTO `sys_logininfor` VALUES ('630', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '验证码已失效', '2020-10-30 02:50:19');
INSERT INTO `sys_logininfor` VALUES ('631', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 02:50:23');
INSERT INTO `sys_logininfor` VALUES ('632', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '退出成功', '2020-10-30 02:52:40');
INSERT INTO `sys_logininfor` VALUES ('633', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 02:52:55');
INSERT INTO `sys_logininfor` VALUES ('634', 'test', '111.18.38.234', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-10-30 03:09:12');
INSERT INTO `sys_logininfor` VALUES ('635', 'admin', '113.111.48.133', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 03:20:22');
INSERT INTO `sys_logininfor` VALUES ('636', 'test', '113.111.48.133', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 03:20:39');
INSERT INTO `sys_logininfor` VALUES ('637', 'test', '119.131.182.28', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 03:43:41');
INSERT INTO `sys_logininfor` VALUES ('638', 'test', '222.91.148.58', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 03:49:28');
INSERT INTO `sys_logininfor` VALUES ('639', 'test', '113.119.166.145', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 03:50:31');
INSERT INTO `sys_logininfor` VALUES ('640', 'test', '117.30.115.103', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 04:37:42');
INSERT INTO `sys_logininfor` VALUES ('641', 'test', '183.245.96.197', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 04:50:35');
INSERT INTO `sys_logininfor` VALUES ('642', 'test', '219.133.68.193', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 05:36:31');
INSERT INTO `sys_logininfor` VALUES ('643', 'test', '210.21.61.126', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 05:40:39');
INSERT INTO `sys_logininfor` VALUES ('644', 'test', '123.233.244.178', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 06:03:44');
INSERT INTO `sys_logininfor` VALUES ('645', 'test', '123.233.244.178', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-30 06:05:05');
INSERT INTO `sys_logininfor` VALUES ('646', 'admin', '43.224.44.125', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 06:09:13');
INSERT INTO `sys_logininfor` VALUES ('647', 'admin', '218.29.67.194', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 06:20:27');
INSERT INTO `sys_logininfor` VALUES ('648', 'test', '218.29.67.194', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 06:20:46');
INSERT INTO `sys_logininfor` VALUES ('649', 'test', '116.232.110.119', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 06:27:45');
INSERT INTO `sys_logininfor` VALUES ('650', 'test', '61.166.168.154', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 06:43:20');
INSERT INTO `sys_logininfor` VALUES ('651', 'test', '36.110.108.59', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 06:44:46');
INSERT INTO `sys_logininfor` VALUES ('652', 'test', '111.163.45.90', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-30 06:48:52');
INSERT INTO `sys_logininfor` VALUES ('653', 'test', '59.52.8.220', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-10-30 07:08:10');
INSERT INTO `sys_logininfor` VALUES ('654', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-30 07:08:36');
INSERT INTO `sys_logininfor` VALUES ('655', 'test', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 07:26:41');
INSERT INTO `sys_logininfor` VALUES ('656', 'test', '60.30.184.232', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 07:38:04');
INSERT INTO `sys_logininfor` VALUES ('657', 'test', '112.230.206.18', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-30 07:43:55');
INSERT INTO `sys_logininfor` VALUES ('658', 'admin', '123.52.249.127', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 07:48:17');
INSERT INTO `sys_logininfor` VALUES ('659', 'admin', '123.52.249.127', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-10-30 07:48:33');
INSERT INTO `sys_logininfor` VALUES ('660', 'test', '123.52.249.127', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 07:54:06');
INSERT INTO `sys_logininfor` VALUES ('661', 'test', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-30 07:55:10');
INSERT INTO `sys_logininfor` VALUES ('662', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 07:55:22');
INSERT INTO `sys_logininfor` VALUES ('663', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:00:29');
INSERT INTO `sys_logininfor` VALUES ('664', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:00:46');
INSERT INTO `sys_logininfor` VALUES ('665', 'test', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:00:58');
INSERT INTO `sys_logininfor` VALUES ('666', 'test', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-30 08:04:42');
INSERT INTO `sys_logininfor` VALUES ('667', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:04:57');
INSERT INTO `sys_logininfor` VALUES ('668', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:05:05');
INSERT INTO `sys_logininfor` VALUES ('669', 'test', '117.136.30.212', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-30 08:05:12');
INSERT INTO `sys_logininfor` VALUES ('670', 'admin', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:05:16');
INSERT INTO `sys_logininfor` VALUES ('671', 'test', '111.163.45.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:05:40');
INSERT INTO `sys_logininfor` VALUES ('672', 'admin', '113.116.49.137', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-10-30 08:10:38');
INSERT INTO `sys_logininfor` VALUES ('673', 'admin', '113.116.49.137', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:10:42');
INSERT INTO `sys_logininfor` VALUES ('674', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:13:17');
INSERT INTO `sys_logininfor` VALUES ('675', 'test', '106.92.241.79', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 08:13:27');
INSERT INTO `sys_logininfor` VALUES ('676', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-10-30 08:14:01');
INSERT INTO `sys_logininfor` VALUES ('677', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:14:06');
INSERT INTO `sys_logininfor` VALUES ('678', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:14:16');
INSERT INTO `sys_logininfor` VALUES ('679', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:14:20');
INSERT INTO `sys_logininfor` VALUES ('680', 'admin', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:14:39');
INSERT INTO `sys_logininfor` VALUES ('681', 'test', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:15:11');
INSERT INTO `sys_logininfor` VALUES ('682', 'test', '221.234.230.9', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:16:56');
INSERT INTO `sys_logininfor` VALUES ('683', 'admin', '110.87.57.227', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 08:26:16');
INSERT INTO `sys_logininfor` VALUES ('684', 'admin', '36.5.79.198', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:37:58');
INSERT INTO `sys_logininfor` VALUES ('685', 'test', '27.223.78.164', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 08:43:01');
INSERT INTO `sys_logininfor` VALUES ('686', 'test', '36.7.122.204', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 08:43:04');
INSERT INTO `sys_logininfor` VALUES ('687', 'test', '116.236.235.50', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 09:09:14');
INSERT INTO `sys_logininfor` VALUES ('688', 'test', '103.216.43.122', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 09:10:12');
INSERT INTO `sys_logininfor` VALUES ('689', 'test', '219.153.164.185', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-30 09:37:33');
INSERT INTO `sys_logininfor` VALUES ('690', 'test', '210.13.87.178', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 09:48:54');
INSERT INTO `sys_logininfor` VALUES ('691', 'test', '180.168.111.1', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 10:01:05');
INSERT INTO `sys_logininfor` VALUES ('692', 'test', '180.168.111.1', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-10-30 10:02:53');
INSERT INTO `sys_logininfor` VALUES ('693', 'admin', '180.168.111.1', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-30 10:03:05');
INSERT INTO `sys_logininfor` VALUES ('694', 'test', '124.133.247.59', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-10-30 10:32:01');
INSERT INTO `sys_logininfor` VALUES ('695', 'test', '101.224.69.132', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 10:46:58');
INSERT INTO `sys_logininfor` VALUES ('696', 'test', '114.139.161.84', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-30 11:35:29');
INSERT INTO `sys_logininfor` VALUES ('697', 'test', '58.213.209.78', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-30 12:43:50');
INSERT INTO `sys_logininfor` VALUES ('698', 'test', '120.229.64.218', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-10-30 12:53:42');
INSERT INTO `sys_logininfor` VALUES ('699', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-30 12:55:06');
INSERT INTO `sys_logininfor` VALUES ('700', 'test', '112.41.10.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-30 13:45:08');
INSERT INTO `sys_logininfor` VALUES ('701', 'test', '111.18.39.119', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-10-30 13:50:55');
INSERT INTO `sys_logininfor` VALUES ('702', 'test', '211.162.10.3', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-30 15:09:32');
INSERT INTO `sys_logininfor` VALUES ('703', 'test', '111.196.244.243', 'XX XX', 'Chrome Mobile', 'Mac OS X (iPad)', '0', '登录成功', '2020-10-30 15:45:16');
INSERT INTO `sys_logininfor` VALUES ('704', 'test', '117.136.41.29', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码已失效', '2020-10-30 16:03:42');
INSERT INTO `sys_logininfor` VALUES ('705', 'test', '117.136.41.29', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-10-30 16:03:49');
INSERT INTO `sys_logininfor` VALUES ('706', 'test', '117.89.143.51', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 17:45:45');
INSERT INTO `sys_logininfor` VALUES ('707', 'test', '183.15.175.86', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-30 19:25:14');
INSERT INTO `sys_logininfor` VALUES ('708', 'admin', '124.162.130.123', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 00:40:40');
INSERT INTO `sys_logininfor` VALUES ('709', 'admin', '124.162.130.123', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 00:40:49');
INSERT INTO `sys_logininfor` VALUES ('710', 'admin', '124.162.130.123', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 00:41:00');
INSERT INTO `sys_logininfor` VALUES ('711', 'test', '27.23.251.118', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-10-31 01:05:37');
INSERT INTO `sys_logininfor` VALUES ('712', 'test', '113.88.109.180', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-10-31 01:20:15');
INSERT INTO `sys_logininfor` VALUES ('713', 'test', '116.252.170.255', 'XX XX', 'Chrome 47', 'Windows 8.1', '0', '登录成功', '2020-10-31 01:26:31');
INSERT INTO `sys_logininfor` VALUES ('714', 'test', '123.196.254.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 01:48:03');
INSERT INTO `sys_logininfor` VALUES ('715', 'test', '183.198.73.239', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-31 02:22:38');
INSERT INTO `sys_logininfor` VALUES ('716', 'test', '115.192.67.246', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-10-31 02:31:09');
INSERT INTO `sys_logininfor` VALUES ('717', 'test', '116.227.132.124', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-31 02:55:40');
INSERT INTO `sys_logininfor` VALUES ('718', 'test', '223.73.185.183', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 03:24:03');
INSERT INTO `sys_logininfor` VALUES ('719', 'test', '218.16.63.107', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 04:31:40');
INSERT INTO `sys_logininfor` VALUES ('720', 'test', '117.188.18.22', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 05:00:04');
INSERT INTO `sys_logininfor` VALUES ('721', 'test', '125.86.178.195', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 05:42:08');
INSERT INTO `sys_logininfor` VALUES ('722', 'test', '14.118.216.93', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-31 05:59:50');
INSERT INTO `sys_logininfor` VALUES ('723', 'test', '106.83.136.152', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 06:23:48');
INSERT INTO `sys_logininfor` VALUES ('724', 'test', '106.83.136.152', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 06:24:04');
INSERT INTO `sys_logininfor` VALUES ('725', 'test', '218.81.241.163', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-31 06:27:55');
INSERT INTO `sys_logininfor` VALUES ('726', 'test', '103.230.213.229', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 06:31:52');
INSERT INTO `sys_logininfor` VALUES ('727', 'test', '112.65.61.128', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-31 06:53:04');
INSERT INTO `sys_logininfor` VALUES ('728', 'test', '114.102.147.214', 'XX XX', 'Chrome', 'Mac OS X', '0', '登录成功', '2020-10-31 07:27:26');
INSERT INTO `sys_logininfor` VALUES ('729', 'test', '113.118.117.62', 'XX XX', 'Firefox 8', 'Mac OS X', '0', '登录成功', '2020-10-31 07:30:16');
INSERT INTO `sys_logininfor` VALUES ('730', 'admin', '58.243.250.155', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 07:31:36');
INSERT INTO `sys_logininfor` VALUES ('731', 'test', '124.65.158.242', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-10-31 07:50:28');
INSERT INTO `sys_logininfor` VALUES ('732', 'test', '42.243.10.9', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-31 07:50:51');
INSERT INTO `sys_logininfor` VALUES ('733', 'test', '113.88.109.180', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-31 08:47:18');
INSERT INTO `sys_logininfor` VALUES ('734', 'test', '27.17.171.57', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 08:50:18');
INSERT INTO `sys_logininfor` VALUES ('735', 'test', '112.64.117.181', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 09:14:28');
INSERT INTO `sys_logininfor` VALUES ('736', 'test', '218.3.204.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 09:19:06');
INSERT INTO `sys_logininfor` VALUES ('737', 'admin', '116.54.59.183', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 09:50:08');
INSERT INTO `sys_logininfor` VALUES ('738', 'test', '117.150.22.42', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-31 10:30:20');
INSERT INTO `sys_logininfor` VALUES ('739', 'admin', '36.57.179.104', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2020-10-31 12:17:38');
INSERT INTO `sys_logininfor` VALUES ('740', 'admin', '36.57.179.104', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '验证码错误', '2020-10-31 12:17:41');
INSERT INTO `sys_logininfor` VALUES ('741', 'test', '223.66.228.158', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 12:27:28');
INSERT INTO `sys_logininfor` VALUES ('742', 'test', '180.97.242.237', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 13:16:20');
INSERT INTO `sys_logininfor` VALUES ('743', 'admin', '183.160.3.183', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '验证码已失效', '2020-10-31 13:27:10');
INSERT INTO `sys_logininfor` VALUES ('744', 'admin', '183.160.3.183', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-10-31 13:27:16');
INSERT INTO `sys_logininfor` VALUES ('745', 'admin', '223.246.116.178', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '验证码已失效', '2020-10-31 13:28:33');
INSERT INTO `sys_logininfor` VALUES ('746', 'admin', '223.246.116.178', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '用户不存在/密码错误', '2020-10-31 13:28:38');
INSERT INTO `sys_logininfor` VALUES ('747', 'test', '171.217.99.121', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-10-31 13:36:30');
INSERT INTO `sys_logininfor` VALUES ('748', 'admin', '220.115.68.173', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-10-31 13:43:36');
INSERT INTO `sys_logininfor` VALUES ('749', 'test', '180.165.46.186', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-10-31 15:10:52');
INSERT INTO `sys_logininfor` VALUES ('750', 'test', '114.100.113.248', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-10-31 15:58:19');
INSERT INTO `sys_logininfor` VALUES ('751', 'Test', '101.45.95.98', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-10-31 22:34:56');
INSERT INTO `sys_logininfor` VALUES ('752', 'test', '116.249.234.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 01:14:34');
INSERT INTO `sys_logininfor` VALUES ('753', 'test', '120.239.226.39', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 01:29:14');
INSERT INTO `sys_logininfor` VALUES ('754', 'admin', '219.145.81.165', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 05:17:09');
INSERT INTO `sys_logininfor` VALUES ('755', 'admin', '219.145.81.165', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 05:17:22');
INSERT INTO `sys_logininfor` VALUES ('756', 'test', '219.145.81.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 05:17:52');
INSERT INTO `sys_logininfor` VALUES ('757', 'admin', '183.160.224.26', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 05:37:17');
INSERT INTO `sys_logininfor` VALUES ('758', 'test', '183.160.224.26', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 05:55:43');
INSERT INTO `sys_logininfor` VALUES ('759', 'test', '183.160.224.26', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 05:55:47');
INSERT INTO `sys_logininfor` VALUES ('760', 'test', '118.123.37.142', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-01 06:14:25');
INSERT INTO `sys_logininfor` VALUES ('761', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 06:48:54');
INSERT INTO `sys_logininfor` VALUES ('762', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 06:49:44');
INSERT INTO `sys_logininfor` VALUES ('763', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 06:49:55');
INSERT INTO `sys_logininfor` VALUES ('764', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 06:50:03');
INSERT INTO `sys_logininfor` VALUES ('765', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 06:50:16');
INSERT INTO `sys_logininfor` VALUES ('766', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 07:06:21');
INSERT INTO `sys_logininfor` VALUES ('767', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:06:25');
INSERT INTO `sys_logininfor` VALUES ('768', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 07:08:13');
INSERT INTO `sys_logininfor` VALUES ('769', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:08:21');
INSERT INTO `sys_logininfor` VALUES ('770', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 07:08:32');
INSERT INTO `sys_logininfor` VALUES ('771', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 07:27:37');
INSERT INTO `sys_logininfor` VALUES ('772', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', null, '2020-11-01 07:27:41');
INSERT INTO `sys_logininfor` VALUES ('773', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', null, '2020-11-01 07:28:12');
INSERT INTO `sys_logininfor` VALUES ('774', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', null, '2020-11-01 07:28:52');
INSERT INTO `sys_logininfor` VALUES ('775', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 07:31:09');
INSERT INTO `sys_logininfor` VALUES ('776', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', null, '2020-11-01 07:32:35');
INSERT INTO `sys_logininfor` VALUES ('777', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:34:02');
INSERT INTO `sys_logininfor` VALUES ('778', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-01 07:34:53');
INSERT INTO `sys_logininfor` VALUES ('779', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:34:58');
INSERT INTO `sys_logininfor` VALUES ('780', '18158873850', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 07:35:09');
INSERT INTO `sys_logininfor` VALUES ('781', 'Kong', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 07:38:31');
INSERT INTO `sys_logininfor` VALUES ('782', 'Kong', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-01 07:38:41');
INSERT INTO `sys_logininfor` VALUES ('783', 'Kong', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:38:53');
INSERT INTO `sys_logininfor` VALUES ('784', 'Kong', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 07:51:29');
INSERT INTO `sys_logininfor` VALUES ('785', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 07:51:37');
INSERT INTO `sys_logininfor` VALUES ('786', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 07:51:42');
INSERT INTO `sys_logininfor` VALUES ('787', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:51:55');
INSERT INTO `sys_logininfor` VALUES ('788', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 07:53:56');
INSERT INTO `sys_logininfor` VALUES ('789', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 07:55:14');
INSERT INTO `sys_logininfor` VALUES ('790', 'test', '117.147.78.188', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-01 10:20:58');
INSERT INTO `sys_logininfor` VALUES ('791', 'test', '125.85.205.108', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 11:15:38');
INSERT INTO `sys_logininfor` VALUES ('792', 'admin', '222.190.63.247', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 11:52:15');
INSERT INTO `sys_logininfor` VALUES ('793', 'test', '222.190.63.247', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 11:52:45');
INSERT INTO `sys_logininfor` VALUES ('794', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 11:52:55');
INSERT INTO `sys_logininfor` VALUES ('795', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 11:53:00');
INSERT INTO `sys_logininfor` VALUES ('796', 'test', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 11:53:59');
INSERT INTO `sys_logininfor` VALUES ('797', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 11:54:06');
INSERT INTO `sys_logininfor` VALUES ('798', 'test', '116.30.192.71', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-01 11:59:33');
INSERT INTO `sys_logininfor` VALUES ('799', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 12:12:13');
INSERT INTO `sys_logininfor` VALUES ('800', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 12:51:37');
INSERT INTO `sys_logininfor` VALUES ('801', 'test', '111.192.102.99', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-01 12:57:59');
INSERT INTO `sys_logininfor` VALUES ('802', 'test', '112.103.17.94', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-01 13:33:23');
INSERT INTO `sys_logininfor` VALUES ('803', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-01 13:34:47');
INSERT INTO `sys_logininfor` VALUES ('804', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-01 13:47:43');
INSERT INTO `sys_logininfor` VALUES ('805', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 13:47:49');
INSERT INTO `sys_logininfor` VALUES ('806', 'admin', '183.160.3.183', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-01 15:32:18');
INSERT INTO `sys_logininfor` VALUES ('807', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 15:49:07');
INSERT INTO `sys_logininfor` VALUES ('808', 'test', '221.220.17.234', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-01 15:50:30');
INSERT INTO `sys_logininfor` VALUES ('809', 'test', '123.149.84.205', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 15:58:40');
INSERT INTO `sys_logininfor` VALUES ('810', 'test', '112.97.215.178', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-01 17:10:02');
INSERT INTO `sys_logininfor` VALUES ('811', 'test', '122.97.179.19', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 17:20:54');
INSERT INTO `sys_logininfor` VALUES ('812', 'test', '116.23.134.222', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 17:54:53');
INSERT INTO `sys_logininfor` VALUES ('813', 'test', '112.97.215.178', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-01 18:26:42');
INSERT INTO `sys_logininfor` VALUES ('814', 'admin', '114.221.63.70', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-01 20:30:52');
INSERT INTO `sys_logininfor` VALUES ('815', 'test', '114.221.63.70', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-01 20:31:10');
INSERT INTO `sys_logininfor` VALUES ('816', 'test', '125.35.85.226', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 00:58:47');
INSERT INTO `sys_logininfor` VALUES ('817', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-02 01:19:39');
INSERT INTO `sys_logininfor` VALUES ('818', 'test', '113.14.228.119', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 01:24:22');
INSERT INTO `sys_logininfor` VALUES ('819', 'admin', '183.14.31.36', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 01:28:42');
INSERT INTO `sys_logininfor` VALUES ('820', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '退出成功', '2020-11-02 01:30:42');
INSERT INTO `sys_logininfor` VALUES ('821', 'admin', '111.85.36.252', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 01:42:14');
INSERT INTO `sys_logininfor` VALUES ('822', 'test', '27.8.44.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 01:46:46');
INSERT INTO `sys_logininfor` VALUES ('823', 'test', '139.227.72.122', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 01:56:55');
INSERT INTO `sys_logininfor` VALUES ('824', 'test', '123.233.115.107', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 01:58:10');
INSERT INTO `sys_logininfor` VALUES ('825', 'test', '219.147.28.114', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 02:01:05');
INSERT INTO `sys_logininfor` VALUES ('826', 'test', '222.173.37.162', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-02 02:06:13');
INSERT INTO `sys_logininfor` VALUES ('827', 'test', '43.227.252.50', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 02:16:22');
INSERT INTO `sys_logininfor` VALUES ('828', 'test', '119.57.107.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 02:26:48');
INSERT INTO `sys_logininfor` VALUES ('829', 'test', '210.21.61.126', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 02:33:23');
INSERT INTO `sys_logininfor` VALUES ('830', 'admin', '36.5.78.173', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 02:46:50');
INSERT INTO `sys_logininfor` VALUES ('831', 'test', '49.77.181.160', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 02:55:10');
INSERT INTO `sys_logininfor` VALUES ('832', 'admin', '59.46.225.11', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-02 03:08:04');
INSERT INTO `sys_logininfor` VALUES ('833', 'test', '59.46.225.11', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 03:08:29');
INSERT INTO `sys_logininfor` VALUES ('834', 'test', '210.13.81.130', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 03:10:00');
INSERT INTO `sys_logininfor` VALUES ('835', 'test', '183.6.116.111', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-02 03:11:11');
INSERT INTO `sys_logininfor` VALUES ('836', 'test', '210.13.81.130', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-02 03:13:06');
INSERT INTO `sys_logininfor` VALUES ('837', 'test', '118.186.2.22', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-02 03:32:19');
INSERT INTO `sys_logininfor` VALUES ('838', 'text', '61.140.233.52', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 03:55:31');
INSERT INTO `sys_logininfor` VALUES ('839', 'test', '61.140.233.52', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 03:55:43');
INSERT INTO `sys_logininfor` VALUES ('840', 'test', '183.14.29.89', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 04:16:43');
INSERT INTO `sys_logininfor` VALUES ('841', 'test', '116.249.109.81', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-02 04:19:00');
INSERT INTO `sys_logininfor` VALUES ('842', 'test', '182.134.148.220', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 04:52:50');
INSERT INTO `sys_logininfor` VALUES ('843', 'test', '182.134.148.220', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-02 04:54:55');
INSERT INTO `sys_logininfor` VALUES ('844', 'test', '59.41.7.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 05:03:52');
INSERT INTO `sys_logininfor` VALUES ('845', 'test', '117.159.26.165', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-02 06:21:09');
INSERT INTO `sys_logininfor` VALUES ('846', 'test', '113.57.175.66', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 06:27:18');
INSERT INTO `sys_logininfor` VALUES ('847', 'admin', '218.86.35.204', 'XX XX', 'Firefox 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 06:30:46');
INSERT INTO `sys_logininfor` VALUES ('848', 'admin', '218.86.35.204', 'XX XX', 'Firefox 8', 'Windows 10', '1', '验证码错误', '2020-11-02 06:30:50');
INSERT INTO `sys_logininfor` VALUES ('849', 'admin', '218.86.35.204', 'XX XX', 'Firefox 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 06:30:54');
INSERT INTO `sys_logininfor` VALUES ('850', 'test', '124.160.65.50', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 06:53:34');
INSERT INTO `sys_logininfor` VALUES ('851', 'test', '27.210.147.103', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 07:02:32');
INSERT INTO `sys_logininfor` VALUES ('852', 'test', '58.213.107.90', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-02 07:19:11');
INSERT INTO `sys_logininfor` VALUES ('853', 'test', '222.84.64.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 07:34:56');
INSERT INTO `sys_logininfor` VALUES ('854', 'admin', '218.57.84.116', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 08:01:14');
INSERT INTO `sys_logininfor` VALUES ('855', 'test', '120.239.40.23', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 08:17:32');
INSERT INTO `sys_logininfor` VALUES ('856', 'test', '113.110.227.228', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 08:51:29');
INSERT INTO `sys_logininfor` VALUES ('857', 'test', '125.65.12.239', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 08:51:51');
INSERT INTO `sys_logininfor` VALUES ('858', 'test', '118.249.56.21', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 09:07:30');
INSERT INTO `sys_logininfor` VALUES ('859', 'test', '210.21.88.164', 'XX XX', 'Internet Explorer 11', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 09:25:04');
INSERT INTO `sys_logininfor` VALUES ('860', 'test', '210.21.88.164', 'XX XX', 'Internet Explorer 11', 'Windows 10', '1', '验证码错误', '2020-11-02 09:25:24');
INSERT INTO `sys_logininfor` VALUES ('861', 'test', '210.21.88.164', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-02 09:25:27');
INSERT INTO `sys_logininfor` VALUES ('862', 'test', '183.45.77.65', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 09:27:15');
INSERT INTO `sys_logininfor` VALUES ('863', 'test', '113.78.164.72', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-02 09:33:11');
INSERT INTO `sys_logininfor` VALUES ('864', 'admin', '125.69.76.42', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-02 09:44:35');
INSERT INTO `sys_logininfor` VALUES ('865', 'admin', '125.69.76.42', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 09:44:40');
INSERT INTO `sys_logininfor` VALUES ('866', 'test', '116.233.77.89', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 09:50:45');
INSERT INTO `sys_logininfor` VALUES ('867', 'test', '171.88.149.165', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-02 09:53:17');
INSERT INTO `sys_logininfor` VALUES ('868', 'test', '222.187.200.98', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 09:54:05');
INSERT INTO `sys_logininfor` VALUES ('869', 'test', '14.124.117.103', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 09:58:24');
INSERT INTO `sys_logininfor` VALUES ('870', 'test', '171.221.52.221', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '退出成功', '2020-11-02 10:11:37');
INSERT INTO `sys_logininfor` VALUES ('871', 'admin', '219.144.219.220', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 10:23:22');
INSERT INTO `sys_logininfor` VALUES ('872', 'test', '219.144.219.220', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 10:23:33');
INSERT INTO `sys_logininfor` VALUES ('873', 'test', '219.144.219.220', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-02 10:23:53');
INSERT INTO `sys_logininfor` VALUES ('874', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 10:49:52');
INSERT INTO `sys_logininfor` VALUES ('875', 'test', '60.173.215.59', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 11:27:58');
INSERT INTO `sys_logininfor` VALUES ('876', 'test', '116.199.102.241', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 11:30:22');
INSERT INTO `sys_logininfor` VALUES ('877', 'test', '116.232.202.78', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 11:53:31');
INSERT INTO `sys_logininfor` VALUES ('878', 'test', '121.101.212.148', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 11:57:24');
INSERT INTO `sys_logininfor` VALUES ('879', 'test', '112.41.10.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 12:26:55');
INSERT INTO `sys_logininfor` VALUES ('880', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 13:07:38');
INSERT INTO `sys_logininfor` VALUES ('881', 'test', '1.81.186.191', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 13:17:38');
INSERT INTO `sys_logininfor` VALUES ('882', 'test', '58.61.51.189', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 13:18:29');
INSERT INTO `sys_logininfor` VALUES ('883', 'test', '1.81.186.191', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-02 13:18:34');
INSERT INTO `sys_logininfor` VALUES ('884', 'admin', '36.5.82.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 13:19:50');
INSERT INTO `sys_logininfor` VALUES ('885', 'test', '112.10.235.214', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-02 13:44:23');
INSERT INTO `sys_logininfor` VALUES ('886', 'test', '163.125.180.37', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 14:03:07');
INSERT INTO `sys_logininfor` VALUES ('887', 'admin', '112.47.161.73', 'XX XX', 'Firefox 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 14:45:57');
INSERT INTO `sys_logininfor` VALUES ('888', 'test', '36.251.129.94', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-02 15:00:06');
INSERT INTO `sys_logininfor` VALUES ('889', 'test', '36.251.129.94', 'XX XX', 'Firefox 8', 'Windows 10', '0', '退出成功', '2020-11-02 15:00:38');
INSERT INTO `sys_logininfor` VALUES ('890', 'admin', '58.243.250.202', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 15:07:44');
INSERT INTO `sys_logininfor` VALUES ('891', 'test', '111.36.172.83', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-02 15:16:27');
INSERT INTO `sys_logininfor` VALUES ('892', 'admin', '58.56.107.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-02 15:25:54');
INSERT INTO `sys_logininfor` VALUES ('893', 'admin', '58.56.107.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 15:26:01');
INSERT INTO `sys_logininfor` VALUES ('894', 'admin', '58.56.107.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 15:27:22');
INSERT INTO `sys_logininfor` VALUES ('895', 'admin', '58.56.107.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-02 15:27:30');
INSERT INTO `sys_logininfor` VALUES ('896', 'test', '58.56.107.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 15:28:01');
INSERT INTO `sys_logininfor` VALUES ('897', 'test', '219.133.101.150', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-02 15:52:16');
INSERT INTO `sys_logininfor` VALUES ('898', 'admin', '58.243.250.202', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-02 15:54:41');
INSERT INTO `sys_logininfor` VALUES ('899', 'admin', '58.243.250.202', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-02 15:54:45');
INSERT INTO `sys_logininfor` VALUES ('900', 'admin', '58.243.250.202', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-02 15:54:48');
INSERT INTO `sys_logininfor` VALUES ('901', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '0', '登录成功', '2020-11-02 23:22:48');
INSERT INTO `sys_logininfor` VALUES ('902', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2020-11-02 23:25:12');
INSERT INTO `sys_logininfor` VALUES ('903', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2020-11-02 23:25:18');
INSERT INTO `sys_logininfor` VALUES ('904', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2020-11-02 23:25:25');
INSERT INTO `sys_logininfor` VALUES ('905', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '验证码错误', '2020-11-02 23:25:28');
INSERT INTO `sys_logininfor` VALUES ('906', 'test', '111.196.74.226', 'XX XX', 'Apple WebKit', 'Mac OS X (iPhone)', '1', '用户不存在/密码错误', '2020-11-02 23:25:35');
INSERT INTO `sys_logininfor` VALUES ('907', 'admin', '222.184.118.252', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 00:42:09');
INSERT INTO `sys_logininfor` VALUES ('908', 'admin', '222.184.118.252', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 00:42:14');
INSERT INTO `sys_logininfor` VALUES ('909', 'admin', '222.184.118.252', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 00:43:03');
INSERT INTO `sys_logininfor` VALUES ('910', 'test', '47.52.249.149', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 01:23:05');
INSERT INTO `sys_logininfor` VALUES ('911', 'test', '27.197.151.137', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 01:28:24');
INSERT INTO `sys_logininfor` VALUES ('912', 'admin', '113.104.224.224', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-03 01:57:30');
INSERT INTO `sys_logininfor` VALUES ('913', 'admin', '113.104.224.224', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-03 01:58:08');
INSERT INTO `sys_logininfor` VALUES ('914', 'admin', '116.228.45.98', 'XX XX', 'Firefox 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 02:05:20');
INSERT INTO `sys_logininfor` VALUES ('915', 'admin', '113.106.110.197', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-03 02:15:20');
INSERT INTO `sys_logininfor` VALUES ('916', 'admin', '113.106.110.197', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-03 02:16:58');
INSERT INTO `sys_logininfor` VALUES ('917', 'test', '42.237.17.174', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-03 02:28:03');
INSERT INTO `sys_logininfor` VALUES ('918', 'test', '113.218.174.49', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-03 02:31:26');
INSERT INTO `sys_logininfor` VALUES ('919', 'test', '113.218.174.49', 'XX XX', 'Chrome 8', 'Windows 7', '0', '退出成功', '2020-11-03 02:32:33');
INSERT INTO `sys_logininfor` VALUES ('920', 'test', '27.8.44.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 02:44:58');
INSERT INTO `sys_logininfor` VALUES ('921', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 02:51:12');
INSERT INTO `sys_logininfor` VALUES ('922', 'test', '211.95.26.70', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 02:53:40');
INSERT INTO `sys_logininfor` VALUES ('923', 'test', '223.73.185.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 02:53:58');
INSERT INTO `sys_logininfor` VALUES ('924', 'test', '220.189.101.79', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 03:04:29');
INSERT INTO `sys_logininfor` VALUES ('925', 'test', '116.228.212.10', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 03:06:42');
INSERT INTO `sys_logininfor` VALUES ('926', 'test', '60.6.203.79', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-03 03:21:16');
INSERT INTO `sys_logininfor` VALUES ('927', 'test', '60.6.203.79', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '退出成功', '2020-11-03 03:24:03');
INSERT INTO `sys_logininfor` VALUES ('928', 'admin', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 03:24:20');
INSERT INTO `sys_logininfor` VALUES ('929', 'admin', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 03:24:28');
INSERT INTO `sys_logininfor` VALUES ('930', 'admin', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 03:24:37');
INSERT INTO `sys_logininfor` VALUES ('931', 'admin', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 03:24:49');
INSERT INTO `sys_logininfor` VALUES ('932', 'test', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-03 03:25:12');
INSERT INTO `sys_logininfor` VALUES ('933', 'test', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 03:25:16');
INSERT INTO `sys_logininfor` VALUES ('934', 'test', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 03:25:24');
INSERT INTO `sys_logininfor` VALUES ('935', 'test', '60.6.203.79', 'XX XX', 'Chrome', 'Windows 10', '0', '退出成功', '2020-11-03 03:25:32');
INSERT INTO `sys_logininfor` VALUES ('936', 'test', '115.220.157.24', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 03:29:15');
INSERT INTO `sys_logininfor` VALUES ('937', 'test', '219.142.225.242', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 03:48:48');
INSERT INTO `sys_logininfor` VALUES ('938', 'test', '112.64.163.194', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 04:37:08');
INSERT INTO `sys_logininfor` VALUES ('939', 'test', '121.11.242.201', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 05:30:55');
INSERT INTO `sys_logininfor` VALUES ('940', 'admin', '113.118.119.97', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-03 05:34:08');
INSERT INTO `sys_logininfor` VALUES ('941', 'admin', '113.118.119.97', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-03 05:35:03');
INSERT INTO `sys_logininfor` VALUES ('942', 'test', '106.121.130.146', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 05:37:30');
INSERT INTO `sys_logininfor` VALUES ('943', 'test', '106.121.130.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 05:37:35');
INSERT INTO `sys_logininfor` VALUES ('944', 'test', '112.66.176.4', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-03 05:50:02');
INSERT INTO `sys_logininfor` VALUES ('945', 'test', '182.135.6.244', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-03 05:54:03');
INSERT INTO `sys_logininfor` VALUES ('946', 'test', '182.135.6.244', 'XX XX', 'Chrome', 'Windows 7', '0', '退出成功', '2020-11-03 05:54:30');
INSERT INTO `sys_logininfor` VALUES ('947', 'test', '120.36.215.206', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 06:01:29');
INSERT INTO `sys_logininfor` VALUES ('948', 'test', '120.36.215.206', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 06:04:44');
INSERT INTO `sys_logininfor` VALUES ('949', 'test', '121.69.40.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 06:07:07');
INSERT INTO `sys_logininfor` VALUES ('950', 'text', '111.40.45.29', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 06:07:45');
INSERT INTO `sys_logininfor` VALUES ('951', 'test', '121.69.40.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-03 06:08:20');
INSERT INTO `sys_logininfor` VALUES ('952', 'test', '121.69.40.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 06:08:24');
INSERT INTO `sys_logininfor` VALUES ('953', 'test', '121.69.40.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 06:08:33');
INSERT INTO `sys_logininfor` VALUES ('954', 'test', '221.2.153.48', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 07:03:23');
INSERT INTO `sys_logininfor` VALUES ('955', 'admin', '58.62.236.114', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 07:28:00');
INSERT INTO `sys_logininfor` VALUES ('956', 'admin', '58.62.236.114', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 07:28:09');
INSERT INTO `sys_logininfor` VALUES ('957', 'test', '42.233.54.2', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 07:33:32');
INSERT INTO `sys_logininfor` VALUES ('958', 'test', '42.233.54.2', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 07:40:13');
INSERT INTO `sys_logininfor` VALUES ('959', 'test', '118.120.204.172', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 07:45:32');
INSERT INTO `sys_logininfor` VALUES ('960', 'admin', '171.212.11.230', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 07:45:38');
INSERT INTO `sys_logininfor` VALUES ('961', 'test', '220.115.189.203', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 07:54:56');
INSERT INTO `sys_logininfor` VALUES ('962', 'test', '36.112.77.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 08:01:49');
INSERT INTO `sys_logininfor` VALUES ('963', 'test', '223.167.65.241', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-03 08:07:37');
INSERT INTO `sys_logininfor` VALUES ('964', 'test', '223.167.65.241', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '验证码错误', '2020-11-03 08:08:07');
INSERT INTO `sys_logininfor` VALUES ('965', 'test', '223.167.65.241', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 08:08:12');
INSERT INTO `sys_logininfor` VALUES ('966', 'test', '113.132.21.39', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 08:34:55');
INSERT INTO `sys_logininfor` VALUES ('967', 'test', '118.186.2.22', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 09:00:55');
INSERT INTO `sys_logininfor` VALUES ('968', 'test', '222.221.216.235', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 09:04:15');
INSERT INTO `sys_logininfor` VALUES ('969', 'test', '222.221.216.235', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 09:05:11');
INSERT INTO `sys_logininfor` VALUES ('970', 'test', '220.163.97.34', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-03 09:09:42');
INSERT INTO `sys_logininfor` VALUES ('971', 'test', '180.110.28.23', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-03 09:34:49');
INSERT INTO `sys_logininfor` VALUES ('972', 'test', '124.78.2.106', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 09:42:36');
INSERT INTO `sys_logininfor` VALUES ('973', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-03 09:52:29');
INSERT INTO `sys_logininfor` VALUES ('974', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '退出成功', '2020-11-03 09:53:11');
INSERT INTO `sys_logininfor` VALUES ('975', 'admin', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '1', '验证码错误', '2020-11-03 09:53:22');
INSERT INTO `sys_logininfor` VALUES ('976', 'admin', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 09:53:33');
INSERT INTO `sys_logininfor` VALUES ('977', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-03 10:44:14');
INSERT INTO `sys_logininfor` VALUES ('978', 'test', '123.121.26.182', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-03 10:57:20');
INSERT INTO `sys_logininfor` VALUES ('979', 'test', '58.246.93.186', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 11:04:24');
INSERT INTO `sys_logininfor` VALUES ('980', '456', '123.52.42.15', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 11:39:41');
INSERT INTO `sys_logininfor` VALUES ('981', 'test', '171.15.167.157', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 12:17:25');
INSERT INTO `sys_logininfor` VALUES ('982', 'test', '61.185.158.253', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 12:18:06');
INSERT INTO `sys_logininfor` VALUES ('983', 'test', '14.23.152.194', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-03 12:32:00');
INSERT INTO `sys_logininfor` VALUES ('984', 'test', '36.110.58.19', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 12:33:49');
INSERT INTO `sys_logininfor` VALUES ('985', 'test', '36.110.58.19', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 12:33:55');
INSERT INTO `sys_logininfor` VALUES ('986', 'test', '220.184.232.172', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-03 12:45:47');
INSERT INTO `sys_logininfor` VALUES ('987', 'test', '103.85.165.18', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-03 13:39:29');
INSERT INTO `sys_logininfor` VALUES ('988', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 14:01:17');
INSERT INTO `sys_logininfor` VALUES ('989', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 14:38:46');
INSERT INTO `sys_logininfor` VALUES ('990', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 14:39:00');
INSERT INTO `sys_logininfor` VALUES ('991', 'test', '120.229.4.117', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 14:41:35');
INSERT INTO `sys_logininfor` VALUES ('992', 'admin', '1.28.185.168', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '用户不存在/密码错误', '2020-11-03 15:03:00');
INSERT INTO `sys_logininfor` VALUES ('993', 'test', '1.28.185.168', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-03 15:04:44');
INSERT INTO `sys_logininfor` VALUES ('994', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-03 15:12:47');
INSERT INTO `sys_logininfor` VALUES ('995', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 15:12:50');
INSERT INTO `sys_logininfor` VALUES ('996', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 15:12:53');
INSERT INTO `sys_logininfor` VALUES ('997', 'test', '219.136.129.93', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 15:23:38');
INSERT INTO `sys_logininfor` VALUES ('998', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 15:33:15');
INSERT INTO `sys_logininfor` VALUES ('999', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 15:33:23');
INSERT INTO `sys_logininfor` VALUES ('1000', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 15:34:21');
INSERT INTO `sys_logininfor` VALUES ('1001', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-03 15:34:31');
INSERT INTO `sys_logininfor` VALUES ('1002', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-03 15:34:38');
INSERT INTO `sys_logininfor` VALUES ('1003', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 15:34:41');
INSERT INTO `sys_logininfor` VALUES ('1004', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 15:36:10');
INSERT INTO `sys_logininfor` VALUES ('1005', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 16:04:03');
INSERT INTO `sys_logininfor` VALUES ('1006', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-03 16:06:01');
INSERT INTO `sys_logininfor` VALUES ('1007', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-03 16:13:02');
INSERT INTO `sys_logininfor` VALUES ('1008', 'test', '111.19.37.56', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-03 19:31:51');
INSERT INTO `sys_logininfor` VALUES ('1009', 'test', '36.170.33.225', 'XX XX', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2020-11-03 23:41:23');
INSERT INTO `sys_logininfor` VALUES ('1010', 'admin', '49.80.236.19', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 00:53:09');
INSERT INTO `sys_logininfor` VALUES ('1011', 'test', '113.88.192.15', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 01:03:10');
INSERT INTO `sys_logininfor` VALUES ('1012', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-04 01:46:04');
INSERT INTO `sys_logininfor` VALUES ('1013', 'test', '116.228.21.172', 'XX XX', 'Chrome 8', 'Windows 8.1', '0', '登录成功', '2020-11-04 02:13:36');
INSERT INTO `sys_logininfor` VALUES ('1014', 'test', '59.41.7.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 02:19:11');
INSERT INTO `sys_logininfor` VALUES ('1015', 'test', '49.77.136.52', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 02:23:37');
INSERT INTO `sys_logininfor` VALUES ('1016', 'test', '61.164.40.34', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 02:32:39');
INSERT INTO `sys_logininfor` VALUES ('1017', 'test', '113.66.249.219', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 02:35:41');
INSERT INTO `sys_logininfor` VALUES ('1018', 'test', '116.2.162.13', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 03:02:54');
INSERT INTO `sys_logininfor` VALUES ('1019', 'test', '42.84.36.44', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 03:05:13');
INSERT INTO `sys_logininfor` VALUES ('1020', 'test', '112.64.178.81', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 03:18:29');
INSERT INTO `sys_logininfor` VALUES ('1021', 'admin', '14.18.236.70', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-04 03:26:11');
INSERT INTO `sys_logininfor` VALUES ('1022', 'admin', '14.18.236.70', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-04 03:26:14');
INSERT INTO `sys_logininfor` VALUES ('1023', 'test', '58.248.158.157', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 03:28:45');
INSERT INTO `sys_logininfor` VALUES ('1024', 'test', '58.248.158.157', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 03:28:49');
INSERT INTO `sys_logininfor` VALUES ('1025', 'test', '61.140.27.250', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 03:35:32');
INSERT INTO `sys_logininfor` VALUES ('1026', 'test', '221.237.156.244', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 04:31:06');
INSERT INTO `sys_logininfor` VALUES ('1027', 'test', '1.87.240.1', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 05:35:33');
INSERT INTO `sys_logininfor` VALUES ('1028', 'admin', '36.5.79.77', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 05:35:45');
INSERT INTO `sys_logininfor` VALUES ('1029', 'admin', '36.5.79.77', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 05:35:57');
INSERT INTO `sys_logininfor` VALUES ('1030', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 05:49:41');
INSERT INTO `sys_logininfor` VALUES ('1031', 'test', '171.214.237.235', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 05:52:59');
INSERT INTO `sys_logininfor` VALUES ('1032', 'test', '110.80.36.74', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 06:06:16');
INSERT INTO `sys_logininfor` VALUES ('1033', 'test', '110.80.36.74', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 06:10:33');
INSERT INTO `sys_logininfor` VALUES ('1034', 'admin', '110.80.36.74', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 06:10:44');
INSERT INTO `sys_logininfor` VALUES ('1035', 'test', '218.77.107.112', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 06:13:57');
INSERT INTO `sys_logininfor` VALUES ('1036', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 06:25:13');
INSERT INTO `sys_logininfor` VALUES ('1037', 'test', '49.65.250.91', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 06:28:25');
INSERT INTO `sys_logininfor` VALUES ('1038', 'test', '61.142.114.201', 'XX XX', 'Chrome', 'Mac OS X', '0', '登录成功', '2020-11-04 06:29:04');
INSERT INTO `sys_logininfor` VALUES ('1039', 'test', '61.142.114.201', 'XX XX', 'Chrome', 'Mac OS X', '0', '退出成功', '2020-11-04 06:29:40');
INSERT INTO `sys_logininfor` VALUES ('1040', 'test', '27.154.24.154', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-04 06:38:59');
INSERT INTO `sys_logininfor` VALUES ('1041', 'admin', '114.97.141.22', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 06:44:46');
INSERT INTO `sys_logininfor` VALUES ('1042', 'test', '112.64.108.225', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-04 06:50:26');
INSERT INTO `sys_logininfor` VALUES ('1043', 'admin', '10.11.68.62', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 06:56:02');
INSERT INTO `sys_logininfor` VALUES ('1044', 'admin', '10.11.68.62', '内网IP', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 06:56:08');
INSERT INTO `sys_logininfor` VALUES ('1045', 'admin', '10.11.68.62', '内网IP', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 06:58:23');
INSERT INTO `sys_logininfor` VALUES ('1046', 'test', '223.98.159.40', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 06:59:14');
INSERT INTO `sys_logininfor` VALUES ('1047', 'test', '58.16.151.187', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 07:00:08');
INSERT INTO `sys_logininfor` VALUES ('1048', 'test', '180.152.153.84', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-04 07:00:46');
INSERT INTO `sys_logininfor` VALUES ('1049', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 07:07:23');
INSERT INTO `sys_logininfor` VALUES ('1050', 'test', '59.108.78.98', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 07:18:20');
INSERT INTO `sys_logininfor` VALUES ('1051', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-04 07:40:04');
INSERT INTO `sys_logininfor` VALUES ('1052', 'test', '111.166.243.61', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-04 07:54:26');
INSERT INTO `sys_logininfor` VALUES ('1053', 'admin', '119.137.52.228', 'XX XX', 'Chrome', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-04 07:55:38');
INSERT INTO `sys_logininfor` VALUES ('1054', 'test', '106.33.12.121', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 08:06:12');
INSERT INTO `sys_logininfor` VALUES ('1055', 'test', '106.33.12.121', 'XX XX', 'Chrome 8', 'Windows 7', '0', '退出成功', '2020-11-04 08:06:23');
INSERT INTO `sys_logininfor` VALUES ('1056', 'test', '119.137.52.228', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-04 08:07:03');
INSERT INTO `sys_logininfor` VALUES ('1057', 'test', '106.33.12.121', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 08:12:38');
INSERT INTO `sys_logininfor` VALUES ('1058', 'test', '175.8.51.191', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 08:32:06');
INSERT INTO `sys_logininfor` VALUES ('1059', 'test', '175.8.51.191', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 08:32:15');
INSERT INTO `sys_logininfor` VALUES ('1060', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-04 08:41:02');
INSERT INTO `sys_logininfor` VALUES ('1061', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 08:41:07');
INSERT INTO `sys_logininfor` VALUES ('1062', 'test', '111.13.46.36', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 08:41:16');
INSERT INTO `sys_logininfor` VALUES ('1063', 'test', '58.48.227.219', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 08:55:36');
INSERT INTO `sys_logininfor` VALUES ('1064', 'test', '39.153.150.25', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-04 09:08:35');
INSERT INTO `sys_logininfor` VALUES ('1065', 'test', '116.6.77.146', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-04 09:10:58');
INSERT INTO `sys_logininfor` VALUES ('1066', 'test', '112.66.176.126', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-04 09:25:33');
INSERT INTO `sys_logininfor` VALUES ('1067', 'test', '111.207.194.199', 'XX XX', 'Firefox 8', 'Mac OS X', '0', '登录成功', '2020-11-04 09:27:43');
INSERT INTO `sys_logininfor` VALUES ('1068', 'test', '36.7.129.90', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 09:32:01');
INSERT INTO `sys_logininfor` VALUES ('1069', 'test', '125.86.191.155', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 09:52:51');
INSERT INTO `sys_logininfor` VALUES ('1070', 'test', '121.69.40.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 10:32:12');
INSERT INTO `sys_logininfor` VALUES ('1071', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 13:03:20');
INSERT INTO `sys_logininfor` VALUES ('1072', 'test', '180.162.231.243', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 13:20:59');
INSERT INTO `sys_logininfor` VALUES ('1073', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 13:28:01');
INSERT INTO `sys_logininfor` VALUES ('1074', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 13:29:17');
INSERT INTO `sys_logininfor` VALUES ('1075', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 13:42:56');
INSERT INTO `sys_logininfor` VALUES ('1076', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 13:43:12');
INSERT INTO `sys_logininfor` VALUES ('1077', 'test', '112.10.111.156', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-04 13:47:54');
INSERT INTO `sys_logininfor` VALUES ('1078', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 14:14:05');
INSERT INTO `sys_logininfor` VALUES ('1079', 'XuXueJun', '192.168.31.145', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 14:33:10');
INSERT INTO `sys_logininfor` VALUES ('1080', 'admin', '192.168.31.145', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 14:33:18');
INSERT INTO `sys_logininfor` VALUES ('1081', 'admin', '192.168.31.145', '内网IP', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 14:39:50');
INSERT INTO `sys_logininfor` VALUES ('1082', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 14:58:22');
INSERT INTO `sys_logininfor` VALUES ('1083', '18158873850', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:04:14');
INSERT INTO `sys_logininfor` VALUES ('1084', 'admin', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 15:04:22');
INSERT INTO `sys_logininfor` VALUES ('1085', 'admin', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 15:04:41');
INSERT INTO `sys_logininfor` VALUES ('1086', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:05:27');
INSERT INTO `sys_logininfor` VALUES ('1087', 'admin', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:07:23');
INSERT INTO `sys_logininfor` VALUES ('1088', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:07:53');
INSERT INTO `sys_logininfor` VALUES ('1089', '18158873850', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:07:56');
INSERT INTO `sys_logininfor` VALUES ('1090', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:08:24');
INSERT INTO `sys_logininfor` VALUES ('1091', '18158873850', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:08:37');
INSERT INTO `sys_logininfor` VALUES ('1092', '18158873850', '36.5.212.18', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:09:06');
INSERT INTO `sys_logininfor` VALUES ('1093', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:09:43');
INSERT INTO `sys_logininfor` VALUES ('1094', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-04 15:13:15');
INSERT INTO `sys_logininfor` VALUES ('1095', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 15:13:18');
INSERT INTO `sys_logininfor` VALUES ('1096', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-04 15:13:22');
INSERT INTO `sys_logininfor` VALUES ('1097', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-04 15:13:35');
INSERT INTO `sys_logininfor` VALUES ('1098', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 15:13:38');
INSERT INTO `sys_logininfor` VALUES ('1099', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:16:36');
INSERT INTO `sys_logininfor` VALUES ('1100', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 15:29:37');
INSERT INTO `sys_logininfor` VALUES ('1101', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 15:30:35');
INSERT INTO `sys_logininfor` VALUES ('1102', 'admin', '183.160.1.154', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-04 15:47:50');
INSERT INTO `sys_logininfor` VALUES ('1103', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-04 15:59:56');
INSERT INTO `sys_logininfor` VALUES ('1104', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:18:22');
INSERT INTO `sys_logininfor` VALUES ('1105', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:26:25');
INSERT INTO `sys_logininfor` VALUES ('1106', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:31:41');
INSERT INTO `sys_logininfor` VALUES ('1107', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:32:52');
INSERT INTO `sys_logininfor` VALUES ('1108', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:33:41');
INSERT INTO `sys_logininfor` VALUES ('1109', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:35:37');
INSERT INTO `sys_logininfor` VALUES ('1110', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:41:41');
INSERT INTO `sys_logininfor` VALUES ('1111', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:44:16');
INSERT INTO `sys_logininfor` VALUES ('1112', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:45:19');
INSERT INTO `sys_logininfor` VALUES ('1113', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:47:36');
INSERT INTO `sys_logininfor` VALUES ('1114', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:52:54');
INSERT INTO `sys_logininfor` VALUES ('1115', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 16:56:17');
INSERT INTO `sys_logininfor` VALUES ('1116', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 17:05:05');
INSERT INTO `sys_logininfor` VALUES ('1117', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 17:14:09');
INSERT INTO `sys_logininfor` VALUES ('1118', 'XuXueJun', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-04 17:17:31');
INSERT INTO `sys_logininfor` VALUES ('1119', 'test', '39.164.41.17', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-05 00:56:22');
INSERT INTO `sys_logininfor` VALUES ('1120', 'admin', '58.101.146.233', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 01:07:58');
INSERT INTO `sys_logininfor` VALUES ('1121', 'test', '58.101.146.233', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 01:08:43');
INSERT INTO `sys_logininfor` VALUES ('1122', 'test', '14.221.97.171', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-05 01:19:47');
INSERT INTO `sys_logininfor` VALUES ('1123', 'test', '110.87.117.251', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-05 01:19:55');
INSERT INTO `sys_logininfor` VALUES ('1124', 'test', '14.221.97.171', 'XX XX', 'Chrome', 'Windows 7', '0', '退出成功', '2020-11-05 01:20:33');
INSERT INTO `sys_logininfor` VALUES ('1125', 'test', '113.200.214.82', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 01:25:06');
INSERT INTO `sys_logininfor` VALUES ('1126', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 01:31:22');
INSERT INTO `sys_logininfor` VALUES ('1127', 'test', '125.211.27.19', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 02:04:58');
INSERT INTO `sys_logininfor` VALUES ('1128', 'test', '117.68.149.89', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 02:09:47');
INSERT INTO `sys_logininfor` VALUES ('1129', 'test', '36.5.147.53', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-05 02:12:45');
INSERT INTO `sys_logininfor` VALUES ('1130', 'test', '61.164.137.170', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 02:15:59');
INSERT INTO `sys_logininfor` VALUES ('1131', 'admin', '58.243.254.177', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 02:20:24');
INSERT INTO `sys_logininfor` VALUES ('1132', 'test', '121.32.154.183', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-05 02:28:26');
INSERT INTO `sys_logininfor` VALUES ('1133', 'test', '121.32.154.183', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '退出成功', '2020-11-05 02:32:14');
INSERT INTO `sys_logininfor` VALUES ('1134', 'admin', '121.32.154.183', 'XX XX', 'Internet Explorer 11', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 02:32:31');
INSERT INTO `sys_logininfor` VALUES ('1135', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-05 02:41:59');
INSERT INTO `sys_logininfor` VALUES ('1136', '18158873850', '36.5.76.173', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-05 02:47:12');
INSERT INTO `sys_logininfor` VALUES ('1137', 'test', '183.195.248.156', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 03:27:17');
INSERT INTO `sys_logininfor` VALUES ('1138', 'admin', '58.243.254.177', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 03:28:25');
INSERT INTO `sys_logininfor` VALUES ('1139', 'admin', '117.30.214.33', 'XX XX', 'Safari', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-05 03:33:29');
INSERT INTO `sys_logininfor` VALUES ('1140', 'admin', '117.30.214.33', 'XX XX', 'Safari', 'Mac OS X', '1', '验证码错误', '2020-11-05 03:33:45');
INSERT INTO `sys_logininfor` VALUES ('1141', 'admin', '117.30.214.33', 'XX XX', 'Safari', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-05 03:33:49');
INSERT INTO `sys_logininfor` VALUES ('1142', 'test', '121.11.161.78', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 04:41:19');
INSERT INTO `sys_logininfor` VALUES ('1143', 'test', '60.191.111.68', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 04:47:54');
INSERT INTO `sys_logininfor` VALUES ('1144', 'admin', '101.229.72.131', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 05:27:06');
INSERT INTO `sys_logininfor` VALUES ('1145', 'test', '101.229.72.131', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 05:27:22');
INSERT INTO `sys_logininfor` VALUES ('1146', 'admin', '116.246.31.34', 'XX XX', 'Chrome 8', 'Windows 8', '1', '用户不存在/密码错误', '2020-11-05 05:33:02');
INSERT INTO `sys_logininfor` VALUES ('1147', 'admin', '116.246.31.34', 'XX XX', 'Chrome 8', 'Windows 8', '1', '验证码错误', '2020-11-05 05:33:09');
INSERT INTO `sys_logininfor` VALUES ('1148', 'admin', '116.246.31.34', 'XX XX', 'Chrome 8', 'Windows 8', '1', '用户不存在/密码错误', '2020-11-05 05:33:14');
INSERT INTO `sys_logininfor` VALUES ('1149', 'test', '116.233.11.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 05:34:12');
INSERT INTO `sys_logininfor` VALUES ('1150', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 05:40:23');
INSERT INTO `sys_logininfor` VALUES ('1151', 'test', '101.224.139.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 05:41:45');
INSERT INTO `sys_logininfor` VALUES ('1152', 'test', '123.125.250.94', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 05:45:08');
INSERT INTO `sys_logininfor` VALUES ('1153', 'test', '58.246.183.150', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 06:09:27');
INSERT INTO `sys_logininfor` VALUES ('1154', 'test', '59.42.128.82', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-05 06:42:07');
INSERT INTO `sys_logininfor` VALUES ('1155', 'test', '219.137.64.133', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-05 06:53:18');
INSERT INTO `sys_logininfor` VALUES ('1156', 'test', '222.240.18.46', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 07:00:46');
INSERT INTO `sys_logininfor` VALUES ('1157', 'test', '182.125.116.104', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 07:01:21');
INSERT INTO `sys_logininfor` VALUES ('1158', 'admin', '115.60.62.138', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 07:04:01');
INSERT INTO `sys_logininfor` VALUES ('1159', 'admin', '115.60.62.138', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 07:04:21');
INSERT INTO `sys_logininfor` VALUES ('1160', 'test', '120.237.156.119', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 07:23:02');
INSERT INTO `sys_logininfor` VALUES ('1161', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 07:45:00');
INSERT INTO `sys_logininfor` VALUES ('1162', 'test', '112.10.55.82', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 07:48:15');
INSERT INTO `sys_logininfor` VALUES ('1163', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 08:05:54');
INSERT INTO `sys_logininfor` VALUES ('1164', 'test', '119.33.33.122', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 08:11:52');
INSERT INTO `sys_logininfor` VALUES ('1165', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 08:12:04');
INSERT INTO `sys_logininfor` VALUES ('1166', 'test', '220.200.43.33', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 08:38:46');
INSERT INTO `sys_logininfor` VALUES ('1167', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 09:19:15');
INSERT INTO `sys_logininfor` VALUES ('1168', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 09:19:22');
INSERT INTO `sys_logininfor` VALUES ('1169', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 09:19:52');
INSERT INTO `sys_logininfor` VALUES ('1170', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 09:19:56');
INSERT INTO `sys_logininfor` VALUES ('1171', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-05 09:21:34');
INSERT INTO `sys_logininfor` VALUES ('1172', 'test', '59.41.7.226', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 09:57:32');
INSERT INTO `sys_logininfor` VALUES ('1173', 'test', '61.52.82.8', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-05 09:58:27');
INSERT INTO `sys_logininfor` VALUES ('1174', 'test', '112.24.203.90', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-05 09:59:24');
INSERT INTO `sys_logininfor` VALUES ('1175', 'test', '223.104.66.131', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 10:02:05');
INSERT INTO `sys_logininfor` VALUES ('1176', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-05 10:09:28');
INSERT INTO `sys_logininfor` VALUES ('1177', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-05 10:09:40');
INSERT INTO `sys_logininfor` VALUES ('1178', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 10:10:10');
INSERT INTO `sys_logininfor` VALUES ('1179', 'admin', '183.13.9.127', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 11:07:50');
INSERT INTO `sys_logininfor` VALUES ('1180', 'admin', '183.13.9.127', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 11:08:05');
INSERT INTO `sys_logininfor` VALUES ('1181', 'test', '183.13.9.127', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 11:08:27');
INSERT INTO `sys_logininfor` VALUES ('1182', 'test', '183.13.9.127', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-05 11:08:33');
INSERT INTO `sys_logininfor` VALUES ('1183', 'admin', '113.116.17.120', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 11:08:37');
INSERT INTO `sys_logininfor` VALUES ('1184', 'test', '183.13.9.127', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-05 11:08:41');
INSERT INTO `sys_logininfor` VALUES ('1185', 'admin', '113.116.17.120', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-05 11:08:46');
INSERT INTO `sys_logininfor` VALUES ('1186', 'admin', '223.244.122.101', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 11:31:25');
INSERT INTO `sys_logininfor` VALUES ('1187', 'test', '1.203.163.2', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 12:18:17');
INSERT INTO `sys_logininfor` VALUES ('1188', 'admin', '113.119.87.23', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-05 12:59:39');
INSERT INTO `sys_logininfor` VALUES ('1189', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 13:08:16');
INSERT INTO `sys_logininfor` VALUES ('1190', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 13:52:28');
INSERT INTO `sys_logininfor` VALUES ('1191', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 14:13:09');
INSERT INTO `sys_logininfor` VALUES ('1192', 'test', '112.97.55.81', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-05 14:24:17');
INSERT INTO `sys_logininfor` VALUES ('1193', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-05 15:08:23');
INSERT INTO `sys_logininfor` VALUES ('1194', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 15:08:26');
INSERT INTO `sys_logininfor` VALUES ('1195', 'test', '113.68.38.49', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-05 15:11:29');
INSERT INTO `sys_logininfor` VALUES ('1196', 'Test', '111.174.77.152', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '用户不存在/密码错误', '2020-11-05 17:37:45');
INSERT INTO `sys_logininfor` VALUES ('1197', 'test', '111.174.77.152', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '验证码错误', '2020-11-05 17:38:06');
INSERT INTO `sys_logininfor` VALUES ('1198', 'test', '111.174.77.152', 'XX XX', 'Chrome Mobile', 'Android 1.x', '1', '用户不存在/密码错误', '2020-11-05 17:38:15');
INSERT INTO `sys_logininfor` VALUES ('1199', 'test', '183.6.116.111', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-06 00:31:28');
INSERT INTO `sys_logininfor` VALUES ('1200', 'test', '183.6.116.111', 'XX XX', 'Safari', 'Mac OS X', '0', '退出成功', '2020-11-06 00:32:45');
INSERT INTO `sys_logininfor` VALUES ('1201', 'test', '27.191.198.164', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 00:45:21');
INSERT INTO `sys_logininfor` VALUES ('1202', 'admin', '113.116.134.178', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 00:59:40');
INSERT INTO `sys_logininfor` VALUES ('1203', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 01:02:49');
INSERT INTO `sys_logininfor` VALUES ('1204', 'test', '101.38.82.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 01:13:56');
INSERT INTO `sys_logininfor` VALUES ('1205', 'test', '101.38.82.165', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-06 01:15:29');
INSERT INTO `sys_logininfor` VALUES ('1206', 'test', '119.84.39.72', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 01:17:05');
INSERT INTO `sys_logininfor` VALUES ('1207', 'test', '119.130.129.100', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 01:17:50');
INSERT INTO `sys_logininfor` VALUES ('1208', 'test', '119.130.129.100', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 01:18:01');
INSERT INTO `sys_logininfor` VALUES ('1209', 'test', '183.13.9.127', 'XX XX', 'Internet Explorer 11', 'Windows 7', '0', '登录成功', '2020-11-06 01:38:00');
INSERT INTO `sys_logininfor` VALUES ('1210', 'admin', '123.114.232.234', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码已失效', '2020-11-06 01:38:10');
INSERT INTO `sys_logininfor` VALUES ('1211', 'admin', '123.114.232.234', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 01:38:13');
INSERT INTO `sys_logininfor` VALUES ('1212', 'admin', '123.114.232.234', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 01:38:17');
INSERT INTO `sys_logininfor` VALUES ('1213', 'test', '123.114.232.234', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 01:38:23');
INSERT INTO `sys_logininfor` VALUES ('1214', 'test', '123.114.232.234', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 01:38:41');
INSERT INTO `sys_logininfor` VALUES ('1215', 'test', '42.101.64.227', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 01:49:22');
INSERT INTO `sys_logininfor` VALUES ('1216', '1', '27.184.49.27', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码错误', '2020-11-06 01:55:38');
INSERT INTO `sys_logininfor` VALUES ('1217', '1', '27.184.49.27', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码已失效', '2020-11-06 01:55:43');
INSERT INTO `sys_logininfor` VALUES ('1218', 'test', '106.38.95.114', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 01:58:35');
INSERT INTO `sys_logininfor` VALUES ('1219', '1', '27.184.49.27', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码已失效', '2020-11-06 02:05:39');
INSERT INTO `sys_logininfor` VALUES ('1220', '1', '27.184.49.27', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 02:05:46');
INSERT INTO `sys_logininfor` VALUES ('1221', 'test', '116.236.235.50', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 02:07:44');
INSERT INTO `sys_logininfor` VALUES ('1222', 'test', '219.135.144.186', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 02:13:03');
INSERT INTO `sys_logininfor` VALUES ('1223', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 02:30:37');
INSERT INTO `sys_logininfor` VALUES ('1224', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:38');
INSERT INTO `sys_logininfor` VALUES ('1225', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:39');
INSERT INTO `sys_logininfor` VALUES ('1226', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:39');
INSERT INTO `sys_logininfor` VALUES ('1227', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:39');
INSERT INTO `sys_logininfor` VALUES ('1228', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 02:30:39');
INSERT INTO `sys_logininfor` VALUES ('1229', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:40');
INSERT INTO `sys_logininfor` VALUES ('1230', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:40');
INSERT INTO `sys_logininfor` VALUES ('1231', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:40');
INSERT INTO `sys_logininfor` VALUES ('1232', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:40');
INSERT INTO `sys_logininfor` VALUES ('1233', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:41');
INSERT INTO `sys_logininfor` VALUES ('1234', 'admin', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-06 02:30:41');
INSERT INTO `sys_logininfor` VALUES ('1235', 'test', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 02:30:58');
INSERT INTO `sys_logininfor` VALUES ('1236', 'test', '219.148.41.13', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 02:39:58');
INSERT INTO `sys_logininfor` VALUES ('1237', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 02:40:59');
INSERT INTO `sys_logininfor` VALUES ('1238', 'test', '171.212.10.216', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 02:45:27');
INSERT INTO `sys_logininfor` VALUES ('1239', 'test', '60.21.206.186', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 02:46:37');
INSERT INTO `sys_logininfor` VALUES ('1240', 'test', '117.36.119.143', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 03:17:04');
INSERT INTO `sys_logininfor` VALUES ('1241', 'admin', '112.80.30.194', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 03:34:33');
INSERT INTO `sys_logininfor` VALUES ('1242', 'admin', '112.80.30.194', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 03:34:41');
INSERT INTO `sys_logininfor` VALUES ('1243', 'admin', '112.80.30.194', 'XX XX', 'Chrome 8', 'Windows 7', '1', '用户不存在/密码错误', '2020-11-06 03:34:47');
INSERT INTO `sys_logininfor` VALUES ('1244', 'test', '61.175.234.226', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 03:38:12');
INSERT INTO `sys_logininfor` VALUES ('1245', 'test', '61.175.234.226', 'XX XX', 'Chrome 8', 'Windows 7', '0', '退出成功', '2020-11-06 03:39:03');
INSERT INTO `sys_logininfor` VALUES ('1246', 'test', '61.154.103.16', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 03:50:29');
INSERT INTO `sys_logininfor` VALUES ('1247', 'test', '106.6.138.233', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 04:01:37');
INSERT INTO `sys_logininfor` VALUES ('1248', 'test', '171.221.244.181', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-06 04:23:47');
INSERT INTO `sys_logininfor` VALUES ('1249', 'test', '171.221.244.181', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 04:23:53');
INSERT INTO `sys_logininfor` VALUES ('1250', 'test', '218.17.25.234', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 04:29:11');
INSERT INTO `sys_logininfor` VALUES ('1251', 'test', '27.191.198.164', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 05:01:31');
INSERT INTO `sys_logininfor` VALUES ('1252', 'test', '106.121.130.146', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-06 05:23:34');
INSERT INTO `sys_logininfor` VALUES ('1253', 'test', '106.121.130.146', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-06 05:23:37');
INSERT INTO `sys_logininfor` VALUES ('1254', 'test', '106.121.130.146', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 05:23:40');
INSERT INTO `sys_logininfor` VALUES ('1255', 'test', '210.22.175.98', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 05:35:03');
INSERT INTO `sys_logininfor` VALUES ('1256', 'test', '61.144.36.122', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 05:51:51');
INSERT INTO `sys_logininfor` VALUES ('1257', 'test', '117.71.58.151', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 05:55:33');
INSERT INTO `sys_logininfor` VALUES ('1258', 'admin', '36.5.76.173', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 05:58:55');
INSERT INTO `sys_logininfor` VALUES ('1259', 'test', '115.236.184.58', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 06:01:43');
INSERT INTO `sys_logininfor` VALUES ('1260', 'test', '223.104.66.70', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-06 06:12:14');
INSERT INTO `sys_logininfor` VALUES ('1261', 'test', '223.104.66.70', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 06:12:18');
INSERT INTO `sys_logininfor` VALUES ('1262', 'test', '117.189.28.59', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 06:16:08');
INSERT INTO `sys_logininfor` VALUES ('1263', 'test', '117.83.131.124', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 06:25:15');
INSERT INTO `sys_logininfor` VALUES ('1264', 'test', '106.38.83.186', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 06:49:27');
INSERT INTO `sys_logininfor` VALUES ('1265', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 07:03:30');
INSERT INTO `sys_logininfor` VALUES ('1266', 'test', '221.222.132.124', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-06 07:05:55');
INSERT INTO `sys_logininfor` VALUES ('1267', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 07:08:29');
INSERT INTO `sys_logininfor` VALUES ('1268', 'test', '219.139.130.99', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 07:08:37');
INSERT INTO `sys_logininfor` VALUES ('1269', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 07:10:46');
INSERT INTO `sys_logininfor` VALUES ('1270', 'test', '219.146.91.110', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-06 07:12:25');
INSERT INTO `sys_logininfor` VALUES ('1271', 'test', '219.146.91.110', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 07:12:31');
INSERT INTO `sys_logininfor` VALUES ('1272', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 07:13:20');
INSERT INTO `sys_logininfor` VALUES ('1273', 'test', '58.213.122.234', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 07:14:13');
INSERT INTO `sys_logininfor` VALUES ('1274', 'test', '58.40.17.82', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 07:40:34');
INSERT INTO `sys_logininfor` VALUES ('1275', 'test', '112.30.117.254', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 07:41:14');
INSERT INTO `sys_logininfor` VALUES ('1276', '1', '171.43.219.102', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 07:52:55');
INSERT INTO `sys_logininfor` VALUES ('1277', 'admin', '171.43.219.102', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 07:53:03');
INSERT INTO `sys_logininfor` VALUES ('1278', 'admin', '127.0.0.1', '内网IP', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 07:54:59');
INSERT INTO `sys_logininfor` VALUES ('1279', 'test', '58.250.197.19', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-06 08:07:32');
INSERT INTO `sys_logininfor` VALUES ('1280', 'test', '219.133.168.18', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 08:09:28');
INSERT INTO `sys_logininfor` VALUES ('1281', 'test', '183.189.194.222', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 08:23:55');
INSERT INTO `sys_logininfor` VALUES ('1282', 'test', '222.91.148.20', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-06 08:25:01');
INSERT INTO `sys_logininfor` VALUES ('1283', 'test', '222.91.148.20', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 08:25:05');
INSERT INTO `sys_logininfor` VALUES ('1284', 'test', '111.163.40.189', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 08:25:51');
INSERT INTO `sys_logininfor` VALUES ('1285', 'test', '115.236.184.58', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 08:33:34');
INSERT INTO `sys_logininfor` VALUES ('1286', 'test', '219.137.188.24', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 08:54:31');
INSERT INTO `sys_logininfor` VALUES ('1287', 'test', '120.36.253.66', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码错误', '2020-11-06 09:32:34');
INSERT INTO `sys_logininfor` VALUES ('1288', 'test', '120.36.253.66', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 09:32:37');
INSERT INTO `sys_logininfor` VALUES ('1289', 'test', '218.72.50.170', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-06 09:50:36');
INSERT INTO `sys_logininfor` VALUES ('1290', 'test', '123.149.77.23', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 10:20:08');
INSERT INTO `sys_logininfor` VALUES ('1291', 'test', '218.17.162.165', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-06 10:57:50');
INSERT INTO `sys_logininfor` VALUES ('1292', 'test', '27.38.32.39', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 11:00:43');
INSERT INTO `sys_logininfor` VALUES ('1293', 'test', '223.96.245.121', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-06 13:21:56');
INSERT INTO `sys_logininfor` VALUES ('1294', 'test', '106.83.201.189', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 13:56:59');
INSERT INTO `sys_logininfor` VALUES ('1295', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 14:06:52');
INSERT INTO `sys_logininfor` VALUES ('1296', 'test', '118.122.37.189', 'XX XX', 'Chrome 8', 'Windows 7', '1', '验证码已失效', '2020-11-06 14:14:56');
INSERT INTO `sys_logininfor` VALUES ('1297', 'test', '118.122.37.189', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-06 14:15:04');
INSERT INTO `sys_logininfor` VALUES ('1298', 'test', '113.205.95.179', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 14:26:36');
INSERT INTO `sys_logininfor` VALUES ('1299', 'test', '120.239.226.78', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 14:32:05');
INSERT INTO `sys_logininfor` VALUES ('1300', 'test', '114.216.240.44', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-06 15:02:10');
INSERT INTO `sys_logininfor` VALUES ('1301', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 15:10:20');
INSERT INTO `sys_logininfor` VALUES ('1302', 'test', '112.10.68.9', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 15:43:02');
INSERT INTO `sys_logininfor` VALUES ('1303', 'test', '114.100.87.107', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-06 17:07:03');
INSERT INTO `sys_logininfor` VALUES ('1304', 'test', '120.36.144.80', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-06 17:15:53');
INSERT INTO `sys_logininfor` VALUES ('1305', 'test', '59.41.161.4', 'XX XX', 'Chrome Mobile', 'Android Mobile', '0', '登录成功', '2020-11-06 19:04:13');
INSERT INTO `sys_logininfor` VALUES ('1306', 'test', '117.26.4.160', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-06 23:34:27');
INSERT INTO `sys_logininfor` VALUES ('1307', 'admin', '1.55.40.44', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 23:34:54');
INSERT INTO `sys_logininfor` VALUES ('1308', 'admin', '1.55.40.44', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 23:35:01');
INSERT INTO `sys_logininfor` VALUES ('1309', 'admin', '1.55.40.44', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-06 23:35:12');
INSERT INTO `sys_logininfor` VALUES ('1310', 'test', '183.4.40.191', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 00:57:30');
INSERT INTO `sys_logininfor` VALUES ('1311', 'test', '222.244.104.186', 'XX XX', 'Safari', 'Mac OS X', '0', '登录成功', '2020-11-07 01:13:04');
INSERT INTO `sys_logininfor` VALUES ('1312', 'admin', '39.130.111.212', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 02:29:58');
INSERT INTO `sys_logininfor` VALUES ('1313', 'admin', '39.130.111.212', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 02:30:03');
INSERT INTO `sys_logininfor` VALUES ('1314', 'test', '121.13.108.100', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 02:41:22');
INSERT INTO `sys_logininfor` VALUES ('1315', 'test', '117.25.172.106', 'XX XX', 'Chrome 8', 'Windows 7', '0', '登录成功', '2020-11-07 02:41:36');
INSERT INTO `sys_logininfor` VALUES ('1316', 'test', '223.11.30.228', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 02:48:20');
INSERT INTO `sys_logininfor` VALUES ('1317', 'admin', '117.22.144.255', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 03:21:14');
INSERT INTO `sys_logininfor` VALUES ('1318', 'admin', '117.22.144.255', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 03:24:15');
INSERT INTO `sys_logininfor` VALUES ('1319', 'test', '117.22.144.255', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 03:30:42');
INSERT INTO `sys_logininfor` VALUES ('1320', 'test', '106.7.248.140', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-07 03:36:46');
INSERT INTO `sys_logininfor` VALUES ('1321', 'admin', '43.224.44.78', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 03:55:34');
INSERT INTO `sys_logininfor` VALUES ('1322', 'admin123', '43.224.44.78', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-07 03:55:40');
INSERT INTO `sys_logininfor` VALUES ('1323', 'admin123', '43.224.44.78', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 03:55:44');
INSERT INTO `sys_logininfor` VALUES ('1324', 'test', '117.22.144.255', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-07 06:21:19');
INSERT INTO `sys_logininfor` VALUES ('1325', 'test', '117.22.144.255', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 06:21:24');
INSERT INTO `sys_logininfor` VALUES ('1326', 'test', '60.173.215.59', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-07 07:59:56');
INSERT INTO `sys_logininfor` VALUES ('1327', 'test', '112.42.187.30', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-07 08:13:20');
INSERT INTO `sys_logininfor` VALUES ('1328', 'test', '58.215.14.58', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 08:21:22');
INSERT INTO `sys_logininfor` VALUES ('1329', 'test', '221.232.151.94', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 09:13:06');
INSERT INTO `sys_logininfor` VALUES ('1330', 'test', '119.181.166.62', 'XX XX', 'Internet Explorer 11', 'Windows 10', '0', '登录成功', '2020-11-07 09:23:15');
INSERT INTO `sys_logininfor` VALUES ('1331', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 09:29:49');
INSERT INTO `sys_logininfor` VALUES ('1332', 'test', '103.107.216.231', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 09:50:19');
INSERT INTO `sys_logininfor` VALUES ('1333', 'test', '113.89.2.4', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 09:54:25');
INSERT INTO `sys_logininfor` VALUES ('1334', 'test', '36.106.66.164', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 10:25:08');
INSERT INTO `sys_logininfor` VALUES ('1335', 'admin', '223.244.119.109', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 10:30:42');
INSERT INTO `sys_logininfor` VALUES ('1336', 'test', '117.151.99.116', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 10:30:58');
INSERT INTO `sys_logininfor` VALUES ('1337', 'test', '117.151.99.116', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 10:32:08');
INSERT INTO `sys_logininfor` VALUES ('1338', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 11:48:28');
INSERT INTO `sys_logininfor` VALUES ('1339', 'admin', '1.82.170.208', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-07 12:32:45');
INSERT INTO `sys_logininfor` VALUES ('1340', 'admin', '1.82.170.208', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '用户不存在/密码错误', '2020-11-07 12:32:49');
INSERT INTO `sys_logininfor` VALUES ('1341', 'test', '183.193.184.253', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-07 12:40:34');
INSERT INTO `sys_logininfor` VALUES ('1342', 'test', '183.193.184.253', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 12:40:56');
INSERT INTO `sys_logininfor` VALUES ('1343', 'test', '183.193.184.253', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 13:16:09');
INSERT INTO `sys_logininfor` VALUES ('1344', 'test', '183.95.50.174', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 13:30:23');
INSERT INTO `sys_logininfor` VALUES ('1345', 'test', '117.132.191.233', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 14:09:30');
INSERT INTO `sys_logininfor` VALUES ('1346', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:11:48');
INSERT INTO `sys_logininfor` VALUES ('1347', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:12:21');
INSERT INTO `sys_logininfor` VALUES ('1348', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:14:19');
INSERT INTO `sys_logininfor` VALUES ('1349', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:29:28');
INSERT INTO `sys_logininfor` VALUES ('1350', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:30:12');
INSERT INTO `sys_logininfor` VALUES ('1351', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 14:33:53');
INSERT INTO `sys_logininfor` VALUES ('1352', 'test', '14.153.186.248', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-07 16:17:24');
INSERT INTO `sys_logininfor` VALUES ('1353', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 16:27:07');
INSERT INTO `sys_logininfor` VALUES ('1354', 'test', '180.119.178.116', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 17:04:48');
INSERT INTO `sys_logininfor` VALUES ('1355', 'test', '14.222.100.13', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-07 23:57:43');
INSERT INTO `sys_logininfor` VALUES ('1356', 'test', '180.158.28.75', 'XX XX', 'Chrome 8', 'Mac OS X', '1', '验证码错误', '2020-11-08 01:44:44');
INSERT INTO `sys_logininfor` VALUES ('1357', 'test', '180.158.28.75', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-08 01:44:48');
INSERT INTO `sys_logininfor` VALUES ('1358', '55', '111.36.10.6', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 02:09:13');
INSERT INTO `sys_logininfor` VALUES ('1359', 'test', '120.244.218.192', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 02:39:45');
INSERT INTO `sys_logininfor` VALUES ('1360', 'test', '222.84.46.116', 'XX XX', 'Chrome', 'Windows 7', '0', '登录成功', '2020-11-08 02:39:59');
INSERT INTO `sys_logininfor` VALUES ('1361', 'test', '125.77.87.44', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-08 03:20:31');
INSERT INTO `sys_logininfor` VALUES ('1362', 'test', '114.250.171.217', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 03:22:20');
INSERT INTO `sys_logininfor` VALUES ('1363', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 04:59:39');
INSERT INTO `sys_logininfor` VALUES ('1364', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-08 05:00:00');
INSERT INTO `sys_logininfor` VALUES ('1365', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 05:00:05');
INSERT INTO `sys_logininfor` VALUES ('1366', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '退出成功', '2020-11-08 05:01:03');
INSERT INTO `sys_logininfor` VALUES ('1367', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 05:01:27');
INSERT INTO `sys_logininfor` VALUES ('1368', 'test', '58.249.110.108', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 06:52:28');
INSERT INTO `sys_logininfor` VALUES ('1369', 'test', '211.97.114.217', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-08 07:52:01');
INSERT INTO `sys_logininfor` VALUES ('1370', 'test', '58.16.228.217', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-08 08:39:21');
INSERT INTO `sys_logininfor` VALUES ('1371', 'test', '119.127.52.103', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-08 09:51:29');
INSERT INTO `sys_logininfor` VALUES ('1372', 'test', '119.127.52.103', 'XX XX', 'Chrome', 'Windows 10', '1', '验证码错误', '2020-11-08 09:51:40');
INSERT INTO `sys_logininfor` VALUES ('1373', 'test', '119.127.52.103', 'XX XX', 'Chrome', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 09:51:46');
INSERT INTO `sys_logininfor` VALUES ('1374', 'test', '119.127.52.103', 'XX XX', 'Chrome', 'Windows 10', '0', '登录成功', '2020-11-08 09:52:12');
INSERT INTO `sys_logininfor` VALUES ('1375', 'admin', '117.89.193.27', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 10:37:40');
INSERT INTO `sys_logininfor` VALUES ('1376', 'test', '117.89.193.27', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 10:38:15');
INSERT INTO `sys_logininfor` VALUES ('1377', 'test', '113.118.217.242', 'XX XX', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2020-11-08 11:18:28');
INSERT INTO `sys_logininfor` VALUES ('1378', 'admin', '14.155.91.108', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 11:45:00');
INSERT INTO `sys_logininfor` VALUES ('1379', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 12:06:56');
INSERT INTO `sys_logininfor` VALUES ('1380', 'test', '119.98.221.23', 'XX XX', 'Chrome 8', 'Mac OS X', '0', '登录成功', '2020-11-08 12:07:28');
INSERT INTO `sys_logininfor` VALUES ('1381', 'test', '113.46.221.182', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 12:33:01');
INSERT INTO `sys_logininfor` VALUES ('1382', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 13:07:44');
INSERT INTO `sys_logininfor` VALUES ('1383', 'admin', '117.81.246.72', 'XX XX', 'Chrome 8', 'Windows 10', '1', '验证码已失效', '2020-11-08 13:43:19');
INSERT INTO `sys_logininfor` VALUES ('1384', 'admin', '117.81.246.72', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 13:43:22');
INSERT INTO `sys_logininfor` VALUES ('1385', 'system', '117.81.246.72', 'XX XX', 'Chrome 8', 'Windows 10', '1', '用户不存在/密码错误', '2020-11-08 13:43:36');
INSERT INTO `sys_logininfor` VALUES ('1386', 'test', '222.209.33.80', 'XX XX', 'Firefox 8', 'Windows 10', '0', '登录成功', '2020-11-08 14:07:17');
INSERT INTO `sys_logininfor` VALUES ('1387', 'admin', '223.244.121.171', 'XX XX', 'Chrome 8', 'Windows 10', '0', '登录成功', '2020-11-08 14:20:08');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `is_frame` int(11) DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2074 DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '系统管理', '0', '70', 'system', null, '1', 'M', '0', '0', '', 'system', 'admin', '2018-03-16 11:33:00', 'admin', '2020-10-22 01:22:01', '系统管理目录');
INSERT INTO `sys_menu` VALUES ('2', '系统监控', '0', '90', 'monitor', null, '1', 'M', '0', '0', '', 'monitor', 'admin', '2018-03-16 11:33:00', 'admin', '2020-10-22 01:22:31', '系统监控目录');
INSERT INTO `sys_menu` VALUES ('3', '系统工具', '0', '80', 'tool', null, '1', 'M', '0', '0', '', 'tool', 'admin', '2018-03-16 11:33:00', 'admin', '2020-10-22 01:22:17', '系统工具目录');
INSERT INTO `sys_menu` VALUES ('4', '塬微官网', '0', '100', 'http://test.org', null, '0', 'M', '0', '0', '', 'guide', 'admin', '2018-03-16 11:33:00', 'admin', '2020-10-22 01:22:43', '若依官网地址');
INSERT INTO `sys_menu` VALUES ('100', '用户管理', '1', '1', 'user', 'system/user/index', '1', 'C', '0', '0', 'system:user:list', 'user', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '用户管理菜单');
INSERT INTO `sys_menu` VALUES ('101', '角色管理', '1', '2', 'role', 'system/role/index', '1', 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '角色管理菜单');
INSERT INTO `sys_menu` VALUES ('102', '菜单管理', '1', '3', 'menu', 'system/menu/index', '1', 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES ('103', '部门管理', '1', '4', 'dept', 'system/dept/index', '1', 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '部门管理菜单');
INSERT INTO `sys_menu` VALUES ('104', '岗位管理', '1', '5', 'post', 'system/post/index', '1', 'C', '0', '0', 'system:post:list', 'post', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '岗位管理菜单');
INSERT INTO `sys_menu` VALUES ('105', '字典管理', '1', '6', 'dict', 'system/dict/index', '1', 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '字典管理菜单');
INSERT INTO `sys_menu` VALUES ('106', '参数设置', '1', '7', 'config', 'system/config/index', '1', 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '参数设置菜单');
INSERT INTO `sys_menu` VALUES ('107', '通知公告', '1', '8', 'notice', 'system/notice/index', '1', 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '通知公告菜单');
INSERT INTO `sys_menu` VALUES ('108', '日志管理', '1', '9', 'log', 'system/log/index', '1', 'M', '0', '0', '', 'log', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '日志管理菜单');
INSERT INTO `sys_menu` VALUES ('109', '在线用户', '2', '1', 'online', 'monitor/online/index', '1', 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '在线用户菜单');
INSERT INTO `sys_menu` VALUES ('110', '定时任务', '2', '2', 'job', 'monitor/job/index', '1', 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '定时任务菜单');
INSERT INTO `sys_menu` VALUES ('111', '数据监控', '2', '3', 'druid', 'monitor/druid/index', '1', 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '数据监控菜单');
INSERT INTO `sys_menu` VALUES ('112', '服务监控', '2', '4', 'server', 'monitor/server/index', '1', 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '服务监控菜单');
INSERT INTO `sys_menu` VALUES ('113', '表单构建', '3', '1', 'build', 'tool/build/index', '1', 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '表单构建菜单');
INSERT INTO `sys_menu` VALUES ('114', '代码生成', '3', '2', 'gen', 'tool/gen/index', '1', 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '代码生成菜单');
INSERT INTO `sys_menu` VALUES ('115', '系统接口', '3', '3', 'swagger', 'tool/swagger/index', '1', 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '系统接口菜单');
INSERT INTO `sys_menu` VALUES ('500', '操作日志', '108', '1', 'operlog', 'monitor/operlog/index', '1', 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '操作日志菜单');
INSERT INTO `sys_menu` VALUES ('501', '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '1', 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '登录日志菜单');
INSERT INTO `sys_menu` VALUES ('1001', '用户查询', '100', '1', '', '', '1', 'F', '0', '0', 'system:user:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1002', '用户新增', '100', '2', '', '', '1', 'F', '0', '0', 'system:user:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1003', '用户修改', '100', '3', '', '', '1', 'F', '0', '0', 'system:user:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1004', '用户删除', '100', '4', '', '', '1', 'F', '0', '0', 'system:user:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1005', '用户导出', '100', '5', '', '', '1', 'F', '0', '0', 'system:user:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1006', '用户导入', '100', '6', '', '', '1', 'F', '0', '0', 'system:user:import', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1007', '重置密码', '100', '7', '', '', '1', 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1008', '角色查询', '101', '1', '', '', '1', 'F', '0', '0', 'system:role:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1009', '角色新增', '101', '2', '', '', '1', 'F', '0', '0', 'system:role:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1010', '角色修改', '101', '3', '', '', '1', 'F', '0', '0', 'system:role:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1011', '角色删除', '101', '4', '', '', '1', 'F', '0', '0', 'system:role:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1012', '角色导出', '101', '5', '', '', '1', 'F', '0', '0', 'system:role:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1013', '菜单查询', '102', '1', '', '', '1', 'F', '0', '0', 'system:menu:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1014', '菜单新增', '102', '2', '', '', '1', 'F', '0', '0', 'system:menu:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1015', '菜单修改', '102', '3', '', '', '1', 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1016', '菜单删除', '102', '4', '', '', '1', 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1017', '部门查询', '103', '1', '', '', '1', 'F', '0', '0', 'system:dept:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1018', '部门新增', '103', '2', '', '', '1', 'F', '0', '0', 'system:dept:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1019', '部门修改', '103', '3', '', '', '1', 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1020', '部门删除', '103', '4', '', '', '1', 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1021', '岗位查询', '104', '1', '', '', '1', 'F', '0', '0', 'system:post:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1022', '岗位新增', '104', '2', '', '', '1', 'F', '0', '0', 'system:post:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1023', '岗位修改', '104', '3', '', '', '1', 'F', '0', '0', 'system:post:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1024', '岗位删除', '104', '4', '', '', '1', 'F', '0', '0', 'system:post:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1025', '岗位导出', '104', '5', '', '', '1', 'F', '0', '0', 'system:post:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1026', '字典查询', '105', '1', '#', '', '1', 'F', '0', '0', 'system:dict:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1027', '字典新增', '105', '2', '#', '', '1', 'F', '0', '0', 'system:dict:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1028', '字典修改', '105', '3', '#', '', '1', 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1029', '字典删除', '105', '4', '#', '', '1', 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1030', '字典导出', '105', '5', '#', '', '1', 'F', '0', '0', 'system:dict:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1031', '参数查询', '106', '1', '#', '', '1', 'F', '0', '0', 'system:config:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1032', '参数新增', '106', '2', '#', '', '1', 'F', '0', '0', 'system:config:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1033', '参数修改', '106', '3', '#', '', '1', 'F', '0', '0', 'system:config:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1034', '参数删除', '106', '4', '#', '', '1', 'F', '0', '0', 'system:config:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1035', '参数导出', '106', '5', '#', '', '1', 'F', '0', '0', 'system:config:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1036', '公告查询', '107', '1', '#', '', '1', 'F', '0', '0', 'system:notice:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1037', '公告新增', '107', '2', '#', '', '1', 'F', '0', '0', 'system:notice:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1038', '公告修改', '107', '3', '#', '', '1', 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1039', '公告删除', '107', '4', '#', '', '1', 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1040', '操作查询', '500', '1', '#', '', '1', 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1041', '操作删除', '500', '2', '#', '', '1', 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1042', '日志导出', '500', '4', '#', '', '1', 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1043', '登录查询', '501', '1', '#', '', '1', 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1044', '登录删除', '501', '2', '#', '', '1', 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1045', '日志导出', '501', '3', '#', '', '1', 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1046', '在线查询', '109', '1', '#', '', '1', 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1047', '批量强退', '109', '2', '#', '', '1', 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1048', '单条强退', '109', '3', '#', '', '1', 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1049', '任务查询', '110', '1', '#', '', '1', 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1050', '任务新增', '110', '2', '#', '', '1', 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1051', '任务修改', '110', '3', '#', '', '1', 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1052', '任务删除', '110', '4', '#', '', '1', 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1053', '状态修改', '110', '5', '#', '', '1', 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1054', '任务导出', '110', '7', '#', '', '1', 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1055', '生成查询', '114', '1', '#', '', '1', 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1056', '生成修改', '114', '2', '#', '', '1', 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1057', '生成删除', '114', '3', '#', '', '1', 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1058', '导入代码', '114', '2', '#', '', '1', 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1059', '预览代码', '114', '4', '#', '', '1', 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('1060', '生成代码', '114', '5', '#', '', '1', 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_menu` VALUES ('2001', '客户管理', '0', '1', 'customerManage', null, '1', 'M', '0', '0', '', 'user', 'admin', '2020-10-20 22:03:52', 'admin', '2020-10-20 22:26:33', '');
INSERT INTO `sys_menu` VALUES ('2002', '客户', '2001', '10', 'customer', 'customerManage/customer', '1', 'C', '0', '0', 'customerManage:customer:list', '#', 'admin', '2020-10-20 22:15:31', 'admin', '2020-10-20 22:28:09', '');
INSERT INTO `sys_menu` VALUES ('2003', '客户群', '2001', '20', 'group', 'customerManage/group', '1', 'C', '0', '0', 'customerManage:group:list', '#', 'admin', '2020-10-20 22:32:55', '', null, '');
INSERT INTO `sys_menu` VALUES ('2004', '客户标签', '2001', '30', 'tag', 'customerManage/tag', '1', 'C', '0', '0', 'customerManage:tag:list', '#', 'admin', '2020-10-20 22:33:45', '', null, '');
INSERT INTO `sys_menu` VALUES ('2005', '离职继承', '2001', '40', 'dimission', 'customerManage/dimission/index', '1', 'C', '0', '0', 'customerManage:dimission:list', '#', 'admin', '2020-10-20 22:34:59', 'admin', '2020-10-28 15:11:40', '');
INSERT INTO `sys_menu` VALUES ('2006', '客户详情', '2001', '11', 'customerDetail', 'customerManage/customerDetail', '1', 'C', '1', '0', 'customerManage:customerDetail:list', '#', 'admin', '2020-10-20 22:37:06', 'admin', '2020-10-22 01:18:43', '');
INSERT INTO `sys_menu` VALUES ('2007', '客户群详情', '2001', '21', 'groupDetail', 'customerManage/groupDetail', '1', 'C', '1', '0', 'customerManage:groupDetail:list', '#', 'admin', '2020-10-20 22:37:59', 'admin', '2020-10-22 01:18:57', '');
INSERT INTO `sys_menu` VALUES ('2008', '通信录', '0', '50', 'contacts', null, '1', 'M', '0', '0', '', 'tree-table', 'admin', '2020-10-20 22:40:17', 'admin', '2020-10-22 01:17:14', '');
INSERT INTO `sys_menu` VALUES ('2009', '组织架构', '2008', '10', 'organization', 'contacts/organization', '1', 'C', '0', '0', 'contacts:organization:list', 'tree', 'admin', '2020-10-20 22:46:05', '', null, '');
INSERT INTO `sys_menu` VALUES ('2010', '企业微信管理', '0', '60', '_enterpriseWechat', null, '1', 'M', '0', '0', '', 'wechat', 'admin', '2020-10-20 22:48:05', 'admin', '2020-11-01 14:55:53', '');
INSERT INTO `sys_menu` VALUES ('2011', '企业微信管理', '2010', '10', '/enterpriseWechat', 'enterpriseWechat/list', '1', 'C', '0', '0', 'enterpriseWechat:list:list', 'wechat', 'admin', '2020-10-20 22:49:32', 'admin', '2020-10-21 22:12:59', '');
INSERT INTO `sys_menu` VALUES ('2012', '查询', '2002', '1', '', null, '1', 'F', '0', '0', 'customerManage:customer:query', '#', 'admin', '2020-10-22 18:18:08', 'admin', '2020-10-22 18:20:32', '');
INSERT INTO `sys_menu` VALUES ('2013', '导出列表', '2002', '2', '', null, '1', 'F', '0', '0', 'customerManage:customer:export', '#', 'admin', '2020-10-22 18:22:39', '', null, '');
INSERT INTO `sys_menu` VALUES ('2014', '打标签', '2002', '3', '', null, '1', 'F', '0', '0', 'customerManage/customer:makeTag', '#', 'admin', '2020-10-22 18:25:47', '', null, '');
INSERT INTO `sys_menu` VALUES ('2015', '移出标签', '2002', '4', '', null, '1', 'F', '0', '0', 'customerManage:customer:removeTag', '#', 'admin', '2020-10-22 18:26:24', '', null, '');
INSERT INTO `sys_menu` VALUES ('2016', '同步客户', '2002', '5', '', null, '1', 'F', '0', '0', 'customerManage:customer:sync', '#', 'admin', '2020-10-22 18:28:27', '', null, '');
INSERT INTO `sys_menu` VALUES ('2017', '查看重复客户', '2002', '6', '', null, '1', 'F', '0', '0', 'customerManage:customer:checkRepeat', '#', 'admin', '2020-10-22 18:30:01', '', null, '');
INSERT INTO `sys_menu` VALUES ('2018', '查询', '2003', '1', '', null, '1', 'F', '0', '0', 'customerManage:group:query', '#', 'admin', '2020-10-22 18:33:29', '', null, '');
INSERT INTO `sys_menu` VALUES ('2019', '导出列表', '2003', '2', '', null, '1', 'F', '0', '0', 'customerManage:group:export', '#', 'admin', '2020-10-22 18:34:43', '', null, '');
INSERT INTO `sys_menu` VALUES ('2020', '同步客户群', '2003', '3', '', null, '1', 'F', '0', '0', 'customerManage:group:sync', '#', 'admin', '2020-10-22 18:35:13', '', null, '');
INSERT INTO `sys_menu` VALUES ('2021', '查看详情', '2003', '4', '', null, '1', 'F', '0', '0', 'customerManage:group:view', '#', 'admin', '2020-10-22 18:40:52', '', null, '');
INSERT INTO `sys_menu` VALUES ('2022', '查看详情', '2002', '7', '', null, '1', 'F', '0', '0', 'customerManage:customer:view', '#', 'admin', '2020-10-22 18:43:41', '', null, '');
INSERT INTO `sys_menu` VALUES ('2023', '新增标签组', '2004', '1', '', null, '1', 'F', '0', '0', 'customerManage:tag:add', '#', 'admin', '2020-10-22 18:46:02', '', null, '');
INSERT INTO `sys_menu` VALUES ('2024', '同步标签组', '2004', '2', '', null, '1', 'F', '0', '0', 'customerManage:tag:sync', '#', 'admin', '2020-10-22 18:46:33', '', null, '');
INSERT INTO `sys_menu` VALUES ('2025', '编辑', '2004', '3', '', null, '1', 'F', '0', '0', 'customerManage:tag:edit', '#', 'admin', '2020-10-22 18:47:00', '', null, '');
INSERT INTO `sys_menu` VALUES ('2026', '删除', '2004', '4', '', null, '1', 'F', '0', '0', 'customerManage:tag:remove', '#', 'admin', '2020-10-22 18:47:20', '', null, '');
INSERT INTO `sys_menu` VALUES ('2027', '查询', '2005', '1', '', null, '1', 'F', '0', '0', 'customerManage:dimission:query', '#', 'admin', '2020-10-22 18:49:36', '', null, '');
INSERT INTO `sys_menu` VALUES ('2028', '已分配的离职员工', '2005', '2', '', null, '1', 'F', '0', '0', 'customerManage:dimission:filter', '#', 'admin', '2020-10-22 18:55:40', '', null, '');
INSERT INTO `sys_menu` VALUES ('2029', '分配发给其他员工', '2005', '3', '', null, '1', 'F', '0', '0', 'customerManage:dimission:allocate', '#', 'admin', '2020-10-22 18:56:28', '', null, '');
INSERT INTO `sys_menu` VALUES ('2030', '编辑', '2005', '3', '', null, '1', 'F', '0', '0', 'customerManage:dimission:edit', '#', 'admin', '2020-10-22 18:57:40', '', null, '');
INSERT INTO `sys_menu` VALUES ('2031', '查询', '2009', '1', '', null, '1', 'F', '0', '0', 'contacts:organization:query', '#', 'admin', '2020-10-22 18:59:24', '', null, '');
INSERT INTO `sys_menu` VALUES ('2032', '同步成员', '2009', '2', '', null, '1', 'F', '0', '0', 'contacts:organization:sync', '#', 'admin', '2020-10-22 19:00:32', '', null, '');
INSERT INTO `sys_menu` VALUES ('2033', '批量导入', '2009', '3', '', null, '1', 'F', '0', '0', 'contacts:organization:import', '#', 'admin', '2020-10-22 19:00:59', '', null, '');
INSERT INTO `sys_menu` VALUES ('2034', '添加成员', '2009', '4', '', null, '1', 'F', '0', '0', 'contacts:organization:addMember', '#', 'admin', '2020-10-22 19:01:54', '', null, '');
INSERT INTO `sys_menu` VALUES ('2035', '查看成员详情', '2009', '5', '', null, '1', 'F', '0', '0', 'contacts:organization:view', '#', 'admin', '2020-10-22 19:06:40', '', null, '');
INSERT INTO `sys_menu` VALUES ('2036', '启用/禁用成员', '2009', '6', '', null, '1', 'F', '0', '0', 'contacts:organization:setStatus', '#', 'admin', '2020-10-22 19:08:35', 'admin', '2020-10-28 11:05:50', '');
INSERT INTO `sys_menu` VALUES ('2037', '激活成员', '2009', '7', '', null, '1', 'F', '0', '0', 'contacts:organization:active', '#', 'admin', '2020-10-22 19:10:14', '', null, '');
INSERT INTO `sys_menu` VALUES ('2038', '编辑成员', '2009', '8', '', null, '1', 'F', '0', '0', 'contacts:organization:edit', '#', 'admin', '2020-10-22 19:10:41', 'admin', '2020-10-22 19:11:00', '');
INSERT INTO `sys_menu` VALUES ('2039', '添加部门', '2009', '9', '', null, '1', 'F', '0', '0', 'contacts:organization:addDep', '#', 'admin', '2020-10-22 19:13:21', 'admin', '2020-10-22 19:14:36', '');
INSERT INTO `sys_menu` VALUES ('2040', '编辑部门', '2009', '10', '', null, '1', 'F', '0', '0', 'contacts:organization:editDep', '#', 'admin', '2020-10-22 19:14:24', '', null, '');
INSERT INTO `sys_menu` VALUES ('2041', '查询', '2011', '1', '', null, '1', 'F', '0', '0', 'enterpriseWechat:query', '#', 'admin', '2020-10-22 19:17:03', '', null, '');
INSERT INTO `sys_menu` VALUES ('2042', '添加', '2011', '2', '', null, '1', 'F', '0', '0', 'enterpriseWechat:add', '#', 'admin', '2020-10-22 19:26:56', '', null, '');
INSERT INTO `sys_menu` VALUES ('2043', '查看', '2011', '3', '', null, '1', 'F', '0', '0', 'enterpriseWechat:view', '#', 'admin', '2020-10-22 19:28:02', 'admin', '2020-10-22 19:28:14', '');
INSERT INTO `sys_menu` VALUES ('2044', '编辑', '2011', '4', '', null, '1', 'F', '0', '0', 'enterpriseWechat:edit', '#', 'admin', '2020-10-22 19:29:28', '', null, '');
INSERT INTO `sys_menu` VALUES ('2045', '激活', '2011', '5', '', null, '1', 'F', '0', '0', 'enterpriseWechat:active', '#', 'admin', '2020-10-22 19:29:58', 'admin', '2020-10-22 19:33:40', '');
INSERT INTO `sys_menu` VALUES ('2046', '禁用', '2011', '6', '', null, '1', 'F', '0', '0', 'enterpriseWechat:forbidden', '#', 'admin', '2020-10-22 19:34:53', 'admin', '2020-10-22 19:35:00', '');
INSERT INTO `sys_menu` VALUES ('2047', '删除成员', '2009', '6', '', null, '1', 'F', '0', '0', 'contacts:organization:remove', '#', 'admin', '2020-10-28 13:48:23', 'admin', '2020-10-28 11:08:24', '');
INSERT INTO `sys_menu` VALUES ('2048', '已分配客户', '2005', '7', '', null, '1', 'F', '0', '0', 'wecom:user:getAllocateCustomers', '#', 'admin', '2020-10-28 13:50:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2049', '已分配的群', '2005', '8', '', null, '1', 'F', '0', '0', 'wecom:user:getAllocateGroups', '#', 'admin', '2020-10-28 13:50:42', '', null, '');
INSERT INTO `sys_menu` VALUES ('2050', '已分配离职员工', '2001', '41', 'allocatedStaffList', 'customerManage/dimission/allocatedStaffList', '1', 'C', '1', '0', 'customerManage/dimission/allocatedStaffList:list', '#', 'admin', '2020-10-28 15:11:17', 'admin', '2020-10-28 15:22:21', '');
INSERT INTO `sys_menu` VALUES ('2051', '已分配离职员工详情', '2001', '42', 'allocatedStaffDetail', 'customerManage/dimission/allocatedStaffDetail', '1', 'C', '1', '0', 'customerManage/dimission/allocatedStaffDetail:list', '#', 'admin', '2020-10-28 15:12:49', 'admin', '2020-10-28 15:22:49', '');
INSERT INTO `sys_menu` VALUES ('2052', '引流码', '0', '20', '/drainageCode', null, '1', 'M', '0', '0', null, 'qrcode', 'admin', '2020-11-08 12:11:44', '', null, '');
INSERT INTO `sys_menu` VALUES ('2053', '员工活码', '2052', '10', 'staff', '/drainageCode/staff/list', '1', 'C', '0', '0', 'drainageCode:staff:list', '#', 'admin', '2020-11-08 12:13:21', '', null, '');
INSERT INTO `sys_menu` VALUES ('2054', '新建员工活码', '2052', '20', 'staffAdd', 'drainageCode/staff/add', '1', 'C', '1', '0', 'drainageCode:staff:add', '#', 'admin', '2020-11-08 12:14:55', '', null, '');
INSERT INTO `sys_menu` VALUES ('2055', '员工活码详情', '2052', '30', 'staffDetail', 'drainageCode/staff/detail', '1', 'C', '1', '0', 'drainageCode:staff:detail', '#', 'admin', '2020-11-08 12:19:19', 'admin', '2020-11-08 12:20:59', '');
INSERT INTO `sys_menu` VALUES ('2056', '客户群活码', '2052', '40', 'group', 'drainageCode/group/list', '1', 'C', '0', '0', 'drainageCode:group:list', '#', 'admin', '2020-11-08 12:26:15', '', null, '');
INSERT INTO `sys_menu` VALUES ('2057', '新增客户群活码', '2052', '50', 'groupAdd', '/drainageCode/group/add', '1', 'C', '1', '0', 'drainageCode:group:add', '#', 'admin', '2020-11-08 12:30:00', '', null, '');
INSERT INTO `sys_menu` VALUES ('2058', '客户群活码信息', '2052', '60', 'groupDetail', 'drainageCode/group/detail', '1', 'C', '1', '0', 'drainageCode:group:detail', '#', 'admin', '2020-11-08 12:31:41', 'admin', '2020-11-08 12:31:51', '');
INSERT INTO `sys_menu` VALUES ('2059', '客户群信息', '2052', '70', 'groupBaseInfo', 'drainageCode/group/baseInfo', '1', 'C', '1', '0', 'drainageCode:group:baseInfo', '#', 'admin', '2020-11-08 12:38:51', '', null, '');
INSERT INTO `sys_menu` VALUES ('2060', '欢迎语', '2052', '80', 'welcome', 'drainageCode/welcome/list', '1', 'C', '0', '0', 'drainageCode:welcome:list', '#', 'admin', '2020-11-08 12:39:34', '', null, '');
INSERT INTO `sys_menu` VALUES ('2061', '新建欢迎语', '2052', '90', 'welcomeAdd', 'drainageCode/welcome/add', '1', 'C', '1', '0', 'drainageCode:welcome:add', '#', 'admin', '2020-11-08 12:40:12', '', null, '');
INSERT INTO `sys_menu` VALUES ('2062', '素材中心', '0', '30', '/material', null, '1', 'M', '0', '0', null, 'material', 'admin', '2020-11-08 12:41:21', '', null, '');
INSERT INTO `sys_menu` VALUES ('2063', '文本', '2062', '10', 'text', 'material/text', '1', 'C', '0', '0', 'material:text', '#', 'admin', '2020-11-08 12:42:44', '', null, '');
INSERT INTO `sys_menu` VALUES ('2064', '图片', '2062', '20', 'image', 'material/image', '1', 'C', '0', '0', 'material:image', '#', 'admin', '2020-11-08 12:43:22', '', null, '');
INSERT INTO `sys_menu` VALUES ('2065', '语音', '2062', '30', 'audio', 'material/audio', '1', 'C', '0', '0', 'material:audio', '#', 'admin', '2020-11-08 12:44:19', '', null, '');
INSERT INTO `sys_menu` VALUES ('2066', '视频', '2062', '40', 'video', 'material/video', '1', 'C', '0', '0', 'material:video', '#', 'admin', '2020-11-08 12:44:52', '', null, '');
INSERT INTO `sys_menu` VALUES ('2067', '文件', '2062', '50', 'file', 'material/file', '1', 'C', '0', '0', 'material:file', '#', 'admin', '2020-11-08 12:45:22', '', null, '');
INSERT INTO `sys_menu` VALUES ('2068', '添加分类', '2062', '101', '', null, '1', 'F', '0', '0', 'material:addType', '#', 'admin', '2020-11-08 12:59:08', 'admin', '2020-11-08 13:00:11', '');
INSERT INTO `sys_menu` VALUES ('2069', '删除分类', '2062', '102', '', null, '1', 'F', '0', '0', 'material:removeType', '#', 'admin', '2020-11-08 13:02:40', '', null, '');
INSERT INTO `sys_menu` VALUES ('2070', '编辑分类', '2062', '103', '', null, '1', 'F', '0', '0', 'material:edit', '#', 'admin', '2020-11-08 13:03:38', '', null, '');
INSERT INTO `sys_menu` VALUES ('2071', '添加素材', '2062', '104', '', null, '1', 'F', '0', '0', 'material:add', '#', 'admin', '2020-11-08 13:04:22', '', null, '');
INSERT INTO `sys_menu` VALUES ('2072', '删除素材', '2062', '105', '', null, '1', 'F', '0', '0', 'material:remove', '#', 'admin', '2020-11-08 13:04:57', '', null, '');
INSERT INTO `sys_menu` VALUES ('2073', '编辑素材', '2062', '106', '', null, '1', 'F', '0', '0', 'material:edit', '#', 'admin', '2020-11-08 13:05:22', '', null, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` varchar(2000) DEFAULT NULL COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='通知公告表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES ('1', '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '管理员');
INSERT INTO `sys_notice` VALUES ('2', '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int(11) DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int(11) DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(50) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int(11) DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`oper_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1111 DEFAULT CHARSET=utf8mb4 COMMENT='操作日志记录';

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES ('829', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.155.87', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-28 07:22:28');
INSERT INTO `sys_oper_log` VALUES ('830', '角色管理', '2', 'com.linkwechat.web.controller.system.SysRoleController.edit()', 'PUT', '1', 'admin', null, '/system/role', '36.5.155.87', 'XX XX', '{\"flag\":false,\"roleId\":2,\"admin\":false,\"remark\":\"普通角色\",\"updateTime\":1603869849000,\"dataScope\":\"2\",\"delFlag\":\"0\",\"params\":{},\"roleSort\":\"2\",\"createTime\":1521171180000,\"updateBy\":\"admin\",\"roleKey\":\"common\",\"roleName\":\"测试用户\",\"menuIds\":[2012,2014,2015,2016,2022,2006,2018,2020,2021,2007,2004,2023,2024,2025,2026,2031,2032,2034,2035,2036,2037,2038,2039,2040,2001,2002,2003,2008,2009],\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:24:21');
INSERT INTO `sys_oper_log` VALUES ('831', '角色管理', '2', 'com.linkwechat.web.controller.system.SysRoleController.edit()', 'PUT', '1', 'admin', null, '/system/role', '36.5.155.87', 'XX XX', '{\"flag\":false,\"roleId\":2,\"admin\":false,\"remark\":\"普通角色\",\"updateTime\":1603870326000,\"dataScope\":\"2\",\"delFlag\":\"0\",\"params\":{},\"roleSort\":\"2\",\"createTime\":1521171180000,\"updateBy\":\"admin\",\"roleKey\":\"common\",\"roleName\":\"测试用户\",\"menuIds\":[2012,2014,2015,2016,2022,2006,2018,2020,2021,2007,2004,2023,2024,2025,2026,2031,2032,2034,2035,2036,2037,2038,2001,2002,2003,2008,2009],\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:32:33');
INSERT INTO `sys_oper_log` VALUES ('832', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '36.5.155.87', 'XX XX', '{\"birthday\":1601481600000,\"gender\":1,\"joinTime\":1601481600000,\"idCard\":\"\",\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"盛锡勇\",\"alias\":\"HaoN\",\"position\":\"JAVA开发工程师\",\"department\":[\"4294967295\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:34:45');
INSERT INTO `sys_oper_log` VALUES ('833', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '36.5.155.87', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"joinTime\":1601481600000,\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"盛浩南\",\"department\":[\"1\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:36:18');
INSERT INTO `sys_oper_log` VALUES ('834', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '127.0.0.1', '内网IP', '{\"gender\":1,\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"盛锡勇\",\"department\":[\"4294967295\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:41:48');
INSERT INTO `sys_oper_log` VALUES ('835', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '127.0.0.1', '内网IP', '{\"gender\":1,\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"盛浩南\",\"department\":[\"4294967295\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:42:23');
INSERT INTO `sys_oper_log` VALUES ('836', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '127.0.0.1', '内网IP', '{\"gender\":1,\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"HaoN\",\"department\":[\"4294967295\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 07:42:59');
INSERT INTO `sys_oper_log` VALUES ('837', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.197', 'XX XX', '{\"visible\":\"0\",\"icon\":\"#\",\"orderNum\":\"6\",\"menuName\":\"禁用成员\",\"updateTime\":1603882698000,\"params\":{},\"parentId\":2009,\"path\":\"\",\"children\":[],\"createTime\":1603364915000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2036,\"menuType\":\"F\",\"perms\":\"contacts:organization:setStatus\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 11:03:01');
INSERT INTO `sys_oper_log` VALUES ('838', '菜单管理', '3', 'com.linkwechat.web.controller.system.SysMenuController.remove()', 'DELETE', '1', 'admin', null, '/system/menu/2037', '223.244.118.197', 'XX XX', '{menuId=2037}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":500}', '0', null, '2020-10-28 11:03:34');
INSERT INTO `sys_oper_log` VALUES ('839', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.197', 'XX XX', '{\"visible\":\"0\",\"icon\":\"#\",\"orderNum\":\"6\",\"menuName\":\"启用/禁用成员\",\"updateTime\":1603883140000,\"params\":{},\"parentId\":2009,\"path\":\"\",\"children\":[],\"createTime\":1603364915000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2036,\"menuType\":\"F\",\"perms\":\"contacts:organization:setStatus\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 11:05:50');
INSERT INTO `sys_oper_log` VALUES ('840', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.197', 'XX XX', '{\"visible\":\"0\",\"icon\":\"#\",\"orderNum\":\"6\",\"menuName\":\"删除成员\",\"updateTime\":1603883297000,\"params\":{},\"parentId\":2009,\"path\":\"\",\"children\":[],\"createTime\":1603864103000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2047,\"menuType\":\"F\",\"perms\":\"contacts:organization:remove\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 11:08:24');
INSERT INTO `sys_oper_log` VALUES ('841', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'admin', null, '/wecom/user', '223.244.118.93', 'XX XX', '{\"gender\":1,\"mobile\":\"846456\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"2+6\",\"name\":\"464\",\"alias\":\"52+\",\"department\":[\"1\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 13:48:40');
INSERT INTO `sys_oper_log` VALUES ('842', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'admin', null, '/wecom/user', '223.244.118.93', 'XX XX', '{\"gender\":1,\"mobile\":\"846456\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"2+6\",\"name\":\"464\",\"alias\":\"52+\",\"department\":[\"1\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 13:48:46');
INSERT INTO `sys_oper_log` VALUES ('843', '代码生成', '6', 'com.linkwechat.generator.controller.GenController.importTableSave()', 'POST', '1', 'admin', null, '/tool/gen/importTable', '127.0.0.1', '内网IP', 'we_message_push', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 13:49:05');
INSERT INTO `sys_oper_log` VALUES ('844', '代码生成', '3', 'com.linkwechat.generator.controller.GenController.remove()', 'DELETE', '1', 'admin', null, '/tool/gen/24', '127.0.0.1', '内网IP', '{tableIds=24}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 13:58:10');
INSERT INTO `sys_oper_log` VALUES ('845', '代码生成', '6', 'com.linkwechat.generator.controller.GenController.importTableSave()', 'POST', '1', 'admin', null, '/tool/gen/importTable', '127.0.0.1', '内网IP', 'we_message_push', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 13:58:23');
INSERT INTO `sys_oper_log` VALUES ('846', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"41\",\"menuName\":\"已分配离职员工\",\"updateTime\":1603897877136,\"params\":{},\"parentId\":2001,\"path\":\"customerManage/dimission/allocatedStaffList.vue\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1603897877136,\"isFrame\":\"1\",\"menuType\":\"M\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:11:17');
INSERT INTO `sys_oper_log` VALUES ('847', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"0\",\"icon\":\"#\",\"orderNum\":\"40\",\"menuName\":\"离职继承\",\"updateTime\":1603897883000,\"params\":{},\"parentId\":2001,\"path\":\"dimission\",\"component\":\"customerManage/dimission/index\",\"children\":[],\"createTime\":1603204499000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2005,\"menuType\":\"C\",\"perms\":\"customerManage:dimission:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:11:41');
INSERT INTO `sys_oper_log` VALUES ('848', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"41\",\"menuName\":\"已分配离职员工\",\"updateTime\":1603897903000,\"params\":{},\"parentId\":2001,\"path\":\"customerManage/dimission/allocatedStaffList\",\"children\":[],\"createTime\":1603869077000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2050,\"menuType\":\"M\",\"perms\":\"\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:11:53');
INSERT INTO `sys_oper_log` VALUES ('849', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"42\",\"menuName\":\"已分配离职员工详情\",\"updateTime\":1603897969532,\"params\":{},\"parentId\":2001,\"path\":\"customerManage/dimission/allocatedStaffDetail\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1603897969532,\"isFrame\":\"1\",\"menuType\":\"M\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:12:49');
INSERT INTO `sys_oper_log` VALUES ('850', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"41\",\"menuName\":\"已分配离职员工\",\"updateTime\":1603898280000,\"params\":{},\"parentId\":2001,\"path\":\"customerManage/dimission/allocatedStaffList\",\"component\":\"customerManage/dimission/allocatedStaffList\",\"children\":[],\"createTime\":1603869077000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2050,\"menuType\":\"C\",\"perms\":\"customerManage/dimission/allocatedStaffList\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:19:58');
INSERT INTO `sys_oper_log` VALUES ('851', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"41\",\"menuName\":\"已分配离职员工\",\"updateTime\":1603898479000,\"params\":{},\"parentId\":2001,\"path\":\"allocatedStaffList\",\"component\":\"customerManage/dimission/allocatedStaffList\",\"children\":[],\"createTime\":1603869077000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2050,\"menuType\":\"C\",\"perms\":\"customerManage/dimission/allocatedStaffList:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:22:21');
INSERT INTO `sys_oper_log` VALUES ('852', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.118.93', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"42\",\"menuName\":\"已分配离职员工详情\",\"updateTime\":1603898545000,\"params\":{},\"parentId\":2001,\"path\":\"allocatedStaffDetail\",\"component\":\"customerManage/dimission/allocatedStaffDetail\",\"children\":[],\"createTime\":1603869169000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2051,\"menuType\":\"C\",\"perms\":\"customerManage/dimission/allocatedStaffDetail:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:22:49');
INSERT INTO `sys_oper_log` VALUES ('853', '企业微信组织架构相关', '1', 'com.linkwechat.web.controller.wecom.WeDepartmentController.add()', 'POST', '1', 'admin', null, '/wecom/department', '114.100.66.114', 'XX XX', '{\"name\":\"软件部\",\"id\":4294967294,\"parentId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:24:44');
INSERT INTO `sys_oper_log` VALUES ('854', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '180.161.100.81', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-28 15:27:27');
INSERT INTO `sys_oper_log` VALUES ('855', '代码生成', '8', 'com.linkwechat.generator.controller.GenController.batchGenCode()', 'GET', '1', 'admin', null, '/tool/gen/batchGenCode', '180.161.100.81', 'XX XX', '{}', 'null', '0', null, '2020-10-28 15:28:29');
INSERT INTO `sys_oper_log` VALUES ('856', '代码生成', '8', 'com.linkwechat.generator.controller.GenController.batchGenCode()', 'GET', '1', 'admin', null, '/tool/gen/batchGenCode', '180.161.100.81', 'XX XX', '{}', 'null', '0', null, '2020-10-28 15:28:30');
INSERT INTO `sys_oper_log` VALUES ('857', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', '123456 admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-10-28 15:56:45');
INSERT INTO `sys_oper_log` VALUES ('858', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', '123456 admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-10-28 15:56:53');
INSERT INTO `sys_oper_log` VALUES ('859', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', 'admin admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-10-28 15:56:59');
INSERT INTO `sys_oper_log` VALUES ('860', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', 'admin admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-10-28 15:57:02');
INSERT INTO `sys_oper_log` VALUES ('861', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', 'admin admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-10-28 15:57:03');
INSERT INTO `sys_oper_log` VALUES ('862', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '183.160.224.249', 'XX XX', 'admin123 123admin', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-28 15:58:04');
INSERT INTO `sys_oper_log` VALUES ('863', '角色管理', '2', 'com.linkwechat.web.controller.system.SysRoleController.edit()', 'PUT', '1', 'admin', null, '/system/role', '36.5.155.87', 'XX XX', '{\"flag\":false,\"roleId\":2,\"admin\":false,\"remark\":\"普通角色\",\"updateTime\":1603936032000,\"dataScope\":\"2\",\"delFlag\":\"0\",\"params\":{},\"roleSort\":\"2\",\"createTime\":1521171180000,\"updateBy\":\"admin\",\"roleKey\":\"common\",\"roleName\":\"测试用户\",\"menuIds\":[2012,2014,2015,2016,2022,2006,2018,2020,2021,2007,2004,2023,2024,2025,2026,2005,2027,2028,2029,2030,2048,2049,2050,2051,2031,2032,2034,2035,2036,2037,2038,2001,2002,2003,2008,2009],\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 01:47:31');
INSERT INTO `sys_oper_log` VALUES ('864', '通讯录相关客户', '1', 'com.linkwechat.web.controller.wecom.WeUserController.add()', 'POST', '1', 'test', null, '/wecom/user', '36.5.155.87', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"18158873850\",\"name\":\"盛锡勇\",\"department\":[\"1\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 01:59:50');
INSERT INTO `sys_oper_log` VALUES ('865', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '222.185.238.221', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:00:07');
INSERT INTO `sys_oper_log` VALUES ('866', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '27.8.44.44', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:00:45');
INSERT INTO `sys_oper_log` VALUES ('867', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '36.5.155.87', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAAdUkp__-t-f2hY0PEiiDHWQ\",\"addTag\":[{\"createTime\":1603936886000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 02:01:36');
INSERT INTO `sys_oper_log` VALUES ('868', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '36.5.155.87', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:02:01');
INSERT INTO `sys_oper_log` VALUES ('869', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '61.154.103.16', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:05:21');
INSERT INTO `sys_oper_log` VALUES ('870', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '113.76.111.225', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:19:45');
INSERT INTO `sys_oper_log` VALUES ('871', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '115.60.147.40', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 02:35:49');
INSERT INTO `sys_oper_log` VALUES ('872', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '210.22.133.173', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 03:18:13');
INSERT INTO `sys_oper_log` VALUES ('873', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '171.15.105.52', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 03:20:23');
INSERT INTO `sys_oper_log` VALUES ('874', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '114.217.138.78', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 05:49:20');
INSERT INTO `sys_oper_log` VALUES ('875', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '116.231.179.170', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 06:01:56');
INSERT INTO `sys_oper_log` VALUES ('876', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '116.54.77.172', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 06:18:03');
INSERT INTO `sys_oper_log` VALUES ('877', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '61.144.97.187', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 07:00:13');
INSERT INTO `sys_oper_log` VALUES ('878', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '115.60.189.47', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 07:08:43');
INSERT INTO `sys_oper_log` VALUES ('879', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '115.60.189.47', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 07:08:48');
INSERT INTO `sys_oper_log` VALUES ('880', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '103.38.233.19', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 07:33:53');
INSERT INTO `sys_oper_log` VALUES ('881', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '122.235.241.170', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 07:55:08');
INSERT INTO `sys_oper_log` VALUES ('882', '启用有效企业微信账号', '3', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.startWeCorpAccount()', 'PUT', '1', 'admin', null, '/wecom/corp/startVailWeCorpAccount/ww24262ce93851488f', '36.5.155.87', 'XX XX', 'ww24262ce93851488f', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 08:54:48');
INSERT INTO `sys_oper_log` VALUES ('883', '启用有效企业微信账号', '3', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.startWeCorpAccount()', 'PUT', '1', 'admin', null, '/wecom/corp/startVailWeCorpAccount/ww24262ce93851488f', '36.5.155.87', 'XX XX', 'ww24262ce93851488f', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 08:54:54');
INSERT INTO `sys_oper_log` VALUES ('884', '启用有效企业微信账号', '3', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.startWeCorpAccount()', 'PUT', '1', 'admin', null, '/wecom/corp/startVailWeCorpAccount/ww24262ce93851488f', '36.5.155.87', 'XX XX', 'ww24262ce93851488f', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 08:56:59');
INSERT INTO `sys_oper_log` VALUES ('885', '启用有效企业微信账号', '3', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.startWeCorpAccount()', 'PUT', '1', 'admin', null, '/wecom/corp/startVailWeCorpAccount/ww24262ce93851488f', '36.5.155.87', 'XX XX', 'ww24262ce93851488f', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 08:57:01');
INSERT INTO `sys_oper_log` VALUES ('886', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '36.5.155.87', 'XX XX', '123admin 123admin123', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-29 09:53:21');
INSERT INTO `sys_oper_log` VALUES ('887', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '223.72.71.128', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 11:33:17');
INSERT INTO `sys_oper_log` VALUES ('888', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '171.91.65.35', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 14:51:56');
INSERT INTO `sys_oper_log` VALUES ('889', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '183.222.23.250', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 15:46:33');
INSERT INTO `sys_oper_log` VALUES ('890', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '119.130.161.126', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-29 19:00:16');
INSERT INTO `sys_oper_log` VALUES ('891', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '36.5.79.198', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-30 02:04:41');
INSERT INTO `sys_oper_log` VALUES ('892', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '36.5.79.198', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604023478000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604023478000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 02:04:56');
INSERT INTO `sys_oper_log` VALUES ('893', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '119.139.136.241', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-30 02:11:43');
INSERT INTO `sys_oper_log` VALUES ('894', '移除客户标签', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.removeLabel()', 'DELETE', '1', 'test', null, '/wecom/customer/removeLabel', '27.8.44.44', 'XX XX', '{}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 02:17:02');
INSERT INTO `sys_oper_log` VALUES ('895', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '27.8.44.44', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604024199000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 02:17:13');
INSERT INTO `sys_oper_log` VALUES ('896', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'test', null, '/wecom/group', '27.8.44.44', 'XX XX', '{\"weTags\":[{\"createTime\":1604024326672,\"name\":\"101001\"},{\"createTime\":1604024326672,\"name\":\"10101\"},{\"createTime\":1604024326672,\"name\":\"101010\"}],\"createTime\":1604024326672,\"gourpName\":\"10101\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 02:18:47');
INSERT INTO `sys_oper_log` VALUES ('897', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '222.91.148.58', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-30 03:49:44');
INSERT INTO `sys_oper_log` VALUES ('898', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '111.163.45.90', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"1\",\"isLeaderInDept\":[\"0\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"1\"],\"email\":\"\",\"isActivate\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 08:14:15');
INSERT INTO `sys_oper_log` VALUES ('899', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '111.163.45.90', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"1\"],\"email\":\"\",\"isActivate\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-30 08:14:37');
INSERT INTO `sys_oper_log` VALUES ('900', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '111.13.46.36', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-30 12:56:34');
INSERT INTO `sys_oper_log` VALUES ('901', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '113.88.109.180', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 01:20:36');
INSERT INTO `sys_oper_log` VALUES ('902', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '113.88.109.180', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 01:20:43');
INSERT INTO `sys_oper_log` VALUES ('903', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '116.227.132.124', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 02:56:13');
INSERT INTO `sys_oper_log` VALUES ('904', '标签组', '2', 'com.linkwechat.web.controller.wecom.WeTagGroupController.edit()', 'PUT', '1', 'test', null, '/wecom/group', '117.188.18.22', 'XX XX', '{\"weTags\":[{\"createTime\":1604120461000,\"tagId\":\"et2H-nDQAADhNzG1XczpXOcYH7gbZhow\",\"groupId\":\"et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg\",\"name\":\"10101\"}],\"createBy\":\"test\",\"createTime\":1604120461000,\"groupId\":\"et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg\",\"gourpName\":\"10101\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-31 05:01:15');
INSERT INTO `sys_oper_log` VALUES ('905', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '42.243.10.9', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 07:51:03');
INSERT INTO `sys_oper_log` VALUES ('906', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '42.243.10.9', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604130658000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604130658000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"},{\"createTime\":1604130658000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-31 07:51:37');
INSERT INTO `sys_oper_log` VALUES ('907', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '124.65.158.242', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 07:51:39');
INSERT INTO `sys_oper_log` VALUES ('908', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'admin', null, '/wecom/user', '183.160.3.183', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"4294967294\"],\"email\":\"\",\"isActivate\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-10-31 13:27:58');
INSERT INTO `sys_oper_log` VALUES ('909', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '171.217.99.121', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-10-31 13:37:00');
INSERT INTO `sys_oper_log` VALUES ('910', '角色管理', '2', 'com.linkwechat.web.controller.system.SysRoleController.edit()', 'PUT', '1', 'admin', null, '/system/role', '127.0.0.1', '内网IP', '{\"flag\":false,\"roleId\":2,\"admin\":false,\"remark\":\"企业微信用户\",\"updateTime\":1604214432000,\"dataScope\":\"2\",\"delFlag\":\"0\",\"params\":{},\"roleSort\":\"2\",\"createTime\":1521171180000,\"updateBy\":\"admin\",\"roleKey\":\"common\",\"roleName\":\"企业微信用户\",\"menuIds\":[2012,2014,2015,2016,2022,2006,2018,2020,2021,2007,2004,2023,2024,2025,2026,2005,2027,2028,2029,2030,2048,2049,2050,2051,2031,2032,2034,2035,2036,2037,2038,2001,2002,2003,2008,2009],\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 07:07:24');
INSERT INTO `sys_oper_log` VALUES ('911', '角色管理', '2', 'com.linkwechat.web.controller.system.SysRoleController.edit()', 'PUT', '1', 'admin', null, '/system/role', '127.0.0.1', '内网IP', '{\"flag\":false,\"roleId\":2,\"admin\":false,\"remark\":\"企业微信用户\",\"updateTime\":1604214452000,\"dataScope\":\"2\",\"delFlag\":\"0\",\"params\":{},\"roleSort\":\"2\",\"createTime\":1521171180000,\"updateBy\":\"admin\",\"roleKey\":\"WeCome\",\"roleName\":\"企业微信用户\",\"menuIds\":[2012,2014,2015,2016,2022,2006,2018,2020,2021,2007,2004,2023,2024,2025,2026,2005,2027,2028,2029,2030,2048,2049,2050,2051,2031,2032,2034,2035,2036,2037,2038,2001,2002,2003,2008,2009],\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 07:07:40');
INSERT INTO `sys_oper_log` VALUES ('912', '企业微信组织架构相关', '1', 'com.linkwechat.web.controller.wecom.WeDepartmentController.add()', 'POST', '1', 'admin', null, '/wecom/department', '127.0.0.1', '内网IP', '{\"name\":\"宣传部\",\"id\":4294967293,\"parentId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 11:54:47');
INSERT INTO `sys_oper_log` VALUES ('913', '企业微信组织架构相关', '3', 'com.linkwechat.web.controller.wecom.WeDepartmentController.remove()', 'DELETE', '1', 'admin', null, '/wecom/department/4294967293', '127.0.0.1', '内网IP', '{ids=4294967293}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 11:57:24');
INSERT INTO `sys_oper_log` VALUES ('914', '企业微信组织架构相关', '3', 'com.linkwechat.web.controller.wecom.WeDepartmentController.remove()', 'DELETE', '1', 'admin', null, '/wecom/department/4294967294', '127.0.0.1', '内网IP', '{ids=4294967294}', 'null', '1', '部门下存在成员', '2020-11-01 11:58:11');
INSERT INTO `sys_oper_log` VALUES ('915', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '127.0.0.1', '内网IP', '{\"birthday\":801244800000,\"externalUserid\":\"nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 12:01:21');
INSERT INTO `sys_oper_log` VALUES ('916', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '127.0.0.1', '内网IP', '{\"birthday\":801244800000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 12:01:45');
INSERT INTO `sys_oper_log` VALUES ('917', '企业微信组织架构相关', '1', 'com.linkwechat.web.controller.wecom.WeDepartmentController.add()', 'POST', '1', 'admin', null, '/wecom/department', '36.5.82.48', 'XX XX', '{\"name\":\"1231563\",\"id\":4294967293,\"parentId\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 13:18:30');
INSERT INTO `sys_oper_log` VALUES ('918', '企业微信组织架构相关', '3', 'com.linkwechat.web.controller.wecom.WeDepartmentController.remove()', 'DELETE', '1', 'admin', null, '/wecom/department/4294967293', '36.5.82.48', 'XX XX', '{ids=4294967293}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 13:18:43');
INSERT INTO `sys_oper_log` VALUES ('919', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"birthday\":801331200000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 14:21:42');
INSERT INTO `sys_oper_log` VALUES ('920', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"birthday\":801331200000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 14:22:00');
INSERT INTO `sys_oper_log` VALUES ('921', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"birthday\":801417600000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 14:26:49');
INSERT INTO `sys_oper_log` VALUES ('922', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"birthday\":801331200000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 14:29:02');
INSERT INTO `sys_oper_log` VALUES ('923', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '36.5.82.48', 'XX XX', '{\"visible\":\"0\",\"icon\":\"wechat\",\"orderNum\":\"60\",\"menuName\":\"企业微信管理\",\"updateTime\":1604242542000,\"params\":{},\"parentId\":0,\"path\":\"_enterpriseWechat\",\"children\":[],\"createTime\":1603205285000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2010,\"menuType\":\"M\",\"perms\":\"\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 14:55:53');
INSERT INTO `sys_oper_log` VALUES ('924', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', 'null', '1', '\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'WHERE external_userid=\'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\'\' at line 1\n### The error may exist in com/linkwechat/wecom/mapper/WeCustomerMapper.java (best guess)\n### The error may involve com.linkwechat.wecom.mapper.WeCustomerMapper.updateById-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE we_customer    WHERE external_userid=?\n### Cause: java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'WHERE external_userid=\'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\'\' at line 1\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near \'WHERE external_userid=\'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\'\' at line 1', '2020-11-01 16:06:18');
INSERT INTO `sys_oper_log` VALUES ('925', '企业微信客户', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.edit()', 'PUT', '1', 'admin', null, '/wecom/customer', '36.5.82.48', 'XX XX', '{\"birthday\":1604937600000,\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-01 16:11:20');
INSERT INTO `sys_oper_log` VALUES ('926', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '61.154.103.16', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-02 01:19:59');
INSERT INTO `sys_oper_log` VALUES ('927', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '123.233.115.107', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-02 01:58:49');
INSERT INTO `sys_oper_log` VALUES ('928', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '183.14.29.89', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-02 04:18:19');
INSERT INTO `sys_oper_log` VALUES ('929', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '183.45.77.65', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"avatarMediaid\":\"3\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"4294967294\"],\"email\":\"1212\",\"isActivate\":1}', 'null', '1', '{\"errcode\":40058,\"errmsg\":\"email exceed min length 6. Invalid input invalid Request Parameter, hint: [1604309317_81_497a7f2ba9033a2667f8ae13b1c948ae], from ip: , more info at https://open.work.weixin.qq.com/devtool/query?e=40058\"}', '2020-11-02 09:28:38');
INSERT INTO `sys_oper_log` VALUES ('930', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '183.45.77.65', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"avatarMediaid\":\"3\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"4294967294\"],\"email\":\"1212\",\"isActivate\":1}', 'null', '1', '{\"errcode\":40058,\"errmsg\":\"email exceed min length 6. Invalid input invalid Request Parameter, hint: [1604309319_81_13ed946a308ce2d112e74cefbb6dd534], from ip: , more info at https://open.work.weixin.qq.com/devtool/query?e=40058\"}', '2020-11-02 09:28:39');
INSERT INTO `sys_oper_log` VALUES ('931', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '183.45.77.65', 'XX XX', '{\"gender\":1,\"mobile\":\"18654148698\",\"isLeaderInDept\":[\"0\"],\"telephone\":\"\",\"userId\":\"XuXueJun\",\"enable\":1,\"name\":\"徐学军\",\"alias\":\"aa\",\"position\":\"\",\"department\":[\"1\"],\"email\":\"1570728529@qq.com\",\"isActivate\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-02 09:29:02');
INSERT INTO `sys_oper_log` VALUES ('932', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '60.173.215.59', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-02 11:28:36');
INSERT INTO `sys_oper_log` VALUES ('933', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '60.173.215.59', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604316484000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604316484000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604316484000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"},{\"createTime\":1604316484000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-02 11:28:48');
INSERT INTO `sys_oper_log` VALUES ('934', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '120.36.170.56', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 01:25:37');
INSERT INTO `sys_oper_log` VALUES ('935', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '27.8.44.44', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 02:45:09');
INSERT INTO `sys_oper_log` VALUES ('936', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'test', null, '/wecom/group', '27.8.44.44', 'XX XX', '{\"weTags\":[{\"createTime\":1604371570608,\"name\":\"15656\"}],\"createTime\":1604371570608,\"gourpName\":\"454\",\"status\":\"0\"}', 'null', '1', '{\"errcode\":40068,\"errmsg\":\"invalid tagid, hint: [1604371570_98_812777d59fe45968777a9d9fe948995e], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=40068\"}', '2020-11-03 02:46:10');
INSERT INTO `sys_oper_log` VALUES ('937', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'test', null, '/wecom/group', '27.8.44.44', 'XX XX', '{\"weTags\":[{\"createTime\":1604371573634,\"name\":\"15656\"}],\"createTime\":1604371573630,\"gourpName\":\"454\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-03 02:46:14');
INSERT INTO `sys_oper_log` VALUES ('938', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '60.6.203.79', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 03:21:35');
INSERT INTO `sys_oper_log` VALUES ('939', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '118.186.2.22', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 09:01:24');
INSERT INTO `sys_oper_log` VALUES ('940', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '111.13.46.36', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 10:44:53');
INSERT INTO `sys_oper_log` VALUES ('941', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '61.185.158.253', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604405898000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604405898000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604405898000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604405898000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-03 12:19:00');
INSERT INTO `sys_oper_log` VALUES ('942', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '61.185.158.253', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-03 12:19:05');
INSERT INTO `sys_oper_log` VALUES ('943', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '120.229.4.117', 'XX XX', '{\"gender\":1,\"mobile\":\"15956608378\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"DongDongQiang\",\"enable\":1,\"name\":\"董健\",\"alias\":\"\",\"position\":\"\",\"department\":[\"1\"],\"email\":\"\",\"isActivate\":1}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-03 14:47:18');
INSERT INTO `sys_oper_log` VALUES ('944', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'test', null, '/wecom/group', '59.41.7.226', 'XX XX', '{\"weTags\":[{\"createTime\":1604456370716,\"name\":\"asas\"}],\"createTime\":1604456370716,\"gourpName\":\"asasdas\",\"status\":\"0\"}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604456371_106_4a71a2084bacf68471fd53580c06ec1d], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\"}', '2020-11-04 02:19:32');
INSERT INTO `sys_oper_log` VALUES ('945', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'test', null, '/wecom/group', '59.41.7.226', 'XX XX', '{\"weTags\":[{\"createTime\":1604456373972,\"name\":\"asas\"},{\"createTime\":1604456373972,\"name\":\"asdas\"}],\"createTime\":1604456373972,\"gourpName\":\"asasdas\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 02:19:34');
INSERT INTO `sys_oper_log` VALUES ('946', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '59.41.7.226', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604456355000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604456355000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604456355000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604456355000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 02:19:36');
INSERT INTO `sys_oper_log` VALUES ('947', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '112.64.178.81', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-04 03:19:33');
INSERT INTO `sys_oper_log` VALUES ('948', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '36.5.79.77', 'XX XX', '123admin admin123', '{\"msg\":\"修改密码失败，旧密码错误\",\"code\":500}', '0', null, '2020-11-04 05:37:52');
INSERT INTO `sys_oper_log` VALUES ('949', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '36.5.79.77', 'XX XX', '123admin123 admin123', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 05:38:02');
INSERT INTO `sys_oper_log` VALUES ('950', '个人信息', '2', 'com.linkwechat.web.controller.system.SysProfileController.updatePwd()', 'PUT', '1', 'admin', null, '/system/user/profile/updatePwd', '36.5.79.77', 'XX XX', 'admin123 123admin123', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 05:39:18');
INSERT INTO `sys_oper_log` VALUES ('951', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '无可用的corpid和secret', '2020-11-04 05:51:12');
INSERT INTO `sys_oper_log` VALUES ('952', '新增企业id相关配置', '1', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.add()', 'POST', '1', 'admin', null, '/wecom/corp', '36.5.79.77', 'XX XX', '{\"contactSecret\":\" ySj_eB18wxg75k1MAqPmknjb6Nf-FwLFxDclRTg_yy0\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\" ySj_eB18wxg75k1MAqPmknjb6Nf-FwLFxDclRTg_yy0\",\"updateTime\":1604469285320,\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285320,\"id\":8}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 05:54:45');
INSERT INTO `sys_oper_log` VALUES ('953', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '无可用的corpid和secret', '2020-11-04 05:54:50');
INSERT INTO `sys_oper_log` VALUES ('954', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '无可用的corpid和secret', '2020-11-04 05:54:55');
INSERT INTO `sys_oper_log` VALUES ('955', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '36.5.79.77', 'XX XX', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\" ySj_eB18wxg75k1MAqPmknjb6Nf-FwLFxDclRTg_yy0\",\"updateTime\":1604469285000,\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 05:58:05');
INSERT INTO `sys_oper_log` VALUES ('956', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '无可用的corpid和secret', '2020-11-04 05:58:10');
INSERT INTO `sys_oper_log` VALUES ('957', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '无可用的corpid和secret', '2020-11-04 05:58:16');
INSERT INTO `sys_oper_log` VALUES ('958', '启用有效企业微信账号', '3', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.startWeCorpAccount()', 'PUT', '1', 'admin', null, '/wecom/corp/startVailWeCorpAccount/ww24262ce93851488f', '36.5.79.77', 'XX XX', 'ww24262ce93851488f', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 05:58:55');
INSERT INTO `sys_oper_log` VALUES ('959', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604469541_106_f584d764682966bdf8ab930914788ddb], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-04 05:59:01');
INSERT INTO `sys_oper_log` VALUES ('960', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '36.5.79.77', 'XX XX', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"updateTime\":1604469285000,\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 06:01:24');
INSERT INTO `sys_oper_log` VALUES ('961', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '36.5.79.77', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-04 06:01:57');
INSERT INTO `sys_oper_log` VALUES ('962', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '110.80.36.74', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-04 06:06:35');
INSERT INTO `sys_oper_log` VALUES ('963', '移除客户标签', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.removeLabel()', 'DELETE', '1', 'test', null, '/wecom/customer/removeLabel', '61.154.103.16', 'XX XX', '{}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 07:41:56');
INSERT INTO `sys_oper_log` VALUES ('964', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '111.13.46.36', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604479583000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604479583000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604479583000,\"tagId\":\"et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"企业用户\"},{\"createTime\":1604479583000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 08:46:33');
INSERT INTO `sys_oper_log` VALUES ('965', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '111.13.46.36', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-04 08:46:40');
INSERT INTO `sys_oper_log` VALUES ('966', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '116.6.77.146', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-04 09:11:18');
INSERT INTO `sys_oper_log` VALUES ('967', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '180.162.231.243', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604496091_107_eaa87c93e763e276aebe9c2135e50615], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-04 13:21:31');
INSERT INTO `sys_oper_log` VALUES ('968', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '223.244.122.101', 'XX XX', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:10:02');
INSERT INTO `sys_oper_log` VALUES ('969', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '223.244.122.101', 'XX XX', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:10:36');
INSERT INTO `sys_oper_log` VALUES ('970', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:33:44');
INSERT INTO `sys_oper_log` VALUES ('971', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:35:28');
INSERT INTO `sys_oper_log` VALUES ('972', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:36:13');
INSERT INTO `sys_oper_log` VALUES ('973', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:37:30');
INSERT INTO `sys_oper_log` VALUES ('974', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"6O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:37:53');
INSERT INTO `sys_oper_log` VALUES ('975', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://192.168.0.101/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:38:02');
INSERT INTO `sys_oper_log` VALUES ('976', '新增企业id相关配置', '1', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.add()', 'POST', '1', 'admin', null, '/wecom/corp', '192.168.31.145', '内网IP', '{\"contactSecret\":\"456526\",\"corpId\":\"52616\",\"companyName\":\"456564165\",\"corpSecret\":\"45656564\",\"wxQrLoginRedirectUri\":\"45945656\",\"updateTime\":1604500717709,\"providerSecret\":\"26456\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604500717709,\"id\":9}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 14:38:37');
INSERT INTO `sys_oper_log` VALUES ('977', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '223.244.122.101', 'XX XX', '{\"contactSecret\":\"456526\",\"corpId\":\"52616\",\"companyName\":\"456564165\",\"corpSecret\":\"11111111\",\"wxQrLoginRedirectUri\":\"22222222222222\",\"updateTime\":1604500718000,\"providerSecret\":\"26456\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604500718000,\"id\":9,\"status\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 15:14:00');
INSERT INTO `sys_oper_log` VALUES ('978', '修改企业id相关配置', '2', 'com.linkwechat.web.controller.wecom.WeCorpAccountController.edit()', 'PUT', '1', 'admin', null, '/wecom/corp', '223.244.122.101', 'XX XX', '{\"contactSecret\":\"IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y\",\"corpId\":\"ww24262ce93851488f\",\"companyName\":\"康有保\",\"corpSecret\":\"4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU\",\"wxQrLoginRedirectUri\":\"http://106.13.201.219/#/authCallback\",\"updateTime\":1604469285000,\"providerSecret\":\"O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk\",\"delFlag\":\"0\",\"params\":{},\"createTime\":1604469285000,\"id\":8,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-04 15:30:27');
INSERT INTO `sys_oper_log` VALUES ('979', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '36.5.147.53', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"avatarMediaid\":\"3\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"4294967294\"],\"email\":\"\",\"isActivate\":1}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604542432_56_e8f1a748c295e594e5cca9a6588a3329], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\"}', '2020-11-05 02:13:53');
INSERT INTO `sys_oper_log` VALUES ('980', '更新通讯录客户', '2', 'com.linkwechat.web.controller.wecom.WeUserController.edit()', 'PUT', '1', 'test', null, '/wecom/user', '36.5.147.53', 'XX XX', '{\"gender\":1,\"wxAccount\":\"18158873850\",\"mobile\":\"18158873850\",\"qqAccount\":\"\",\"isLeaderInDept\":[\"1\"],\"telephone\":\"\",\"userId\":\"18158873850\",\"avatarMediaid\":\"3\",\"enable\":1,\"name\":\"盛锡勇\",\"alias\":\"\",\"position\":\"\",\"department\":[\"4294967294\"],\"email\":\"\",\"isActivate\":1}', 'null', '1', '{\"errcode\":301015,\"errmsg\":\"avatar_mediaid invalid, hint: [1604542433_81_34ef2767ad6c50a814194de728e88739], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=301015\"}', '2020-11-05 02:13:53');
INSERT INTO `sys_oper_log` VALUES ('981', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '121.32.154.183', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604543352_129_e86d1c670286230623561d232fdc2c59], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-05 02:29:12');
INSERT INTO `sys_oper_log` VALUES ('982', '通讯录相关客户', '1', 'com.linkwechat.web.controller.wecom.WeUserController.add()', 'POST', '1', '18158873850', null, '/wecom/user', '36.5.76.173', 'XX XX', '{\"gender\":1,\"mobile\":\"15665400628\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"15665400628\",\"name\":\"江总\",\"alias\":\"江总\",\"department\":[\"1\"],\"isActivate\":2}', 'null', '1', '\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'\n### The error may exist in com/linkwechat/wecom/mapper/WeUserMapper.java (best guess)\n### The error may involve com.linkwechat.wecom.mapper.WeUserMapper.insert-Inline\n### The error occurred while setting parameters\n### SQL: INSERT INTO we_user  ( user_id,  user_name, alias, gender, mobile,   department,  is_leader_in_dept,        is_activate )  VALUES  ( ?,  ?, ?, ?, ?,   ?,  ?,        ? )\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'\n; Duplicate entry \'15665400628\' for key \'PRIMARY\'; nested exception is java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'', '2020-11-05 02:49:17');
INSERT INTO `sys_oper_log` VALUES ('983', '通讯录相关客户', '1', 'com.linkwechat.web.controller.wecom.WeUserController.add()', 'POST', '1', '18158873850', null, '/wecom/user', '36.5.76.173', 'XX XX', '{\"gender\":1,\"mobile\":\"15665400628\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"15665400628\",\"name\":\"江总\",\"department\":[\"1\"],\"isActivate\":2}', 'null', '1', '\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'\n### The error may exist in com/linkwechat/wecom/mapper/WeUserMapper.java (best guess)\n### The error may involve com.linkwechat.wecom.mapper.WeUserMapper.insert-Inline\n### The error occurred while setting parameters\n### SQL: INSERT INTO we_user  ( user_id,  user_name,  gender, mobile,   department,  is_leader_in_dept,        is_activate )  VALUES  ( ?,  ?,  ?, ?,   ?,  ?,        ? )\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'\n; Duplicate entry \'15665400628\' for key \'PRIMARY\'; nested exception is java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'15665400628\' for key \'PRIMARY\'', '2020-11-05 02:49:48');
INSERT INTO `sys_oper_log` VALUES ('984', '通讯录相关客户', '1', 'com.linkwechat.web.controller.wecom.WeUserController.add()', 'POST', '1', '18158873850', null, '/wecom/user', '36.5.76.173', 'XX XX', '{\"gender\":1,\"mobile\":\"15665400628\",\"isLeaderInDept\":[\"undefined\"],\"userId\":\"15665400628\",\"name\":\"JDQ\",\"department\":[\"1\"],\"isActivate\":2}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-05 02:51:49');
INSERT INTO `sys_oper_log` VALUES ('985', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '101.224.139.165', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604554968_98_bbafdda31bc0c5896beda5a5d31adfb9], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-05 05:42:48');
INSERT INTO `sys_oper_log` VALUES ('986', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '123.125.250.94', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 05:46:33');
INSERT INTO `sys_oper_log` VALUES ('987', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '58.246.183.150', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 06:10:08');
INSERT INTO `sys_oper_log` VALUES ('988', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 07:45:34');
INSERT INTO `sys_oper_log` VALUES ('989', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 07:45:46');
INSERT INTO `sys_oper_log` VALUES ('990', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 07:51:46');
INSERT INTO `sys_oper_log` VALUES ('991', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 08:06:17');
INSERT INTO `sys_oper_log` VALUES ('992', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 08:07:26');
INSERT INTO `sys_oper_log` VALUES ('993', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 08:09:27');
INSERT INTO `sys_oper_log` VALUES ('994', '移除客户标签', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.removeLabel()', 'DELETE', '1', 'admin', null, '/wecom/customer/removeLabel', '36.5.76.173', 'XX XX', '{}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-05 08:12:18');
INSERT INTO `sys_oper_log` VALUES ('995', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '119.33.33.122', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 08:12:46');
INSERT INTO `sys_oper_log` VALUES ('996', '用户管理', '1', 'com.linkwechat.web.controller.system.SysUserController.add()', 'POST', '1', 'admin', null, '/system/user', '127.0.0.1', '内网IP', '{\"phonenumber\":\"13266548392\",\"admin\":false,\"validCropId\":false,\"password\":\"$2a$10$Y3ijHot0ldFxsMAa7.kqFu2HcvzTm9aMeC1wJbTfmWoJ2rQhnPM72\",\"postIds\":[4],\"email\":\"113775422@qq.com\",\"nickName\":\"测试\",\"sex\":\"0\",\"deptId\":109,\"updateTime\":1604568773979,\"params\":{},\"userName\":\"测试新增\",\"userId\":107,\"createBy\":\"admin\",\"roleIds\":[],\"createTime\":1604568773979,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-05 09:35:19');
INSERT INTO `sys_oper_log` VALUES ('997', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '223.104.66.131', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-05 10:02:52');
INSERT INTO `sys_oper_log` VALUES ('998', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '27.191.198.164', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604624934_130_b994a0f10f8979d83ad3a88afc9e41ce], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-06 01:08:55');
INSERT INTO `sys_oper_log` VALUES ('999', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 06:43:55');
INSERT INTO `sys_oper_log` VALUES ('1000', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 06:50:06');
INSERT INTO `sys_oper_log` VALUES ('1001', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:03:36');
INSERT INTO `sys_oper_log` VALUES ('1002', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:08:35');
INSERT INTO `sys_oper_log` VALUES ('1003', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:10:58');
INSERT INTO `sys_oper_log` VALUES ('1004', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '219.146.91.110', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"}]}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604646798_129_2af8b5ce45f891117f4ac47749c814cf], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\"}', '2020-11-06 07:13:18');
INSERT INTO `sys_oper_log` VALUES ('1005', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'test', null, '/wecom/customer/makeLabel', '219.146.91.110', 'XX XX', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604646769000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:13:20');
INSERT INTO `sys_oper_log` VALUES ('1006', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:13:26');
INSERT INTO `sys_oper_log` VALUES ('1007', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '219.146.91.110', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:13:32');
INSERT INTO `sys_oper_log` VALUES ('1008', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:14:53');
INSERT INTO `sys_oper_log` VALUES ('1009', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:15:19');
INSERT INTO `sys_oper_log` VALUES ('1010', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'admin', null, '/wecom/customer/synchWeCustomer', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:16:28');
INSERT INTO `sys_oper_log` VALUES ('1011', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'admin', null, '/wecom/customer/makeLabel', '127.0.0.1', '内网IP', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604646803000,\"tagId\":\"et2H-nDQAACFz3gFh1wZ5cSqQhApwUyA\",\"groupId\":\"et2H-nDQAAdpZH-mCQq43ih5xUlrS9UQ\",\"name\":\"企业QQ\"},{\"createTime\":1604646803000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604646803000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604646803000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604646803000,\"tagId\":\"et4_fSDAAA_wpbwIIUroXo56dJXyZHLQ\",\"groupId\":\"et4_fSDAAAfEdaaSHfl1Ta78id0ukY3g\",\"name\":\"重要\"}]}', 'null', '1', '{\"errcode\":40068,\"errmsg\":\"invalid tagid, hint: [1604647061_98_a8982fcc1e408eff099fbbbe7a9c9536], from ip: 111.13.46.36, more info at https://open.work.weixin.qq.com/devtool/query?e=40068\"}', '2020-11-06 07:17:41');
INSERT INTO `sys_oper_log` VALUES ('1012', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '58.213.122.234', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:17:54');
INSERT INTO `sys_oper_log` VALUES ('1013', '标签组', '1', 'com.linkwechat.web.controller.wecom.WeTagGroupController.add()', 'POST', '1', 'admin', null, '/wecom/group', '127.0.0.1', '内网IP', '{\"weTags\":[{\"createTime\":1604647082720,\"name\":\"123\"}],\"createTime\":1604647082720,\"gourpName\":\"ghhgf\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:18:03');
INSERT INTO `sys_oper_log` VALUES ('1014', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '58.213.122.234', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 07:18:21');
INSERT INTO `sys_oper_log` VALUES ('1015', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'admin', null, '/wecom/customer/makeLabel', '127.0.0.1', '内网IP', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAAd7YUGnw71_iXjD-HaruyFg\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"123\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:18:38');
INSERT INTO `sys_oper_log` VALUES ('1016', '标签组', '2', 'com.linkwechat.web.controller.wecom.WeTagGroupController.edit()', 'PUT', '1', 'admin', null, '/wecom/group', '127.0.0.1', '内网IP', '{\"weTags\":[{\"createTime\":1604647129000,\"tagId\":\"et2H-nDQAAd7YUGnw71_iXjD-HaruyFg\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"123\"},{\"createTime\":1604647150065,\"tagId\":\"et2H-nDQAA0zYuuiE_ty9DCIoAfc18eQ\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"3434\"}],\"createBy\":\"admin\",\"createTime\":1604647083000,\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"gourpName\":\"ghhgf\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:19:10');
INSERT INTO `sys_oper_log` VALUES ('1017', '标签组', '2', 'com.linkwechat.web.controller.wecom.WeTagGroupController.edit()', 'PUT', '1', 'admin', null, '/wecom/group', '127.0.0.1', '内网IP', '{\"weTags\":[{\"createTime\":1604647159000,\"tagId\":\"et2H-nDQAA0zYuuiE_ty9DCIoAfc18eQ\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"3434\"}],\"createBy\":\"admin\",\"createTime\":1604647083000,\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"gourpName\":\"ghhgf\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:19:24');
INSERT INTO `sys_oper_log` VALUES ('1018', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'admin', null, '/wecom/customer/makeLabel', '127.0.0.1', '内网IP', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:20:24');
INSERT INTO `sys_oper_log` VALUES ('1019', '客户打标签', '2', 'com.linkwechat.web.controller.wecom.WeCustomerController.makeLabel()', 'POST', '1', 'admin', null, '/wecom/customer/makeLabel', '127.0.0.1', '内网IP', '{\"externalUserid\":\"wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ\",\"addTag\":[{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手机\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw\",\"groupId\":\"et2H-nDQAA0OENkZNfgx7cjF8IacoShg\",\"name\":\"小米手环\"},{\"createTime\":1604647104000,\"tagId\":\"et2H-nDQAALPTXhYLwzwtMc25IE3COFw\",\"groupId\":\"et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g\",\"name\":\"个人用户\"}]}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:22:38');
INSERT INTO `sys_oper_log` VALUES ('1020', '标签组', '2', 'com.linkwechat.web.controller.wecom.WeTagGroupController.edit()', 'PUT', '1', 'admin', null, '/wecom/group', '127.0.0.1', '内网IP', '{\"weTags\":[{\"createTime\":1604649302000,\"tagId\":\"et2H-nDQAA0zYuuiE_ty9DCIoAfc18eQ\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"3434\"},{\"createTime\":1604649309148,\"tagId\":\"et2H-nDQAAOh5qBB5mEP1Z0asFCI99HQ\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"111\"}],\"createBy\":\"admin\",\"createTime\":1604647083000,\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"gourpName\":\"ghhgf\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 07:55:09');
INSERT INTO `sys_oper_log` VALUES ('1021', '标签组', '2', 'com.linkwechat.web.controller.wecom.WeTagGroupController.edit()', 'PUT', '1', 'admin', null, '/wecom/group', '127.0.0.1', '内网IP', '{\"weTags\":[{\"createTime\":1604649354000,\"tagId\":\"et2H-nDQAA0zYuuiE_ty9DCIoAfc18eQ\",\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"name\":\"3434\"}],\"createBy\":\"admin\",\"createTime\":1604647083000,\"groupId\":\"et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ\",\"gourpName\":\"ghhgf\",\"status\":\"0\"}', 'null', '1', '{\"errcode\":40068,\"errmsg\":\"invalid tagid, hint: [1604649367_98_96210182b57c686ce5bed325b2b0ece7], from ip: 111.13.46.36, more info at https://open.work.weixin.qq.com/devtool/query?e=40068\"}', '2020-11-06 07:56:07');
INSERT INTO `sys_oper_log` VALUES ('1022', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '222.91.148.20', 'XX XX', '{}', '{\"msg\":\"后台开始同步数据，请稍后关注进度\",\"code\":200}', '0', null, '2020-11-06 08:26:03');
INSERT INTO `sys_oper_log` VALUES ('1023', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"updateTime\":1604675430268,\"params\":{},\"parentId\":0,\"createTime\":1604675430292,\"name\":\"一级\",\"id\":1324730886436032512}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,                          name,             parent_id,                          create_time,                          update_time )           values ( ?,                          ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:10:30');
INSERT INTO `sys_oper_log` VALUES ('1024', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675627777,\"params\":{},\"parentId\":0,\"createTime\":1604675627795,\"name\":\"1256\",\"id\":1324731714819461120}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:13:48');
INSERT INTO `sys_oper_log` VALUES ('1025', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675785220,\"params\":{},\"parentId\":0,\"createTime\":1604675785241,\"name\":\"41654\",\"id\":1324732375195848704}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:16:25');
INSERT INTO `sys_oper_log` VALUES ('1026', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675801480,\"params\":{},\"parentId\":0,\"createTime\":1604675801498,\"name\":\"4165\",\"id\":1324732443382648832}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:16:42');
INSERT INTO `sys_oper_log` VALUES ('1027', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675844891,\"params\":{},\"parentId\":0,\"createTime\":1604675854801,\"name\":\"526126\",\"id\":1324732669791178752}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:17:38');
INSERT INTO `sys_oper_log` VALUES ('1028', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675957669,\"params\":{},\"parentId\":0,\"createTime\":1604675957703,\"name\":\"1635\",\"id\":1324733098553905152}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:19:18');
INSERT INTO `sys_oper_log` VALUES ('1029', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604675976181,\"params\":{},\"parentId\":0,\"createTime\":1604675976242,\"name\":\"29652\",\"id\":1324733176312107008}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:19:36');
INSERT INTO `sys_oper_log` VALUES ('1030', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604676002345,\"params\":{},\"parentId\":0,\"createTime\":1604676002364,\"name\":\"9\",\"id\":1324733285875716096}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeCategoryMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO we_category          ( id,             media_type,             name,             parent_id,                          create_time,                          update_time )           values ( ?,             ?,             ?,             ?,                          ?,                          ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:20:02');
INSERT INTO `sys_oper_log` VALUES ('1031', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604676240564,\"params\":{},\"parentId\":0,\"createTime\":1604676240582,\"name\":\"1965156\",\"id\":1324734285034426368}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 15:24:01');
INSERT INTO `sys_oper_log` VALUES ('1032', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604676506920,\"params\":{},\"parentId\":0,\"createTime\":1604676506938,\"name\":\"16156\",\"id\":1324735402212462592}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 15:28:27');
INSERT INTO `sys_oper_log` VALUES ('1033', '更新素材信息', '2', 'com.linkwechat.web.controller.wecom.WeMaterialController.edit()', 'PUT', '1', 'admin', null, '/wecom/material', '223.244.119.109', 'XX XX', '{\"updateTime\":1604677310658,\"params\":{},\"content\":\"456156\",\"createTime\":1604677310673,\"id\":1324738773258473472,\"categoryId\":1324734285034426368}', '{\"msg\":\"操作失败\",\"code\":500}', '0', null, '2020-11-06 15:41:51');
INSERT INTO `sys_oper_log` VALUES ('1034', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.119.109', 'XX XX', '{\"updateTime\":1604677467809,\"params\":{},\"content\":\"063023\",\"createTime\":1604677467813,\"id\":1324739432414318592,\"categoryId\":1324734285034426368}', 'null', '1', '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeMaterialMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO         we_material          ( id,                                           category_id,                                                        content,                                                                                               create_time,                                                        update_time )          VALUES          ( ?,                                           ?,                                                        ?,                                                                                               ?,                                                        ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1\n; Data truncation: Out of range value for column \'id\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'id\' at row 1', '2020-11-06 15:44:28');
INSERT INTO `sys_oper_log` VALUES ('1035', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.119.109', 'XX XX', '{\"updateTime\":1604677733317,\"params\":{},\"content\":\"26+25+6\",\"createTime\":1604677733319,\"id\":1324740546027196416,\"categoryId\":1324734285034426368}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 15:48:53');
INSERT INTO `sys_oper_log` VALUES ('1036', '更新素材信息', '2', 'com.linkwechat.web.controller.wecom.WeMaterialController.edit()', 'PUT', '1', 'admin', null, '/wecom/material', '223.244.119.109', 'XX XX', '{\"updateTime\":1604677733000,\"params\":{},\"content\":\"26+25+61561\",\"createTime\":1604678313452,\"id\":1324740546027196416,\"categoryId\":1324734285034426368}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 15:58:34');
INSERT INTO `sys_oper_log` VALUES ('1037', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604678812375,\"params\":{},\"parentId\":1324734285034426368,\"createTime\":1604678812398,\"name\":\"和大热天的人\",\"id\":1324745072012562432}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 16:06:53');
INSERT INTO `sys_oper_log` VALUES ('1038', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.119.109', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604678821232,\"params\":{},\"parentId\":1324735402212462592,\"createTime\":1604678821250,\"name\":\"和大热天大热天\",\"id\":1324745109140541440}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 16:07:01');
INSERT INTO `sys_oper_log` VALUES ('1039', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.119.109', 'XX XX', '{\"updateTime\":1604681307005,\"params\":{},\"content\":\"16515\",\"createTime\":1604681307018,\"id\":1324755535211401216,\"categoryId\":1324745109140541440}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-06 16:48:27');
INSERT INTO `sys_oper_log` VALUES ('1040', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '222.244.104.186', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604711747_100_025fceb22e985b3599006e43115c9b91], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-07 01:15:47');
INSERT INTO `sys_oper_log` VALUES ('1041', '标签组', '3', 'com.linkwechat.web.controller.wecom.WeTagGroupController.remove()', 'DELETE', '1', 'test', null, '/wecom/group/et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '119.181.166.62', 'XX XX', '{ids=et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604741134_99_87a7ff56acd72710856b07fcc23dd756], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\"}', '2020-11-07 09:25:34');
INSERT INTO `sys_oper_log` VALUES ('1042', '标签组', '3', 'com.linkwechat.web.controller.wecom.WeTagGroupController.remove()', 'DELETE', '1', 'test', null, '/wecom/group/et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '119.181.166.62', 'XX XX', '{ids=et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ}', 'null', '1', '{\"errcode\":40068,\"errmsg\":\"invalid tagid, hint: [1604741138_98_62a9ded5bcbffc744079e26fad9576af], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=40068\"}', '2020-11-07 09:25:38');
INSERT INTO `sys_oper_log` VALUES ('1043', '标签组', '3', 'com.linkwechat.web.controller.wecom.WeTagGroupController.remove()', 'DELETE', '1', 'test', null, '/wecom/group/et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '119.181.166.62', 'XX XX', '{ids=et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ}', 'null', '1', '{\"errcode\":40068,\"errmsg\":\"invalid tagid, hint: [1604741148_98_625eb54d57731fc9edb3d97a83d563d4], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=40068\"}', '2020-11-07 09:25:48');
INSERT INTO `sys_oper_log` VALUES ('1044', '欢迎语模板', '2', 'com.linkwechat.web.controller.wecom.WeMsgTlpController.edit()', 'PUT', '1', 'admin', null, '/wecom/tlp', '223.244.119.109', 'XX XX', '{\"updateTime\":1604741487290,\"delFlag\":0,\"params\":{},\"welcomeMsgTplType\":1,\"createTime\":1604741487290,\"id\":1325007949562777600,\"welcomeMsg\":\"5145145\"}', '{\"msg\":\"操作失败\",\"code\":500}', '0', null, '2020-11-07 09:31:27');
INSERT INTO `sys_oper_log` VALUES ('1045', '更换分组', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.resetCategory()', 'PUT', '1', 'admin', null, '/wecom/material/resetCategory', '223.244.119.109', 'XX XX', '{\"materials\":\"1324740546027196416,1324755535211401216\",\"categoryId\":\"1324735402212462592\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 10:58:00');
INSERT INTO `sys_oper_log` VALUES ('1046', '更换分组', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.resetCategory()', 'PUT', '1', 'admin', null, '/wecom/material/resetCategory', '223.244.121.171', 'XX XX', '{\"materials\":\"1324740546027196416,1324755535211401216\",\"categoryId\":\"1324734285034426368\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 11:49:52');
INSERT INTO `sys_oper_log` VALUES ('1047', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604749904486,\"params\":{},\"parentId\":0,\"createTime\":1604749904508,\"name\":\"图片分类一级\",\"id\":1325043253938098176}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 11:51:44');
INSERT INTO `sys_oper_log` VALUES ('1048', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604749924205,\"params\":{},\"parentId\":0,\"createTime\":1604749924227,\"name\":\"一级\",\"id\":1325043336641384448}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 11:52:04');
INSERT INTO `sys_oper_log` VALUES ('1049', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604760887583,\"params\":{},\"parentId\":1325043253938098176,\"createTime\":1604760887631,\"name\":\"二级\",\"id\":1325089320507412480}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 14:54:48');
INSERT INTO `sys_oper_log` VALUES ('1050', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604761409122,\"params\":{},\"parentId\":1325043253938098176,\"createTime\":1604761409138,\"name\":\"二级2\",\"id\":1325091507849531392}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 15:03:29');
INSERT INTO `sys_oper_log` VALUES ('1051', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604761422596,\"params\":{},\"parentId\":1325043336641384448,\"createTime\":1604761422596,\"name\":\"二级\",\"id\":1325091564296474624}', 'null', '1', '名称已存在！', '2020-11-07 15:03:43');
INSERT INTO `sys_oper_log` VALUES ('1052', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"0\",\"updateTime\":1604761470704,\"params\":{},\"parentId\":1325043336641384448,\"createTime\":1604761470725,\"name\":\"二级1\",\"id\":1325091766164131840}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 15:04:31');
INSERT INTO `sys_oper_log` VALUES ('1053', '企业微信客户同步接口', '3', 'com.linkwechat.web.controller.wecom.WeCustomerController.synchWeCustomer()', 'GET', '1', 'test', null, '/wecom/customer/synchWeCustomer', '180.119.178.116', 'XX XX', '{}', 'null', '1', '{\"errcode\":41001,\"errmsg\":\"access_token missing, hint: [1604768748_107_2bc55ec0fe4f80201610255e647bd033], from ip: 106.13.201.219, more info at https://open.work.weixin.qq.com/devtool/query?e=41001\",\"follow_user\":[]}', '2020-11-07 17:05:49');
INSERT INTO `sys_oper_log` VALUES ('1054', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"1\",\"updateTime\":1604769252885,\"params\":{},\"parentId\":0,\"createTime\":1604769252972,\"name\":\"1\",\"id\":1325124407273852928}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 17:14:13');
INSERT INTO `sys_oper_log` VALUES ('1055', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"4\",\"updateTime\":1604769283801,\"params\":{},\"parentId\":0,\"createTime\":1604769283861,\"name\":\"古乐\",\"id\":1325124536831709184}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-07 17:14:43');
INSERT INTO `sys_oper_log` VALUES ('1056', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/118e8067-abe8-4bc5-9e7e-cedcb6ee1533.jpg\"}}', '0', null, '2020-11-08 05:37:50');
INSERT INTO `sys_oper_log` VALUES ('1057', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/2e3744c0-d933-4e41-bd1e-82f39773a7f8.jpg\"}}', '0', null, '2020-11-08 06:04:54');
INSERT INTO `sys_oper_log` VALUES ('1058', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/2d8b7bbb-64c4-4b7d-a3ea-b893f915b3f6.jpg\"}}', '0', null, '2020-11-08 06:06:07');
INSERT INTO `sys_oper_log` VALUES ('1059', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/51b5b1d8-7c49-43a2-b076-4aa8091ffac5.jpg\"}}', '0', null, '2020-11-08 06:07:39');
INSERT INTO `sys_oper_log` VALUES ('1060', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/715a966c-b78d-42a8-afcd-0c01484eb29e.jpg\"}}', '0', null, '2020-11-08 06:10:06');
INSERT INTO `sys_oper_log` VALUES ('1061', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '0', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"a.jpg\",\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/77ace8e4-fba1-4627-9647-c0eeff7af653.jpg\"}}', '0', null, '2020-11-08 06:35:47');
INSERT INTO `sys_oper_log` VALUES ('1062', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.121.171', 'XX XX', '{\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/77ace8e4-fba1-4627-9647-c0eeff7af653.jpg\",\"updateTime\":1604817352816,\"params\":{},\"createTime\":1604817352828,\"id\":1325326152700661760,\"categoryId\":1325043253938098176}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 06:35:53');
INSERT INTO `sys_oper_log` VALUES ('1063', '更新素材信息', '2', 'com.linkwechat.web.controller.wecom.WeMaterialController.edit()', 'PUT', '1', 'admin', null, '/wecom/material', '223.244.121.171', 'XX XX', '{\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/77ace8e4-fba1-4627-9647-c0eeff7af653.jpg\",\"updateTime\":1604817353000,\"params\":{},\"content\":\"2+26+626+\",\"materialName\":\"156\",\"createTime\":1604819218154,\"id\":1325326152700661760,\"categoryId\":1325043253938098176}', 'null', '1', '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1325326152700661760\' for key \'PRIMARY\'\r\n### The error may exist in file [D:\\IdeaProjects\\link-wechat\\linkwe-wecom\\target\\classes\\mapper\\wecom\\WeMaterialMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: update we_material set                       id=?,                                 category_id=?,                                 material_url=?,                                 content=?,                                 material_name=?,                                                               create_time=?,                                           update_time=?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1325326152700661760\' for key \'PRIMARY\'\n; Duplicate entry \'1325326152700661760\' for key \'PRIMARY\'; nested exception is java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'1325326152700661760\' for key \'PRIMARY\'', '2020-11-08 07:06:58');
INSERT INTO `sys_oper_log` VALUES ('1064', '更新素材信息', '2', 'com.linkwechat.web.controller.wecom.WeMaterialController.edit()', 'PUT', '1', 'admin', null, '/wecom/material', '223.244.121.171', 'XX XX', '{\"materialUrl\":\"http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/77ace8e4-fba1-4627-9647-c0eeff7af653.jpg\",\"updateTime\":1604817353000,\"params\":{},\"content\":\"+626+\",\"materialName\":\"465\",\"createTime\":1604820145446,\"id\":1325326152700661760,\"categoryId\":1325043253938098176}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 07:22:26');
INSERT INTO `sys_oper_log` VALUES ('1065', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"icon\":\"qrcode\",\"orderNum\":\"20\",\"menuName\":\"引流码\",\"updateTime\":1604837504416,\"params\":{},\"parentId\":0,\"path\":\"/drainageCode\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604837504416,\"isFrame\":\"1\",\"menuType\":\"M\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:11:44');
INSERT INTO `sys_oper_log` VALUES ('1066', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"10\",\"menuName\":\"员工活码\",\"updateTime\":1604837601168,\"params\":{},\"parentId\":2052,\"path\":\"staff\",\"component\":\"/drainageCode/staff/list\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604837601168,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:staff:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:13:21');
INSERT INTO `sys_oper_log` VALUES ('1067', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"20\",\"menuName\":\"新建员工活码\",\"updateTime\":1604837695868,\"params\":{},\"parentId\":2052,\"path\":\"staffAdd\",\"component\":\"drainageCode/staff/add\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604837695868,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:staff:add\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:14:56');
INSERT INTO `sys_oper_log` VALUES ('1068', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"30\",\"menuName\":\"staffDetail\",\"updateTime\":1604837959851,\"params\":{},\"parentId\":2052,\"path\":\"staffDetail\",\"component\":\"drainageCode/staff/detail\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604837959851,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:staff:detail\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:19:20');
INSERT INTO `sys_oper_log` VALUES ('1069', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"30\",\"menuName\":\"员工活码详情\",\"updateTime\":1604838054000,\"params\":{},\"parentId\":2052,\"path\":\"staffDetail\",\"component\":\"drainageCode/staff/detail\",\"children\":[],\"createTime\":1604809159000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2055,\"menuType\":\"C\",\"perms\":\"drainageCode:staff:detail\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:20:59');
INSERT INTO `sys_oper_log` VALUES ('1070', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"40\",\"menuName\":\"客户群活码\",\"updateTime\":1604838375272,\"params\":{},\"parentId\":2052,\"path\":\"group\",\"component\":\"drainageCode/group/list\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604838375272,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:26:15');
INSERT INTO `sys_oper_log` VALUES ('1071', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"50\",\"menuName\":\"新增客户群活码\",\"updateTime\":1604838599956,\"params\":{},\"parentId\":2052,\"path\":\"groupAdd\",\"component\":\"/drainageCode/group/add\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604838599956,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:add\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:30:00');
INSERT INTO `sys_oper_log` VALUES ('1072', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"60\",\"menuName\":\"groupDetail\",\"updateTime\":1604838701793,\"params\":{},\"parentId\":2052,\"path\":\"groupDetail\",\"component\":\"drainageCode/group/detail\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604838701793,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:detail\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:31:42');
INSERT INTO `sys_oper_log` VALUES ('1073', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"icon\":\"#\",\"orderNum\":\"60\",\"menuName\":\"客户群活码信息\",\"updateTime\":1604838705000,\"params\":{},\"parentId\":2052,\"path\":\"groupDetail\",\"component\":\"drainageCode/group/detail\",\"children\":[],\"createTime\":1604809901000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2058,\"menuType\":\"C\",\"perms\":\"drainageCode:group:detail\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:31:51');
INSERT INTO `sys_oper_log` VALUES ('1074', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"70\",\"menuName\":\"客户群活码\",\"updateTime\":1604838922967,\"params\":{},\"parentId\":2052,\"path\":\"groupBaseInfo\",\"component\":\"drainageCode/group/baseInfo\",\"children\":[],\"createTime\":1604838922967,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:baseInfo\",\"status\":\"0\"}', '{\"msg\":\"新增菜单\'客户群活码\'失败，菜单名称已存在\",\"code\":500}', '0', null, '2020-11-08 12:35:23');
INSERT INTO `sys_oper_log` VALUES ('1075', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"70\",\"menuName\":\"客户群活码信息\",\"updateTime\":1604839110553,\"params\":{},\"parentId\":2052,\"path\":\"groupBaseInfo\",\"component\":\"drainageCode/group/baseInfo\",\"children\":[],\"createTime\":1604839110553,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:baseInfo\",\"status\":\"0\"}', '{\"msg\":\"新增菜单\'客户群活码信息\'失败，菜单名称已存在\",\"code\":500}', '0', null, '2020-11-08 12:38:30');
INSERT INTO `sys_oper_log` VALUES ('1076', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"70\",\"menuName\":\"客户群信息\",\"updateTime\":1604839131703,\"params\":{},\"parentId\":2052,\"path\":\"groupBaseInfo\",\"component\":\"drainageCode/group/baseInfo\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839131703,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:group:baseInfo\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:38:51');
INSERT INTO `sys_oper_log` VALUES ('1077', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"80\",\"menuName\":\"欢迎语\",\"updateTime\":1604839174504,\"params\":{},\"parentId\":2052,\"path\":\"welcome\",\"component\":\"drainageCode/welcome/list\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839174504,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:welcome:list\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:39:34');
INSERT INTO `sys_oper_log` VALUES ('1078', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"1\",\"orderNum\":\"90\",\"menuName\":\"新建欢迎语\",\"updateTime\":1604839212537,\"params\":{},\"parentId\":2052,\"path\":\"welcomeAdd\",\"component\":\"drainageCode/welcome/add\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839212537,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"drainageCode:welcome:add\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:40:12');
INSERT INTO `sys_oper_log` VALUES ('1079', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"icon\":\"material\",\"orderNum\":\"30\",\"menuName\":\"素材中心\",\"updateTime\":1604839281604,\"params\":{},\"parentId\":0,\"path\":\"/material\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839281604,\"isFrame\":\"1\",\"menuType\":\"M\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:41:21');
INSERT INTO `sys_oper_log` VALUES ('1080', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"10\",\"menuName\":\"文本\",\"updateTime\":1604839364585,\"params\":{},\"parentId\":2062,\"path\":\"text\",\"component\":\"material/text\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839364585,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"material:text\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:42:44');
INSERT INTO `sys_oper_log` VALUES ('1081', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"20\",\"menuName\":\"图片\",\"updateTime\":1604839402819,\"params\":{},\"parentId\":2062,\"path\":\"image\",\"component\":\"material/image\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839402819,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"material:image\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:43:22');
INSERT INTO `sys_oper_log` VALUES ('1082', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"30\",\"menuName\":\"语音\",\"updateTime\":1604839459456,\"params\":{},\"parentId\":2062,\"path\":\"audio\",\"component\":\"material/audio\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839459456,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"material:audio\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:44:19');
INSERT INTO `sys_oper_log` VALUES ('1083', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"40\",\"menuName\":\"视频\",\"updateTime\":1604839491904,\"params\":{},\"parentId\":2062,\"path\":\"video\",\"component\":\"material/video\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839491904,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"material:video\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:44:52');
INSERT INTO `sys_oper_log` VALUES ('1084', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"50\",\"menuName\":\"文件\",\"updateTime\":1604839522755,\"params\":{},\"parentId\":2062,\"path\":\"file\",\"component\":\"material/file\",\"createBy\":\"admin\",\"children\":[],\"createTime\":1604839522755,\"isFrame\":\"1\",\"menuType\":\"C\",\"perms\":\"material:file\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:45:22');
INSERT INTO `sys_oper_log` VALUES ('1085', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"10\",\"menuName\":\"添加分类\",\"updateTime\":1604840347926,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840347926,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:addType\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 12:59:08');
INSERT INTO `sys_oper_log` VALUES ('1086', '菜单管理', '2', 'com.linkwechat.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"icon\":\"#\",\"orderNum\":\"101\",\"menuName\":\"添加分类\",\"updateTime\":1604840367000,\"params\":{},\"parentId\":2062,\"path\":\"\",\"children\":[],\"createTime\":1604811548000,\"updateBy\":\"admin\",\"isFrame\":\"1\",\"menuId\":2068,\"menuType\":\"F\",\"perms\":\"material:addType\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:00:11');
INSERT INTO `sys_oper_log` VALUES ('1087', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"102\",\"menuName\":\"删除分类\",\"updateTime\":1604840560305,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840560305,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:removeType\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:02:40');
INSERT INTO `sys_oper_log` VALUES ('1088', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"103\",\"menuName\":\"编辑分类\",\"updateTime\":1604840618370,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840618370,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:edit\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:03:38');
INSERT INTO `sys_oper_log` VALUES ('1089', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"104\",\"menuName\":\"添加素材\",\"updateTime\":1604840662319,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840662319,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:add\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:04:22');
INSERT INTO `sys_oper_log` VALUES ('1090', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"105\",\"menuName\":\"删除素材\",\"updateTime\":1604840697553,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840697553,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:remove\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:04:57');
INSERT INTO `sys_oper_log` VALUES ('1091', '菜单管理', '1', 'com.linkwechat.web.controller.system.SysMenuController.add()', 'POST', '1', 'admin', null, '/system/menu', '223.244.121.171', 'XX XX', '{\"visible\":\"0\",\"orderNum\":\"106\",\"menuName\":\"编辑素材\",\"updateTime\":1604840722217,\"params\":{},\"parentId\":2062,\"createBy\":\"admin\",\"children\":[],\"createTime\":1604840722217,\"isFrame\":\"1\",\"menuType\":\"F\",\"perms\":\"material:edit\",\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:05:22');
INSERT INTO `sys_oper_log` VALUES ('1092', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', 'null', '1', '临时素材上传失败！', '2020-11-08 13:20:03');
INSERT INTO `sys_oper_log` VALUES ('1093', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', 'null', '1', 'filename : [sample.wav], extension : [wav], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf]]', '2020-11-08 13:23:28');
INSERT INTO `sys_oper_log` VALUES ('1094', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', 'null', '1', 'filename : [sample.wav], extension : [wav], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf]]', '2020-11-08 13:23:43');
INSERT INTO `sys_oper_log` VALUES ('1095', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"2.amr\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/f63179f9-ebf6-4ae8-891d-706dafb463c9.amr\"}}', '0', null, '2020-11-08 13:30:43');
INSERT INTO `sys_oper_log` VALUES ('1096', '添加类目', '1', 'com.linkwechat.web.controller.wecom.WeCategoryController.add()', 'POST', '1', 'admin', null, '/wecom/category', '223.244.121.171', 'XX XX', '{\"mediaType\":\"2\",\"updateTime\":1604842979552,\"params\":{},\"parentId\":0,\"createTime\":1604842979580,\"name\":\"1265\",\"id\":1325433639084888064}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 13:42:59');
INSERT INTO `sys_oper_log` VALUES ('1097', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '2', 'null', '1', 'filename : [企业微信.mp4], extension : [mp4], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf, wav, amr]]', '2020-11-08 13:45:27');
INSERT INTO `sys_oper_log` VALUES ('1098', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '2', 'null', '1', 'filename : [企业微信.mp4], extension : [mp4], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf, wav, amr]]', '2020-11-08 13:46:12');
INSERT INTO `sys_oper_log` VALUES ('1099', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '3', 'null', '1', 'filename : [elevator.exe], extension : [exe], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf, wav, amr, mp4]]', '2020-11-08 14:08:50');
INSERT INTO `sys_oper_log` VALUES ('1100', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '3', 'null', '1', 'filename : [ipr.reg], extension : [reg], allowed extension : [[bmp, gif, jpg, jpeg, png, doc, docx, xls, xlsx, ppt, pptx, html, htm, txt, rar, zip, gz, bz2, pdf, wav, amr, mp4]]', '2020-11-08 14:19:09');
INSERT INTO `sys_oper_log` VALUES ('1101', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '3', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"ipr.reg\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile//2020/11/08/3d8f56e4-7b69-4d76-9bee-d891d7cef8bd.reg\"}}', '0', null, '2020-11-08 14:20:25');
INSERT INTO `sys_oper_log` VALUES ('1102', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '2', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"企业微信.mp4\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/31631afd-8f32-4e08-ad74-9c94d6af6fa1.mp4\"}}', '0', null, '2020-11-08 14:22:26');
INSERT INTO `sys_oper_log` VALUES ('1103', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.121.171', 'XX XX', '{\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/31631afd-8f32-4e08-ad74-9c94d6af6fa1.mp4\",\"updateTime\":1604845397228,\"params\":{},\"createTime\":1604845397234,\"id\":1325443779464925184,\"categoryId\":1325433639084888064}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 14:23:17');
INSERT INTO `sys_oper_log` VALUES ('1104', '删除素材信息', '3', 'com.linkwechat.web.controller.wecom.WeMaterialController.remove()', 'DELETE', '1', 'admin', null, '/wecom/material/1324755535211401216', '223.244.121.171', 'XX XX', '{ids=1324755535211401216}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 14:23:32');
INSERT INTO `sys_oper_log` VALUES ('1105', '删除类目', '3', 'com.linkwechat.web.controller.wecom.WeCategoryController.remove()', 'DELETE', '1', 'admin', null, '/wecom/category/1325124536831709184', '223.244.121.171', 'XX XX', '{ids=1325124536831709184}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 14:23:41');
INSERT INTO `sys_oper_log` VALUES ('1106', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"2.amr\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/2916a8f4-f88d-4329-9592-9d679f62a4be.amr\"}}', '0', null, '2020-11-08 14:26:05');
INSERT INTO `sys_oper_log` VALUES ('1107', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"2.amr\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/3d94676f-1862-4799-bb9e-98cd5e96ba25.amr\"}}', '0', null, '2020-11-08 14:32:26');
INSERT INTO `sys_oper_log` VALUES ('1108', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"2.amr\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/c9e0eb26-a308-4d56-b2b5-777b1997747c.amr\"}}', '0', null, '2020-11-08 14:32:31');
INSERT INTO `sys_oper_log` VALUES ('1109', '上传素材信息', '0', 'com.linkwechat.web.controller.wecom.WeMaterialController.upload()', 'POST', '1', 'admin', null, '/wecom/material/upload', '223.244.121.171', 'XX XX', '1', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"materialName\":\"2.amr\",\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/67222805-7a5e-447f-bdc6-1ebf5d8c23bd.amr\"}}', '0', null, '2020-11-08 14:33:30');
INSERT INTO `sys_oper_log` VALUES ('1110', '添加素材信息', '1', 'com.linkwechat.web.controller.wecom.WeMaterialController.add()', 'POST', '1', 'admin', null, '/wecom/material', '223.244.121.171', 'XX XX', '{\"materialUrl\":\"http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/67222805-7a5e-447f-bdc6-1ebf5d8c23bd.amr\",\"updateTime\":1604846014548,\"params\":{},\"materialName\":\"2.amr\",\"createTime\":1604846014551,\"id\":1325446368671698944,\"categoryId\":1325124407273852928}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2020-11-08 14:33:34');

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int(11) NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='岗位信息表';

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES ('1', 'ceo', '董事长', '1', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_post` VALUES ('2', 'se', '项目经理', '2', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_post` VALUES ('3', 'hr', '人力资源', '3', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');
INSERT INTO `sys_post` VALUES ('4', 'user', '普通员工', '4', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(11) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '超级管理员', 'admin', '1', '1', '0', '0', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '超级管理员');
INSERT INTO `sys_role` VALUES ('2', '企业微信用户', 'WeCome', '2', '2', '0', '0', 'admin', '2018-03-16 11:33:00', 'admin', '2020-11-01 07:07:40', '企业微信用户');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色和部门关联表';

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES ('2', '100');
INSERT INTO `sys_role_dept` VALUES ('2', '101');
INSERT INTO `sys_role_dept` VALUES ('2', '105');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('2', '2001');
INSERT INTO `sys_role_menu` VALUES ('2', '2002');
INSERT INTO `sys_role_menu` VALUES ('2', '2003');
INSERT INTO `sys_role_menu` VALUES ('2', '2004');
INSERT INTO `sys_role_menu` VALUES ('2', '2005');
INSERT INTO `sys_role_menu` VALUES ('2', '2006');
INSERT INTO `sys_role_menu` VALUES ('2', '2007');
INSERT INTO `sys_role_menu` VALUES ('2', '2008');
INSERT INTO `sys_role_menu` VALUES ('2', '2009');
INSERT INTO `sys_role_menu` VALUES ('2', '2012');
INSERT INTO `sys_role_menu` VALUES ('2', '2014');
INSERT INTO `sys_role_menu` VALUES ('2', '2015');
INSERT INTO `sys_role_menu` VALUES ('2', '2016');
INSERT INTO `sys_role_menu` VALUES ('2', '2018');
INSERT INTO `sys_role_menu` VALUES ('2', '2020');
INSERT INTO `sys_role_menu` VALUES ('2', '2021');
INSERT INTO `sys_role_menu` VALUES ('2', '2022');
INSERT INTO `sys_role_menu` VALUES ('2', '2023');
INSERT INTO `sys_role_menu` VALUES ('2', '2024');
INSERT INTO `sys_role_menu` VALUES ('2', '2025');
INSERT INTO `sys_role_menu` VALUES ('2', '2026');
INSERT INTO `sys_role_menu` VALUES ('2', '2027');
INSERT INTO `sys_role_menu` VALUES ('2', '2028');
INSERT INTO `sys_role_menu` VALUES ('2', '2029');
INSERT INTO `sys_role_menu` VALUES ('2', '2030');
INSERT INTO `sys_role_menu` VALUES ('2', '2031');
INSERT INTO `sys_role_menu` VALUES ('2', '2032');
INSERT INTO `sys_role_menu` VALUES ('2', '2034');
INSERT INTO `sys_role_menu` VALUES ('2', '2035');
INSERT INTO `sys_role_menu` VALUES ('2', '2036');
INSERT INTO `sys_role_menu` VALUES ('2', '2037');
INSERT INTO `sys_role_menu` VALUES ('2', '2038');
INSERT INTO `sys_role_menu` VALUES ('2', '2048');
INSERT INTO `sys_role_menu` VALUES ('2', '2049');
INSERT INTO `sys_role_menu` VALUES ('2', '2050');
INSERT INTO `sys_role_menu` VALUES ('2', '2051');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）(11:企业微信用户)',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(50) DEFAULT '' COMMENT '最后登陆IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', '103', 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$2fp6IaGJlTLIZ1B/Uf5vH.Kvm0RtJLWtZi21aL5bqxiNqSbgqcqae', '0', '0', '127.0.0.1', '2018-03-16 11:33:00', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '管理员');
INSERT INTO `sys_user` VALUES ('2', '105', 'ry', '塬微', '00', 'yw@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2018-03-16 11:33:00', 'admin', '2018-03-16 11:33:00', 'admin', '2020-09-13 15:36:10', '测试员');
INSERT INTO `sys_user` VALUES ('100', '103', 'admin1111', '1212', '00', '1539136324@qq.com', '18158873856', '0', '', '$2a$10$3YQW427CAAZKRCitiQWif.PDcQN2VskNsxWJV.1olVJVb/ebR/MhC', '0', '2', '', null, 'admin', '2020-09-18 19:08:03', '', null, null);
INSERT INTO `sys_user` VALUES ('101', '103', 'HaoN', 'HaoN', '00', '18158873850@163.com', '18158873850', '0', '', '$2a$10$pEMOaH/3PSwVhM4q.0lEf.ySxjSJL/c1vMp470LUoMSsOdteGBaxy', '0', '2', '', null, 'admin', '2020-10-20 11:32:24', '', null, null);
INSERT INTO `sys_user` VALUES ('102', '103', 'test', 'test', '00', '1539136325@qq.com', '13956925008', '0', '', '$2a$10$xIkXYWKgjh28POMexRgzE.BveFrRQavLZA1yvnZXxBbShtWfeFRxi', '0', '0', '', null, 'admin', '2020-10-28 11:49:40', '', null, '测试用户');
INSERT INTO `sys_user` VALUES ('104', null, '18158873850', '盛锡勇', '11', '', '18158873850', '1', '', '$2a$10$1LQgXzr2RxTZJ1JkgYCW5ezK/vD45cxCqzY5OI7Mds1F1H7laC9he', '0', '0', '', null, '', '2020-11-01 07:34:02', '', null, null);
INSERT INTO `sys_user` VALUES ('105', null, 'Kong', '柯鹏浩', '11', '', '18056630169', '1', '', '$2a$10$U7j8B2im9eXWZ2xsll56TO.XlZtGf2FxApXpIP/kG9h2NKAlyGa3u', '0', '0', '', null, '', '2020-11-01 07:38:53', '', null, null);
INSERT INTO `sys_user` VALUES ('106', null, 'XuXueJun', '徐学军', '11', '1570728529@qq.com', '18654148698', '1', '', '$2a$10$HtViHdkY1nRqw4z2tOE6RuScWgZlBYugBlW1MnMhyasxeYCr2.6B.', '0', '0', '', null, '', '2020-11-04 07:55:44', '', null, null);
INSERT INTO `sys_user` VALUES ('107', '109', '测试新增', '测试', '00', '113775422@qq.com', '13266548392', '0', '', '$2a$10$Y3ijHot0ldFxsMAa7.kqFu2HcvzTm9aMeC1wJbTfmWoJ2rQhnPM72', '0', '0', '', null, 'admin', '2020-11-05 09:35:19', '', null, null);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户与岗位关联表';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES ('1', '1');
INSERT INTO `sys_user_post` VALUES ('2', '2');
INSERT INTO `sys_user_post` VALUES ('107', '4');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1', '1');
INSERT INTO `sys_user_role` VALUES ('2', '2');
INSERT INTO `sys_user_role` VALUES ('101', '2');
INSERT INTO `sys_user_role` VALUES ('102', '2');
INSERT INTO `sys_user_role` VALUES ('104', '2');
INSERT INTO `sys_user_role` VALUES ('105', '2');
INSERT INTO `sys_user_role` VALUES ('106', '2');

-- ----------------------------
-- Table structure for we_allocate_customer
-- ----------------------------
DROP TABLE IF EXISTS `we_allocate_customer`;
CREATE TABLE `we_allocate_customer` (
  `id` bigint(20) NOT NULL,
  `takeover_userid` varchar(32) NOT NULL COMMENT '接替成员的userid',
  `external_userid` varchar(32) NOT NULL COMMENT '被分配的客户id',
  `allocate_time` datetime NOT NULL COMMENT '分配时间',
  `handover_userid` varchar(32) DEFAULT NULL COMMENT '原跟进成员的userid',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='离职分配的客户列表';

-- ----------------------------
-- Records of we_allocate_customer
-- ----------------------------
INSERT INTO `we_allocate_customer` VALUES ('1321116275060150274', '15665400628', 'wm2H-nDQAAdUkp__-t-f2hY0PEiiDHWQ', '2020-10-27 23:47:20', '18158873850');
INSERT INTO `we_allocate_customer` VALUES ('1321460630959460354', 'XuXueJun', 'wm2H-nDQAAdUkp__-t-f2hY0PEiiDHWQ', '2020-10-28 22:35:40', '15665400628');
INSERT INTO `we_allocate_customer` VALUES ('1321460630959460355', 'XuXueJun', 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', '2020-10-28 22:35:40', '15665400628');

-- ----------------------------
-- Table structure for we_allocate_group
-- ----------------------------
DROP TABLE IF EXISTS `we_allocate_group`;
CREATE TABLE `we_allocate_group` (
  `id` bigint(20) NOT NULL,
  `chat_id` varchar(32) DEFAULT NULL COMMENT '分配的群id',
  `new_owner` varchar(32) DEFAULT NULL COMMENT '新群主',
  `old_owner` varchar(32) DEFAULT NULL COMMENT '原群主',
  `allocate_time` datetime DEFAULT NULL COMMENT '分配时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分配的群租';

-- ----------------------------
-- Records of we_allocate_group
-- ----------------------------
INSERT INTO `we_allocate_group` VALUES ('1321116281255137281', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', '15665400628', '18158873850', '2020-10-27 23:47:21');
INSERT INTO `we_allocate_group` VALUES ('1321116281263525890', 'wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', '15665400628', '18158873850', '2020-10-27 23:47:21');
INSERT INTO `we_allocate_group` VALUES ('1321460637364162561', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', 'XuXueJun', '15665400628', '2020-10-28 22:35:42');
INSERT INTO `we_allocate_group` VALUES ('1321460637368356865', 'wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', 'XuXueJun', '15665400628', '2020-10-28 22:35:42');

-- ----------------------------
-- Table structure for we_category
-- ----------------------------
DROP TABLE IF EXISTS `we_category`;
CREATE TABLE `we_category` (
  `id` bigint(100) NOT NULL COMMENT '主键id',
  `media_type` int(1) NOT NULL COMMENT '0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)',
  `name` varchar(50) DEFAULT NULL COMMENT '分类名称',
  `parent_id` bigint(100) DEFAULT '0' COMMENT '父分类的id',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `del_flag` int(1) DEFAULT '0' COMMENT '0  未删除 1 已删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of we_category
-- ----------------------------
INSERT INTO `we_category` VALUES ('1324734285034426368', '4', '1965156', '0', null, '2020-11-06 23:24:01', null, '2020-11-06 23:24:01', '0');
INSERT INTO `we_category` VALUES ('1324735402212462592', '4', '16156', '0', null, '2020-11-06 23:28:27', null, '2020-11-06 23:28:27', '0');
INSERT INTO `we_category` VALUES ('1324745072012562432', '4', '和大热天的人', '1324734285034426368', null, '2020-11-07 00:06:52', null, '2020-11-07 00:06:52', '0');
INSERT INTO `we_category` VALUES ('1324745109140541440', '4', '和大热天大热天', '1324735402212462592', null, '2020-11-07 00:07:01', null, '2020-11-07 00:07:01', '0');
INSERT INTO `we_category` VALUES ('1325043253938098176', '0', '图片分类一级', '0', null, '2020-11-07 19:51:45', null, '2020-11-07 19:51:44', '0');
INSERT INTO `we_category` VALUES ('1325043336641384448', '0', '一级', '0', null, '2020-11-07 19:52:04', null, '2020-11-07 19:52:04', '0');
INSERT INTO `we_category` VALUES ('1325089320507412480', '0', '二级', '1325043253938098176', null, '2020-11-07 22:54:48', null, '2020-11-07 22:54:48', '0');
INSERT INTO `we_category` VALUES ('1325091507849531392', '0', '二级2', '1325043253938098176', null, '2020-11-07 23:03:29', null, '2020-11-07 23:03:29', '0');
INSERT INTO `we_category` VALUES ('1325091766164131840', '0', '二级1', '1325043336641384448', null, '2020-11-07 23:04:31', null, '2020-11-07 23:04:31', '0');
INSERT INTO `we_category` VALUES ('1325124407273852928', '1', '1', '0', null, '2020-11-08 01:14:13', null, '2020-11-08 01:14:13', '0');
INSERT INTO `we_category` VALUES ('1325124536831709184', '4', '古乐', '0', null, '2020-11-08 01:14:44', null, '2020-11-08 01:14:44', '1');
INSERT INTO `we_category` VALUES ('1325433639084888064', '2', '1265', '0', null, '2020-11-08 21:43:00', null, '2020-11-08 21:43:00', '0');

-- ----------------------------
-- Table structure for we_corp_account
-- ----------------------------
DROP TABLE IF EXISTS `we_corp_account`;
CREATE TABLE `we_corp_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) DEFAULT NULL COMMENT '企业名称',
  `corp_id` varchar(64) DEFAULT NULL COMMENT '企业ID',
  `corp_secret` varchar(64) DEFAULT NULL COMMENT '应用的密钥凭证',
  `contact_secret` varchar(64) DEFAULT NULL COMMENT '外部联系人密钥',
  `wx_qr_login_redirect_uri` varchar(64) DEFAULT NULL COMMENT '企业微信扫码登陆系统回调地址',
  `provider_secret` varchar(64) DEFAULT NULL,
  `agent_id` varchar(64) DEFAULT NULL COMMENT '应用id',
  `status` char(1) DEFAULT '1' COMMENT '帐号状态（0正常 1停用)',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='企业id相关配置';

-- ----------------------------
-- Records of we_corp_account
-- ----------------------------
INSERT INTO `we_corp_account` VALUES ('8', '康有保', 'ww24262ce93851488f', '4_aGghgsQoxYzeF9V4chLtUiUVTDlYWpT8tXuFpZVjU', 'IVGWHwB8_1vXUq3ye7R0lvafTwbHT9bIOLfxYuVhx4Y', 'http://106.13.201.219/#/authCallback', 'O3E1bQrlidwXFfGVTRmObH3ZZy0SXq13y60xgSu9Fzk', null, '0', '0', null, '2020-11-04 13:54:45', null, '2020-11-04 13:54:45');
INSERT INTO `we_corp_account` VALUES ('9', '456564165', '52616', '11111111', '456526', '22222222222222', '26456', null, '1', '0', null, '2020-11-04 22:38:38', null, '2020-11-04 22:38:38');

-- ----------------------------
-- Table structure for we_customer
-- ----------------------------
DROP TABLE IF EXISTS `we_customer`;
CREATE TABLE `we_customer` (
  `external_userid` varchar(32) NOT NULL COMMENT '外部联系人的userid',
  `name` varchar(32) DEFAULT NULL COMMENT '外部联系人名称',
  `avatar` varchar(200) DEFAULT NULL COMMENT '外部联系人头像',
  `type` tinyint(4) DEFAULT NULL COMMENT '外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户',
  `gender` tinyint(4) DEFAULT NULL COMMENT '外部联系人性别 0-未知 1-男性 2-女性',
  `unionid` varchar(32) DEFAULT NULL COMMENT '外部联系人在微信开放平台的唯一身份标识,通过此字段企业可将外部联系人与公众号/小程序用户关联起来。',
  `birthday` datetime DEFAULT NULL COMMENT '生日',
  `corp_name` varchar(100) DEFAULT NULL COMMENT '客户企业简称',
  `corp_full_name` varchar(100) DEFAULT NULL COMMENT '客户企业全称',
  `position` varchar(100) DEFAULT NULL COMMENT '客户职位',
  PRIMARY KEY (`external_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信客户表';

-- ----------------------------
-- Records of we_customer
-- ----------------------------
INSERT INTO `we_customer` VALUES ('wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', '45度', 'http://wx.qlogo.cn/mmhead/uI5pczeERTbdXh2yJLy6T3DhHWfdLkrOvZCibCIia0Q706U18UsTUrJw/0', '1', '1', null, null, null, null, null);

-- ----------------------------
-- Table structure for we_department
-- ----------------------------
DROP TABLE IF EXISTS `we_department`;
CREATE TABLE `we_department` (
  `id` bigint(20) NOT NULL,
  `name` varchar(64) NOT NULL COMMENT '部门名称',
  `parent_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信组织架构相关';

-- ----------------------------
-- Records of we_department
-- ----------------------------
INSERT INTO `we_department` VALUES ('1', '康有保', '0');
INSERT INTO `we_department` VALUES ('4294967294', '软件部', '1');
INSERT INTO `we_department` VALUES ('4294967295', '总经办', '1');

-- ----------------------------
-- Table structure for we_emple_code
-- ----------------------------
DROP TABLE IF EXISTS `we_emple_code`;
CREATE TABLE `we_emple_code` (
  `id` bigint(20) NOT NULL,
  `code_type` tinyint(4) DEFAULT NULL COMMENT '活码类型:1:批量;2:单人;3:多人;',
  `is_join_confirm_friends` tinyint(4) DEFAULT NULL COMMENT '客户添加时无需经过确认自动成为好友:1:是;0:否',
  `activity_scene` varchar(70) DEFAULT NULL COMMENT '活动场景',
  `welcome_msg` varchar(60) DEFAULT NULL COMMENT '欢迎语',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `del_flag` tinyint(4) DEFAULT NULL COMMENT '0:正常;1:删除;',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工活码表';

-- ----------------------------
-- Records of we_emple_code
-- ----------------------------
INSERT INTO `we_emple_code` VALUES ('1316026794918416384', '1', '0', '活动添加', '欢迎加我好友', null, '2020-10-13 22:43:33', '0');
INSERT INTO `we_emple_code` VALUES ('1316031133099626496', '1', '0', '活动添加', '欢迎加我好友', null, '2020-10-13 23:00:47', '0');
INSERT INTO `we_emple_code` VALUES ('1316032275879694336', '1', '0', '活动添加', '欢迎加我好友', null, '2020-10-13 23:05:20', '0');
INSERT INTO `we_emple_code` VALUES ('1316032806769528832', '1', '0', '活动添加', '欢迎加我好友', null, '2020-10-13 23:07:26', '0');
INSERT INTO `we_emple_code` VALUES ('1316042981685465088', '1', '0', '活动', '欢迎', null, '2020-10-13 23:47:52', '0');
INSERT INTO `we_emple_code` VALUES ('1316043881288175616', '1', '0', '活动', '欢迎', null, '2020-10-13 23:51:27', '0');

-- ----------------------------
-- Table structure for we_emple_code_tag
-- ----------------------------
DROP TABLE IF EXISTS `we_emple_code_tag`;
CREATE TABLE `we_emple_code_tag` (
  `id` bigint(20) NOT NULL,
  `tag_id` bigint(20) DEFAULT NULL COMMENT '标签id',
  `emple_code_id` bigint(20) DEFAULT NULL COMMENT '员工活码id',
  `del_flag` tinyint(4) DEFAULT '0' COMMENT '0:正常;2:删除;',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工活码标签';

-- ----------------------------
-- Records of we_emple_code_tag
-- ----------------------------

-- ----------------------------
-- Table structure for we_emple_code_use_scop
-- ----------------------------
DROP TABLE IF EXISTS `we_emple_code_use_scop`;
CREATE TABLE `we_emple_code_use_scop` (
  `id` bigint(20) NOT NULL,
  `emple_code_id` bigint(20) DEFAULT NULL COMMENT '员工活码id',
  `business_id` bigint(20) DEFAULT NULL COMMENT '活码类型下业务使用人的id',
  `del_flag` tinyint(4) DEFAULT NULL COMMENT '0:正常;2:删除;',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工活码使用人';

-- ----------------------------
-- Records of we_emple_code_use_scop
-- ----------------------------
INSERT INTO `we_emple_code_use_scop` VALUES ('1316026794918416385', '1316026794918416384', '18158873850', '0');
INSERT INTO `we_emple_code_use_scop` VALUES ('1316031133099626497', '1316031133099626496', '18158873850', '0');
INSERT INTO `we_emple_code_use_scop` VALUES ('1316032275879694337', '1316032275879694336', '18158873850', '0');
INSERT INTO `we_emple_code_use_scop` VALUES ('1316032806769528833', '1316032806769528832', '18158873850', '0');
INSERT INTO `we_emple_code_use_scop` VALUES ('1316042981685465089', '1316042981685465088', '18158873850', '0');
INSERT INTO `we_emple_code_use_scop` VALUES ('1316043881288175617', '1316043881288175616', '18158873850', '0');

-- ----------------------------
-- Table structure for we_flower_customer_rel
-- ----------------------------
DROP TABLE IF EXISTS `we_flower_customer_rel`;
CREATE TABLE `we_flower_customer_rel` (
  `id` bigint(20) NOT NULL,
  `user_id` varchar(32) DEFAULT NULL COMMENT '添加了此外部联系人的企业成员userid',
  `remark` varchar(100) DEFAULT NULL COMMENT '该成员对此外部联系人的备注',
  `description` tinytext COMMENT '该成员对此外部联系人的描述',
  `create_time` datetime DEFAULT NULL COMMENT '该成员添加此外部联系人的时间',
  `remark_corp_name` varchar(100) DEFAULT NULL COMMENT '该成员对此客户备注的企业名称\r\n',
  `remark_mobiles` varchar(255) DEFAULT NULL COMMENT '该成员对此客户备注的手机号码',
  `oper_userid` varchar(32) DEFAULT NULL COMMENT '发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid',
  `add_way` varchar(30) DEFAULT NULL COMMENT '该成员添加此客户的来源，',
  `state` varchar(30) DEFAULT NULL COMMENT '企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定',
  `external_userid` varchar(32) DEFAULT NULL COMMENT '客户id',
  `status` char(255) DEFAULT '0' COMMENT '状态（0正常 1删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='具有外部联系人功能企业员工也客户的关系表';

-- ----------------------------
-- Records of we_flower_customer_rel
-- ----------------------------
INSERT INTO `we_flower_customer_rel` VALUES ('1324629099565682688', 'XuXueJun', null, '', '2020-10-29 22:35:44', null, '', null, null, null, 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', '0');

-- ----------------------------
-- Table structure for we_flower_customer_tag_rel
-- ----------------------------
DROP TABLE IF EXISTS `we_flower_customer_tag_rel`;
CREATE TABLE `we_flower_customer_tag_rel` (
  `id` bigint(20) NOT NULL,
  `flower_customer_rel_id` bigint(20) NOT NULL COMMENT '添加客户的企业微信用户',
  `tag_id` varchar(32) NOT NULL COMMENT '标签id',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户标签关系表';

-- ----------------------------
-- Records of we_flower_customer_tag_rel
-- ----------------------------
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1324604969118662658', '1324604963900493824', 'et4_fSDAAA_wpbwIIUroXo56dJXyZHLQ', '2020-11-06 14:50:08');
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1324629102778396674', '1324629099565682688', 'et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ', '2020-11-06 16:26:02');
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1324629102786785281', '1324629099565682688', 'et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw', '2020-11-06 16:26:02');
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1324629102786785282', '1324629099565682688', 'et2H-nDQAALPTXhYLwzwtMc25IE3COFw', '2020-11-06 16:26:02');

-- ----------------------------
-- Table structure for we_group
-- ----------------------------
DROP TABLE IF EXISTS `we_group`;
CREATE TABLE `we_group` (
  `chat_id` varchar(32) NOT NULL,
  `group_name` varchar(20) DEFAULT NULL COMMENT '群名',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `notice` varchar(100) DEFAULT NULL COMMENT '群公告',
  `owner` varchar(32) DEFAULT NULL COMMENT '群主userId',
  `status` tinyint(1) DEFAULT '0' COMMENT '0 - 正常;1 - 跟进人离职;2 - 离职继承中;3 - 离职继承完成',
  PRIMARY KEY (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信群';

-- ----------------------------
-- Records of we_group
-- ----------------------------
INSERT INTO `we_group` VALUES ('wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', '哈牛逼群', '2020-10-20 14:05:41', null, 'XuXueJun', '3');
INSERT INTO `we_group` VALUES ('wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', '测试群', '2020-10-27 22:24:21', null, 'XuXueJun', '3');

-- ----------------------------
-- Table structure for we_group_code
-- ----------------------------
DROP TABLE IF EXISTS `we_group_code`;
CREATE TABLE `we_group_code` (
  `id` bigint(20) NOT NULL,
  `activity_head_url` varchar(60) DEFAULT NULL COMMENT '活动头像',
  `activity_name` varchar(60) DEFAULT NULL COMMENT '活动名称',
  `activity_scene` varchar(60) DEFAULT NULL COMMENT '场景',
  `guide` varchar(60) DEFAULT NULL COMMENT '引导语',
  `join_group_is_tip` tinyint(4) DEFAULT NULL COMMENT '进群是否提示:1:是;0:否;',
  `tip_msg` varchar(100) DEFAULT NULL COMMENT '进群提示语',
  `customer_server_qr_code` varchar(100) DEFAULT NULL COMMENT '客服二维码',
  `del_flag` tinyint(4) DEFAULT NULL COMMENT '0:正常;2:删除;',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户群活码';

-- ----------------------------
-- Records of we_group_code
-- ----------------------------

-- ----------------------------
-- Table structure for we_group_code_actual
-- ----------------------------
DROP TABLE IF EXISTS `we_group_code_actual`;
CREATE TABLE `we_group_code_actual` (
  `id` bigint(20) NOT NULL,
  `actual_group_qr_code` varchar(100) DEFAULT NULL COMMENT '实际群码',
  `group_name` varchar(100) DEFAULT NULL COMMENT '群名称',
  `effect_time` datetime DEFAULT NULL COMMENT '有效期',
  `scan_code_times_limit` int(11) DEFAULT NULL COMMENT '扫码次数限制',
  `group_code_id` bigint(20) DEFAULT NULL COMMENT '群活码id',
  `scan_code_times` int(11) DEFAULT NULL COMMENT '扫码次数',
  `del_flag` tinyint(4) DEFAULT NULL COMMENT '0:正常使用;2:删除;',
  `status` tinyint(4) DEFAULT '0' COMMENT '0:使用中',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实际群码';

-- ----------------------------
-- Records of we_group_code_actual
-- ----------------------------

-- ----------------------------
-- Table structure for we_group_member
-- ----------------------------
DROP TABLE IF EXISTS `we_group_member`;
CREATE TABLE `we_group_member` (
  `id` bigint(20) NOT NULL,
  `user_id` varchar(32) DEFAULT NULL COMMENT '群成员id',
  `chat_id` varchar(32) DEFAULT NULL COMMENT '群id',
  `union_id` varchar(32) DEFAULT NULL COMMENT '外部联系人在微信开放平台的唯一身份标识',
  `join_time` timestamp NULL DEFAULT NULL COMMENT '加群时间',
  `join_scene` tinyint(4) DEFAULT NULL COMMENT '加入方式',
  `type` tinyint(4) DEFAULT NULL COMMENT '成员类型:1 - 企业成员;2 - 外部联系人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信群成员';

-- ----------------------------
-- Records of we_group_member
-- ----------------------------
INSERT INTO `we_group_member` VALUES ('1323893540236845057', 'XuXueJun', 'wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', null, '2020-10-28 22:35:42', '1', '1');
INSERT INTO `we_group_member` VALUES ('1323893540241039361', 'XuXueJun', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', null, '2020-10-20 14:05:41', '1', '1');
INSERT INTO `we_group_member` VALUES ('1323893540241039362', 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', null, '2020-10-20 14:05:41', '1', '2');

-- ----------------------------
-- Table structure for we_material
-- ----------------------------
DROP TABLE IF EXISTS `we_material`;
CREATE TABLE `we_material` (
  `id` bigint(100) NOT NULL COMMENT '主键id',
  `category_id` bigint(100) DEFAULT NULL COMMENT '分类id',
  `material_url` varchar(255) DEFAULT NULL COMMENT '本地资源文件地址',
  `content` text COMMENT '文本内容、图片文案',
  `material_name` varchar(80) DEFAULT NULL COMMENT '图片名称',
  `digest` varchar(255) DEFAULT NULL COMMENT '摘要',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `cover_url` varchar(255) DEFAULT NULL COMMENT '封面本地资源文件',
  `del_flag` int(1) DEFAULT '0' COMMENT '0 未删除 1 已删除',
  `audio_time` varchar(10) DEFAULT '0' COMMENT '音频时长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of we_material
-- ----------------------------
INSERT INTO `we_material` VALUES ('1324740546027196416', '1324734285034426368', null, '26+25+61561', null, null, null, '2020-11-06 23:58:33', null, '2020-11-06 23:48:53', null, '0', null);
INSERT INTO `we_material` VALUES ('1324755535211401216', '1324734285034426368', null, '16515', null, null, null, '2020-11-07 00:48:27', null, '2020-11-07 00:48:27', null, '1', null);
INSERT INTO `we_material` VALUES ('1325326152700661760', '1325043253938098176', 'http://cqbjnh.natappfree.cc/profile/upload/2020/11/08/77ace8e4-fba1-4627-9647-c0eeff7af653.jpg', '+626+', '465', null, null, '2020-11-08 15:22:25', null, '2020-11-08 14:35:53', null, '0', null);
INSERT INTO `we_material` VALUES ('1325443779464925184', '1325433639084888064', 'http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/31631afd-8f32-4e08-ad74-9c94d6af6fa1.mp4', null, null, null, null, '2020-11-08 22:23:17', null, '2020-11-08 22:23:17', null, '0', null);
INSERT INTO `we_material` VALUES ('1325446368671698944', '1325124407273852928', 'http://n3rpzt.natappfree.cc/profile/upload/2020/11/08/67222805-7a5e-447f-bdc6-1ebf5d8c23bd.amr', null, '2.amr', null, null, '2020-11-08 22:33:35', null, '2020-11-08 22:33:35', null, '0', null);

-- ----------------------------
-- Table structure for we_message_push
-- ----------------------------
DROP TABLE IF EXISTS `we_message_push`;
CREATE TABLE `we_message_push` (
  `message_push_id` bigint(20) NOT NULL COMMENT '主键id',
  `push_type` int(1) DEFAULT '0' COMMENT '群发类型 0 发给客户 1 发给客户群',
  `message_type` varchar(2) DEFAULT NULL COMMENT '消息类型 0 文本消息  1 图片消息 2 语音消息  3 视频消息    4 文件消息 5 文本卡片消息 6 图文消息\r\n7 图文消息（mpnews） 8 markdown消息 9 小程序通知消息 10 任务卡片消息',
  `to_user` varchar(1000) DEFAULT NULL COMMENT '指定接收消息的成员',
  `to_party` varchar(255) DEFAULT NULL COMMENT '指定接收消息的部门',
  `to_tag` varchar(255) DEFAULT NULL COMMENT '指定接收消息的标签',
  `message_json` text COMMENT '消息体',
  `push_range` varchar(1) DEFAULT NULL COMMENT '消息范围 0 全部客户  1 指定客户',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `del_flag` int(1) DEFAULT NULL COMMENT '0 未删除 1 已删除',
  `invaliduser` varchar(255) DEFAULT NULL COMMENT '无效用户',
  `invalidparty` varchar(255) DEFAULT NULL COMMENT '无效单位',
  `invalidtag` varchar(255) DEFAULT NULL COMMENT '无效标签',
  `chat_id` text COMMENT '群聊id',
  PRIMARY KEY (`message_push_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='消息发送的表';

-- ----------------------------
-- Records of we_message_push
-- ----------------------------

-- ----------------------------
-- Table structure for we_msg_tlp
-- ----------------------------
DROP TABLE IF EXISTS `we_msg_tlp`;
CREATE TABLE `we_msg_tlp` (
  `id` bigint(20) NOT NULL,
  `welcome_msg` varchar(255) DEFAULT NULL COMMENT '欢迎语',
  `media_id` bigint(20) DEFAULT NULL COMMENT '素材的id',
  `del_flag` tinyint(4) DEFAULT '0' COMMENT '0:正常;2:删除;',
  `welcome_msg_tpl_type` tinyint(4) DEFAULT NULL COMMENT '欢迎语模板类型:1:员工欢迎语;2:部门员工欢迎语;3:客户群欢迎语',
  `create_by` varchar(60) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='欢迎语模板表';

-- ----------------------------
-- Records of we_msg_tlp
-- ----------------------------
INSERT INTO `we_msg_tlp` VALUES ('1312734181264068608', '欢迎光临', null, '2', '1', '1', '2020-10-04 20:48:39');
INSERT INTO `we_msg_tlp` VALUES ('1312734240420532224', '欢迎光临', null, '2', '1', '1', '2020-10-04 20:48:42');
INSERT INTO `we_msg_tlp` VALUES ('1312734249236959232', '欢迎光临', null, '2', '1', '1', '2020-10-04 20:48:44');
INSERT INTO `we_msg_tlp` VALUES ('1312734256459550720', '欢迎光临', null, '0', '1', '1', '2020-10-04 20:48:46');
INSERT INTO `we_msg_tlp` VALUES ('1312740005210361856', '欢迎加入该部门', null, '0', '2', null, null);

-- ----------------------------
-- Table structure for we_msg_tlp_scope
-- ----------------------------
DROP TABLE IF EXISTS `we_msg_tlp_scope`;
CREATE TABLE `we_msg_tlp_scope` (
  `id` bigint(20) NOT NULL,
  `msg_tlp_id` bigint(20) DEFAULT NULL COMMENT '模板id',
  `use_user_id` bigint(20) DEFAULT NULL COMMENT '使用人id',
  `del_flag` tinyint(4) DEFAULT '0' COMMENT '0:正常;2:删除;',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模板使用人员范围';

-- ----------------------------
-- Records of we_msg_tlp_scope
-- ----------------------------
INSERT INTO `we_msg_tlp_scope` VALUES ('1312740015884865536', '1312740005210361856', '18158873850', null);

-- ----------------------------
-- Table structure for we_tag
-- ----------------------------
DROP TABLE IF EXISTS `we_tag`;
CREATE TABLE `we_tag` (
  `group_id` varchar(64) NOT NULL COMMENT '标签组id',
  `name` varchar(50) DEFAULT NULL COMMENT '标签名',
  `create_time` datetime DEFAULT NULL,
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1删除）',
  `tag_id` varchar(64) NOT NULL COMMENT '微信端返回的id',
  PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业微信标签';

-- ----------------------------
-- Records of we_tag
-- ----------------------------
INSERT INTO `we_tag` VALUES ('et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '3434', '2020-11-06 15:19:10', '0', 'et2H-nDQAA0zYuuiE_ty9DCIoAfc18eQ');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAY4pZvqkY1SiOCrXk6_Enbg', '15656', '2020-11-04 17:31:13', '0', 'et2H-nDQAAbbYA_xN9thP9aN1Jr_1tfw');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAimIg5GKq9w3TumxTihCbGw', 'asdas', '2020-11-04 17:31:13', '0', 'et2H-nDQAAbFgcwRP86mLt-3ANZNQmYQ');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAdpZH-mCQq43ih5xUlrS9UQ', '企业QQ', null, '0', 'et2H-nDQAACFz3gFh1wZ5cSqQhApwUyA');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '123', '2020-11-06 15:18:03', '2', 'et2H-nDQAAd7YUGnw71_iXjD-HaruyFg');
INSERT INTO `we_tag` VALUES ('et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg', '10101', '2020-10-31 13:01:01', '0', 'et2H-nDQAADhNzG1XczpXOcYH7gbZhow');
INSERT INTO `we_tag` VALUES ('et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg', '101001', '2020-10-31 13:01:01', '2', 'et2H-nDQAAkFJwg8E_-oRdrXeuGvGpOA');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g', '个人用户', '2020-11-04 17:31:13', '0', 'et2H-nDQAALPTXhYLwzwtMc25IE3COFw');
INSERT INTO `we_tag` VALUES ('et2H-nDQAA0OENkZNfgx7cjF8IacoShg', '小米手环', '2020-11-04 17:31:13', '0', 'et2H-nDQAANng0Mp9ccFSv6ivIaQGzOw');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', '111', '2020-11-06 15:55:09', '0', 'et2H-nDQAAOh5qBB5mEP1Z0asFCI99HQ');
INSERT INTO `we_tag` VALUES ('et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg', '101010', '2020-10-31 13:01:01', '2', 'et2H-nDQAAPEzYAk5DQiIuZdjbbYmk5Q');
INSERT INTO `we_tag` VALUES ('et2H-nDQAA0OENkZNfgx7cjF8IacoShg', '小米手机', '2020-11-04 17:31:13', '0', 'et2H-nDQAASkqQ45l7Y2Hmn9zF2mGyNQ');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g', '企业用户', '2020-11-04 17:31:13', '0', 'et2H-nDQAATH8oY7ppNrVgpMJeEnXj3w');
INSERT INTO `we_tag` VALUES ('et2H-nDQAAimIg5GKq9w3TumxTihCbGw', 'asas', '2020-11-04 17:31:13', '0', 'et2H-nDQAA_E0OXAdfPIudSDKJftJ4pw');
INSERT INTO `we_tag` VALUES ('et4_fSDAAAfEdaaSHfl1Ta78id0ukY3g', '重要', null, '0', 'et4_fSDAAA_wpbwIIUroXo56dJXyZHLQ');

-- ----------------------------
-- Table structure for we_tag_group
-- ----------------------------
DROP TABLE IF EXISTS `we_tag_group`;
CREATE TABLE `we_tag_group` (
  `group_id` varchar(64) NOT NULL,
  `gourp_name` varchar(50) DEFAULT NULL,
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1删除）',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签组';

-- ----------------------------
-- Records of we_tag_group
-- ----------------------------
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAA0OENkZNfgx7cjF8IacoShg', '小米', 'test', '2020-11-04 17:31:13', '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAA7RUu640RpW6BV9iJm5o1Dg', '10101', 'test', '2020-10-31 13:01:01', '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAAdpZH-mCQq43ih5xUlrS9UQ', 'QQ用户', 'admin', null, '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAAf7xXeIPfacpx4uhQ8ZeXGQ', 'ghhgf', 'admin', '2020-11-06 15:18:03', '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAAFHFM5mBW9RYsQbKDzuVq2g', '拼多多客户', 'test', '2020-11-04 17:31:13', '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAAimIg5GKq9w3TumxTihCbGw', 'asasdas', 'test', '2020-11-04 17:31:13', '0');
INSERT INTO `we_tag_group` VALUES ('et2H-nDQAAY4pZvqkY1SiOCrXk6_Enbg', '454', 'test', '2020-11-04 17:31:13', '0');
INSERT INTO `we_tag_group` VALUES ('et4_fSDAAAfEdaaSHfl1Ta78id0ukY3g', '客户等级', 'admin', null, '0');

-- ----------------------------
-- Table structure for we_user
-- ----------------------------
DROP TABLE IF EXISTS `we_user`;
CREATE TABLE `we_user` (
  `user_id` varchar(64) NOT NULL,
  `head_image_url` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `user_name` varchar(200) DEFAULT NULL COMMENT '用户名称',
  `alias` varchar(100) DEFAULT NULL COMMENT '用户昵称',
  `gender` tinyint(1) DEFAULT '1' COMMENT '性别。1表示男性，2表示女性',
  `mobile` varchar(20) NOT NULL COMMENT '手机号',
  `email` varchar(30) DEFAULT NULL COMMENT '邮箱',
  `wx_account` varchar(32) DEFAULT NULL COMMENT '个人微信号',
  `department` tinytext COMMENT '用户所属部门,使用逗号隔开,字符串格式存储',
  `position` varchar(300) DEFAULT NULL COMMENT '职务',
  `is_leader_in_dept` tinytext COMMENT '1表示为上级,0表示普通成员(非上级)。',
  `join_time` date DEFAULT NULL COMMENT '入职时间',
  `enable` tinyint(4) DEFAULT '1' COMMENT '是否启用(1表示启用成员，0表示禁用成员)',
  `id_card` char(18) DEFAULT NULL COMMENT '身份证号',
  `qq_account` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `telephone` varchar(32) DEFAULT NULL COMMENT '座机',
  `address` varchar(300) DEFAULT NULL COMMENT '地址',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `customer_tags` varchar(255) DEFAULT NULL COMMENT '客户标签,字符串使用逗号隔开',
  `dimission_time` datetime DEFAULT NULL COMMENT '离职时间',
  `is_allocate` tinyint(1) DEFAULT '0' COMMENT '离职是否分配(1:已分配;0:未分配;)',
  `is_activate` tinyint(4) DEFAULT NULL COMMENT '激活状态: 1=已激活，2=已禁用，4=未激活，5=退出企业,6=删除',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通讯录相关客户';

-- ----------------------------
-- Records of we_user
-- ----------------------------
INSERT INTO `we_user` VALUES ('15665400628', null, 'JDQ', '', '1', '15665400628', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '4');
INSERT INTO `we_user` VALUES ('18158873850', null, '盛锡勇', '', '1', '18158873850', '', '18158873850', '4294967294', '', '1', null, '1', null, '', '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('ChiChiXiaoXie', null, '谢运吉', '', '1', '17756606730', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, '2020-10-28 20:03:08', '1', '6');
INSERT INTO `we_user` VALUES ('DongChunLin', null, '董春林', '', '1', '18756686768', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('DongDongQiang', null, '董健', '', '1', '15956608378', '', null, '1', '', '1', null, '1', null, null, '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('Kong', null, '柯鹏浩', '', '1', '18056630169', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('Meng', null, '黄梦怡', '', '2', '18355359156', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('XiaoSheYu', null, '舒俊丽', '', '2', '15956647920', '', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '1');
INSERT INTO `we_user` VALUES ('XuXueJun', null, '徐学军', 'aa', '1', '18654148698', '1570728529@qq.com', null, '1', '', '0', null, '1', null, null, '', null, null, null, null, null, '0', '1');
