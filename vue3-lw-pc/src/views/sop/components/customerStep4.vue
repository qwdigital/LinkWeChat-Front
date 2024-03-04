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
                label="客户标签变化"></el-checkbox>
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
            <div>
              <el-checkbox
                v-model="form.endContent.joinCustomerGroup.change"
                @change="clearGroupFn"
                label="客户加入客群"></el-checkbox>
              <span class="sub-des">
                设置该项后。SOP结束后将会认定客户已满足加入某个客群的要求，于最后一天发送消息邀请客户加入群聊
              </span>
              <div class="select_unit" v-if="form.endContent.joinCustomerGroup.change">
                <el-form-item label="加群引导语：" label-width="110px" prop="joinGroupTip">
                  <el-input
                    style="width: 400px"
                    v-model="form.endContent.joinCustomerGroup.joinGroupTip"
                    type="textarea"
                    maxlength="200"
                    show-word-limit
                    clearable></el-input>
                </el-form-item>
                <el-form-item label="选择群活码：" label-width="110px" prop="groupUrl">
                  <div v-if="form.endContent.joinCustomerGroup.groupUrl">
                    <div>{{ form.endContent.joinCustomerGroup.groupName }}</div>
                    <img
                      style="height: 80px; width: 80px; margin-top: 5px"
                      :src="form.endContent.joinCustomerGroup.groupUrl" />
                  </div>

                  <el-button
                    v-if="!isDetail"
                    icon="el-icon-plus"
                    type="primary"
                    plain
                    @click="dialogVisibleSelectQrCode = true">
                    {{ form.endContent.joinCustomerGroup.groupUrl ? '编辑' : '选择' }}群活码
                  </el-button>
                </el-form-item>
              </div>
            </div>
            <div>
              <el-checkbox
                v-model="form.endContent.toChangeIntoOtherSop.change"
                @change="clearOtherFn"
                label="转入其他SOP"></el-checkbox>
              <span class="sub-des">设置该项后，本SOP结束后将会自动切换至下一SOP开始新的SOP推送</span>
              <div class="select_unit" v-if="form.endContent.toChangeIntoOtherSop.change">
                <el-form-item label="转接引导语：" label-width="110px" prop="toChangeTip">
                  <el-input
                    style="width: 400px"
                    v-model="form.endContent.toChangeIntoOtherSop.toChangeTip"
                    type="textarea"
                    maxlength="200"
                    show-word-limit
                    clearable></el-input>
                </el-form-item>
                <el-form-item label="选择SOP：" label-width="110px">
                  <el-select v-model="form.endContent.toChangeIntoOtherSop.toChangeIntoSopId">
                    <el-option
                      :disabled="item.sopBaseId === $route.query.id"
                      v-for="item in sopList"
                      :key="item.sopBaseId"
                      :label="item.sopName"
                      :value="item.sopBaseId"></el-option>
                  </el-select>
                </el-form-item>
              </div>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="提前结束SOP：" prop="name">
          <el-switch v-model="endState" :active-value="1" :inactive-value="0"></el-switch>
          <template v-if="endState === 1">
            <div>
              <el-radio-group v-model="form.earlyEnd" style="display: flex; flex-direction: column">
                <el-radio :label="1" style="margin-top: 15px">
                  当满足以上任意勾选项时，则自动结束当前SOP，其余勾选项不执行。
                </el-radio>
                <el-radio :label="2" style="margin-top: 15px">当满足以上全部勾选项时，则自动结束当前SOP。</el-radio>
              </el-radio-group>
            </div>
          </template>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-footer-sticky" v-if="!isDetail" v-loading="loading">
      <el-button plain @click="next(3)">上一步</el-button>
      <el-button type="primary" @click="submitFn">确定</el-button>
    </div>
    <SelectQrCode
      v-model:visible="dialogVisibleSelectQrCode"
      @success="selectedQrCode"
      :selected="selectedCodeList"></SelectQrCode>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      type="1"
      :selected="selectedTagList"
      @success="getSelectTag"></SelectTag>
  </div>
</template>
<script>
import SelectQrCode from '@/components/SelectQrCode'
import { getList } from '@/api/customer/tag'
import { getTableList } from '@/api/sop/index'

export default {
  name: 'customer-step-4',
  components: {
    SelectQrCode,
  },
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
          joinCustomerGroup: {
            change: false,
            joinGroupTip: '',
            groupUrl: '',
            groupName: '',
            groupCodeId: '',
          },
          toChangeIntoOtherSop: {
            change: false,
            toChangeTip: '',
            toChangeIntoSopId: '',
          },
        },
      },
    },
  },
  data() {
    return {
      endState: null,
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
          joinCustomerGroup: {
            change: false,
            joinGroupTip: '',
            groupUrl: '',
            groupName: '',
            groupCodeId: '',
          },
          toChangeIntoOtherSop: {
            change: false,
            toChangeTip: '',
            toChangeIntoSopId: '',
          },
        },
      },
      dialogVisibleSelectQrCode: false,
      selectedCodeList: [],
      selectSOP: false,
      sopList: [],
    }
  },
  methods: {
    clearTagFn(data) {
      if (!data) {
        this.form.endContent.executeTag.tagIds = []
        this.selectedTagList = []
      }
    },
    clearGroupFn(data) {
      if (!data) {
        this.form.endContent.joinCustomerGroup.joinGroupTip = ''
        this.form.endContent.joinCustomerGroup.groupUrl = ''
        this.form.endContent.joinCustomerGroup.groupName = ''
        this.form.endContent.joinCustomerGroup.groupCodeId = ''
      }
    },
    clearOtherFn(data) {
      if (!data) {
        this.form.endContent.toChangeIntoOtherSop.toChangeIntoSopId = ''
        this.form.endContent.toChangeIntoOtherSop.toChangeTip = ''
      } else {
        this.editSop()
      }
    },
    submitFn() {
      // 校验
      if (this.form.endContent.executeTag.change) {
        if (!this.selectedTagList.length) {
          this.msgError('请选择客户标签！')
          return false
        }
      }
      if (this.form.endContent.joinCustomerGroup.change) {
        if (
          !this.form.endContent.joinCustomerGroup.joinGroupTip ||
          !this.form.endContent.joinCustomerGroup.groupCodeId
        ) {
          this.msgError('请填写加群引导语并选择群活码！')
          return false
        }
      }
      if (this.form.endContent.toChangeIntoOtherSop.change) {
        if (
          !this.form.endContent.toChangeIntoOtherSop.toChangeTip ||
          !this.form.endContent.toChangeIntoOtherSop.toChangeIntoSopId
        ) {
          this.msgError('请填写转接引导语并选择sop!')
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
    selectedQrCode(data) {
      if (data) {
        this.selectedCodeList[0] = data
        this.form.endContent.joinCustomerGroup.groupUrl = data.codeUrl
        this.form.endContent.joinCustomerGroup.groupName = data.activityName
        this.form.endContent.joinCustomerGroup.groupCodeId = data.id
      }
    },
    getSelectTag(list) {
      this.selectedTagList = list
      let arr = []
      let arr1 = []
      list.forEach((dd) => {
        arr.push(dd.name)
        arr1.push(dd.tagId)
      })
      // this.tagNames = arr.join(',')
      this.form.endContent.executeTag.tagIds = arr1
    },
    editTag() {
      if (this.form.endContent.executeTag.tagIds.length) {
        this.selectedTagList = []
        getList({ groupTagType: 1 }).then(({ rows }) => {
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
    editGroup() {
      let obj = {
        codeUrl: this.form.endContent.joinCustomerGroup.groupUrl,
        activityName: this.form.endContent.joinCustomerGroup.groupName,
        id: this.form.endContent.joinCustomerGroup.groupCodeId,
      }
      this.selectedCodeList[0] = obj
    },
    editSop() {
      getTableList({ pageSize: 10000, pageNum: 1, baseType: 1 }).then((res) => {
        this.sopList = res.rows
      })
    },
  },
  created() {
    if (this.initData.endContent) {
      if (this.initData.endContent.executeTag && this.initData.endContent.executeTag.change) {
        this.form.endContent.executeTag = this.initData.endContent.executeTag
        this.editTag()
      }
      if (this.initData.endContent.joinCustomerGroup && this.initData.endContent.joinCustomerGroup.change) {
        this.form.endContent.joinCustomerGroup = this.initData.endContent.joinCustomerGroup
        this.editGroup()
      }
      if (this.initData.endContent.toChangeIntoOtherSop && this.initData.endContent.toChangeIntoOtherSop.change) {
        this.form.endContent.toChangeIntoOtherSop = this.initData.endContent.toChangeIntoOtherSop
        this.editSop()
      }
      if (this.initData.earlyEnd === 0) {
        this.endState = 0
      } else {
        this.form.earlyEnd = this.initData.earlyEnd
        this.endState = 1
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
