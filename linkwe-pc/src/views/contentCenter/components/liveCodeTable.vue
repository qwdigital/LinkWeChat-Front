<template>
  <div>
    <!-- 二维码组件table -->
    <el-dialog
      :title="`添加${title}`"
      :visible.sync="Pvisible"
      width="70%"
      append-to-body
      destroy-on-close
      :before-close="handleClose"
    >
      <div v-if="loading || list.length !== 0">
        <el-table v-loading="loading" :data="list" @row-click="onRowClick">
          <el-table-column width="30">
            <template slot-scope="{ row }">
              <el-radio v-model="row.checked" :label="true"></el-radio>
            </template>
          </el-table-column>
          <!-- 员工活码 -->
          <template v-if="type === 'ygcode'">
            <el-table-column label="二维码" align="center" prop="qrCode" min-width="120">
              <template slot-scope="{ row }">
                <el-image
                  :src="row.qrCode"
                  fit="fit"
                  :preview-src-list="[row.qrCode]"
                  style="width: 100px; height: 100px"
                ></el-image>
              </template>
            </el-table-column>
            <el-table-column
              label="活码名称"
              align="center"
              min-width="100"
              prop="name"
              show-overflow-tooltip
            />
            <el-table-column
              label="活码分组"
              align="center"
              min-width="100"
              prop="qrGroupName"
              show-overflow-tooltip
            />
            <el-table-column
              label="使用员工"
              align="center"
              min-width="140"
              prop="qrUserInfos"
              show-overflow-tooltip
            >
              <template slot-scope="{ row }">
                <template>
                  <div v-for="(unit, key) in row.qrUserInfos" :key="key" style="display: inline">
                    <template v-for="(item, index) in unit.weQrUserList">
                      <span :key="index">{{ item.userName + ' ' }}</span>
                    </template>
                  </div>
                </template>
              </template>
            </el-table-column>
            <el-table-column label="标签" align="center" prop="qrTags" min-width="160px">
              <template slot-scope="{ row }">
                <div>
                  <template v-for="(data, key) in row.qrTags">
                    <el-tag v-if="key < 2 && data.tagName" :key="key" size="mini"
                      >{{ data.tagName }}
                    </el-tag>
                  </template>
                  <el-popover trigger="hover" width="200">
                    <template v-for="(unit, index) in row.qrTags">
                      <el-tag :key="index" v-if="index > 1 && unit.tagName" size="mini">
                        {{ unit.tagName }}</el-tag
                      >
                    </template>
                    <div style="display: inline" slot="reference">
                      <el-tag v-if="row.qrTags ? row.qrTags.length > 2 : false" size="mini"
                        >...</el-tag
                      >
                    </div>
                  </el-popover>
                </div>
              </template>
            </el-table-column>
            <!-- <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180">
            </el-table-column> -->
            <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180">
            </el-table-column>
          </template>
          <!-- 客群活码 -->
          <template v-else-if="type === 'kqcode'">
            <el-table-column prop="activityName" label="活码名称" align="center"></el-table-column>
            <el-table-column prop="codeUrl" label="二维码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <el-image
                    slot="reference"
                    :src="row.codeUrl"
                    class="code-image--small"
                  ></el-image>
                  <el-image :src="row.codeUrl" class="code-image"> </el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column label="客群标签" width="180px">
              <template #default="{ row }">
                <div>
                  <tag-ellipsis
                    limit="2"
                    :list="row.tags ? row.tags.split(',') : []"
                  ></tag-ellipsis>
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
                <a style="color: #0079de; text-decoration: underline" @click="getDetail(row.id)">{{
                  row.chatGroupNum
                }}</a>
              </template>
            </el-table-column>
            <el-table-column
              prop="chatGroupMemberTotalNum"
              width="120px"
              label="群总人数"
              align="center"
            >
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
            <el-table-column
              prop="joinChatGroupTotalMemberNum"
              width="120px"
              label="进群人数"
              align="center"
            >
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
            <el-table-column
              prop="exitChatGroupTotalMemberNum"
              width="120px"
              label="退群人数"
              align="center"
            >
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
            <el-table-column
              prop="updateTime"
              label="最近操作时间"
              align="center"
              width="150"
            ></el-table-column>
          </template>
          <!-- 识客活码 -->
          <template v-else-if="type === 'skcode'">
            <el-table-column
              prop="knowCustomerName"
              label="识客码名称"
              align="center"
            ></el-table-column>
            <el-table-column prop="knowCustomerQr" label="二维码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <el-image
                    slot="reference"
                    :src="row.knowCustomerQr"
                    class="code-image--small"
                  ></el-image>
                  <el-image :src="row.knowCustomerQr" class="code-image"> </el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column
              prop="tdScanCodeNumber"
              width="120px"
              label="今日扫码次数"
              align="center"
            ></el-table-column>
            <el-table-column
              prop="totalScanCodeNumber"
              width="120px"
              label="总扫码次数"
              align="center"
            ></el-table-column>
            <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
            <el-table-column
              prop="updateTime"
              label="操作时间"
              align="center"
              width="160"
            ></el-table-column>
          </template>
          <!-- 拉新活码 -->
          <template v-else-if="type === 'lxcode'">
            <el-table-column prop="codeName" label="活码名称" align="center"></el-table-column>
            <el-table-column label="活码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <el-image
                    slot="reference"
                    :src="row.emplCodeUrl"
                    class="code-image--small"
                  ></el-image>
                  <el-image :src="row.emplCodeUrl" class="code-image"></el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column prop="emplList" label="使用员工" align="center">
              <template #default="{ row }">
                <el-popover
                  v-if="row.emplList"
                  placement="bottom"
                  trigger="hover"
                  :content="row.emplList.map((d) => d.businessName).join()"
                >
                  <div slot="reference" class="table-desc toe">
                    <!-- {{ getDisplayRealGroups(row) }} -->
                    {{ row.emplList.map((d) => d.businessName).join() }}
                  </div>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column label="客户标签" align="center">
              <div v-if="row.tagList" slot-scope="{ row }">
                <TagEllipsis :list="row.tagList" defaultProps="tagName"></TagEllipsis>
              </div>
              <span v-else>无标签</span>
            </el-table-column>
            <el-table-column label="实际群聊" align="center">
              <div v-if="row.actualGroupName" slot-scope="{ row }">
                <el-popover placement="bottom" trigger="hover" :disabled="row.tagList.length < 3">
                  <div>
                    <el-tag
                      type="primary"
                      v-for="(unit, unique) in row.actualGroupName.split(',')"
                      :key="unique"
                    >
                      {{ unit }}
                    </el-tag>
                  </div>
                  <div slot="reference">
                    <el-tag
                      type="primary"
                      v-for="(unit, unique) in row.actualGroupName.split(',').slice(0, 2)"
                      :key="unique"
                    >
                      {{ unit }}
                    </el-tag>
                    <el-tag type="primary" key="a" v-if="row.tagList.length > 2">...</el-tag>
                  </div>
                </el-popover>
              </div>
              <span v-else>无群聊</span>
            </el-table-column>
            <el-table-column
              label="添加好友数"
              align="center"
              prop="cusNumber"
              width="100"
            ></el-table-column>
            <el-table-column label="创建人" align="center" prop="createBy"></el-table-column>
            <el-table-column
              label="创建时间"
              align="center"
              prop="createTime"
              width="160"
            ></el-table-column>
          </template>
        </el-table>
        <pagination
          :total="total"
          :page.sync="query.pageNum"
          :limit.sync="query.pageSize"
          @pagination="getList()"
        />
      </div>

      <div class="empty" v-else-if="!loading && list.length === 0">
        <div class="tips">暂无{{ title }}，点击下方按钮立即创建</div>
        <el-button type="primary" @click="goAdd">去创建</el-button>
      </div>
      <div slot="footer">
        <el-button @click="Pvisible = false">取 消</el-button>
        <el-button type="primary" @click="submit(list.length)">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="当前客群" :visible.sync="detailDialog" append-to-body width="70%">
      <el-table v-loading="tabLoading" :data="tableList" style="width: 100%">
        <el-table-column
          label="客群名称"
          align="center"
          min-width="100"
          prop="groupName"
          show-overflow-tooltip
        />
        <el-table-column
          label="群主"
          align="center"
          min-width="100"
          prop="groupOwner"
          show-overflow-tooltip
        />
        <el-table-column
          label="群总人数"
          align="center"
          prop="chatGroupMemberTotalNum"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          label="进群人数"
          align="center"
          prop="joinChatGroupTotalMemberNum"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column>
        <el-table-column
          label="退群人数"
          align="center"
          prop="exitChatGroupTotalMemberNum"
          min-width="100"
          show-overflow-tooltip
        ></el-table-column>
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
              "
              >查看详情</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <div slot="footer">
        <el-button @click="detailDialog = false">取 消</el-button>
        <el-button type="primary" @click="detailDialog = false">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getList as getEmployeeList } from '@/api/drainageCode/staff'
import { getList, getTableTotal } from '@/api/drainageCode/group'
import { getList as identificationList } from '@/api/drainageCode/identity'
import { getList as pullNewList } from '@/api/communityOperating/newCustomer'

export default {
  props: {
    // 添加标签显隐
    twoVisible: {
      type: Boolean,
      default: false,
    },
    type: {
      type: String,
      default: 'ygcode',
    },
  },
  watch: {
    type: {
      handler(val) {
        this.getList()
      },
    },
  },
  data() {
    return {
      loading: false,
      tabLoading: false,
      list: [],
      query: {
        pageNum: 1,
        pageSize: 10,
      }, // 员工活码
      total: 0,
      liveCodeUrl: null,
      detailDialog: false,
      tableList: [],
    }
  },
  computed: {
    title() {
      const titleMap = {
        ygcode: '员工活码',
        kqcode: '客群活码',
        mdcoed: '门店活码',
        skcode: '识客活码',
        lxcode: '拉新活码',
      }
      return titleMap[this.type]
    },
    Pvisible: {
      get() {
        return this.twoVisible
      },
      set(val) {
        this.$emit('update:twoVisible', val)
      },
    },
  },
  created() {
    this.getList()
  },
  methods: {
    handleClose() {
      this.Pvisible = false
      // this.list.forEach((i) => (i.checked = false))
      this.list = []
    },
    getDetail(id) {
      this.detailDialog = true
      this.tabLoading = true
      getTableTotal(id).then((res) => {
        this.tableList = res.data
        this.tabLoading = false
      })
    },
    submit(length) {
      if (length) {
        if (this.liveCodeUrl === null) {
          this.$message.error('请选择活码')
        } else {
          this.$emit('selectLiveCode', this.liveCodeUrl)
          // this.list.forEach((i) => (i.checked = false))
          this.Pvisible = false
          this.list = []
        }
      } else {
        this.Pvisible = false
      }
    },
    getList() {
      this.loading = true
      let obj = {
        ygcode: getEmployeeList,
        kqcode: getList,
        // mdcoed: storeList,
        skcode: identificationList,
        lxcode: pullNewList,
      }
      if (this.type === 'ygcode') {
        // this.query = {
        //   pageNum: 1,
        //   pageSize: 10,
        //   orderByColumn: 'wqc.update_time',
        //   isAsc: 'desc',
        // }
        this.query.orderByColumn = 'wqc.update_time'
        this.query.isAsc = 'desc'
      } else {
        delete this.query.orderByColumn
        delete this.query.isAsc
        // this.query = {
        //   pageNum: 1,
        //   pageSize: 10,
        // }
      }
      obj[this.type](this.query)
        .then(({ rows, total }) => {
          this.list = rows.map((i) => {
            i.checked = false
            return i
          })
          this.total = Number(total)
          this.loading = false
        })
        .catch(() => {
          this.loading = false
        })
    },
    goAdd() {
      let router = {
        ygcode: 'Staff',
        kqcode: 'CustomerGroup',
        mdcoed: 'Store',
        skcode: 'Identity',
        lxcode: 'NewCustomer',
      }
      this.$router.push({ name: router[this.type] })
    },
    onRowClick(row, column, event) {
      const evTarget = event.target.nodeName.toUpperCase(0)
      if (evTarget == 'INPUT') {
        return
      }
      const checked = row.checked
      if (!checked) {
        this.list.forEach((i) => (i.checked = false))
      }
      row.checked = !checked
      let obj = {
        ygcode: 'qrCode',
        kqcode: 'codeUrl',
        // mdcoed:'',
        skcode: 'knowCustomerQr',
        lxcode: 'emplCodeUrl',
      }
      this.liveCodeUrl = row.checked ? row[obj[this.type]] : null
    },
  },
}
</script>

<style lang="scss" scoped>
.empty {
  width: 30%;
  margin: 30px auto;
  text-align: center;
  .tips {
    color: #aaa;
    font-size: 12px;
    line-height: 60px;
  }
}
</style>
