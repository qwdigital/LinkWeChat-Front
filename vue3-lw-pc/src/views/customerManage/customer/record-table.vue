<script>
import { getRecordList } from '@/api/customer'
import { dictTrackState } from '@/utils/dictionary'
import { dateFormat } from '@/utils'
export default {
  name: 'record-table',
  props: {
    stageList: {
      type: Array,
      default: [],
    },
    // 当前跟进人id
    userId: {
      type: String,
      default: null,
    },
    // 所有跟进人id（用于客户画像汇总的同步）
    userIdAll: {
      type: String,
      default: null,
    },
    // 1:客户动态;2:员工动态;3:互动动态;4:跟进动态
    trajectoryType: {
      type: String,
      default: null,
    },
  },
  components: {},
  data() {
    return {
      query: {
        pageNum: 0,
        pageSize: 10,
        externalUserid: '', //	是	当前客户id
        userId: null, //		当前跟进人id,
        trajectoryType: null, //	1:客户动态;2:员工动态;3:互动动态;4:跟进动态
      },
      loading: false,
      total: 0,
      list: [], // 列表
      dictTrackState,
      dateFormat,
      goto: true,
      stage: [],
    }
  },
  computed: {},
  watch: {
    stageList: {
      deep: true,
      immediate: true,
      handler(val) {
        if (val) {
          this.stage = val
        }
      },
    },
  },
  created() {
    this.getList(1)
  },
  mounted() {},
  methods: {
    /** 查询 */
    getList(page) {
      Object.assign(this.query, {
        externalUserid: this.$route.query.externalUserid,
        weUserId: this.userId,
      })
      page && (this.query.pageNum = page)
      this.loading = true
      getRecordList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    setValue(data) {
      let str = ''
      this.stage.forEach((dd) => {
        if (dd.stageVal == data) {
          str = dd.stageKey
        }
      })
      return str
    },
  },
}
</script>

<template>
  <div v-loading="loading">
    <el-table :data="list">
      <el-table-column label="员工" align="center" prop="createBy" />
      <el-table-column label="跟进记录" align="center" prop="trackContent" />
      <el-table-column prop="trackState" label="商机阶段" align="center">
        <template #default="{ row }">
          <!-- <el-tag v-if="row.trackState" :type="dictTrackState[~~row.trackState + ''].color">
              {{ dictTrackState[~~row.trackState + ''].name }}
            </el-tag> -->
          <el-tag v-if="row.trackState">
            {{ setValue(row.trackState) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="跟进记录时间" align="center" prop="createTime" />
    </el-table>

    <div class="ac">
      <el-pagination
        class="mt10"
        small
        hide-on-single-page
        @current-change="getList"
        :current-page="query.pageNum"
        :page-sizes="[10, 20, 50]"
        :page-size="query.pageSize"
        layout="total, prev, pager, next"
        :total="total"></el-pagination>
    </div>
  </div>
</template>

<style lang="scss" scoped>
// .timeline-time-wrap {
// }
.infinite-list-item {
  border-bottom: 1px solid var(--border-black-9);
  &:last-child {
    border: 0;
  }
}
.timeline-time {
  font-size: 14px;
  color: var(--font-black-6);
  line-height: 48px;
}
.el-timeline > .timeline-box-item:first-child ::v-deep .el-timeline-item__node {
  border-radius: 0 !important;
}
.timeline-box {
  padding-left: 70px;
  &-item {
    ::v-deep .el-timeline-item__timestamp {
      position: absolute;
      top: 4px;
      left: -45px;
      margin: 0;
    }

    &-title {
      font-weight: 700;
      line-height: 25px;
    }
  }
}

::v-deep .el-timeline-item__tail {
  border-left-color: var(--color);
}
</style>
