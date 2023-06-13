<template>
  <div style="height: 100%;">
    <div class="g-left-right">
      <div class="left g-card">
        <div class="title">
          <div class="title-name">人群分组</div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <el-scrollbar class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == key }"
            v-for="(group, key) in groupList"
            :key="group.id"
            @click="switchGroup(key, group)"
          >
            <div class="name">{{ group.name }}</div>
            <el-dropdown v-if="group.flag === 0" class="dropdown" @command="onGroupCommand($event, group)">
              <span class="dot">
                <i class="el-icon-more content-icon"></i>
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
        <el-form :inline="true" label-width="" label-position="left" class="top-search">
          <el-form-item label="人群名称">
            <el-input v-model="query.name" placeholder="请输入人群名称" clearable @keyup.enter.native="search()" />
          </el-form-item>
          <el-form-item label="选择状态" prop="qrUserName">
            <el-select v-model="query.status">
              <el-option
                v-for="(unit, key) in statusList"
                :key="key"
                :label="unit.name"
                :value="unit.status"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label-width="0">
            <el-button type="primary" @click="search()">查询</el-button>
            <el-button @click="resetQuery" type="info" plain>清空</el-button>
          </el-form-item>
        </el-form>
        <div class="g-card">
          <div class="mid-action">
            <el-button type="primary" @click="goRoute('add')">新建人群</el-button>
            <div>
              <el-button type="primary" plain @click="removeFn('mult')">批量删除</el-button>
              <el-button type="primary" plain @click="updateFn('mult')">批量更新</el-button>
            </div>
          </div>
          <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" style="width: 100%;">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="人群名称" align="center" prop="qrCode" min-width="120">
              <template slot-scope="{ row }">
                <span class="default_name" @click="goRoute('detail', row.id)">{{ row.name }}</span>
              </template>
            </el-table-column>
            <el-table-column label="人群规模" align="center" min-width="100" prop="crowdNum" show-overflow-tooltip>
              <template slot="header">
                <el-popover placement="top" trigger="hover">
                  <div slot="reference">
                    人群规模
                    <i class="el-icon-question"></i>
                  </div>
                  <div>为上一次人群计算成功的数量，非实时数据，可手动更新</div>
                </el-popover>
              </template>
              <template slot-scope="{ row }">
                <span>{{ row.crowdNum ? row.crowdNum : '-' }}</span>
              </template>
            </el-table-column>
            <el-table-column label="计算状态" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip>
              <template slot-scope="{ row }">
                <div
                  :class="{
                    color1: row.status === 1,
                    color2: row.status === 2,
                    color3: row.status === 3,
                    color4: row.status === 4
                  }"
                >
                  {{
                    row.status === 1
                      ? '待计算'
                      : row.status === 2
                      ? '计算中'
                      : row.status === 3
                      ? '计算完成'
                      : row.status === 4
                      ? '计算失败'
                      : ''
                  }}
                </div>
              </template>
            </el-table-column>
            <el-table-column
              label="创建人"
              align="center"
              min-width="140"
              prop="createBy"
              show-overflow-tooltip
            ></el-table-column>
            <el-table-column label="最近更新时间" align="center" prop="updateTime" width="180"></el-table-column>
            <el-table-column
              label="操作"
              align="center"
              fixed="right"
              width="180"
              class-name="small-padding fixed-width"
            >
              <template slot-scope="{ row }">
                <el-button type="text" @click="goRoute('detail', row.id)">查看</el-button>
                <template v-if="row.status === 3 || row.status === 4">
                  <el-divider direction="vertical"></el-divider>
                  <el-button type="text" @click="goRoute('add', row.id)">编辑</el-button>
                </template>
                <el-divider direction="vertical"></el-divider>
                <el-button type="text" @click="removeFn('single', row.id)">删除</el-button>
                <template v-if="row.status !== 2 && row.type === 1">
                  <el-divider direction="vertical"></el-divider>
                  <el-button type="text" @click="updateFn('single', row.id)">更新</el-button>
                </template>
              </template>
            </el-table-column>
          </el-table>
          <pagination :total="total" :page.sync="query.pageNum" :limit.sync="query.pageSize" @pagination="getList()" />
        </div>
      </div>
    </div>

    <!-- <el-row type="flex" justify="space-between" class="g-margin-t">
      <el-col :span="5" class="left g-card" style="border-radius: 4px; background: #fff;"> </el-col>
      <el-col :span="19" class="g-card mt0">
       </el-col>
    </el-row> -->

    <el-dialog :title="`${groupForm.id ? '修改' : '新建'}分组`" :visible.sync="groupVisible" width="30%">
      <el-form :model="groupForm" :rules="rules" ref="groupForm">
        <el-form-item label="分组名称" prop="name" label-width="80px">
          <el-input v-model="groupForm.name" clearable autocomplete="off" maxlength="15" show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="groupVisible = false">取 消</el-button>
        <el-button type="primary" @click="onAddOrUpdateGroup">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import { getList, remove, renew, deleteCategory } from '@/api/marketStrategy/people'
  import { getCodeCategoryList, addCodeCategory, updateCodeCategory } from '@/api/drainageCode/staff'
  // import ClipboardJS from 'clipboard'
  export default {
    name: 'marketing_stratege_people',
    components: {},
    data() {
      return {
        // 查询参数
        query: {
          pageNum: 1,
          pageSize: 10,
          groupId: '',
          name: '',
          status: null,
          orderByColumn: 'update_time',
          isAsc: 'desc'
        },
        statusList: [
          { name: '全部状态', status: null },
          { name: '待计算', status: 1 },
          { name: '计算中', status: 2 },
          { name: '计算完成', status: 3 },
          { name: '计算失败', status: 4 }
        ],
        // 遮罩层
        loading: false,
        // 选中数组
        ids: [],
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
          weEmpleCodeUseScops: []
        },
        groupList: [],
        groupVisible: false,
        groupForm: {
          mediaType: 7,
          name: ''
        },
        rules: {
          name: [
            {
              required: true,
              message: '请输入分组名称',
              trigger: 'blur'
            },
            {
              min: 1,
              max: 15,
              message: '长度在 1 到 15 个字符',
              trigger: 'blur'
            }
          ]
        },
        groupIndex: 0
      }
    },
    created() {
      this.getCodeCategoryListFn()
      this.$store.setBusininessDesc(
        `
        <div>基于标签体系建立自定义策略人群</div>
      `
      )
    },
    mounted() {},
    methods: {
      addGroup() {
        this.groupForm = {
          mediaType: 7,
          name: ''
        }
        this.groupVisible = true
      },
      getCodeCategoryListFn() {
        getCodeCategoryList({ mediaType: 7 }).then((res) => {
          if (res.code == 200) {
            this.groupList = res.data
            this.query.groupId = this.groupList[0].id
            this.groupIndex = 0
            this.query.pageNum = 1
            this.getList()
          }
        })
      },
      switchGroup(index, data) {
        this.groupIndex = index
        this.query.groupId = data.id
        this.search()
      },
      search() {
        this.query.pageNum = 1
        this.getList()
      },
      getList() {
        this.loading = true
        getList(this.query)
          .then(({ rows, total }) => {
            this.list = rows
            this.total = Number(total)
            this.loading = false
            this.ids = []
          })
          .catch(() => {
            this.loading = false
          })
      },
      /** 重置按钮操作 */
      resetQuery() {
        this.query.name = ''
        this.query.status = null
        this.search()
      },
      goRoute(path, id) {
        this.$router.push({ path: path, query: { id } })
      },

      // 多选框选中数据
      handleSelectionChange(selection) {
        this.ids = selection.map((item) => item.id)
      },
      /** 删除按钮操作 */
      removeFn(type, id) {
        if (type === 'mult' && !this.ids.length) {
          this.msgInfo('请选择要删除项！')
          return
        }
        const ids = id || this.ids.join(',')
        this.$confirm('是否确认删除策略人群？删除后不可撤销，请谨慎操作。', '警告', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            return remove(ids)
          })
          .then(() => {
            this.search()
            this.msgSuccess('删除成功')
          })
          .catch(function () {})
      },
      // 更新
      updateFn(type, id) {
        if (type === 'mult' && !this.ids.length) {
          this.msgInfo('请选择要更新项！')
          return
        }
        let arr = []
        if (type === 'mult' && this.ids.length) {
          this.ids.forEach((dd) => {
            this.list.map((res) => {
              if (dd === res.id) {
                if (res.status !== 2 && res.type === 1) {
                  arr.push(dd)
                }
              }
            })
          })
          if (!arr.length) {
            this.msgInfo('没有可更新项！')
            return
          }
        }
        const ids = id || arr.join(',')
        this.$confirm('是否确认更新?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
          .then(() => {
            return renew(ids.split(','))
          })
          .then(() => {
            this.getList()
            this.msgSuccess('操作成功！')
          })
          .catch(function () {})
      },
      // 新增分组
      onAddOrUpdateGroup() {
        this.$refs.groupForm.validate((validate) => {
          if (this.groupForm.id) {
            let obj = {
              id: this.groupForm.id,
              name: this.groupForm.name,
              mediaType: 7
            }
            this.groupForm = obj
          }
          if (validate) {
            ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
              this.groupVisible = false
              this.groupForm = {
                name: '',
                mediaType: 7
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
        this.$confirm(
          '是否确认删除当前分组？删除后该分组下人群移动到默认分组中，该操作不可撤销，请谨慎操作！',
          '提示',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
          .then(() => {
            deleteCategory(id).then((res) => {
              this.getCodeCategoryListFn()
            })
          })
          .catch(() => {})
      }
    }
  }
</script>

<style lang="scss" scoped>
  .color1 {
    color: rgba(0, 0, 0, 0.9);
  }
  .color2 {
    color: #fa7216;
  }
  .color3 {
    color: #00d695;
  }
  .color4 {
    color: #e34d59;
  }
  .title_name {
    margin: 10px 0 0 10px;
    font-size: 16px;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.9);
  }
  .default_name {
    color: #0079de;
    cursor: pointer;
    &:hover {
      opacity: 0.7;
    }
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
    background-color: #dcdfe6;
  }
  .hover-item {
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #3c88f0;
    padding: 6px 15px;
    cursor: pointer;
    &:hover {
      background-color: #f5f8fe;
    }
  }
</style>
