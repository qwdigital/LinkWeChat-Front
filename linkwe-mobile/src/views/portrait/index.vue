<template>
  <div class="portrait" :style="{ 'margin-bottom': isQueryExternalUserId ? '70px' : '0px' }">
    <div class="details card">
      <div class="detail mb20">
        <div class="left">
          <div class="img"><img :src="form.avatar" alt="" /></div>
          <div class="right">
            <div class="key">
              {{ form.name || '' }}
              <!-- {{ (form.name || '') + (form.remarkCorpName ? '-' + form.remarkCorpName : '') }} -->
            </div>
            <div class="flex aic">
              <van-icon
                name="manager"
                :class="['gender', { 1: 'man', 2: 'woman' }[form.gender]]"
              ></van-icon>
              <span
                :style="{
                  color: form.customerType === 1 ? '#4bde03' : '#f9a90b',
                  'font-size': '12px',
                }"
              >
                {{ { 1: '@微信', 2: '@企业微信' }[form.customerType] }}
              </span>
            </div>
          </div>
        </div>
        <div
          v-if="dictTrackState[form.trackState]"
          :style="{ color: dictTrackState[form.trackState].color }"
          @click="usershow = true"
        >
          {{ dictTrackState[form.trackState].name }}
          <van-icon name="arrow" />
        </div>
      </div>
      <div class="table">
        <div class="detail li">
          <div class="key">手机号</div>
          <div>{{ form.remarkMobiles }}</div>
        </div>
        <div class="detail li">
          <div class="key">年龄</div>
          <div>{{ form.age }}</div>
        </div>
        <div class="detail li">
          <div class="key">生日</div>
          <div>{{ form.birthday ? form.birthday.substring(0, 10) : '' }}</div>
        </div>
        <div class="detail li">
          <div class="key">邮箱</div>
          <div>{{ form.email }}</div>
        </div>
        <div
          class=" more ac mt15"
          @click="
            detailshow = true
            getAreaList()
          "
        >
          更多详细资料
        </div>
      </div>
    </div>
    <!-- 企业标签 -->
    <div class="userlabel card">
      <div class="detail">
        <div class="title">企业标签</div>
        <div class="data" is-link @click="labelEdit()">编辑<van-icon name="arrow" /></div>
      </div>
      <div v-if="form.tags && form.tags.length" class="labelstyle mt15">
        <div class="label" v-for="(unit, unique) in form.tags" :key="unique">
          {{ unit.name }}
        </div>
      </div>
      <van-empty v-else image-size="50" description="暂无数据" />
    </div>

    <!-- 个人标签 -->
    <div class="userlabel card">
      <div class="detail">
        <div class="title">个人标签</div>
        <div class="data" is-link @click="labelEdit('person')">编辑<van-icon name="arrow" /></div>
      </div>
      <div v-if="form.personTags && form.personTags.length" class="labelstyle mt15">
        <div class="label" v-for="(unit, unique) in form.personTags" :key="unique">
          {{ unit.name }}
        </div>
      </div>
      <van-empty v-else image-size="50" description="暂无数据" />
    </div>

    <!-- 社交关系 -->
    <div class="realationship card">
      <div class="detail">
        <div class="title">社交关系</div>
        <div class="data" @click="goRoute('/community')">详情<van-icon name="arrow" /></div>
      </div>
      <div class="detail">
        <div class="boxnumber">
          <div class="number">{{ staff.length }}</div>
          <p class="key">跟进员工</p>
        </div>
        <div class="boxnumber">
          <div class="number">{{ groupChat.length }}</div>
          <p class="key">所在群聊</p>
        </div>
        <div class="boxnumber">
          <div class="number">{{ commonGroup.length }}</div>
          <p class="key">共同群聊</p>
        </div>
      </div>
    </div>
    <!-- 客户轨迹 -->
    <div class="addwaiting card">
      <div class="detail">
        <div class="title">客户轨迹</div>
        <div class="data" is-link @click="sync">同步</div>
      </div>

      <van-tabs v-model="query.trajectoryType" @change="refreshTrajectory()" :color="color">
        <van-tab :name="0" title="全部"></van-tab>
        <van-tab :name="1" title="客户动态"></van-tab>
        <van-tab :name="2" title="员工动态"></van-tab>
        <van-tab :name="4" title="跟进动态"></van-tab>
        <van-tab :name="3" title="互动动态"></van-tab>
      </van-tabs>

      <!-- 步骤条 -->
      <StepList ref="stepList" :load="findTrajectory"></StepList>
    </div>

    <div class="cancat-btn">
      <van-button
        v-if="isQueryExternalUserId"
        type="info"
        size="normal"
        block
        round
        @click="concat"
      >
        联系客户
      </van-button>
    </div>

    <!--

      以下为各编辑弹窗

      -->
    <!-- 详细资料 -->
    <van-action-sheet v-model="detailshow" title="详细资料">
      <van-form @submit="saveUserInformation" input-align="right">
        <div class="content" style="padding:0;">
          <van-field
            v-model="form.customerFullName"
            name="姓名"
            label="姓名"
            placeholder="请输入"
          />
          <van-field
            v-model="form.remarkMobiles"
            name="手机号"
            label="手机号"
            placeholder="请输入"
          />
          <van-field v-model="form.age" name="年龄" label="年龄" placeholder="请输入" disabled />

          <van-field
            v-model="form.birthday"
            readonly
            name="生日"
            label="生日"
            placeholder="请选择"
            @click="birthdayShow = true"
          />

          <van-field v-model="form.email" name="邮箱" label="邮箱" placeholder="请输入" />

          <van-field
            v-model="form.area"
            readonly
            label="所在省市区(县)"
            placeholder="请选择"
            @click="addressShow = true"
          />

          <van-field v-model="form.address" name="详细地址" label="详细地址" placeholder="请输入" />
          <van-field v-model="form.qq" name="QQ" label="QQ" placeholder="请输入" />
          <van-field v-model="form.position" name="职业" label="职业" placeholder="请输入" />
          <van-field v-model="form.remarkCorpName" name="公司" label="公司" placeholder="请输入" />
          <van-field
            v-model="form.otherDescr"
            name="其他描述"
            label="其他描述"
            placeholder="请输入"
            input-align="left"
            type="textarea"
            class="conagency"
          />
        </div>
        <div class="save-btn">
          <van-button round block size="normal" type="info" native-type="submit">保存</van-button>
        </div>
      </van-form>
    </van-action-sheet>
    <!-- 选择年月日 -->
    <van-popup v-model="birthdayShow" position="bottom" round :style="{ height: '60%' }">
      <van-datetime-picker
        v-model="birthday"
        type="date"
        title="选择年月日"
        :min-date="minDate"
        :max-date="maxDate"
        @confirm="confirm"
        @cancel="detailshow = false"
    /></van-popup>
    <!-- 请选择所在地区 -->
    <van-popup v-model="addressShow" round position="bottom">
      <van-cascader
        v-model="form.areaId"
        title="请选择所在地区"
        :options="addressOptions"
        :field-names="{
          text: 'name',
          value: 'id',
        }"
        @close="addressShow = false"
        @finish="selectedArea"
      />
    </van-popup>

    <!--

      跟进状态触发弹出框开始 -->
    <van-action-sheet v-model="usershow" title="跟进记录">
      <!-- 表单 -->
      <van-form @submit="onSubmit">
        <van-field
          name="radio"
          label="跟进状态"
          required
          :rules="[{ required: true, message: '' }]"
        >
          <template #input>
            <van-radio-group v-model="trackState" direction="horizontal">
              <van-radio name="2">跟进中</van-radio>
              <van-radio name="3">已成交</van-radio>
              <van-radio name="4">无意向</van-radio>
            </van-radio-group>
          </template>
        </van-field>

        <!-- 跟进内容 -->
        <van-field
          v-model="conagency"
          name="跟进内容"
          label="跟进内容"
          placeholder="请输入跟进内容"
          type="textarea"
          required
          class="conagency"
          :rules="[{ required: true, message: '' }]"
        />
        <div class="save-btn">
          <van-button round block size="normal" type="info" native-type="submit">保存</van-button>
        </div>
      </van-form>
    </van-action-sheet>
    <!-- 跟进状态触发弹出框结束 -->

    <!-- 客户标签里的编辑触发弹出框开始 -->
    <van-action-sheet v-model="show" :title="editLabelType === 'person' ? '个人标签' : '客户标签'">
      <!-- 个人标签 -->
      <div class="content">
        <template v-if="editLabelType === 'person'">
          <div class="labelstyle">
            <div
              v-for="(unit, unique) in alllabel"
              :key="unique"
              class="label"
              :class="addTag.some((e) => e.tagId == unit.tagId) && 'active'"
              @click="clickLabel(unit)"
            >
              {{ unit.name }}
            </div>
          </div>
          <div class="add-person-tag ac " @click="showAddTag = true">
            <van-icon class="mr10" name="add-o" />添加个人标签
          </div>
        </template>

        <!-- 企业标签 -->
        <template v-else>
          <div v-for="(item, index) in alllabel" :key="index">
            <div class="mb15 mt5 tag-group-name">{{ item.groupName }}</div>
            <div class="labelstyle">
              <div
                v-for="(unit, unique) in item.weTags"
                :key="unique"
                class="label"
                :class="addTag.some((e) => e.tagId == unit.tagId) && 'active'"
                @click="clickLabel(unit)"
              >
                {{ unit.name }}
              </div>
            </div>
          </div>
        </template>

        <van-empty v-if="!alllabel || !alllabel.length" image-size="50" description="暂无数据" />
      </div>
      <div class="save-btn">
        <van-button type="info" size="normal" block round @click="saveCustomerTag">
          保存
        </van-button>
      </div>
    </van-action-sheet>

    <!-- "添加个人标签 -->
    <van-dialog
      v-model="showAddTag"
      title="添加标签"
      show-cancel-button
      width="300px"
      :confirm-button-color="color"
      :before-close="submitNewPersonTag"
    >
      <van-form ref="addTagForm" validate-trigger="onChange">
        <van-field
          v-model="newPersonTag"
          maxlength="15"
          placeholder="请输入标签（不超过15字）"
          :rules="[{ required: true, message: '' }]"
          class="conagency"
        />
      </van-form>
    </van-dialog>
    <!-- 客户标签里的编辑触发弹出框结束 -->
  </div>
</template>

<script>
import {
  getCustomerInfo,
  updateWeCustomerInfo,
  getAllTags,
  updateWeCustomerPorTraitTag,
  findAddaddEmployes,
  findAddGroupNum,
  findTrajectory,
  addOrEditWaitHandle,
  addOrUpdatePersonTags,
  sync,
} from '@/api/portrait'
import StepList from '@/components/StepList.vue'
import { color } from '@/styles/varibles.less'
import { dateFormat } from '@/utils'
import { getAreaList } from '@/api/common'
export default {
  components: {
    StepList,
  },
  data() {
    return {
      color,
      // 客户标签弹出框
      show: false,
      // 跟进状态的弹出框开始
      usershow: false,
      trackState: '', // 跟进状态
      conagency: '', // 跟进内容
      actions: [{ name: '选项一' }, { name: '选项二' }, { name: '选项三' }],
      // active:false,
      // 客户轨迹
      // 待办动态
      todonewsshow: false,
      // 接口开始
      externalUserId: '',
      // externalUserId: 'wmiGuBCgAAoCBD1frD3hRplbsXoBLx6g', // 客户IdwmiGuBCgAAoCBD1frD3hRplbsXoBLx6g
      // externalUserId: 'wmiGuBCgAA617zOzAIg-0sZG3Vok7BUA',
      form: {
        name: '', // 昵称
        remarkMobiles: '', // 手机号
        age: '', // 年龄
        birthday: '', // 客户生日
        email: '', // 邮箱
        address: '', // 地址
        qq: '', // qq
        position: '', // 职业
        remarkCorpName: '', // 公司
        otherDescr: '', // 其他描述
        tags: [], // 企业标签合集
        personTags: [], // 个人标签合集
      },
      alllabel: [], // 标签组
      // 点击测试组标签获取的变量
      groupId: '',
      name: '',
      tagId: '',
      addTag: [], // 添加的参数
      staff: [], // 添加的员工
      groupChat: [], // 添加的群聊
      commonGroup: [], // 共同的群聊
      //   客户轨迹
      query: {
        trajectoryType: null,
      },

      loading: false,
      finished: false,
      dictTrackState: Object.freeze({
        1: { name: '待跟进', color },
        2: { name: '跟进中', color },
        3: { name: '已成交', color: '#07c160' },
        4: { name: '无意向', color: '#ff976a' },
        5: { name: '已流失', color: '#ee0a24' },
      }),
      editLabelType: '', // 编辑标签类型
      showAddTag: false,
      newPersonTag: '',
      isQueryExternalUserId: false,

      detailshow: false,
      birthdayShow: false,
      addressShow: false,
      minDate: new Date(1949, 9, 1),
      maxDate: new Date(),
      birthday: new Date(2022, 0, 17),
      // 选项列表，children 代表子选项，支持多级嵌套
      addressOptions: [],
    }
  },
  computed: {
    userId() {
      return process.env.NODE_ENV !== 'development' ? this.$store.state.userId : 'XuXueJun'
    },
  },
  created() {
    let query = this.$route.query
    this.externalUserId =
      process.env.NODE_ENV !== 'development'
        ? query && query.id
        : 'wmbhUTLgAA6ByLnY45U-uiC4ccoMvwng'

    this.isQueryExternalUserId = !!this.externalUserId
    if (process.env.NODE_ENV === 'production') {
      this.$toast.loading()
      if (this.isQueryExternalUserId) {
        this.start()
        this.$toast.clear()
      } else {
        this.init()
      }
    } else {
      this.start()
      // this.getAllTags()
    }
  },

  methods: {
    start() {
      this.findAddaddEmployes()
      this.findAddGroupNum()
      this.getCustomerInfo()
      this.refreshTrajectory()
    },
    init() {
      wx.invoke('getContext', {}, (res) => {
        if (res.err_msg == 'getContext:ok') {
          let entry = res.entry //返回进入H5页面的入口类型，目前有normal、contact_profile、single_chat_tools、group_chat_tools
          if (!['single_chat_tools', 'group_chat_tools', 'contact_profile'].includes(entry)) {
            // this.$toast.clear()
            this.$toast('入口错误：' + entry)
            return
          }
          if (entry === 'group_chat_tools') {
            this.$router.replace('/portraitGroup')
            return
          }
          wx.invoke('getCurExternalContact', {}, (res) => {
            if (res.err_msg == 'getCurExternalContact:ok') {
              this.externalUserId = res.userId //返回当前外部联系人userId
              // 获取客户信息
              this.start()
            } else {
              //错误处理
              this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
            }
            this.$toast.clear()
          })
        } else {
          //错误处理
          this.$toast.clear()
          this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
        }
      })
    },
    getCustomerInfo() {
      // this.$toast('userId:' + this.userId)
      let params = {
        externalUserid: this.externalUserId,
        userId: this.userId,
      }
      getCustomerInfo(params)
        .then(({ data }) => {
          if (data.tagIds && data.tagNames) {
            data.tagIds = data.tagIds.split(',')
            data.tagNames = data.tagNames.split(',')
            data.tags = data.tagIds.map((unit, index) => ({
              tagId: unit,
              name: data.tagNames[index],
            }))
          }

          if (data.personTagIds && data.personTagNames) {
            data.personTagIds = data.personTagIds.split(',')
            data.personTagNames = data.personTagNames.split(',')
            data.personTags = data.personTagIds.map((unit, index) => ({
              tagId: unit,
              name: data.personTagNames[index],
            }))
          }
          this.form = Object.assign(data, params)
          // console.log(this.form);
        })
        .catch((err) => {
          console.log(err)
        })
    },
    // 获取客户添加的员工
    findAddaddEmployes() {
      findAddaddEmployes(this.externalUserId)
        .then(({ data }) => {
          // console.log(data);
          this.staff = data
        })
        .catch((err) => {
          console.log(err)
        })
    },
    // 获取用户添加的群
    findAddGroupNum() {
      findAddGroupNum({
        externalUserid: this.externalUserId,
        userId: this.userId,
      })
        .then(({ data }) => {
          this.groupChat = data
          this.commonGroup = this.groupChat.filter((ele) => {
            return ele.groupMemberNum == 1
          })
        })
        .catch((err) => {
          console.log(err)
        })
    },
    //   获取轨迹信息
    findTrajectory(params) {
      if (!this.externalUserId) {
        return new Promise(() => {})
      }
      let query = {
        weUserId: this.userId,
        externalUserid: this.externalUserId,
      }
      Object.assign(query, this.query, params)
      query.trajectoryType == 0 && (query.trajectoryType = null)
      return findTrajectory(query)
    },
    refreshTrajectory() {
      this.$nextTick(() => {
        this.$refs.stepList.getList(1)
      })
    },
    getAreaList() {
      getAreaList().then(({ data }) => {
        this.addressOptions = data
      })
    },
    getAllTags(type) {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })
      let params = {
        groupTagType: 1,
      }
      if (type === 'person') {
        params = {
          groupTagType: 3,
          userId: this.userId,
        }
      }
      return getAllTags(params)
        .then(({ data }) => {
          this.alllabel = this.listTagOneArray = data

          if (this.editLabelType !== 'person') {
            this.listTagOneArray = []
            data.forEach((element) => {
              element.weTags.forEach((d) => {
                this.listTagOneArray.push(d)
              })
            })
          }
          this.$toast.clear()
        })
        .catch((err) => {
          console.log(err)
        })
    },

    // 选择生日
    confirm(date) {
      this.birthdayShow = false
      this.form.birthday = dateFormat(date, 'yyyy-MM-dd')
    },
    // 选择所在省市区
    selectedArea({ selectedOptions }) {
      this.addressShow = false
      this.form.provinceId = selectedOptions[0].id
      this.form.cityId = selectedOptions[1].id
      this.form.areaId = selectedOptions[2].id
      this.form.area = selectedOptions.map((option) => option.name).join('/')
    },
    // 详细资料保存
    saveUserInformation() {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })
      // this.form.userId = this.userId
      updateWeCustomerInfo(this.form)
        .then((data) => {
          this.$toast('操作成功')
          this.detailshow = false
        })
        .catch((err) => {
          console.log(err)
        })
    },

    // 编辑跟进动态
    onSubmit() {
      let form = {
        weUserId: this.userId,
        externalUserid: this.externalUserId,
        trackContent: this.conagency,
        trackState: this.trackState, //1:待跟进;2:跟进中;3:已成交;4:无意向;5:已流失
      }
      addOrEditWaitHandle(form)
        .then((data) => {
          this.getCustomerInfo()
          this.refreshTrajectory()

          if (data.code == 200) {
            this.$toast.success('保存成功')
            this.usershow = false
            this.conagency = ''
            this.trackState = ''
          }
        })
        .catch((err) => {
          console.log(err)
        })

      //   表单重置
      // this.dateagency = ''
      // this.startTime = ''
      // this.endTime = ''
    },

    goRoute(path) {
      this.$router.push({
        path,
        query: {
          customerId: this.externalUserId,
          //   type
        },
      })
    },
    // 点击编辑标签
    async labelEdit(type) {
      this.editLabelType = type
      await this.getAllTags(type)
      this.addTag = []

      let tags = this.form[type === 'person' ? 'personTags' : 'tags']
      let hasErrorTag = [] // 异常活已经删除的标签
      // let repeat = [] // 重复的标签
      tags &&
        tags.forEach((unit) => {
          // 判断是否有重复标签
          // let isRepeat = this.listTagOneArray.some((d) => {
          //   return d.tagId === unit.tagId
          // })
          // // 去重
          // if (isRepeat) {
          //   repeat.push(unit.name)
          //   return
          // }
          let filter = this.listTagOneArray.find((d) => {
            return d.tagId === unit.tagId
          })
          // 如果没有匹配到，则说明该便签处于异常状态，可能已被删除或破坏
          if (!filter) {
            hasErrorTag.push(unit.name)
            return
          }

          this.addTag.push(filter)
        })
      this.show = true
      // 获取用户当前的lable,将当前用户的lable与所有lable进行对比，相同的弹框内蓝色展示
      // 弹框内的标签组选中时蓝色展示
      // 弹框内的子标签与选中时蓝色展示，点击时
    },
    // 点击选择标签
    clickLabel(item) {
      let index = this.addTag.findIndex((e) => {
        return item.tagId == e.tagId
      })
      // 数组里不存在该对象,则添加
      if (index == -1) {
        this.addTag.push({
          groupId: item.groupId,
          name: item.name,
          tagId: item.tagId,
        })
      } else {
        // 数组里存在该对象,则删除
        this.addTag.splice(index, 1)
      }
    },
    // 更新客户画像标签
    saveCustomerTag() {
      //  [{ groupId: this.groupId, name: this.name, tagId: this.tagId }]
      updateWeCustomerPorTraitTag({
        externalUserid: this.externalUserId,
        userId: this.userId,
        isCompanyTag: this.editLabelType !== 'person', //是否是企业标签true是;false:不是
        addTag: this.addTag.map((e) => ({ tagId: e.tagId })),
      })
        .then((res) => {
          //   console.log(res);
          if (res.code == 200) {
            this.show = false
            //   重新获取客户标签
            this.getCustomerInfo()
            this.$toast.success('保存成功')
          }

          // console.log(123);
        })
        .catch((err) => {
          console.log(err)
        })
    },

    // 添加个人标签
    submitNewPersonTag(action, done) {
      if (action === 'confirm') {
        this.$refs.addTagForm
          .validate()
          .then(() => {
            let params = {
              weTags: [{ name: this.newPersonTag, owner: this.userId }],
            }
            addOrUpdatePersonTags(params)
              .then((res) => {
                this.$toast.success('添加成功')
                this.getAllTags('person')
              })
              .catch((err) => {
                console.log(err)
              })
            done()
          })
          .catch((err) => {
            done(false)
            console.log(err)
          })
      } else {
        done()
      }
    },
    sync() {
      this.$toast.loading({
        message: 'loading...',
        duration: 0,
        forbidClick: true,
      })
      sync(this.userId)
        .then((res) => {
          this.$toast.success('同步成功')
          this.refreshTrajectory()
        })
        .finally(() => {
          this.$toast.clear()
        })
    },
    concat(row) {
      wx.openEnterpriseChat({
        // 注意：userIds和externalUserIds至少选填一个。内部群最多2000人；外部群最多500人；如果有微信联系人，最多40人
        userIds: sessionStorage.userId, //参与会话的企业成员列表，格式为userid1;userid2;...，用分号隔开。
        externalUserIds: this.externalUserId, // 参与会话的外部联系人列表，格式为userId1;userId2;…，用分号隔开。
        groupName: '', // 会话名称。单聊时该参数传入空字符串""即可。
        chatId: '', // 若要打开已有会话，需指定此参数。如果是新建会话，chatId必须为空串
        success: (res) => {
          var chatId = res.chatId //返回当前群聊ID，仅当使用agentConfig注入该接口权限时才返回chatId
          // 回调
        },
        fail: (res) => {
          if (res.errMsg.indexOf('function not exist') > -1) {
            alert('版本过低请升级')
          } else {
            // 企微会自动弹出错误提示
            // this.$dialog({ message: '进入失败：' + JSON.stringify(res) })
          }
        },
      })
    },
  },
}
</script>

<style lang="less" scoped>
.portrait {
  padding: 0 12px;
  border-top: 9px solid transparent;
  background: linear-gradient(to bottom, #eaf5ff 0%, #fafafa 256px);
  background-origin: border-box;
}
.card {
  background: #ffffff;
  box-shadow: 0px 2px 6px -3px rgba(0, 0, 0, 0.04);
  border-radius: 8px;
  margin-bottom: 8px;
  padding: 14px;
  .title {
    text-align: center;
    font-size: 16px;
    color: #222;
    font-weight: 500;
    line-height: 30px;
  }
}
.header {
  margin: 20px 10px 10px;
  vertical-align: center;
  text-align: center;
}

//  详细资料
.detail {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #666;
  .key {
    color: #222;
    font-weight: 500;
  }
  .data {
    font-size: 13px;
    color: #999;
  }
  // .van-icon-cross {
  //   color: #999;
  // }
}
.left {
  display: flex;
  align-items: center;
  .img {
    width: 52px;
    height: 52px;
    background-color: #f2f2f2;
    margin-right: 12px;
    border-radius: 6px;
    overflow: hidden;
  }
  .right {
    line-height: 25px;
  }
}
.gender {
  color: #9c9c9c;
}
.man {
  color: @color;
}
.woman {
  color: pink;
}
.table {
  .li {
    line-height: 44px;
    border-bottom: 1px solid #fafafa;
  }
  .more {
    color: @color;
    font-size: 13px;
  }
}

.content {
  max-height: 60vh;
  position: relative;
  margin: 15px 0 0;
  padding: 0 16px;
  overflow: auto;

  ::v-deep .van-field__label {
    color: #222;
    font-weight: 500;
    width: 30vw;
  }
  .add-person-tag {
    color: @color;
    font-size: 13px;
    margin: 30px 0;
  }
  .tag-group-name {
    font-size: 14px;
    color: #666;
  }
}
// .van-action-sheet__header {
//   .van-icon-cross {
//     color: #666;
//     font-size: 16px;
//   }
// }
// 客户标签
.labelstyle {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  .label {
    display: inline-block;
    min-width: 72px;
    font-size: 13px;
    padding: 4px 5px 3px;
    border-radius: 8px;
    color: #666;
    background: #fafafa;
    text-align: center;
    margin: 0 0 11px 9px;
    line-height: 26px;
  }
  .active {
    background: #ecf5ff;
    color: @color;
  }
}

.save-btn {
  width: 90%;
  margin: 20px auto;
  .van-button {
    height: 40px;
    line-height: 40px;
  }
}

//  社交关系
.boxnumber {
  width: 100%;
  text-align: center;
  margin: 10px 0;
  .key {
    font-size: 12px;
    color: #b5b8c0;
  }
  .number {
    text-align: center;
    margin-bottom: 10px;
    font-size: 18px;
    font-weight: 700;
    color: #222;
  }
}
.addwaiting {
  .labelstyle {
    .label1 {
      width: 80px;
      margin-bottom: 20px;
      border-radius: 40px;
    }
  }
}

/deep/.conagency {
  line-height: 40px;
  flex-direction: column;
  .van-field__control {
    // background-color: #f2f2f2;
    background-color: #fafafa;
    padding: 0 10px;
    border-radius: 8px;
  }
}

.cancat-btn {
  background: #fff;
  position: fixed;
  bottom: 0;
  left: 0;
  padding: 15px 5%;
  width: 100vw;
  .van-button {
    height: 40px;
    line-height: 40px;
  }
}
</style>
