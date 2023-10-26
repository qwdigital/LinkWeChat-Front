<template>
  <div class="left">
    <el-form label-position="left" inline label-width="" class="top-search">
      <el-form-item label="欢迎语">
        <el-input placeholder="请输入欢迎语" v-model="query.templateInfo" style="width: 260px"></el-input>
      </el-form-item>
      <el-form-item label="选择员工" prop="qrUserName" v-if="type === '2'">
        <el-input :model-value="qrUserName" readonly @click="dialogVisible = true" placeholder="请选择员工" />
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" @click="getList(0)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="goRoute()">新建{{ wel[type] }}欢迎语</el-button>
        <el-button style="align-self: flex-end" type="primary" plain @click="removeMult()">批量删除</el-button>
      </div>
      <el-table
        v-loading="loading"
        :data="list"
        @selection-change="handleSelectionChange"
        max-height="calc(100vh - 420px)">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="欢迎语" align="center" prop="welcomeMsg" min-width="250" show-overflow-tooltip>
          <template #default="scope">
            {{ scope.row.templateInfo }}
          </template>
        </el-table-column>
        <el-table-column v-if="type === '2'" label="员工" prop="userNames" align="center"></el-table-column>
        <el-table-column label="附件" align="center" prop="attachTotalNum" />
        <el-table-column label="最近更新" align="center">
          <template #default="scope">
            <div>{{ scope.row.updateBy }}</div>
            <span>{{ scope.row.updateTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template #default="scope">
            <el-button text @click="showPreview(scope.row)">预览</el-button>

            <el-button text @click="goRoute(scope.row)">编辑</el-button>
            <!-- v-hasPermi="['wecom:tlp:edit']" -->

            <el-button text @click="remove(scope.row.id)">删除</el-button>
            <!-- v-hasPermi="['wecom:tlp:remove']" -->
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>

    <el-dialog title="预览" v-model="showPreviewDialog" width="50%">
      <PreviewInPhone :list="previewList" :templateInfo="templateInfo"></PreviewInPhone>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="showPreviewDialog = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
    <!-- 批量新建弹窗 -->
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getList, remove } from '@/api/drainageCode/welcome'
// import { lexicalDetail } from '@/api/contentCenter/scriptCenter'
import { templateDetail } from '@/api/contentCenter/modleCenter'

export default {
  name: 'Tab2',
  components: {
    PreviewInPhone,
  },
  props: {
    type: {
      type: [Number, String],
      default: '1',
    },
  },
  data() {
    return {
      userArray: [], // 选择人员
      qrUserName: undefined,
      ids: [],
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        // welcomeMsg: undefined,
        tplType: 1,
        // orderByColumn: 'wmt.create_time',
        // isAsc: 'desc',
        templateType: 1,
      },
      dialogVisible: false,
      loading: false,
      total: 0,
      list: [],
      wel: {
        1: '活码',
        2: '员工',
        3: '入群',
      },
      showPreviewDialog: false,
      previewList: [],
      templateInfo: '',
      materialMsgList: [],
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
    resetQuery() {
      if (this.type == 2) {
        this.query.userId = ''
      }
      this.query.templateInfo = ''
      this.userArray = []
      this.qrUserName = ''
      this.query.pageNum = 1
      this.getList()
    },
    getSelectUser(data) {
      this.userArray = data
      this.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.userId = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    /** 查询 */
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      this.query.tplType = this.type
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
      this.$confirm('是否确认删除吗?', '警告', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
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
      this.$confirm('是否确认删除吗?', '警告', { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' })
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
        query.tplType = this.type
      } else {
        query.tplType = this.type
      }
      this.$router.push({
        path: 'add',
        query: query,
      })
    },
    showPreview(data) {
      this.templateInfo = data.templateInfo
      this.getDeatil(data.id)
      this.showPreviewDialog = true
    },
    getDeatil(id) {
      this.loading = true
      templateDetail(id)
        .then((res) => {
          this.previewList = res.data.weMaterialList
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
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
  background-color: var(--bg-black-11);
}
</style>
