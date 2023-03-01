<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form label-width="110px" label-position="right">
          <div class="g-card">
            <el-form-item label="使用员工" required :error="userError" v-if="showMember">
              <el-tag sizi="mini" v-for="(unit, key) in users" :key="key">{{ unit.name }}</el-tag>
              <div>
                <el-button type="primary" size="mini" plain @click="onSelectUser">选择员工</el-button>
              </div>
              <div class="sub-des">
                一个员工被设置多个欢迎语时，以最新设置或修改的为准，如果通过活码添加，则只推送活码欢迎语
              </div>
            </el-form-item>
            <!-- 欢迎语 -->
            <div class="my-cord">
              <div v-if="showTemplate" class="operation" @click="getWelList(), (dialogVisibleSelectWel = true)">
                <i class="el-icon-menu mr5"></i>
                从模板库中选择
              </div>
              <div v-if="!showTemplate" class="operation" @click="onChooseMaterialWel()">
                <i class="el-icon-menu mr5"></i>
                从素材中选择
              </div>
              <el-form-item
                :label="isgroup ? '消息内容' : '欢迎语'"
                required
                style="margin-right: 200px !important"
                :error="welcomeMsgError">
                <el-input
                  ref="msgTextarea"
                  type="textarea"
                  v-model="form.welcomeMsg"
                  maxlength="2000"
                  show-word-limit
                  placeholder="请输入"
                  :autosize="{ minRows: 5, maxRows: 20 }"
                  clearable />
              </el-form-item>
              <el-form-item style="" v-if="!isgroup">
                <el-checkbox v-model="isChecked" @change="onInsert">插入客户昵称</el-checkbox>
              </el-form-item>
            </div>
          </div>

          <!-- 附件 -->
          <div class="g-card" v-for="(item, index) in form.materialMsgList" :key="index">
            <!-- 文本 -->
            <div class="my-cord" v-if="item.msgType == '4'">
              <div class="operation">
                <div v-if="showMorMaterial" class="algin" @click="onChooseMaterial(item.msgType, index)">
                  <i class="el-icon-menu mr5"></i>
                  从素材中选择
                </div>
                <div class="algin" @click="onRemoveMaterial(index)">
                  <i class="el-icon-delete mr5"></i>
                  删除
                </div>
              </div>
              <el-form-item label="文本" required style="margin-right: 200px !important" :error="item.contentError">
                <el-input type="text" v-model="item.content" maxlength="200" placeholder="请输入" />
              </el-form-item>
            </div>
            <!-- 图片上传 -->
            <div class="my-cord" v-else-if="item.msgType == '0'">
              <div class="operation">
                <div v-if="showMorMaterial" class="algin" @click="onChooseMaterial(item.msgType, index)">
                  <i class="el-icon-menu mr5"></i>
                  从素材中选择
                </div>
                <div class="algin" @click="onRemoveMaterial(index)">
                  <i class="el-icon-delete mr5"></i>
                  删除
                </div>
              </div>
              <el-form-item label="图片上传" required :error="item.materialUrlError">
                <upload class="image-uploader" :fileUrl.sync="item.materialUrl" type="0"></upload>
              </el-form-item>
            </div>
            <!-- 图文 -->
            <div class="my-cord" v-else-if="item.msgType == '8'">
              <div class="operation">
                <div v-if="showMorMaterial" class="algin" @click="onChooseMaterial(item.msgType, index)">
                  <i class="el-icon-menu mr5"></i>
                  从素材中选择
                </div>
                <div class="algin" @click="onRemoveMaterial(index)">
                  <i class="el-icon-delete mr5"></i>
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
            <div class="my-cord" v-else-if="item.msgType == '9'">
              <div class="operation">
                <div v-if="showMorMaterial" class="algin" @click="onChooseMaterial(item.msgType, index)">
                  <i class="el-icon-menu mr5"></i>
                  从素材中选择
                </div>
                <div class="algin" @click="onRemoveMaterial(index)">
                  <i class="el-icon-delete mr5"></i>
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
                  :autosize="{ minRows: 5, maxRows: 20 }"
                  v-model="item.materialName"
                  placeholder="请输入小程序标题"
                  maxlength="64"
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
                <upload class="image-uploader" :fileUrl.sync="item.coverUrl" type="0"></upload>
              </el-form-item>
            </div>
          </div>

          <!-- 添加附件 -->
          <div class="g-card add-continue" v-show="form.materialMsgList.length <= 8 && showMore()">
            <el-dropdown style="margin-left: 10px" @command="onInsertMaterial">
              <div style="display: flex; align-items: center">
                <img style="margin-right: 5px" :src="require('@/assets/drainageCode/plus-circle.png')" alt="" />
                继续添加附件
              </div>
              <el-dropdown-menu slot="dropdown" trigger="click">
                <!-- <el-dropdown-item :command="4">
                  <el-button type="text">文字</el-button>
                </el-dropdown-item> -->
                <el-dropdown-item :command="'0'" v-if="showType('0')">
                  <el-button type="text">图片</el-button>
                </el-dropdown-item>
                <el-dropdown-item :command="'8'" v-if="showType('8')">
                  <el-button type="text">图文</el-button>
                </el-dropdown-item>
                <el-dropdown-item :command="'9'" v-if="showType('9')">
                  <el-button type="text">小程序</el-button>
                </el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
          <el-form-item v-if="showStepBtn" label-width="0" style="margin-top: 20px">
            <el-button @click="onBackStep" v-if="showBack">上一步</el-button>
            <el-button type="primary" @click="submit">保存</el-button>
          </el-form-item>
        </el-form>
      </el-col>
      <el-col style="width: 350px">
        <div class="g-card" style="height: 100%">
          <preview-client :list="form"></preview-client>
        </div>
      </el-col>
    </el-row>
    <SelectMaterial
      :visible.sync="dialogVisibleSelectMaterial"
      :type="materialType"
      @success="submitSelectMaterial"></SelectMaterial>
    <SelectMaterial
      :visible.sync="dialogVisibleSelectMaterialWel"
      type="4"
      @success="submitSelectMaterialWel"></SelectMaterial>

    <el-dialog key="a" title="选择欢迎语" :visible.sync="dialogVisibleSelectWel" width="500">
      <div>
        <el-input class="welcome-input" placeholder="请输入关键字" v-model="welQuery.welcomeMsg">
          <el-button slot="append" @click="getWelList">查询</el-button>
        </el-input>
        <el-table
          ref="table"
          v-loading="welLoading"
          :data="welList"
          :max-height="300"
          :show-header="false"
          highlight-current-row
          @current-change="(val) => (welSelected = val)">
          <el-table-column property="welcomeMsg" show-overflow-tooltip>
            <template slot-scope="{ row }">
              {{ row.attachments[0].content }}
            </template>
          </el-table-column>
          <el-table-column width="60">
            <template slot-scope="{ row }">
              <i
                v-if="welSelected.id === row.id"
                class="el-icon-check"
                style="color: rgb(65, 133, 244); font-size: 25px"></i>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div slot="footer">
        <el-button @click="dialogVisibleSelectWel = false">取 消</el-button>
        <el-button type="primary" @click="selectWelcome">确 定</el-button>
      </div>
    </el-dialog>
    <SelectWeUser
      :defaultValues="selectedUserList"
      :visible.sync="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"></SelectWeUser>
  </div>
</template>

<script>
import SelectMaterial from '@/components/SelectMaterial'
import { getList } from '@/api/drainageCode/welcome'
import PreviewClient from '@/components/previewInMobileClient.vue'
const materialField = {
  audioTime: '', // 音频时长
  content: '', // 内容 小程序路径
  coverUrl: '', // 封面图
  digest: '', // 摘要
  materialName: '', // 图片名称、7图文标题、8小程序标题
  materialUrl: '', // 本地资源文件地址、小程序AppID
  contentError: '', // 表单校验
  materialUrlError: '',
  materialNameError: '',
  coverUrlError: '',
}
export default {
  name: 'welcome-detail',
  components: {
    SelectMaterial,
    PreviewClient,
  },
  props: {
    baseData: {
      type: Object,
      default: () => {
        return {
          welcomeMsg: '',
          materialMsgList: [],
        }
      },
    },
    isgroup: {
      type: Boolean,
      default: false,
    },
    showTemplate: {
      type: Boolean,
      default: true,
    },
    showMember: {
      type: Boolean,
      default: false,
    },
    showBack: {
      type: Boolean,
      default: false,
    },
    showMorMaterial: {
      type: Boolean,
      default: false,
    },
    showStepBtn: {
      type: Boolean,
      default: true,
    },
    currentActive: {
      type: Number,
    },
    isSingle: {
      type: Boolean,
      default: false,
    },
    strType: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    baseData(val) {
      if (val.welcomeMsg) {
        this.form.welcomeMsg = val.welcomeMsg
        this.form.materialMsgList = val.materialMsgList
        this.form.userIds = val.userIds
        this.form.userNames = val.userNames
        this.setData()
        this.$forceUpdate()
      }
    },
  },
  data() {
    return {
      userError: '',
      isChecked: false,
      form: {
        welcomeMsg: '',
        materialMsgList: [],
        userIds: '',
        userNames: '',
      },
      users: [],
      welcomeMsgError: '',
      dialogVisibleSelectMaterial: false,
      materialType: '',
      dialogVisibleSelectWel: false,
      dialogVisibleSelectMaterialWel: false,
      // 遮罩层
      loading: false,
      welQuery: {
        welcomeMsg: '',
      },
      welLoading: false,
      welList: [],
      welSelected: {
        id: '',
      },
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      strTemplate1: '%NICKNAME%',
      strTemplate2: '#客户昵称#',
    }
  },
  mounted() {
    if (this.baseData.welcomeMsg) {
      this.form.welcomeMsg = this.baseData.welcomeMsg
      this.form.materialMsgList = this.baseData.materialMsgList
      this.form.userIds = this.baseData.userIds
      this.form.userNames = this.baseData.userNames
      this.setData()
    }
  },
  methods: {
    setData() {
      this.selectedUserList = []
      let arr = []
      if (this.form.userIds) {
        arr = this.form.userIds.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.form.userNames.split(',')[index],
          }
        })
      }
      this.users = arr
    },
    showType(type) {
      let exit = true
      if (this.isSingle) {
        this.form.materialMsgList.forEach((dd) => {
          if (dd.msgType === type) {
            exit = false
          }
        })
      }
      return exit
    },
    showMore() {
      let exit = true
      if (this.isSingle) {
        if (this.form.materialMsgList.length === 1) {
          exit = false
        }
      }
      return exit
    },
    onSelectUser() {
      this.userError = ''
      this.selectedUserList = []
      let arr = []
      if (this.form.userIds) {
        arr = this.form.userIds.split(',').map((dd, index) => {
          return {
            userId: dd,
            name: this.form.userNames.split(',')[index],
          }
        })
      }
      this.selectedUserList = arr
      this.dialogVisibleSelectUser = true
    },
    selectedUser(users) {
      let ids = []
      let names = []
      const selectedUserList = users.map((d) => {
        ids.push(d.userId)
        names.push(d.name)
        return {
          userId: d.userId,
          name: d.name,
        }
      })
      this.users = selectedUserList
      this.form.userIds = ids.join(',')
      this.form.userNames = names.join(',')
    },
    // 插入客户昵称
    onInsert(val) {
      this.isChecked = val
      const $textarea = this.$refs.msgTextarea.$el.children[0]
      const msg = this.form.welcomeMsg
      if (val) {
        const textIndex = $textarea.selectionStart
        if (textIndex == 0 && document.activeElement != $textarea) {
          this.form.welcomeMsg += this.strType ? this.strTemplate1 : this.strTemplate2
        } else {
          let str = this.strType ? this.strTemplate1 : this.strTemplate2
          this.form.welcomeMsg = msg.slice(0, textIndex) + str + msg.slice(textIndex)
        }
      } else {
        this.form.welcomeMsg = this.strType ? msg.replace(/\%NICKNAME\%/, '') : msg.replace(/\#客户昵称\#/, '')
      }
    },
    onChooseMaterial(materialType, rowIndex) {
      this.materialType = materialType
      this.rowIndex = rowIndex
      this.dialogVisibleSelectMaterial = true
    },
    submitSelectMaterial(data) {
      this.form.materialMsgList.splice(
        this.rowIndex,
        1,
        Object.assign({}, this.form.materialMsgList[this.rowIndex], data),
      )
    },
    onChooseMaterialWel() {
      this.dialogVisibleSelectMaterialWel = true
    },
    submitSelectMaterialWel(data) {
      this.isChecked = false
      this.form.welcomeMsg = data.content
    },
    onInsertMaterial(e) {
      this.form.materialMsgList.push({
        msgType: e,
        ...materialField,
      })
    },
    onRemoveMaterial(index) {
      this.form.materialMsgList.splice(index, 1)
    },
    // 上一步
    onBackStep() {
      this.$emit('update')
    },
    validateMaterial() {
      let materialList = this.form.materialMsgList

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
        8: [
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
        9: [
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
      }

      return materialList.every((i) => {
        let validateList = validateFields[i.msgType]
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
    /** 获取欢迎语列表 */
    getWelList() {
      this.welLoading = true
      getList(this.welQuery).then(({ rows }) => {
        this.welList = rows
        this.$refs.table.$forceUpdate()
        this.welLoading = false
      })
    },

    // 欢迎语确认按钮
    selectWelcome() {
      this.form.welcomeMsg = this.welSelected.attachments ? this.welSelected.attachments[0].content : ''
      this.form.materialMsgList = this.welSelected.attachments ? this.getData(this.welSelected.attachments) : []
      this.welSelected = {
        id: '',
      }
      this.$forceUpdate()
      this.dialogVisibleSelectWel = false
    },
    getData(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              msgType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              msgType: '9',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
      // })
    },
    resetData(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === '0') {
            let obj = {
              msgType: 'image',
              picUrl: dd.materialUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === '8') {
            let ob = {
              msgType: 'link',
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === '9') {
            let ff = {
              msgType: 'miniprogram',
              appId: dd.digest,
              title: dd.materialName,
              picUrl: dd.coverUrl,
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
          if (dd.msgType === 'image') {
            let obj = {
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              msgType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              msgType: '9',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    submit() {
      if (this.showMember && !this.form.userIds) {
        this.userError = '请选择员工！'
        return
      }
      if (!this.form.welcomeMsg) {
        this.welcomeMsgError = '请输入欢迎语'
        return
      } else {
        this.welcomeMsgError = ''
      }
      const checkMaterialResult = this.validateMaterial()
      if (checkMaterialResult) {
        let goto = true
        this.form.materialMsgList.forEach((dd) => {
          if (dd.msgType === '8') {
            let reUrl = /(http|https):\/\/([\w.]+\/?)\S*/
            if (!reUrl.test(dd.materialUrl)) {
              goto = false
              dd.materialUrlError = '必须以 http://或 https://开头'
            }
          }
          if (dd.msgType === '9') {
            let htm = /^.*html$/
            if (!htm.test(dd.materialUrl)) {
              goto = false
              dd.materialUrlError = '必须以 html 作为后缀'
            }
          }
        })
        this.$forceUpdate()
        if (goto) {
          if (this.form.userIds) {
            this.form.userIds = this.form.userIds.split(',')
            this.form.userNames = this.form.userNames.split(',')
            delete this.form.users
          }
          // this.msgInfo('校验通过')
          this.$emit('submit', this.form)
          return true
        } else {
          return false
        }
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
  color: #999999;
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
    color: #1785ff;
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
