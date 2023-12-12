<template>
  <div>
    <RequestChartTable ref="table" :request="getList">
      <template #query="{ query }">
        <el-form-item label="活码名称" prop="activityName">
          <el-input clearable v-model="query.activityName" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item label="入群标签" prop="tagIds">
          <el-input :model-value="tagNames" readonly @click="showSelectTag = true" placeholder="请选择" />
        </el-form-item>
        <!-- <      label="创建人" prop="createBy">
        <el-input v-model="query.createBy" placeholder="请输入"></el-input>
      </>
      <el-form-item label="创建时间">
        <el-date-picker v-model="searchDate" format="YYYY-MM-DD" value-format="YYYYMMDD" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item> -->
      </template>

      <template #operation="{ selectedIds }">
        <div class="mid-action mb0">
          <el-button type="primary" @click="$router.push('./add')">新建活码</el-button>
          <div>
            <el-button
              type="primary"
              plain
              :disabled="!selectedIds?.length"
              @click="$refs.table?.download(downloadBatch, '批量群活码.zip', '确认下载所有图片吗?')">
              批量下载
            </el-button>
            <el-button type="primary" plain :disabled="!selectedIds?.length" @click="$refs.table?.remove(remove)">
              批量删除
            </el-button>
          </div>
        </div>
      </template>

      <template #table="{ data }">
        <el-table-column prop="activityName" label="活码名称" align="center"></el-table-column>
        <el-table-column prop="codeUrl" label="二维码" align="center" width="130">
          <template #default="{ row }">
            <el-popover placement="bottom" trigger="hover">
              <template #reference><el-image :src="row.codeUrl" class="code-image--small"></el-image></template>
              <el-image :src="row.codeUrl" class="code-image"></el-image>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="入群标签" width="180px">
          <template #default="{ row }">
            <TagEllipsis :list="row.tags?.split(',')" emptyText></TagEllipsis>
          </template>
        </el-table-column>
        <el-table-column label="活码客群数" align="center" width="120px" prop="chatGroupNum">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  活码客群数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
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
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  群总人数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>当前群活码全部群的总人数（含员工及重复）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="joinChatGroupTotalMemberNum" width="120px" label="进群人数" align="center">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  进群人数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>通过当前群活码进群的人数（去重）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="exitChatGroupTotalMemberNum" width="120px" label="退群人数" align="center">
          <template #header>
            <el-popover placement="top" trigger="hover">
              <template #reference>
                <div>
                  退群人数
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </div>
              </template>
              <div>通过当前群活码进群后退群的人数（去重）</div>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
        <el-table-column prop="updateTime" label="最近操作时间" align="center" width="150"></el-table-column>
        <el-table-column label="操作" align="center" width="220" fixed="right">
          <template #default="{ row }">
            <!-- <el-button
              text
              @click="
                $router.push({
                  path: 'analyse',
                  query: { id: row.state, groupId: row.id },
                })
              ">
              统计
            </el-button> -->
            <el-button
              text
              @click="
                $router.push({
                  path: 'detail',
                  query: {
                    id: row.id,
                    state: row.state,
                    obj: encodeURIComponent(JSON.stringify(row)),
                  },
                })
              ">
              详情|统计
            </el-button>
            <el-button
              text
              @click="
                $router.push({
                  path: 'add',
                  query: {
                    id: row.id,
                    obj: encodeURIComponent(JSON.stringify(row)),
                  },
                })
              ">
              编辑
            </el-button>
            <el-button
              text
              @click="
                ;(share.visible = true), (row.qrCode = row.codeUrl), (row.name = row.activityName)((share.data = row))
              ">
              分享
            </el-button>
            <el-button text @click="$refs.table?.remove(remove, row.id)">删除</el-button>

            <!-- <el-dropdown style="margin-left: 10px">
              <el-button text>
                <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item>
                    <el-button
                      text
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
                    <el-button text @click="$refs.table?.remove(() => remove(row.id))">删除</el-button>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown> -->
          </template>
        </el-table-column>
      </template>
    </RequestChartTable>

    <!-- <el-dialog v-if="realCodeDialog" title="实际群码" v-model="realCodeDialog" append-to-body width="70%">
        <RealCode ref="realCode" :groupCodeId="openGroupCodeId" :status="openGroupCodeStatus"></RealCode>
      </el-dialog> -->
    <select-tag v-model:visible="showSelectTag" type="1" :selected="tagList" @success="getSelectTag"></select-tag>

    <el-dialog title="当前客群" v-model="detailDialog" append-to-body width="70%">
      <el-table v-loading="loading" :data="tableList" style="width: 100%">
        <el-table-column label="客群名称" align="center" min-width="100" prop="groupName" show-overflow-tooltip />
        <el-table-column label="关联状态">
          <template #default="{ row }">
            {{ row.status == 0 ? '未关联' : row.status == 1 ? '已关联' : '' }}
          </template>
        </el-table-column>
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
              text
              @click="
                $router.push({
                  path: '/groupManage/customerGroupManage/group/groupDetail',
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
      <template #footer>
        <div>
          <el-button @click="detailDialog = false">取 消</el-button>
          <el-button type="primary" @click="detailDialog = false">确 定</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 分享活码 -->
    <el-dialog title="分享活码" v-model="share.visible" width="666px">
      <div style="background: var(--bg-black-8); padding: var(--card-margin); border-radius: var(--border-radius-big)">
        <CodeLink :data="share.data" />
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getList, remove, downloadBatch, download, getTableTotal } from '@/api/drainageCode/group'

export default {
  components: {
    // RealCode: defineAsyncComponent(() => import('./components/RealCode')),
    CodeLink: defineAsyncComponent(() => import('../components/CodeLink')),
  },
  data() {
    return {
      getList,
      remove,
      downloadBatch,
      query: {
        pageNum: 1,
        pageSize: 10,
        activityName: '',
        tagIds: '',
      },
      tagNames: '',
      loading: false,
      searchDate: '', // 查询日期
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
      share: {},
    }
  },
  watch: {
    searchDate: {
      deep: true,
      handler(dateRange) {
        if (!dateRange || dateRange.length !== 2) {
          this.query.beginTime = ''
          this.query.endTime = ''
        } else {
          ;[this.query.beginTime, this.query.endTime] = dateRange
        }
      },
    },
    // 如果实际群码弹出框关闭,刷新数据
    realCodeDialog(val) {
      if (val === false) this.$refs.table?.getList()
    },
  },
  mounted() {},
  created() {
    this.$store.setBusininessDesc(
      `
        <div>生成永久二维码，根据规则自动切换企微客群，支持群满自动建群</div>
      `,
    )
  },
  unmounted() {},
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
    // 打开实际群码窗口
    // handleRealCodeDialogOpen(groupCodeId, status) {
    //   this.openGroupCodeId = groupCodeId
    //   this.openGroupCodeStatus = status
    //   this.realCodeDialog = true
    // },
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
