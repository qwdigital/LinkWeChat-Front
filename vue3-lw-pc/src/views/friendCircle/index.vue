<template>
  <div>
    <el-form :model="query" label-position="left" ref="queryForm" :inline="true" label-width="" class="top-search">
      <el-form-item label="选择创建人">
        <el-input :model-value="name" readonly @click="dialogVisible = true" placeholder="请选择员工" />
      </el-form-item>
      <el-form-item label="时间范围">
        <el-date-picker
          clearable
          v-model="value1"
          format="YYYY-MM-DD"
          @change="setTimeChange"
          type="daterange"
          range-separator="——"
          start-placeholder="开始日期"
          end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label-width="0">
        <!-- v-hasPermi="['wecom:code:list']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <ButtonSync :lastSyncTime="lastSyncTime" @click="syncFn">同步朋友圈</ButtonSync>
        <div class="desc" v-if="lastSyncTime">最近同步：{{ lastSyncTime }}</div>
        <div class="desc" v-else>暂无记录，请手动点击同步</div>
      </div>

      <el-table ref="table" v-loading="loading" :data="tableData">
        <el-table-column show-overflow-tooltip prop="content" label="朋友圈内容">
          <template #default="{ row }">
            <el-image
              v-if="row.contentType === 'image'"
              :src="row.content"
              fit="fill"
              :preview-src-list="[row.content]"
              style="width: 100px; height: 100px"></el-image>
            <video
              v-else-if="row.contentType === 'video'"
              style="width: 100px; height: 100px"
              :src="row.content"></video>
            <div v-else>{{ row.content }}</div>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip prop="contentType" label="类型">
          <template #default="{ row }">
            <!-- image:图片；text:文本;video:视频；link:图文 -->
            <div>
              {{
                row.contentType === 'image'
                  ? '图片'
                  : row.contentType === 'text'
                  ? '文本'
                  : row.contentType === 'video'
                  ? '视频'
                  : '图文'
              }}
            </div>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip prop="creator" label="创建人"></el-table-column>
        <el-table-column show-overflow-tooltip prop="createTime" width="170px" label="创建时间"></el-table-column>
        <el-table-column show-overflow-tooltip prop="pointNum" label="点赞数"></el-table-column>
        <el-table-column show-overflow-tooltip prop="commentNum" label="评论数"></el-table-column>
        <el-table-column label="操作" align="center" width="100">
          <template #default="{ row }">
            <el-button text @click="detailFn(row.id)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="getList()" />
    </div>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>
    <el-dialog title="详情" v-model="detailDialogVisible" width="40%">
      <el-form label-position="right" label-width="100px">
        <template v-for="(data, index) in detail.otherContent" :key="index">
          <el-form-item label="内容：" v-if="data.annexType === 'text'">
            {{ data.other }}
          </el-form-item>
          <el-form-item label=" " v-if="data.annexType === 'video'">
            <div style="display: inline-block; margin-right: 10px">
              <video style="width: 200px; height: 200px" :src="data.annexUrl" controls></video>
            </div>
          </el-form-item>
          <el-form-item label=" " v-if="data.annexType === 'link'">
            <div style="display: inline-block; margin-right: 10px">
              <span style="width: 100px; height: 100px">{{ data.annexUrl }}</span>
            </div>
          </el-form-item>
        </template>
        <el-form-item label=" ">
          <div class="img_list">
            <div v-for="(data, index) in detail.otherContent">
              <el-image
                class="item"
                style="width: 100px; height: 100px"
                :preview-src-list="[data.annexUrl]"
                v-if="data.annexType === 'image'"
                :src="data.annexUrl"></el-image>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="点赞客户：" v-if="detail.pointCustomerName">
          <el-tag v-for="(data, key) in detail.pointCustomerName.split(',')" :key="key">{{ data }}</el-tag>
        </el-form-item>
        <el-form-item label="评论客户：" v-if="detail.momentCustomerName">
          <el-tag v-for="(data, key) in detail.momentCustomerName.split(',')" :key="key">{{ data }}</el-tag>
        </el-form-item>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="detailDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="detailDialogVisible = false">确 定</el-button>
          </span>
        </template>
      </el-form>
    </el-dialog>
  </div>
</template>
<script>
import moment from 'moment'
import { getEnterpriceList, syncHMoments, getDetail } from '@/api/circle'
export default {
  name: 'friend-index',
  components: {},
  data() {
    return {
      // disable: false,
      value1: [],
      dialogVisible: false,
      userArray: [],
      name: '',
      query: {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        creator: '',
        type: 1,
      },
      loading: false,
      tableData: [],
      total: 0,
      lastSyncTime: '',
      detailDialogVisible: false,
      detail: {},
    }
  },
  methods: {
    setTimeChange(e) {
      if (e) {
        this.query.beginTime = moment(e[0]).format('YYYY-MM-DD')
        this.query.endTime = moment(e[1]).format('YYYY-MM-DD')
      } else {
        this.query.beginTime = ''
        this.query.endTime = ''
      }
    },
    detailFn(id) {
      this.detailDialogVisible = true
      getDetail(id).then((dd) => {
        if (dd.code === 200) {
          this.detail = dd.data
        }
      })
    },
    syncFn() {
      syncHMoments({ filterType: 1 }).then((res) => {
        if (res.code === 200) {
          this.msgSuccess(res.msg)
          this.getList(1)
        }
      })
    },
    getSelectUser(data) {
      this.userArray = data
      this.query.creator = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
      this.name = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
    },
    resetQuery() {
      this.name = ''
      ;(this.query = {
        pageSize: 10,
        pageNum: 1,
        beginTime: '',
        endTime: '',
        creator: '',
        type: 1,
      }),
        (this.userArray = [])
      this.value1 = []
      this.getList(1)
    },
    getList(type) {
      type && (this.query.pageNum = type)
      this.loading = true
      getEnterpriceList(this.query)
        .then((res) => {
          this.tableData = res.rows
          this.lastSyncTime = res.lastSyncTime
          // this.setTimeDiff()
          this.total = Number(res.total)
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // setTimeDiff() {
    //   if (this.lastSyncTime) {
    //     let date1 = moment(this.lastSyncTime)
    //     let date2 = moment()
    //     let date3 = date2.diff(date1, 'minute')
    //     const h = Math.floor(date3 / 60)
    //     console.log(h)
    //     if (h >= 2) {
    //       this.disable = false
    //     } else {
    //       this.disable = true
    //     }
    //   }
    // }
  },
  mounted() {},
  created() {
    this.value1[1] = moment(new Date()).format('YYYY-MM-DD')
    this.value1[0] = moment(new Date()).subtract(1, 'months').format('YYYY-MM-DD')
    this.query.beginTime = moment(this.value1[0]).format('YYYY-MM-DD')
    this.query.endTime = moment(this.value1[1]).format('YYYY-MM-DD')
    this.getList()
  },
}
</script>
<style lang="scss" scoped>
.img_list {
  display: flex;
  flex-wrap: wrap;
  width: 330px;
  .item {
    flex: 1;
    width: 110px;
    height: 100px;
    margin-right: 5px;
  }
}
</style>
