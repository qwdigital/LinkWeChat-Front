<template>
  <div>
    <el-form ref="queryForm" :model="query" inline class="top-search" label-position="left">
      <el-form-item label="">
        <el-input v-model="query.labelName" placeholder="请输入信息项名称"></el-input>
      </el-form-item>
      <el-form-item label="">
        <el-select :popper-append-to-body="false" v-model="query.type" placeholder="请选择信息项类型">
          <el-option v-for="(item, index) in infoType" :key="index" :label="item.name" :value="item.key"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <div class="tag-input" @click="dialogVisible = true">
          <span class="tag-place" v-if="!queryTag.length">请选择</span>
          <template v-else>
            <el-tag v-for="(unit, unique) in queryTag" :key="unique">{{ unit.name }}</el-tag>
          </template>
        </div>
      </el-form-item>
      <el-form-item label=" ">
        <el-button type="primary" @click="getList">查询</el-button>
        <el-button @click="resetQuery">清空</el-button>
      </el-form-item>
    </el-form>
    <div class="g-card">
      <div class="g-card-title mid-action">
        <el-button type="primary" @click="setField">新建信息项</el-button>
      </div>
      <el-table ref="table" row-key="id" :data="list" v-loading="loading">
        <el-table-column label="" width="50" align="left">
          <svg-icon icon="dragIcon" style="cursor: move" />
        </el-table-column>
        <el-table-column label="信息项名称" align="center" prop="labelName"></el-table-column>
        <el-table-column label="信息项类型" align="center">
          <template #default="{ row }">
            {{ setValue(row.type) }}
          </template>
        </el-table-column>
        <el-table-column label="客户标签" align="center">
          <template #default="{ row }">
            <div v-if="row.visualTagIds">
              <el-tag>{{ row.visualTagName }}</el-tag>
            </div>
            <div v-else>全部客户</div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200" fixed="right">
          <template #header>
            <div>
              操作
              <el-popover trigger="hover">
                可通过拖动操作移动信息项排名，移动后会同步影响员工手机端查看的客户信息先后排序。
                <template #reference>
                  <el-icon-QuestionFilled class="el-icon-QuestionFilled"></el-icon-QuestionFilled>
                </template>
              </el-popover>
            </div>
          </template>
          <template #default="{ row }">
            <el-button text :disabled="row.isDefault == 1" @click="editFn(row)">编辑</el-button>
            <el-button text :disabled="row.isDefault == 1" @click="deleteFn(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <!-- 选择标签弹窗 -->
    <SelectTag ref="selectTag" v-model:visible="dialogVisible" title="选择标签" @success="querySelectFn"></SelectTag>

    <el-dialog :title="dialog.title" v-model="dialog.show" :close-on-click-modal="false">
      <div>
        <el-form ref="form" :rules="rules" :model="form" label-position="left" label-width="120px">
          <el-form-item label="信息项名称" prop="labelName">
            <el-input
              style="width: 250px"
              v-model="form.labelName"
              placeholder="请输入信息项名称"
              maxlength="10"
              show-word-limit></el-input>
          </el-form-item>
          <el-form-item label="选择标签">
            <div class="sub-des">选择后则打上此标签的客户会增加此信息项供成员填写，如为空则全部客户都增加此信息项</div>
            <template v-for="(item, index) in tagList" :key="index">
              <el-tag v-if="item.name">{{ item.name }}</el-tag>
            </template>
            <div>
              <el-button type="primary" icon="el-icon-plus" @click="showSelectTag = true">
                {{ tagList.length ? '编辑' : '添加' }}标签
              </el-button>
            </div>
          </el-form-item>
          <el-form-item label="信息项属性" prop="type">
            <el-radio-group v-model="form.type" @change="setChange">
              <el-radio :label="1">文本</el-radio>
              <el-radio :label="2">时间</el-radio>
              <el-radio :label="3">勾选项</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="勾选项性质" prop="typeSub" v-if="form.type == 3">
            <el-radio-group v-model="form.typeSub">
              <el-radio :label="1">单选</el-radio>
              <el-radio :label="2">多选</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="勾选项内容" prop="otherContent" v-if="form.type == 3">
            <template v-for="(item, index) in form.otherContent" :key="index">
              <el-tag type="primary" closable @close="closeTag(item, index)">
                {{ item.labelName }}
              </el-tag>
            </template>
            <el-input
              style="margin-left: 10px; width: 200px"
              class="input-new-tag"
              v-if="visibleAdd"
              v-model.trim="newInput"
              ref="saveTagInput"
              maxlength="10"
              show-word-limit
              @keyup.enter="newInputConfirm"
              @blur="newInputConfirm"></el-input>
            <el-button v-else style="margin-left: 10px" type="primary" plain class="button-new-tag" @click="showInput">
              + 添加内容项
            </el-button>
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

    <SelectTag
      ref="selectTag"
      v-model:visible="showSelectTag"
      title="选择标签"
      :selected="tagList"
      @success="submitSelectTag"
      :isSingle="true"></SelectTag>
  </div>
</template>
<script>
import Sortable from 'sortablejs'
import { getList, addField, updateField, deleteField, multiField } from '@/api/customer/defineAttr.js'
export default {
  name: 'define-customer-attr',
  components: {},
  data() {
    return {
      queryTag: [],
      dialogVisible: false,
      loading: false,
      infoType: [
        { name: '文本', key: 1 },
        { name: '时间', key: 2 },
        { name: '勾选项', key: 3 },
      ],
      query: {
        labelName: '',
        type: null,
        visualTagIds: '',
      },
      list: [],
      dialog: {
        title: '新建信息项',
        state: 'add',
        show: false,
      },
      tagList: [],
      showSelectTag: false,
      form: {
        labelName: '',
        businessType: 1,
        visualTagIds: '',
        type: 1,
        // typeSub: 1,
        otherContent: [],
      },
      visibleAdd: false,
      newInput: '',
      rules: {
        labelName: [
          {
            required: true,
            message: '信息项名称不能为空',
            trigger: 'blur',
          },
        ],
        type: [
          {
            required: true,
            message: '信息项属性不能为空',
            trigger: 'blur',
          },
        ],
        typeSub: [
          {
            required: true,
            message: '勾选项性质不能为空',
            trigger: 'blur',
          },
        ],
        otherContent: [
          {
            required: true,
            message: '勾选项内容不能为空',
            trigger: 'blur',
          },
        ],
      },
    }
  },
  methods: {
    updateSort() {
      this.list.forEach((item, index) => {
        item.labelSort = this.list.length - index
      })
      multiField(this.list)
    },
    closeTag(data, index) {
      this.form.otherContent.splice(index, 1)
    },
    dragSort() {
      const el = this.$refs.table.$el.querySelectorAll('.el-table__body-wrapper table > tbody')[0]
      this.sortable = Sortable.create(el, {
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
    setValue(data) {
      let str = ''
      this.infoType.forEach((dd) => {
        if (dd.key == data) {
          str = dd.name
        }
      })
      return str
    },
    deleteFn(data) {
      this.$confirm('是否确认删除当前画像信息项？该操作不可恢复，请谨慎操作。', '删除', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          deleteField(data.id).then((res) => {
            this.getList('delete')
          })
        })
        .catch(() => {})
    },
    editFn(data) {
      this.form = data
      if (this.form.visualTagIds) {
        this.tagList = [
          {
            tagId: this.form.visualTagIds,
            name: this.form.visualTagName,
          },
        ]
      }
      this.dialog.show = true
    },
    setChange(type) {
      if (type !== 3) {
        delete this.form.typeSub
        this.form.otherContent = []
      }
    },
    submit() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.form.id ? '' : (this.form.labelSort = this.list.length + 1)
          ;(this.form.id ? updateField : addField)(this.form)
            .then((res) => {
              this.getList(1)
              this.msgSuccess('操作成功！')
              this.dialog.show = false
            })
            .catch((err) => {
              this.msgError('操作失败！')
            })
        }
      })
    },
    setField(type) {
      this.form = {
        labelName: '',
        businessType: 1,
        visualTagIds: '',
        type: 1,
        otherContent: [],
      }
      this.tagList = []
      this.dialog.show = true
    },
    showInput() {
      this.visibleAdd = true
      this.$nextTick((_) => {
        this.$refs.saveTagInput.$refs.input.focus()
      })
    },
    newInputConfirm() {
      let name = this.newInput
      if (name) {
        Array.isArray(this.form.otherContent) || (this.form.otherContent = [])
        let isExist = this.form.otherContent.some((e) => {
          return e.labelName === name
        })
        if (isExist) {
          this.msgError('内容项已存在，不可重复添加')
          return
        }
        this.form.otherContent.push({ labelName: name })
      }
      this.visibleAdd = false
      this.newInput = ''
    },
    resetQuery() {
      this.query.labelName = ''
      this.query.type = null
      this.query.visualTagIds = ''
      this.queryTag = []
      this.getList()
    },
    submitSelectTag(data) {
      this.tagList = data
      this.form.visualTagIds = data
        .map((dd) => {
          return dd.tagId
        })
        .join(',')
    },
    querySelectFn(data) {
      this.queryTag = data
      this.query.visualTagIds = data
        .map((dd) => {
          return dd.tagId
        })
        .join(',')
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
