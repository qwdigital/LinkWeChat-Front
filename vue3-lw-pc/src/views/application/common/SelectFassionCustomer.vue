<template>
  <div>
    <el-form-item :label="title" required>
      <el-radio-group v-model="currentType" @change="clearData" :disabled="isDetail">
        <el-radio :label="0">全部客户</el-radio>
        <el-radio :label="1">部分客户</el-radio>
      </el-radio-group>
    </el-form-item>
    <el-form-item v-if="currentType == 1">
      <div>
        <div class="item-magin aic">
          <div class="item-name">
            <!-- <span style="color: red;">*</span> -->
            添加人
          </div>
          <el-button v-if="!isDetail" class="mr10" icon="el-icon-plus" type="primary" plain @click="onSelectUser(2)">
            {{ form.weUserIds ? '编辑' : '选择' }}添加人
          </el-button>
          <el-tag v-for="item in selectedUserList" :key="item.userId">{{ item.name }}</el-tag>
        </div>
        <div class="item-magin">
          <div class="item-name">发送性别</div>
          <el-select v-model="form.gender" @change="changeFn()" :disabled="isDetail">
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
            value-format="YYYY-MM-DD"
            v-model="rangeTime"
            @change="setDateChange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"></el-date-picker>
        </div>
        <div class="item-magin aic">
          <div class="item-name">客户标签</div>
          <el-button v-if="!isDetail" class="mr10" icon="el-icon-plus" type="primary" plain @click="onSelectTag">
            {{ form.tagIds ? '编辑' : '选择' }}标签
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
      default: '选择老客',
    },
  },
  watch: {
    dataObj: {
      handler(val, old) {
        if (val) {
          this.setData(val)
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
        weUserIds: '', //执行成员id，多个使用逗号隔开(或群主id)
        weUserName: '', //执行成员名称多个使用逗号隔开(或群主名)
        gender: null, //性别
        tagIds: '', //多个标签id使用逗号隔开
        tagNames: '', //多个标签名使用逗号隔开
        beginTime: '', //添加开始时间
        endTime: '', //添加结束时间
        trackState: null, //跟进状态
      },
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      selectedUserList: [],
      selectedTagList: [],
      rangeTime: [],
      currentType: 0,
    }
  },
  methods: {
    setData(data) {
      if (!data) {
        this.currentType = 0
        this.form = {
          weUserIds: '',
          weUserName: '',
          gender: null,
          tagIds: '',
          tagNames: '',
          beginTime: '',
          endTime: '',
          trackState: null,
        }
        return
      } else {
        this.form = data
        this.currentType = 1
      }
      if (this.form.tagIds) {
        this.selectedTagList = []
        let arr = this.form.tagIds.split(',')
        let obj = {}
        arr.forEach((dd, index) => {
          obj = {
            tagId: dd,
            name: this.form.tagNames.split(',')[index],
          }
          this.selectedTagList.push(obj)
        })
      }
      if (this.form.weUserIds) {
        this.selectedUserList = []
        let arr = this.form.weUserIds.split(',')
        let obj = {}
        arr.forEach((dd, index) => {
          obj = {
            userId: dd,
            name: this.form.weUserName.split(',')[index],
          }
          this.selectedUserList.push(obj)
        })
      }
      if (this.form.beginTime && this.form.endTime) {
        this.rangeTime = [this.form.beginTime, this.form.endTime]
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
      this.form = {
        weUserIds: '',
        weUserName: '',
        gender: null,
        tagIds: '',
        tagNames: '',
        beginTime: '',
        endTime: '',
        trackState: null,
      }
      this.selectedUserList = []
      this.selectedTagList = []
      this.rangeTime = []
      this.changeFn()
    },
    setDateChange(date) {
      if (date && date[0]) {
        this.form.beginTime = date[0]
      } else {
        this.form.beginTime = ''
      }
      if (date && date[1]) {
        this.form.endTime = date[1]
      } else {
        this.form.endTime = ''
      }
      this.changeFn()
    },
    submitSelectTag(data) {
      this.selectedTagList = data
      this.form.tagIds = data
        .map((dd) => {
          return dd.tagId
        })
        .join(',')

      this.form.tagNames = data
        .map((dd) => {
          return dd.name
        })
        .join(',')
      this.changeFn()
    },
    selectedUser(users) {
      this.selectedUserList = users
      this.form.weUserIds = users
        .map((dd) => {
          return dd.userId
        })
        .join(',')
      this.form.weUserName = users
        .map((dd) => {
          return dd.name
        })
        .join(',')
      this.changeFn()
    },
    changeFn() {
      this.$emit('update', this.currentType == 1 ? this.form : null)
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
