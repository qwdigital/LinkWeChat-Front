<template>
  <div>
    <div class="g-card">
      <el-steps :active="currentActive" align-center finish-status="success">
        <el-step title="基础信息"></el-step>
        <el-step title="表单画布"></el-step>
        <el-step title="表单设置"></el-step>
        <el-step title="预览发布"></el-step>
      </el-steps>
    </div>
    <div class="g-card tab-content form1" v-show="currentActive === 1">
      <div class="fxbw">
        <el-form
          style="width: 30%"
          ref="baseForm"
          :rules="baseRules"
          :model="baseForm"
          label-position="left"
          label-width="80px">
          <el-form-item label="表单名称" prop="surveyName">
            <el-input v-model="baseForm.surveyName" maxlength="15" show-word-limit clearable></el-input>
          </el-form-item>
          <el-form-item label="表单分组" prop="groupId">
            <el-select v-model="baseForm.groupId">
              <el-option
                v-for="item in codeCategoryList"
                :key="item.id"
                :label="item.name"
                :value="item.id"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="表单说明">
            <el-switch v-model="ifFormDescription" :active-value="1" :inactive-value="0"></el-switch>
            <div v-if="ifFormDescription == 1">
              <div class="sub-des">开启后，表单首页或表单顶部会有说明文案</div>
              <el-input
                ref="msgTextarea"
                type="textarea"
                v-model="baseForm.formDescription"
                maxlength="200"
                show-word-limit
                placeholder="请填写表单说明"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable />
            </div>
          </el-form-item>
          <el-form-item label="表单logo">
            <el-switch v-model="ifFormLogo" :active-value="1" :inactive-value="0"></el-switch>
            <div v-if="ifFormLogo == 1">
              <div class="sub-des">开启后，表单首页或表单顶部会有logo图</div>
              <upload v-model:fileUrl="baseForm.formLogo" class="image-uploader" @update:file="handleUploadedHeadImage">
                <template #tip><div>建议大小2M以内，仅支持png/jpg等图片类型</div></template>
              </upload>
            </div>
          </el-form-item>
          <el-form-item>
            <el-button plain @click.stop="CancelTheNewOne">取消</el-button>
            <el-button type="primary" @click.stop="nextStep(2)">下一步</el-button>
          </el-form-item>
        </el-form>
        <div>
          <FormsDetail
            :type="1"
            :index="1"
            :surveyName="baseForm.surveyName"
            :ifFormDescription="ifFormDescription"
            :formDescription="baseForm.formDescription"
            :ifFormLogo="ifFormLogo"
            :logoUrl="baseForm.formLogo"
            :FormIdY="formIdN"
            :id="'y'"></FormsDetail>
          <div style="display: flex; justify-content: center">
            <el-radio v-model="visibility" label="0">独立首页</el-radio>
          </div>
        </div>
        <div>
          <FormsDetail
            :type="1"
            :index="2"
            unionDomId="FormsDetail3"
            :surveyName="baseForm.surveyName"
            :ifFormDescription="ifFormDescription"
            :formDescription="baseForm.formDescription"
            :ifFormLogo="ifFormLogo"
            :logoUrl="baseForm.formLogo"
            :FormIdY="formIdN"
            :id="'y'"></FormsDetail>
          <div style="display: flex; justify-content: center">
            <el-radio v-model="visibility" label="1">表单首页</el-radio>
          </div>
        </div>
      </div>
    </div>
    <div class="g-card tab-content" style="height: calc(100vh - 216px)" v-show="currentActive === 2">
      <!-- <el-form
        ref="codeForm"
        :rules="codeRules"
        :model="codeForm"
        label-position="right"
        label-width="100px"
      >
    </el-form> -->
      <Build :pageDataAll="pageDataAll" v-on:toStyles="toStyles"></Build>
      <div class="ar">
        <el-button plain @click.stop="CancelTheNewOne">取消</el-button>
        <el-button @click.stop="currentActive = 1">上一步</el-button>
        <el-button type="primary" @click.stop="nextStep(3)">下一步</el-button>
      </div>
    </div>
    <div class="g-card tab-content form3" v-if="currentActive == 3">
      <el-form style="margin-left: 30%; width: 500px">
        <el-form-item label="定时收集">
          <el-switch v-model="baseForm.tinyint" :active-value="1" :inactive-value="0"></el-switch>
          <div style="width: 350px">
            <el-date-picker
              v-if="baseForm.tinyint"
              style="margin-top: 20px"
              v-model="searchDate"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              type="daterange"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              v-bind="pickerOptions"></el-date-picker>
          </div>
        </el-form-item>
        <el-form-item label="只允许在微信中填写">
          <el-switch
            v-model="baseForm.anAuth"
            :active-value="1"
            :inactive-value="0"
            @change="(val) => val == 0 && (One = 0)"></el-switch>
          <div class="sub-des">开启后会授权登录，提供微信昵称、性别、城市信息</div>
        </el-form-item>
        <el-form-item v-if="baseForm.anAuth == 1" label="每人限制填写1次">
          <el-switch v-model="One" :active-value="1" :inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item v-if="One == 1" style="" label="每人每天限制填写1次">
          <el-switch v-model="OneToOne" :active-value="1" :inactive-value="0"></el-switch>
          <div class="sub-des">填写并提交成功后重复打开问卷时则直接跳转结束页</div>
        </el-form-item>
        <el-form-item style="margin-left: auto !important; width: 280px; text-align: right">
          <el-button plain @click.stop="CancelTheNewOne">取消</el-button>
          <el-button @click.stop="currentActive = 2">上一步</el-button>
          <el-button type="primary" @click.stop="nextStep(4)">下一步</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="g-card tab-content form4" v-show="currentActive === 4">
      <div class="flex">
        <div style="flex-basis: 65%">
          <el-form ref="baseForm" label-position="left" label-width="150px">
            <div style="display: flex; align-items: center">
              <el-form-item label="表单链接">
                <div style="display: flex">
                  <div>
                    <el-input style="width: 400px" v-model="baseFormUrl4" disabled show-word-limit clearable></el-input>
                  </div>
                </div>
              </el-form-item>
              <div style="margin-left: 15px; display: flex; flex-shrink: 0; z-index: 9">
                <div
                  style="color: var(--color); cursor: pointer"
                  type="button"
                  class="copy-btn"
                  :data-clipboard-text="baseFormUrl4">
                  复制
                </div>
              </div>
            </div>

            <el-form-item label="表单二维码">
              <div>
                <div>
                  <div style="display: flex">
                    <div>
                      <canvas class="qrcode" ref="qrCodeUrl"></canvas>
                    </div>
                    <div
                      @click.stop="btnDownload"
                      style="
                        display: flex;
                        align-items: flex-end;
                        margin-bottom: 5px;
                        color: var(--color);
                        cursor: pointer;
                        margin-left: 10px;
                      ">
                      下载二维码
                    </div>
                  </div>
                  <div class="sub-des" style="position: relative; top: -10px">支持手机扫码预览</div>
                </div>
              </div>
            </el-form-item>
            <el-form-item label="是否开启渠道链接">
              <div>
                <div>
                  <div>
                    <el-switch v-model="ifChannelsName" :active-value="1" :inactive-value="0"></el-switch>
                  </div>
                  <div class="sub-des" style="position: relative; top: -10px">
                    开启后将会在默认链接基础上增加渠道标识
                  </div>
                  <div v-if="ifChannelsName" class="add_form4_qd">
                    <div class="add_form4_qd_ul">
                      <div class="add_form4_qd_li1 add_form4_qd_li">渠道</div>
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
                            v-model="ChannelsList[index]" />
                        </div>
                      </div>
                      <div class="add_form4_qd_li2 add_form4_qd_li">
                        {{ baseFormUrl4 + '&dataSource=' }}
                        <el-input type="text" placeholder="请输入渠道标识" v-model="channelsPathList[index]" />
                        <label for=""></label>
                      </div>
                      <div class="add_form4_qd_li3 add_form4_qd_li">
                        <span style="color: var(--color); cursor: pointer" @click.stop="deletChannels(item, index)">
                          取消
                        </span>
                      </div>
                    </div>
                  </div>
                  <div v-if="ifChannelsName" style="color: var(--color); cursor: pointer" @click.stop="addChannels">
                    +继续添加
                  </div>
                </div>
              </div>
            </el-form-item>
            <el-form-item>
              <el-button v-if="!$route.query.currentActiveA" plain @click.stop="removeFn">取消新建</el-button>
              <el-button v-if="$route.query.currentActiveA" plain @click.stop="cancelFn">取消</el-button>
              <el-button v-if="!$route.query.currentActiveA" type="primary" @click.stop="nextStep(3, 4)">
                上一步
              </el-button>
              <el-button v-if="!$route.query.currentActiveA" type="primary" @click.stop="addFormS('fb')">
                确认发布
              </el-button>
              <el-button v-if="$route.query.currentActiveA" type="primary" @click.stop="addFormS()">确认修改</el-button>
            </el-form-item>
          </el-form>
        </div>
        <div v-if="currentActive == 4" style="flex-basis: 35%">
          <FormsDetail :FormIdY="formIdN" unionDomId="FormsDetail4" :id="'y'"></FormsDetail>
        </div>
      </div>
    </div>

    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :selected="selectedTagList"
      @success="submitSelectTag"></SelectTag>

    <!-- 选择使用员工弹窗 -->
    <SelectUser
      :key="codeForm.qrType"
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      :isOnlyLeaf="true"
      :isSigleSelect="codeForm.qrType == 1"
      @success="selectedUser"></SelectUser>
  </div>
</template>
<script>
import QRCode from 'qrcode'
import { getDetail, add, update, getCodeCategoryList } from '@/api/drainageCode/staff'
//新增表单；表单列表查询
import {
  insertInfoToSurvey,
  selectInfoToSurvey,
  updateInfoToSurvey,
  updateSurveyStatus,
  deleteInfoToSurvey,
  // uploadFile,
} from '@/api/drainageCode/smartForms.js'
import FormsDetail from './build/formsDetail.vue'

import SelectMaterial from '@/components/SelectMaterial'
import Build from './build/index'
import { dateFormat } from '@/utils/index'
export default {
  components: {
    SelectMaterial,
    Build,
    FormsDetail,
  },
  watch: {
    One: function (val, oldVal) {
      console.log('valOne', val, oldVal)
      if (val == 0) {
        this.OneToOne = 0
      }
    },
    OneToOne: function (val, oldVal) {
      if (val == 1) {
        this.One = 1
      }
    },
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          let curDay = new Date()
          return time.getTime() <= curDay.setDate(curDay.getDate() - 1)
        },
      },
      dataFormList: '',
      ChannelsList: [], //渠道
      channelsName: '',
      formIdN: '',
      visibility: '0',
      ifPhoneZ: false,
      ifNameZ: false,
      baseFormUrl4: 'http://localhost/formsDetail', //链接
      searchDate: '', // 查询日期
      operationIndex: null,
      formTemp: {}, // 编辑基础数据
      formId: '', //表单Id
      materialData: {
        welcomeMsg: '',
        materialMsgList: [],
      },
      title: '新建',
      currentActive: 1,

      ifFormDescription: 0, //表单说明开关
      ifFormLogo: 0, //表单logo开关
      One: 0, //只能填写一次
      OneToOne: 0, //一人一天填写一次
      ifChannelsName: 1,
      baseForm: {
        channelsName: '', //渠道
        visibility: 0, //独立首页
        surveyName: '', //表单名称
        groupId: '', //表单分组
        styles: '', //表单数据
        fillingRules: 0, //填写规则
        surveyState: 0, //表单状态
        formDescription: '', //表单说明
        formLogo: '', //logo图片路径
        tinyint: 0, //是否定时收集
        anAuth: 0, //是否微信授权
        //多渠道地址,
        channelsPath: '',
        // qrAutoAdd: 1, // 自动通过
        // weEmpleCodeTags: [], // 标签
      },
      channelsPathList: [],
      baseRules: {
        surveyName: [
          {
            required: true,
            message: '请输入表单名称',
            trigger: 'blur',
          },
        ],
        groupId: [
          {
            required: true,
            message: '请选择分组',
            trigger: 'blur',
          },
        ],
      },

      pageDataAll: null,
      codeForm: {
        qrType: 1,
        qrRuleType: 1,
        weEmpleCodeUseScops: [],
        empleCodeRosterDto: [
          {
            type: 0,
            weEmpleCodeUseScops: [], // 员工
            weekday: [1, 2, 3, 4, 5, 6, 7], // 周期
            qrRuleType: 2,
            startDate: '00:00', // 开始时间
            endDate: '23:59', // 结束时间
          },
        ],
      },
      codeRules: {
        qrType: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        qrRuleType: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
          },
        ],
        weEmpleCodeUseScops: [
          {
            required: true,
            message: '请选择',
            trigger: 'blur',
            validator: (rule, value, callback) => {
              if (value.length == 0) {
                callback(new Error('请选择'))
              } else {
                callback()
              }
            },
          },
        ],
      },
      isInsertClientName: true,
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      dialogVisibleSelectMaterial: false,
      dialogVisibleSelectWel: false,
      loading: false,
      codeCategoryList: [], // 活码分组
      selectedUserList: [], // 需要回显的选中员工
      selectedTagList: [],
      timeConflict: false,
    }
  },
  created() {
    let id = this.$route.query.id
    let groupId = this.$route.query.groupId
    this.formId = this.formIdN = this.$route.query.formId
    this.formId && this.selectInfoToSurvey()
    if (groupId) {
      this.baseForm.groupId = groupId //分组id
    }
    if (this.$route.query.currentActiveA) {
      this.currentActive = Number(this.$route.query.currentActiveA)
      this.selectInfoToSurvey()
    }
    this.getCodeCategoryList()
    if (id) {
      this.title = '编辑'
      this.getDetailFn(id)
    }
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('.copy-btn')
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    removeFn() {
      this.$confirm('是否确认取消新建当前表单，取消后不可恢复，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          return deleteInfoToSurvey(this.formId)
        })
        .then(() => {
          this.$router.back()
        })
        .catch(function () {})
    },
    deletChannels(item, index) {
      let that = this
      if (that.ChannelsList.length < 2) {
        this.$alert('当前渠道不可删除', '提示', {
          confirmButtonText: '我知道了',
        })
      } else {
        that.ChannelsList.splice(index, 1)
        that.channelsPathList.splice(index, 1)
      }
    },
    addFormS(xx) {
      let that = this
      this.baseForm.surveyState = 0
      if (this.baseForm.tinyint) {
        this.baseForm.timingStart = this.searchDate[0] + ' 00:00:00'
        this.baseForm.timingEnd = this.searchDate[1] + ' 23:59:59'
        this.baseForm.anTiming = this.baseForm.tinyint
      }
      if (this.One == 0 && this.OneToOne == 0) {
        this.baseForm.fillingRules = 2
      } else if (this.One) {
        this.baseForm.fillingRules = 0
      } else if (this.OneToOne) {
        this.baseForm.fillingRules = 1
      }
      // that.ifPhoneZ = false
      // that.ifNameZ = false
      this.baseForm.htmlPath = '/formsDetail'
      let stylesx = JSON.parse(this.baseForm.styles)

      console.log('this.baseForm', this.baseForm)
      this.baseForm.styles = JSON.stringify(stylesx)
      this.baseForm.id = that.formIdN
      console.log('this.formIdN', this.formIdN)
      console.log('this.ChannelsList', this.ChannelsList)
      if (this.ChannelsList.length != 0) {
        this.baseForm.channelsName = ''
        this.baseForm.channelsPath = ''
        for (let i = 0; i < this.ChannelsList.length; i++) {
          if (this.baseForm.channelsName) {
            if (!this.ChannelsList[i]) {
              this.msgError('渠道不能为空！')
              return
            }
            this.baseForm.channelsName = this.baseForm.channelsName + ',' + this.ChannelsList[i]
            if (!this.channelsPathList[i]) {
              this.msgError('渠道标识不能为空！')
              return
            }
            this.baseForm.channelsPath = this.baseForm.channelsPath + ',' + this.channelsPathList[i]
            console.log('i', i, this.baseForm.channelsPath, this.channelsPathList[i])
          } else {
            this.baseForm.channelsName = this.ChannelsList[i]
            this.baseForm.channelsPath = this.channelsPathList[i]
          }
        }
      } else {
        this.baseForm.channelsName = '默认渠道'
        this.baseForm.channelsPath = 'Default'
        this.channelsPathList = ['Default']
      }
      // console.log('this.baseForm', this.baseForm)
      // console.log('this.isRepeat(this.channelsPathList)', this.isRepeat(this.channelsPathList))
      if (this.isRepeat(this.ChannelsList)) {
        this.msgError('渠道"' + this.isRepeat(this.ChannelsList) + '"重复')
        return
      }
      if (this.isRepeat(this.channelsPathList)) {
        this.msgError('渠道标识"' + this.isRepeat(this.channelsPathList) + '"重复')
        return
      }

      for (let i = 0; i < stylesx.length; i++) {
        for (let q = 0; q < stylesx[i].length; q++) {
          if (stylesx[i][q].formCodeId == 0) {
            that.readonly = false
          }
          // 删除提交数据中固定的省市区JSON数据树
          else if (stylesx[i][q].formCodeId == 9) {
            stylesx[i][q].options = []
          }
        }
      }

      let t = 0

      for (let i = 0; i < stylesx.length; i++) {
        for (let q = 0; q < stylesx[i].length; q++) {
          if (stylesx[i][q].formCodeId == 0) {
            stylesx[i][q].readonly = true
          }
          if (stylesx[i][q].formCodeId != 0 && stylesx[i][q].formCodeId != 1) {
            t++
            stylesx[i][q].page = i + 1
            stylesx[i][q].pageNo = q + 1
            if (stylesx[i][q].label.indexOf('.') != -1) {
              stylesx[i][q].TitleNumber = t
            } else {
              stylesx[i][q].TitleNumber = t
            }
          } else {
            stylesx[i][q].page = i + 1
            stylesx[i][q].label = ''
          }
        }
      }

      this.baseForm.styles = JSON.stringify(stylesx)
      //生成各渠道二维码
      // var childs = this.$refs.ewmTAddEwm.childNodes;
      // for(var i = childs .length - 1; i >= 0; i--) {
      //   this.$refs.ewmTAddEwm.removeChild(childs[i]);
      // }
      // let rwmNum=0;
      // for(let i=0;i<this.channelsPathList.length;i++){
      //   var qrcode = new QRCode(this.$refs.ewmTAddEwm, {
      //       text: that.channelsPathList[i], // 需要转换为二维码的内容
      //       width: 150,
      //       height: 150,
      //       colorDark: '#000000',
      //       colorLight: '#ffffff',
      //       correctLevel: QRCode.CorrectLevel.H
      //   })
      //   rwmNum=i;
      // }
      // for(let q=0;q<=rwmNum;q++){
      //   console.log('this.$refs.ewmTAddEwm1',this.$refs.ewmTAddEwm.childNodes)
      //   setTimeout(function(){
      //     console.log('this.$refs.ewmTAddEwm',that.$refs.ewmTAddEwm.childNodes[q*2+1].currentSrc)
      //     that.uploadFile(that.$refs.ewmTAddEwm.childNodes[q*2+1].currentSrc)
      //   },10)
      // }
      // console.log('this.$refs.ewmTAddEwm1',this.$refs.ewmTAddEwm.childNodes)
      // return
      if (xx == 'fb') {
        that.updateSurveyStatus(that.dataFormList.id, 1, that.dataFormList)
        delete that.baseForm.surveyState
      }
      updateInfoToSurvey(that.baseForm).then((response) => {
        if (xx == 'to3') {
          return
        }
        that.cancelFn()
      })
    },
    //上传二维码
    uploadFile(dataurl) {
      uploadFile(dataurl).then((response) => {
        console.log('二维码返回值', response)
      })
    },
    addChannels() {
      let a = ''
      this.ChannelsList.push(a)
    },
    //表单4详情
    selectInfoToSurvey() {
      selectInfoToSurvey(this.formId).then(({ data }) => {
        console.log('获取from4详情', data)
        this.dataFormList = data
        if (data) {
          if (data.channelsName) {
            this.ChannelsList = data.channelsName.split(',')
            this.channelsPathList = data.channelsPath.split(',')
          }
          this.baseForm.surveyName = data.surveyName
          if (data.formDescription) {
            this.ifFormDescription = 1
            this.baseForm.formDescription = data.formDescription
          }
          if (data.formLogo) {
            this.ifFormLogo = 1
            this.baseForm.formLogo = data.formLogo
            this.baseForm.logoUrl = data.formLogo
          }
          this.pageDataAll = JSON.parse(data.styles)
        }
        this.baseFormUrl4 = window.location.origin + '/formsDetail?id=true&formId=' + this.formId

        this.creatQrCode()
        // this.$forceUpdate()
      })
    },
    //更新表单状态
    updateInfoToSurvey(data) {
      let that = this
      updateInfoToSurvey(data)
        .then((res) => {
          that.selectInfoToSurvey()
        })
        .catch(() => {})
    },
    //开启表单
    updateSurveyStatus(id, surveyState, row) {
      let that = this
      if (row.surveyState == 0 && !row.timingStart) {
        let data = {
          id: id,
          timingStart: dateFormat(new Date()),
        }
        this.updateInfoToSurvey(data)
      } else {
        let newData = new Date()
        if (newData < new Date(row.timingStart)) {
          surveyState = 4
        }
      }
      let data = {
        id: id,
        surveyState: surveyState,
      }
      updateSurveyStatus(data)
        .then((res) => {
          if (res.code == 200) {
            that.$message({
              message: '操作成功',
              type: 'success',
            })
            // that.cancelFn()
          } else {
            that.msgError(res.msg)
          }
        })
        .catch(() => {})
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
    //前端生成二维码
    creatQrCode() {
      let that = this
      console.log('this.$refs.qrCodeUrl.img', this.$refs.qrCodeUrl.childNodes)
      // if (this.$refs.qrCodeUrl.childNodes.length > 1) {
      //   return
      // }
      // if (this.$refs.qrCodeUrl.img) {
      //   return
      // }
      var qrcode = QRCode.toDataURL(
        this.$refs.qrCodeUrl,
        window.location.origin + '/formsDetail?id=q&formId=' + that.formId, // 需要转换为二维码的内容
        {
          width: 150,
          margin: 4,
          errorCorrectionLevel: 'H',
        },
      )
      console.log('this.$refs.qrCodeUrl', this.$refs.qrCodeUrl)
    },
    // 创建下载图片事件
    btnDownload() {
      this.downloadFile('表单二维码', this.$refs.qrCodeUrl.childNodes[1].src)
      //创建一个具有指定的命名空间URI和限定名称的元素
      // var save_link = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');
      // save_link.href = data;
      // save_link.download = filename;
      // // 绑定下载事件
      // var event = document.createEvent('MouseEvents');
      // event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false,         false, false, 0, null);
      // save_link.dispatchEvent(event);
    },
    //子传父，获取表单数据
    toStyles(res) {
      console.log('获取表单样式', res)
      let ress = []
      for (let i = 0; i < res.length; i++) {
        ress.push([])
        for (let q = 0; q < res[i].length; q++) {
          ress[ress.length - 1].push(res[i][q])
        }
      }
      let t = 0
      for (let i = 0; i < ress.length; i++) {
        for (let q = 0; q < ress[i].length; q++) {
          if (ress[i][q].formCodeId != 0 && ress[i][q].formCodeId != 1) {
            t++
            ress[i][q].page = i + 1
            ress[i][q].pageNo = q + 1
            if (ress[i][q].label.indexOf('.') != -1) {
              console.log('ress[i][q].label.indexOf(".")', ress[i][q].label.length)
              // let a=ress[i][q].label.slice(ress[i][q].label.indexOf("."),ress[i][q].label.length);
              // ress[i][q].label=t+a;
              ress[i][q].TitleNumber = t
            } else {
              // ress[i][q].label=t+'.'+ress[i][q].label
              // ress[i][q].TitleNumber=t;
            }
            if (ress[i][q].formCodeId == '625' && ress[i][q].formCodeId == '626') {
              ress[i].splice(q, 1)
            }
          } else {
            ress[i][q].page = i + 1
            ress[i][q].label = ''
          }
        }
      }
      if (ress.length != 0) {
        this.baseForm.styles = JSON.stringify(ress)
        // console.log('this.baseForm',this.baseForm.styles)
      } else {
        this.baseForm.styles = ''
      }
    },
    // 获取上传的头像数据
    handleUploadedHeadImage(file) {
      const reader = new FileReader()
      // reader.readAsDataURL(file.raw)
      reader.onload = () => {
        this.baseForm.logoUrl = reader.result
        console.log('this.baseForm.logoUrl', this.baseForm.logoUrl)
      }
    },
    checkStartEnd(e, index) {
      this.timeConflict = false
      this.operationIndex = index
      let goto = this.allTimeConflict() // 默认全天员工冲突
      // let timeGo = true // 非默认周期时间冲突
      if (goto) {
        // if (this.operationIndex > 0) {
        if (
          this.codeForm.empleCodeRosterDto[this.operationIndex].weekday.length &&
          (this.codeForm.empleCodeRosterDto[this.operationIndex].endDate ||
            this.codeForm.empleCodeRosterDto[this.operationIndex].startDate)
        ) {
          this.someTimeConflict()
        }
        // }
      }
    },
    someTimeConflict() {
      let conflictUserItem = [] // 存在冲突的当前数据
      let userList = [] // 当前重复人员
      let passList = [] // 当前之前的人员 不包含默认的第一条

      let current = this.codeForm.empleCodeRosterDto[this.operationIndex].weEmpleCodeUseScops.map((i) => {
        return {
          userId: i.businessId,
          name: i.businessName,
        }
      })
      this.codeForm.empleCodeRosterDto.forEach((data, key) => {
        data.weEmpleCodeUseScops.map((i, index) => {
          if (key != this.operationIndex) {
            passList.push({
              userId: i.businessId,
              name: i.businessName,
              index: key,
              week: [],
              goto1: true,
              goto2: true,
            })
          }
        })
      })
      current.map((dd) => {
        passList.map((ff) => {
          if (dd.userId === ff.userId) {
            userList.push(ff)
          }
        })
      })
      // 重复人员下的时间校验
      let repeatWeek = []
      let currentWeekday = this.codeForm.empleCodeRosterDto[this.operationIndex].weekday
      userList.forEach((user) => {
        const arr = this.codeForm.empleCodeRosterDto[user.index].weekday
        for (var i = 0; i < arr.length; i++) {
          if (currentWeekday.indexOf(arr[i]) != -1) {
            user.week.push(arr[i])
          }
        }
      })
      userList.forEach((ddd) => {
        if (ddd.week.length) {
          let start = this.codeForm.empleCodeRosterDto[ddd.index].startDate
          let end = this.codeForm.empleCodeRosterDto[ddd.index].endDate
          if (start && end) {
            if (this.codeForm.empleCodeRosterDto[this.operationIndex].startDate) {
              ddd.goto1 = this.checkAuditTime(
                start,
                end,
                this.codeForm.empleCodeRosterDto[this.operationIndex].startDate,
              )
            }
            if (this.codeForm.empleCodeRosterDto[this.operationIndex].endDate) {
              ddd.goto2 = this.checkAuditTime(start, end, this.codeForm.empleCodeRosterDto[this.operationIndex].endDate)
            }
          }
        }
      })
      let str = ''
      userList.forEach((fdfd) => {
        if (!fdfd.goto1 || !fdfd.goto2) {
          let ss = fdfd.week.map((data) => {
            return data === 7 ? '日' : data
          })
          str += '员工' + fdfd.name + '在周' + ss.join('、') + '时间存在冲突;'
        }
      })
      if (str) {
        this.timeConflict = true
        this.msgError(str)
      } else {
        this.timeConflict = false
      }
    },
    allTimeConflict() {
      if (this.operationIndex === 0) {
        return true
      }
      let current = this.codeForm.empleCodeRosterDto[this.operationIndex].weEmpleCodeUseScops.map((i) => {
        return {
          userId: i.businessId,
          name: i.businessName,
        }
      })
      let first = this.codeForm.empleCodeRosterDto[0].weEmpleCodeUseScops.map((i) => {
        return {
          userId: i.businessId,
          name: i.businessName,
        }
      })
      let result = []
      current.map((dd) => {
        first.map((ff) => {
          if (dd.userId === ff.userId) {
            result.push(dd)
          }
        })
      })
      if (result.length) {
        let str = result
          .map((obj, index) => {
            return obj.name
          })
          .join(',')
        this.msgError('员工 ' + str + ' 已是全天在线，时间存在冲突！')
        this.timeConflict = true
        return false
      } else {
        this.timeConflict = false
        return true
      }
    },
    checkAuditTime(beginTime, endTime, current) {
      let strb = beginTime.split(':')
      if (strb.length != 2) {
        return false
      }
      let stre = endTime.split(':')
      if (stre.length != 2) {
        return false
      }
      let cur = current.split(':')
      if (cur.length != 2) {
        return false
      }
      let b = new Date()
      let e = new Date()
      let n = new Date()
      b.setHours(strb[0])
      b.setMinutes(strb[1])
      e.setHours(stre[0])
      e.setMinutes(stre[1])
      n.setHours(cur[0])
      n.setMinutes(cur[1])
      if (n.getTime() - b.getTime() >= 0 && n.getTime() - e.getTime() <= 0) {
        return false
      } else {
        return true
      }
    },
    cancelFn() {
      this.$router.back()
      // this.$router.push({
      //   path: 'list',
      // })
    },
    CancelTheNewOne() {
      this.$confirm('是否确认取消新建当前表单，取消后不可恢复，请谨慎操作。', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.$router.back()
        })
        .catch(() => {})
    },
    getWelData(data) {
      this.submit(data)
    },
    changeType(e) {
      if (e === 1) {
        this.codeForm.qrRuleType = 1
      }
    },
    nextStep(nextStep, oldIndex) {
      let that = this
      let form = ''
      if (nextStep == 2) {
        form = 'baseForm'
        this.baseForm.visibility = this.visibility
        if (!this.baseForm.surveyName) {
          this.msgError('表单名称不能为空！')
          return
        }
        if (this.ifFormDescription) {
          if (!this.baseForm.formDescription) {
            this.msgError('表单说明不能为空！')
            return
          }
        }
        if (this.ifFormLogo) {
          if (!this.baseForm.logoUrl) {
            this.baseForm.logoUrl = this.baseForm.formLogo
          }
          if (!this.baseForm.logoUrl) {
            console.log('this.baseForm', this.baseForm)
            this.msgError('表单logo不能为空！')
            return
          }
        }
        this.currentActive = nextStep
      } else if (nextStep == 3) {
        console.log('this.baseForm.styles', this.baseForm.styles)
        let styles = JSON.parse(this.baseForm.styles)
        console.log('styles.length', styles.length)
        if (styles.length == 0) {
          this.msgError('表单不能为空!')
          return
        }
        for (let i = 0; i < styles.length; i++) {
          for (let q = 0; q < styles[i].length; q++) {
            let label = styles[i][q].label.substring(styles[i][q].label.indexOf('.') + 1)
            if (styles[i][q].formCodeId == 0) {
              if (!styles[i][q].defaultValue) {
                this.msgError('第' + styles[i][q].page + '页,[文字说明]不能为空')
                return
              }
            }
            if (styles[i][q].formCodeId == 1) {
              if (!styles[i][q].src) {
                this.msgError('第' + styles[i][q].page + '页,[图片]不能为空')
                return
              }
            }
            if (styles[i][q].formCodeId == 6) {
              if (!styles[i][q].options || styles[i][q].options.length == 0) {
                console.log('styles[i][q]', styles[i][q])
                this.msgError('第' + styles[i][q].page + '页,' + label + ',[下拉选择]不能为空')
                return
              }
              for (let w = 0; w < styles[i][q].options.length; w++) {
                if (!styles[i][q].options[w].label) {
                  this.msgError('第' + styles[i][q].page + '页,' + label + ',[下拉选择]名称不能为空')
                  return
                }
              }
            }
            if (styles[i][q].formCodeId == 7) {
              if (!styles[i][q].options || styles[i][q].options.length == 0) {
                this.msgError('第' + styles[i][q].page + '页,' + label + ',[级联选择]不能为空')
                return
              }
            }
            if (styles[i][q].formCodeId == 8) {
              if (!styles[i][q].options || styles[i][q].options.length == 0) {
                this.msgError('第' + styles[i][q].page + '页,' + label + ',[选项组]不能为空')
                return
              }
            }
          }
        }
        if (oldIndex == 4) {
          this.addFormS('to3')
        }
        this.currentActive = nextStep
        return
      } else if (nextStep == 4) {
        this.baseForm.surveyState = 0
        if (this.baseForm.tinyint) {
          if (!this.searchDate[0]) {
            this.msgError('定时收集不能为空!')
            return
          }
          this.baseForm.timingStart = this.searchDate[0] + ' 00:00:00'
          this.baseForm.timingEnd = this.searchDate[1] + ' 23:59:59'
          this.baseForm.anTiming = this.baseForm.tinyint
        }
        if (this.One == 0 && this.OneToOne == 0) {
          this.baseForm.fillingRules = 2
        } else if (this.One && this.OneToOne == 0) {
          this.baseForm.fillingRules = 0
        } else if (this.OneToOne) {
          this.baseForm.fillingRules = 1
        }
        this.baseForm.htmlPath = '/formsDetail'
        let stylesx = JSON.parse(this.baseForm.styles)
        for (let i = 0; i < stylesx.length; i++) {
          for (let q = 0; q < stylesx[i].length; q++) {
            if (stylesx[i][q].formCodeId == 0) {
              that.readonly = false
            }
            // 删除提交数据中固定的省市区JSON数据树
            else if (stylesx[i][q].formCodeId == 9) {
              stylesx[i][q].options = []
            }
          }
        }
        let t = 0
        for (let i = 0; i < stylesx.length; i++) {
          for (let q = 0; q < stylesx[i].length; q++) {
            if (stylesx[i][q].formCodeId == 0) {
              stylesx[i][q].readonly = true
            }
            if (stylesx[i][q].formCodeId != 0 && stylesx[i][q].formCodeId != 1) {
              t++
              stylesx[i][q].page = i + 1
              stylesx[i][q].pageNo = q + 1
              if (stylesx[i][q].label.indexOf('.') != -1) {
                console.log('stylesx[i][q].label.indexOf(".")', stylesx[i][q].label.length)
                stylesx[i][q].TitleNumber = t
              } else {
                stylesx[i][q].TitleNumber = t
              }
            } else {
              stylesx[i][q].page = i + 1
              stylesx[i][q].label = ''
            }
          }
        }

        console.log('this.baseForm', this.baseForm)
        this.baseForm.styles = JSON.stringify(stylesx)
        this.baseForm.id = that.formId
        console.log('this.ChannelsList', this.ChannelsList)
        if (this.ChannelsList.length != 0) {
          this.baseForm.channelsName = ''
          this.baseForm.channelsPath = ''
          for (let i = 0; i < this.ChannelsList.length; i++) {
            if (this.baseForm.channelsName) {
              if (!this.ChannelsList[i]) {
                this.msgError('渠道不能为空！')
                return
              }
              this.baseForm.channelsName = this.baseForm.channelsName + ',' + this.ChannelsList[i]
              if (!this.channelsPathList[i]) {
                this.msgError('渠道标识不能为空！')
                return
              }
              this.baseForm.channelsPath = this.baseForm.channelsPath + ',' + this.channelsPathList[i]
            } else {
              this.baseForm.channelsName = this.ChannelsList[i]
              this.baseForm.channelsPath = this.channelsPathList[i]
            }
          }
        } else {
          this.baseForm.channelsName = '默认渠道'
          this.baseForm.channelsPath = 'Default'
          this.channelsPathList = ['Default']
        }
        if (!this.formIdN) {
          // console.log('this.baseForm',this.baseForm)
          // return
          insertInfoToSurvey(this.baseForm).then((response) => {
            console.log('新增表单返回值', response)
            if (response.code == 200) {
              that.formId = response.data
              that.formIdN = response.data
              that.selectInfoToSurvey()
              that.currentActive = nextStep
              return
            } else {
              this.msgError(response.msg)
            }
          })
        } else {
          updateInfoToSurvey(this.baseForm).then((response) => {
            console.log('更新表单返回值1', response)
            if (response.code == 200) {
              that.selectInfoToSurvey()
              that.currentActive = nextStep
              return
            } else {
              this.msgError(response.msg)
            }
          })
        }

        return
      }
      this.$refs[form].validate((validate) => {
        // console.log('validate', validate)
        // if (validate) {
        //   console.log('nextStep', nextStep)
        //   if (nextStep == 2) {
        //     console.log('this.ifFormDescription', this.ifFormDescription)
        //     // this.currentActive = nextStep
        //   }
        // }
      })
    },
    isRepeat(ary) {
      for (var i = 0; i < ary.length; i++) {
        console.log(ary.indexOf(ary[i]))
        if (ary.indexOf(ary[i]) != i) {
          return ary[i]
        }
      }
      return false
    },
    /** 获取详情 */
    getDetailFn(id) {
      this.loading = true
      console.log('id', id)
      getDetail(id).then((res) => {
        this.formTemp = res.data
        let base = JSON.parse(JSON.stringify(res.data))
        this.baseForm = {
          surveyName: base.name,
          groupId: base.groupId,
          qrAutoAdd: base.autoAdd, // 自动通过
          weEmpleCodeTags: base.qrTags, // 标签
        }
        this.codeForm.qrType = base.type
        this.codeForm.qrRuleType = base.ruleType
        if (base.ruleType === 1) {
          let arr = []
          base.qrUserInfos[0].weQrUserList.forEach((dd) => {
            let obj = {
              scopeId: base.qrUserInfos[0].scopeId,
              businessId: dd.userId,
              businessName: dd.userName,
            }
            arr.push(obj)
          })
          this.codeForm.weEmpleCodeUseScops = arr
        } else {
          let arr = []
          base.qrUserInfos.forEach((dd) => {
            let obj = {
              type: dd.type,
              startDate: dd.beginTime,
              endDate: dd.endTime,
              weekday: dd.workCycle ? dd.workCycle.split(',').map((i) => parseInt(i, 0)) : [],
              scopeId: dd.scopeId,
              weEmpleCodeUseScops: dd.weQrUserList.map((ff) => {
                return {
                  businessId: ff.userId,
                  businessName: ff.userName,
                }
              }),
            }
            arr.push(obj)
          })
          this.codeForm.empleCodeRosterDto = arr
        }
        this.materialData = {
          welcomeMsg: base.qrAttachments ? base.qrAttachments[0].content : '',
          materialMsgList: base.qrAttachments ? this.setEditList(base.qrAttachments) : [],
        }
        this.loading = false
      })
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
    // 获取分组
    getCodeCategoryList() {
      getCodeCategoryList({
        mediaType: 15,
      }).then((res) => {
        this.codeCategoryList = res.data
        console.log('表单分组', this.codeCategoryList)
      })
    },
    // 选择人员变化事件
    selectedUser(users) {
      let params = {
        userIds: [],
        departmentIds: [],
      }
      const selectedUserList = users.map((d) => {
        d.userId && params.userIds.push(d.userId)
        d.id && params.departmentIds.push(d.id)
        return {
          businessId: d.userId || d.id,
          businessName: d.name,
          businessIdType: d.userId ? 2 : 1,
        }
      })
      params.userIds += ''
      params.departmentIds += ''
      // 全天排班
      if (this.codeForm.qrRuleType == 1) {
        this.codeForm.weEmpleCodeUseScops = selectedUserList
      } else {
        // 自动排班
        this.codeForm.empleCodeRosterDto[this.selectedRosterIndex].weEmpleCodeUseScops = selectedUserList
        this.checkStartEnd(null, this.selectedRosterIndex)
      }
    },
    // 自动排班-选择员工
    onSelectUser(index) {
      // 设置回显数据
      this.selectedUserList = []
      if (this.codeForm.qrRuleType == 2) {
        this.selectedRosterIndex = index
        let arr = []
        arr = this.codeForm.empleCodeRosterDto[this.selectedRosterIndex].weEmpleCodeUseScops.map((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedUserList = arr
        // this.selectedUserList = [...this.codeForm.weEmpleCodeUseScops[index]]
      } else {
        // this.selectedUserList = [...this.codeForm.weEmpleCodeUseScops]
        let arr = []
        arr = this.codeForm.weEmpleCodeUseScops.map((dd) => {
          return {
            userId: dd.businessId,
            // id: dd.businessIdType === 1 ? dd.businessId:'',
            name: dd.businessName,
          }
        })
        this.selectedUserList = arr
      }
      this.dialogVisibleSelectUser = true
    },
    // 添加工作周期
    onAddRoster() {
      this.codeForm.empleCodeRosterDto.push({
        weEmpleCodeUseScops: [], // 员工
        weekday: [], // 周期
        type: 1,
        startDate: '', // 开始时间
        endDate: '', // 结束时间
      })
    },
    // 删除工作周期
    onRemoveRoster(index) {
      this.codeForm.empleCodeRosterDto.splice(index, 1)
    },
    // 工作周期时间变化
    onRosterTimeChange(e, index) {
      const [startTime, endTime] = e
      this.codeForm.empleCodeRosterDto[index].startDate = startTime
      this.codeForm.empleCodeRosterDto[index].endDate = endTime
      this.codeForm.empleCodeRosterDto[index].time = e
    },
    selectedFn() {
      if (this.baseForm.weEmpleCodeTags) {
        this.selectedTagList = this.baseForm.weEmpleCodeTags.map((dd) => ({
          tagId: dd.tagId,
          name: dd.tagName,
        }))
      }
      this.dialogVisibleSelectTag = true
    },
    submitSelectTag(data) {
      this.baseForm.weEmpleCodeTags = data.map((d) => ({
        tagId: d.tagId,
        tagName: d.name,
      }))
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
    submit(data) {
      let list = this.resetData(data.materialMsgList)
      let myObj = {
        attachments: [
          {
            content: data.welcomeMsg,
            msgType: 'text',
          },
        ],
      }
      myObj.attachments.push(...list)
      if (this.codeForm.qrRuleType === 1) {
        let obj = {
          type: 0,
          scopeId: this.codeForm.weEmpleCodeUseScops[0].scopeId ? this.codeForm.weEmpleCodeUseScops[0].scopeId : '',
          userIds: this.codeForm.weEmpleCodeUseScops.map((dd) => dd.businessId),
        }
        this.codeForm.qrUserInfos = [obj]
      } else {
        this.codeForm.qrUserInfos = []
        this.codeForm.empleCodeRosterDto.forEach((fff) => {
          let obj = {
            scopeId: fff.scopeId ? fff.scopeId : '',
            type: fff.type,
            beginTime: fff.startDate,
            endTime: fff.endDate,
            userIds: fff.weEmpleCodeUseScops.map((dd) => dd.businessId),
            workCycle: fff.weekday,
          }
          this.codeForm.qrUserInfos.push(obj)
        })
      }
      this.baseForm.qrTags = this.baseForm.weEmpleCodeTags.map((ccc) => ccc.tagId)
      let obj = Object.assign({}, this.baseForm, this.codeForm, myObj)
      delete obj.weEmpleCodeTags
      delete obj.weEmpleCodeUseScops
      delete obj.empleCodeRosterDto
      if (this.formTemp.id) {
        obj.qrId = this.formTemp.id
        obj.configId = this.formTemp.configId
      }
      ;(this.formTemp.id ? update : add)(obj)
        .then(({ data }) => {
          this.msgSuccess('操作成功')
          this.loading = false
          this.$router.back()
        })
        .catch(() => {
          this.loading = false
        })
    },
  },
}
</script>

<style lang="scss" scoped>
.tab-content {
  padding: 30px 20px 15px;
}
.el-form-item__label {
  font-size: 12px;
}

.el-checkbox__label {
  font-size: 12px;
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

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: var(--font-black);
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-4);
  display: flex;
}

.wrap {
  display: flex;
  margin-top: 24px;

  .el-form {
    margin-right: 10%;
  }
}

.tip {
  color: var(--font-black-6);
}

.welcome-input {
  display: table;
  width: 80%;
  margin: 0 auto 20px;
}

.el-icon-CircleCloseFilled {
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

    &:hover {
      opacity: 0.8;
    }
  }
}

.roster-btn-delete {
  margin-top: -16%;
  margin-right: -8%;
}

.roster-card:not(:first-child) {
  margin-top: 20px;
}
.qrcode {
  display: inline-block;
  img {
    width: 132px;
    height: 132px;
    background: var(--bg-white); //设置白色背景色
    padding: 6px; // 利用padding的特性，挤出白边
  }
}
.phone_img {
  background: url('../../../assets/drainageCode/preview-bg.png');
  background-repeat: no-repeat;
  background-size: 100% 100%;
}
::v-deep .form3 .el-scrollbar__wrap {
  padding-bottom: 5px;
}
.add_form4_qd {
  width: 100%;
  border: 1px solid var(--border-black-9);
  .add_form4_qd_ul {
    overflow: hidden;
    flex-shrink: 0;
    display: flex;
    height: 50px;
    .add_form4_qd_li {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100%;
      border: 1px solid var(--border-black-9);
    }
    .add_form4_qd_li1 {
      width: 160px;
    }
    .add_form4_qd_li2 {
      flex: 1;
      line-height: initial;
    }
    .add_form4_qd_li3 {
      width: 140px;
    }
  }
}
.add_form4_qd_li {
  display: flex;
  flex-shrink: 0;
}
</style>
