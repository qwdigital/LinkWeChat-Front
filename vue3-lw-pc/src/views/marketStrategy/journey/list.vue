<template>
  <div>
    <el-form :inline="true" label-width="" label-position="left" class="top-search">
      <el-form-item label="旅程名称">
        <el-input v-model="query.name" placeholder="请输入旅程名称" clearable @keyup.enter.native="search()" />
      </el-form-item>
      <el-form-item label="旅程状态">
        <el-select v-model="query.status">
          <el-option
            v-for="item in statusOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <el-button type="primary" size="small" @click="search()">查询</el-button>
        <el-button @click="resetQuery" size="small" type="info" plain>清空</el-button>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="space-between" class="g-margin-t">
      <el-col :span="5" class="left g-card">
        <div class="title">
          <div class="title-name">旅程分组</div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <div class="item-list">
          <div
            class="item"
            :class="{ active: groupIndex == key }"
            v-for="(group, key) in groupList"
            :key="group.id"
            @click="switchGroup(key, group)">
            <div class="name">{{ group.name }}</div>
            <el-dropdown v-if="group.flag === 0" class="dropdown" @command="onGroupCommand($event, group)">
              <span class="dot">
                <!-- <img style="height: 15px;width: 15px;" :src="require('@/assets/drainageCode/more.png')" alt=""> -->
                <i class="el-icon-more content-icon"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="edit">修改分组</el-dropdown-item>
                <el-dropdown-item command="remove">删除分组</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </el-col>
      <el-col :span="19" class="g-card mt0">
        <div>
          <div style="display: flex; justify-content: space-between">
            <el-button type="primary" size="small" @click="$router.push('add')">
              +&nbsp;&nbsp;&nbsp;&nbsp;新建旅程
            </el-button>
            <div>
              <el-button type="primary" plain :disabled="ids.length === 0" @click="handleUpdateStatus(2)">
                批量启用
              </el-button>
              <el-button type="primary" plain :disabled="ids.length === 0" @click="handleUpdateStatus(4)">
                批量暂停
              </el-button>
              <el-button type="primary" plain :disabled="ids.length === 0" @click="removeFn('mult')">
                批量删除
              </el-button>
            </div>
          </div>
        </div>
        <el-table :data="list" v-loading="loading" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" align="center"></el-table-column>
          <el-table-column label="旅程名称" align="center" prop="qrCode" min-width="120" fixed="left">
            <template slot-scope="{ row }">
              <span
                class="default_name"
                @click="
                  $router.push({
                    path: 'detail',
                    query: {
                      id: row.id,
                      obj: encodeURIComponent(JSON.stringify(row)),
                    },
                  })
                ">
                {{ row.name }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="startTime" label="起始时间" align="center" width="150">
            <template slot-scope="{ row }">
              <span>{{ row.startTime ? row.startTime : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="finishTime" label="结束时间" align="center" width="150">
            <template slot-scope="{ row }">
              <span>{{ row.finishTime ? row.finishTime : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="旅程状态" align="center">
            <template #default="{ row }">
              <span :style="{ color: row.color || '#000' }">{{ row.statusText }}</span>
            </template>
          </el-table-column>
          <el-table-column label="触发人数" align="center" width="120px" prop="triggerNum">
            <template slot="header">
              <el-popover placement="top" trigger="hover">
                <div slot="reference">
                  触发人数
                  <i class="el-icon-question"></i>
                </div>
                <div>当前旅程触发的总人数，进入旅程的客户即视为触发</div>
              </el-popover>
            </template>
            <template #default="{ row }">
              {{ row.triggerNum }}
            </template>
          </el-table-column>
          <el-table-column label="触达人数" align="center" width="120px" prop="reachNum">
            <template slot="header">
              <el-popover placement="top" trigger="hover">
                <div slot="reference">
                  触达人数
                  <i class="el-icon-question"></i>
                </div>
                <div>当前旅程通过触达动作成功触达的人数</div>
              </el-popover>
            </template>
            <template #default="{ row }">
              {{ row.reachNum }}
            </template>
          </el-table-column>
          <el-table-column label="触达率" align="center" width="120px" prop="reachRate">
            <template slot="header">
              <el-popover placement="top" trigger="hover">
                <div slot="reference">
                  触达率
                  <i class="el-icon-question"></i>
                </div>
                <div>触达人数/触发人数，精确2位小数</div>
              </el-popover>
            </template>
            <template #default="{ row }">
              {{ row.reachRate }}
            </template>
          </el-table-column>
          <el-table-column prop="createBy" label="创建人" align="center" width="150"></el-table-column>
          <el-table-column prop="updateTime" label="最近更新时间" align="center" width="150"></el-table-column>
          <el-table-column label="操作" align="center" width="180" fixed="right">
            <template #default="{ row }">
              <el-button
                type="text"
                size="mini"
                @click="
                  $router.push({
                    path: 'detail',
                    query: {
                      id: row.id,
                      obj: encodeURIComponent(JSON.stringify(row)),
                    },
                  })
                ">
                查看
              </el-button>
              <el-button
                type="text"
                size="mini"
                v-if="row.status === 0 || row.status === 1 || row.status === 2"
                @click="
                  $router.push({
                    path: 'add',
                    query: {
                      id: row.id,
                    },
                  })
                ">
                编辑
              </el-button>
              <el-button
                type="text"
                size="mini"
                @click="removeFn('single', row.id)"
                v-if="row.status === 0 || row.status === 1">
                删除
              </el-button>
              <el-button
                type="text"
                size="mini"
                @click="handleUpdateStatus(2, row.id)"
                v-if="row.status === 1 || row.status === 4">
                开启
              </el-button>
              <el-button type="text" size="mini" @click="handleUpdateStatus(4, row.id)" v-if="row.status === 2">
                暂停
              </el-button>
              <el-button
                type="text"
                size="mini"
                @click="handleUpdateStatus(5, row.id)"
                v-if="row.status === 2 || row.status === 4 || row.status === 3">
                停用
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination
          v-show="total > 0"
          :total="total"
          :page.sync="query.pageNum"
          :limit.sync="query.pageSize"
          @pagination="getList()" />
      </el-col>
    </el-row>

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
import { getCodeCategoryList, addCodeCategory, updateCodeCategory, removeCodeCategory } from '@/api/drainageCode/staff'
import { getList, remove, updateStatus, removeJourneyGroup } from '@/api/marketStrategy/journey.js'
//
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
        name: '', // 旅程名称
        status: '', // 旅程状态
        // orderByColumn: "wqc.update_time",
        isAsc: 'desc',
      },
      statusOptions: [
        {
          value: '',
          label: '全部',
        },
        {
          value: 0,
          label: '未发布',
        },
        {
          value: 1,
          label: '待执行',
        },
        {
          value: 2,
          label: '执行中',
        },
        {
          value: 3,
          label: '已完成',
        },
        {
          value: 4,
          label: '已暂定',
        },
        {
          value: 5,
          label: '已停用',
        },
        {
          value: 6,
          label: '执行失败',
        },
      ],
      //   qrUserName: undefined,
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
        mediaType: 8,
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
      //   journeyClass: "#000", // 状态颜色
    }
  },
  created() {
    this.getCodeCategoryListFn()
    this.$store.dispatch(
      'app/setBusininessDesc',
      `
        <div>基于客户旅程实现策略自动化</div>
      `,
    )
  },
  mounted() {},
  methods: {
    addGroup() {
      this.groupForm = {
        mediaType: 8,
        name: '',
      }
      this.groupVisible = true
    },
    getCodeCategoryListFn() {
      getCodeCategoryList({ mediaType: 8 }).then((res) => {
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
      //   this.loading = true;
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.list.forEach((item) => {
            switch (item.status) {
              case 0:
                item.statusText = '未发布'
                break
              case 1:
                item.statusText = '待执行'
                break
              case 2:
                item.statusText = '执行中'
                item.color = '#00D695'
                break
              case 3:
                item.statusText = '已完成'
                break
              case 4:
                item.statusText = '已暂停'
                item.color = '#FA7216'
                break
              case 5:
                item.statusText = '已停用'
                item.color = '#E34D59'
                break
              case 6:
                item.statusText = '执行失败'
                item.color = '#E34D59'
                break
              default:
                break
            }
          })
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
      this.query.status = ''
      //   this.userArray = [];
      //   this.qrUserName = "";
      // this.query.userArrayStr = ''
      this.search()
    },
    goRoute(path, id) {
      this.$router.push({
        path: path,
        query: { id, groupId: this.query.groupId },
      })
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    /** 删除按钮操作 */
    removeFn(type, id) {
      const ids = id || this.ids.join(',')
      this.$confirm('是否确认删除策略旅程？删除后不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
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
    // 更改状态
    handleUpdateStatus(status, id) {
      let i = []
      i.push(id)
      if (!id) {
        i = false
      }
      const ids = i || this.ids
      let text = ''
      if (status === 2) {
        text = '是否确认开启该策略旅程？开启后立即执行当前策略旅程。'
      } else if (status === 4) {
        text = '是否确认暂停该策略旅程？暂停后该旅程不再继续执行后续旅程。'
      } else {
        text = '是否确认停用该策略旅程？停用后不可恢复执行，仅支持查看数据，请谨慎操作。'
      }
      this.$confirm(text, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return updateStatus({ ids, status })
        })
        .then(() => {
          this.search()
          this.msgSuccess('操作成功')
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
            mediaType: 8,
          }
          this.groupForm = obj
        }
        if (validate) {
          ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
            this.groupVisible = false
            this.groupForm = {
              name: '',
              mediaType: 8,
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
      this.$confirm('是否确认删除当前分组？删除后该分组下人群移动到默认分组中，该操作不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          removeCodeCategory(id).then((res) => {
            this.getRemoveJourneyGroup(id)
            this.getCodeCategoryListFn()
          })
        })
        .catch(() => {})
    },
    getRemoveJourneyGroup(id) {
      removeJourneyGroup(id).then((res) => {})
    },
  },
}
</script>

<style lang="scss" scoped>
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

.left {
  margin-right: 16px;
  display: flex;
  flex-direction: column;
  .title {
    color: #3c88f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .title-name {
      color: rgba(0, 0, 0, 0.9);
      font-size: 16px;
      font-weight: 600;
      // color: #333333;
      display: flex;
      align-items: center;
    }
    .title-btn {
      cursor: pointer;
      display: flex;
      align-items: center;
      font-size: 14px;
      font-weight: normal;
      color: #0079de;
      &:hover {
        opacity: 0.8;
      }
    }
  }

  .item-list {
    padding-top: 15px;
    display: flex;
    flex-direction: column;
    overflow-x: hidden;
    overflow-y: auto;
    .item {
      cursor: pointer;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 14px;
      color: rgba(0, 0, 0, 0.6);
      height: 40px;
      line-height: 40px;
      width: 100%;
      padding-left: 20px;
      .name {
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
      }
      .dropdown {
        // display: none;
        .dot {
          cursor: pointer;
          width: 15px;
          height: 15px;
          line-height: 15px;
          font-size: 14px;
          font-family: JMT-Font, JMT;
          font-weight: normal;
          color: rgba(0, 0, 0, 0.6);
          margin-right: 10px;
          margin-left: 5px;
          font-weight: 500;
          .content-icon {
            color: rgba(0, 0, 0, 0.6);
            font-size: 12px;
            transform: rotate(90deg);
          }
        }
      }
      &:hover {
        color: rgba(0, 0, 0, 0.9);
        background: #f5f8fe;
        opacity: 0.8;
        border-radius: 2px;
        .dropdown {
          // display: block;
        }
      }
    }

    .active {
      // border-left: 2px solid #3c88f0;
      color: rgba(0, 0, 0, 0.9);
      background: #f5f8fe;
      border-radius: 2px;
    }
  }
}
</style>
