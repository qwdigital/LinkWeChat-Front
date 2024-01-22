<script>
import { getCosConfig, getVideoPic, upload } from '@/api/common'
import { dateFormat, uuid } from '@/utils/index'
// import Video from 'video.js'
import Cos from 'cos-js-sdk-v5'
import BenzAMRRecorder from 'benz-amr-recorder'
import MP4Box from 'mp4box'

import OSS from 'ali-oss'

export default {
  components: {},
  emits: [
    'update:fileUrl',
    'update:fileName',
    'update:imgSize',
    'update:width',
    'update:heigth',
    'update:pixelSize',
    'update:fileList',
    'upSuccess',
    'getPicUrl',
    'loadingChange',
  ],
  props: {
    // 单文件上传时使用
    fileUrl: {
      type: String,
      default: '',
    },
    fileName: {
      type: String,
      default: '',
    },
    imgSize: {
      type: Number,
      default: undefined,
    },

    // 多文件上传时使用，例如: [{name: 'food.jpg', url: 'https://xxx.cdn.com/xxx.jpg'}]
    fileList: {
      type: Array,
      default: () => [],
    },

    // 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)
    type: {
      type: String,
      default: '0',
      validator: function (value) {
        // 这个值必须匹配下列字符串中的一个
        return ['0', '1', '2', '3'].includes(value)
      },
    },
    // 上传文件大小不能超过 maxSize MB, 各类型有默认限制 参见: maxSizeDefault
    maxSize: {
      type: Number,
      default: undefined,
    },
    // 图片的宽高像素限制 [width(number), height(number)],默认null不限制
    maxImgPx: {
      type: Array,
      default: () => [1024, 1024], // () => [100, 100]
    },
    // 允许上传的文件格式后缀名 eg:["jpg", "png"]，['*']为不限制，各类型有默认限制 参见: formatDefault
    format: {
      type: Array,
      default: undefined,
    },
    // 选择上传文件类型, 用于过滤系统选择文件类型, 默认根据类型自动匹配：见 acceptAuto，
    accept: {
      type: String,
      default: '',
    },
    // 是否能上传多个
    multiple: {
      type: Boolean,
      default: false,
    },
    // multiple为true时有效，最多上传几个,默认不限制，最小为1
    limit: {
      type: [Number, String],
      default: undefined,
    },
    // onProgress: {
    //   type: Function,
    //   default: null,
    // },
    // beforeUpload: {
    //   type: Function,
    //   default: function() {
    //     return function() {}
    //   },
    // },

    // 图片操作  目前支持有 view：查看，remove：删除，download：下载
    // action: {
    //   type: Array,
    //   default: () => ["view", "remove"],
    // },
  },
  data() {
    return {
      loading: false,

      fileUrlWatch: this.fileUrl,
      fileNameWatch: this.fileName,
      fileListWatch: this.fileList,

      picUrl: '', // 视频第一帧
      file: undefined,
      speed: 0, // 上传网速
      percentage: 0, //上传进度

      // cos配置信息
      cosConfig: { bucketName: '', cosImgUrlPrefix: '', region: '' },
      cosInstance: undefined, // cos实例
      ossObj: undefined,
    }
  },
  watch: {
    fileUrl: {
      handler(value) {
        this.fileUrlWatch = value
      },
    },
    fileName: {
      handler(value) {
        this.fileNameWatch = value
      },
    },
    fileList: {
      handler(value) {
        this.fileListWatch = value
      },
      deep: true,
    },
    loading(val) {
      this.$emit('loadingChange', val)
    },
  },
  computed: {
    // 识别选择文件类型
    acceptAuto() {
      return ['image/*', 'amr/*', 'video/*'][this.type]
    },
  },
  created() {
    getCosConfig().then((res) => {
      this.cosConfig = res
      // console.log(this.cosConfig)
      if (res.fileObject == 'tencentOss') {
        this.cosInstance = new Cos({
          SecretId: res.secretId,
          SecretKey: res.secretKey,
        })
      } else if (res.fileObject == 'local' || res.fileObject == 'minio') {
      } else {
        // let region = res.region.split('//')[1]
        this.ossObj = new OSS({
          // yourRegion填写Bucket所在地域。Region填写为oss-cn-hangzhou。
          region: res.region.split('.')[0],
          // 从STS服务获取的临时访问密钥（AccessKey ID和AccessKey Secret）。
          accessKeyId: res.secretId,
          accessKeySecret: res.secretKey,
          // 填写Bucket名称。
          bucket: res.bucketName,
        })
      }
    })
  },
  mounted() {
    // const cosInstance = new Cos({
    //   // getAuthorization 必选参数
    //   getAuthorization: function (options, callback) {
    //     // 服务端例子：https://github.com/tencentyun/qcloud-cos-sts-sdk/blob/master/scope.md
    //     // 异步获取临时密钥
    //     var url = window.lwConfig.BASE_API + '/file/get/config' // url替换成您自己的后端服务
    //     var xhr = new XMLHttpRequest()
    //     xhr.open('get', url, true)
    //     xhr.setRequestHeader('Content-Type', 'application/json')
    //     xhr.onload = function (e) {
    //       try {
    //         var data = JSON.parse(e.target.responseText)
    //         var credentials = data.credentials
    //       } catch (e) {}
    //       if (!data || !credentials) {
    //         return console.error('credentials invalid:\n' + JSON.stringify(data, null, 2))
    //       }
    //       callback({
    //         TmpSecretId: decrypt(credentials.secretId),
    //         TmpSecretKey: credentials.secretKey,
    //         SecurityToken: credentials.sessionToken,
    //         // 建议返回服务器时间作为签名的开始时间，避免用户浏览器本地时间偏差过大导致签名错误
    //         StartTime: data.startTime, // 时间戳，单位秒，如：1580000000
    //         ExpiredTime: data.expiredTime, // 时间戳，单位秒，如：1580000000
    //         // ScopeLimit: true, // 细粒度控制权限需要设为 true，会限制密钥只在相同请求时重复使用
    //       })
    //     }
    //     xhr.send()
    //     // xhr.send(JSON.stringify(options.Scope))
    //   },
    // })
  },
  methods: {
    upload() {
      if (this.cosConfig.fileObject == 'tencentOss') {
        this.tencentFn()
      } else if (this.cosConfig.fileObject == 'local' || this.cosConfig.fileObject == 'minio') {
        this.localFn()
      } else if (this.cosConfig.fileObject == 'aliOss') {
        this.aliOss()
      }
    },
    localFn() {
      this.loading = true
      let file = undefined
      if (!this.multiple || this.limit == 1) {
        file = this.file
      } else {
        // 多选上传是多次调用单传的
        file = this.file.shift()
      }
      let formData = new FormData()
      formData.append('file', file)
      upload(formData).then((dd) => {
        if (dd.code == 200) {
          let location = dd.data.url
          this.$emit('upSuccess', location)
          this.type == 2
            ? //获取视频第一帧画面
              getVideoPic({ url: location }).then((res) => {
                this.loading = false
                this.$emit('getPicUrl', res.data.url, res.data)
              })
            : (this.loading = false)

          // 使用本地链接提供预览，避免上传后下载的问题
          let url = window.URL.createObjectURL(file)

          let name = file.name
          let memorySize = file.size
          if (!this.multiple) {
            this.fileUrlWatch = url
            this.$emit('update:fileUrl', location)
            this.$emit('update:fileName', (this.fileNameWatch = name))
            this.$emit('update:imgSize', memorySize)
          } else {
            this.fileListWatch = this.fileListWatch.concat({ name, url, memorySize })
            this.$emit('update:fileList', this.fileList.concat({ name, url: location, memorySize }))
          }
        } else {
          this.loading = false
          this.$message.error('上传失败，请稍后再试')
        }
      })
    },
    async aliOss() {
      this.loading = true
      let file = undefined
      if (!this.multiple || this.limit == 1) {
        file = this.file
      } else {
        // 多选上传是多次调用单传的
        file = this.file.shift()
      }
      let date = new Date()
      let format = file.name.match(/\.(\w+)$/g)
      format = format && format[0]
      // 实例可能未初始化完成
      if (!this.ossObj) {
        this.$message.error('存储空间正忙，请稍后再试')
        return
      }
      let name = `${dateFormat(date, 'YYYY-MM-DD')}/t${date.getTime()}-${uuid()}${format}`
      try {
        const data = await this.ossObj.multipartUpload(name, file, {
          progress: (progressData) => {
            progressData > 0 && (this.percentage = progressData.toFixed(2) * 100)
            // this.speed = (progressData.speed / 1024 / 1024).toFixed(2)
          },
        })
        if (data) {
          this.percentage = this.speed = 0
          let location = this.cosConfig.cosImgUrlPrefix + data.name
          this.$emit('upSuccess', location)
          this.type == 2
            ? //获取视频第一帧画面
              getVideoPic({ url: location }).then((res) => {
                this.loading = false
                this.$emit('getPicUrl', res.data.url, res.data)
              })
            : (this.loading = false)

          // 使用本地链接提供预览，避免上传后下载的问题
          let url = window.URL.createObjectURL(file)

          let name = file.name
          let memorySize = file.size
          if (!this.multiple) {
            this.fileUrlWatch = url
            this.$emit('update:fileUrl', location)
            this.$emit('update:fileName', (this.fileNameWatch = name))
            this.$emit('update:imgSize', memorySize)
          } else {
            this.fileListWatch = this.fileListWatch.concat({ name, url, memorySize })
            this.$emit('update:fileList', this.fileList.concat({ name, url: location, memorySize }))
          }
        }
      } catch (e) {
        this.loading = false
        this.$message.error('上传失败，请稍后再试')
      }
    },
    tencentFn() {
      this.loading = true
      let file = undefined
      if (!this.multiple || this.limit == 1) {
        file = this.file
      } else {
        // 多选上传是多次调用单传的
        file = this.file.shift()
      }
      let date = new Date()
      let format = file.name.match(/\.(\w+)$/g)
      format = format && format[0]
      const params = {
        Bucket: this.cosConfig.bucketName /* 填入您自己的存储桶，必须字段 */,
        Region: this.cosConfig.region /* 存储桶所在地域，例如ap-beijing，必须字段 */,
        Key: `/${dateFormat(date, 'YYYY-MM-DD')}/t${date.getTime()}-${uuid()}${format}`,
        /* 存储在桶里的对象键（例如1.jpg，a/b/test.txt），必须字段。*/
        // 此处使用的格式: /日期/t时间戳-uid-文件后缀名
      }

      // 实例可能未初始化完成
      if (!this.cosInstance) {
        this.$message.error('存储空间正忙，请稍后再试')
        return
      }

      this.cosInstance.uploadFile(
        {
          ...params,
          Body: file /* 必须，上传文件对象，可以是input[type="file"]的file对象 */,
          onProgress: (progressData) => {
            progressData.percent > 0 && (this.percentage = progressData.percent.toFixed(2) * 100)
            progressData.speed > 0 && (this.speed = (progressData.speed / 1024 / 1024).toFixed(2))
            // this.onProgress && this.onProgress(this.percentage, this.speed)
          },
        },
        (err1, data) => {
          this.percentage = this.speed = 0
          if (err1) {
            this.loading = false
            this.$message.error('上传失败，请稍后再试')
          } else {
            let location = 'https://' + data.Location
            this.$emit('upSuccess', location)
            this.type == 2
              ? //获取视频第一帧画面
                getVideoPic({ url: location }).then((res) => {
                  this.loading = false
                  this.$emit('getPicUrl', res.data.url, res.data)
                })
              : (this.loading = false)

            // 使用本地链接提供预览，避免上传后下载的问题
            let url = window.URL.createObjectURL(file)

            let name = file.name
            let memorySize = file.size
            if (!this.multiple) {
              this.fileUrlWatch = url
              this.$emit('update:fileUrl', location)
              this.$emit('update:fileName', (this.fileNameWatch = name))
              this.$emit('update:imgSize', memorySize)
            } else {
              this.fileListWatch = this.fileListWatch.concat({ name, url, memorySize })
              this.$emit('update:fileList', this.fileList.concat({ name, url: location, memorySize }))
            }
          }
        },
      )
    },
    remove(i) {
      this.$confirm('确定要删除吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        let clone = JSON.parse(JSON.stringify(this.fileList))
        this.fileListWatch.splice(i, 1)
        clone.splice(i, 1)
        this.$emit('update:fileList', clone)
      })
    },
    handleExceed(file, fileList) {
      this.$message.error('最多上传' + this.limit + '张')
      this.loading = false
    },
    async handleBeforeUpload(file, filelist) {
      this.loading = true
      let isFormat = true
      let isSize = true

      // type： 0 图片（image）、1 语音（voice）、2 视频（video），3 普通文件(file)

      // 统一校验文件后缀名格式
      // 如果没有显示配置 format 格式限制，则使用默认下面校验
      let format = this.format
      let tip = ''
      if (!format || !format.length) {
        let formatDefault = {
          0: { tip: 'png/jpg', value: ['png', 'jpg', 'jpeg'] },
          1: { value: ['amr'] },
          2: { value: ['mp4'] },
          3: { tip: 'word/pdf/ppt', value: ['doc', 'docx', 'pdf', 'ppt', 'pptx', 'pps', 'pptsx'] },
        }
        format = formatDefault[this.type].value
        tip = formatDefault[this.type].tip
      }

      const reg = new RegExp(`\\.(${format.join('|')})$`, 'ig') // /\.xlsx|.$/
      isFormat = format[0] === '*' || reg.test(file.name)
      if (!isFormat) {
        this.$message.error('文件格式错误，仅支持 ' + (tip || format.join('，')) + ' 格式!')
        this.loading = false
        return Promise.reject()
      }

      // 统一校验文件体积
      // 如果没有显式配置 maxSize 限制大小，则使用下面默认值，单位 MB，
      let maxSize = this.maxSize
      if (!maxSize) {
        let maxSizeDefault = { 0: 2, 1: 2, 2: 100, 3: 50 }
        maxSize || (maxSize = maxSizeDefault[this.type])
      }
      isSize = file.size / 1024 / 1024 < maxSize
      if (!isSize) {
        this.$message.error('上传文件大小不能超过 ' + maxSize + 'MB!')
        this.loading = false
        return Promise.reject()
      }

      // 各类型独有的校验
      let validate = true
      if (this.type === '0') {
        // 图片
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
                  validate = false
                  this.$message.error(`图片“宽”度超过${maxImgPx[0]}像素，请重新选择`)
                } else if (height > maxImgPx[1]) {
                  this.$message.error(`图片“高”度超过${maxImgPx[1]}像素，请重新选择`)
                  validate = false
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
        let amr = new BenzAMRRecorder()
        try {
          await amr.initWithBlob(file)
          validate = amr.getDuration() <= 60
          if (!validate) {
            this.$message.error('上传文件时长不能超过 60秒!')
          }
        } catch (error) {
          console.log(error)
          this.$message.error('文件已损坏')
        }
      } else if (this.type === '2') {
        // 视频
        let result = await this.checkVideoCode(file)
        if (result.mime.indexOf('video/mp4') === -1) {
          this.$message.error('mp4 格式不正确, 请使用标准编码视频!')
          this.loading = false
          return Promise.reject()
        }
      } else if (this.type === '3') {
        // 普通文件
      }
      if (!validate) {
        this.loading = false
      }
      // if (beforeUpload) {
      //   return beforeUpload(file)
      // }
      else if (!this.multiple || this.limit == 1) {
        this.file = file
      } else {
        Array.isArray(this.file) || (this.file = []) // 多选
        this.file.push(file)
      }
      return validate || Promise.reject()
    },
    onError(err, file, fileList) {
      this.loading = false
      this.$message.error('上传文件失败')
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
    showView(index) {
      let imager = index !== undefined ? this.$refs.image[index] : this.$refs.image
      imager.$el.firstElementChild.click()
      // this.$nextTick(() => {
      //   // 为遮罩层添加关闭事件
      //   let maskEl = imager.$children[0].$refs['el-image-viewer__wrapper'].firstChild
      //   maskEl.addEventListener('click', () => {
      //     event.stopPropagation()
      //     imager.closeViewer()
      //   })
      // })
      // this.$refs.image.$refs.closeViewer();
    },
  },
}
</script>

<template>
  <div>
    <!-- 多个上传文件列表展示 -->
    <template v-if="multiple">
      <!-- 图片 -->
      <template v-if="type == 0">
        <!-- <transition-group> -->
        <div v-for="(item, index) in fileListWatch" :key="index" class="img-item upload-item">
          <el-image
            ref="image"
            class="upload-img uploader-size"
            :src="item.url"
            fit="contain"
            :preview-src-list="fileListWatch.map((e) => e.url)"
            alt="" />
          <div class="action-mask">
            <el-icon-search class="el-icon-search mr5" @click="showView(index)"></el-icon-search>
            <!-- <span v-if="action.includes('download')" @click="download(item)">
              <el-icon-download class="el-icon-download"></el-icon-download>
            </span> -->
            <el-icon-delete class="el-icon-delete mr5" @click="remove(index)"></el-icon-delete>
          </div>
        </div>
        <!-- </transition-group> -->
      </template>
      <!-- 后续再这里扩展其他文件列表 -->
    </template>

    <el-upload
      v-if="!multiple || !limit || fileListWatch.length < limit"
      class="uploader"
      action="/api"
      :accept="accept || acceptAuto"
      :http-request="upload"
      :data="{ mediaType: type }"
      :show-file-list="false"
      :file-list="fileListWatch"
      :disabled="loading"
      :multiple="multiple && limit != 1"
      :limit="limit"
      :on-error="onError"
      :on-exceed="handleExceed"
      :before-upload="handleBeforeUpload">
      <!--
      element-loading-text="正在上传..."
        :on-success="onSuccess"
       -->

      <slot>
        <div v-if="!loading && !fileUrlWatch" class="uploader-icon upload-action uploader-size">
          <el-icon-plus class="el-icon-plus" />
        </div>

        <TransitionGroup>
          <!-- 上传进度条 -->
          <div class="upload-action uploader-size" v-if="loading" :key="1">
            <el-progress v-if="percentage" class="progress cc" type="circle" :percentage="percentage"></el-progress>
            <div class="el-loading-spinner">
              <svg viewBox="25 25 50 50" class="circular">
                <circle cx="50" cy="50" r="20" fill="none" class="path"></circle>
              </svg>
            </div>
            <div class="cc" style="margin-top: 35px" v-if="speed">
              {{ speed + 'M/s' }}
            </div>
          </div>

          <!-- 单文件上传的文件展示 -->
          <div v-if="!loading && fileUrlWatch && !multiple" class="upload-item" :key="2">
            <template v-if="type === '0'">
              <el-image
                v-if="fileUrlWatch"
                ref="image"
                :src="fileUrlWatch"
                class="upload-img upload-img-single uploader-size"
                :preview-src-list="[fileUrlWatch]"
                preview-teleported
                fit="contain"
                @click.stop />

              <div class="action-mask" @click.self.stop>
                <el-icon-search class="el-icon-search" @click.stop="showView()"></el-icon-search>
                <el-icon-EditPen class="el-icon-EditPen"></el-icon-EditPen>
                <!-- <span v-if="action.includes('download')" @click.prevent.stop="download(item)">
              <el-icon-download class="el-icon-download"></el-icon-download>
            </span> -->
                <!-- <span @click.prevent.stop="remove()">
                  <el-icon-delete class="el-icon-delete"></el-icon-delete>
                </span> -->
              </div>
            </template>
            <template v-else-if="type === '2'">
              <video
                ref="video"
                id="myVideo"
                class="upload-video"
                width="100%"
                controls
                webkit-playsinline="true"
                playsinline="true"
                :autoplay="false"
                :key="fileUrlWatch"
                preload="auto">
                <source :src="fileUrlWatch" type="video/mp4" />
              </video>
              <div class="action-mask" style="height: 30%" @click.self.stop>
                <el-icon-EditPen class="el-icon-EditPen"></el-icon-EditPen>
              </div>
            </template>
            <template v-else class="al">
              {{ fileNameWatch || fileUrlWatch }}
              <el-icon-EditPen class="el-icon-EditPen ml10"></el-icon-EditPen>
              <!-- a链接用本地视频打不开，视频地址使用远程地址 -->
              <a @click.stop :href="/\.mp4$/.test(fileNameWatch) ? fileUrl : fileUrlWatch" target="_blank">
                <el-icon-view class="el-icon-view ml10" style="vertical-align: middle"></el-icon-view>
              </a>
            </template>
          </div>
        </TransitionGroup>
      </slot>
    </el-upload>

    <!-- 上传格式，大小等提示语 -->
    <div class="tip">
      <slot name="tip"></slot>
    </div>
  </div>
</template>

<style lang="scss" scoped>
::v-deep.uploader {
  display: inline-block;
  vertical-align: middle;
  .el-upload {
    display: block;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
}
// 默认组件大小，如需修改，请通过外部重写该类样式
.uploader-size {
  width: 178px;
  height: 178px;
}
.upload-action {
  position: relative;
  text-align: center;
}
.uploader-icon {
  display: flex;
  font-size: 28px;
  align-items: center;
  justify-content: center;
  color: var(--font-black-6);
  border-radius: 6px;
  border: 1px dashed var(--border-black-10);
  transition: all 0.3s;
  &:hover {
    border-color: var(--color);
    color: var(--color);
  }
}
.progress {
  overflow: hidden;
}
.upload-img-single {
  border: 1px dashed var(--border-black-9);
}
.upload-img {
  display: block;
}
.upload-video {
  display: block;
  width: 300px;
  height: 150px;
  box-sizing: border-box;
  color: var(--font-white, #fff);
  background-color: var(--bg-black);
  position: relative;
  padding: 0;
  font-size: 10px;
  line-height: 1;
  font-weight: normal;
  font-style: normal;
  word-break: initial;
}
.tip {
  color: var(--font-black-7);
  font-size: 12px;
  line-height: 1.5;
  margin-top: 5px;
}
.img-item {
  position: relative;
  display: inline-block;
  vertical-align: middle;
  margin: 0 10px 10px 0;
  transition: all 0.3s;
}
.action-mask {
  position: absolute;
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 0 30px;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  cursor: pointer;
  text-align: center;
  color: var(--font-white, #fff);
  opacity: 0;
  font-size: 20px;
  transition: opacity 0.3s;
  background-color: var(--bg-black-5);
  z-index: 1;
}
.upload-item {
  &:hover {
    .action-mask {
      opacity: 1;
    }
  }
}
</style>
