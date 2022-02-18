<script>
import ChartBar from '@/components/ChartBar'
import ChartLine from '@/components/ChartLine'
import SelectUser from '@/components/SelectUser'
import { getRealCnt, getRealCntMember } from '@/api/operateCenter/groupAnalysis'
import { getList as getGroupList } from '@/api/customer/group'
export default {
  name: '',
  components: { ChartLine, ChartBar, SelectUser },
  props: {
    type: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      loading: { customerGroup: false, customerGroupMember: false },
      timeRange: 7,
      // 日期范围
      dateRange: [],
      dialogVisible: false,
      dialogType: 'customerGroup',
      // 群聊
      groupChats: [],
      // 查询参数
      query: {
        chatIds: '',
        ownerIds: '',
        beginTime: undefined,
        endTime: undefined,
      },
      legend: {
        customerGroup: ['新增客群数', '解散客群数'],
        customerGroupMember: ['新增客群成员数', '流失客群成员数'],
      },
      // 选择人员
      selectUsers: {
        customerGroup: [],
        customerGroupMember: [],
      },
      customerGroup: {
        xData: [],
        series: [],
      },
      customerGroupMember: {
        xData: [],
        series: [],
      },
    }
  },
  computed: {},
  watch: {},
  created() {
    this.setTime(7)
  },
  mounted() {},
  methods: {
    getList(type) {
      this.query.beginTime = this.dateRange && this.dateRange[0]
      this.query.endTime = this.dateRange && this.dateRange[1]
      let selectUsers = this.selectUsers[type]
      if (Array.isArray(selectUsers)) {
        this.query.ownerIds = selectUsers.map((e) => e.userId).join(',')
      } else {
        this.query.ownerIds = ''
      }

      this.loading[type] = true
      let api = { customerGroup: getRealCnt, customerGroupMember: getRealCntMember }
      api[type](this.query)
        .then(({ rows }) => {
          this[type].series = []

          this[type].xData = rows.map((e) => e.xtime)
          this[type].series.push(rows.map((e) => e.addCnt))
          type === 'customerGroup' && this[type].series.push(rows.map((e) => e.dissolveCnt))
          type === 'customerGroupMember' && this[type].series.push(rows.map((e) => e.quitCnt))
        })
        .catch((error) => {
          console.error(error)
        })
        .finally(() => {
          this.loading[type] = false
        })
    },
    getGroupList(params) {
      getGroupList(params)
        .then(({ rows }) => {
          this.groupChats = rows
        })
        .catch((e) => {
          console.error(e)
        })
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      d.setMinutes(d.getMinutes() - d.getTimezoneOffset())
      return d.toJSON().substr(0, 10)
    },
    setTime(days) {
      this.timeRange = days
      if (days) {
        let date = new Date()
        date.setDate(date.getDate() - days)
        this.dateRange = [this.getTime(date), this.getTime()]
        this.getList('customerGroup')
        this.getList('customerGroupMember')
      } else {
        this.dateRange = null
      }
    },
    showDialog(type) {
      this.dialogType = type
      this.dialogVisible = true
    },
    getSelectUser(data) {
      this.selectUsers[this.dialogType] = data
      this.query[this.dialogType] = data.map((e) => e.name).join(',')
      if (this.dialogType === 'customerGroup') {
        this.getList(this.dialogType)
      } else {
        this.query.chatIds = ''
        this.getGroupList({
          groupLeaderName: this.query[this.dialogType],
        })
      }
    },
  },
}
</script>

<template>
  <div>
    <div class="operation">
      <el-button-group>
        <el-button size="small" type="primary" :plain="timeRange != 7" @click="setTime(7)"
          >近一周</el-button
        >
        <el-button size="small" type="primary" :plain="timeRange != 30" @click="setTime(30)"
          >近一月
        </el-button>
        <el-button size="small" type="primary" :plain="!!timeRange" @click="setTime()"
          >自定义
        </el-button>
      </el-button-group>
      <el-date-picker
        v-if="!timeRange"
        v-model="dateRange"
        size="small"
        class="ml20"
        style="width: 260px"
        value-format="yyyy-MM-dd"
        type="daterange"
        :clearable="false"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        @change="
          getList('customerGroup')
          getList('customerGroupMember')
        "
      ></el-date-picker>
    </div>
    <el-row :gutter="10">
      <el-col :span="12">
        <div>
          <el-input
            style="width: 180px"
            v-model="query.customerGroup"
            readonly
            @focus="showDialog('customerGroup')"
            placeholder="请选择群主"
          />
        </div>
        <ChartLine
          v-loading="loading.customerGroup"
          :xData="customerGroup.xData"
          :legend="legend['customerGroup']"
          :series="customerGroup.series"
        ></ChartLine>
      </el-col>
      <el-col :span="12">
        <div>
          <el-input
            style="width: 180px"
            v-model="query.customerGroupMember"
            readonly
            @focus="showDialog('customerGroupMember')"
            placeholder="请选择群主"
          />
          <el-select
            v-model="query.chatIds"
            placeholder="请选择群聊"
            clearable
            @change="getList('customerGroupMember')"
          >
            <el-option
              v-for="item in groupChats"
              :key="item.chatId"
              :label="item.groupName"
              :value="item.chatId"
            >
            </el-option>
          </el-select>
        </div>
        <ChartLine
          v-loading="loading.customerGroupMember"
          :xData="customerGroupMember.xData"
          :legend="legend['customerGroupMember']"
          :series="customerGroupMember.series"
        ></ChartLine>
      </el-col>
    </el-row>

    <SelectUser
      :visible.sync="dialogVisible"
      title="组织架构"
      :defaultValues="selectUsers[dialogType]"
      @success="getSelectUser"
      :isOnlyLeaf="true"
    ></SelectUser>
  </div>
</template>

<style lang="scss" scoped></style>
