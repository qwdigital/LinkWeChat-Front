<script>
import { getList, update, add, remove, sync } from '@/api/internalCollaborate/appManage'
// import clipboard from "clipboard";

export default {
  components: { HistoryMsg: () => import('./HistoryMsg') },
  props: {},
  data() {
    return {
      query: {
        // pageNum: 1,
        // pageSize: 10,
        // name: '',
      },
      // dateRange: [], // 添加日期
      // total: 0,
      form: {},
      list: [],
      dialogVisible: false,
      disabled: false,
      loading: false,
      rules: Object.freeze({
        agentId: [{ required: true, message: '必填项', trigger: 'blur' }],
        name: [{ required: true, message: '必填项', trigger: 'blur' }],
        description: [{ required: true, message: '必填项', trigger: 'blur' }],
        logoUrl: [{ required: true, message: '必填项', trigger: 'change' }],
      }),

      id: '',
      dialogVisibleHistoryMsg: false,
      // dialogVisibleSelectMaterial: false,
    }
  },
  watch: {},
  computed: {},
  created() {
    this.getList()

    this.$store.dispatch('app/setBusininessDesc', `<div>企业微信自建应用管理，支持通过应用发送应用消息</div> `)
  },
  mounted() {
    // new clipboard(".copy-btn");
  },
  methods: {
    getList(page) {
      // if (this.dateRange) {
      //   this.query.beginTime = this.dateRange[0]
      //   this.query.endTime = this.dateRange[1]
      // } else {
      //   this.query.beginTime = ''
      //   this.query.endTime = ''
      // }
      // page && (this.query.pageNum = page)
      this.loading = true
      getList()
        .then(({ data, total }) => {
          data.forEach((element) => {
            element.allowPartyName = (element.allowPartyName || '').split(',')
            element.allowUserinfoName = (element.allowUserinfoName || '').split(',')
          })
          this.list = data
        })
        .finally(() => {
          this.loading = false
        })
    },
    sync(item) {
      sync(item.id).then(({ data }) => {
        Object.assign(item, data)
        this.msgSuccess('操作成功')
      })
    },
    edit(data, type) {
      this.form = Object.assign({}, data || {})
      this.dialogVisible = true
      type || !data ? (this.disabled = false) : (this.disabled = true)
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    submit() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          ;(this.form.id ? update : add)(this.form)
            .then(() => {
              this.msgSuccess('操作成功')
              this.dialogVisible = false
              this.getList()
              // this.getList(!this.form.id && 1)
            })
            .catch(() => {
              this.dialogVisible = false
            })
        }
      })
    },
    remove(id) {
      // const operIds = id || this.ids + ''
      this.$confirm('是否确认删除？该操作不可撤销，请谨慎操作。', {
        title: '警告',
        type: 'warning',
      })
        .then(function () {
          return remove(id)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    // goRoute(id, path) {
    //   this.$router.push({
    //     path: 'taskAev',
    //     query: { id },
    //   })
    // },

    // 选择素材确认按钮
    // submitSelectMaterial(text, image, file) {
    //   this.form.logoMediaid = image.id
    //   this.form.squareLogoUrl = image.materialUrl
    //   this.dialogVisibleSelectMaterial = false
    // },
  },
}
</script>

<template>
  <div>
    <ul v-loading="loading" class="list-wrap">
      <li v-for="(item, index) of list" :key="index" class="list">
        <div class="flex">
          <el-image :src="item.logoUrl" fit="fit"></el-image>
          <div class="">
            <div class="title blod toe">{{ item.name }}</div>
            <div class="desc mt10">
              {{ item.description }}
            </div>
            <el-button size="mini" type="primary" plain @click="sync(item)">同步</el-button>
          </div>
        </div>
        <div class="flex aic mt10">
          <div class="list-label">AgentId</div>
          {{ item.agentId }}
        </div>
        <div class="flex aic mt10">
          <div class="list-label">可见范围</div>
          <!-- <div class="flex">
            <div v-for="(item, index) of item.allowPartys.split(',')" :key="index">
              <i class="el-icon-folder-opened" v-if="item"></i>{{ item }}
            </div>
          </div> -->
          <TagEllipsis :list="item.allowPartyName"></TagEllipsis>
        </div>
        <div class="list-action fxbw">
          <!-- <el-button type="text">发送消息</el-button> -->
          <el-button
            type="text"
            @click="
              id = item.id
              dialogVisibleHistoryMsg = true
            ">
            历史消息
          </el-button>
          <el-button type="text" @click="edit(item)">编辑</el-button>
          <el-button type="text" @click="remove(item.id)">删除</el-button>
        </div>
      </li>
      <li class="list flex aic cp" style="justify-content: center" @click="edit()">
        <div class="ac theme">
          <i class="el-icon-plus"></i>
          添加应用
        </div>
      </li>
    </ul>

    <!-- 编辑，添加弹窗 -->
    <el-dialog
      :title="form.id ? '编辑' : '添加'"
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="580px">
      <el-form ref="form" label-position="right" :model="form" :rules="rules" label-width="80px">
        <!-- 添加 -->
        <!-- <template v-if="!form.id"> -->
        <el-form-item label="应用ID" prop="agentId">
          <el-input v-model="form.agentId" placeholder="请输入应用 AgentId"></el-input>
          <div class="dialog-tip">如何获取：企微后台->应用管理->自建应用详情->AgentId</div>
        </el-form-item>
        <el-form-item
          label="应用密钥"
          prop="secret"
          :rules="{ required: !form.agentId, message: '必填项', trigger: 'blur' }">
          <el-input v-model="form.secret" placeholder="请输入应用 Secret"></el-input>
          <div class="dialog-tip">如何获取：企微后台->应用管理->自建应用详情->Secret</div>
        </el-form-item>
        <!-- </template> -->

        <!-- 编辑 -->
        <template v-if="form.id">
          <el-form-item label="应用名称" prop="name">
            <el-input v-model="form.name" maxlength="16" show-word-limit placeholder="请输入应用名称"></el-input>
          </el-form-item>
          <el-form-item label="应用描述" prop="description">
            <el-input
              type="textarea"
              v-model="form.description"
              maxlength="60"
              show-word-limit
              placeholder="请输入应用描述"></el-input>
          </el-form-item>
          <el-form-item label="应用头像" prop="logoUrl">
            <upload class="image-uploader" :fileUrl.sync="form.logoUrl" type="0"></upload>
          </el-form-item>
        </template>

        <!-- <el-row :gutter="10">
          <el-col :span="4">
            <div class="avatar-wrap ac" @click="dialogVisibleSelectMaterial = true">
              <img class="avatar" v-if="form.squareLogoUrl" :src="form.squareLogoUrl" />
              <i v-else class="el-icon-plus avatar-uploader-icon cc"></i>
            </div>
          </el-col>
          <el-col :span="20">
            <el-form-item label="应用Id" prop="agentId">
              <el-input
                v-model="form.agentId"
                :disabled="!!form.id"
                placeholder="请输入应用Id"></el-input>
            </el-form-item>
            <el-form-item label="应用Secret" prop="agentSecret">
              <el-input
                :disabled="!!form.id"
                v-model="form.agentSecret"
                placeholder="请输入应用Secret"></el-input>
            </el-form-item>
            <el-form-item label="可见范围" v-if="form.id">
              <div class="flex">
                <div v-for="(item, index) of form.allowPartys.split(',')" :key="index">
                  <i class="el-icon-folder-opened" v-if="item"></i>{{ item }}
                </div>
                <div v-for="(item, index) of form.allowUserinfos.split(',')" :key="'1' + index">
                  <i class="el-icon-s-custom" v-if="item"></i>{{ item }}
                </div>
              </div>
            </el-form-item>
          </el-col>
        </el-row> -->
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 历史消息 弹窗 -->
    <el-dialog title="历史消息" :visible.sync="dialogVisibleHistoryMsg" :close-on-click-modal="false">
      <HistoryMsg :id="id" v-if="dialogVisibleHistoryMsg" />
    </el-dialog>

    <!-- 选择素材弹窗 -->
    <!-- <SelectMaterial
      :visible.sync="dialogVisibleSelectMaterial"
      type="1"
      :showArr="[1]"
      @success="submitSelectMaterial"
    >
    </SelectMaterial> -->
  </div>
</template>

<style lang="scss" scoped>
.theme {
  color: $blue;
}
.list-wrap {
  display: flex;
  flex-wrap: wrap;
  line-height: 20px;
  .list {
    width: 33%;
    height: 218px;
    padding: 20px 20px 10px;
    border: 1px solid #eee;
    margin: 0 20px 20px 0;
    background: #fff;
    border-radius: 6px;
    .el-image {
      margin-right: 10px;
      width: 80px;
      height: 80px;
      flex: none;
      border: 1px solid #eee;
      border-radius: 5px;
      background: #eee;
    }
    .title {
      font-size: 16px;
    }
    .desc {
      color: #ddd;
      word-break: break-all;
    }
    .list-label {
      color: #888;
      width: 90px;
    }
  }
}

.dialog-tip {
  color: #888;
  font-size: 12px;
}
// .avatar-wrap {
//   position: relative;
//   width: 120px;
//   height: 120px;
//   border: 1px solid #eee;
//   border-radius: 5px;
// }
// .avatar {
//   width: 100%;
// }
// .avatar-uploader-icon {
//   font-size: 28px;
//   color: #ddd;
// }
</style>
