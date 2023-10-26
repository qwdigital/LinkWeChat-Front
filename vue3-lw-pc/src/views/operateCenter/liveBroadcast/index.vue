<template>
  <div>
    <!-- 企微直播 -->
    <el-form label-position="left" inline label-width="80px" class="top-search">
      <el-form-item label-width="0" prop="qrUserName">
        <el-input :model-value="qrUserName" readonly @click="dialogVisible = true" placeholder="请选择直播成员" />
      </el-form-item>
      <el-form-item label-width="0">
        <el-select v-model="query.liveState" placeholder="请选择直播状态">
          <el-option v-for="item in status" :key="item.value" :label="item.label" :value="item.value"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <el-input placeholder="请输入直播标题" v-model="query.liveTitle" style="width: 260px"></el-input>
      </el-form-item>
      <el-form-item label-width="0">
        <el-date-picker
          v-model="dateRange"
          type="datetimerange"
          format="YYYY-MM-DD HH:mm"
          value-format="YYYY-MM-DD HH:mm"
          start-placeholder="预约开始时间"
          end-placeholder="预约结束时间"
          style="width: 260px"></el-date-picker>
      </el-form-item>

      <el-form-item label-width="0">
        <el-button type="primary" @click="getList(0)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <div>
          <el-button type="primary" @click="goAdd">新建预约直播</el-button>
          <el-button type="primary" @click="refresh" :loading="freshLoadng">同步直播状态</el-button>
        </div>
        <el-button style="align-self: flex-end" type="primary" plain :loading="exportLoading" @click="exportFn">
          导出 Excel
        </el-button>
      </div>
      <el-table v-loading="loading" :data="list">
        <el-table-column label="直播成员" prop="liveUserName" align="center"></el-table-column>
        <el-table-column label="直播标题" align="center" min-width="120" show-overflow-tooltip>
          <template #default="scope">
            {{ coverContent(scope.row.liveTitle) }}
          </template>
        </el-table-column>
        <el-table-column label="所属部门" align="center" min-width="100" show-overflow-tooltip>
          <template #default="scope">
            {{ coverContent(scope.row.deptName) }}
          </template>
        </el-table-column>
        <el-table-column label="直播状态" align="center" show-overflow-tooltip>
          <template #default="scope">
            {{ dealState(scope.row.liveState) }}
          </template>
        </el-table-column>
        <el-table-column label="预约开始时间" align="center">
          <template #default="scope">
            {{ scope.row.liveStartDate + ' ' + scope.row.liveStartTime }}
          </template>
        </el-table-column>
        <el-table-column label="预约持续时间" align="center" prop="livingDurationDesc" />
        <el-table-column label="创建人" align="center" prop="createBy" />
        <el-table-column label="创建时间" align="center" prop="createTime" />
        <el-table-column label="操作" align="center" fixed="right" width="300">
          <template #default="scope">
            <el-button text v-if="[0, 1].includes(scope.row.liveState)" @click="copyURL(scope.row.shareOrJoinUrl)">
              分享直播
            </el-button>
            <el-button text v-if="[1].includes(scope.row.liveState)" @click="copyURL(scope.row.shareOrJoinUrl)">
              进入直播
            </el-button>
            <el-button
              text
              v-if="[2].includes(scope.row.liveState) && scope.row.replayStatus === 0 && scope.row.openReplay === 1"
              @click="copyURL(scope.row.shareOrJoinUrl)">
              查看回放
            </el-button>
            <el-button text @click="shareCount(scope.row.id)">分享统计</el-button>
            <el-button text v-if="[0].includes(scope.row.liveState)" @click="goEdit(scope.row.id)">修改直播</el-button>
            <el-button text v-if="[0].includes(scope.row.liveState)" @click="cancelLive(scope.row.id)">
              取消直播
            </el-button>
            <el-button text v-if="[1, 2].includes(scope.row.liveState)" @click="goDetail(scope.row.id)">
              直播详情
            </el-button>
            <el-button text v-if="[2, 3, 4].includes(scope.row.liveState)" @click="remove(scope.row.id)">
              删除
            </el-button>
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
    <!-- 批量新建弹窗 -->
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
      :isSigleSelect="true"></SelectUser>
  </div>
</template>

<script>
import { getList, liveExport, oneStep, liveRemove, cancelLive } from '@/api/operateCenter/liveBroadcast'
import { dateFormat } from '@/utils/index'
export default {
  data() {
    return {
      freshLoadng: false,
      exportLoading: false,
      userArray: [], // 选择人员
      qrUserName: undefined,
      query: {
        pageNum: 1,
        pageSize: 10,
        liveWeUserid: undefined,
      },
      dialogVisible: false,
      dateRange: [], // 日期范围
      loading: false,
      list: [],
      total: 0,
      status: [
        {
          value: 0,
          label: '预约中',
        },
        {
          value: 1,
          label: '直播中',
        },
        {
          value: 2,
          label: '已结束',
        },
        {
          value: 3,
          label: '已过期',
        },
        {
          value: 4,
          label: '已取消',
        },
      ],
    }
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
      <div>创建企业的预约直播，用于员工内部培训或外部产品宣讲直播</div>
    `,
    )
  },
  methods: {
    /** 查询 */
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      this.query.beginTime = this.dateRange[0]
      this.query.endTime = this.dateRange[1]
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
    resetQuery() {
      // this.query.liveTitle = ''
      let pageSize = this.query.pageSize
      this.userArray = []
      this.qrUserName = ''
      this.dateRange = []
      this.query = {}
      this.query.pageNum = 1
      this.query.pageSize = pageSize
      // this.query.liveState = null
      // this.query.liveWeUserid = null
      this.getList()
    },
    getSelectUser(data) {
      this.userArray = data
      this.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.liveWeUserid = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    // 超过20个。。。展示
    coverContent(str) {
      if (str && str.length > 20) {
        str = str.substr(0, 20) + '...'
      }
      return str
    },
    // 将内容复制到剪切板
    copyURL(url) {
      var textArea = document.createElement('textarea')
      textArea.textContent = url
      textArea.style.position = 'fixed'
      document.body.appendChild(textArea)
      textArea.select()
      try {
        document.execCommand('copy') // 把要复制的内容拷贝到剪贴板
        this.$message.success('链接复制成功，请在微信中打开')
      } catch (ex) {
        this.$message.error('链接复制失败')
        return false
      } finally {
        document.body.removeChild(textArea) // 移除插入的文本域节点
      }
    },

    // 新建预约直播
    goAdd() {
      this.$router.push({
        path: 'add',
      })
    },
    //编辑预约直播
    goEdit(id) {
      this.$router.push({
        path: `add`,
        query: {
          id,
        },
      })
    },
    // 直播详情
    goDetail(id) {
      this.$router.push({
        path: `detail`,
        query: {
          id,
        },
      })
    },
    // 取消直播
    cancelLive(id) {
      this.$confirm('是否确认取消当前直播？取消后不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return cancelLive({ id })
        })
        .then(() => {
          this.getList()
          this.msgSuccess('取消成功')
        })
    },
    // 分享统计
    shareCount(id) {
      this.$router.push({
        path: `share`,
        query: {
          id,
        },
      })
    },
    refresh() {
      this.freshLoadng = true
      oneStep()
        .then((res) => {
          if (res.code === 200) {
            this.getList()
            this.freshLoadng = false
          }
        })
        .catch(() => {
          this.freshLoadng = false
        })
    },
    /** 删除按钮操作 */
    remove(id) {
      this.$confirm('是否确认删除此条直播数据？删除后不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return liveRemove(id)
        })
        .then(() => {
          this.getList()
          this.msgSuccess('删除成功')
        })
    },
    exportFn() {
      this.$confirm('确认导出吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.exportLoading = true
          return liveExport()
        })
        .then((res) => {
          if (!res) return
          const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 构造一个blob对象来处理数据，并设置文件类型

          if (window.navigator.msSaveOrOpenBlob) {
            //兼容IE10
            navigator.msSaveBlob(blob, '咨询记录')
          } else {
            const href = URL.createObjectURL(blob) //创建新的URL表示指定的blob对象
            const a = document.createElement('a') //创建a标签
            a.style.display = 'none'
            a.href = href // 指定下载链接
            a.download = dateFormat(new Date(), 'YYYY-MM-DD') + '_直播列表.xlsx' //指定下载文件名
            a.click() //触发下载
            URL.revokeObjectURL(a.href) //释放URL对象
          }
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.exportLoading = false
        })
    },
    dealState(state) {
      switch (state) {
        case 0:
          return '预约中'
          break
        case 1:
          return '直播中'
          break
        case 2:
          return '已结束'
          break
        case 3:
          return '已过期'
          break
        case 4:
          return '已取消'
          break
      }
    },
  },
}
</script>

<style lang="scss" scoped></style>
