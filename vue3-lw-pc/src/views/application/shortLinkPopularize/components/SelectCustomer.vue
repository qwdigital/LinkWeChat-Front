<template>
  <div>
    <el-form-item :label="title" required prop="type">
      <el-radio-group v-model="form.type" @change="clearData" :disabled="isDetail">
        <el-radio :label="0">全部客户</el-radio>
        <el-radio :label="1">部分客户</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item v-if="form.type == 1">
      <div>
        <div class="item-magin aic">
          <div class="item-name">
            <!-- <span style="color: red;">*</span> -->
            添加人
          </div>
          <el-button
            v-if="!isDetail"
            class="mr10"
            :icon="'el-icon-CirclePlus'"
            type="primary"
            plain
            @click="onSelectUser(2)">
            {{ form.userIds ? '编辑' : '选择' }}添加人
          </el-button>
          <el-tag v-for="item in selectedUserList" :key="item.userId">{{ item.name }}</el-tag>
        </div>
        <div class="item-magin">
          <div class="item-name">发送性别</div>
          <el-select v-model="form.sex" @change="changeFn()" :disabled="isDetail">
            <el-option label="全部" :value="null"></el-option>
            <el-option label="未知" :value="0"></el-option>
            <el-option label="男性" :value="1"></el-option>
            <el-option label="女性" :value="2"></el-option>
          </el-select>
        </div>
        <div class="item-magin">
          <div class="item-name">
            <!-- <span style="color: red;">*</span> -->
            添加时间
          </div>
          <el-date-picker
            :disabled="isDetail"
            value-format="YYYY-MM-DD HH:mm:ss"
            v-model="rangeTime"
            @change="setDateChange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"></el-date-picker>
        </div>
        <div class="item-magin aic">
          <div class="item-name">客户标签</div>
          <el-button
            v-if="!isDetail"
            class="mr10"
            :icon="circle - plus - outline"
            type="primary"
            plain
            @click="onSelectTag">
            {{ form.labelIds ? '编辑' : '选择' }}标签
          </el-button>
          <el-tag v-for="item in selectedTagList" :key="item.tagId">{{ item.name }}</el-tag>
        </div>
        <div class="item-magin">
          <div class="item-name">商机阶段</div>
          <el-select v-model="form.trackState" @change="changeFn()" :disabled="isDetail">
            <el-option label="全部" :value="null"></el-option>
            <el-option
              v-for="(item, index) in stageList"
              :key="index"
              :label="item.stageKey"
              :value="item.stageVal"></el-option>
          </el-select>
        </div>
      </div>
    </el-form-item>
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择添加人"
      destroyOnClose
      :defaultValues="selectedUserList"
      @success="selectedUser"></SelectUser>

    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      title="选择标签"
      :selected="selectedTagList"
      @success="submitSelectTag"></SelectTag>
  </div>
</template>
<script>
import { getList } from '@/api/salesCenter/businessConver.js'
export default {
  name: 'select-customer',
  components: {},
  props: {
    isDetail: {
      type: Boolean,
      default: false,
    },
    dataObj: {
      type: Object,
      default: null,
    },
    title: {
      type: String,
      default: '群发客户',
    },
  },
  watch: {
    dataObj: {
      handler(val, old) {
        if (val) {
          this.form = val
          this.setData()
        }
      },
      deep: true,
      immediate: true,
    },
  },
  data() {
    return {
      stageList: [],
      form: {
        type: 0,
        sex: null,
        trackState: null,
        addBeginTime: '',
        addEndTime: '',
        labelIds: '',
        userIds: '',
      },
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      selectedUserList: [],
      selectedTagList: [],
      rangeTime: [],
    }
  },
  methods: {
    setData() {
      if (this.form.labelIds) {
        this.selectedTagList = []
        let arr = this.form.labelIds.split(',')
        let obj = {}
        arr.forEach((dd) => {
          obj = {
            tagId: dd,
            name: this.form.labels[dd],
          }
          this.selectedTagList.push(obj)
        })
      }
      if (this.form.userIds) {
        this.selectedUserList = []
        let arr = this.form.userIds.split(',')
        let obj = {}
        arr.forEach((dd) => {
          obj = {
            userId: dd,
            name: this.form.users[dd],
          }
          this.selectedUserList.push(obj)
        })
      }
      if (this.form.addBeginTime && this.form.addEndTime) {
        this.rangeTime = [this.form.addBeginTime, this.form.addEndTime]
      }
    },
    getStage() {
      getList().then((res) => {
        this.stageList = res.data
      })
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    onSelectTag() {
      this.dialogVisibleSelectTag = true
    },
    clearData(type) {
      if (type == 0) {
        this.selectedUserList = []
        this.selectedTagList = []
        this.rangeTime = []
        this.form.sex = ''
        this.form.trackState = ''
        this.form.addBeginTime = ''
        this.form.addEndTime = ''
        this.form.labelIds = ''
        this.form.userIds = ''
        this.changeFn()
      }
    },
    setDateChange(date) {
      if (date && date[0]) {
        this.form.addBeginTime = date[0]
      } else {
        this.form.addBeginTime = ''
      }
      if (date && date[1]) {
        this.form.addEndTime = date[1]
      } else {
        this.form.addEndTime = ''
      }
      this.changeFn()
    },
    submitSelectTag(data) {
      this.selectedTagList = data
      this.form.labelIds = data
        .map((dd) => {
          return dd.tagId
        })
        .join(',')
      let obj = {}
      data.forEach((ff) => {
        obj[ff.tagId] = ff.name
      })
      this.form.labels = obj
      this.changeFn()
    },
    selectedUser(users) {
      this.selectedUserList = users
      this.form.userIds = users
        .map((dd) => {
          return dd.userId
        })
        .join(',')
      let obj = {}
      users.forEach((ff) => {
        obj[ff.userId] = ff.name
      })
      this.form.users = obj
      this.changeFn()
    },
    changeFn() {
      this.$emit('update', this.form)
    },
  },
  created() {
    this.getStage()
  },
}
</script>

<style lang="scss" scoped>
.item-name {
  width: 100px;
}
.item-magin {
  // display: flex;
  margin: 10px 0;
}
</style>
