/*
Navicat MySQL Data Transfer

Source Server         : LinkWechat
Source Server Version : 50731
Source Host           : 146.56.222.200:3306
Source Database       : link-wechat

Target Server Type    : MYSQL
Target Server Version : 50731
File Encoding         : 65001

Date: 2020-10-28 15:12:42
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COMMENT='代码生成业务表';

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES ('22', 'we_allocate_customer', '离职分配的客户列表', 'WeAllocateCustomer', 'crud', 'com.linkwechat.wecom', 'wecom', 'customer', '离职分配的客户列', 'ruoyi', '0', '/', '{}', 'admin', '2020-10-24 23:50:14', '', '2020-10-24 23:50:30', null);
INSERT INTO `gen_table` VALUES ('23', 'we_allocate_group', '分配的群租', 'WeAllocateGroup', 'crud', 'com.linkwechat.wecom', 'wecom', 'group', '分配的群租', 'ruoyi', '0', '/', '{}', 'admin', '2020-10-24 23:50:15', '', '2020-10-24 23:50:41', null);

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
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COMMENT='代码生成业务表字段';

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
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F7708000001756E0C4711787400013174000E302F3130202A202A202A202A203F74001172795461736B2E72794E6F506172616D7374000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000001740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E697A0E58F82EFBC8974000133740001317800);
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F7708000001756E0C4711787400013174000E302F3135202A202A202A202A203F74001572795461736B2E7279506172616D7328277279272974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000002740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E69C89E58F82EFBC8974000133740001317800);
INSERT INTO `QRTZ_JOB_DETAILS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', null, 'com.linkwechat.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F5045525449455373720023636F6D2E6C696E6B7765636861742E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200084C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000673746174757371007E00097872002C636F6D2E6C696E6B7765636861742E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200094C0009626567696E54696D6571007E00094C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0007656E6454696D6571007E00094C0006706172616D7371007E00034C000672656D61726B71007E00094C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C78707074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B59741903000078707708000001622CDE29E078707074000070707371007E000F7708000001756E0C4712787400013174000E302F3230202A202A202A202A203F74003872795461736B2E72794D756C7469706C65506172616D7328277279272C20747275652C20323030304C2C203331362E3530442C203130302974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000003740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E5A49AE58F82EFBC8974000133740001317800);

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
INSERT INTO `QRTZ_SCHEDULER_STATE` VALUES ('RuoyiScheduler', 'DESKTOP-CAVF6SU1603869099608', '1603869104301', '15000');

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
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', 'TASK_CLASS_NAME1', 'DEFAULT', null, '1603869100000', '-1', '5', 'PAUSED', 'CRON', '1603869099000', '0', null, '2', '');
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', 'TASK_CLASS_NAME2', 'DEFAULT', null, '1603869105000', '-1', '5', 'PAUSED', 'CRON', '1603869100000', '0', null, '2', '');
INSERT INTO `QRTZ_TRIGGERS` VALUES ('RuoyiScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', 'TASK_CLASS_NAME3', 'DEFAULT', null, '1603869100000', '-1', '5', 'PAUSED', 'CRON', '1603869100000', '0', null, '2', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=443 DEFAULT CHARSET=utf8mb4 COMMENT='系统访问记录';

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=2050 DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

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
INSERT INTO `sys_menu` VALUES ('2005', '离职继承', '2001', '40', 'dimission', 'customerManage/dimission', '1', 'C', '0', '0', 'customerManage:dimission:list', '#', 'admin', '2020-10-20 22:34:59', '', null, '');
INSERT INTO `sys_menu` VALUES ('2006', '客户详情', '2001', '11', 'customerDetail', 'customerManage/customerDetail', '1', 'C', '1', '0', 'customerManage:customerDetail:list', '#', 'admin', '2020-10-20 22:37:06', 'admin', '2020-10-22 01:18:43', '');
INSERT INTO `sys_menu` VALUES ('2007', '客户群详情', '2001', '21', 'groupDetail', 'customerManage/groupDetail', '1', 'C', '1', '0', 'customerManage:groupDetail:list', '#', 'admin', '2020-10-20 22:37:59', 'admin', '2020-10-22 01:18:57', '');
INSERT INTO `sys_menu` VALUES ('2008', '通信录', '0', '50', 'contacts', null, '1', 'M', '0', '0', '', 'tree-table', 'admin', '2020-10-20 22:40:17', 'admin', '2020-10-22 01:17:14', '');
INSERT INTO `sys_menu` VALUES ('2009', '组织架构', '2008', '10', 'organization', 'contacts/organization', '1', 'C', '0', '0', 'contacts:organization:list', 'tree', 'admin', '2020-10-20 22:46:05', '', null, '');
INSERT INTO `sys_menu` VALUES ('2010', '企业微信管理', '0', '60', '/_enterpriseWechat', null, '1', 'M', '0', '0', '', 'wechat', 'admin', '2020-10-20 22:48:05', 'admin', '2020-10-22 01:23:00', '');
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
INSERT INTO `sys_menu` VALUES ('2036', '禁用成员', '2009', '6', '', null, '1', 'F', '0', '0', 'contacts:organization:forbidden', '#', 'admin', '2020-10-22 19:08:35', '', null, '');
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
INSERT INTO `sys_menu` VALUES ('2047', '删除成员', '2009', '6', '', null, '1', 'F', '0', '0', 'contacts:organization:removeMember', '#', 'admin', '2020-10-28 13:48:23', '', null, '');
INSERT INTO `sys_menu` VALUES ('2048', '已分配客户', '2005', '7', '', null, '1', 'F', '0', '0', 'wecom:user:getAllocateCustomers', '#', 'admin', '2020-10-28 13:50:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2049', '已分配的群', '2005', '8', '', null, '1', 'F', '0', '0', 'wecom:user:getAllocateGroups', '#', 'admin', '2020-10-28 13:50:42', '', null, '');

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
) ENGINE=InnoDB AUTO_INCREMENT=829 DEFAULT CHARSET=utf8mb4 COMMENT='操作日志记录';

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------

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
INSERT INTO `sys_role` VALUES ('2', '测试用户', 'common', '2', '2', '0', '0', 'admin', '2018-03-16 11:33:00', 'admin', '2020-10-28 13:54:44', '普通角色');

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
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '100');
INSERT INTO `sys_role_menu` VALUES ('2', '101');
INSERT INTO `sys_role_menu` VALUES ('2', '102');
INSERT INTO `sys_role_menu` VALUES ('2', '103');
INSERT INTO `sys_role_menu` VALUES ('2', '104');
INSERT INTO `sys_role_menu` VALUES ('2', '105');
INSERT INTO `sys_role_menu` VALUES ('2', '106');
INSERT INTO `sys_role_menu` VALUES ('2', '107');
INSERT INTO `sys_role_menu` VALUES ('2', '108');
INSERT INTO `sys_role_menu` VALUES ('2', '500');
INSERT INTO `sys_role_menu` VALUES ('2', '501');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '1002');
INSERT INTO `sys_role_menu` VALUES ('2', '1003');
INSERT INTO `sys_role_menu` VALUES ('2', '1004');
INSERT INTO `sys_role_menu` VALUES ('2', '1005');
INSERT INTO `sys_role_menu` VALUES ('2', '1006');
INSERT INTO `sys_role_menu` VALUES ('2', '1007');
INSERT INTO `sys_role_menu` VALUES ('2', '1008');
INSERT INTO `sys_role_menu` VALUES ('2', '1009');
INSERT INTO `sys_role_menu` VALUES ('2', '1010');
INSERT INTO `sys_role_menu` VALUES ('2', '1011');
INSERT INTO `sys_role_menu` VALUES ('2', '1012');
INSERT INTO `sys_role_menu` VALUES ('2', '1013');
INSERT INTO `sys_role_menu` VALUES ('2', '1014');
INSERT INTO `sys_role_menu` VALUES ('2', '1015');
INSERT INTO `sys_role_menu` VALUES ('2', '1016');
INSERT INTO `sys_role_menu` VALUES ('2', '1017');
INSERT INTO `sys_role_menu` VALUES ('2', '1018');
INSERT INTO `sys_role_menu` VALUES ('2', '1019');
INSERT INTO `sys_role_menu` VALUES ('2', '1020');
INSERT INTO `sys_role_menu` VALUES ('2', '1021');
INSERT INTO `sys_role_menu` VALUES ('2', '1022');
INSERT INTO `sys_role_menu` VALUES ('2', '1023');
INSERT INTO `sys_role_menu` VALUES ('2', '1024');
INSERT INTO `sys_role_menu` VALUES ('2', '1025');
INSERT INTO `sys_role_menu` VALUES ('2', '1026');
INSERT INTO `sys_role_menu` VALUES ('2', '1027');
INSERT INTO `sys_role_menu` VALUES ('2', '1028');
INSERT INTO `sys_role_menu` VALUES ('2', '1029');
INSERT INTO `sys_role_menu` VALUES ('2', '1030');
INSERT INTO `sys_role_menu` VALUES ('2', '1031');
INSERT INTO `sys_role_menu` VALUES ('2', '1032');
INSERT INTO `sys_role_menu` VALUES ('2', '1033');
INSERT INTO `sys_role_menu` VALUES ('2', '1034');
INSERT INTO `sys_role_menu` VALUES ('2', '1035');
INSERT INTO `sys_role_menu` VALUES ('2', '1036');
INSERT INTO `sys_role_menu` VALUES ('2', '1037');
INSERT INTO `sys_role_menu` VALUES ('2', '1038');
INSERT INTO `sys_role_menu` VALUES ('2', '1039');
INSERT INTO `sys_role_menu` VALUES ('2', '1040');
INSERT INTO `sys_role_menu` VALUES ('2', '1041');
INSERT INTO `sys_role_menu` VALUES ('2', '1042');
INSERT INTO `sys_role_menu` VALUES ('2', '1043');
INSERT INTO `sys_role_menu` VALUES ('2', '1044');
INSERT INTO `sys_role_menu` VALUES ('2', '1045');
INSERT INTO `sys_role_menu` VALUES ('2', '2001');
INSERT INTO `sys_role_menu` VALUES ('2', '2002');
INSERT INTO `sys_role_menu` VALUES ('2', '2003');
INSERT INTO `sys_role_menu` VALUES ('2', '2004');
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
INSERT INTO `sys_role_menu` VALUES ('2', '2031');
INSERT INTO `sys_role_menu` VALUES ('2', '2032');
INSERT INTO `sys_role_menu` VALUES ('2', '2034');
INSERT INTO `sys_role_menu` VALUES ('2', '2035');
INSERT INTO `sys_role_menu` VALUES ('2', '2036');
INSERT INTO `sys_role_menu` VALUES ('2', '2037');
INSERT INTO `sys_role_menu` VALUES ('2', '2038');
INSERT INTO `sys_role_menu` VALUES ('2', '2039');
INSERT INTO `sys_role_menu` VALUES ('2', '2040');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
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
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', '103', 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2018-03-16 11:33:00', 'admin', '2018-03-16 11:33:00', 'ry', '2018-03-16 11:33:00', '管理员');
INSERT INTO `sys_user` VALUES ('2', '105', 'ry', '塬微', '00', 'yw@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '2', '127.0.0.1', '2018-03-16 11:33:00', 'admin', '2018-03-16 11:33:00', 'admin', '2020-09-13 15:36:10', '测试员');
INSERT INTO `sys_user` VALUES ('100', '103', 'admin1111', '1212', '00', '1539136324@qq.com', '18158873856', '0', '', '$2a$10$3YQW427CAAZKRCitiQWif.PDcQN2VskNsxWJV.1olVJVb/ebR/MhC', '0', '2', '', null, 'admin', '2020-09-18 19:08:03', '', null, null);
INSERT INTO `sys_user` VALUES ('101', '103', 'HaoN', 'HaoN', '00', '18158873850@163.com', '18158873850', '0', '', '$2a$10$pEMOaH/3PSwVhM4q.0lEf.ySxjSJL/c1vMp470LUoMSsOdteGBaxy', '0', '2', '', null, 'admin', '2020-10-20 11:32:24', '', null, null);
INSERT INTO `sys_user` VALUES ('102', '103', 'test', 'test', '00', '1539136325@qq.com', '13956925008', '0', '', '$2a$10$xIkXYWKgjh28POMexRgzE.BveFrRQavLZA1yvnZXxBbShtWfeFRxi', '0', '0', '', null, 'admin', '2020-10-28 11:49:40', '', null, '测试用户');

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
  `status` char(1) DEFAULT '1' COMMENT '帐号状态（0正常 1停用)',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='企业id相关配置';

-- ----------------------------
-- Records of we_corp_account
-- ----------------------------

-- ----------------------------
-- Table structure for we_customer
-- ----------------------------
DROP TABLE IF EXISTS `we_customer`;
CREATE TABLE `we_customer` (
  `external_userid` varchar(32) NOT NULL COMMENT '外部联系人的userid',
  `name` varchar(32) DEFAULT NULL COMMENT '外部联系人名称',
  `avatar` varchar(100) DEFAULT NULL COMMENT '外部联系人头像',
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
INSERT INTO `we_customer` VALUES ('wm2H-nDQAAdUkp__-t-f2hY0PEiiDHWQ', '_Alone°', 'http://wx.qlogo.cn/mmhead/Q3auHgzwzM53hwhG5TrgXZ2ntsUibKdtlwNKxFyKcCOicHh5RRRpvQhg/0', '1', '1', null, null, null, null, null);

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
  `use_user_id` bigint(20) DEFAULT NULL COMMENT '活码类型下业务使用人的id',
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
INSERT INTO `we_flower_customer_rel` VALUES ('1321095489365610496', '15665400628', null, '', '2020-10-25 15:50:39', null, '', '18158873850', '6', null, 'wm2H-nDQAAdUkp__-t-f2hY0PEiiDHWQ', '0');
INSERT INTO `we_flower_customer_rel` VALUES ('1321334354454122496', '15665400628', null, '', '2020-10-25 18:52:38', null, '', 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', '3', null, 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', '0');

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
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1321095491252072450', '1321095489365610496', 'et2H-nDQAAyWqRWmN4jLQa025wvkhPEw', '2020-10-27 22:24:44');
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1321334262230790145', '1321095489365610496', 'et2H-nDQAAyWqRWmN4jLQa025wvkhPEw', '2020-10-28 14:13:32');
INSERT INTO `we_flower_customer_tag_rel` VALUES ('1321334355621163009', '1321334354454122496', 'et2H-nDQAALPTXhYLwzwtMc25IE3COFw', '2020-10-28 14:13:54');

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
INSERT INTO `we_group` VALUES ('wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', '哈牛逼群', '2020-10-20 14:05:41', null, '15665400628', '2');
INSERT INTO `we_group` VALUES ('wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', '测试群', '2020-10-27 22:24:21', null, '15665400628', '3');

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
INSERT INTO `we_group_member` VALUES ('1321333299247902721', '15665400628', 'wr2H-nDQAAB2BKn_M9TisnGUB37vJc6g', null, '2020-10-27 23:47:22', '1', '1');
INSERT INTO `we_group_member` VALUES ('1321333299260485634', 'XuXueJun', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', null, '2020-10-20 14:05:41', '1', '1');
INSERT INTO `we_group_member` VALUES ('1321333299260485635', '15665400628', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', null, '2020-10-27 23:47:22', '1', '1');
INSERT INTO `we_group_member` VALUES ('1321333299260485636', 'wm2H-nDQAA6pTRfJF2ywka6yJ2Opl8PQ', 'wr2H-nDQAA6KDoYAS-uCN601Rvum7NCg', null, '2020-10-20 14:05:41', '1', '2');

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
  `mobile` char(11) NOT NULL COMMENT '手机号',
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
