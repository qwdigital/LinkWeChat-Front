<script>
import { getList, getAnalysis, remove } from '@/api/intelligentShortLink'
import * as api from '@/api/enterpriseId'
import { touchTypeDict } from './components/mixin'
export default {
  name: '',
  components: {},
  data() {
    return {
      loading: false,
      cardData: [],
      total: 0,
      query: {
        pageSize: 10,
        pageNum: 1,
      },
      touchTypeDict,
      // dictStatus: Object.freeze({
      //   1: '启用',
      //   2: '关闭',
      // }),

      list: [],
      ids: [],
      needMoreInfo: false,
      dialogVisible: false,
    }
  },
  computed: {},
  watch: {},
  created() {
    this.setState()
    this.getList()
    this.getAnalysis()
    this.$store.setBusininessDesc(` <div>生成智能短链，一键跳转公众号、小程序、企业微信</div> `)
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    cancelFn() {
      this.needMoreInfo = false
      this.dialogVisible = false
      this.goRoute()
    },
    gotoSetting() {
      this.$router.push({
        name: lwConfig.WORK_WEIXIN_CONFIG_ROUTE_NAME,
      })
    },
    setState() {
      api.getDetail().then((res) => {
        if (!res.data.wxAppletOriginalId || !res.data.miniAppId || !res.data.miniSecret) {
          this.needMoreInfo = true
        }
      })
    },
    getAnalysis() {
      this.loading = true
      getAnalysis()
        .then(({ data }) => {
          this.cardData = [
            {
              title: '访问总数(pv)',
              tips: '短链页面访问的总次数',
              value: data.pvTotalCount,
            },
            {
              title: '访问总人数(uv)',
              tips: '短链页面访问的独立IP数',
              value: data.uvTotalCount,
            },
            {
              title: '小程序打开数',
              tips: '小程序成功打开的总次数',
              value: data.openTotalCount,
            },
            {
              title: '今日访问总数(pv)',
              tips: '今日短链页面访问的总次数',
              value: data.pvTodayCount,
              title1: '较昨日',
              value1: data.pvDiff,
            },
            {
              title: '今日访问总人数(uv)',
              tips: '今日短链页面访问的独立IP数',
              value: data.uvTodayCount,
              title1: '较昨日',
              value1: data.uvDiff,
            },
            {
              title: '今日小程序打开数',
              tips: '今日小程序成功打开的总次数',
              value: data.openTodayCount,
              title1: '较昨日',
              value1: data.openDiff,
            },
          ]
        })
        .catch((e) => {
          console.log(e)
        })
        .finally(() => {
          this.loading = false
        })
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows || []
          this.total = +total
        })
        .catch(() => {})
        .finally(() => {
          this.loading = false
        })
    },
    resetForm() {
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    goRoute(row, detail = 'addEdit') {
      if (!row && this.needMoreInfo) {
        this.dialogVisible = true
        return
      }
      let { id } = row || {}
      this.$router.push({
        path: './' + detail,
        query: { id },
      })
    },
    remove(id) {
      const ids = id || this.ids + ''
      this.$confirm('是否确认删除吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(function () {
          return remove(ids)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
  },
}
</script>

<template>
  <div>
    <CardGroupIndex :data="cardData"></CardGroupIndex>

    <el-form ref="queryForm" :inline="true" :model="query" class="top-search" label-width="">
      <el-form-item label="短链名称" prop="shortLinkName">
        <el-input clearable v-model="query.shortLinkName" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-select clearable v-model="query.type" placeholder="请选择">
          <el-option
            v-for="(item, index) in touchTypeDict"
            :key="index"
            :label="item.allName"
            :value="+index"></el-option>
        </el-select>
      </el-form-item>
      <!-- <el-form-item label="" prop="status">
        <el-select clearable v-model="query.status" placeholder="请选择">
          <el-option v-for="(item, index) in dictStatus" :key="index" :label="item" :value="+index"></el-option>
        </el-select>
      </el-form-item> -->

      <el-form-item label="">
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" class="mr10" @click="goRoute()">新建短链</el-button>
        <el-button :disabled="!ids.length" type="danger" @click="remove()">批量删除</el-button>
      </div>
      <el-table v-loading="loading" :data="list" @selection-change="(val) => (ids = val.map((e) => e.id))">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column label="短链名称" align="center" prop="shortLinkName" show-overflow-tooltip />
        <el-table-column label="类型" align="center" prop="type">
          <template #default="{ row }">{{ touchTypeDict[row.type + ''].allName }}</template>
        </el-table-column>
        <el-table-column label="短链地址" align="center" prop="shortLink" show-overflow-tooltip>
          <template #default="{ row }">
            <span>{{ row.shortLink }}</span>
            <!-- <el-icon-copy-document
              class="el-icon-copy-document copy-btn cp ml20"
              title="复制"
              :data-clipboard-text="row.shortLink"></el-icon-copy-document> -->
          </template>
        </el-table-column>
        <el-table-column width="35" align="center">
          <template #default="{ row }">
            <el-icon-copy-document
              class="el-icon-copy-document copy-btn cp"
              title="复制"
              :data-clipboard-text="row.shortLink"></el-icon-copy-document>
          </template>
        </el-table-column>

        <!-- <el-table-column label="状态" align="center" prop="status">
        <template #default="{ row }">{{ dictStatus[row.status + ''] }}</template>
      </el-table-column> -->
        <el-table-column label="最后更新时间" align="center" prop="updateTime" show-overflow-tooltip></el-table-column>
        <el-table-column label="操作" align="center">
          <template #default="{ row }">
            <el-button text @click="goRoute(row, 'detail')">详情|统计</el-button>
            <el-button text @click="goRoute(row)">编辑</el-button>
            <el-button @click="remove(row.id)" text>删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
      <template v-if="needMoreInfo">
        <div class="tips">
          智能短链需要先配置短链小程序，否则无法正常使用，
          <a class="link" @click="gotoSetting">去配置</a>
        </div>
      </template>
    </div>
    <el-dialog title="提示" :close-on-click-modal="false" :show-close="false" v-model="dialogVisible" width="auto">
      <div style="text-align: center">智能短链需要先配置短链小程序，否则无法正常使用。</div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelFn">继续新建</el-button>
          <el-button type="primary" @click="gotoSetting">去配置</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
.tips {
  margin-top: 30px;
  text-align: center;
  color: var(--font-black-6);
}
.link {
  color: var(--color);
  border-bottom: 1px solid var(--color);
}
.el-icon-copy-document {
  &:hover {
    color: var(--color);
  }
}
</style>
