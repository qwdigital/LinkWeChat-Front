<template>
  <div style="height: 100%">
    <div class="g-left-right">
      <div class="left g-card">
        <div class="title">
          <div class="title-name">
            <el-icon-arrow-up class="el-icon-arrow-up mr5"></el-icon-arrow-up>
            全部
          </div>
          <div class="title-btn" @click="addGroup(0)">添加</div>
        </div>
        <el-scrollbar class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == key }"
            v-for="(group, key) in groupList"
            :key="group.id"
            @click="switchGroup(key, group)">
            <div class="name">{{ group.name }}</div>
            <el-dropdown v-if="groupIndex == key" class="dropdown" @command="onGroupCommand($event, group)">
              <span class="dot">
                <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="moveUp" v-if="key !== 0">上移</el-dropdown-item>
                  <el-dropdown-item command="moveDown" v-if="key !== groupList.length - 1">下移</el-dropdown-item>
                  <el-dropdown-item command="edit">修改分组</el-dropdown-item>
                  <el-dropdown-item command="remove" v-if="group.fixed !== 1">删除分组</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-scrollbar>
      </div>
      <div class="right">
        <div class="g-card">
          <div class="mid-action">
            <el-button type="primary" @click="add()">新建字段</el-button>
            <div>
              <el-button type="primary" plain @click="removeFn('mult')">批量删除</el-button>
            </div>
          </div>

          <el-table
            v-loading="loading"
            :data="list"
            @selection-change="handleSelectionChange"
            :default-sort="{ prop: 'sort', order: 'descending' }">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="字段名称" align="center" min-width="100" prop="name" show-overflow-tooltip />
            <el-table-column label="字段类型" align="center" min-width="100" prop="type" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.typeStr }}
              </template>
            </el-table-column>

            <el-table-column label="字段说明/字段值" align="center" min-width="100" prop="type" show-overflow-tooltip>
              <template #default="{ row }">
                {{ row.expound ? row.expound : row.value ? row.value : '-' }}
              </template>
            </el-table-column>

            <el-table-column label="最近操作记录" align="center" width="180">
              <template #default="{ row }">
                <div>{{ row.updateBy }}</div>
                <div>{{ row.updateTime }}</div>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="180">
              <template #default="{ row }">
                <el-button text @click="getListMove(row.catalogueId, row.id, 0)" v-if="!row.isFirst">上移</el-button>
                <el-button text @click="getListMove(row.catalogueId, row.id, 1)" v-if="!row.isLast">下移</el-button>
                <el-button text @click="add(row.id)">编辑</el-button>
                <el-button text @click="removeFn('single', row.id)" v-if="row.fixed !== 1">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getList()" />
        </div>
      </div>
    </div>
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
    <Add v-model="visible" :catalogueId="query.catalogueId" :editId="editId" @success="getList()" />
  </div>
</template>

<script>
import Add from './add'
import {
  getList,
  remove,
  listMove,
  fnRemove,
  getCodeCategoryList,
  addCodeCategory,
  updateCodeCategory,
  removeCodeCategory,
  moveCodeCategory,
} from '@/api/salesCenter/orderInfo'
//
export default {
  name: 'OrderInfo', // 订单信息
  components: { Add },
  data() {
    return {
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        catalogueId: '',
      },
      qrUserName: undefined,
      userArray: [], // 选择人员
      userArrayStr: '',
      dialogVisible: false,
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
        weEmpleCodeUseScops: [],
      },
      groupList: [],
      groupVisible: false,
      groupForm: {
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
      visible: false,
      typeList: [],
      editId: undefined,
    }
  },
  created() {
    this.getCodeCategoryListFn()
    this.$store.setBusininessDesc(
      `
        <div>可自定义修改客户画像中的订单信息项供企业个性化使用</div>
      `,
    )
  },
  mounted() {},
  methods: {
    getListMove(catalogueId, id, direction) {
      listMove({ id, direction, catalogueId }).then((res) => {
        this.getList()
      })
    },
    add(id) {
      this.visible = true
      this.editId = id
    },
    move(direction, id) {
      let obj = { direction, id }
      moveCodeCategory(obj).then((res) => {
        if (res.code === 200) {
          this.getCodeCategoryListFn()
        }
      })
    },
    addGroup() {
      this.groupForm = {
        name: '',
      }
      this.groupVisible = true
    },
    getCodeCategoryListFn() {
      getCodeCategoryList().then((res) => {
        if (res.code == 200) {
          this.groupList = res.data
          this.query.catalogueId = this.groupList[0].id
          this.groupIndex = 0
          this.query.pageNum = 1
          this.getList()
        }
      })
    },
    switchGroup(index, data) {
      this.groupIndex = index
      this.query.catalogueId = data.id
      this.getList()
    },
    getList() {
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          if (rows[0]) {
            rows[0].isFirst = true
            rows[rows.length - 1].isLast = true
          }
          this.list = rows
          this.total = Number(total)
          this.loading = false
          this.ids = []
        })
        .finally(() => {
          this.loading = false
        })
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
      const ids = this.ids.join(',')
      this.$confirm('是否确认删除?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          if (id) {
            return remove(id)
          } else {
            return fnRemove(ids)
          }
        })
        .then(() => {
          this.msgSuccess('删除成功')
          this.getList()
        })
        .catch(function () {})
    },
    // 新增分组
    onAddOrUpdateGroup() {
      this.$refs.groupForm.validate((validate) => {
        console.log(this.groupForm)
        if (this.groupForm.id) {
          let obj = {
            id: this.groupForm.id,
            name: this.groupForm.name,
          }
          this.groupForm = obj
        }
        if (validate) {
          ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
            this.groupVisible = false
            this.groupForm = {
              name: '',
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
      } else if (e == 'moveUp') {
        //  上移
        this.move(0, group.id)
      } else if (e == 'moveDown') {
        //  下移
        this.move(1, group.id)
      }
    },
    editGroup(group) {
      this.groupForm = JSON.parse(JSON.stringify(group))
      this.groupVisible = true
    },
    removeGroup(id) {
      // this.$confirm('确认删除当前分组? 删除后其下活码将移至默认分组！', '提示', {
      this.$confirm('是否确认删除当前分组？删除后该分组下所有字段同步删除，该操作不可撤销，请谨慎操作。', '提示', {
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
