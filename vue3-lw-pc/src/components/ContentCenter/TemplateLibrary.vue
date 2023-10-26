<template>
  <div class="left" style="border-radius: 4px; background: var(--bg-white)">
    <!--模板库  -->
    <div>
      <!-- v-hasPermi="['wecom:tlp:add']" -->
      <el-form label-position="left" inline label-width="80px">
        <el-form-item>
          <el-input
            :placeholder="isGroup ? '请输入群发内容' : '请输入欢迎语'"
            v-model="query.templateInfo"
            style="width: 260px"></el-input>
        </el-form-item>
        <el-form-item label-width="0">
          <el-button type="primary" @click="getList(0)">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div>
      <el-table v-loading="loading" :data="list" @current-change="currentChange">
        <el-table-column width="60">
          <template #default="{ row }">
            <el-icon-check
              v-if="welSelected ? welSelected.id === row.id : false"
              class="el-icon-check"
              style="color: rgb(65, 133, 244); font-size: 25px"></el-icon-check>
          </template>
        </el-table-column>
        <el-table-column :label="isGroup ? '群发内容' : '欢迎语'" align="center" min-width="200" show-overflow-tooltip>
          <template #default="scope">
            {{ scope.row.templateInfo }}
          </template>
        </el-table-column>
        <!-- <el-table-column
          v-if="type === '2'"
          label="员工"
          prop="userNames"
          align="center"
        ></el-table-column> -->
        <el-table-column label="附件" align="center" prop="attachTotalNum" />
        <el-table-column label="最近更新" align="center">
          <template #default="scope">
            <div>{{ scope.row.updateBy }}</div>
            <span>{{ scope.row.createTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template #default="scope">
            <el-button text @click="showPreview(scope.row)">预览</el-button>
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

    <el-dialog title="预览" v-model="showPreviewDialog" width="50%" append-to-body>
      <div>
        <PreviewInPhone :list="previewList" :templateInfo="templateInfo"></PreviewInPhone>
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
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getList } from '@/api/drainageCode/welcome'
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
    // 1.欢迎语模板 2.群发模板 3.sop
    isGroup: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      welSelected: {
        id: '',
      },
      userArray: [], // 选择人员
      qrUserName: undefined,
      ids: [],
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        templateType: 1,
        // welcomeMsg: undefined,
        // orderByColumn: 'wmt.create_time',
        // isAsc: 'desc',
      },
      loading: false,
      total: 0,
      list: [],
      showPreviewDialog: false,
      previewList: [],
      templateInfo: '',
      materialMsgList: [],
    }
  },
  watch: {},
  computed: {},
  created() {
    this.getList()
  },
  mounted() {},
  methods: {
    currentChange(val) {
      this.welSelected = val
      if (val) {
        this.$emit('changeObj', val.id)
        // templateDetail(val.id).then((res) => {
        //   this.$emit('changeObj', res.data)
        // })
      }
    },
    resetQuery() {
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
      this.query.qrUserIds = this.userArray
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
      this.query.templateType = this.isGroup ? 2 : 1
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
  background-color: var(--bg-black-11);
}
.bottom {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}
</style>
