<template>
  <div>
    <div class="g-card">
      <el-steps :active="currentActive" align-center finish-status="success">
        <el-step title="活码设置"></el-step>
        <el-step title="欢迎语"></el-step>
      </el-steps>
    </div>
    <template v-if="currentActive === 1">
      <el-row :gutter="10" type="flex" style="margin-top: 10px">
        <el-col>
          <el-form :model="form" ref="form" :rules="rule" label-width="120px" label-position="right">
            <div class="g-card">
              <el-form-item label="门店范围：" prop="raidus">
                距离门店半径
                <el-input v-model="form.raidus" style="width: 50px"></el-input>
                公里范围内，客户可扫码添加门店群
              </el-form-item>
              <el-form-item label="超出范围提示：" prop="outOfRangeTip">
                <el-input
                  v-model="form.outOfRangeTip"
                  style="width: 350px"
                  type="textarea"
                  maxlength="30"
                  show-word-limit
                  placeholder="请输入"
                  :autosize="{ minRows: 3, maxRows: 20 }"
                  clearable />
              </el-form-item>
              <el-form-item label="活码员工客服：">
                <el-switch
                  @change="setChange"
                  v-model="form.codeState"
                  :active-value="0"
                  :inactive-value="1"></el-switch>
                <div class="sub-des">开启后，当客户超过范围时显示该员工客服的二维码</div>
                <template v-if="form.codeState === 0">
                  <div v-if="selectedUserList.length > 0">
                    <el-tag v-for="(item, index) in selectedUserList" :key="index">
                      {{ item.name }}
                    </el-tag>
                  </div>
                  <el-button type="primary" plain icon="el-icon-plus" @click="onSelectUser">
                    {{ selectedUserList.length ? '编辑' : '选择' }}员工
                  </el-button>
                </template>
              </el-form-item>
              <el-form-item label="新客户标签">
                <template v-for="(item, index) in selectedTagList" :key="index">
                  <el-tag v-if="item.name">{{ item.name }}</el-tag>
                </template>
                <div>
                  <el-button type="primary" icon="el-icon-plus" @click="dialogVisibleSelectTag = true">
                    {{ selectedTagList.length == 0 ? '添加' : '编辑' }}标签
                  </el-button>
                </div>
                <div class="sub-des">添加成功后，该客户将会自动设置以上选择标签</div>
              </el-form-item>
            </div>
            <div class="g-card mt20 pad20">
              <el-button plain @click="cancelFn">取消</el-button>
              <el-button type="primary" @click="nextStep()">下一步</el-button>
            </div>
          </el-form>
        </el-col>
        <el-col style="flex-basis: 350px">
          <div class="g-card" style="height: 100%; display: flex">
            <preview-client :showTip="true" name="专属门店导购" :value="form"></preview-client>
          </div>
        </el-col>
      </el-row>
    </template>
    <template v-if="currentActive === 2">
      <AddMaterial
        :moduleType="4"
        :otherType="4"
        @update="currentActive = 1"
        @submit="getWelData"
        :baseData="materialData"
        isTransData
        :showModle="true"></AddMaterial>
    </template>
    <SelectUser
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      :isSigleSelect="true"
      :defaultValues="selectedUserList"
      @success="selectedUser"></SelectUser>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :selected="selectedTagList"
      @success="submitSelectTag"></SelectTag>
  </div>
</template>
<script>
import PreviewClient from '../components/PreviewInStore.vue'
import { addOrUpdateCodeInStore, getCode } from '@/api/drainageCode/store'
import AddMaterial from '@/components/ContentCenter/AddMaterial'
function validateRadius(rule, value, callback) {
  if (value == '') {
    callback()
    return
  }
  if (Number.isNaN(Number(value)) || Number(value) < 1 || Number(value) > 10 || value.toString().indexOf('.') > -1) {
    callback('请输入 1-100 的正整数')
  } else {
    callback()
  }
}
export default {
  name: 'guide-add',
  data() {
    return {
      currentActive: 1,
      dialogVisibleSelectUser: false,
      selectedUserList: [],
      dialogVisibleSelectTag: false,
      selectedTagList: [],
      form: {
        addOrUpdate: true,
        raidus: 3,
        outOfRangeTip: '您所在区域暂未开设门店，可联系客服或手动搜索',
        codeState: 1,
        storeCodeType: 1,
        customerServiceName: '',
        customerServiceId: '',
      },
      materialData: {
        templateInfo: '',
        attachments: [],
      },
      loading: false,
      rule: {
        raidus: [
          { required: true, message: '请输入门店范围', trigger: 'blur' },
          { validator: validateRadius, trigger: 'change' },
        ],
        outOfRangeTip: [{ required: true, message: '请输入超出范围提示', trigger: 'blur' }],
      },
    }
  },
  components: {
    PreviewClient,
    AddMaterial,
  },
  created() {
    this.init()
  },
  methods: {
    setChange(data) {
      if (data === 1) {
        this.selectUserList = []
        this.form.customerServiceName = ''
        this.form.customerServiceId = ''
      }
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    selectedUser(data) {
      this.selectedUserList = data
      if (data && data.length) {
        this.form.customerServiceName = data[0].name
        this.form.customerServiceId = data[0].userId
      } else {
        this.form.customerServiceName = ''
        this.form.customerServiceId = ''
      }
    },
    submitSelectTag(data) {
      this.selectedTagList = data
    },
    cancelFn() {
      this.$router.back()
    },
    nextStep() {
      this.$refs['form'].validate((val) => {
        if (val) {
          if (this.form.codeState === 0) {
            if (this.form.customerServiceId) {
              this.currentActive = 2
            } else {
              this.msgError('开启了活码员工客服， 请选择员工')
            }
          } else {
            this.currentActive = 2
          }
        }
      })
    },
    getWelData(data) {
      this.submit(data)
    },
    // resetData (list) {
    //   let arr = []
    //   if (list && list.length) {
    //     list.forEach(dd => {
    //       if (dd.msgType === '0') {
    //         let obj = {
    //           msgType: 'image',
    //           picUrl: dd.materialUrl
    //         }
    //         arr.push(obj)
    //       } else if (dd.msgType === '8') {
    //         let ob = {
    //           msgType: 'link',
    //           title: dd.materialName,
    //           linkUrl: dd.materialUrl
    //         }
    //         arr.push(ob)
    //       } else if (dd.msgType === '9') {
    //         let ff = {
    //           msgType: 'miniprogram',
    //           appId: dd.digest,
    //           title: dd.materialName,
    //           picUrl: dd.coverUrl,
    //           linkUrl: dd.materialUrl
    //         }
    //         arr.push(ff)
    //       }
    //     })
    //   }
    //   return arr
    // },
    submit(data) {
      this.loading = true
      if (this.selectedTagList.length) {
        let names = []
        let ids = []
        this.selectedTagList.forEach((dd) => {
          names.push(dd.name)
          ids.push(dd.tagId)
        })
        this.form.tagIds = ids.join(',')
        this.form.tagNames = names.join(',')
      }
      let list = data.attachments
      let myObj = {
        ...this.form,
        attachments: [
          {
            content: data.templateInfo,
            msgType: 'text',
          },
        ],
      }
      myObj.attachments.push(...list)
      myObj.addOrUpdate = myObj.id ? false : true
      addOrUpdateCodeInStore(myObj).then(({ data }) => {
        this.msgSuccess('操作成功')
        this.$router.back()
        this.loading = false
      })
    },
    init() {
      getCode(1).then(({ data }) => {
        if (data?.id) {
          this.form = data
          if (this.form.customerServiceId) {
            let obj = {
              name: this.form.customerServiceName,
              userId: this.form.customerServiceId,
            }
            this.selectedUserList = [obj]
          }
          this.materialData = {
            templateInfo: this.form.weQrAttachments ? this.form.weQrAttachments[0].content : '',
            attachments: this.form.weQrAttachments,
          }
          if (this.form.tagIds) {
            this.selectedTagList = []
            let ids = this.form.tagIds.split(',')
            let names = this.form.tagNames.split(',')
            ids.forEach((dd, index) => {
              this.selectedTagList.push({
                tagId: dd,
                name: names[index],
              })
            })
          }
        }
      })
    },
  },
}
</script>
<style lang="scss" scoped>
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}
</style>
