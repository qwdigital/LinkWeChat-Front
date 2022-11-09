<script>
import { getList, update, add, remove, sync } from '@/api/internalCollaborate/groupRobot'

export default {
  components: { HistoryMsg: () => import('./HistoryMsg') },
  props: {},
  data() {
    return {
      form: {},
      list: [],
      dialogVisible: false,
      disabled: false,
      loading: false,
      rules: Object.freeze({
        name: [{ required: true, message: '必填项', trigger: 'blur' }],
        WebHook: [{ required: true, message: '必填项', trigger: 'blur' }],
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
  mounted() {},
  methods: {
    getList(page) {
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
        <div class="list-item">
          <div class="title blod toe">{{ item.name }}</div>
          <div class="desc mt10">
            {{ item.description }}
          </div>
          <!-- <el-button size="mini" type="primary" plain @click="sync(item)">同步</el-button> -->
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
        </div>
      </li>
      <li class="list" @click="edit()">
        <div class="ac flex aic cp theme list-item" style="justify-content: center">
          <i class="el-icon-plus"></i>
          添加机器人
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
        <el-form-item label="群名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入群名称"></el-input>
          <div class="dialog-tip">如何获取：企微后台->应用管理->自建应用详情->AgentId</div>
        </el-form-item>
        <el-form-item label="WebHook" prop="secret">
          <el-input v-model="form.secret" placeholder="请输入WebHook URL"></el-input>
          <div class="dialog-tip">如何获取：企业微信内部群 -> 开启群机器人 -> 复制地址</div>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 历史消息 弹窗 -->
    <el-dialog title="历史消息" :visible.sync="dialogVisibleHistoryMsg" :close-on-click-modal="false">
      <HistoryMsg :id="id" v-if="dialogVisibleHistoryMsg" ref="historyMsg" />
    </el-dialog>
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
    width: 33.3%;
    overflow: hidden;
  }
  .list-item {
    height: 218px;
    padding: 20px 20px 10px;
    border: 1px solid #eee;
    margin: 0 20px 20px 0;
    background: #fff;
    border-radius: 6px;
    .title {
      font-size: 16px;
    }
    .desc {
      color: #ddd;
      word-break: break-all;
    }
  }
}

.dialog-tip {
  color: #888;
  font-size: 12px;
}
</style>
