<template>
  <div>
    <!-- 二维码组件table -->
    <el-dialog
      :title="`添加${title}`"
      v-model="Pvisible"
      width="70%"
      append-to-body
      destroy-on-close
      :before-close="handleClose">
      <div v-if="loading || list.length !== 0">
        <el-table v-loading="loading" :data="list" @row-click="onRowClick">
          <el-table-column width="30">
            <template #default="{ row }">
              <el-radio v-model="row.checked" :label="true"></el-radio>
            </template>
          </el-table-column>
          <!-- 员工活码 -->
          <template v-if="type === 'ygcode'">
            <el-table-column label="二维码" align="center" prop="qrCode" min-width="120">
              <template #default="{ row }">
                <el-image
                  :src="row.qrCode"
                  fit="fill"
                  :preview-src-list="[row.qrCode]"
                  style="width: 100px; height: 100px"></el-image>
              </template>
            </el-table-column>
            <el-table-column label="活码名称" align="center" min-width="100" prop="name" show-overflow-tooltip />
            <el-table-column label="活码分组" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip />
            <el-table-column label="使用员工" align="center" min-width="140" prop="qrUserInfos" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-for="(unit, key) in row.qrUserInfos" :key="key" style="display: inline">
                  <template v-for="(item, index) in unit.weQrUserList" :key="index">
                    <span>{{ item.userName + ' ' }}</span>
                  </template>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="标签" align="center" prop="qrTags" min-width="160px">
              <template #default="{ row }">
                <div>
                  <template v-for="(data, key) in row.qrTags" :key="key">
                    <el-tag v-if="key < 2 && data.tagName" :key="key">{{ data.tagName }}</el-tag>
                  </template>
                  <el-popover trigger="hover" width="200">
                    <template v-for="(unit, index) in row.qrTags" :key="index">
                      <el-tag v-if="index > 1 && unit.tagName">{{ unit.tagName }}</el-tag>
                    </template>
                    <template #reference>
                      <div style="display: inline">
                        <el-tag v-if="row.qrTags ? row.qrTags.length > 2 : false">...</el-tag>
                      </div>
                    </template>
                  </el-popover>
                </div>
              </template>
            </el-table-column>
            <!-- <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180">
            </el-table-column> -->
            <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
          </template>
          <!-- 客群活码 -->
          <template v-else-if="type === 'kqcode'">
            <el-table-column prop="activityName" label="活码名称" align="center"></el-table-column>
            <el-table-column prop="codeUrl" label="二维码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <template #reference><el-image :src="row.codeUrl" class="code-image--small"></el-image></template>
                  <el-image :src="row.codeUrl" class="code-image"></el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column label="客群标签" width="180px">
              <template #default="{ row }">
                <tag-ellipsis v-if="row.tags" limit="2" :list="row.tags.split(',')"></tag-ellipsis>
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
                <a style="color: #0079de; text-decoration: underline" @click="getDetail(row.id)">
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
          </template>
          <!-- 识客活码 -->
          <template v-else-if="type === 'skcode'">
            <el-table-column prop="knowCustomerName" label="识客码名称" align="center"></el-table-column>
            <el-table-column prop="knowCustomerQr" label="二维码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <template #reference>
                    <el-image :src="row.knowCustomerQr" class="code-image--small"></el-image>
                  </template>
                  <el-image :src="row.knowCustomerQr" class="code-image"></el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column
              prop="tdScanCodeNumber"
              width="120px"
              label="今日扫码次数"
              align="center"></el-table-column>
            <el-table-column
              prop="totalScanCodeNumber"
              width="120px"
              label="总扫码次数"
              align="center"></el-table-column>
            <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
            <el-table-column prop="updateTime" label="操作时间" align="center" width="160"></el-table-column>
          </template>
          <!-- 拉新活码 -->
          <template v-else-if="type === 'lxcode'">
            <el-table-column prop="name" label="活码名称" align="center"></el-table-column>
            <el-table-column prop="type" label="拉新方式" align="center">
              <template #default="{ row }">
                {{ row.type === 1 ? '红包拉新' : '卡券拉新' }}
              </template>
            </el-table-column>
            <el-table-column prop="imageUrl" label="二维码" align="center" width="130">
              <template #default="{ row }">
                <el-popover placement="bottom" trigger="hover">
                  <template #reference><el-image :src="row.imageUrl" class="code-image--small"></el-image></template>
                  <el-image :src="row.imageUrl" class="code-image"></el-image>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column prop="scanNum" width="160px" label="新增客户总数" align="center">
              <template #header>
                <el-popover placement="top" trigger="hover">
                  <template #reference>
                    <div>
                      新增客户总数
                      <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                    </div>
                  </template>
                  <div>通过当前活码新增的客户总数</div>
                </el-popover>
              </template>
            </el-table-column>
            <el-table-column prop="receiveNum" width="160px" label="新客领取总数" align="center">
              <template #header>
                <el-popover placement="top" trigger="hover">
                  <template #reference>
                    <div>
                      新客领取总数
                      <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                    </div>
                  </template>
                  <div>新增客户领取的红包/卡券总数</div>
                </el-popover>
              </template>
            </el-table-column>

            <el-table-column prop="createBy" label="创建人" align="center"></el-table-column>
            <el-table-column prop="updateTime" label="最近操作时间" align="center" width="200"></el-table-column>
          </template>
        </el-table>
        <pagination
          :total="total"
          v-model:page="query.pageNum"
          v-model:limit="query.pageSize"
          @pagination="getList()" />
      </div>

      <div class="empty" v-else-if="!loading && list.length === 0">
        <div class="tips">暂无{{ title }}，点击下方按钮立即创建</div>
        <el-button type="primary" @click="goAdd">去创建</el-button>
      </div>
      <template #footer>
        <div>
          <el-button @click="Pvisible = false">取 消</el-button>
          <el-button type="primary" @click="submit(list.length)">确 定</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog title="当前客群" v-model="detailDialog" append-to-body width="70%">
      <el-table v-loading="tabLoading" :data="tableList" style="width: 100%">
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
  </div>
</template>

<script>
import { getList as getEmployeeList } from '@/api/drainageCode/staff'
import { getList, getTableTotal } from '@/api/drainageCode/group'
import { getList as identificationList } from '@/api/drainageCode/identity'
import { getList as pullNewList } from '@/api/drainageCode/pullNews'

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
        this.query.orderByColumn = 'wqc.update_time'
        this.query.isAsc = 'desc'
      } else {
        delete this.query.orderByColumn
        delete this.query.isAsc
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
        ygcode: 'staffCode',
        kqcode: 'customerGroupCode',
        mdcoed: 'storeCode',
        skcode: 'identityCode',
        lxcode: 'pullNewsCode',
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
        lxcode: 'imageUrl',
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
    color: var(--font-black-7);
    font-size: 12px;
    line-height: 60px;
  }
}
</style>
