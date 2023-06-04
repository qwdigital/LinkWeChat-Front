<template>
  <div>
    <div>
      <!-- v-hasPermi="['wecom:tlp:add']" -->

      <el-form label-position="left" inline label-width="80px">
        <el-form-item label="欢迎语">
          <el-input clearable placeholder="请输入欢迎语" v-model="query.welcomeMsg" style="width: 260px"></el-input>
        </el-form-item>
        <el-form-item label-width="0">
          <el-button type="primary" @click="getList(0)">查询</el-button>
          <el-button @click=";(query.welcomeMsg = ''), getList(0)">重置</el-button>
        </el-form-item>
      </el-form>
      <div style="margin-top: 20px; display: flex; justify-content: space-between">
        <el-button type="primary" @click="goRoute()">新建{{ wel[type] }}欢迎语</el-button>
        <div>
          <el-button style="align-self: flex-end" type="primary" plain @click="removeMult()">批量删除</el-button>
        </div>
      </div>
    </div>
    <div>
      <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="欢迎语" align="center" prop="welcomeMsg" min-width="250" show-overflow-tooltip>
          <template #default="scope">
            {{ scope.row.attachments[0].content }}
          </template>
        </el-table-column>
        <el-table-column v-if="type === '2'" label="员工" prop="userNames" align="center"></el-table-column>
        <el-table-column label="创建人" align="center" prop="createBy" />
        <el-table-column label="创建时间" align="center" prop="createTime" />
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-button text @click="showPreview(scope.row)">预览</el-button>

            <el-button text @click="goRoute(scope.row)">编辑</el-button>
            <!-- v-hasPermi="['wecom:tlp:edit']" -->

            <el-button text @click="remove(scope.row.id)">删除</el-button>
            <!-- v-hasPermi="['wecom:tlp:remove']" -->
          </template>
        </el-table-column>
      </el-table>
      <div class="bottom">
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </div>
    </div>

    <el-dialog title="预览" v-model="showPreviewDialog" width="50%">
      <div>
        <preview-client :list="previewData"></preview-client>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="showPreviewDialog = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import PreviewClient from '@/components/previewInMobileClient.vue'
import { getList, remove } from '@/api/drainageCode/welcome'
export default {
  name: 'Tab',
  components: {
    PreviewClient,
  },
  props: {
    type: {
      type: [Number, String],
      default: '1',
    },
  },
  data() {
    return {
      ids: [],
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        welcomeMsg: undefined,
        tplType: 1,
        orderByColumn: 'wmt.create_time',
        isAsc: 'desc',
      },
      loading: false,
      total: 0,
      list: [],
      wel: {
        1: '活码',
        2: '员工',
        3: '入群',
      },
      showPreviewDialog: false,
      previewData: {
        welcomeMsg: '',
        materialMsgList: [],
      },
    }
  },
  watch: {},
  computed: {},
  created() {
    this.query.tplType = +this.type
    this.getList()
  },
  mounted() {},
  methods: {
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    /** 查询 */
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    /** 删除按钮操作 */
    remove(id) {
      // const operIds = id || this.ids + "";
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning',
      })
        .then(() => {
          return remove(id)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    removeMult() {
      if (!this.ids.length) {
        this.msgInfo('请勾选需要删除的项！')
        return
      }
      this.$confirm('是否确认删除吗?', '警告', {
        type: 'warning',
      })
        .then(() => {
          return remove(this.ids.join(','))
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    goRoute(data) {
      let query = {}
      if (data) {
        localStorage.setItem('obj', JSON.stringify(data))
        query.id = data.id
      } else {
        query.tplType = this.type
      }
      this.$router.push({
        path: '/content/template/welcomeAdd',
        query: query,
      })
    },
    showPreview(data) {
      ;(this.previewData.welcomeMsg = data.attachments ? data.attachments[0].content : ''),
        (this.previewData.materialMsgList = data.attachments ? this.setEditList(data.attachments) : [])
      this.showPreviewDialog = true
      // })
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              msgType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              msgType: '9',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
  },
}
</script>

<style lang="scss" scoped>
.header {
  padding: 0 20px;
}
.divider-content {
  width: 100%;
  height: 10px;
  background-color: #f5f7fb;
}
.bottom {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}
</style>
