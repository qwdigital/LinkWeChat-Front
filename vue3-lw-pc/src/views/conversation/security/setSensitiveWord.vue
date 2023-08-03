<!-- 敏感词设置页面 -->
<template>
  <div class="add-sensitive-word">
    <div class="g-card">
      <div class="mid-action">
        <el-input v-model="form.patternWords" placeholder="搜索关键词" style="width: 300px;">
          <template #append><el-button icon="el-icon-search" @click="getSettingList"></el-button></template>
        </el-input>
        <el-button type="primary" class="add-btn" @click="addSensitive">添加敏感词</el-button>
      </div>

      <el-table :data="tableData">
        <el-table-column prop="strategyName" label="策略名称"></el-table-column>
        <el-table-column prop="patternWords" label="匹配词"></el-table-column>
        <el-table-column prop="auditScopeName" label="审计范围">
          <template #default="{ row }">
            <template v-if="row.auditUserScope && row.auditUserScope.length">
              <TagEllipsis :list="row.auditUserScope[0].auditScopeName.split(',')"></TagEllipsis>
            </template>
            <template v-else>全体成员</template>
          </template>
        </el-table-column>
        <el-table-column prop="auditUserName" label="审计人"></el-table-column>
        <el-table-column label="消息通知">
          <template #default="scope">
            <el-switch
              v-model="scope.row.alertFlag"
              :active-value="1"
              :inactive-value="0"
              @change="handleStatusChange(scope.row)"
            ></el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="scope">
            <el-button text @click="handleUpdate(scope.row)">修改</el-button>
            <el-button text @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="query.pageNum"
        v-model:limit="query.pageSize"
        @pagination="getSettingList()"
      />
    </div>

    <!-- 添加敏感词 -->
    <el-dialog title="添加敏感词" v-model="open" width="600px" append-to-body :close-on-click-modal="false">
      <el-form ref="addForm" :model="addForm" :rules="rules" label-width="130px">
        <el-form-item label="敏感词策略名称" prop="strategyName">
          <el-input v-model="addForm.strategyName" placeholder="例：红包" />
        </el-form-item>
        <el-form-item label="匹配词" prop="patternWords">
          <el-input v-model="addForm.patternWords" placeholder="例：红包,hongbao,hb" />
          <div class="sub-title">匹配词间用逗号隔开</div>
        </el-form-item>
        <el-form-item label="审计范围" :error="rangeErrorMsg">
          <div class="tag-input" style="width: auto;" @click="openAuditUserRange">
            <span class="tag-place" v-if="!auditUserRange.length">
              请选择
              <span class="prompt-title">若不选择，则默认全体成员</span>
            </span>
            <template v-else>
              <el-tag type="info" v-for="(unit, unique) in auditUserRange" :key="unique">{{ unit.name }}</el-tag>
            </template>
          </div>
        </el-form-item>
        <el-form-item label="审计人" :required="true" :error="errorMsg">
          <div class="tag-input" style="width: auto;" @click="openAuditUser">
            <span class="tag-place" v-if="!auditUser.length">
              请选择
              <span class="prompt-title">请选择部门负责人</span>
            </span>
            <template v-else>
              <el-tag type="info" v-for="(unit, unique) in auditUser" :key="unique">{{ unit.name }}</el-tag>
            </template>
          </div>
        </el-form-item>
        <el-form-item label="消息通知">
          <el-switch v-model="alertFlag" :active-value="1" :inactive-value="0"></el-switch>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="addSensitiveForm">确 定</el-button>
          <el-button @click="open = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    <!-- 选择审计范围弹窗 -->
    <SelectUser v-model:visible="dialogVisibleSelectUser" title="选择添加人" @success="selectedUser"></SelectUser>
    <!-- 选择审计人弹窗 -->
    <SelectUser
      v-model:visible="dialogVisibleSelectAuditUser"
      title="选择添加人"
      isSigleSelect
      @success="selectedAuditUser"
    ></SelectUser>
  </div>
</template>
<script>
  import * as sensitiveApis from '@/api/conversation/security'

  export default {
    components: {},
    data() {
      return {
        form: {
          pageSize: 10,
          pageNum: 1,
          patternWords: '' // 关键词
        },
        addForm: {
          strategyName: '', // 策略名称
          patternWords: '' // 匹配词
        },
        alertFlag: 0, // 消息通知
        tableData: [], // 敏感词列表
        errorMsg: '', // 审计人错误提示
        rangeErrorMsg: '', // 审计范围错误提示
        query: {
          pageNum: 1,
          pageSize: 10
        },
        auditUserRange: [], // 审计范围
        auditUser: [], // 审计人
        total: 0,
        dialogVisibleSelectUser: false, // 是否显示审计范围
        dialogVisibleSelectAuditUser: false, // 是否显示审计人
        open: false, // 是否显示添加敏感词弹框
        submitFlag: '', // 添加或者修改
        rowId: '', // 修改的数据id
        rules: {
          strategyName: [{ required: true, message: '敏感词策略不能为空', trigger: 'blur' }],
          patternWords: [{ required: true, message: '匹配词不能为空', trigger: 'blur' }]
        }
      }
    },
    mounted() {
      this.getSettingList()
    },
    methods: {
      // 获取敏感词设置列表
      getSettingList() {
        this.form.pageSize = this.query.pageSize
        this.form.pageNum = this.query.pageNum
        sensitiveApis.getSettingSensitiveList(this.form).then((res) => {
          if (res.code === 200) {
            this.tableData = res.rows
            this.total = Number(res.total)
          }
        })
      },
      // 提交敏感词表单
      addSensitiveForm() {
        // console.log(this.auditUser)
        this.$refs.addForm.validate((valid) => {
          if (valid) {
            // if (this.auditUserRange.length === 0) {
            //   this.rangeErrorMsg = '请选择审计范围'
            //   return
            // } else {
            //   this.rangeErrorMsg = ''
            // }
            if (this.auditUser.length === 0) {
              this.errorMsg = '请选择审计人'
              return
            } else {
              this.rangeErrorMsg = ''
            }
            const params = this.addForm
            if (this.auditUserRange.length) {
              let auditUserScope = []
              const obj = {
                scopeType: 2, // this.auditUserRange.map((d) => d.department) + '',
                auditScopeId: this.auditUserRange.map((d) => d.userId) + '',
                auditScopeName: this.auditUserRange.map((d) => d.name) + ''
              }
              auditUserScope.push(obj)
              params.auditUserScope = auditUserScope
            } else {
              params.auditUserScope = []
            }
            params.auditUserId = this.auditUser.map((d) => d.userId) + ''
            params.auditUserName = this.auditUser.map((d) => d.name) + ''
            params.alertFlag = this.alertFlag
            if (this.submitFlag === 'add') {
              sensitiveApis.addSettingSensitive(params).then((res) => {
                if (res.code === 200) {
                  this.open = false
                  this.getSettingList()
                }
              })
            }
            if (this.submitFlag === 'modify') {
              params.id = this.rowId
              sensitiveApis.modifySettingSensitive(params).then((res) => {
                if (res.code === 200) {
                  this.open = false
                  this.getSettingList()
                }
              })
            }
          }
        })
      },
      // 打开审计范围
      openAuditUserRange() {
        this.dialogVisibleSelectUser = true
      },
      // 打开审计人
      openAuditUser() {
        this.dialogVisibleSelectAuditUser = true
      },
      resetForm() {
        this.addForm = {
          strategyName: '',
          patternWords: ''
        }
        this.auditUserRange = [] // 审计范围
        this.auditUser = []
        this.alertFlag = 0
        this.errorMsg = ''
      },
      // 添加敏感词
      addSensitive() {
        this.submitFlag = 'add'
        this.resetForm()
        this.open = true
      },
      selectedUser(list) {
        // console.log(list)
        this.auditUserRange = list
        // this.form.scopeType = list.map(d => d.department) + ""
        // this.form.auditScopeId = list.map(d => d.userId) + ""
      },
      selectedAuditUser(list) {
        this.auditUser = list
      },
      // 修改敏感词
      handleUpdate(row) {
        console.log(row)
        this.submitFlag = 'modify'
        this.errorMsg = ''
        this.rowId = row.id
        sensitiveApis.getSensitiveDetails(this.rowId).then((res) => {
          if (res.code === 200) {
            this.addForm.strategyName = res.data.strategyName
            this.addForm.patternWords = res.data.patternWords
            this.auditUser = [
              {
                name: res.data.auditUserName,
                userId: res.data.auditUserId
              }
            ]
            if (res.data.auditUserScope.length) {
              this.auditUserRange = [
                {
                  name: res.data.auditUserScope[0].auditScopeName,
                  userId: res.data.auditUserScope[0].auditScopeId,
                  department: res.data.auditUserScope[0].scopeType
                }
              ]
            } else {
              this.auditUserRange = []
            }
            this.alertFlag = res.data.alertFlag
          }
        })
        this.open = true
      },
      // 删除敏感词
      handleDelete(row) {
        this.$confirm('是否确认删除吗?', '警告', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }).then(() => {
          return sensitiveApis.deleteSensitive(row.id).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('删除成功')
              this.getSettingList()
            }
          })
        })
      },
      handleStatusChange(row) {
        sensitiveApis.modifySettingSensitive(row).then((res) => {
          if (res.code === 200) {
            this.msgSuccess('操作成功')
            this.getSettingList()
          }
        })
      }
    }
  }
</script>
<style lang="scss" scoped>
  .content {
    margin-top: 15px;
    padding: 10px;
  }
  .prompt-title {
    margin-left: 10px;
    color: var(--font-black-6);
  }
  .tag-place {
    color: var(--color);
  }
  .sub-title {
    font-size: 13px;
    color: var(--font-black-6);
  }
</style>
