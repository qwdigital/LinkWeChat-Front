<template>
  <div class="flex">
    <div class="g-card fxauto">
      <el-form
        :model="form"
        :rules="rules"
        ref="form"
        label-width="140px"
        :class="isDetail && 'form-detail'"
        :disabled="isDetail">
        <el-form-item label="活码名称:" prop="activityName">
          <el-input v-model="form.activityName" placeholder="请输入名称" show-word-limit maxlength="15"></el-input>
          <el-tag
            class="fr cp"
            v-if="isDetail"
            size="large"
            effect="dark"
            @click="
              $router.push({
                path: 'add',
                query: {
                  id: form.id,
                  obj: encodeURIComponent(JSON.stringify(form)),
                },
              })
            ">
            编辑
          </el-tag>
        </el-form-item>
        <el-form-item label="活码客群:" prop="chatIdList">
          <template v-if="!isDetail">
            <el-button type="primary" @click="selectGroupFn">选择客群</el-button>
            <SelectGroup v-model:visible="showSelectModal" :defaults="groupList" @submit="setSelectData"></SelectGroup>
            <div class="sub-des">最多选择五个客群</div>
          </template>

          <TagEllipsis :list="groupList" limit="10" defaultProps="groupName" emptyText></TagEllipsis>
        </el-form-item>
        <el-form-item label="入群标签:" prop="tagIds">
          <template v-if="!isDetail">
            <el-button type="primary" @click="showSelectTag = true">选择标签</el-button>
            <SelectTag
              v-model:visible="showSelectTag"
              type="1"
              :defaultValues="tagList"
              @success="getSelectTag"></SelectTag>
            <div class="sub-des">通过此群活码进群的客户自动打上标签</div>
          </template>

          <TagEllipsis :list="tagList" limit="10" emptyText></TagEllipsis>
        </el-form-item>
        <el-form-item label="群满是否自动建群:">
          <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
          <div class="sub-des">默认以第一个群的群主作为新建群的群主</div>
        </el-form-item>
        <template v-if="form.autoCreateRoom" label="">
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
        </template>
      </el-form>
    </div>
    <div class="fxnone g-margin-l" v-if="isDetail">
      <CodeLink :data="form" />
    </div>
  </div>
  <div class="g-footer-sticky" v-if="!isDetail">
    <el-button @click="$router.back()">取消</el-button>
    <el-button type="primary" @click="submit">确定</el-button>
  </div>
</template>

<script>
import { add, update, getDetail } from '@/api/drainageCode/group'
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
    CodeLink: defineAsyncComponent(() => import('../components/CodeLink')),
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
        // tagIds: [{ required: true, message: '请添加客群标签', trigger: 'blur' }],
        roomBaseName: [{ required: true, message: '请输入群名前缀', trigger: 'blur' }],
        roomBaseId: [{ required: true, message: '请输入群起始序号', trigger: 'blur' }],
      },
      showSelectModal: false,
      groupList: [],
      tagList: [],
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  created() {
    this.getGroupDetail(this.$route.query.id)
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
    async handleValidateFn() {
      return this.$refs['form'].validate()
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
    submit() {
      this.$refs.form.validate((valid) => {
        if (!valid) return
        this.$store.loading = true
        ;(this.form.id ? update : add)(this.form)
          .then((res) => {
            this.$router.back()
            // if (res.code === 200) {
            //   this.$emit('next', res.data.id, res.data)
            // } else if (res.code === 433) {
            //   this.$refs['form'].fields[0].validateMessage = res.msg
            //   this.$refs['form'].fields[0].validateState = 'error'
            //   this.$emit('next')
            // } else {
            //   this.$emit('next')
            // }
          })
          .finally(() => {
            this.$store.loading = false
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
    getGroupDetail(id) {
      if (id) this.form = JSON.parse(decodeURIComponent(this.$route.query.obj))
      this.form.qrCode = this.form.codeUrl
      this.form.name = this.form.activityName
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
      // // this.$forceUpdate()
    },
  },
}
</script>

<style scoped lang="scss">
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
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
</style>
