<template>
  <div style="height: 100%">
    <div class="g-left-right">
      <div class="left g-card">
        <div class="title">
          <div class="title-name">
            <el-icon-arrow-up class="el-icon-arrow-up mr5"></el-icon-arrow-up>
            全部
          </div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <el-scrollbar class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == key }"
            v-for="(group, key) in groupList"
            :key="group.id"
            @click="switchGroup(key, group)">
            <div class="name">{{ group.name }}</div>
            <el-dropdown
              v-if="groupIndex == key && group.flag === 0"
              class="dropdown"
              @command="onGroupCommand($event, group)">
              <span class="dot">
                <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="edit">修改分组</el-dropdown-item>
                  <el-dropdown-item command="remove">删除分组</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-scrollbar>
      </div>

      <div class="right">
        <RequestChartTable
          ref="table"
          :isCreateRequest="false"
          :request="(pa) => (Object.assign(pa, query), getList(pa))"
          @reset="qrUserName = query.qrUserIds = ''">
          <template #query="{ query }">
            <el-form-item label="活码名称" prop="qrName">
              <el-input v-model="query.qrName" placeholder="请输入活码名称" clearable />
            </el-form-item>
            <el-form-item label="选择员工">
              <el-input v-model="qrUserName" readonly @click="dialogVisible = true" placeholder="请选择员工" />
            </el-form-item>
            <!-- <el-form-item label="分配方式" prop="isJoinGroup">
              <el-select v-model="query.isJoinGroup" placeholder="请选择分配方式">
                <el-option v-for="(item, index) in dictAddStatus" :key="index" :label="item" :value="index"></el-option>
              </el-select>
            </el-form-item> -->
          </template>

          <template #operation="{ selectedIds }">
            <div class="mid-action mb0">
              <el-button type="primary" @click="goRoute('add')">新建活码</el-button>
              <div>
                <el-button
                  type="primary"
                  plain
                  :disabled="!selectedIds?.length"
                  @click="$refs.table?.download(downloadBatch, '批量员工活码.zip', '确认下载所有图片吗?')">
                  批量下载
                </el-button>
                <el-button type="primary" plain :disabled="!selectedIds?.length" @click="$refs.table?.remove(remove)">
                  批量删除
                </el-button>
              </div>
            </div>
          </template>

          <template #table="{ data }">
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
            <!-- <el-table-column label="活码分组" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip /> -->
            <el-table-column label="使用员工" align="center" min-width="140" prop="qrUserInfos" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-for="(unit, key) in row.qrUserInfos" :key="key" style="display: inline">
                  <template v-for="(item, index) in unit.weQrUserList" :key="index">
                    <span>{{ item.userName + ' ' }}</span>
                  </template>
                </div>
                <!-- <TagEllipsis :list="row.qrUserInfos.f" defaultProps="userName" emptyText /> -->
              </template>
            </el-table-column>
            <el-table-column label="标签" align="center" prop="qrTags" min-width="160px">
              <template #default="{ row }">
                <TagEllipsis :list="row.qrTags" defaultProps="tagName" emptyText />
              </template>
            </el-table-column>
            <!-- <el-table-column align="center" prop="isJoinGroup" label="分配方式">
              <template #default="{ row }">{{ dictAddStatus[row.isJoinGroup] }}</template>
            </el-table-column> -->
            <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="220">
              <template #default="{ row }">
                <el-button text @click="goRoute('detail', row.id)">详情|统计</el-button>
                <el-button text @click=";(share.visible = true), (share.data = row)">分享</el-button>
                <el-button text @click="goRoute('add', row.id)">编辑</el-button>
                <el-button text @click="$refs.table?.remove(remove, row.id)">删除</el-button>
              </template>
            </el-table-column>
          </template>
        </RequestChartTable>
      </div>
    </div>

    <!-- 批量新建弹窗 -->
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"></SelectUser>

    <el-dialog :title="`${groupForm.id ? '修改' : '新建'}分组`" v-model="groupVisible" width="30%">
      <el-form :model="groupForm" :rules="rules" ref="groupForm">
        <el-form-item label="分组名称" prop="name" label-width="80px">
          <el-input v-model="groupForm.name" clearable autocomplete="off" maxlength="15" show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="groupVisible = false">取 消</el-button>
          <el-button type="primary" @click="onAddOrUpdateGroup">确 定</el-button>
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
import {
  getList,
  remove,
  downloadBatch,
  getCodeCategoryList,
  addCodeCategory,
  updateCodeCategory,
  removeCodeCategory,
} from '@/api/drainageCode/staff'
//
export default {
  name: 'CodeStaff',
  components: { CodeLink: defineAsyncComponent(() => import('../components/CodeLink')) },
  data() {
    return {
      getList,
      remove,
      downloadBatch,
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        groupId: '',
        qrUserIds: undefined,
        orderByColumn: 'wqc.update_time',
        isAsc: 'desc',
      },
      qrUserName: undefined,
      userArray: [], // 选择人员
      userArrayStr: '',
      dialogVisible: false,
      // 遮罩层
      loading: false,
      // 总条数
      total: 0,
      // 表格数据
      list: [],
      // 表单参数
      form: {
        codeType: 3,
        qrcode: '',
        isJoinConfirmFriends: 0,
        weEmpleCodeTags: [],
        weEmpleCodeUseScops: [],
      },
      groupList: [],
      groupVisible: false,
      groupForm: {
        mediaType: 6,
        name: '',
      },
      rules: {
        name: [
          {
            required: true,
            message: '请输入分组名称',
            trigger: 'blur',
          },
          {
            min: 1,
            max: 15,
            message: '长度在 1 到 15 个字符',
            trigger: 'blur',
          },
        ],
      },
      groupIndex: 0,

      share: {},
      // dictAddStatus: { 0: '未进群', 1: '已进群' },
    }
  },
  created() {
    this.getCodeCategoryListFn()
    this.$store.setBusininessDesc(
      `
        <div>支持单人、批量单人及多人方式新建员工活码，客户可以通过扫描员工活码添加员工为好友，并支持自动给客户打标签和发送欢迎语。</div>
      `,
    )
  },
  mounted() {},
  methods: {
    addGroup() {
      this.groupForm = {
        mediaType: 6,
        name: '',
      }
      this.groupVisible = true
    },
    getCodeCategoryListFn() {
      getCodeCategoryList({ mediaType: 6 }).then((res) => {
        this.groupList = res.data
        this.query.groupId = this.groupList[0].id
        this.groupIndex = 0
        this.query.pageNum = 1
        this.$refs.table.getList()
      })
    },
    switchGroup(index, data) {
      this.groupIndex = index
      this.query.groupId = data.id
      this.$refs.table?.getList()
    },
    getSelectUser(data) {
      this.userArray = data
      this.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
      this.query.qrUserIds = this.userArray
        .map(function (obj, index) {
          return obj.userId
        })
        .join(',')
    },
    goRoute(path, id) {
      this.$router.push({ path: path, query: { id, groupId: this.query.groupId } })
    },

    // 新增分组
    onAddOrUpdateGroup() {
      this.$refs.groupForm.validate((validate) => {
        console.log(this.groupForm)
        if (this.groupForm.id) {
          let obj = {
            id: this.groupForm.id,
            name: this.groupForm.name,
            mediaType: 6,
          }
          this.groupForm = obj
        }
        if (validate) {
          ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
            this.groupVisible = false
            this.groupForm = {
              name: '',
              mediaType: 6,
            }
            this.$refs.groupForm.clearValidate()
            this.getCodeCategoryListFn()
          })
        }
      })
    },
    onGroupCommand(e, group) {
      if (group.id === '1') {
        this.msgInfo('默认分组不可操作！')
        return
      }
      if (e == 'edit') {
        this.editGroup(group)
      } else if (e == 'remove') {
        this.removeGroup(group.id)
      }
    },
    editGroup(group) {
      this.groupForm = JSON.parse(JSON.stringify(group))
      this.groupVisible = true
    },
    removeGroup(id) {
      // this.$confirm('确认删除当前分组? 删除后其下活码将移至默认分组！', '提示', {
      this.$confirm('确认删除当前分组? 删除后其下活码将一并删除！', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          removeCodeCategory(id).then((res) => {
            this.getCodeCategoryListFn()
          })
        })
        .catch(() => {})
    },
  },
}
</script>

<style lang="scss" scoped>
[class*='el-col-'] {
  overflow: auto;
}
.bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.my-divider {
  display: block;
  height: 1px;
  width: 100%;
  background-color: var(--bg-black-9);
}
.hover-item {
  font-size: 12px;

  font-weight: 400;
  color: var(--color);
  padding: 6px 15px;
  cursor: pointer;

  &:hover {
    background-color: var(--bg-black-11);
  }
}
</style>
