<script>
  import { upload } from '@/api/material'
  import Video from 'video.js'
  import BenzAMRRecorder from 'benz-amr-recorder'
  import MP4Box from 'mp4box'

  export default {
    name: 'Upload',
    components: {},
    props: {
      fileUrl: {
        type: String,
        default: ''
      },
      fileUrls: {
        type: Array,
        default: null
      },
      fileName: {
        type: String,
        default: ''
      },
      fileNames: {
        type: Array,
        default: () => []
      },
      // 监视弹框显示隐藏
      dalogChange: {
        type: Boolean,
        default: false
      },
      // 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)
      type: {
        type: String,
        default: '0'
      },
      // 上传文件大小不能超过 maxSize MB
      maxSize: {
        type: Number,
        default: 2
      },
      // 图片的宽高像素限制 [width(number), height(number)],默认null不限制
      maxImgPx: {
        type: Array,
        default: null // () => [100, 100]
      },
      // 限制允许上传的文件格式 eg:["bmp", "jpg", "png", "jpeg", "gif"]
      format: {
        type: Array,
        default: null
      },
      // 是否能上传多个
      multiple: {
        type: Boolean,
        default: false
      },
      // 最多上传几个
      limit: {
        type: Number,
        default: 1
      },
      // 是否限制文件只能上传word/pdf/ppt
      isThree: {
        type: Boolean,
        default: false
      }
      // beforeUpload: {
      //   type: Function,
      //   default: function() {
      //     return function() {}
      //   },
      // },
    },
    data() {
      return {
        loading: false,
        action: window.lwConfig.BASE_API + '/file/upload',
        // (this.type == 0
        //   ? '/wecom/material/uploadimg'
        //   : '/common/uploadFile2Cos'),
        headers: window.lwConfig.headers,
        // domain: window.lwConfig.BASE_API

        dialogImageUrl: '',
        dialogVisible: false,
        urls: [],
        names: [], // 批量上传图片名称
        picUrl: '', // 视频第一帧
        fileList: []
      }
    },
    watch: {
      fileUrls: {
        handler(value) {
          this.names = this.fileNames
          this.urls = value
        },
        immediate: true
      },
      fileUrl: {
        handler(value) {
          if (this.$refs.video) {
            this.$refs.video.src = value
          }
        }
      },
      dalogChange(val) {
        this.$refs.multPic.clearFiles()
      }
    },
    computed: {
      accept() {
        return ['image/*', 'amr/*', 'video/*', '*'][this.type]
      }
    },
    created() {},
    mounted() {},
    methods: {
      handleRemove(i) {
        this.fileList = []
        if (this.urls.length === 0) {
          this.urls = []
        } else {
          this.urls.splice(i, 1)
          this.urls.forEach((el, index) => {
            let obj = { url: '', name: '' }
            obj.url = el
            this.fileList.push(obj)
          })
        }
        if (this.names.length === 0) {
          this.names = []
        } else {
          this.names.splice(i, 1)
          this.names.forEach((item, index) => {
            this.fileList[index].name = item
          })
        }
        this.$emit('update:fileUrls', this.urls)
        this.$emit('update:fileNames', this.names)
      },
      handleExceed(file, fileList) {
        this.$message.error(`最多上传${this.limit}张`)
        this.loading = false
      },
      async handleBeforeUpload(file, filelist) {
        this.loading = true
        let isFormat = true
        let isSize = true
        if (this.format && this.format.length) {
          // 校验格式
          let reg = /\.(\w+)$/g
          let match = file.name.match(reg)
          let fileFormat = match && match[0].replace('.', '').toLowerCase()
          if (!(isFormat = this.format.includes(fileFormat))) {
            this.$message.error('文件格式不正确，请重新选择')
            this.loading = false
            return Promise.reject()
          }
        }
        if (this.type === '0') {
          // 图片
          isFormat = file.type === 'image/jpeg' || file.type === 'image/png'
          isSize = file.size / 1024 / 1024 < this.maxSize
          if (!isFormat) {
            this.$message.error('上传文件只能是 JPG/PNG 格式!')
            this.loading = false
          }
          if (!isSize) {
            this.$message.error('上传文件大小不能超过 2MB!')
            this.loading = false
          }
          let maxImgPx = this.maxImgPx
          if (maxImgPx) {
            try {
              await new Promise((resolve) => {
                let width, height
                let image = new Image()
                //加载图片获取图片真实宽度和高度
                image.onload = () => {
                  width = image.width
                  height = image.height
                  if (width > maxImgPx[0]) {
                    isSize = false
                    this.$message.error(`图片“宽”度超过${maxImgPx[0]}像素，请重新选择`)
                  } else if (height > maxImgPx[1]) {
                    this.$message.error(`图片“高”度超过${maxImgPx[1]}像素，请重新选择`)
                    isSize = false
                  }
                  window.URL && window.URL.revokeObjectURL(image.src)
                  resolve()
                }
                if (window.URL) {
                  let url = window.URL.createObjectURL(file)
                  image.src = url
                } else if (window.FileReader) {
                  let reader = new FileReader()
                  reader.onload = function (e) {
                    let data = e.target.result
                    image.src = data
                  }
                  reader.readAsDataURL(file)
                }
              })
            } catch (e) {
              console.error(e)
            }
          }
        } else if (this.type === '1') {
          // 语音
          isFormat = /.amr$/gi.test(file.name)
          isSize = file.size / 1024 / 1024 < 2

          if (!isFormat) {
            this.$message.error('上传文件只能是 amr 格式!')
            this.loading = false
          }
          if (!isSize) {
            this.$message.error('上传文件大小不能超过 2MB!')
            this.loading = false
          }
          let amr = new BenzAMRRecorder()
          try {
            await amr.initWithBlob(file)
            isSize = amr.getDuration() <= 60
            if (!isSize) {
              this.$message.error('上传文件时长不能超过 60秒!')
              this.loading = false
            }
          } catch (error) {
            console.log(error)
            this.$message.error('文件损坏')
          }
        } else if (this.type === '2') {
          // 视频
          isFormat = file.type === 'video/mp4'
          isSize = file.size / 1024 / 1024 < 100
          if (!isFormat) {
            this.$message.error('上传文件只能是 mp4 格式!')
            this.loading = false
          }
          let result
          await this.checkVideoCode(file).then((res) => {
            console.log(res)
            result = res
          })
          if (result.mime.indexOf('video/mp4') === -1) {
            this.$message.error('mp4 格式不正确, 请使用标准编码视频!')
            this.loading = false
            return Promise.reject()
          }
          if (!isSize) {
            this.$message.error('上传文件大小不能超过 100MB!')
          }
        } else if (this.type === '3') {
          // 普通文件
          isSize = file.size / 1024 / 1024 < 50
          if (!isSize) {
            this.$message.error('上传文件大小不能超过 50MB!')
          }
          if (this.isThree) {
            isFormat = this.fileType(file.name)
            if (!isFormat) {
              this.$message.error('上传文件只能是 word/pdf/ppt!')
              this.loading = false
            }
          }
        }
        if (!isSize) {
          this.loading = false
        }
        // if (beforeUpload) {
        //   return beforeUpload(file)
        // }
        return (isFormat && isSize) || Promise.reject()
      },
      checkVideoCode(file) {
        return new Promise((resolve, reject) => {
          const mp4boxFile = MP4Box.createFile()
          const reader = new FileReader()
          reader.readAsArrayBuffer(file)
          reader.onload = function (e) {
            const arrayBuffer = e.target.result
            arrayBuffer.fileStart = 0
            mp4boxFile.appendBuffer(arrayBuffer)
          }
          mp4boxFile.onReady = function (info) {
            resolve(info)
          }
          mp4boxFile.onError = function (info) {
            reject(info)
          }
        })
      },
      fileType(file) {
        let filecontent = JSON.parse(JSON.stringify(file))
        filecontent = filecontent.split('.')
        let type = filecontent[filecontent.length - 1]
        if (['doc', 'docx', 'pdf', 'ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
          return true
        } else {
          return false
        }
      },
      onSuccess(res, file) {
        if (res.code === 200) {
          // this.$emit('update:fileUrl', res.data.materialUrl)
          // this.$emit('update:fileName', res.data.materialName)

          // if (this.type == 0) {
          //   res.url = res.data.url
          //   res.fileName = res.data.url
          // }
          if (this.fileUrls || this.fileUrls === []) {
            this.urls.push(res.data.url)
            this.names.push(res.data.name)
          }
          this.$emit('update:fileUrl', res.data.url)
          this.$emit('update:fileUrls', this.urls)
          this.$emit('update:fileName', res.data.name)
          this.$emit('update:fileNames', this.names)
          this.$emit('update:file', file)
          this.loading = false
          // this.fileUrl = URL.createObjectURL(file.raw)
        } else {
          this.loading = false
          this.$message.error(res.msg)
        }
      },
      onError(err, file, fileList) {
        this.loading = false
        this.$message.error('上传文件失败')
      }
    }
  }
</script>

<template>
  <div>
    <div v-if="fileUrls || fileUrls === []">
      <div class="img-style">
        <!-- 多个图片 -->
        <div v-for="(item, index) in fileUrls" :key="index" class="img-item">
          <img class="upload-img" :src="item" alt="" @mouseenter="enterImg(index)" @mouseleave="leaveImg(index)" />
          <span class="mask">
            <span class="item-delete" @click="handleRemove(index)">
              <i class="el-icon-delete"></i>
            </span>
          </span>
        </div>
        <el-upload
          ref="multPic"
          v-loading="loading"
          element-loading-text="正在上传..."
          class="uploader"
          :accept="accept"
          :action="action"
          :headers="headers"
          :data="{ mediaType: type }"
          :show-file-list="false"
          :file-list="fileList"
          :on-success="onSuccess"
          :on-error="onError"
          :before-upload="handleBeforeUpload"
          :multiple="multiple"
          :limit="limit"
          :on-exceed="handleExceed"
        >
          <slot>
            <template>
              <i class="el-icon-plus uploader-icon"></i>
            </template>
          </slot>
        </el-upload>
      </div>
    </div>
    <div v-else>
      <el-upload
        ref="multPic"
        v-loading="loading"
        element-loading-text="正在上传..."
        class="uploader"
        :accept="accept"
        :action="action"
        :headers="headers"
        :data="{ mediaType: type }"
        :show-file-list="false"
        :on-success="onSuccess"
        :on-error="onError"
        :before-upload="handleBeforeUpload"
      >
        <slot>
          <template v-if="fileUrl || (fileUrls && fileUrls.length)">
            <div v-if="type === '0'">
              <img v-if="fileUrl" :src="fileUrl" class="upload-img" />
            </div>
            <div v-else-if="type === '2'">
              <video
                ref="video"
                id="myVideo"
                class="video-js vjs-default-skin vjs-big-play-centered"
                width="100%"
                controls
                webkit-playsinline="true"
                playsinline="true"
                :autoplay="false"
                preload="auto"
              >
                <source :src="fileUrl" type="video/mp4" />
              </video>
            </div>
            <div v-else>{{ fileName }}</div>
          </template>
          <i v-else class="el-icon-plus uploader-icon"></i>
        </slot>
      </el-upload>
    </div>

    <div class="tip">
      <slot name="tip"></slot>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  ::v-deep.uploader {
    display: inline-block;
    .el-upload {
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      &:hover {
        border-color: #409eff;
      }
    }
  }

  .uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
    border-radius: 6px;
    border: 1px dashed #d9d9d9;
  }
  .upload-img {
    width: 178px;
    height: 178px;
    display: block;
  }
  .tip {
    color: #aaa;
    font-size: 12px;
  }
  .img-style {
    display: flex;
    flex-wrap: wrap;
  }
  .img-item {
    margin-right: 10px;
    margin-bottom: 10px;
    position: relative;
  }
  .mask {
    position: absolute;
    display: block;
    width: 100%;
    height: 100%;
    left: 0;
    top: 0;
    cursor: pointer;
    text-align: center;
    color: #fff;
    opacity: 0;
    font-size: 20px;
    transition: opacity 0.3s;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1;
    line-height: 178px;
    .item-delete {
      display: none;
    }
  }
  .mask:hover {
    opacity: 1;
    background-color: rgba(0, 0, 0, 0.5);
    .item-delete {
      display: inline-block;
    }
  }
</style>
