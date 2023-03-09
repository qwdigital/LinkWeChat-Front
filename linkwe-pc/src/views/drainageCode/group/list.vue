<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left" label-width="">
      <el-form-item label="活码名称" prop="activityName">
        <el-input clearable v-model="query.activityName" placeholder="请输入活码名称"></el-input>
      </el-form-item>
      <el-form-item label="客群标签" prop="tagIds">
        <el-input :value="tagNames" readonly @focus="showSelectTag = true" placeholder="请选择客群标签" />
      </el-form-item>
      <!-- <el-form-item label="创建人" prop="createBy">
        <el-input v-model="query.createBy" placeholder="请输入创建人"></el-input>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker v-model="searchDate" format="yyyy-MM-dd" value-format="yyyyMMdd" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item> -->
      <el-form-item label="">
        <el-button type="primary" @click="handleSearch">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="$router.push('./groupAdd')">新建活码</el-button>
        <div>
          <el-button type="primary" plain :disabled="multiGroupCode.length === 0" @click="handleBulkDownload">
            批量下载
          </el-button>
          <el-button type="primary" plain :disabled="multiGroupCode.length === 0" @click="handleBulkRemove">
            批量删除
          </el-button>
        </div>
      </div>
      <el-table :data="groupCodes" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="activityName" label="活码名称" align="center"></el-table-column>
        <el-table-column prop="codeUrl" label="二维码" align="center" width="130">
          <template #default="{ row }">
            <el-popover placement="bottom" trigger="hover">
              <el-image slot="reference" :src="row.codeUrl" class="code-image--small"></el-image>
              <el-image :src="row.codeUrl" class="code-image"></el-image>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="客群标签" width="180px">
          <template #default="{ row }">
            <div>
              <tag-ellipsis limit="2" :list="row.tags.split(',')"></tag-ellipsis>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="活码客群数" align="center" width="120px" prop="chatGroupNum">
          <template slot="header">
            <el-popover placement="top" trigger="hover">
              <div slot="reference">
                活码客群数
                <i class="el-icon-question"></i>
              </div>
              <div>当前群活码所有群聊数量，包括自动建立的群</div>
            </el-popover>
          </template>
          <template #default="{ row }">
            <a style="color: var(--color); text-decoration: underline" @click="getDetail(row.id)">
              {{ row.chatGroupNum }}
            </a>
          </template>
        </el-table-column>
        <el-table-column prop="chatGroupMemberTotalNum" width="120px" label="群总人数" align="center">
          <template slot="header">
            <el-popover placement="top" trigger="hover">
              <div slot="reference">
                群总人数
                <i class="el-icon-question"></i>
              </div>
              <div>当前群活码全部群的总人数（含员工及重复）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="joinChatGroupTotalMemberNum" width="120px" label="进群人数" align="center">
          <template slot="header">
            <el-popover placement="top" trigger="hover">
              <div slot="reference">
                进群人数
                <i class="el-icon-question"></i>
              </div>
              <div>通过当前群活码进群的人数（去重）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="exitChatGroupTotalMemberNum" width="120px" label="退群人数" align="center">
          <template slot="header">
            <el-popover placement="top" trigger="hover">
              <div slot="reference">
                退群人数
                <i class="el-icon-question"></i>
              </div>
              <div>通过当前群活码进群后退群的人数（去重）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
        <el-table-column prop="updateTime" label="最近操作时间" align="center" width="150"></el-table-column>
        <el-table-column label="操作" align="center" width="180" fixed="right">
          <template #default="{ row }">
            <el-button
              type="text"
              size="mini"
              @click="
                $router.push({
                  path: 'analyse',
                  query: { id: row.state, groupId: row.id },
                })
              ">
              统计
            </el-button>
            <el-button type="text" @click="handleDownload(row.id, row.activityName)">下载</el-button>
            <el-button type="text" class="copy-btn" :data-clipboard-text="row.codeUrl">复制</el-button>
            <el-dropdown style="margin-left: 10px">
              <el-button type="text">
                <i class="el-icon-more"></i>
              </el-button>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item>
                  <el-button
                    type="text"
                    size="mini"
                    @click="
                      $router.push({
                        path: 'groupAdd',
                        query: {
                          groupCodeId: row.id,
                          obj: encodeURIComponent(JSON.stringify(row)),
                        },
                      })
                    ">
                    编辑
                  </el-button>
                </el-dropdown-item>
                <el-dropdown-item>
                  <el-button type="text" @click="handleRemove(row.id)">删除</el-button>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="query.pageNum"
        :limit.sync="query.pageSize"
        @pagination="getGroupCodes" />
      <el-dialog v-if="realCodeDialog" title="实际群码" :visible.sync="realCodeDialog" append-to-body width="70%">
        <RealCode ref="realCode" :groupCodeId="openGroupCodeId" :status="openGroupCodeStatus"></RealCode>
      </el-dialog>
      <select-tag :visible.sync="showSelectTag" type="2" :selected="tagList" @success="getSelectTag"></select-tag>
      <el-dialog title="当前客群" :visible.sync="detailDialog" append-to-body width="70%">
        <el-table v-loading="loading" :data="tableList" style="width: 100%">
          <el-table-column label="客群名称" align="center" min-width="100" prop="groupName" show-overflow-tooltip />
          <el-table-column label="群主" align="center" min-width="100" prop="groupOwner" show-overflow-tooltip />
          <el-table-column
            label="群总人数"
            align="center"
            prop="chatGroupMemberTotalNum"
            min-width="100"
            show-overflow-tooltip></el-table-column>
          <el-table-column
            label="进群人数"
            align="center"
            prop="joinChatGroupTotalMemberNum"
            min-width="100"
            show-overflow-tooltip></el-table-column>
          <el-table-column
            label="退群人数"
            align="center"
            prop="exitChatGroupTotalMemberNum"
            min-width="100"
            show-overflow-tooltip></el-table-column>
          <el-table-column label="操作" align="center" width="180">
            <template #default="{ row }">
              <el-button
                type="text"
                size="mini"
                @click="
                  $router.push({
                    path: '/groupManage/customerGroupManage/groupDetail',
                    query: {
                      chatId: row.chatId,
                    },
                  })
                ">
                查看详情
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <div slot="footer">
          <el-button @click="detailDialog = false">取 消</el-button>
          <el-button type="primary" @click="detailDialog = false">确 定</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import RealCode from './realCode'
import { getList, remove, downloadBatch, download, getTableTotal } from '@/api/drainageCode/group'

import ShowTag from '@/components/common/ShowTag.vue'
import SelectTag from '@/components/SelectTag.vue'
export default {
  components: { RealCode, ShowTag, SelectTag },
  data() {
    return {
      query: {
        pageNum: 1,
        pageSize: 10,
        activityName: '',
        tagIds: '',
      },
      tagNames: '',
      loading: false,
      searchDate: '', // 查询日期
      multiGroupCode: [], // 多选数据
      groupCodes: [], // 群活码数据
      total: 0, // 总数据量
      realCodeDialog: false, // 实际群码总数dialog
      openGroupCodeId: null, // 打开实际群码关联的群活码ID
      openGroupCodeStatus: -1, // 打开实际群码的检索状态
      clipboard: null, // 拷贝对象
      showSelectTag: false,
      tagList: [],
      tagIndex: 1,
      tableList: [],
      loading: false,
      detailDialog: false,
    }
  },
  watch: {
    searchDate(dateRange) {
      if (!dateRange || dateRange.length !== 2) {
        this.query.beginTime = ''
        this.query.endTime = ''
      } else {
        ;[this.query.beginTime, this.query.endTime] = dateRange
      }
    },
    // 如果实际群码弹出框关闭,刷新数据
    realCodeDialog(val) {
      if (val === false) this.getGroupCodes()
    },
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  created() {
    this.getGroupCodes()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>生成永久二维码，根据规则自动切换企微客群，支持群满自动建群</div>
      `,
    )
  },
  destroyed() {
    this.clipboard.destroy()
  },
  methods: {
    getDetail(id) {
      this.detailDialog = true
      this.loading = true
      getTableTotal(id).then((res) => {
        this.tableList = res.data
        this.loading = false
      })
    },
    getSelectTag(list) {
      this.taglist = list
      let arr = []
      let arr1 = []
      list.forEach((dd) => {
        arr.push(dd.name)
        arr1.push(dd.tagId)
      })
      this.tagNames = arr.join(',')
      this.query.tagIds = arr1.join(',')
    },
    // 获取活码数据
    getGroupCodes() {
      const params = Object.assign({}, this.query)
      this.loading = true
      getList(params)
        .then((res) => {
          if (res.code === 200) {
            this.groupCodes = res.rows
            this.total = parseInt(res.total)
          }
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    // 查询
    handleSearch() {
      this.getGroupCodes()
    },
    // 搜索栏清空
    resetQuery() {
      this.$refs['queryForm'].resetFields()
      this.tagNames = ''
      this.tagList = []
      this.$nextTick(() => {
        this.getGroupCodes()
      })
    },
    // 批量下载
    handleBulkDownload() {
      const ids = this.multiGroupCode.map((group) => group.id)
      this.$confirm('是否确认下载所有图片吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return downloadBatch(ids + '')
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], { type: 'application/zip' })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '批量群活码.zip' // 重命名文件
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
        })
        .catch(function () {})
    },
    // 批量删除
    handleBulkRemove() {
      this.$confirm('确认删除当前群活码?删除操作无法撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          const ids = this.multiGroupCode.map((group) => group.id)
          remove(ids + '').then((res) => {
            if (res.code === 200) {
              this.getGroupCodes()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    // 下载
    handleDownload(codeId, activityName) {
      const name = activityName + '.png'
      download(codeId).then((res) => {
        if (res != null) {
          let blob = new Blob([res], { type: 'application/zip' })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = name // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    // 删除
    handleRemove(codeId) {
      this.$confirm('确认删除当前群活码?删除操作无法撤销，请谨慎操作。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          remove(codeId).then((res) => {
            if (res.code === 200) {
              this.getGroupCodes()
            } else {
            }
          })
        })
        .catch(() => {})
    },
    // 处理多选
    handleSelectionChange(val) {
      this.multiGroupCode = val
    },
    // 打开实际群码窗口
    handleRealCodeDialogOpen(groupCodeId, status) {
      this.openGroupCodeId = groupCodeId
      this.openGroupCodeStatus = status
      this.realCodeDialog = true
    },
  },
}
</script>

<style scoped lang="scss">
.overflow-ellipsis {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.table-desc {
  max-width: 150px;
}
.code-image {
  width: 200px;
  height: 200px;
}
.code-image--small {
  width: 50px;
  height: 50px;
}
.expire-icon {
  color: red;
}
</style>
