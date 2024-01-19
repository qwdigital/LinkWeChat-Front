<template>
  <div>
    <div class="g-card">
      <el-steps :active="active" align-center finish-status="success">
        <el-step title="基础信息"></el-step>
        <el-step title="群发内容"></el-step>
      </el-steps>
    </div>
    <div class="g-card" v-if="active == 0">
      <el-form style="width: 60%; margin: 0 auto" ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="群发类型" required prop="chatType">
          <el-radio-group v-model="form.chatType">
            <el-radio :label="1">群发客户</el-radio>
            <el-radio :label="2">群发客户群</el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="form.chatType == 2">
          <el-form-item label="群发客户群" required prop="isAll">
            <el-radio-group v-model="form.isAll">
              <el-radio :label="0">全部群</el-radio>
              <el-radio :label="1">部分群</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="form.isAll == 1">
            <div>
              <div class="item-magin aic">
                <div class="item-name">
                  <span style="color: red">*</span>
                  选择群主：
                </div>
                <!-- <el-tag v-for="(unit, unique) in selectCustomerGroupList" :key="unique">
                  {{ unit.groupLeaderName }}
                </el-tag> -->
                <el-tag v-for="item in selectCustomerGroupList" :key="item.userId">{{ item.name }}</el-tag>
                <el-button
                  type="primary"
                  :class="selectCustomerGroupList.length == 1 && 'ml10'"
                  @click="onSelectCustomerGroup">
                  选择群主
                </el-button>
              </div>
            </div>
          </el-form-item>
        </template>
        <template v-if="form.chatType == 1">
          <el-form-item label="群发客户" required prop="isAll">
            <el-radio-group v-model="form.isAll">
              <el-radio :label="0">全部客户</el-radio>
              <el-radio :label="1">部分客户</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="form.isAll == 1">
            <CustomerRangeForm ref="customerRangeForm" isTrans v-model:data="form.weCustomersQuery" />
          </el-form-item>
        </template>
        <el-form-item label="发送类型" required prop="isTask">
          <el-radio-group v-model="form.isTask">
            <el-radio :label="0">立即发送</el-radio>
            <el-radio :label="1">定时发送</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.isTask == 1">
          <div>
            <div class="item-magin">
              <div class="item-name">发送时间</div>
              <el-date-picker
                v-model="form.sendTime"
                type="datetime"
                placeholder="选择日期时间"
                v-bind="pickerOptions"></el-date-picker>
            </div>
          </div>
        </el-form-item>
        <el-form-item label-width="0">
          <!-- <el-button @click="active = 1">取消</el-button> -->
          <el-button type="primary" @click="nextStep">下一步</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-margin-t" v-show="active === 1">
      <AddMaterial
        :showModle="true"
        :moduleType="4"
        :otherType="2"
        @update="active = 0"
        @submit="save"
        :baseData="materialData"
        isTransData></AddMaterial>
    </div>

    <!-- 选择客户群聊 -->
    <!-- <SelectCustomerGroup  v-model:visible="dialogVisibleSelectCustomerGroup" @success="submitSelectCustomerGroup" :multiSelect="true"></SelectCustomerGroup> -->
    <SelectUser
      v-model:visible="dialogVisibleSelectCustomerGroup"
      title="选择添加人"
      destroyOnClose
      :defaultValues="selectCustomerGroupList"
      @success="submitSelectCustomerGroup"></SelectUser>
  </div>
</template>

<script>
import { getDetailRaw, add, getCustomerList } from '@/api/groupMessage'
import { getMaterialMediaId } from '@/api/material'
import { getList } from '@/api/salesCenter/businessConver.js'

import SelectCustomerGroup from '@/components/SelectCustomerGroup'
import moment from 'moment'
import { parseTime } from '@/utils/common'
import AddMaterial from '@/components/ContentCenter/AddMaterial'
import { delTreeKeys } from '@/utils/index'
export default {
  components: {
    //
    SelectCustomerGroup,
    AddMaterial,
  },
  props: {},
  data() {
    return {
      stageList: [],
      active: 0,
      loading: false,
      // 表单参数
      form: {
        chatType: 1,
        isAll: 0, //
        gender: '', // 发送客户-性别
        trackState: '', // 发送客户-跟进状态
        rangeTime: [], // 发送客户-添加时间
        sendClientTagList: [], // 发送客户标签
        sendClientUserList: [], // 发送客户添加人
        tag: [],
        department: [],
        staffId: [],
        isTask: 0,
        sendTime: '',
        customerList: [], // 客户列表 临时存储
      },
      userParty: [],
      rules: {
        isAll: [
          { required: true, message: '请选择', trigger: 'change' },
          { validator: this.validateClientGroup, trigger: 'blur' },
        ],
        isTask: [{ validator: this.validateSettingTimeType, trigger: 'blur' }],
      },
      statusOptions: Object.freeze([
        {
          label: '发送给客户',
          value: '0',
        },
        {
          label: '发送给客户群',
          value: '1',
        },
      ]),
      activeName: '0',
      dialogVisibleSelectCustomer: false,
      dialogVisibleSelectCustomerGroup: false,
      selectCustomerGroupList: [],
      pickerOptions: {
        disabledDate(time) {
          var date = new Date()
          date.setFullYear(date.getFullYear() + 2)
          date.setDate(date.getDate() - 1)
          return time.getTime() < Date.now() - 8.64e7 || time.getTime() > date.getTime()
        },
        selectableRange: parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '{hh}:{ii}:{ss}') + '- 23:59:59',
      },
      materialData: {
        templateInfo: '',
        materialMsgList: [],
      },
    }
  },
  watch: {
    'form.sendTime'(selectTime) {
      const myDate = new Date()
      const now = myDate.valueOf()
      const time = new Date(selectTime).valueOf()
      if (time > now) {
        this.pickerOptions.selectableRange =
          parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '00:00:00') + '- 23:59:59'
      } else {
        this.pickerOptions.selectableRange =
          parseTime(new Date(moment().format('YYYY-MM-DD HH:mm:ss')), '{hh}:{ii}:{ss}') + '- 23:59:00'
      }
    },
  },
  computed: {
    // 是否显示选择的客户标签
    isOnlyTag() {
      return this.form.tag[0] && this.form.chatType == 0
    },
    // 是否显示选择范围后的文字说明
    isSelectedText() {
      return this.userParty[0] || this.isOnlyTag
    },
    // 选择范围后的文字说明
    selectedText() {
      return `将发送消息给${this.userParty[0] ? this.userParty[0].name + '等部门或成员的' : ''}${
        this.userParty[0] && this.isOnlyTag ? '，且' : ''
      }${this.isOnlyTag ? '满足' + this.form.tag[0].name + '等标签的' : ''}${
        this.form.chatType == 0 ? '客户' : '客户群'
      }`
    },
  },
  created() {
    this.$store.setBusininessDesc(
      `<div>每位客户/每个客户群每天可接收1条群发消息，可以是企业统一创建发送的，也可以是成员自己创建发送的；超过接收上限的客户/客户群将无法再收到群发消息。</div>`,
    )

    if (this.$route.query.chatType) {
      this.form.chatType = Number(this.$route.query.chatType)
    }
    this.getStage()

    if (this.$route.query.id) {
      getDetailRaw(this.$route.query.id).then(({ data = {} }) => {
        // 删除主键
        delTreeKeys(data, ['id'])

        this.form = Object.assign(data, this.$route.query)
        this.form.isTask = +this.form.isTask
        this.form.isAll = this.form.isAll ? 0 : 1
        this.form.weCustomersQuery = data.weCustomersOrGroupQuery?.weCustomersQuery
        let ownerNames = data.weCustomersOrGroupQuery?.weGroupQuery?.ownerNames?.split?.(',')
        this.selectCustomerGroupList =
          data.weCustomersOrGroupQuery?.weGroupQuery?.owners?.split?.(',')?.map?.((e, i) => ({
            userId: e,
            name: ownerNames[i],
          })) || []
        this.materialData = {
          templateInfo: data?.content || '',
          attachments: data?.weGroupMessageAttachmentsVo || [],
        }
      })
    }
  },
  mounted() {},
  methods: {
    getStage() {
      getList().then((res) => {
        this.stageList = res.data
      })
    },
    parseTime(time, cFormat) {
      if (arguments.length === 0) {
        return null
      }
      const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}'
      let date
      if (typeof time === 'object') {
        date = time
      } else {
        if (typeof time === 'string' && /^[0-9]+$/.test(time)) {
          time = parseInt(time)
        }
        if (typeof time === 'number' && time.toString().length === 10) {
          time = time * 1000
        }
        date = new Date(time)
      }
      const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds(),
        a: date.getDay(),
      }
      const time_str = format.replace(/{([ymdhisa])+}/g, (result, key) => {
        const value = formatObj[key]
        // Note: getDay() returns 0 on Sunday
        if (key === 'a') {
          return ['日', '一', '二', '三', '四', '五', '六'][value]
        }
        return value.toString().padStart(2, '0')
      })
      return time_str
    },
    // validatePushUserRange(rule, value, callback) {
    // 	if(value == 1 && this.userParty.length == 0) {
    // 		callback('请选择员工')
    // 	} else {
    // 		callback()
    // 	}
    // },
    validateClientGroup(rule, value, callback) {
      if (this.form.chatType == 2 && this.form.isAll == 1 && this.selectCustomerGroupList.length == 0) {
        callback('请选择群主')
      } else {
        callback()
      }
    },
    validateSettingTimeType(rule, value, callback) {
      if (this.form.isTask == 1 && !this.form.sendTime) {
        callback('请选择发送时间')
      } else {
        callback()
      }
    },
    // 下一步 校验数据
    nextStep() {
      this.$refs.form.validate((validate) => {
        if (!validate) return
        if (this.form.chatType == 1 && this.form.isAll == 1) {
          this.$store.loading = true
          this.$refs.customerRangeForm
            .getCustomerList()
            .then((data) => {
              if (data?.length) {
                this.form.senderList = data
                this.active++
              }
            })
            .finally(() => {
              this.$store.loading = false
            })
        } else {
          this.active++
        }
      })
    },
    resetData(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === '0') {
            let obj = {
              msgType: 'image',
              picUrl: dd.materialUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === '8') {
            let ob = {
              msgType: 'link',
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === '9') {
            let ff = {
              msgType: 'miniprogram',
              appId: dd.digest,
              title: dd.materialName,
              picUrl: dd.coverUrl,
              linkUrl: dd.materialUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    save(materialData) {
      let list = materialData.attachments
      let myObj = {
        content: materialData.templateInfo,
        attachmentsList: [
          {
            content: materialData.templateInfo,
            msgType: 'text',
          },
        ],
      }
      myObj.attachmentsList.push(...list)
      let data = Object.assign({}, this.form, myObj)
      data = JSON.parse(JSON.stringify(data))
      if (data.chatType === 1) {
        if (data.isAll === 0) {
          data.senderList = []
        }
      } else {
        if (data.isAll == 1) {
          data.senderList = this.selectCustomerGroupList.map((i) => {
            return { userId: i.userId }
          })
        } else {
          data.senderList = []
        }
      }
      data.isAll = data.isAll == 0
      // data.sendClientUserList.map(i => i.userId)
      // 发送类型
      data.sendTime = data.isTask == 1 ? parseTime(new Date(data.sendTime)) : ''
      // data.department = data.department.join(',')
      delete data.department
      delete data.rangeTime
      delete data.sendClientUserList
      delete data.sendClientTagList
      delete data.tag
      delete data.trackState
      delete data.gender
      delete data.staffId
      this.$store.loading = true
      add(data).then((res) => {
        if (res.code == 200) {
          this.$router.go(-1)
          this.msgSuccess('操作成功')
        } else {
          this.msgError(res.msg || '操作失败')
        }
        this.$store.loading = false
      })
    },
    onSelectCustomerGroup() {
      this.dialogVisibleSelectCustomerGroup = true
    },
    // 选择群主
    submitSelectCustomerGroup(data) {
      this.selectCustomerGroupList = data
      // let newData = []
      // if (data && data.length > 0) {
      //   let keyMap = new Set()
      //   data.forEach(i => {
      //     if (!keyMap.has(i.owner)) {
      //       newData.push(i)
      //       keyMap.add(i.owner)
      //     }
      //   })
      // }
      // this.selectCustomerGroupList = newData
      this.$refs.form.clearValidate('isAll')
    },
  },
}
</script>

<style lang="scss" scoped>
.content-border {
  padding: 10px 20px;
  background: var(--bg-white);
  border: 1px solid var(--border-black-10);
  .item-name {
    width: 100px;
  }
  .item-magin {
    display: flex;
    margin: 10px 0;
  }
}

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: var(--font-black);
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-4);
  display: flex;
}

.small-tip {
  font-size: 12px;
  color: var(--font-black-6);
  margin-left: 12px;
}

.content-wrap {
  background: var(--bg-white);
  border-radius: 10px;
  padding: 20px;
}

.content-left {
  position: relative;

  .create {
    position: absolute;
    right: 10px;
    top: 14px;
    z-index: 1;
  }

  .el-tabs {
    height: 90%;
    border-radius: 8px;
    padding: 10px;
  }
}

.input-wrap {
  width: 240px;
  display: inline-flex;
  border-radius: 4px;
  border: 1px solid var(--border-black-9);
  align-items: center;
  padding: 0 15px;
  overflow: hidden;
  height: 32px;

  .placeholder {
    color: var(--font-black-7);
    font-size: 14px;
  }
}
</style>
