<template>
  <div style="margin-top: 10px">
    <div class="g-card">
      <div class="g-card-title">结束SOP配置</div>
      <el-form ref="form" :model="form" label-position="right" label-width="130px">
        <el-form-item label="结束SOP内容项：" prop="name">
          <div class="select_content">
            <div>
              <el-checkbox
                v-model="form.endContent.executeTag.change"
                @change="clearTagFn"
                label="客群标签变化"></el-checkbox>
              <span class="sub-des">
                设置该项后。SOP结束后用户标签仅会生成以下标签。如需保留用户原有标签，请一并勾选。
              </span>
              <div class="select_unit" v-if="form.endContent.executeTag.change">
                <div v-if="selectedTagList.length > 0">
                  <el-tag v-for="(item, index) in selectedTagList" :key="index">{{ item.name }}</el-tag>
                </div>
                <el-button icon="el-icon-plus" type="primary" plain @click="dialogVisibleSelectTag = true">
                  {{ selectedTagList.length ? '修改' : '选择' }}标签
                </el-button>
              </div>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="提前结束SOP：" prop="name">
          <el-checkbox v-model="endState" @change="clearTagFn"></el-checkbox>
          当满足以上勾选项时，则自动结束当前SOP。
        </el-form-item>
      </el-form>
    </div>
    <div class="g-footer-sticky" v-if="!isDetail" v-loading="loading">
      <el-button plain @click="next(3)">上一步</el-button>
      <el-button type="primary" @click="submitFn">确定</el-button>
    </div>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      type="2"
      :selected="selectedTagList"
      @success="getSelectTag"></SelectTag>
  </div>
</template>
<script>
import { getList } from '@/api/customer/tag'

export default {
  name: 'group-step-4',
  components: {},
  props: {
    loading: {
      type: Boolean,
      default: false,
    },
    initData: {
      type: Object,
      default: {
        earlyEnd: 1, // 1 满足任意勾选项  2 全部勾选项
        endContent: {
          executeTag: {
            change: false,
            tagIds: [],
          },
        },
      },
    },
  },
  data() {
    return {
      endState: false,
      isDetail: false,
      selectedTagList: [],
      dialogVisibleSelectTag: false,
      form: {
        earlyEnd: 1, // 1 满足任意勾选项  2 全部勾选项
        endContent: {
          executeTag: {
            change: false,
            tagIds: [],
          },
        },
      },
    }
  },
  methods: {
    clearTagFn(data) {
      if (!data) {
        this.form.endContent.executeTag.tagIds = []
        this.selectedTagList = []
      }
    },
    submitFn() {
      // 校验
      if (this.form.endContent.executeTag.change) {
        if (!this.selectedTagList.length) {
          this.msgError('请选择客群标签！')
          return false
        }
      }
      if (!this.endState) {
        this.form.earlyEnd = 0
      }
      this.$emit('success', this.form)
    },
    next(type) {
      this.$emit('stepFn', type)
    },
    getSelectTag(list) {
      this.selectedTagList = list
      let arr = []
      let arr1 = []
      list.forEach((dd) => {
        arr.push(dd.name)
        arr1.push(dd.tagId)
      })
      this.form.endContent.executeTag.tagIds = arr1
    },
    editTag() {
      if (this.form.endContent.executeTag.tagIds.length) {
        this.selectedTagList = []
        getList({ groupTagType: 2 }).then(({ rows }) => {
          this.listOneArray = []
          rows.forEach((element) => {
            element.weTags.forEach((d) => {
              this.listOneArray.push({ tagId: d.tagId, name: d.name })
            })
          })
          this.form.endContent.executeTag.tagIds.forEach((dd) => {
            let index = this.listOneArray.findIndex((item) => item.tagId == dd)
            if (index !== -1) {
              this.selectedTagList.push(this.listOneArray[index])
            }
          })
        })
      }
    },
  },
  created() {
    if (this.initData.endContent) {
      if (this.initData.endContent.executeTag && this.initData.endContent.executeTag.change) {
        this.form.endContent.executeTag = this.initData.endContent.executeTag
        this.editTag()
      }
      if (this.initData.earlyEnd === 0) {
        this.endState = false
      } else {
        this.form.earlyEnd = this.initData.earlyEnd
        this.endState = true
      }
    }
  },
}
</script>
<style lang="scss" scoped>
.select_content {
  background-color: var(--color-light-10);
  padding: 20px;
  border-radius: 5px;
  .select_unit {
    padding: 10px 25px;
  }
}
.sub-des {
  margin-left: 10px;
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
