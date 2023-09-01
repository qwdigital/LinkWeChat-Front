<template>
  <el-table v-loading="loading" :data="ChannelsList" style="width: 1000px">
    <el-table-column label="渠道" align="center" prop="createTime">
      <template #default="{ row, $index }">
        <el-input style="width: 80%" type="text" placeholder="请输入渠道标识" v-model="ChannelsList[$index]" />
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
    <el-table-column label="渠道标识" align="center" prop="createTime" show-overflow-tooltip>
      <template #default="{ row, $index }">{{ baseFormUrl4 + '&dataSource=' }}{{ row }}</template>
    </el-table-column>
    <el-table-column label="操作" align="center" prop="createTime" show-overflow-tooltip>
      <template #default="{ row, $index }">
        <el-button text class="copy-btn" :data-clipboard-text="baseFormUrl4 + '&dataSource=' + row">复制</el-button>
        <el-button text @click="btnDownload($index)">下载二维码</el-button>
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
      formId: '1551375031790080000',
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
    btnDownload(index) {
      console.log('this.$refs.qrCodeUrl', this.$refs.ewmTAddEwm.childNodes[index * 2 + 1].src)
      this.downloadFile('表单二维码', this.$refs.ewmTAddEwm.childNodes[index * 2 + 1].src)
      //创建一个具有指定的命名空间URI和限定名称的元素
      // var save_link = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');
      // save_link.href = data;
      // save_link.download = filename;
      // // 绑定下载事件
      // var event = document.createEvent('MouseEvents');
      // event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false,         false, false, 0, null);
      // save_link.dispatchEvent(event);
    },
    //base64转blob
    base64ToBlob(code) {
      let parts = code.split(';base64,')
      let contentType = parts[0].split(':')[1]
      let raw = window.atob(parts[1])
      let rawLength = raw.length

      let uInt8Array = new Uint8Array(rawLength)

      for (let i = 0; i < rawLength; ++i) {
        uInt8Array[i] = raw.charCodeAt(i)
      }
      return new Blob([uInt8Array], { type: contentType })
    },
    //下载
    downloadFile(fileName, content) {
      let aLink = document.createElement('a')
      let blob = this.base64ToBlob(content) //new Blob([content]);

      let evt = document.createEvent('HTMLEvents')
      evt.initEvent('click', true, true) //initEvent 不加后两个参数在FF下会报错  事件类型，是否冒泡，是否阻止浏览器的默认行为
      aLink.download = fileName
      aLink.href = URL.createObjectURL(blob)

      // aLink.dispatchEvent(evt);
      aLink.click()
    },
    //获取详情
    selectInfoToSurvey() {
      let that = this
      if (!this.formId) {
        this.loading = false
        return
      }
      selectInfoToSurvey(this.formId).then((response) => {
        this.loading = false

        that.baseFormUrl4 = window.location.origin + '/formsDetail?id=true&formId=' + that.formId
        if (response.data.channelsName) {
          that.ChannelsList = response.data.channelsName.split(',')
          that.channelsPathList = response.data.channelsPath.split(',')
          for (let i = 0; i < that.channelsPathList.length; i++) {
            //生成各渠道二维码
            for (let w = 0; w < this.ChannelsList.length; w++) {
              console.log('二维码转换内容', that.baseFormUrl4 + '&dataSource=' + that.channelsPathList[w])
              QRCode.toDataURL(
                this.baseFormUrl4 + '&dataSource=' + that.channelsPathList[w], // 需要转换为二维码的内容
                { width: 150, margin: 2, errorCorrectionLevel: 'H' },
              ).then((url) => (this.eImgList[i] = url))
            }
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
