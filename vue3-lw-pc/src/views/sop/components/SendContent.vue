<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form label-width="110px" label-position="right">
          <div class="g-card" v-for="(item, index) in attachments" :key="index">
            <!-- 文本 -->
            <div class="my-cord" v-if="item.msgType == '4'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item label="文本" required style="margin-right: 200px !important" :error="item.contentError">
                <TextareaExtend
                  v-model="item.content"
                  maxlength="2000"
                  :autosize="{ minRows: 5, maxRows: 20 }"
                  show-word-limit
                  placeholder="请输入" />
              </el-form-item>
            </div>
            <!-- 图片上传 -->
            <div class="my-cord" v-else-if="item.msgType == '0'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item label="图片上传" required :error="item.materialUrlError">
                <upload class="image-uploader" v-model:fileUrl="item.materialUrl" type="0"></upload>
              </el-form-item>
            </div>
            <!-- 图文 -->
            <div class="my-cord" v-else-if="item.msgType == '9'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item
                label="图文标题"
                style="margin-right: 200px !important"
                required
                :error="item.materialNameError">
                <el-input
                  type="textarea"
                  :autosize="{ minRows: 5 }"
                  v-model="item.materialName"
                  placeholder="请输入图文标题"
                  maxlength="64"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item
                label="图文链接"
                style="margin-right: 200px !important"
                required
                :error="item.materialUrlError">
                <el-input v-model="item.materialUrl" placeholder="请输入图文链接"></el-input>
                <div class="sub-des">仅支持公众号图文链接，且必须以 http://或 https://开头</div>
              </el-form-item>
            </div>
            <!-- 小程序 -->
            <div class="my-cord" v-else-if="item.msgType == '11'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item
                label="小程序标题"
                style="margin-right: 200px !important"
                required
                :error="item.materialNameError">
                <el-input
                  type="textarea"
                  :autosize="{ minRows: 2, maxRows: 20 }"
                  v-model="item.materialName"
                  placeholder="请输入小程序标题"
                  maxlength="32"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item
                label="小程序AppID"
                style="margin-right: 200px !important"
                required
                :error="item.digestError">
                <el-input v-model="item.digest" placeholder="请输入小程序AppID"></el-input>
                <div class="sub-des">必须是审核通过，正常发布，且关联到企业的小程序应用</div>
              </el-form-item>
              <el-form-item
                label="小程序路径"
                style="margin-right: 200px !important"
                required
                :error="item.materialUrlError">
                <el-input v-model="item.materialUrl" placeholder="请输入小程序路径"></el-input>
                <div class="sub-des">必须以 html 作为后缀</div>
              </el-form-item>
              <el-form-item label="小程序封面" required :error="item.coverUrlError">
                <upload class="image-uploader" v-model:fileUrl="item.coverUrl" type="0"></upload>
              </el-form-item>
            </div>
            <!-- 视频 -->
            <div class="my-cord" v-else-if="item.msgType == '2'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item
                label="视频标题"
                style="margin-right: 200px !important"
                required
                :error="item.materialNameError">
                <el-input
                  type="textarea"
                  :autosize="{ minRows: 2, maxRows: 20 }"
                  v-model="item.materialName"
                  placeholder="请输入视频标题"
                  maxlength="60"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item label="视频描述" style="margin-right: 200px !important">
                <el-input
                  v-model="item.digest"
                  placeholder="请输入视频描述"
                  type="textarea"
                  :autosize="{ minRows: 2, maxRows: 20 }"
                  maxlength="100"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item label="上传视频" required :error="item.materialUrlError">
                <Upload
                  class="image-uploader"
                  v-model:fileUrl="item.materialUrl"
                  @getPicUrl="getVideoPic($event, index)"
                  type="2"></Upload>
                <div class="sub-des">支持mp4/mov格式，视频大小不超过100M</div>
              </el-form-item>
            </div>
            <!-- 文件 -->
            <div class="my-cord" v-else-if="item.msgType == '3'">
              <div class="operation">
                <div class="algin" v-if="showMorMaterial" @click="onChooseMaterial(item.msgType, index)">
                  <el-icon-menu class="el-icon-menu mr5" />
                  从素材中选择
                </div>
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item
                label="文件标题"
                style="margin-right: 200px !important"
                required
                :error="item.materialNameError">
                <el-input
                  type="textarea"
                  :autosize="{ minRows: 2, maxRows: 20 }"
                  v-model="item.materialName"
                  placeholder="请输入文件标题"
                  maxlength="60"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item label="文件描述" style="margin-right: 200px !important">
                <el-input
                  v-model="item.digest"
                  placeholder="请输入文件描述"
                  type="textarea"
                  :autosize="{ minRows: 2, maxRows: 20 }"
                  maxlength="100"
                  show-word-limit
                  clearable></el-input>
              </el-form-item>
              <el-form-item label="上传文件" required :error="item.materialUrlError">
                <Upload
                  class="image-uploader"
                  v-model:fileUrl="item.materialUrl"
                  v-model:fileName="item.materialName"
                  type="3"></Upload>
                <div class="sub-des">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
              </el-form-item>
            </div>

            <div class="my-cord" v-else-if="item.msgType == '12'">
              <div class="operation">
                <div class="algin" v-if="attachments.length > 1" @click="onRemoveMaterial(index)">
                  <el-icon-delete class="el-icon-delete mr5" />
                  删除
                </div>
              </div>
              <el-form-item label="表单" required :error="item.digestError">
                <el-select v-model="item.digest" @change="setSelectChange($event, index)">
                  <el-option
                    v-for="(unit, key) in surveyDataList"
                    :key="key"
                    :label="unit.surveyName"
                    :value="unit.id"></el-option>
                </el-select>
              </el-form-item>
            </div>
          </div>
          <!-- 添加附件 -->
          <div class="g-card add-continue" v-show="attachments.length < 9">
            <el-dropdown style="margin-left: 10px" @command="onInsertMaterial">
              <div style="display: flex; align-items: center">
                <el-icon-CirclePlus class="el-icon-CirclePlus mr5"></el-icon-CirclePlus>
                继续添加附件(已配置{{ attachments.length }}/9条内容)
              </div>
              <template #dropdown>
                <el-dropdown-menu trigger="click">
                  <el-dropdown-item v-if="show" :command="'4'">
                    <el-button text>文本</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'0'">
                    <el-button text>图片</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'9'">
                    <el-button text>图文</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'11'">
                    <el-button text>小程序</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'2'">
                    <el-button text>视频</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'3'">
                    <el-button text>文件</el-button>
                  </el-dropdown-item>
                  <el-dropdown-item :command="'12'">
                    <el-button text>表单</el-button>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-form>
      </el-col>
    </el-row>
    <SelectMaterial
      v-model:visible="dialogVisibleSelectMaterial"
      :type="materialType"
      @success="submitSelectMaterial"></SelectMaterial>
  </div>
</template>

<script>
import { surveyList } from '@/api/drainageCode/smartForms.js'
import SelectMaterial from './SelectMaterial/index.vue'
const materialField = {
  audioTime: '', // 音频时长
  content: '', // 内容 小程序路径
  coverUrl: '', // 封面图
  digest: '', // 摘要
  digestError: '', // 摘要
  materialName: '', // 图片名称、7图文标题、8小程序标题
  materialUrl: '', // 本地资源文件地址、小程序AppID
  contentError: '', // 表单校验
  materialUrlError: '',
  materialNameError: '',
  coverUrlError: '',
}
export default {
  name: 'send-content',
  components: {
    SelectMaterial,
  },
  props: {
    baseData: {
      type: Array,
      default: () => {
        return [
          {
            msgType: '4',
            ...materialField,
          },
        ]
      },
    },
    showMorMaterial: {
      type: Boolean,
      default: true,
    },
    currentActive: {
      type: Number,
    },
    sendType: {
      type: Number,
      default: 1,
    },
  },
  watch: {
    baseData: {
      deep: true,
      handler(val) {
        if (val) {
          this.attachments = []
          if (val.length) {
            this.attachments = this.setEditList(val)
          } else {
            this.attachments.push({
              msgType: '4',
              ...materialField,
            })
          }
          // this.$forceUpdate()
        }
      },
    },
    attachments: {
      deep: true,
      immediate: true,
      handler(val) {
        this.setShow()
      },
    },
  },
  data() {
    return {
      show: true,
      surveyId: '',
      surveyDataList: [],
      attachments: [
        {
          msgType: '4',
          ...materialField,
        },
      ],
      dialogVisibleSelectMaterial: false,
      materialType: '',
      dialogVisibleSelectWel: false,
      dialogVisibleSelectMaterialWel: false,
      // 遮罩层
      loading: false,
    }
  },
  mounted() {
    if (this.baseData && this.baseData.length) {
      this.attachments = this.setEditList(JSON.parse(JSON.stringify(this.baseData)))
      this.setShow()
    }
    surveyList({ pageSize: 10000, pageNum: 1 }).then((res) => {
      if (res.code === 200) {
        this.surveyDataList = res.rows
      }
    })
  },
  methods: {
    preview() {
      let arr = this.resetData(this.attachments)
      return arr
    },
    getVideoPic(data, index) {
      this.attachments[index].coverUrl = data
      console.log(this.attachments[index])
    },
    setShow() {
      this.show = true
      if (this.sendType === 1) {
        let index = this.attachments.findIndex((dd) => dd.msgType == '4')
        if (index !== -1) {
          this.show = false
        } else {
          this.show = true
        }
      }
    },
    setSelectChange(id, index) {
      // /#/formsDetail?id=true&formId=35&dataSource=Default&channelsName=默认渠道
      if (id) {
        let order = this.surveyDataList.findIndex((dd) => dd.id == id)
        let str = `/formsDetail?id=true&formId=${id}&dataSource=${this.surveyDataList[order].channelsPath}&channelsName=${this.surveyDataList[order].channelsName}`
        this.attachments[index].materialUrl = window.location.origin + str
        this.attachments[index].materialName = this.surveyDataList[order].surveyName
        this.attachments[index].digest = id
      }
    },
    onChooseMaterial(materialType, rowIndex) {
      this.materialType = materialType
      this.rowIndex = rowIndex
      this.dialogVisibleSelectMaterial = true
    },
    submitSelectMaterial(data) {
      if (this.materialType == '4') {
        delete data.id
      }
      this.attachments.splice(this.rowIndex, 1, Object.assign({}, this.attachments[this.rowIndex], data))
    },
    onChooseMaterialWel() {
      this.dialogVisibleSelectMaterialWel = true
    },
    onInsertMaterial(e) {
      // if (e === '12') {
      //   surveyList({ pageSize: 10000, pageNum: 1 }).then((res) => {
      //     if (res.code === 200) {
      //       this.surveyDataList = res.rows
      //     }
      //   })
      // }
      this.attachments.push({
        msgType: e,
        ...materialField,
      })
    },
    onRemoveMaterial(index) {
      this.attachments.splice(index, 1)
    },
    validateMaterial() {
      let materialList = this.attachments
      const validateFields = {
        4: [
          {
            checkField: 'content',
            errorField: 'contentError',
            errorMsg: '请输入文本',
          },
        ],
        0: [
          {
            checkField: 'materialUrl',
            errorField: 'materialUrlError',
            errorMsg: '请上传图片',
          },
        ],
        9: [
          {
            checkField: 'materialName',
            errorField: 'materialNameError',
            errorMsg: '请输入图文标题',
          },
          {
            checkField: 'materialUrl',
            errorField: 'materialUrlError',
            errorMsg: '请输入图文链接',
          },
        ],
        11: [
          {
            checkField: 'materialName',
            errorField: 'materialNameError',
            errorMsg: '请输入小程序标题',
          },
          {
            checkField: 'digest',
            errorField: 'digestError',
            errorMsg: '请输入小程序AppID',
          },
          {
            checkField: 'materialUrl',
            errorField: 'materialUrlError',
            errorMsg: '请输入小程序路径',
          },
          {
            checkField: 'coverUrl',
            errorField: 'coverUrlError',
            errorMsg: '请上传小程序封面',
          },
        ],
        2: [
          {
            checkField: 'materialName',
            errorField: 'materialNameError',
            errorMsg: '请输入视频标题',
          },
          // {
          //   checkField: 'digest',
          //   errorField: 'digestError',
          //   errorMsg: '请输入视频描述'
          // },
          {
            checkField: 'materialUrl',
            errorField: 'materialUrlError',
            errorMsg: '请上传视频',
          },
        ],
        3: [
          {
            checkField: 'materialName',
            errorField: 'materialNameError',
            errorMsg: '请输入文件标题',
          },
          // {
          //   checkField: 'digest',
          //   errorField: 'digestError',
          //   errorMsg: '请输入文件描述'
          // },
          {
            checkField: 'materialUrl',
            errorField: 'materialUrlError',
            errorMsg: '请上传文件',
          },
        ],
        12: [
          {
            checkField: 'digest',
            errorField: 'digestError',
            errorMsg: '请选择表单',
          },
        ],
      }

      return materialList.every((i, index) => {
        let validateList = JSON.parse(JSON.stringify(validateFields[i.msgType]))
        let goto = true
        validateList.forEach((validate) => {
          if (!i[validate.checkField]) {
            i[validate.errorField] = validate.errorMsg
            goto = false
          } else {
            i[validate.errorField] = ''
          }
        })
        return goto
      })
    },
    resetData(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === '4') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: 'text',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === '0') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: 'image',
              picUrl: dd.materialUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === '9') {
            let ob = {
              id: dd.id ? dd.id : '',
              msgType: 'link',
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === '11') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: 'miniprogram',
              appId: dd.digest,
              title: dd.materialName,
              picUrl: dd.coverUrl,
              linkUrl: dd.materialUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === '2') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: 'video',
              description: dd.digest,
              title: dd.materialName,
              linkUrl: dd.materialUrl,
              picUrl: dd.coverUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === '3') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: 'file',
              description: dd.digest,
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === '12') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: 'link',
              appId: dd.digest,
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'link' && dd.appId) {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '12',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
              digest: dd.appId,
            }
            arr.push(obj)
          } else if (dd.msgType === 'text') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === 'image') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              id: dd.id ? dd.id : '',
              msgType: '9',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'video') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '2',
              digest: dd.description,
              materialName: dd.title,
              materialUrl: dd.linkUrl,
              coverUrl: dd.picUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'file') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '3',
              digest: dd.description,
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    submit() {
      const checkMaterialResult = this.validateMaterial()
      if (checkMaterialResult) {
        let goto = true
        this.attachments.forEach((dd) => {
          if (dd.msgType === '9') {
            let reUrl = /(http|https):\/\/([\w.]+\/?)\S*/
            if (!reUrl.test(dd.materialUrl)) {
              goto = false
              dd.materialUrlError = '必须以 http://或 https://开头'
            }
          }
          if (dd.msgType === '11') {
            let htm = /^.*html$/
            if (!htm.test(dd.materialUrl)) {
              goto = false
              dd.materialUrlError = '必须以 html 作为后缀'
            }
          }
        })
        // this.$forceUpdate()
        if (goto) {
          // this.msgInfo('校验通过')
          let arr = this.resetData(this.attachments)
          this.$emit('update', arr)
          return true
        } else {
          return false
        }
      } else {
        this.msgError('请填写完整发送内容！')
      }
    },
  },
}
</script>

<style lang="scss" scoped>
::v-deep .image-uploader {
  .uploader-icon {
    width: 120px;
    height: 114px;
    line-height: 114px;
  }
  .upload-img {
    width: 100px;
    height: 94px;
  }
}
.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}

.add-continue {
  cursor: pointer;
  font-size: 14px;

  font-weight: 400;
  color: var(--color);
  display: flex;
  align-items: center;
  justify-content: center;

  &:hover {
    opacity: 0.8;
  }
}

.my-cord {
  position: relative;

  .operation {
    z-index: 100;
    cursor: pointer;
    position: absolute;
    top: 0;
    right: 0;
    font-size: 12px;

    font-weight: 400;
    color: var(--color);
    display: flex;
    align-items: center;

    .algin {
      margin-left: 20px;
      display: flex;
      align-items: center;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
