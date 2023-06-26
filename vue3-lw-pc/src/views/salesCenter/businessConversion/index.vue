<template>
  <div>
    <div class="g-card">
      <div class="g-card-title mid-action">
        <el-button type="primary" @click="setField">新建阶段</el-button>
      </div>
      <el-table ref="table" row-key="id" :data="list" v-loading="loading" :row-class-name="rowClassRender">
        <el-table-column label="" width="50" align="left">
          <template #default="{ row }">
            <svg-icon v-if="row.stageState == 2" icon="dragIcon" />
          </template>
        </el-table-column>
        <el-table-column label="阶段名称" align="center" prop="stageKey"></el-table-column>
        <el-table-column label="阶段描述" align="center" prop="stageDesc"></el-table-column>
        <el-table-column label="阶段状态" align="center" prop="stageState">
          <template #default="{ row }">
            {{ setValue(row.stageState) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200" fixed="right">
          <template #header><div>操作</div></template>
          <template #default="{ row }">
            <el-button text :disabled="row.isDefault == 1 && row.stageState != 2" @click="editFn(row)">编辑</el-button>
            <el-button text :disabled="row.isDefault == 1 && row.stageState != 2" @click="deleteFn(row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-dialog title="提示" v-model="delObj.show" :close-on-click-modal="false">
      <div>
        <span>
          当前共有【{{ delObj.num }}】个客户正处于【{{
            delObj.stageKey
          }}】阶段，删除阶段需要为这些客户分配一个新状态，分配后立即生效且不可撤销，请谨慎操作。
        </span>
        <el-form ref="form" :rules="rules" :model="form" label-position="left" label-width="120px">
          <el-form-item label="新阶段">
            <el-select v-model="delObj.newStage">
              <template v-for="(item, index) in list" :key="index">
                <el-option :label="item.stageKey" :value="item.stageVal"></el-option>
              </template>
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <div>
          <el-button @click="delObj.show = false">取 消</el-button>
          <el-button type="primary" @click="deleteSubmit">确 定</el-button>
        </div>
      </template>
    </el-dialog>
    <el-dialog :title="dialog.title" v-model="dialog.show" :close-on-click-modal="false">
      <div>
        <el-form ref="form" :rules="rules" :model="form" label-position="left" label-width="120px">
          <el-form-item label="阶段名称" prop="stageKey">
            <el-input
              style="width: 250px"
              v-model="form.stageKey"
              placeholder="请输入阶段名称"
              maxlength="10"
              show-word-limit></el-input>
          </el-form-item>
          <el-form-item label="阶段描述" prop="stageDesc">
            <el-input
              style="width: 250px"
              type="textarea"
              v-model="form.stageDesc"
              placeholder="请输入阶段描述"></el-input>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <div>
          <el-button @click="dialog.show = false">取 消</el-button>
          <el-button type="primary" @click="submit">确 定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>
<script>
import Sortable from 'sortablejs'
import {
  getList,
  addField,
  updateField,
  deleteField,
  multiField,
  getCustomerNum,
} from '@/api/salesCenter/businessConver.js'
export default {
  name: 'business-conversion-attr',
  components: {},
  data() {
    return {
      dialogVisible: false,
      loading: false,
      list: [],
      dialog: {
        title: '新建阶段',
        state: 'add',
        show: false,
      },
      form: {
        stageKey: '',
        stageDesc: '',
      },
      rules: {
        stageKey: [
          {
            required: true,
            message: '阶段名称不能为空',
            trigger: 'blur',
          },
        ],
        stageDesc: [
          {
            required: true,
            message: '阶段描述不能为空',
            trigger: 'blur',
          },
        ],
      },
      infoType: [
        { name: '待跟进', key: 1 },
        { name: '跟进中', key: 2 },
        { name: '已结束', key: 3 },
      ],
      deleteId: null,
      delObj: {
        show: false,
        num: null,
        stageKey: '',
        stageVal: '',
        newStage: '',
      },
      addId: '',
    }
  },
  methods: {
    rowClassRender({ row }) {
      if (row.stageState == 2) {
        return 'item'
      } else {
        return ''
      }
    },
    setValue(data) {
      let str = ''
      this.infoType.forEach((dd) => {
        if (dd.key == data) {
          str = dd.name
        }
      })
      return str
    },
    updateSort() {
      this.list.forEach((item, index) => {
        item.sort = index + 1
      })
      updateField(this.list)
    },
    dragSort() {
      const el = this.$refs.table.$el.querySelectorAll('.el-table__body-wrapper table > tbody')[0]
      this.sortable = Sortable.create(el, {
        draggable: '.item',
        ghostClass: 'sortable-ghost',
        setData: function (dataTransfer) {
          dataTransfer.setData('Text', '')
        },
        onEnd: (e) => {
          if (e.oldIndex !== e.newIndex) {
            const targetRow = this.list.splice(e.oldIndex, 1)[0]
            this.list.splice(e.newIndex, 0, targetRow)
            this.updateSort()
          }
        },
      })
    },
    deleteSubmit() {
      if (!this.delObj.newStage) {
        this.msgError('请选择新阶段！')
        return
      }
      deleteField({ id: this.deleteId, growStageVal: this.delObj.stageVal })
        .then((res) => {
          this.msgSuccess('操作成功！')
          this.delObj.show = false
          this.getList('delete')
        })
        .catch(() => {
          this.msgError('操作失败！')
          this.delObj.show = false
        })
    },
    deleteFn(data) {
      this.delObj = {
        show: false,
        num: null,
        stageKey: data.stageKey,
        stageVal: data.stageVal,
        newStage: '',
      }
      this.deleteId = data.id
      getCustomerNum(data.stageVal).then((res) => {
        if (res.data.customerNumbwe) {
          this.delObj.num = res.data.customerNumbwe
          this.delObj.show = true
        } else {
          this.$confirm(`是否删除【${data.stageKey}】阶段？删除后立即生效且不可撤销，请谨慎操作。`, '删除', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
          })
            .then(() => {
              deleteField({ id: data.id }).then((res) => {
                this.msgSuccess('操作成功！')
                this.getList('delete')
              })
            })
            .catch(() => {})
        }
      })
    },
    editFn(data) {
      this.form = data
      this.dialog.show = true
    },
    submit() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.form.id ? '' : (this.form.sort = this.list.length + 1)
          ;(this.form.id ? updateField : addField)(this.form.id ? [this.form] : this.form)
            .then((res) => {
              if (!this.form.id) {
                this.addId = res.data.id
              }
              this.getList(1)
              this.msgSuccess('操作成功！')
              this.dialog.show = false
            })
            .catch((err) => {
              this.msgError('操作失败！')
              this.dialog.show = false
            })
        }
      })
    },
    resetSort() {
      let list = JSON.parse(JSON.stringify(this.list))
      let obj = {}
      list.forEach((data, index) => {
        if (data.id == this.addId) {
          obj = data
          list.splice(index, 1)
        }
      })
      let order = list.findLastIndex((x) => x.stageState == 2)
      if (order !== -1) {
        list.splice(order + 1, 0, obj)
      } else {
        list.splice(1, 0, obj)
      }
      this.list = JSON.parse(JSON.stringify(list))
      this.addId = ''
      this.updateSort()
    },
    setField(type) {
      this.form = {
        stageKey: '',
      }
      this.dialog.show = true
    },
    newInputConfirm() {
      // let name = this.newInput
      // if (name) {
      //   Array.isArray(this.form.otherContent) || (this.form.otherContent = [])
      //   let isExist = this.form.otherContent.some((e) => {
      //     return e.labelName === name
      //   })
      //   if (isExist) {
      //     this.msgError('内容项已存在，不可重复添加')
      //     return
      //   }
      //   this.form.otherContent.push({ labelName: name })
      // }
    },
    getList(type) {
      this.loading = true
      getList(this.query).then((res) => {
        this.loading = false
        this.list = res.data
        if (type == 'init') {
          this.dragSort()
        }
        if (type == 'delete') {
          this.updateSort()
        }
        if (this.addId) {
          this.resetSort()
        }
      })
    },
  },
  mounted() {
    this.getList('init')
  },
  created() {
    this.$store.setBusininessDesc(
      `
          <div>可自定义修改企业客户的画像信息项供企业个性化使用</div>
        `,
    )
  },
}
</script>
<style lang="scss" scoped>
.sub-des {
  font-size: 12px;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: var(--font-black-6);
}
</style>
