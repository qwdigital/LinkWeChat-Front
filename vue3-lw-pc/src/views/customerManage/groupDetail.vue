<script>
import { dictJoinGroupType } from '@/utils/dictionary'
import * as api from '@/api/customer/group'

export default {
  // name: 'GroupDetail',
  components: {},
  data() {
    return {
      // 遮罩层
      loading: false,
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // 总条数
      total: 0,
      // 表格数据
      list: [],
      // 群信息
      group: {},
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        chatId: undefined,
        name: undefined,
        delFlag: 0,
      },
      dictJoinGroupType,
      dialogVisible: false,
      selectedTag: [],
      tagDialogType: {},
    }
  },
  created() {
    this.query.chatId = this.$route.query.chatId
    this.getDetail()
    this.getList()
  },
  methods: {
    getDetail() {
      api.getDetail(this.query.chatId).then(({ data }) => {
        // this.group = Object.assign({}, this.group, res.data)
        // console.log(this.group)
        // this.group.createTime = moment(this.group.createTime).format('YYYY-MM-DD HH:mm:ss')
        if (data.tagIds) {
          data.tagIds = data.tagIds.split(',')
          data.tags = data.tags.split(',')
        }
        this.group = data
      })
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = false
      api.getMembers(this.query).then((response) => {
        this.list = response.rows
        this.total = +response.total
        this.loading = false
      })
    },
    resetForm(formName) {
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.operId)
      this.multiple = !selection.length
    },
    makeTag() {
      let data = this.group
      this.tagDialogType.type = ''
      let curTags = []
      if (data.tags && data.tagIds) {
        curTags = data.tags.map((i, idx) => ({
          name: i,
          tagName: i,
          tagId: data.tagIds[idx],
        }))
      }
      this.selectedTag = curTags
      this.dialogVisible = true
    },
    submitSelectTag(data) {
      this.loading = true
      api
        .makeGroupTag({
          chatId: this.query.chatId,
          tagIds: data.map((row) => {
            return row.tagId
          }),
        })
        .then((res) => {
          if (res.code == 200) {
            this.loading = false
            this.getDetail()
            this.msgSuccess('操作成功')
          }
        })
        .finally(() => {
          this.loading = false
          this.dialogVisible = false
        })
    },
  },
}
</script>

<template>
  <div v-loading="loading">
    <!-- <el-button slot="append" circle icon="el-icon-back" @click="$router.back()"></el-button>返回 -->
    <div class="flex">
      <div class="left g-card">
        <div class="flex aic">
          <el-avatar
            :size="50"
            style="flex: none"
            src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"></el-avatar>
          <div class="info-wrap">
            <div style="margin-bottom: 15px; font-weight: 500">
              {{ group.groupName }}
            </div>
            <div class="info">
              <span class="">创建时间：</span>
              {{ group.createTime }}
            </div>
            <div class="info" style="flex: 1">
              <span class="">客群标签：</span>
              <div style="display: inline-block">
                <template v-if="group.tags">
                  <TagEllipsis :list="group.tags" limit="8"></TagEllipsis>
                </template>
              </div>
              <el-button text class="ml10" v-hasPermi="['customerManage/customer:makeTag']" @click="makeTag()">
                编辑标签
              </el-button>
            </div>
          </div>
        </div>

        <div class="flex aic ac overview">
          <div>
            <div class="value">
              {{ group.groupLeaderName }}
            </div>
            <div class="key">群主</div>
          </div>
          <span class="line"></span>
          <div>
            <div class="value">
              {{ group.memberNum || 0 }}
            </div>
            <div class="key">群总人数</div>
          </div>
          <span class="line"></span>
          <div>
            <div class="value">
              {{ group.customerNum || 0 }}
            </div>
            <div class="key">客户总数</div>
          </div>
          <span class="line"></span>
          <div>
            <div class="value">
              {{ group.toDayMemberNum || 0 }}
            </div>
            <div class="key">今日进群数</div>
          </div>
        </div>
      </div>

      <div class="g-card right" style="margin: 0 0 0 var(--card-margin)">
        <div class="g-title g-title-sub">群公告</div>
        <div style="padding: 0 20px 20px">
          {{ group.notice || '未设置' }}
          <!-- 为更好的服务广大客户，我司将于2021年5月9日晚22:00至22:30进行系统升级维护。敬请您妥善安排业务办理时间。由此给您带来的不便，我们深表歉意，并将尽快恢复对您的服务，衷心感谢您对我行的理解和支持！ -->
        </div>
      </div>
    </div>

    <el-form ref="queryForm" :inline="true" :model="query" label-width="70px" class="top-search mt20">
      <el-form-item label="成员名称" prop="name">
        <el-input v-model="query.name" placeholder="请输入" clearable></el-input>
      </el-form-item>
      <el-form-item label="">
        <el-button style="margin-left: 10px" type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetForm()">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <el-table :data="list" @selection-change="handleSelectionChange">
        <el-table-column width="55" />
        <el-table-column label="群成员" prop="name">
          <template #default="scope">
            {{ scope.row.name }}
            <!-- <span
            :style="{color: scope.row.joinType == 1 ? '#4bde03' : '#f9a90b'}"
          >{{ ({1: '@微信', 2: '@企业微信'})[scope.row.joinType] }}</span>-->
            <!-- <el-icon-Avatar :class="['el-icon-Avatar', ({1: 'man', 2: 'woman'})[scope.row.gender]]"/> -->
          </template>
        </el-table-column>
        <el-table-column label="进群时间" prop="joinTime"></el-table-column>
        <el-table-column label="进群方式" prop="joinScene">
          <template #default="scope">
            <span>{{ dictJoinGroupType[scope.row.joinScene] }}</span>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getList()" />
    </div>

    <!-- 选择标签弹窗 -->
    <SelectTag
      ref="selectTag"
      type="2"
      v-model:visible="dialogVisible"
      :title="tagDialogType.title"
      :selected="selectedTag"
      @success="submitSelectTag"></SelectTag>
  </div>
</template>

<style lang="scss" scoped>
.info-wrap {
  margin-left: 20px;
  .info {
    color: var(--font-black-4);
  }
}
.overview {
  justify-content: space-around;
  line-height: 30px;
  .key {
    color: var(--font-black-6);
  }
  .value {
    color: var(--font-black);
    font-weight: 600;
    font-size: 16px;
  }
  .line {
    width: 1px;
    height: 30px;
    background: var(--bg-black-8);
  }
}
.left {
  width: 70%;
}
.right {
  width: 30%;
}
</style>
