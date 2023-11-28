<template>
  <div class="flex">
    <el-form
      v-loading="loading"
      :model="form"
      ref="form"
      :rules="rules"
      label-width="100px"
      class="fxauto g-margin-r"
      :class="isDetail && 'form-detail'"
      :disabled="isDetail">
      <div class="g-card">
        <div class="g-card-title fxbw">
          群发设置
          <el-tag class="cp" v-if="isDetail" size="large" effect="dark" @click="sync">同步</el-tag>
        </div>

        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="form.taskName" show-word-limit placeholder="请输入" clearable />
        </el-form-item>

        <el-form-item label="发送范围" prop="sendScope">
          <el-radio-group v-model="form.sendScope">
            <el-radio v-for="(target, index) in { 0: '全部客户', 1: '部分客户' }" :key="index" :label="index">
              {{ target }}
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="form.sendScope == 1">
          <CustomerRangeForm
            v-model:data="form.weCustomersQuery"
            :disabled="isDetail"
            :isDetail="isDetail"
            label-width="100px" />
        </template>
      </div>

      <div class="g-card">
        <div class="g-card-title">拉群设置</div>
        <el-form-item label="加群引导语" prop="welcomeMsg">
          <TextareaExtend
            v-model="form.welcomeMsg"
            maxlength="220"
            show-word-limit
            :autosize="{ minRows: 5, maxRows: 20 }"
            placeholder="请输入"
            clearable />
        </el-form-item>
        <el-form-item label="活码客群:" prop="groups">
          <template v-if="!isDetail">
            <el-button type="primary" @click="dialogVisibleSelectGroup = true">选择客群</el-button>
            <div class="g-tip">最多选择五个客群</div>
            <SelectGroup
              v-model:visible="dialogVisibleSelectGroup"
              :defaults="form.groups"
              @submit="(data) => ((form.groups = data), $refs.form.validateField('groups'))"></SelectGroup>
          </template>
          <TagEllipsis :list="form.groups" limit="5" defaultProps="groupName"></TagEllipsis>
        </el-form-item>

        <el-form-item label="群满自动建群:">
          <el-switch v-model="form.autoCreateRoom" :active-value="1" :inactive-value="0"></el-switch>
          <div class="g-tip">默认以第一个群的群主作为新建群的群主</div>
        </el-form-item>
        <template v-if="form.autoCreateRoom">
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

        <el-form-item label="链接标题" prop="linkTitle">
          <el-input v-model="form.linkTitle" maxlength="20" show-word-limit placeholder="请输入" clearable></el-input>
        </el-form-item>
        <el-form-item label="链接描述" prop="linkDesc">
          <el-input v-model="form.linkDesc" maxlength="30" show-word-limit placeholder="请输入" clearable></el-input>
        </el-form-item>
        <el-form-item label="链接封面" prop="linkCoverUrl">
          <upload v-model:fileUrl="form.linkCoverUrl" type="0" :maxSize="2" :format="['jpg', 'jpeg', 'png']">
            <template #tip><div>支持jpg/jpeg/png格式，图片大小不超过2M</div></template>
          </upload>
        </el-form-item>
      </div>
      <div class="g-footer-sticky" style="z-index: 10" v-if="!isDetail">
        <el-button type="primary" @click="submit">保存</el-button>
        <el-button @click="$router.back()">取消</el-button>
      </div>
    </el-form>

    <div>
      <div class="preview-wrap g-card mt0 sticky-t">
        <div class="g-card-title">预览</div>
        <PhoneDialog
          :list="[
            { text: form.welcomeMsg || '请输入加群引导语' },
            { title: form.linkTitle, desc: form.linkDesc, image: form.linkCoverUrl },
          ]" />
      </div>
    </div>
  </div>
</template>

<script>
import { getDetail, add, update, sync } from './api'
import { getCustomerList } from '@/api/groupMessage'
export default {
  components: { SelectGroup: defineAsyncComponent(() => import('@/components/SelectGroup.vue')) },
  data() {
    return {
      id: '',

      dialogVisibleSelectGroup: false,
      loading: false,
      // 表单参数
      form: {
        taskName: '', // 任务名称
        welcomeMsg: '', // 加群引导语
        sendScope: '0', // 发送范围
        // weCustomersQuery: {},
      },
      rules: Object.freeze({
        taskName: [{ required: true, message: '必填项', trigger: 'blur' }],
        welcomeMsg: [{ required: true, message: '必填项', trigger: 'blur' }],
        groups: [{ required: true, message: '必填项', trigger: 'blur' }],
        sendScope: [{ required: true, message: '必填项', trigger: 'blur' }],
        linkTitle: [{ required: true, message: '必填项', trigger: 'blur' }],
        linkDesc: [{ required: true, message: '必填项', trigger: 'blur' }],
      }),
    }
  },
  computed: {
    isDetail() {
      return this.$route.path.endsWith('detail')
    },
  },
  watch: {},
  created() {
    this.id = this.$route.query.id
    this.id && this.getDetail(this.id)
  },
  methods: {
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id)
        .then(({ data }) => {
          this.form = data
        })
        .finally(() => {
          this.loading = false
        })
    },
    sync() {
      this.loading = false
      sync(this.id)
        .then(() => {
          this.msgSuccess('操作成功')
        })
        .finally(() => {
          this.loading = false
        })
    },
    submit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          let form = JSON.parse(JSON.stringify(this.form))
          if (form.sendScope == 1) {
            let ranges = form.weCustomersQuery
            let params = ranges && {
              genders: ranges.genders?.join(','),
              customerTypes: ranges.customerTypes?.join(','),
              tagIds: ranges.tags?.map((e) => e.tagId)?.join(','),
              tagNames: ranges.tags?.map((e) => e.name)?.join(','),
              userIds: ranges.users?.map((e) => e.userId)?.join(','),
              userNames: ranges.users?.map((e) => e.name)?.join(','),
              beginTime: ranges.dateRange?.[0],
              endTime: ranges.dateRange?.[1],
              trackState: ranges.trackState,
              isContain: ranges.tags?.length ? ranges.isContain : undefined,
            }
            this.loading = true
            getCustomerList(params, 1)
              .then(({ data }) => {
                if (data?.length) {
                  form.senderList = data
                  this.sendData(form)
                } else {
                  this.msgError('未找到可发送客户！')
                  this.loading = false
                }
              })
              .catch(() => {
                this.loading = false
              })
          } else {
            this.sendData(form)
          }
        }
      })
    },
    sendData(form) {
      this.loading = true
      ;(this.id ? update : add)(form)
        .then(() => {
          this.msgSuccess('添加成功')
          this.$router.back()
        })
        .finally(() => {
          this.loading = false
        })
    },
  },
}
</script>

<style lang="scss" scoped>
.preview-wrap {
  line-height: 26px;
}
.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}
</style>
