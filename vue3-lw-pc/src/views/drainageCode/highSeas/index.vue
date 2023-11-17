<template>
  <div>
    <el-form :model="query" label-position="left" ref="queryForm" :inline="true" label-width="70px" class="top-search">
      <el-form-item label="电话" prop="phone" label-width="40px">
        <el-input v-model="query.phone" placeholder="请输入电话" clearable @keyup.enter="getList(1)" />
      </el-form-item>
      <el-form-item label="客户备注名" prop="customerName" label-width="90px">
        <el-input v-model="query.customerName" placeholder="请输入客户备注名" clearable @keyup.enter="getList(1)" />
      </el-form-item>
      <el-form-item label="员工名" prop="addUserName">
        <el-input v-model="query.addUserName" placeholder="请输入员工名" clearable @keyup.enter="getList(1)" />
      </el-form-item>
      <el-form-item label="添加状态" prop="addState">
        <el-select clearable v-model="query.addState">
          <el-option label="待添加" :value="0"></el-option>
          <el-option label="已添加" :value="1"></el-option>
          <el-option label="待通过" :value="3"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="0">
        <!-- v-hasPermi="['wecom:code:list']" -->
        <el-button type="primary" @click="getList(1)">查询</el-button>
        <el-button @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <div class="g-card">
      <div class="mid-action">
        <el-button type="primary" @click="importDialogVisible = true">导入客户</el-button>
        <div>
          <el-button type="primary" plain @click="removeMult()">批量删除</el-button>
          <el-button type="primary" plain @click="tipMulFn">批量提醒</el-button>
        </div>
      </div>
      <el-table ref="myTable" v-loading="loading" :data="list" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="电话号码" align="center" prop="phone" min-width="180px" show-overflow-tooltip />
        <el-table-column label="客户备注姓名" align="center" prop="customerName" show-overflow-tooltip />
        <el-table-column label="客户标签" align="center" prop="tagNames" min-width="180px" show-overflow-tooltip>
          <template #default="{ row }">
            <div v-if="row.tagNames">
              <TagEllipsis :list="row.tagNames.split(',')" />
            </div>
          </template>
        </el-table-column>
        <el-table-column label="分配员工" align="center" prop="addUserName" />
        <el-table-column label="当前状态" align="center" prop="addState">
          <template #default="{ row }">
            <el-tag v-if="row.addState === 0" type="danger">待添加</el-tag>
            <el-tag v-if="row.addState === 1" type="success">已添加</el-tag>
            <el-tag v-if="row.addState === 3" type="warning">待通过</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="导入时间" align="center" prop="createTime" width="180"></el-table-column>
        <el-table-column label="操作" align="center">
          <template #default="{ row }">
            <el-button v-if="row.addState == 0" text @click="tipFn(row.id)">提醒</el-button>
            <el-button text @click="removeFn(row.id)">删除</el-button>
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

    <!-- <div v-if="dialogVisible"> -->
    <!-- 批量新建弹窗 -->
    <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisible"
      title="选择员工"
      @success="selectedUserFn"></SelectUser>
    <!-- </div> -->
    <div v-if="dialogVisibleSelectTag">
      <SelectTag
        v-model:visible="dialogVisibleSelectTag"
        :selected="selectedTagList"
        @success="submitSelectTagFn"></SelectTag>
    </div>

    <el-dialog
      title="导入客户"
      :close-on-click-modal="false"
      :show-close="false"
      v-model="importDialogVisible"
      width="40%">
      <el-form ref="importForm" :model="form" :rules="formRules" label-position="right">
        <el-form-item label="选择表格" prop="file" required>
          <div style="display: flex">
            <el-upload
              accept=".xls, .xlsx"
              :action="actionUrl"
              :limit="1"
              :headers="headers"
              ref="upload"
              :on-remove="handleRemove"
              :on-change="setFileData"
              :auto-upload="false">
              <el-button type="primary" plain @click="clearData()">上传表格</el-button>
            </el-upload>
            <el-button style="margin-left: 10px; flex: 0" text plain @click="downloadFn">下载模板</el-button>
          </div>
        </el-form-item>
        <el-form-item label="选择员工" prop="weCustomerStaffs" required>
          <el-tag v-for="(data, index) in form.weCustomerStaffs" :key="index">{{ data.staffName }}</el-tag>
          <el-button type="primary" plain @click="selectUserFn">
            {{ form.weCustomerStaffs.length ? '编辑' : '选择' }}员工
          </el-button>
          <div class="sub-des">公海客户平均分配给选择的员工</div>
        </el-form-item>
        <el-form-item label="新客户标签" prop="customerSeasTags">
          <template v-for="(data, index) in form.customerSeasTags" :key="index">
            <el-tag v-if="data.tagName">{{ data.tagName }}</el-tag>
          </template>
          <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
          <div class="sub-des">添加成功后，该客户系统添加此标签</div>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click=";(importDialogVisible = false), clearData()">取 消</el-button>
          <el-button type="primary" @click="submitImport" v-loading="submitLoading">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { getList, downloadTemplate, remove, upload, detail, alertFn } from '@/api/drainageCode/seas'
import { download } from '@/utils/common'

export default {
  name: 'CodeStaff',
  components: {},
  data() {
    return {
      submitLoading: false,
      headers: window.lwConfig.headers,
      currentActive: 'sea',
      importDialogVisible: false,
      dialogVisibleSelectTag: false,
      // 查询参数
      query: {
        pageNum: 1,
        pageSize: 10,
        customerName: undefined,
        phone: undefined,
        addUserName: undefined,
        addState: undefined,
      },
      // 日期范围
      dateRange: [],
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
        customerSeasTags: [],
        weCustomerStaffs: [],
      },
      formRules: {},
      selectedUserList: [],
      actionUrl: '...',
      selectedTagList: [],
    }
  },
  created() {
    this.getList()
    this.$store.setBusininessDesc(
      `
			     <div>管理员在后台将客户导入后，系统根据分配规则自动分配给员工，员工可以一键复制客户手机号，快速添加客户，并支持添加效果统计。</div>
			   `,
    )
  },
  mounted() {},
  methods: {
    clearData() {
      this.$refs.upload.clearFiles()
      this.form.file = ''
    },
    submitImport() {
      if (!this.form.file) {
        this.msgError('请先上传表格！')
        return false
      }
      if (!this.form.weCustomerStaffs.length) {
        this.msgError('请先选择员工！')
        return false
      }
      let obj = {
        file: this.form.file,
        addUserId: this.form.weCustomerStaffs
          .map((dd) => {
            return dd.staffId
          })
          .join(','),
        addUserName: this.form.weCustomerStaffs
          .map((dd) => {
            return dd.staffName
          })
          .join(','),
        tagIds: this.form.customerSeasTags.length
          ? this.form.customerSeasTags
              .map((dd) => {
                return dd.tagId
              })
              .join(',')
          : '',
        tagNames: this.form.customerSeasTags.length
          ? this.form.customerSeasTags
              .map((dd) => {
                return dd.tagName
              })
              .join(',')
          : '',
      }
      this.submitLoading = true
      upload(this.toFormData(obj))
        .then((res) => {
          if (res.code === 200) {
            // this.msgSuccess(res.msg)
            this.form = {
              file: {},
              customerSeasTags: [],
              weCustomerStaffs: [],
            }
            this.selectedUserList = []
            this.selectedTagList = []
            this.getList()
            this.msgSuccess(res.data)
            this.importDialogVisible = false
          } else {
            this.msgError(res.msg)
          }
          this.submitLoading = false
        })
        .catch(() => {})
    },
    toFormData(val) {
      let formData = new FormData()
      for (let i in val) {
        isArray(val[i], i)
      }

      function isArray(array, key) {
        if (array == undefined || typeof array == 'function') {
          return false
        }
        if (typeof array != 'object') {
          formData.append(key, array)
        } else if (array instanceof Array) {
          if (array.length !== 0) {
            for (let i in array) {
              for (let j in array[i]) {
                isArray(array[i][j], `${key}[${i}].${j}`)
              }
            }
          }
        } else {
          let arr = Object.keys(array)
          if (arr.indexOf('uid') == -1) {
            for (let j in array) {
              isArray(array[j], `${key}.${j}`)
            }
          } else {
            formData.append(`${key}`, array)
          }
        }
      }
      console.log(formData)
      return formData
    },
    submitSelectTagFn(data) {
      this.form.customerSeasTags = data.map((d) => ({
        tagId: d.tagId,
        tagName: d.name,
      }))
    },
    selectedFn() {
      if (this.form.customerSeasTags) {
        this.selectedTagList = this.form.customerSeasTags.map((dd) => ({
          tagId: dd.tagId,
          name: dd.tagName,
        }))
      }
      this.dialogVisibleSelectTag = true
    },
    selectUserFn() {
      this.selectedUserList = []
      let arr = []
      arr = this.form.weCustomerStaffs.map((dd) => {
        return {
          userId: dd.staffId,
          name: dd.staffName,
        }
      })
      this.selectedUserList = arr
      this.dialogVisible = true
    },
    selectedUserFn(users) {
      const selectedUserList = users.map((d) => {
        return {
          staffId: d.id || d.userId,
          staffName: d.name,
        }
      })
      this.form.weCustomerStaffs = selectedUserList
    },
    setFileData(f, fl) {
      this.form.file = f.raw
    },
    handleRemove() {
      this.form.file = ''
    },
    downloadFn() {
      downloadTemplate().then((res) => {
        if (res != null) {
          let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = '模板.xlsx' //指定下载文件名
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    getList(page) {
      page && (this.query.pageNum = page)
      this.loading = true
      getList(this.query)
        .then(({ rows, total }) => {
          this.list = rows
          this.total = +total
          this.loading = false
          this.ids = []
        })
        .catch(() => {
          this.loading = false
        })
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = []
      this.$refs['queryForm'].resetFields()
      this.getList(1)
    },
    goRoute(path, id) {
      this.$router.push({
        path: path,
        query: {
          id,
        },
      })
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id)
    },
    /** 删除按钮操作 */
    removeFn(id) {
      this.$confirm('是否确认删除?', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(
        () => {
          remove(id).then((res) => {
            if (res.code === 200) {
              this.getList()
              this.msgSuccess('删除成功')
            } else {
              this.msgError(res.msg)
            }
          })
        },
        () => {},
      )
    },
    removeMult() {
      if (this.ids.length) {
        this.$confirm('是否确认删除?', '警告', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(
          () => {
            remove(this.ids.join(',')).then((res) => {
              if (res.code === 200) {
                this.getList()
                this.msgSuccess('删除成功')
              } else {
                this.msgError(res.msg)
              }
            })
          },
          () => {},
        )
      } else {
        this.msgInfo('请先勾选要操作项！')
      }
    },
    tipFn(id) {
      this.$confirm('是否确定发送员工跟进客户提醒？确定后提醒将发送至对应员工', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(
        () => {
          alertFn(id).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('提醒成功！')
            } else {
              this.msgError(res.msg)
            }
          })
        },
        () => {},
      )
    },
    tipMulFn() {
      if (this.ids.length) {
        this.$confirm('是否确定发送员工跟进客户提醒？确定后提醒将发送至对应员工', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(
          () => {
            alertFn(this.ids.join(',')).then((res) => {
              if (res.code === 200) {
                this.msgSuccess('提醒成功！')
                this.ids = []
                this.$refs.myTable.clearSelection()
              } else {
                this.msgError(res.msg)
              }
            })
          },
          () => {},
        )
      } else {
        this.msgInfo('请先勾选要操作项！')
      }
    },
  },
}
</script>

<style lang="scss" scoped>
::v-deep .el-tabs__header {
  margin-bottom: 0;
}

.divider-content {
  width: 100%;
  height: 10px;
  background-color: var(--bg-black-11);
}

.my-divider {
  display: block;
  height: 1px;
  width: 100%;
  background-color: var(--bg-black-9);
}

.bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}

.total-item {
  // width: 200px;
  padding: 20px;
  background: linear-gradient(90deg, #3c89f0 0%, #1364f4 100%);
  border-radius: 4px;
  .name {
    font-size: 14px;

    font-weight: 400;
    color: var(--font-white, #fff);
  }
  .value {
    margin-top: 5px;
    font-size: 18px;

    font-weight: 400;
    color: var(--font-white, #fff);
  }
}

.table-header {
  font-size: 16px;

  font-weight: 500;
  color: var(--font-black);
  margin-bottom: 20px;
}
</style>
