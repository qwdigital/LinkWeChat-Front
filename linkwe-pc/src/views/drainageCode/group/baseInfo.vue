<template>
  <div>
    <el-row>
      <el-col :sm="24" :md="16" :lg="14">
        <el-form :model="form" :rules="rules" ref="form" label-width="140px">
          <el-row>
            <el-col :sm="24" :md="18">
              <el-form-item label="活码名称:" prop="activityName">
                <el-input
                  v-model="form.activityName"
                  placeholder="请输入名称"
                  show-word-limit
                  maxlength="15"></el-input>
              </el-form-item>
              <el-form-item label="活码客群:" prop="chatIdList">
                <template v-for="(item, index) in groupList">
                  <el-tag v-if="item.groupName" size="medium" :key="index">{{ item.groupName }}</el-tag>
                </template>
                <div>
                  <el-button size="mini" type="primary" icon="el-icon-plus" @click="selectGroupFn">
                    {{ '添加' }}客群
                  </el-button>
                </div>
                <div class="sub-des">最多选择五个客群</div>
              </el-form-item>
              <el-form-item label="客群标签:" prop="tagIds">
                <template v-for="(item, index) in tagList">
                  <el-tag v-if="item.name" size="medium" :key="index">{{ item.name }}</el-tag>
                </template>
                <div>
                  <el-button size="mini" type="primary" icon="el-icon-plus" @click="showSelectTag = true">
                    {{ tagList.length ? '编辑' : '添加' }}标签
                  </el-button>
                </div>
                <div class="sub-des">设置群活码的标签</div>
              </el-form-item>
              <el-form-item label="群满是否自动建群:">
                <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
                <div class="sub-des">默认以第一个群的群主作为新建群的群主</div>
              </el-form-item>
              <el-form-item v-if="form.autoCreateRoom" label="">
                <el-card>
                  <el-form-item label="群名前缀:" prop="roomBaseName">
                    <el-input
                      show-word-limit
                      maxlength="20"
                      v-model="form.roomBaseName"
                      placeholder="请输入群名前缀"></el-input>
                  </el-form-item>
                  <el-form-item label="群起始序号:" prop="roomBaseId">
                    <el-input-number v-model="form.roomBaseId" controls-position="right" :min="1"></el-input-number>
                  </el-form-item>
                </el-card>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </el-col>
    </el-row>
    <select-group :visible.sync="showSelectModal" :defaults="groupList" @submit="setSelectData"></select-group>
    <select-tag :visible.sync="showSelectTag" type="2" :defaultValues="tagList" @success="getSelectTag"></select-tag>
  </div>
</template>

<script>
import { add, update, getDetail } from '@/api/drainageCode/group'
import SelectTag from '@/components/SelectTag.vue'
import SelectGroup from '../components/SelectGroup.vue'
export default {
  props: {
    // 实际群活码
    groupCodeId: {
      type: String,
      default: '',
    },
  },
  components: {
    SelectGroup,
    SelectTag,
  },
  data() {
    return {
      showSelectTag: false,
      form: {
        activityName: '',
        autoCreateRoom: 0,
        chatIdList: '',
        roomBaseId: 1,
        tagIds: '',
        roomBaseName: '',
      },
      // 活码头像数据
      headImage: null,
      rules: {
        activityName: [{ required: true, message: '请输入活码名称', trigger: 'blur' }],
        chatIdList: [{ required: true, message: '请添加活码客群', trigger: 'blur' }],
        tagIds: [{ required: true, message: '请添加客群标签', trigger: 'blur' }],
        roomBaseName: [{ required: true, message: '请输入群名前缀', trigger: 'blur' }],
        roomBaseId: [{ required: true, message: '请输入群起始序号', trigger: 'blur' }],
      },
      showSelectModal: false,
      groupList: [],
      tagList: [],
      loading: false,
    }
  },
  created() {
    if (this.groupCodeId) this.form = JSON.parse(decodeURIComponent(this.$route.query.obj))
    this.getGroupDetail()
  },
  methods: {
    selectGroupFn() {
      this.showSelectModal = true
    },
    setSelectData(data) {
      if (data && data.length) {
        this.groupList = data
        this.form.chatIdList = this.groupList
          .map((dd) => {
            return dd.chatId
          })
          .join(',')
      }
    },
    handleValidateFn() {
      let status = null
      this.$refs['form'].validate((valid) => {
        if (valid) {
          status = true
        } else {
          status = false
        }
      })
      return status
    },
    getSelectTag(list) {
      this.tagList = list
      this.form.tagIds = this.tagList
        .map((dd) => {
          return dd.tagId
        })
        .join(',')
      this.form.tags = this.tagList
        .map((dd) => {
          return dd.name
        })
        .join(',')
    },
    // 新增群活码
    add() {
      this.$refs.form.validate((valid) => {
        if (!valid) return
        // 新增群活码数据至数据库
        add(this.form).then((res) => {
          if (res.code === 200) {
            this.$emit('next', res.data.id, res.data)
          } else if (res.code === 433) {
            this.$refs['form'].fields[0].validateMessage = res.msg
            this.$refs['form'].fields[0].validateState = 'error'
            this.$emit('next')
          } else {
            this.$emit('next')
          }
        })
      })
    },
    // 更新群活码
    update() {
      this.$refs.form.validate((valid) => {
        if (!valid) return
        update(this.form).then((res) => {
          if (res.code === 200) {
            this.$emit('next', this.groupCodeId, res.data)
          } else if (res.code === 433) {
            this.$refs['form'].fields[0].validateMessage = res.msg
            this.$refs['form'].fields[0].validateState = 'error'
            this.$emit('next')
          } else {
            this.$emit('next')
          }
        })
      })
    },
    // 获取群活码信息
    getGroupDetail() {
      if (!this.groupCodeId) return
      // 编辑回显
      let arr = []
      let names = this.form.tags ? this.form.tags.split(',') : []
      let ids = this.form.tagIds ? this.form.tagIds.split(',') : []
      ids.forEach((dd, index) => {
        let obj = {
          name: names[index],
          tagId: dd,
        }
        arr.push(obj)
      })
      this.tagList = arr
      let arr2 = []
      let groupNames = this.form.groupNames ? this.form.groupNames.split(',') : []
      let groupIds = this.form.chatIdList ? this.form.chatIdList.split(',') : []
      groupIds.forEach((dd, index) => {
        let obj = {
          groupName: groupNames[index],
          chatId: dd,
        }
        arr2.push(obj)
      })
      this.groupList = arr2
      this.$forceUpdate()
    },
    // 提交
    submit() {
      if (!this.groupCodeId) return this.add()
      this.update()
    },
  },
}
</script>

<style scoped lang="scss">
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: #999999;
}
::v-deep .image-uploader {
  .uploader-icon {
    width: 80px;
    height: 80px;
    line-height: 80px;
  }

  .upload-img {
    width: 80px;
    height: 80px;
  }
}

::v-deep .image-uploader2 {
  .uploader-icon {
    width: 120px;
    height: 120px;
    line-height: 120px;
  }
  .upload-img {
    width: 120px;
    height: 120px;
  }
}

.el-form-item {
  margin-bottom: 30px;
}
</style>
