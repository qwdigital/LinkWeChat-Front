<template>
  <div>
    <div class="flex">
      <div style="width: calc(100% - 425px); padding-right: var(--card-margin);">
        <el-form :model="form" :rules="rules" ref="form" label-width="140px">
          <el-row class="g-card">
            <el-col>
              <Attachment
                @phoneData="getPhoneData"
                @success="getAttentment"
                @changeInfo="changeInfo"
                :baseData="attachmentsData"
                :showModle="false"
              ></Attachment>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <div class="g-card" style="width: 425px; margin-top: 0;">
        <PreviewInPhone :list="previewData" :templateInfo="templateInfo"></PreviewInPhone>
      </div>
    </div>
  </div>
</template>

<script>
  import Attachment from './Attachment.vue'
  import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
  export default {
    props: {
      initData: {
        type: Object,
        default: {}
      }
    },
    components: {
      Attachment,
      PreviewInPhone
    },
    data() {
      return {
        previewData: [],
        templateInfo: '',
        attachmentsData: {
          templateInfo: '',
          attachments: []
        },
        form: []
      }
    },
    mounted() {},
    watch: {
      initData: {
        deep: true,
        immediate: true,
        handler(newData, old) {
          this.form = JSON.parse(JSON.stringify(this.initData))
          this.setData()
        }
      }
    },
    methods: {
      changeInfo(data) {
        this.templateInfo = data
      },
      getAttentment(data) {
        this.form = data
      },
      getPhoneData(data) {
        this.previewData = data
      },
      // 提交
      submit() {
        if (!this.templateInfo) {
          this.msgError('欢迎语不能为空！')
          return
        }
        let arr = JSON.parse(JSON.stringify(this.form))
        arr.unshift({
          content: this.templateInfo,
          msgType: 'text'
        })
        this.$emit('submit', arr)
        this.setData()
      },
      setData() {
        if (this.form) {
          let arr = []
          this.form.forEach((dd) => {
            if (dd.msgType == 'text') {
              this.templateInfo = dd.content
            } else {
              arr.push(dd)
            }
          })
          this.form = arr
          let data = this.setAttachments(arr)
          ;(this.attachmentsData = {
            templateInfo: this.templateInfo,
            attachments: data
          }),
            (this.previewData = data)
          console.log(this.attachmentsData)
        }
        // this.$forceUpdate()
      },
      setAttachments(list) {
        let arr = []
        if (list && list.length) {
          list.forEach((dd) => {
            if (dd.msgType === 'image') {
              let obj = {
                id: dd.materialId,
                mediaType: '0',
                materialUrl: dd.picUrl
              }
              arr.push(obj)
            } else if (dd.msgType === 'video') {
              let obj = {
                id: dd.materialId,
                mediaType: '2',
                materialUrl: dd.fileUrl,
                coverUrl: dd.picUrl,
                digest: dd.description,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'file') {
              let obj = {
                id: dd.materialId,
                mediaType: '3',
                materialUrl: dd.fileUrl,
                digest: dd.description,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'text') {
              let obj = {
                id: dd.materialId,
                mediaType: '4',
                content: dd.content
              }
              arr.push(obj)
            } else if (dd.msgType === 'link') {
              let obj = {
                id: dd.materialId,
                mediaType: '9',
                content: dd.content,
                coverUrl: dd.picUrl,
                materialUrl: dd.linkUrl,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'miniprogram') {
              let ff = {
                id: dd.materialId,
                mediaType: '11',
                digest: dd.appId,
                materialName: dd.title,
                coverUrl: dd.picUrl,
                materialUrl: dd.fileUrl
              }
              arr.push(ff)
            } else if (dd.msgType === 'news') {
              let ff = {
                id: dd.materialId,
                mediaType: '12',
                digest: dd.description,
                materialUrl: dd.fileUrl,
                coverUrl: dd.picUrl,
                content: dd.content,
                materialName: dd.title
              }
              arr.push(ff)
            } else if (dd.msgType === 'posters') {
              let obj = {
                id: dd.materialId,
                mediaType: '5',
                materialUrl: dd.fileUrl,
                materialName: dd.title
              }
              arr.push(obj)
            }
          })
        }
        return arr
      }
    }
  }
</script>

<style scoped lang="scss">
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
