<template>
  <div>
    <el-form
      :model="query"
      label-position="left"
      ref="queryForm"
      :inline="true"
      label-width="70px"
      class="top-search"
    >
      <el-form-item prop="name">
        <el-input v-model="query.name" placeholder="请输入任务名称" style="width: 160px"></el-input>
      </el-form-item>
      <el-form-item prop="createBy">
        <el-input
          v-model="query.createBy"
          placeholder="请输入创建人"
          style="width: 160px"
        ></el-input>
      </el-form-item>
      <el-form-item prop="sendType">
        <!-- <el-input v-model="query" placeholder="请输入创建人"></el-input> -->
        <el-select clearable v-model="query.sendType" placeholder="请选择发送方式">
          <el-option
            v-for="(item, index) in sendType"
            :key="index"
            :label="item.label"
            :value="item.value"
          ></el-option>
        </el-select>
      </el-form-item>
      <el-form-item prop="creator">
        <el-select clearable v-model="query.status" placeholder="请选择任务状态">
          <el-option
            v-for="(item, index) in taskStatus"
            :key="index"
            :label="item.label"
            :value="item.value"
          ></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-date-picker
          clearable
          v-model="value1"
          format="YYYY-MM-DD HH:mm"
          @change="setTimeChange"
          type="datetimerange"
          range-separator="—"
          start-placeholder="执行开始时间"
          end-placeholder="执行结束时间"
          style="width: 260px"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <!-- v-hasPermi="['wecom:code:list']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">清空</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <div>
          <!-- <span class="desc" v-if="lastSyncTime">最近同步：{{ lastSyncTime }}</span>
          <span class="desc" v-else>暂无记录，请手动点击同步</span> -->
          <ButtonSync @click="syncFn">同步</ButtonSync>
        </div>
        <div>
          <el-popover placement="top" trigger="hover">
            <template #reference>
              <el-icon-QuestionFilled class="el-icon-QuestionFilled mr5"></el-icon-QuestionFilled>
            </template>
            <div>企业每分钟创建朋友圈的频率：10条/分钟</div>
          </el-popover>
          <el-button type="primary" @click="gotoRoute" style="margin-right: 10px"
            >新建朋友圈</el-button
          >
        </div>
      </div>
      <el-table ref="table" v-loading="loading" :data="tableData">
        <el-table-column show-overflow-tooltip prop="name" label="任务名称">
          <template #default="{ row }">
            {{ row.name ? row.name : '—' }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip prop="sendType" label="发送方式">
          <template #default="{ row }">
            {{ dealSendType(row.sendType) }}
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip prop="createBy" label="创建人"></el-table-column>
        <el-table-column
          show-overflow-tooltip
          prop="executeTime"
          label="执行时间"
        ></el-table-column>
        <el-table-column show-overflow-tooltip prop="status" label="任务状态">
          <template #default="{ row }">
            <div>
              {{ dealType(row.status) }}
            </div>
          </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip prop="finishRate" label="完成率"></el-table-column>
        <el-table-column label="操作" align="center" width="200">
          <template #default="{ row }">
            <el-button text @click="remind(row.id)" v-if="row.status === 2">提醒执行</el-button>
            <el-button text @click="statistics(row)">统计</el-button>
            <el-button text @click="detailFn(row)">查看</el-button>
            <el-button text @click="cease(row.id)" v-if="row.status !== 3">停止</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()"
      />
    </div>

    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectUser>
  </div>
</template>
<script>
import moment from 'moment'
import { getEnterpriceList, syncHMoments, cancelMoments, reminderMoments } from '@/api/circle'
export default {
  name: 'enterprise',
  components: {},
  data() {
    return {
      value1: [],
      dialogVisible: false,
      userArray: [],
      query: {
        pageSize: 10,
        pageNum: 1,
        executeStartTime: '',
        executeEndTime: '',
      },
      loading: false,
      tableData: [],
      total: 0,
      sendType: [
        { label: '企微群发', value: 0 },
        { label: '成员群发', value: 1 },
        { label: '自主发送', value: 2 },
      ], // 发送方式
      taskStatus: [
        { label: '未开始', value: 1 },
        { label: '进行中', value: 2 },
        { label: '已结束', value: 3 },
      ], // 任务状态
    }
  },
  methods: {
    dealType(type) {
      switch (type) {
        case 1:
          return '未开始'
          break
        case 2:
          return '进行中'
          break
        case 3:
          return '已结束'
          break
      }
    },
    dealSendType(type) {
      switch (type) {
        case 0:
          return '企微群发'
          break
        case 1:
          return '个人发送'
          break
        case 2:
          return '成员群发'
          break
      }
    },
    remind(id) {
      this.$confirm('提醒执行将针对本任务未执行的成员再次催促执行，是否确认提醒？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      })
        .then(() => {
          reminderMoments(id).then((res) => {
            if (res.code === 200) {
              this.msgSuccess(res.msg)
              this.getList()
            }
          })
        })
        .catch(() => {})
    },
    cease(id) {
      this.$confirm(
        '是否确认停止当前朋友圈任务？停止后将终止当前朋友圈任务，不可再次继续。仅可查看已执行成员的相关数据。（部分朋友圈数据同步可能会存在偏差）',
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
        }
      )
        .then(() => {
          cancelMoments(id).then((res) => {
            if (res.code === 200) {
              this.msgSuccess(res.msg)
              this.getList()
            }
          })
        })
        .catch(() => {})
    },
    gotoRoute() {
      this.$router.push({
        path: '/customerMaintain/friendCircle/publish',
      })
    },
    setTimeChange(e) {
      if (e) {
        this.query.executeStartTime = moment(e[0]).format('YYYY-MM-DD HH:mm')
        this.query.executeEndTime = moment(e[1]).format('YYYY-MM-DD HH:mm')
      } else {
        this.query.executeStartTime = ''
        this.query.executeEndTime = ''
      }
    },
    determineType(row) {
      let determineType = '' // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
      if (row.isLwPush === 1) {
        // 非同步型
        determineType = 1
      } else if (row.isLwPush === 0) {
        // 同步型
        if (row.type === 0) {
          // 企业同步型
          determineType = 2
        } else if (row.type === 1) {
          // 个人同步型
          determineType = 3
        }
      }
      return determineType
    },
    detailFn(row) {
      // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
      let type = this.determineType(row)
      this.$router.push({
        path: '/customerMaintain/friendCircle/publish',
        query: {
          type,
          id: row.id,
        },
      })
    },
    // 统计
    statistics(row) {
      // 朋友圈类型 1：非同步型  2：企业同步型 3：个人同步型
      let type = this.determineType(row)
      this.$router.push({
        path: '/customerMaintain/friendCircle/statistics',
        query: {
          type,
          id: row.id,
        },
      })
    },
    syncFn() {
      syncHMoments(2).then((res) => {
        if (res.code === 200) {
          this.msgSuccess(res.msg)
          this.getList()
        }
      })
    },
    getSelectUser(data) {
      this.userArray = data
      this.query.creator = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
    },
    resetQuery() {
      ;(this.query = {
        pageSize: 10,
        pageNum: 1,
        executeStartTime: '',
        executeEndTime: '',
        // beginTime: '',
        // endTime: '',
        // creator: '',
        // type: 0,
      }),
        (this.userArray = [])
      this.value1 = []
      this.getList()
    },
    getList(type) {
      type && (this.query.pageNum = type)
      this.loading = true
      getEnterpriceList(this.query)
        .then((res) => {
          this.tableData = res.rows
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
    // },
  },
  mounted() {},
  created() {
    // this.value1[1] = moment(new Date()).format('YYYY-MM-DD')
    // this.value1[0] = moment(new Date()).subtract(1, 'months').format('YYYY-MM-DD')
    // this.query.executeStartTime = moment(this.value1[0]).format('YYYY-MM-DD')
    // this.query.executeEndTime = moment(this.value1[1]).format('YYYY-MM-DD')
    this.getList()
    this.$store.setBusininessDesc(
      `
        <div>可对企业的朋友圈资源进行统一运营，联动互动功能进行自动打标签，统计成员朋友圈执行效率功能等等</div>
      `
    )
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
