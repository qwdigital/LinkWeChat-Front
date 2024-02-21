import request from '@/utils/request'
const service = ''
const serviceUser = '/user'
const base = '/auth'

/* 组织管理 */

// 同步组织架构
export function setOragnize() {
  return request({
    url: '/system/user/sync',
    method: 'post',
  })
}

// 获取组织部门
export function getDeptTree() {
  return request({
    url: '/system/dept/list',
  })
}

// 获取组织部门下员工
export function getDeptUser(params) {
  return request({
    url: '/system/user/list',
    params,
  })
}
export function getDeptUserAll(params) {
  return request({
    url: '/system/user/listAll',
    params,
  })
}

// 修改员工角色
export function editUserRoles(params) {
  return request({
    url: '/system/user/editUserRole',
    data: params,
    method: 'put',
  })
}

/* 角色管理 */

// 角色列表
export function getRolesList(roleName) {
  return request({
    url: '/system/role/list',
    params: { roleName },
  })
}

export function getRoleDetail(roleId) {
  return request({
    url: '/system/role/' + roleId,
  })
}

// 选择角色下拉
export function getRoleOption() {
  return request({
    url: '/system/role/optionselect',
  })
}

// 查询菜单下拉树结构
export function treeselect() {
  return request({
    url: '/system/menu/allTreeselect',
    method: 'get',
  })
}

// 角色新增
export function addRole(params) {
  return request({
    url: '/system/role',
    method: 'post',
    data: params,
  })
}

// 角色编辑
export function editRole(params) {
  return request({
    url: '/system/role',
    method: 'put',
    data: params,
  })
}

// 角色删除
export function deleteRole(id) {
  return request({
    url: '/system/role/' + id,
    method: 'delete',
  })
}

/**
 * 获取所有部门
 * @param {*} params
 * {
  "id": "部门id ",
  "name": "部门名称",
  "parentId": "父节点id "
}
 */
export function getTree(params) {
  return request({
    url: '/list',
    params,
  })
}

/**
 * 更新部门
 * @param {*} params
 * {
  "id": "部门id ",
  "name": "部门名称",
  "parentId": "父节点id "
}
*/
export function updateDepart(data) {
  return request({
    url: service,
    method: 'put',
    data,
  })
}

/**
 * 新增部门
 * @param {Object} data
 *  * {
  "name": "部门名称",
  "parentId": "父节点id "
}
 */
export function addDepart(data) {
  return request({
    url: service,
    method: 'post',
    data,
  })
}

export function removeDepart(ids) {
  return request({
    url: '/' + ids,
    method: 'DELETE',
  })
}

/**
 * 获取通讯录人员列表
 * @param {*} params
 * {
    "pageNum": "当前页",
    "pageSize": "当前页显示条数",
    "name": "姓名",
    "userId": "账号",
    "mobile": "手机号",
    "beginTime": "开始时间",
    "endTime": "结束时间",
    "isActivate": "是否激活（1:是；2:否）该字段主要表示当前信息是否同步微信 ",
    "department": "根据组织id获取,获取通讯录人员"
}
 */
export function getList(params) {
  return request({
    url: serviceUser + '/list',
    params,
  })
}

/**
 * 获取所有员工的接口(不分页)
{
  “isActivate” //1=已激活，2=已禁用，4=未激活，5=退出企业,
 “isConfigCustomerContact”//1:是;0:否
}
 * @returns
 */
export function getAllStaff(params) {
  return request({
    url: serviceUser + '/findAllWeUser',
    params: {
      isActivate: 1, //1=已激活，2=已禁用，4=未激活，5=退出企业,
      isConfigCustomerContact: 0, //1:是;0:否
    },
  })
}

/**
 * 根据ID获取通讯录人员详情
 * @param {String} id
 */
export function getUserDetail(id) {
  return request({
    url: serviceUser + '/' + id,
  })
}

/**
 * 新增用户
 * @param {Object} data
 */
export function addUser(data) {
  return request({
    url: serviceUser,
    method: 'post',
    data,
  })
}

/**
 * 更新用户
 * @param {*} data
 * {
    "avatarMediaid": "用户头像,该值来自素材库",
    "name": "姓名",
    "alias": "昵称",
    "userId": "账号",
    "gender": "性别。（默认）1表示男性，2表示女性",
    "mobile": "手机号",
    "email": "邮箱",
    "wxAccount": "个人微信号",
    "department": "用户所属部门id,[1,2]",
    "position": "职务",
    "isLeaderInDept": "个数必须和参数department的个数一致，表示在所在的部门内是否为上级。1表示为上级,0表示普通成员(非上级)",
    "joinTime": "入职时间",
    "enable": "是否启用(1表示启用成员，0表示禁用成员)",
    "idCard": "身份证号",
    "qqAccount": "QQ号",
    "telephone": "座机",
    "address": "地址",
    "birthday": "生日",
    "isActivate": "是否激活（1:是；2:否）该字段主要表示当前信息是否同步微信",
    "id": "主键"
}
 */
export function updateUser(data) {
  return request({
    url: serviceUser,
    method: 'put',
    data,
  })
}

/**
 * 启用禁用用户 true：启用 false：禁用
 * @param {*} data
 * {
    "id": "通讯录客户ID",
    "enable": "启用禁用用户 true：启用 false：禁用"
}
 */
export function startOrStop(data) {
  return request({
    url: serviceUser + '/startOrStop',
    method: 'put',
    data,
  })
}

/**
 * 用户删除接口
 * @param {*} userId
 */
export function remove(userId) {
  return request({
    url: serviceUser + '/' + userId,
    method: 'DELETE',
  })
}

/**
 * 同步成员
 */
export function syncUser() {
  return request({
    url: serviceUser + '/synchWeUser',
  })
}

// 人员绑定权限
export function bindDepts(data) {
  return request({
    url: '/system/user/editDataScop',
    method: 'post',
    data,
  })
}
