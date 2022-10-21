<template>
  <div class="Channels_add_form4_qd">
    <div v-show="false" ref="ewmTAddEwm"></div>
    <div class="add_form4_qd_ul" style="height: 50px">
      <div class="add_form4_qd_li1 add_form4_qd_li">渠道</div>
      <div class="add_form4_qd_li22 add_form4_qd_li">二维码</div>
      <div class="add_form4_qd_li2 add_form4_qd_li">渠道标识</div>
      <div class="add_form4_qd_li3 add_form4_qd_li">操作</div>
    </div>
    <div class="add_form4_qd_ul" v-for="(item, index) in ChannelsList" :key="index">
      <div class="add_form4_qd_li1 add_form4_qd_li">
        <div style="display: flex; justify-content: center; :flex ; justify-content: center">
          <el-input
            style="width: 80%"
            type="text"
            placeholder="请输入渠道标识"
            v-model="ChannelsList[index]"
          />
        </div>
      </div>
      <div class="add_form4_qd_li22 add_form4_qd_li">
        <!-- <img style="height:80px;" :src="eImgList[index]" alt=""> -->
        <el-popover placement="bottom" trigger="hover" v-if="eImgList[index]">
          <el-image slot="reference" :src="eImgList[index]" class="code-image--small"></el-image>
          <el-image :src="eImgList[index]" class="code-image"> </el-image>
        </el-popover>
      </div>
      <div class="add_form4_qd_li2 add_form4_qd_li">
        {{ baseFormUrl4 + '&dataSource=' }}{{ channelsPathList[index] }}<label for=""></label>
      </div>
      <div
        class="add_form4_qd_li3 add_form4_qd_li"
        style="display: flex; align-items: center; justify-content: space-around"
      >
        <div
          style="display: flex; color: #2c8cf0; cursor: pointer; flex: 1; justify-content: center"
          type="button"
          class="copy-btn"
          :data-clipboard-text="baseFormUrl4 + '&dataSource=' + channelsPathList[index]"
        >
          复制
        </div>
        <div
          @click="btnDownload(index)"
          style="color: #2c8cf0; cursor: pointer; flex: 1"
          class="copy-btn"
        >
          下载二维码
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import QRCode from 'qrcodejs2'
import { selectInfoToSurvey } from '@/api/drainageCode/smartForms.js'
export default {
  props: ['FormIdY'],
  data() {
    return {
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
  destroyed() {
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
        return
      }
      selectInfoToSurvey(this.formId).then((response) => {
        that.baseFormUrl4 = window.lwConfig.DOMAIN + '/#/formsDetail?id=true&formId=' + that.formId
        if (response.data.channelsName) {
          that.ChannelsList = response.data.channelsName.split(',')
          that.channelsPathList = response.data.channelsPath.split(',')
          for (let i = 0; i < that.channelsPathList.length; i++) {
            //生成各渠道二维码
            var childs = this.$refs.ewmTAddEwm.childNodes
            for (let q = childs.length - 1; q >= 0; q--) {
              this.$refs.ewmTAddEwm.removeChild(childs[q])
            }
            let rwmNum = 0
            for (let w = 0; w < this.ChannelsList.length; w++) {
              console.log(
                '二维码转换内容',
                that.baseFormUrl4 + '&dataSource=' + that.channelsPathList[w]
              )
              var qrcode = new QRCode(this.$refs.ewmTAddEwm, {
                text: that.baseFormUrl4 + '&dataSource=' + that.channelsPathList[w], // 需要转换为二维码的内容
                width: 150,
                height: 150,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H,
              })
              rwmNum = w
            }
            setTimeout(function () {
              console.log('that.$refs.ewmTAddEwm.childNodes', that.$refs.ewmTAddEwm.childNodes)
              console.log('that.ChannelsList', that.ChannelsList)
              that.eImgList = []
              for (let i = 0; i < that.$refs.ewmTAddEwm.childNodes.length / 2; i++) {
                that.eImgList[i] = that.$refs.ewmTAddEwm.childNodes[i * 2 + 1].src
              }
            }, 500)
          }
        }
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.code-image {
  width: 200px;
  height: 200px;
}
.code-image--small {
  width: 80px;
  height: 80px;
}
.Channels_add_form4_qd {
  margin-bottom: 30px;
  width: 1000px;
  border: 1px solid #e6e6e6;
  .add_form4_qd_ul {
    box-sizing: border-box;
    overflow: hidden;
    flex-shrink: 0;
    display: flex;
    height: 100px;
    .add_form4_qd_li {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100%;
      border: 1px solid #e6e6e6;
    }
    .add_form4_qd_li1 {
      width: 160px;
    }
    .add_form4_qd_li2 {
      flex: 1;
      line-height: initial;
    }
    .add_form4_qd_li22 {
      width: 220px;
    }
    .add_form4_qd_li3 {
      width: 180px;
    }
  }
}
.add_form4_qd_li {
  display: flex;
  flex-shrink: 0;
}
</style>
