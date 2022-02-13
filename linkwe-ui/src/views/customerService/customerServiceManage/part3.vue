<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top:10px;">
      <el-col>
        <div class="g-card g-pad20">
          <el-form ref="form" :model="form" label-position="right" label-width="120px">
            <el-form-item label="接待员工:" required prop="userIdList">
              <div v-if="userList.length > 0">
                <el-tag size="medium" v-for="(item, index) in userList" :key="index">{{ item.name }}</el-tag>
              </div>
              <el-button type="primary" plain size="mini" @click="onSelectUser">{{ userList.length ? '修改' : '选择' }}员工</el-button>
              <div class="sub-des">每个客服账号最多添加500个接待员工</div>
            </el-form-item>
            <el-form-item label="分配方式:" required prop="receptionType">
              <div class="radio-content">
                <div>
                  <el-radio v-model="form.allocationWay" :label="1">轮流分配</el-radio>
                  <div class="sub-des">
                    新咨询轮流分配给所有接待员工
                  </div>
                </div>
                <div style="margin-left:20px;">
                  <el-radio v-model="form.allocationWay" :label="2">空闲分配</el-radio>
                  <div class="sub-des">
                    新咨询分配给当前接待人数最少的接待员工
                  </div>
                </div>
              </div>
            </el-form-item>
            <el-form-item label="优先分配:">
              <el-switch v-model="form.isPriority" :active-value=2 :inactive-value=1></el-switch>
              <div class="sub-des">
                开启后，将优先分配给上次接待的员工
              </div>
            </el-form-item>
            <el-form-item label="接待上限:">
              一个接待员工最多同时接待
              <el-input-number v-model="form.receiveLimit" :min="2" :max="50" :controls="false"></el-input-number>人
              <div class="sub-des">
                请输入2~50的正整数，最多支持同时接待50人
              </div>
            </el-form-item>
            <el-form-item label="排队提醒:">
              <el-switch v-model="form.queueNotice" :active-value=1 :inactive-value=2></el-switch>
              <div class="sub-des">
                开启后，当员工接待达上限，客户进度接待池排队时自动发送提示语
              </div>
              <el-input type="textarea" :disabled="form.queueNotice === 2" v-model="form.queueNoticeContent" maxlength="200" show-word-limit placeholder="请输入" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
            </el-form-item>
            <el-form-item label="超时未回复提醒:">
              <el-switch v-model="form.timeOutNotice" :active-value=1 :inactive-value=2></el-switch>
              <div class="sub-des">
                开启后，当客户超过指定时间未回复时，将自动发送提示语
              </div>
              超过
              <el-input :disabled="form.timeOutNotice === 2" style=" width:60px;" :controls="false" v-model="form.timeOut"></el-input>
              <el-select :disabled="form.timeOutNotice === 2" style="width:80px;" v-model="form.timeOutType">
                <el-option label="分钟" :value="1"></el-option>
                <el-option label="小时" :value="2"></el-option>
              </el-select> 客户未回复时，自动发送提示语
              <el-input :disabled="form.timeOutNotice === 2" style="margin-top: 10px;" type="textarea" v-model="form.timeOutContent" maxlength="200" show-word-limit placeholder="请输入" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
            </el-form-item>
            <el-form-item label="自动结束提醒:">
              <el-switch v-model="form.endNotice" :active-value=1 :inactive-value=2></el-switch>
              <div class="sub-des">
                开启后，当客户超过指定时间未回复时，将自动结束当前会话
              </div>
              超过
              <el-input :disabled="form.endNotice === 2" style=" width:60px;" :controls="false" v-model="form.endNoticeTime"></el-input>
              <el-select :disabled="form.endNotice === 2" style="width:80px;" v-model="form.endTimeType">
                <el-option label="分钟" :value="1"></el-option>
                <el-option label="小时" :value="2"></el-option>
              </el-select> 客户未回复时，自动发送结束语
              <el-input :disabled="form.endNotice === 2" style="margin-top: 10px;" type="textarea" v-model="form.endContent" maxlength="200" show-word-limit placeholder="请输入" :autosize="{ minRows: 5, maxRows: 20 }" clearable />
            </el-form-item>
            <el-form-item>
              <el-button plain @click="nextStep(2)">上一步</el-button>
              <el-button type="primary" @click="nextStep">确定</el-button>
            </el-form-item>
          </el-form>
        </div>
      </el-col>
      <el-col style="width: 350px">
        <div class="g-card g-pad20" style="height: 100%">
          <show-in-phone :name="name" :avatar="avatar" :data="form" def="rule"></show-in-phone>
        </div>
      </el-col>
    </el-row>
    <SelectUser :defaultValues="userList" :visible.sync="dialogVisibleSelectUser" title="选择员工" :isOnlyLeaf="true" @success="selectedUser"></SelectUser>
  </div>
</template>
<script>
  import ShowInPhone from '../components/WelcomeInPhonePre.vue'
  import SelectUser from '@/components/SelectUser'
  export default {
    name: 'customer-service-part3',
    data () {
      return {
        form: {
          userIdList: [],
          allocationWay: 1,
          isPriority: 1,
          receiveLimit: 50,
          queueNotice: 1,
          queueNoticeContent: '抱歉，当前所有客服都在接待中，请耐心等待，谢谢。',
          timeOutNotice: 1,
          timeOut: null,
          timeOutType: 1,
          timeOutContent: '客服当前仍在等待您的回复哦~',
          endNotice: 1,
          endNoticeTime: null,
          endTimeType: 1,
          endContent: '感谢您的支持与信任，若您有任何疑问，欢迎随时联系，谢谢。'
        },
        userList: [],
        selectedUserList: [],
        dialogVisibleSelectUser: false
      }
    },
    components: {
      SelectUser,
      ShowInPhone
    },
    props: {
       name: {
        type: String,
        default: ''
      },
      avatar: {
        type: String,
        default: ''
      },
      isEdit: {
        type: Boolean,
        default: false
      },
      editData: {
        type: Object,
        default: () => {
          return {}
        }
      }
    },
    watch: {
      isEdit: 'setEdit',
    },
    methods: {
      setEdit () {
        if (this.isEdit) {
          this.form = this.editData
          let arr = []
          if (this.editData.userIdList && this.editData.userIdList.length) {
            this.editData.userIdList.forEach(dd => {
              arr.push({ userId: dd.userId, name: dd.userName })
            })
          }
          this.userList = arr
        }
      },
      nextStep (type) {
        console.log(type)
        let arr = []
        this.userList.forEach(dd => {
          arr.push({ userId: dd.userId })
        })
        this.form.userIdList = arr
        this.$emit('submit', type, this.form)
      },
      onSelectUser () {
        this.dialogVisibleSelectUser = true
      },
      selectedUser (users) {
        console.log(users)
        this.userList = users
        this.dialogVisibleSelectUser = false
      }
    },
    mounted () {

    },
    created () {

    }
  }
</script>
<style lang="scss" scoped>
  .radio-content {
    display: flex;
    align-items: center;
  }
  .sub-des {
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
</style>