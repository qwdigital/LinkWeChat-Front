<template>
  <div>
    <div class="g-card">
      <el-steps :active="active" align-center finish-status="success">
        <el-step title="基础信息"></el-step>
        <el-step title="活码员工"></el-step>
        <el-step title="欢迎语"></el-step>
      </el-steps>
    </div>
    <div class="g-card">
      <el-form
        v-if="active == 0"
        ref="baseForm"
        :rules="baseRules"
        :model="form"
        label-position="right"
        label-width="100px">
        <el-form-item label="活码名称" prop="qrName">
          <el-input v-model="form.qrName" maxlength="15" show-word-limit clearable></el-input>
          <!-- <div class="g-tip">活码名称创建完成后不可修改</div> -->
        </el-form-item>
        <el-form-item label="活码分组" prop="qrGroupId">
          <el-select v-model="form.qrGroupId">
            <el-option v-for="item in codeCategoryList" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="自动通过好友">
          <el-switch v-model="form.qrAutoAdd" :active-value="1" :inactive-value="0"></el-switch>
          <div class="g-tip">开启后，客户添加该企业微信时，无需好友验证，将会自动添加成功</div>
        </el-form-item>
        <el-form-item label="新客标签">
          <el-button type="primary" @click="selectedFn">选择标签</el-button>
          <div class="g-tip">添加成功后，该客户将会自动打上选中的标签</div>
          <TagEllipsis :list="form.weEmpleCodeTags" limit="10" defaultProps="tagName"></TagEllipsis>
        </el-form-item>
        <el-form-item>
          <el-button plain @click="cancelFn">取消</el-button>
          <el-button type="primary" @click="nextStep(active + 1)">下一步</el-button>
        </el-form-item>
      </el-form>
      <el-form
        v-if="active == 1"
        ref="codeForm"
        :rules="codeRules"
        :model="form"
        label-position="right"
        label-width="100px">
        <el-form-item label="活码类型" prop="qrType">
          <el-radio-group v-model="form.qrType" @change="changeType">
            <el-radio :label="1">单人</el-radio>
            <el-radio :label="2">多人</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排班类型" prop="qrRuleType">
          <el-radio-group v-model="form.qrRuleType">
            <el-radio :label="1">全天在线</el-radio>
            <el-radio :label="2" :disabled="form.qrType === 1">自动排班</el-radio>
          </el-radio-group>
          <div class="g-tip">
            <span v-if="form.qrRuleType == 1">多人全天在线时随机分配，单人活码不支持排班</span>
            <span v-else-if="form.qrRuleType == 2">
              选择自动排班时，默认生成一条全天在线规则，不可删除，保证有员工全天在线
            </span>
          </div>
        </el-form-item>
        <el-form-item label="排班方式" prop="qrRuleMode" v-if="form.qrType == 2 && form.qrRuleType == 1">
          <el-radio-group v-model="form.qrRuleMode">
            <el-radio :label="1">
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <span>
                    轮询
                    <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                  </span>
                </template>
                <div>根据二维码的优先级顺序，平均展示给访问用户。</div>
              </el-popover>
            </el-radio>
            <el-radio :label="2">
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <span>
                    顺序
                    <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                  </span>
                </template>
                <div>二维码访问人数达到访问上限后，自动切换至下一个二维码。</div>
              </el-popover>
            </el-radio>
            <el-radio :label="3">
              <el-popover placement="top" trigger="hover">
                <template #reference>
                  <span>
                    随机
                    <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                  </span>
                </template>
                <div>用户扫描二维码后，将在上线的员工中随机一个进行展示。</div>
              </el-popover>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="活码员工" prop="weEmpleCodeUseScops" v-if="form.qrRuleType == 1">
          <div v-if="form.weEmpleCodeUseScops.length > 0 && form.qrType == 1">
            <el-tag v-for="(item, index) in form.weEmpleCodeUseScops" :key="index">
              {{ item.businessName }}
            </el-tag>
          </div>
          <el-button type="primary" plain @click="onSelectUser">
            {{ form.weEmpleCodeUseScops?.length ? '修改' : '选择' }}员工
          </el-button>
          <div class="g-tip">单人活码只能选择一个员工，多人活码支持选择多个员工</div>
          <div v-if="form.weEmpleCodeUseScops.length > 0 && form.qrType == 2">
            <MemeberList :list="form.weEmpleCodeUseScops" @update="getList"></MemeberList>
            <!-- <el-tag
                  class="user-el-tag"

                  v-for="(item, index) in form.weEmpleCodeUseScops"
                  :key="index"
                >
                  {{ item.businessName }}
                  <el-input-number
                    size="mini"
                    v-model="form.weEmpleCodeUseScops[index].businessNumber"
                    :min="0"
                    :max="100"
                  ></el-input-number>
                </el-tag> -->
          </div>
        </el-form-item>
        <el-form-item label="备用员工" prop="weSpareUseScops" v-if="form.qrType == 2 && form.qrRuleType == 1">
          <div v-if="form.weSpareUseScops.length > 0">
            <el-tag v-for="(item, index) in form.weSpareUseScops" :key="index">
              {{ item.businessName }}
            </el-tag>
          </div>
          <el-button type="primary" plain @click="onSelectSpareUser">
            {{ form.weSpareUseScops.length ? '修改' : '选择' }}备用员工
          </el-button>
        </el-form-item>
        <el-form-item label="开启备用员工" prop="openSpareUser" v-if="form.qrType == 2 && form.qrRuleType == 1">
          <el-switch v-model="form.openSpareUser" :active-value="1" :inactive-value="0"></el-switch>
          <div class="g-tip">员工当日添加用户数达每日上限后添加至备用员工。若如关闭，则自动循环下一个上限</div>
        </el-form-item>
        <el-form-item label="添加同一员工" prop="openSpareUser" v-if="form.qrType == 2 && form.qrRuleType == 1">
          <el-switch v-model="form.isExclusive" :active-value="1" :inactive-value="0"></el-switch>
          <div class="g-tip">开启后，相同客户会优先添加到同一个员工。</div>
        </el-form-item>
        <el-form-item v-if="form.qrRuleType == 2" label="活码排班" prop="empleCodeRosterDto">
          <template v-for="(item, index) in form.empleCodeRosterDto" :key="item.id">
            <el-card class="box-card roster-card">
              <div style="display: flex; justify-content: flex-end">
                <el-button v-if="index !== 0" type="text" icon="el-icon-delete" @click="onRemoveRoster(index)">
                  删除
                </el-button>
              </div>
              <el-form-item label="排班员工">
                <el-tag v-for="(tag, key) in item.weEmpleCodeUseScops" :key="key">
                  {{ tag.businessName }}
                </el-tag>
                <el-button style="margin-left: 10px" type="primary" plain @click="onSelectUser(index)">
                  {{ item.weEmpleCodeUseScops.length ? '修改' : '选择' }}员工
                </el-button>
              </el-form-item>
              <el-form-item label="工作周期">
                <el-checkbox-group v-model="item.weekday" @change="checkStartEnd($event, index)">
                  <el-checkbox :label="1" :disabled="index === 0">周一</el-checkbox>
                  <el-checkbox :label="2" :disabled="index === 0">周二</el-checkbox>
                  <el-checkbox :label="3" :disabled="index === 0">周三</el-checkbox>
                  <el-checkbox :label="4" :disabled="index === 0">周四</el-checkbox>
                  <el-checkbox :label="5" :disabled="index === 0">周五</el-checkbox>
                  <el-checkbox :label="6" :disabled="index === 0">周六</el-checkbox>
                  <el-checkbox :label="7" :disabled="index === 0">周日</el-checkbox>
                </el-checkbox-group>
              </el-form-item>
              <el-form-item label="在线时间">
                <el-time-select
                  style="width: 40%"
                  v-model="item.startDate"
                  :disabled="index === 0"
                  start="00:00"
                  end="23:59"
                  step="00:30"
                  :max-time="item.endDate"
                  @change="checkStartEnd($event, index)"
                  placeholder="任意时间点"></el-time-select>
                -
                <el-time-select
                  style="width: 40%"
                  start="00:00"
                  end="23:59"
                  step="00:30"
                  :min-time="item.startDate"
                  @change="checkStartEnd($event, index)"
                  v-model="item.endDate"
                  :disabled="index === 0"
                  placeholder="任意时间点"></el-time-select>
              </el-form-item>
            </el-card>
          </template>
          <div class="mt20">
            <el-button type="primary" plain @click="onAddRoster">添加工作周期</el-button>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button @click="active--">上一步</el-button>
          <el-button type="primary" @click="nextStep(active + 1)">下一步</el-button>
        </el-form-item>
      </el-form>
      <!-- <welcome-content v-loading="loading" :showBack="true" @update="active = 2" :baseData="materialData" @submit="getWelData"></welcome-content> -->
      <template v-if="active == 2">
        <div class="g-card overhide">
          <div class="g-card-title">欢迎语设置</div>
          <el-form label-position="right" label-width="100px">
            <el-form-item style="margin-bottom: 10px" label="欢迎语类型">
              <el-radio-group v-model="form.qrWelcomeOpen">
                <el-radio :label="1">不发送欢迎语</el-radio>
                <el-radio :label="2">
                  活码欢迎语
                  <div class="bfc-p" v-if="form.qrWelcomeOpen == 2">
                    <el-checkbox v-model="form.qrPriorityUserWelcome" :true-label="0" :false-label="1">
                      如果员工有员工欢迎语，则优先发送员工欢迎语
                      <el-button
                        text
                        size="default"
                        @click="$router.push({ name: 'templateWelAdd', query: { tplType: 2 } })">
                        去设置
                      </el-button>
                    </el-checkbox>
                  </div>
                </el-radio>
              </el-radio-group>
            </el-form-item>
          </el-form>
        </div>
        <template v-if="form.qrWelcomeOpen == 1">
          <el-button @click="active--">上一步</el-button>
          <el-button type="primary" size="default" @click="submit()">确定</el-button>
        </template>

        <AddMaterial
          v-else
          :moduleType="4"
          :otherType="1"
          @update="active = 1"
          @submit="getWelData"
          :baseData="materialData"
          isTransData
          :showModle="true"></AddMaterial>
      </template>
    </div>

    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :selected="selectedTagList"
      @success="submitSelectTag"></SelectTag>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :key="form.qrType"
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      :isOnlyLeaf="true"
      :isSigleSelect="form.qrType == 1"
      @success="selectedUser"></SelectUser>

    <!-- 选择使用备用员工弹窗 -->
    <SelectUser
      :key="form.qrType + '-only'"
      :defaultValues="selectedSpareUserList"
      v-model:visible="dialogVisibleSelectSpareUser"
      title="选择使用备用员工"
      :isOnlyLeaf="true"
      :isSigleSelect="form.qrType == 1"
      @success="selectedSpareUser"></SelectUser>
  </div>
</template>

<script>
import { getDetail, add, update, getCodeCategoryList } from '@/api/drainageCode/staff'
import SelectMaterial from '@/components/SelectMaterial'
import AddMaterial from '@/components/ContentCenter/AddMaterial'
import MemeberList from './memberList.vue'

export default {
  components: {
    MemeberList,
    SelectMaterial,
    AddMaterial,
  },
  data() {
    return {
      operationIndex: null,
      materialData: {
        templateInfo: '',
        materialMsgList: [],
      },
      active: 0,
      baseRules: {
        qrName: [
          {
            required: true,
            message: '请输入活码名称',
            trigger: 'blur',
          },
        ],
        qrGroupId: [
          {
            required: true,
            message: '请选择分组',
            trigger: 'blur',
          },
        ],
      },
      form: {
        qrName: '',
        qrGroupId: '',
        qrAutoAdd: 1, // 自动通过
        weEmpleCodeTags: [], // 标签
        qrWelcomeOpen: 1,
        qrType: 1,
        qrRuleType: 1,
        qrRuleMode: 1,
        openSpareUser: 0,
        isExclusive: 0,
        weEmpleCodeUseScops: [],
        weSpareUseScops: [],
        empleCodeRosterDto: [
          {
            type: 0,
            weEmpleCodeUseScops: [], // 员工
            weSpareUseScops: [], // 备用员工
            weekday: [1, 2, 3, 4, 5, 6, 7], // 周期
            qrRuleType: 2,
            startDate: '00:00', // 开始时间
            endDate: '23:59', // 结束时间
          },
        ],
      },
      codeRules: {
        qrType: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        qrRuleType: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        qrRuleMode: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        openSpareUser: [
          {
            required: false,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        weEmpleCodeUseScops: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
            validator: (rule, value, callback) => {
              if (value.length == 0) {
                callback(new Error('请选择'))
              } else {
                callback()
              }
            },
          },
        ],
        weSpareUseScops: [
          {
            required: false,
            trigger: 'blur',
          },
        ],
      },
      isInsertClientName: true,
      dialogVisibleSelectUser: false,
      dialogVisibleSelectSpareUser: false,
      dialogVisibleSelectTag: false,
      dialogVisibleSelectMaterial: false,
      dialogVisibleSelectWel: false,
      codeCategoryList: [], // 活码分组
      selectedUserList: [], // 需要回显的选中员工
      selectedSpareUserList: [], // 需要回显的选中备用员工
      selectedTagList: [],
      timeConflict: false,
    }
  },
  created() {
    let id = this.$route.query.id
    let groupId = this.$route.query.groupId
    if (groupId) {
      this.form.qrGroupId = groupId
    }
    this.getCodeCategoryList()
    if (id) {
      this.getDetail(id)
    }
  },
  methods: {
    getList(data) {
      this.form.weEmpleCodeUseScops = data
    },
    checkStartEnd(e, index) {
      this.timeConflict = false
      this.operationIndex = index
      let goto = this.allTimeConflict() // 默认全天员工冲突
      // let timeGo = true // 非默认周期时间冲突
      if (goto) {
        // if (this.operationIndex > 0) {
        if (
          this.form.empleCodeRosterDto[this.operationIndex].weekday.length &&
          (this.form.empleCodeRosterDto[this.operationIndex].endDate ||
            this.form.empleCodeRosterDto[this.operationIndex].startDate)
        ) {
          this.someTimeConflict()
        }
        // }
      }
    },
    someTimeConflict() {
      let conflictUserItem = [] // 存在冲突的当前数据
      let userList = [] // 当前重复人员
      let passList = [] // 当前之前的人员 不包含默认的第一条

      let current = this.form.empleCodeRosterDto[this.operationIndex].weEmpleCodeUseScops.map((i) => {
        return { userId: i.businessId, name: i.businessName }
      })
      this.form.empleCodeRosterDto.forEach((data, key) => {
        data.weEmpleCodeUseScops.map((i, index) => {
          if (key != this.operationIndex) {
            passList.push({
              userId: i.businessId,
              name: i.businessName,
              index: key,
              week: [],
              goto1: true,
              goto2: true,
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
      let currentWeekday = this.form.empleCodeRosterDto[this.operationIndex].weekday
      userList.forEach((user) => {
        const arr = this.form.empleCodeRosterDto[user.index].weekday
        for (var i = 0; i < arr.length; i++) {
          if (currentWeekday.indexOf(arr[i]) != -1) {
            user.week.push(arr[i])
          }
        }
      })
      userList.forEach((ddd) => {
        if (ddd.week.length) {
          let start = this.form.empleCodeRosterDto[ddd.index].startDate
          let end = this.form.empleCodeRosterDto[ddd.index].endDate
          if (start && end) {
            if (this.form.empleCodeRosterDto[this.operationIndex].startDate) {
              ddd.goto1 = this.checkAuditTime(start, end, this.form.empleCodeRosterDto[this.operationIndex].startDate)
            }
            if (this.form.empleCodeRosterDto[this.operationIndex].endDate) {
              ddd.goto2 = this.checkAuditTime(start, end, this.form.empleCodeRosterDto[this.operationIndex].endDate)
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
    allTimeConflict() {
      if (this.operationIndex === 0) {
        return true
      }
      let current = this.form.empleCodeRosterDto[this.operationIndex].weEmpleCodeUseScops.map((i) => {
        return { userId: i.businessId, name: i.businessName }
      })
      let first = this.form.empleCodeRosterDto[0].weEmpleCodeUseScops.map((i) => {
        return { userId: i.businessId, name: i.businessName }
      })
      let result = []
      current.map((dd) => {
        first.map((ff) => {
          if (dd.userId === ff.userId) {
            result.push(dd)
          }
        })
      })
      if (result.length) {
        let str = result
          .map((obj, index) => {
            return obj.name
          })
          .join(',')
        this.msgError('员工 ' + str + ' 已是全天在线，时间存在冲突！')
        this.timeConflict = true
        return false
      } else {
        this.timeConflict = false
        return true
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
    cancelFn() {
      this.$router.back()
    },
    getWelData(data) {
      this.submit(data)
    },
    changeType(e) {
      if (e === 1) {
        this.form.qrRuleType = 1
      }
    },
    nextStep(nextStep) {
      let form = ''
      if (nextStep == 1) {
        form = 'baseForm'
      } else if (nextStep == 2) {
        form = 'codeForm'
      }
      this.$refs[form].validate((validate) => {
        if (validate) {
          if (nextStep === 2) {
            if (this.form.qrRuleType === 2) {
              let go = true
              let week = true
              let time = true
              this.form.empleCodeRosterDto.forEach((ddd) => {
                if (!ddd.weEmpleCodeUseScops.length) {
                  go = false
                }
                if (!ddd.weekday.length) {
                  week = false
                }
                if (!ddd.startDate || !ddd.endDate) {
                  time = false
                }
              })
              if (go) {
                if (week) {
                  if (time) {
                    if (this.timeConflict) {
                      this.msgError('排班存在冲突！')
                    } else {
                      this.active = nextStep
                    }
                  } else {
                    this.msgError('请选择活码排班每项的在线时间！')
                  }
                } else {
                  this.msgError('活码排班每项工作周期至少勾选一项！')
                }
              } else {
                this.msgError('活码排班每项至少选择一名员工！')
              }
            } else {
              this.active = nextStep
            }
          } else {
            this.active = nextStep
          }
        }
      })
    },
    /** 获取详情 */
    getDetail(id) {
      getDetail(id).then((res) => {
        let base = JSON.parse(JSON.stringify(res.data))
        Object.assign(this.form, base, {
          qrName: base.name,
          qrGroupId: base.groupId,
          qrAutoAdd: base.autoAdd, // 自动通过
          weEmpleCodeTags: base.qrTags, // 标签
        })
        this.form.qrType = base.type
        this.form.qrRuleType = base.ruleType
        this.form.qrRuleMode = base.ruleMode
        this.form.openSpareUser = base.openSpareUser
        this.form.isExclusive = base.isExclusive
        if (base.ruleType === 1) {
          let arr = []
          let spareArr = []
          base.qrUserInfos[0].weQrUserList.forEach((dd) => {
            if (dd.isSpareUser === 0) {
              let obj = {
                scopeId: base.qrUserInfos[0].scopeId,
                businessId: dd.userId,
                businessName: dd.userName,
                businessNumber: dd.schedulingNum,
              }
              arr.push(obj)
            } else {
              let obj = {
                scopeId: base.qrUserInfos[0].scopeId,
                businessId: dd.userId,
                businessName: dd.userName,
              }
              spareArr.push(obj)
            }
          })
          this.form.weEmpleCodeUseScops = arr
          this.form.weSpareUseScops = spareArr
        } else {
          let arr = []
          base.qrUserInfos.forEach((dd) => {
            let obj = {
              type: dd.type,
              startDate: dd.beginTime,
              endDate: dd.endTime,
              weekday: dd.workCycle ? dd.workCycle.split(',').map((i) => parseInt(i, 0)) : [],
              scopeId: dd.scopeId,
              weEmpleCodeUseScops: dd.weQrUserList.map((ff) => {
                return { businessId: ff.userId, businessName: ff.userName }
              }),
            }
            arr.push(obj)
          })
          this.form.empleCodeRosterDto = arr
        }
        this.materialData = {
          templateInfo: base.qrAttachments?.[0]?.content || '',
          attachments: base.qrAttachments || [],
        }
        // this.materialData.materialMsgList.forEach(ddd => {
        //   ddd.msgType = Number(ddd.msgType)
        // })
      })
    },
    // 获取活码分组
    getCodeCategoryList() {
      getCodeCategoryList({ mediaType: 6 }).then((res) => {
        this.codeCategoryList = res.data
      })
    },
    // 选择人员变化事件
    selectedUser(users) {
      let params = {
        userIds: [],
        departmentIds: [],
      }
      const selectedUserList = users.map((d) => {
        d.userId && params.userIds.push(d.userId)
        d.id && params.departmentIds.push(d.id)
        return {
          businessId: d.userId || d.id,
          businessName: d.name,
          businessIdType: d.userId ? 2 : 1,
          businessNumber: 1,
        }
      })
      params.userIds += ''
      params.departmentIds += ''
      // 全天排班
      if (this.form.qrRuleType == 1) {
        this.form.weEmpleCodeUseScops = selectedUserList
      } else {
        // 自动排班
        this.form.empleCodeRosterDto[this.selectedRosterIndex].weEmpleCodeUseScops = selectedUserList
        this.checkStartEnd(null, this.selectedRosterIndex)
      }
    },
    // 选择备用人员变化事件
    selectedSpareUser(users) {
      let params = {
        spareUserIds: [],
        departmentIds: [],
      }
      const selectedSpareUserList = users.map((d) => {
        d.userId && params.spareUserIds.push(d.userId)
        d.id && params.departmentIds.push(d.id)
        return {
          businessId: d.userId || d.id,
          businessName: d.name,
          businessIdType: d.userId ? 2 : 1,
        }
      })
      params.spareUserIds += ''
      params.departmentIds += ''
      // 全天排班
      if (this.form.qrRuleType == 1) {
        this.form.weSpareUseScops = selectedSpareUserList
      } else {
        // 自动排班
        this.form.empleCodeRosterDto[this.selectedRosterIndex].weSpareUseScops = selectedSpareUserList
        this.checkStartEnd(null, this.selectedRosterIndex)
      }
    },
    // 自动排班-选择员工
    onSelectUser(index) {
      // 设置回显数据
      this.selectedUserList = []
      if (this.form.qrRuleType == 2) {
        this.selectedRosterIndex = index
        let arr = []
        arr = this.form.empleCodeRosterDto[this.selectedRosterIndex].weEmpleCodeUseScops.map((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedUserList = arr
        // this.selectedUserList = [...this.form.weEmpleCodeUseScops[index]]
      } else {
        // this.selectedUserList = [...this.form.weEmpleCodeUseScops]
        let arr = []
        arr = this.form.weEmpleCodeUseScops?.map?.((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedUserList = arr
      }
      this.dialogVisibleSelectUser = true
    },
    // 自动排班-选择备用员工
    onSelectSpareUser(index) {
      // 设置回显数据
      this.selectedSpareUserList = []
      if (this.form.qrRuleType == 2) {
        this.selectedRosterIndex = index
        let arr = []
        arr = this.form.empleCodeRosterDto[this.selectedRosterIndex].weSpareUseScops.map((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedSpareUserList = arr
        // this.selectedSpareUserList = [...this.form.weSpareUseScops[index]]
      } else {
        // this.selectedSpareUserList = [...this.form.weSpareUseScops]
        let arr = []
        arr = this.form.weSpareUseScops.map((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedSpareUserList = arr
      }
      this.dialogVisibleSelectSpareUser = true
    },
    // 添加工作周期
    onAddRoster() {
      this.form.empleCodeRosterDto.push({
        weEmpleCodeUseScops: [], // 员工
        weekday: [], // 周期
        type: 1,
        startDate: '', // 开始时间
        endDate: '', // 结束时间
      })
    },
    // 删除工作周期
    onRemoveRoster(index) {
      this.timeConflict = false
      this.form.empleCodeRosterDto.splice(index, 1)
    },
    // 工作周期时间变化
    onRosterTimeChange(e, index) {
      const [startTime, endTime] = e
      this.form.empleCodeRosterDto[index].startDate = startTime
      this.form.empleCodeRosterDto[index].endDate = endTime
      this.form.empleCodeRosterDto[index].time = e
    },
    selectedFn() {
      if (this.form.weEmpleCodeTags) {
        this.selectedTagList = this.form.weEmpleCodeTags.map((dd) => ({
          tagId: dd.tagId,
          name: dd.tagName,
        }))
      }
      this.dialogVisibleSelectTag = true
    },
    submitSelectTag(data) {
      this.form.weEmpleCodeTags = data.map((d) => ({
        tagId: d.tagId,
        tagName: d.name,
      }))
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
    submit(data) {
      let myObj = {
        attachments: [],
      }
      if (data) {
        let list = data.attachments
        myObj = {
          attachments: [
            {
              content: data.templateInfo,
              msgType: 'text',
            },
          ],
        }
        myObj.attachments.push(...list)
      }
      if (this.form.qrRuleType === 1) {
        let qrUserInfosDetail = []
        this.form.weEmpleCodeUseScops?.forEach?.((uu) => {
          let objDetail = {
            userId: uu.businessId,
            schedulingNum: uu.businessNumber,
          }
          qrUserInfosDetail.push(objDetail)
        })
        let obj = {
          type: 0,
          scopeId: this.form.weEmpleCodeUseScops[0].scopeId ? this.form.weEmpleCodeUseScops[0].scopeId : '',
          userIds: this.form.weEmpleCodeUseScops?.map?.((dd) => dd.businessId),
          spareUserIds: this.form.weSpareUseScops?.map?.((ss) => ss.businessId),
          qrUserInfosDetail: qrUserInfosDetail,
        }
        this.form.qrUserInfos = [obj]
      } else {
        this.form.qrUserInfos = []
        this.form.empleCodeRosterDto?.forEach?.((fff) => {
          let qrUserInfosDetail = []
          fff.weEmpleCodeUseScops.forEach((uu) => {
            let objDetail = {
              userId: uu.businessId,
              schedulingNum: 0,
            }
            qrUserInfosDetail.push(objDetail)
          })
          let obj = {
            scopeId: fff.scopeId ? fff.scopeId : '',
            type: fff.type,
            beginTime: fff.startDate,
            endTime: fff.endDate,
            userIds: fff.weEmpleCodeUseScops.map((dd) => dd.businessId),
            workCycle: fff.weekday,
            qrUserInfosDetail: qrUserInfosDetail,
          }
          this.form.qrUserInfos.push(obj)
        })
      }
      this.form.qrTags = this.form.weEmpleCodeTags.map((ccc) => ccc.tagId)
      let obj = Object.assign({}, this.form, myObj)
      delete obj.weEmpleCodeTags
      delete obj.weEmpleCodeUseScops
      delete obj.empleCodeRosterDto
      if (this.form.id) {
        obj.qrId = this.form.id
        obj.configId = this.form.configId
      }
      this.$store.loading = true
      ;(this.form.id ? update : add)(obj)
        .then(({ data }) => {
          this.msgSuccess('操作成功')
          this.$router.back()
        })
        .finally(() => {
          this.$store.loading = false
        })
    },
  },
}
</script>

<style lang="scss" scoped>
.add-continue {
  cursor: pointer;
  font-size: 14px;

  font-weight: 400;
  color: var(--color);
  display: flex;
  align-items: center;
  justify-content: center;
  &:hover {
    opacity: 0.8;
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

.wrap {
  display: flex;
  margin-top: 24px;
  .el-form {
    margin-right: 10%;
  }
}

.preview-wrap {
  line-height: 26px;
}

.tip {
  color: var(--font-black-6);
}

.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}

.el-icon-error {
}

.my-cord {
  position: relative;
  .operation {
    z-index: 100;
    cursor: pointer;
    position: absolute;
    top: 0;
    right: 0;
    font-size: 12px;

    font-weight: 400;
    color: #1785ff;
    display: flex;
    align-items: center;
    &:hover {
      opacity: 0.8;
    }
  }
}
.roster-btn-delete {
  margin-top: -16%;
  margin-right: -8%;
}
.roster-card:not(:first-child) {
  margin-top: 20px;
}
.user-el-tag {
  margin-right: 50px;
  width: 160px;
  margin-left: 0px;
}
</style>
