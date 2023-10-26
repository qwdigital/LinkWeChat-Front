<template>
  <div>
    <div class="g-left-right">
      <div class="left g-card">
        <div class="title">
          <div class="title-name">表单分组</div>
          <div class="title-btn" @click="addGroup">添加</div>
        </div>
        <div class="item-list">
          <div
            class="item"
            v-for="(group, key) in groupList"
            :class="{ active: groupIndex == key }"
            :key="group.id"
            @click="switchGroup(key, group)">
            <div class="name">{{ group.name }}</div>
            <el-dropdown
              v-if="groupIndex == key && group.flag === 0"
              class="dropdown"
              @command="onGroupCommand($event, group)">
              <div v-if="group">
                <span class="dot" v-if="group.name != '默认分组'">
                  <!-- <img :src="('@/assets/drainageCode/more.png')" alt=""> -->
                  <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
                </span>
              </div>
              <template #dropdown v-if="group">
                <el-dropdown-menu>
                  <el-dropdown-item command="edit">修改分组</el-dropdown-item>
                  <el-dropdown-item command="remove">删除分组</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </div>
      <div class="right">
        <el-form :inline="true" label-width="70px" label-position="left" class="top-search">
          <el-form-item label="表单ID">
            <el-input
              onkeyup="value=value.replace(/[^\d]/g,'')"
              v-model="query.id"
              placeholder="请输入表单ID"
              clearable
              @keyup.enter="search()" />
          </el-form-item>
          <el-form-item label="表单名称">
            <!-- readonly -->
            <el-input v-model="query.surveyName" clearable placeholder="请输入表单名称" @keyup.enter="search()" />
          </el-form-item>
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="dateRange"
              value-format="YYYY-MM-DD"
              type="daterange"
              v-bind="pickerOptions"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"></el-date-picker>
            <!-- <el-date-picker
                  v-model="query.createTime"
                  type="daterange"
                  default-time="['00:00:00','00:00:00']"
                  value-format="YYYY-MM-DD HH:mm:ss"
                  placeholder="选择时间"></el-date-picker> -->
          </el-form-item>
          <el-form-item label="选择状态" prop="addState">
            <el-select v-model="query.surveyState">
              <el-option label="未发布" :value="0"></el-option>
              <el-option label="收集中" :value="1"></el-option>
              <el-option label="已暂停" :value="2"></el-option>
              <el-option label="已结束" :value="3"></el-option>
              <!-- <el-option label="待通过" :value="3">
              		</el-option> -->
            </el-select>
          </el-form-item>
          <el-form-item label-width="0">
            <el-button type="primary" @click="search()">查询</el-button>
            <el-button @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="g-card">
          <div class="mid-action">
            <el-button type="primary" @click="goRoute('add')">新建表单</el-button>
            <div>
              <el-button type="primary" plain @click="removeFn('mult')">删除</el-button>
              <!-- <el-button type="primary" plain @click="downloadBatch()"
                  >批量下载</el-button
                > -->
            </div>
          </div>
          <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange" style="width: 100%">
            <el-table-column type="selection" width="50" align="center" />
            <el-table-column label="表单ID&名称" min-width="170" align="center" prop="id" show-overflow-tooltip>
              <template #default="{ row }">
                <div>ID：{{ row.id }}</div>
                <div>名称：{{ row.surveyName }}</div>
              </template>
            </el-table-column>
            <el-table-column label="表单分组" align="center" min-width="100" prop="groupName" show-overflow-tooltip>
              <template #default="{ row }">
                <div style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap">
                  {{ row.groupName }}
                </div>
              </template>
            </el-table-column>
            <el-table-column label="创建人&时间" align="center" min-width="130" prop="createTime" show-overflow-tooltip>
              <template #default="{ row }">
                <div>{{ row.createBy }}</div>
                <div>{{ row.createTime }}</div>
              </template>
            </el-table-column>
            <el-table-column
              label="收集开始&结束时间"
              align="center"
              min-width="200"
              prop="qrUserInfos"
              show-overflow-tooltip>
              <template #default="{ row }">
                <div>
                  开始时间:{{ row.timingStart }}
                  <span v-if="!row.timingStart">永久</span>
                </div>
                <div>
                  结束时间:{{ row.timingEnd }}
                  <span v-if="!row.timingEnd">永久</span>
                </div>
              </template>
            </el-table-column>

            <el-table-column label="表单状态" align="center" min-width="100" prop="qrGroupName" show-overflow-tooltip>
              <template #default="{ row }">
                <div v-if="row.surveyState == 0">未发布</div>
                <div v-if="row.surveyState == 1">收集中</div>
                <div v-if="row.surveyState == 2">已暂停</div>
                <div v-if="row.surveyState == 3">已结束</div>
              </template>
            </el-table-column>
            <el-table-column
              label="总访问量/有效收集量"
              align="center"
              min-width="180"
              prop="qrGroupName"
              show-overflow-tooltip>
              <template #header="scope">
                <div style="display: flex; align-items: center">
                  <div>总访问量/有效收集量</div>
                  <div style="margin-left: 10px">
                    <el-popover width="250" trigger="hover">
                      <p>总访问量:PV;</p>
                      <p>有效收集量:成功提交表单的UV</p>
                      <template #reference>
                        <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                      </template>
                    </el-popover>
                  </div>
                </div>
              </template>
              <template #default="{ row }">
                <div>{{ row.totalVisits }}/{{ row.collectionVolume }}</div>
              </template>
            </el-table-column>

            <el-table-column
              label="最近操作人&时间"
              align="center"
              min-width="130"
              prop="qrGroupName"
              show-overflow-tooltip>
              <template #default="{ row }">
                <div>{{ row.updateBy }}</div>
                <div>{{ row.updateTime }}</div>
              </template>
            </el-table-column>

            <el-table-column label="操作" align="center" fixed="right" width="260">
              <template #default="{ row }">
                <!-- <el-button text @click="goRoute('staffDetail', row.id)">详情|统计</el-button> -->
                <el-button text @click.stop="openPreview(row.id)">预览</el-button>
                <el-button v-if="[0, 2].includes(+row.surveyState)" text @click="updateSurveyStatus(row.id, 1, row)">
                  开启
                </el-button>
                <el-button v-if="row.surveyState == 0" text @click="goRoute('add', '', row.id)">编辑</el-button>
                <el-button v-if="[1, 2].includes(+row.surveyState)" @click.stop="openChannels(row.id)" text>
                  分享
                </el-button>
                <el-button v-if="[1, 4].includes(+row.surveyState)" text @click="updateSurveyStatus(row.id, 2, row)">
                  暂停
                </el-button>
                <el-button v-if="[1, 2].includes(+row.surveyState)" text @click="updateSurveyStatus(row.id, 3, row)">
                  结束
                </el-button>
                <el-button v-if="row.surveyState != 1" text @click="removeFn('single', row.id)">删除</el-button>
                <el-button v-if="row.surveyState != 0" text @click="goRoute('smartFormStatistics', row.id)">
                  统计
                </el-button>
                <!-- <el-dropdown style="margin-left: 10px">
                  <el-button text>
                    <el-icon-MoreFilled class="el-icon-MoreFilled"></el-icon-MoreFilled>
                  </el-button>
                  <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item>
                      <el-button text @click="download(row.id, row.qrGroupName, row.name)">下载</el-button>
                    </el-dropdown-item>
                    <el-dropdown-item>
                      <el-button text @click="removeFn('single', row.id)">删除</el-button>
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </el-dropdown> -->
              </template>
            </el-table-column>
          </el-table>
          <!-- <div class="bottom"> -->

          <pagination
            :total="total"
            v-model:page="query.pageNum"
            v-model:limit="query.pageSize"
            @pagination="getList()" />
          <!-- </div> -->
        </div>
      </div>
    </div>

    <!-- 批量新建弹窗 -->
    <!--   <SelectUser
       v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectUser> -->

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

    <el-dialog title="表单预览" v-model="Preview" width="auto" destroy-on-close>
      <FormsDetail style="margin: 0 5px" :FormIdY="FormIdY" id="y" :key="FormIdY"></FormsDetail>
    </el-dialog>

    <el-dialog title="表单分享" v-model="ifChannels" width="auto" destroy-on-close>
      <Channels :FormIdY="FormIdY" :key="FormIdY"></Channels>
    </el-dialog>
  </div>
</template>

<script>
import {
  surveyList,
  deleteInfoToSurvey,
  updateSurveyStatus,
  updateInfoToSurvey,
  // updateSurveyGroup
} from '@/api/drainageCode/smartForms.js'
import { dateFormat } from '@/utils/index'
import FormsDetail from './build/formsDetail.vue'
import Channels from './components/Channels.vue'
import {
  getList,
  downloadBatch,
  getCodeCategoryList,
  addCodeCategory,
  updateCodeCategory,
  removeCodeCategory,
} from '@/api/drainageCode/staff'

const groupForm = {
  mediaType: 15,
  name: '',
}
export default {
  name: 'CodeStaff',
  components: {
    FormsDetail,
    Channels,
  },
  data() {
    return {
      //当前时间戳
      newData: '',
      //分享显示
      ifChannels: false,
      newGroupId: '',
      //预览表单id
      FormIdY: '',
      //预览显示
      Preview: false,
      //默认分组id
      DefaultGroupingId: '',
      // 查询参数
      seachDate: '',
      query: {
        createTime: '',
        pageNum: 1,
        pageSize: 10,
        groupId: '',
        surveyName: '',
        surveyState: undefined,

        // qrName: '', // 活码名称
        // qrUserName: undefined,
        // orderByColumn: 'wqc.update_time',
        // isAsc: 'desc',
      },
      // 日期范围
      dateRange: [],
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
      groupForm: JSON.parse(JSON.stringify(groupForm)),
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
    }
  },
  created() {
    this.getCodeCategoryListFn()
    // this.$store.setBusininessDesc(
    //
    //   `
    //   <div>支持单人、批量单人及多人方式新建员工活码，客户可以通过扫描员工活码添加员工为好友，并支持自动给客户打标签和发送欢迎语。</div>
    // `
    // )
  },
  mounted() {},
  methods: {
    openPreview(id) {
      this.FormIdY = id
      this.Preview = true
    },
    openChannels(id) {
      this.FormIdY = id
      this.ifChannels = true
    },
    //更新表单状态
    updateInfoToSurvey(data) {
      updateInfoToSurvey(data)
        .then((res) => {
          console.log('更改状态返回值', res)
        })
        .catch(() => {})
    },
    //开启表单
    updateSurveyStatus(id, surveyState, row, style) {
      let that = this
      console.log('row', row.surveyState, row.timingStart, row)

      if (row.surveyState == 0 && !row.timingStart) {
        let data = {
          id: id,
          timingStart: dateFormat(new Date()),
        }
        console.log('data', data)
        this.updateInfoToSurvey(data)
      } else if (row.surveyState == 0 && row.timingStart) {
        let data = {
          id: id,
          timingStart: row.timingStart,
          timingEnd: row.timingEnd,
        }
        console.log('data', data)
        this.updateInfoToSurvey(data)
      }
      if (surveyState == 1) {
        if (row.timingStart) {
          let newData = new Date()
          if (newData < new Date(row.timingStart)) {
            surveyState = 1
            let data = {
              id: id,
              timingStart: dateFormat(new Date()),
              timingEnd: row.timingEnd,
            }
            this.updateInfoToSurvey(data)
          }
        }
        if (row.timingEnd) {
          let newData = new Date()
          if (newData > new Date(row.timingEnd)) {
            surveyState = 3
          }
        }
      }
      console.log('surveyState', surveyState)
      console.log('row.timingStart', row.timingStart)
      if (surveyState == 3) {
        let newData = new Date()
        let data = {
          id: id,
          timingEnd: dateFormat(new Date()),
        }
        this.updateInfoToSurvey(data)
      }
      let data = {
        id: id,
        surveyState: surveyState,
      }
      updateSurveyStatus(data)
        .then((res) => {
          if ([1, 2, 3].includes(surveyState) && style != 'no') {
            this.msgSuccess('操作成功')
          }

          that.getList()
        })
        .catch(() => {})
    },
    addGroup() {
      this.groupForm = JSON.parse(JSON.stringify(groupForm))
      this.groupVisible = true
    },
    getCodeCategoryListFn() {
      getCodeCategoryList({ mediaType: groupForm.mediaType }).then(({ data }) => {
        this.groupList = data
        let groupId = this.$route.query && this.$route.query.groupId
        let groupIndex = data.findIndex((e) => e.id === groupId)
        if (groupId && groupIndex != -1) {
          this.query.groupId = groupId
          this.query.groupName = data[groupIndex].name
          this.groupIndex = groupIndex
        } else {
          this.query.groupId = undefined
          this.query.groupName = undefined
          this.groupIndex = undefined
        }
        this.query.pageNum = 1
        for (let i = 0; i < data.length; i++) {
          if (data[i].name == '默认分组') {
            this.newGroupId = data[i].id
          }
        }
        this.getList()
      })
    },
    switchGroup(index, data) {
      console.log('data', data)
      this.groupIndex = index
      this.query.groupName = data.name
      this.$router.replace({
        query: {
          groupId: data.id,
        },
      })

      this.query.groupId = data.id
      this.search()
    },
    getSelectUser(data) {
      this.userArray = data
      this.query.qrUserName = this.userArray
        .map(function (obj, index) {
          return obj.name
        })
        .join(',')
    },
    search() {
      this.query.pageNum = 1
      this.getList()
    },
    getList() {
      if (this.dateRange) {
        this.query.startDate = this.dateRange[0]
        this.query.endDate = this.dateRange[1]
      } else {
        this.query.startDate = ''
        this.query.endDate = ''
      }
      this.loading = true
      surveyList(this.query)
        .then((res) => {
          this.total = Number(res.total)
          this.list = res.rows
          for (let i = 0; i < this.list.length; i++) {
            if (this.list[i].surveyState == 4) {
              if (this.list[i].timingStart) {
                let newData = new Date()
                if (newData < new Date(this.list[i].timingStart)) {
                  this.list[i].surveyState = 4
                } else {
                  this.list[i].surveyState = 1
                  this.updateSurveyStatus(this.list[i].id, 1, this.list[i], 'no')
                }
              }
              if (this.list[i].timingEnd) {
                let newData = new Date()
                if (newData > new Date(this.list[i].timingEnd)) {
                  this.list[i].surveyState = 3
                }
              }
            }
            // this.list[i].createTime=this.list[i].createTime.substr(0,10);
          }
          this.loading = false
          this.ids = []
        })
        .catch(() => {
          this.loading = false
        })
    },
    /** 重置按钮操作 */
    resetQuery() {
      // this.query.qrName = ''
      this.query.createTime = ''
      this.query.surveyState = ''
      this.query.surveyName = ''
      this.query.id = ''
      // this.userArray = []
      // this.query.addState = ''
      // this.query.userArrayStr = ''
      this.search()
    },
    goRoute(path, id, formId, currentActiveA, currentActiveB) {
      this.$router.push({
        path: path,
        query: {
          id,
          formId,
          currentActiveA,
          currentActiveB,
          groupId: this.query.groupId,
        },
      })
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      console.log('selection', selection)
      this.ids = selection.map((item) => item.id)
    },
    /** 删除按钮操作 */
    removeFn(type, id) {
      if (type === 'mult' && !this.ids.length) {
        this.msgInfo('请选择要删除项！')
        return
      }
      const ids = id || this.ids.join(',')
      this.$confirm('是否确定删除当前问卷？该操作同步删除所有数据，且不可恢复，请谨慎操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteInfoToSurvey(ids)
        })
        .then(() => {
          this.search()
          this.msgSuccess('删除成功')
        })
        .catch(function () {})
    },
    download(id, userName, qrName) {
      let name = userName + '-' + qrName + '.png'
      downloadBatch(id).then((res) => {
        if (res != null) {
          let blob = new Blob([res], {
            type: 'application/zip',
          })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = name // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    /** 下载 */
    downloadBatch(qrCode) {
      if (!this.ids.length) {
        this.msgInfo('请先勾选下载项！')
        return
      }
      this.$confirm('是否确认下载所有图片吗?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return downloadBatch(this.ids.join(','))
        })
        .then((res) => {
          if (res != null) {
            let blob = new Blob([res], {
              type: 'application/zip',
            })
            let url = window.URL.createObjectURL(blob)
            const link = document.createElement('a') // 创建a标签
            link.href = url
            link.download = '批量员工活码.zip' // 重命名文件
            link.click()
            URL.revokeObjectURL(url) // 释放内存
          }
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
            mediaType: groupForm.mediaType,
          }
          this.groupForm = obj
        }
        if (validate) {
          ;(this.groupForm.id ? updateCodeCategory : addCodeCategory)(this.groupForm).then((res) => {
            this.groupVisible = false
            this.groupForm = JSON.parse(JSON.stringify(groupForm))
            this.$refs.groupForm.clearValidate()
            this.msgSuccess('操作成功')
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
      let that = this
      this.$confirm('是否确认删除当前分组，删除后所有表单将设置为默认分组，该操作不可撤销，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          let data = {
            groupId: id,
            newGroupId: that.newGroupId,
          }
          console.log('updateSurveyGroup')
          removeCodeCategory(id).then((res) => {
            this.msgSuccess('操作成功')
            that.getCodeCategoryListFn()
          })
          // updateSurveyGroup(that.$qs.stringify(data)).then((res) => {
          // })
        })
        .catch(() => {})
    },
  },
}
</script>

<style lang="scss" scoped>
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
