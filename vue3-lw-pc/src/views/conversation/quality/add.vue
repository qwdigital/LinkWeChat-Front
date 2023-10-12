<template>
  <div>
    <div class="g-card">
      <el-form ref="form" :rules="rules" :model="form" label-position="right" label-width="140px">
        <el-form-item label="质检规则名称:" prop="name">
          <el-input v-model="form.name" maxlength="20" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item label="超时时间标准:" prop="timeOut">
          <el-input v-model="form.timeOut" style="width: 120px;" placeholder="请输入"></el-input>
          分钟
        </el-form-item>
        <el-form-item label="质检时间范围:" required prop="qiRuleScope" style="width: 60%;">
          <div class="sub-des">
            <span>可根据不同成员的上班时间灵活调整配置</span>
          </div>
          <template v-for="(item, index) in form.qiRuleScope" :key="item.id">
            <el-card class="box-card roster-card">
              <div style="display: flex; justify-content: flex-end;">
                <el-button
                  v-if="form.qiRuleScope.length !== 1"
                  text
                  icon="el-icon-delete"
                  @click="onRemoveRoster(index)"
                >
                  删除
                </el-button>
              </div>
              <el-form-item label-width="100px" label="排班员工:">
                <el-tag v-for="(tag, key) in item.weQiRuleUserList" :key="key">
                  {{ tag.userName }}
                </el-tag>
                <el-button
                  icon="el-icon-plus"
                  style="margin-left: 10px;"
                  type="primary"
                  @click="onSelectSingleUser(index)"
                >
                  {{ item.weQiRuleUserList.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
              <el-form-item label-width="100px" label="工作周期:">
                <el-checkbox-group v-model="item.workCycle" @change="checkStartEnd($event, index)">
                  <el-checkbox label="1">周一</el-checkbox>
                  <el-checkbox label="2">周二</el-checkbox>
                  <el-checkbox label="3">周三</el-checkbox>
                  <el-checkbox label="4">周四</el-checkbox>
                  <el-checkbox label="5">周五</el-checkbox>
                  <el-checkbox label="6">周六</el-checkbox>
                  <el-checkbox label="7">周日</el-checkbox>
                </el-checkbox-group>
              </el-form-item>
              <el-form-item label-width="100px" label="在线时间:">
                <el-time-select
                  style="width: 130px;"
                  v-model="item.beginTime"
                  start="00:00"
                  end="23:59"
                  step="00:30"
                  :max-time="item.endTime"
                  @change="checkStartEnd($event, index)"
                  placeholder="任意时间点"
                ></el-time-select>
                --
                <el-time-select
                  style="width: 130px;"
                  start="00:00"
                  end="23:59"
                  step="00:30"
                  :min-time="item.beginTime"
                  @change="checkStartEnd($event, index)"
                  v-model="item.endTime"
                  placeholder="任意时间点"
                ></el-time-select>
              </el-form-item>
            </el-card>
          </template>
          <div class="mt20">
            <el-button type="primary" icon="el-icon-plus" @click="onAddCircle">新增时间</el-button>
          </div>
        </el-form-item>
        <el-form-item label="质检会话类型" required prop="chatType">
          <el-radio-group v-model="form.chatType">
            <el-radio :label="1">全部</el-radio>
            <el-radio :label="2">客户会话</el-radio>
            <el-radio :label="3">客群会话</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="质检督导:" prop="manageUserInfo">
          <div v-if="form.manageUserInfo.length > 0">
            <el-tag v-for="(item, index) in form.manageUserInfo" :key="index">
              {{ item.userName }}
            </el-tag>
          </div>
          <el-button icon="el-icon-plus" type="primary" @click="dialogVisible = true">
            {{ form.manageUserInfo.length ? '修改' : '选择' }}成员
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-footer-sticky">
      <el-button @click="$router.back()">取消</el-button>
      <el-button type="primary" @click="submit">确定</el-button>
    </div>
    <SelectUser
      key="1"
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="form.manageUserInfo"
      @success="getSelectUser"
    ></SelectUser>
    <SelectUser
      key="2"
      v-model:visible="singleSelectVisible"
      title="组织架构"
      :defaultValues="singleSelect"
      @success="getSingleUser"
    ></SelectUser>
  </div>
</template>

<script>
  import { addQuality, editQuality, detailQuality } from './api.js'
  export default {
    name: 'quality-add',
    data() {
      return {
        loading: false,
        dialogVisible: false,
        singleSelect: [],
        singleSelectVisible: false,
        orderIndex: null,
        form: {
          name: '',
          chatType: 1,
          timeOut: 10,
          manageUserInfo: [],
          qiRuleScope: [
            {
              beginTime: '',
              endTime: '',
              weQiRuleUserList: [],
              workCycle: []
            }
          ]
        },
        rules: {
          name: [
            {
              required: true,
              message: '请输入质检规则名称',
              trigger: 'blur'
            }
          ],
          timeOut: [
            {
              required: true,
              message: '请输入超时时间标准',
              trigger: 'blur'
            },
            {
              pattern: /^[1-9][0-9]*$/,
              message: '超时时间标准必须为正整数',
              trigger: 'blur'
            }
          ],
          manageUserInfo: [
            {
              required: true,
              message: '请选择质检督导',
              trigger: 'blur'
            }
          ]
        },
        timeConflict: false
      }
    },
    methods: {
      getSingleUser(data) {
        this.form.qiRuleScope[this.orderIndex].weQiRuleUserList = data
      },
      onSelectSingleUser(index) {
        this.orderIndex = index
        this.singleSelect = this.form.qiRuleScope[index].weQiRuleUserList
        this.singleSelectVisible = true
      },
      async checkData() {
        let pass = true
        await this.$refs['form'].validate((validate) => {
          if (!validate) {
            pass = false
          } else {
            let go = true
            let week = true
            let time = true
            this.form.qiRuleScope.forEach((ddd) => {
              if (!ddd.weQiRuleUserList.length) {
                go = false
              }
              if (!ddd.workCycle.length) {
                week = false
              }
              if (!ddd.beginTime || !ddd.endTime) {
                time = false
              }
            })
            if (go) {
              if (week) {
                if (time) {
                  if (this.timeConflict) {
                    pass = false
                    this.msgError('排班存在冲突！')
                  }
                } else {
                  pass = false
                  this.msgError('请选择排班每项的在线时间！')
                }
              } else {
                pass = false
                this.msgError('排班每项工作周期至少勾选一项！')
              }
            } else {
              pass = false
              this.msgError('排班每项至少选择一名员工！')
            }
          }
        })
        return pass
      },
      async submit() {
        if (await this.checkData()) {
          this.loading = true
          let obj = {
            name: this.form.name,
            chatType: this.form.chatType,
            timeOut: this.form.timeOut,
            manageUser: this.form.manageUserInfo.map((dd) => dd.userId).join(',')
          }
          let arr = []
          this.form.qiRuleScope.forEach((res) => {
            let dd = {
              beginTime: res.beginTime,
              endTime: res.endTime,
              workCycle: res.workCycle,
              userIds: res.weQiRuleUserList.map((ff) => ff.userId)
            }
            arr.push(dd)
          })
          obj.qiUserInfos = arr
          ;(this.form.id ? editQuality(this.$route.query.id, obj) : addQuality(obj)).then((res) => {
            if (res.code == 200) {
              this.msgSuccess('操作成功')
              this.loading = false
              this.$router.back()
            }
          })
        }
      },
      checkStartEnd(e, index) {
        this.timeConflict = false
        this.operationIndex = index
        if (
          this.form.qiRuleScope[this.operationIndex].workCycle.length &&
          (this.form.qiRuleScope[this.operationIndex].beginTime || this.form.qiRuleScope[this.operationIndex].endTime)
        ) {
          this.someTimeConflict()
        }
      },
      someTimeConflict() {
        let userList = [] // 当前重复人员
        let passList = []
        let current = this.form.qiRuleScope[this.operationIndex].weQiRuleUserList.map((i) => {
          return { userId: i.userId, name: i.userName }
        })
        this.form.qiRuleScope.forEach((data, key) => {
          data.weQiRuleUserList.map((i, index) => {
            if (key != this.operationIndex) {
              passList.push({
                userId: i.userId,
                name: i.userName,
                index: key,
                week: [],
                goto1: true,
                goto2: true
              })
            }
          })
        })
        current.map((dd) => {
          passList.map((ff) => {
            if (dd.userId === ff.userId) {
              userList.push(ff)
            }
          })
        })
        // 重复人员下的时间校验
        let repeatWeek = []
        let currentWeekday = this.form.qiRuleScope[this.operationIndex].workCycle
        userList.forEach((user) => {
          const arr = this.form.qiRuleScope[user.index].workCycle
          for (var i = 0; i < arr.length; i++) {
            if (currentWeekday.indexOf(arr[i]) != -1) {
              user.week.push(arr[i])
            }
          }
        })
        userList.forEach((ddd) => {
          if (ddd.week.length) {
            let start = this.form.qiRuleScope[ddd.index].beginTime
            let end = this.form.qiRuleScope[ddd.index].endTime
            if (start && end) {
              if (this.form.qiRuleScope[this.operationIndex].beginTime) {
                ddd.goto1 = this.checkAuditTime(start, end, this.form.qiRuleScope[this.operationIndex].beginTime)
              }
              if (this.form.qiRuleScope[this.operationIndex].endTime) {
                ddd.goto2 = this.checkAuditTime(start, end, this.form.qiRuleScope[this.operationIndex].endTime)
              }
            }
          }
        })
        let str = ''
        userList.forEach((fdfd) => {
          if (!fdfd.goto1 || !fdfd.goto2) {
            let ss = fdfd.week.map((data) => {
              return data === 7 ? '日' : data
            })
            str += '员工' + fdfd.name + '在周' + ss.join('、') + '时间存在冲突;'
          }
        })
        if (str) {
          this.timeConflict = true
          this.msgError(str)
        } else {
          this.timeConflict = false
        }
      },
      checkAuditTime(beginTime, endTime, current) {
        let strb = beginTime.split(':')
        if (strb.length != 2) {
          return false
        }
        let stre = endTime.split(':')
        if (stre.length != 2) {
          return false
        }
        let cur = current.split(':')
        if (cur.length != 2) {
          return false
        }
        let b = new Date()
        let e = new Date()
        let n = new Date()
        b.setHours(strb[0])
        b.setMinutes(strb[1])
        e.setHours(stre[0])
        e.setMinutes(stre[1])
        n.setHours(cur[0])
        n.setMinutes(cur[1])
        if (n.getTime() - b.getTime() >= 0 && n.getTime() - e.getTime() <= 0) {
          return false
        } else {
          return true
        }
      },
      getSelectUser(data) {
        this.form.manageUserInfo = data
      },
      onAddCircle() {
        this.form.qiRuleScope.push({ beginTime: '', endTime: '', weQiRuleUserList: [], workCycle: [] })
      },
      onRemoveRoster(index) {
        this.form.qiRuleScope.splice(index, 1)
      }
    },
    created() {
      if (this.$route.query.id) {
        detailQuality(this.$route.query.id).then((res) => {
          this.form = res.data
          this.form.qiRuleScope.forEach((dd) => {
            dd.workCycle = dd.workCycle.split(',')
            dd.weQiRuleUserList.forEach((ss) => {
              ss.name = ss.userName
            })
          })
          this.form.manageUserInfo.forEach((ff) => {
            ff.name = ff.userName
          })
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .sub-des {
    font-size: 12px;
    font-weight: 400;
    color: var(--font-black-6);
  }
  .roster-btn-delete {
    margin-top: -16%;
    margin-right: -8%;
  }
  .roster-card:not(:first-child) {
    margin-top: 20px;
  }
</style>
