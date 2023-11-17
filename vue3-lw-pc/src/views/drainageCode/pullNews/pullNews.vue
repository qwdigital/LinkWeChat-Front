<template>
  <div>
    <el-row :gutter="10" type="flex">
      <el-col>
        <el-form :model="form" :rules="rules" ref="form" label-width="140px">
          <el-row>
            <el-col :sm="24" :md="18">
              <el-form-item label="选择红包:" required v-if="query.qrType === 1">
                <!-- table -->
                <div class="table-button">
                  <el-table :data="tableList" v-if="tableList.length" class="mr10">
                    <el-table-column width="300" label="红包" align="center" prop="name">
                      <template #default="{ row }">
                        <div class="red-packet-message">
                          <div class="red-packet-text">
                            {{ row.name }}
                          </div>
                        </div>
                      </template>
                    </el-table-column>
                    <el-table-column label="红包金额(元)" align="center" prop="money" />
                  </el-table>
                  <el-button text @click="radioClick(tableList)" class="button">
                    {{ !tableList.length ? '选择红包' : '修改' }}
                  </el-button>
                </div>

                <div class="sub-des" v-if="!tableList.length">选择红包之前需要在红包工具->企业红包中创建红包</div>
              </el-form-item>
              <el-form-item label="选择卡券:" required v-else>
                <!-- table -->
                <el-button text @click="dialogVisibleCard = true">
                  {{ !tableList.length ? '选择卡券' : '修改' }}
                </el-button>
                <div class="sub-des">选择卡券之前需要在微信支付商户平台的营销中心提前创建代金券</div>
              </el-form-item>
              <IdentityAttachment
                @phoneData="getPhoneData"
                @success="getAttentment"
                @changeInfo="changeInfo"
                :baseData="attachmentsData"
                :maxlengthTwo="8"></IdentityAttachment>
            </el-col>
          </el-row>
        </el-form>
      </el-col>
      <el-col style="flex-basis: 400px">
        <PreviewInPhone
          name="新客户"
          :list="previewData"
          :templateInfo="templateInfo"
          :pullnewsInfo="{ qrType: 1, materialName: tableList.length ? tableList[0].name : '' }"></PreviewInPhone>
      </el-col>
    </el-row>
    <IdentitySelect v-model:choseDialog="choseDialog" @itemArry="getItemArry" :moduleType="5"></IdentitySelect>
    <!-- 点击选择卡券弹出的弹框 -->
    <CardTable
      v-if="dialogVisibleCard"
      v-model:twoVisible="dialogVisibleCard"
      :qrType="query.qrType"
      :redId="redId"
      @selectCard="selectCard" />
  </div>
</template>

<script>
import IdentityAttachment from '../components/IdentityAttachment.vue'
import IdentitySelect from '../components/IdentitySelect.vue'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import PreviewInIdentity from '../components/PreViewInIdentity.vue'
import CardTable from './cardTable'
// import { name } from 'lodash.merge'
export default {
  props: {
    // 活码id
    groupCodeId: {
      type: String,
      default: '',
    },
    // 拉新方式 1红包 2卡券
    query: {
      type: Object,
      default: {},
    },
    // initData: {
    //   type: Object,
    //   default: {},
    // },
  },
  watch: {
    query: {
      handler(val) {
        if (val.businessData) {
          let name = JSON.parse(val.businessData)['name']
          let money = JSON.parse(val.businessData)['money']
          let obj = {
            id: val.businessId,
            name,
            money,
          }
          this.selectCard(obj)
        }
        let list = []
        if (val.attachments) {
          val.attachments.forEach((item) => {
            if (item.msgType === 'text') {
              this.templateInfo = item.content
              this.attachmentsData.templateInfo = item.content
              this.attachmentsData['templateInfo'] = item.content
            } else {
              list.push(item)
            }
          })

          console.log(this.attachmentsData)
          // this.attachmentsData['attachments'] = val.attachments
        } else if (val.qrAttachments) {
          val.qrAttachments.forEach((item) => {
            if (item.msgType === 'text') {
              this.templateInfo = item.content
              this.attachmentsData.templateInfo = item.content
              this.attachmentsData['templateInfo'] = item.content
            } else {
              list.push(item)
            }
          })
        }
        if (list) {
          this.attachmentsData['attachments'] = this.setAttachments(list)
          this.previewData = this.setAttachments(list)
        }
        console.log(147, this.attachmentsData)
      },
      deep: true,
      immediate: true,
    },
  },
  components: {
    IdentityAttachment,
    IdentitySelect,
    PreviewInPhone,
    PreviewInIdentity,
    CardTable,
  },
  data() {
    return {
      // posterUrl: '',
      dialogVisibleCard: false,
      choseDialog: false,
      welcomVisible: false,
      // showSelectTag: false,
      redId: null,
      form: {
        // knowCustomerName: '',
        // addWeUser: {
        //   executeUserCondit: {
        //     change: false,
        //     weUserIds: [],
        //   },
        //   executeDeptCondit: {
        //     change: false,
        //     deptIds: [],
        //     posts: [],
        //   },
        // },
        // weKnowCustomerCodeTags: [],
        // postersId: null,
        attachments: [],
      },
      // 活码头像数据
      headImage: null,
      rules: {
        // knowCustomerName: [{ required: true, message: '请输入识客码名称', trigger: 'blur' }],
      },
      showSelectModal: false,
      groupList: [],
      // tagList: [],
      loading: false,
      previewData: [],
      //
      pullnewsInfo: {
        qrType: 1,
        materialName: '',
      },
      templateInfo: '',
      attachmentsData: {
        templateInfo: '',
        attachments: [],
      },
      tableList: [],
    }
  },
  mounted() {
    if (this.query.qrType === 1) {
      this.pullnewsInfo = {
        qrType: 1,
        materialName: '',
      }
    } else {
      this.pullnewsInfo = {
        qrType: 2,
        materialName: '',
        digest: '',
      }
    }
  },
  methods: {
    radioClick(list) {
      this.dialogVisibleCard = true
      if (list.length) {
        // 点击修改按钮
        this.redId = list[0].id
      }
    },
    getItemArry(data) {
      this.posterUrl = data[0].materialUrl
      // this.form.postersId = data[0].id
    },
    selectCard(val) {
      this.tableList = []
      this.tableList.push(val)
      val.name ? (this.pullnewsInfo['materialName'] = val.name) : ''
      let obj = {
        businessId: val.id,
        businessData: JSON.stringify({ name: val.name, money: val.money }),
      }
      this.form = Object.assign(this.form, obj)
    },
    // 客户昵称
    changeInfo(data) {
      this.templateInfo = data
    },
    getAttentment(data) {
      // debugger
      // console.log('getAttentment', data)
      let list = []
      data.forEach((item) => {
        if (item.msgType) {
          list.push(item)
        }
      })
      this.form.attachments = list
    },
    getPhoneData(data) {
      // console.log('getPhoneData', data)
      this.previewData = data
      // this.previewData.push(this.obj)
    },
    selectGroupFn() {
      this.showSelectModal = true
    },
    setSelectData(data) {
      if (data && data.length) {
        this.groupList = data
        this.form.chatIdList = this.groupList
          .map((dd) => {
            return dd.chatId
          })
          .join(',')
      }
    },
    transInfo() {
      let form = JSON.parse(JSON.stringify(this.form))
      if (this.templateInfo) {
        form.attachments.unshift({
          content: this.templateInfo,
          msgType: 'text',
        })
      }
      this.$emit('createLiveCode', form)
    },
    handleValidateFn() {
      let status = true
      // this.$refs['form'].validate((valid) => {
      // if (valid) {
      if (!this.templateInfo) {
        status = false
        this.msgError('欢迎语不能为空！')
      }
      if (!this.form.businessId) {
        status = false
        this.form.qrType === 1 ? this.msgError('请选择红包') : this.msgError('请选择卡券')
      }
      let form = JSON.parse(JSON.stringify(this.form))
      form.attachments.unshift({
        content: this.templateInfo,
        msgType: 'text',
      })
      this.$emit('createLiveCode', form)
      // } else {
      //   status = false
      // }
      // })
      return status
    },
    // getSelectTag(list) {
    //   this.tagList = list
    //   let arr = []
    //   list.forEach((dd) => {
    //     arr.push({
    //       tagName: dd.name,
    //       tagId: dd.tagId,
    //     })
    //   })
    //   this.form.weKnowCustomerCodeTags = arr
    // },
    // 提交
    submit() {
      this.form.attachments.unshift({
        content: this.templateInfo,
        msgType: 'text',
      })
      if (this.posterUrl) {
        this.form.posterUrl = this.posterUrl
      }
      this.$emit('next', this.form)
    },
    // setData() {
    //   this.form = JSON.parse(JSON.stringify(this.initData))
    //   if (this.form.weKnowCustomerCodeTags) {
    //     let arr = []
    //     this.form.weKnowCustomerCodeTags.forEach((dd, index) => {
    //       arr.push({
    //         name: dd.tagName,
    //         tagId: dd.tagId,
    //       })
    //     })
    //     this.tagList = arr
    //   }
    //   if (this.form.postersId) {
    //     this.posterUrl = this.form.posterUrl
    //   }
    //   if (this.form.attachments) {
    //     let arr = []
    //     this.form.attachments.forEach((dd) => {
    //       if (dd.msgType == 'text') {
    //         this.templateInfo = dd.content
    //       } else {
    //         arr.push(dd)
    //       }
    //     })
    //     let data = this.setAttachments(arr)
    //     ;(this.attachmentsData = {
    //       templateInfo: this.templateInfo,
    //       attachments: data,
    //     }),
    //       (this.previewData = data)
    //   }
    //   // this.$forceUpdate()
    // },
    setAttachments(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              mediaType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'video') {
            let obj = {
              mediaType: '2',
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'file') {
            let obj = {
              mediaType: '3',
              materialUrl: dd.fileUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'text') {
            let obj = {
              mediaType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let obj = {
              mediaType: '9',
              content: dd.content,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              mediaType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.fileUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'news') {
            let ff = {
              mediaType: '12',
              digest: dd.description,
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              content: dd.content,
              materialName: dd.title,
            }
            arr.push(ff)
          } else if (dd.msgType === 'posters') {
            let obj = {
              mediaType: '5',
              materialUrl: dd.fileUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          }
        })
      }
      return arr
    },
  },
}
</script>

<style scoped lang="scss">
::v-deep {
  .el-input-number.is-without-controls .el-input__inner {
    text-align: left;
  }
}
.table-button {
  display: flex;
  align-items: flex-end;
  .button {
    height: 26px;
  }
  .red-packet-message {
    display: inline-block;
    text-align: left;
    width: 175px;
    height: 75px;
    padding: 20px 10px 0 54px;
    color: var(--font-white, #fff);
    line-height: 1.15;
    font-size: 14px;
    font-weight: 500;
    background: url('../../../assets/image/newred1.png') 0 0/100% 100% no-repeat;
    .red-packet-text {
      width: 100%;
      height: 30px;
      overflow: hidden;
      white-space: nowrap; // 强制一行
      text-overflow: ellipsis; // 文字溢出显示省略号
    }
  }
}
.sub-des {
  font-size: 12px;
  font-weight: 400;
  color: var(--font-black-6);
}
::v-deep .image-uploader {
  .uploader-icon {
    width: 80px;
    height: 80px;
    line-height: 80px;
  }

  .upload-img {
    width: 80px;
    height: 80px;
  }
}

::v-deep .image-uploader2 {
  .uploader-icon {
    width: 120px;
    height: 120px;
    line-height: 120px;
  }
  .upload-img {
    width: 120px;
    height: 120px;
  }
}

.el-form-item {
  margin-bottom: 30px;
}
</style>
