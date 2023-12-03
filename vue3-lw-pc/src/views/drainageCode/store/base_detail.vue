<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <div class="g-card">
          <div class="g-card-title" style="display: inline-block">活码分享</div>
          <div style="float: right">
            <el-button type="primary" @click="gotoEdit">编辑</el-button>
          </div>
          <div class="content">
            <div>
              <img style="height: 120px; width: 120px" :src="form.storeCodeConfigQr" />
            </div>
            <div class="operation">
              <div>
                <el-button type="primary" @click="downloadUrlFn">下载活码</el-button>
              </div>
              <el-button type="primary" plain @click="handleCopy(form.storeCodeConfigUrl)">复制链接</el-button>
            </div>
          </div>
        </div>
        <div class="g-card">
          <el-form :model="form" ref="form" label-width="120px" label-position="right">
            <el-form-item label="门店范围：" prop="raidus">
              距离门店半径{{ form.raidus }}公里范围内，客户可扫码添加{{ codeType === 1 ? '门店导购' : '门店群' }}
            </el-form-item>
            <el-form-item v-if="codeType === 2" label="加群引导语：" prop="welcomeMsg">
              <el-input
                disabled
                v-model="form.welcomeMsg"
                type="textarea"
                maxlength="200"
                show-word-limit
                placeholder="请输入加群引导语"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable />
            </el-form-item>
            <el-form-item label="超出范围提示：" prop="outOfRangeTip">
              <el-input
                disabled
                v-model="form.outOfRangeTip"
                type="textarea"
                maxlength="30"
                show-word-limit
                placeholder="请输入超出范围提示"
                :autosize="{ minRows: 2, maxRows: 20 }"
                clearable />
            </el-form-item>
            <el-form-item label="活码员工客服：">
              <el-switch disabled v-model="form.codeState" :active-value="0" :inactive-value="1"></el-switch>
              <!-- <div class="sub-des">
                开启后，当客户超过范围时显示该员工客服的二维码
              </div> -->
              <template v-if="form.codeState === 0">
                <div v-if="selectedUserList.length > 0">
                  <el-tag v-for="(item, index) in selectedUserList" :key="index">{{ item.name }}</el-tag>
                </div>
              </template>
            </el-form-item>
            <el-form-item v-if="codeType === 1" label="新客户标签">
              <template v-for="(item, index) in selectedTagList" :key="index">
                <el-tag v-if="item.name">{{ item.name }}</el-tag>
              </template>
              <!-- <div class="sub-des">
                  添加成功后，该客户将会自动设置以上选择标签
                </div> -->
            </el-form-item>
          </el-form>
        </div>
      </el-col>
      <el-col style="min-width: 750px">
        <div class="g-card" style="height: 100%; display: flex">
          <template v-if="codeType === 1">
            <preview-store-client :showGuide="true" name="专属门店导购" :value="form"></preview-store-client>
            <PreviewInPhone
              :originList="materialData.attachments"
              :templateInfo="materialData.welcomeMsg"
              :liveUrl="liveUrl" />
          </template>
          .
          <template v-if="codeType === 2">
            <preview-store-client key="1" :showStore="true" name="专属门店群" :value="form"></preview-store-client>
            <preview-store-client key="2" :showTip="true" name="专属门店群" :value="form"></preview-store-client>
          </template>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import PreviewStoreClient from '../components/PreviewInStore.vue'

import { getCode, downloadUrl } from '@/api/drainageCode/store'

export default {
  name: 'base-detail',
  data() {
    return {
      selectedUserList: [],
      selectedTagList: [],
      form: {
        raidus: 3,
        outOfRangeTip: '您所在区域暂未开设门店，可联系客服或手动搜索',
        codeState: 1,
        storeCodeType: 1,
        customerServiceName: '',
        customerServiceId: '',
        welcomeMsg: '',
      },
      materialData: {
        welcomeMsg: '',
        attachments: [],
      },
    }
  },
  components: {
    PreviewInPhone,
    PreviewStoreClient,
  },
  props: {
    codeType: {
      type: Number,
      default: 1,
    },
  },
  methods: {
    handleCopy(text) {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this.$message({ message: '复制成功', type: 'success' })
    },
    gotoEdit() {
      this.$router.push({
        path: this.codeType === 1 ? 'guideCode' : 'storeCode',
      })
    },
    downloadUrlFn() {
      downloadUrl({ storeCodeType: this.codeType }).then((res) => {
        if (res != null) {
          let blob = new Blob([res], {
            type: 'application/image',
          })
          let url = window.URL.createObjectURL(blob)
          const link = document.createElement('a') // 创建a标签
          link.href = url
          link.download = this.codeType === 1 ? '门店导购码.jpg' : '门店群活码.jpg' // 重命名文件
          link.click()
          URL.revokeObjectURL(url) // 释放内存
        }
      })
    },
    init() {
      getCode(this.codeType).then((res) => {
        if (res.code === 200 && res.data) {
          this.form = res.data
          if (this.form.customerServiceId) {
            let obj = {
              name: this.form.customerServiceName,
              userId: this.form.customerServiceId,
            }
            this.selectedUserList = [obj]
          }
          if (this.form.weQrAttachments && this.form.weQrAttachments.length) {
            this.materialData = {
              welcomeMsg: this.form.weQrAttachments ? this.form.weQrAttachments[0].content : '',
              attachments: this.form.weQrAttachments,
            }
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
  created() {
    this.init()
  },
}
</script>
<style lang="scss" scoped>
.content {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  .operation {
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }
}
</style>
