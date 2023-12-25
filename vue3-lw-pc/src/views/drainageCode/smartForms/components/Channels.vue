<template>
  <el-table v-loading="loading" :data="ChannelsList" style="width: 1000px">
    <el-table-column label="渠道" align="center" prop="createTime">
      <template #default="{ row, $index }">
        {{ ChannelsList[$index] }}
        <!-- <el-input style="width: 80%" type="text" placeholder="请输入渠道标识" v-model="ChannelsList[$index]" /> -->
      </template>
    </el-table-column>
    <el-table-column label="二维码" align="center" prop="createTime" show-overflow-tooltip>
      <template #default="{ row, $index }">
        <el-image :src="eImgList[$index]" class="code-image"></el-image>
        <!-- <el-popover placement="bottom" trigger="hover" v-if="eImgList[$index]">
          <template #reference><el-image :src="eImgList[$index]" class="code-image--small"></el-image></template>
          <el-image :src="eImgList[$index]" class="code-image"></el-image>
        </el-popover> -->
      </template>
    </el-table-column>
    <el-table-column label="地址" align="center" prop="createTime" show-overflow-tooltip>
      <template #default="{ row, $index }">{{ baseFormUrl4 + '&dataSource=' }}{{ encodeURIComponent(row) }}</template>
    </el-table-column>
    <el-table-column label="操作" align="center" prop="createTime" show-overflow-tooltip>
      <template #default="{ row, $index }">
        <el-button text class="copy-btn" :data-clipboard-text="baseFormUrl4 + '&dataSource=' + encodeURIComponent(row)">
          复制
        </el-button>
        <el-button text @click="downloadBlob(eImgList[$index], '表单二维码.png', 'image')">下载二维码</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
import QRCode from 'qrcode'
import { selectInfoToSurvey } from '@/api/drainageCode/smartForms.js'
export default {
  props: ['FormIdY'],
  data() {
    return {
      loading: true,
      eImgList: [],
      formId: '',
      ChannelsList: '',
      channelsPathList: '',
      baseFormUrl4: '',
    }
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
    this.formId = this.FormIdY
    this.selectInfoToSurvey()
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    //获取详情
    selectInfoToSurvey() {
      if (!this.formId) {
        this.loading = false
        return
      }
      selectInfoToSurvey(this.formId).then((response) => {
        this.loading = false

        this.baseFormUrl4 = window.location.origin + '/formsDetail?id=true&formId=' + this.formId
        if (response.data.channelsName) {
          this.ChannelsList = response.data.channelsName.split(',')
          this.channelsPathList = response.data.channelsPath.split(',')
          //生成各渠道二维码
          for (let w = 0; w < this.channelsPathList.length; w++) {
            console.log('二维码转换内容', this.baseFormUrl4 + '&dataSource=' + this.channelsPathList[w])
            QRCode.toDataURL(
              this.baseFormUrl4 + '&dataSource=' + this.ChannelsList[w], // 需要转换为二维码的内容
              { width: 150, margin: 2, errorCorrectionLevel: 'H' },
            ).then((url) => (this.eImgList[w] = url))
          }
          this.eImgList.push()
        }
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.code-image {
  width: 180px;
  height: 180px;
}
// .code-image--small {
//   width: 200px;
//   height: 200px;
// }
</style>
