<template>
  <div :style="Ifcontainer ? '' : 'background:#666;display: flex;justify-content: center;height: 100%;padding: 30px;'">
    <div
      :class="Ifcontainer ? 'container' : 'container containerPC'"
      data-title="调查问卷"
      :id="cpUnionDomId"
      v-loading="loading">
      <!-- 电脑端预览 -->
      <phone-template v-if="style == 'y' && fromList" style="margin: 0 auto" :title="fromList.surveyName">
        <div style="display: flex; justify-content: center; margin-top: 30px">
          <template v-if="ifFormLogo && !formId && !fromList.formLogo">
            <div v-if="!logoUrl" class="form-logo" style="">Logo</div>
            <el-image v-else fit="cover" :src="logoUrl" class="form-logo" />
          </template>
          <el-image v-if="fromList.formLogo" fit="cover" :src="fromList.formLogo" class="form-logo" />
        </div>
        <div v-if="fromList.surveyName" class="ac mt20" style="font-size: 20px; font-weight: 700">
          {{ fromList.surveyName }}
        </div>
        <div v-if="fromList.formDescription" style="font-size: 16px; padding: 30px 30px 0; line-height: 20px">
          {{ fromList.formDescription }}
        </div>
        <div v-if="fromList.visibility == 0" style="padding: 15px; margin- top: 10px">
          <div @click.stop="startFillIn()" class="formDetailPush">开始填写</div>
        </div>
        <div
          v-if="
            (fromList.visibility == 1 &&
              fromList.surveyState != 0 &&
              fromList.surveyState != 2 &&
              fromList.surveyState != 3) ||
            (fromList.visibility == 1 && style == 'y')
          ">
          <div v-if="drawingList.length != 0">
            <el-form
              :size="formConf.size"
              :label-position="formConf.labelPosition"
              :label-width="formConf.labelWidth + 'px'">
              <DraggableItem
                v-for="(element, index) in drawingList"
                v-show="element.formCodeId != 0"
                :key="element.renderKey"
                :drawing-list="drawingList"
                :element="element"
                :index="index"
                :active-id="activeId"
                :form-conf="formConf" />
            </el-form>
          </div>
          <div v-if="drawingList.length == 0 && fromList.surveyName" style="padding: 15px; position: relative">
            <el-form ref="elForm" :model="formData" :rules="rules" label-width="100px" label-position="top">
              <div style="color: transparent; position: relative; top: 500px">
                <span style="color: transparent; position: relative; top: 500px">1</span>
              </div>
              <el-form-item label="姓名" prop="userName">
                <el-input
                  v-model="formData.userName"
                  placeholder="请输入你的姓名"
                  clearable
                  :style="{ width: '100%' }"></el-input>
              </el-form-item>
              <el-form-item label="手机号" prop="mobile">
                <el-input
                  v-model="formData.mobile"
                  placeholder="请输入手机号"
                  :maxlength="11"
                  show-word-limit
                  clearable
                  :style="{ width: '100%' }"></el-input>
              </el-form-item>
            </el-form>
          </div>
          <div style="color: #fff">1</div>
          <div v-if="page == pageData.length && page != 1" style="padding: 1rem; position: relative; top: 0.5rem">
            <div @click="dePage" class="formDetailPush">上一页</div>
          </div>
          <div v-if="page == pageData.length" style="padding: 1rem; position: relative; top: 0.5rem">
            <div @click.stop="fromPush()" class="formDetailPush">确认提交</div>
          </div>
          <div v-if="page != pageData.length && page == 1" style="padding: 1rem; position: relative; top: 0.5rem">
            <div @click="addPage" class="formDetailPush">下一页</div>
          </div>
          <div
            v-if="page != pageData.length && page != 1"
            style="padding: 1rem; position: relative; top: 0.5rem; display: flex; justify-content: space-between">
            <div @click="dePage" style="width: 45%" class="formDetailPush">上一页</div>
            <div @click="addPage" style="width: 45%" class="formDetailPush">下一页</div>
          </div>
        </div>
      </phone-template>

      <!-- @click.stop="back" -->
      <!-- <div
            style="
              position: absolute;
              font-weight: 700;
              width: 10px;
              height: 10px;
              top: 55px;
              left: 50px;
              text-align: center;
              z-index: 1999;
            "
          ></div> -->
      <!-- 手机端 -->
      <div v-if="style != 'y' && drawingList.length != 0" class="container">
        <div v-if="fromList.formLogo && !ifEnd" style="display: flex; justify-content: center; margin-top: 30px">
          <el-image fit="cover" :src="fromList.formLogo" class="form-logo"></el-image>
        </div>
        <div v-if="fromList.surveyName" class="ac mt20">
          <span style="font-size: 20px; font-weight: 700">
            {{ fromList.surveyName }}
          </span>
        </div>
        <div v-if="fromList.formDescription && !ifEnd" style="font-size: 16px; padding: 30px 30px 0; line-height: 20px">
          {{ fromList.formDescription }}
        </div>
        <div v-if="fromList.visibility == 0 && !ifEnd" style="padding: 15px; margin- top: 8px">
          <div @click.stop="startFillIn()" class="formDetailPush">开始填写</div>
        </div>

        <div v-if="fromList.visibility == 1 && !ifEnd">
          <el-form
            :size="formConf.size"
            :label-position="formConf.labelPosition"
            :label-width="formConf.labelWidth + 'px'">
            <div v-for="(element, index) in drawingList" :key="element.renderKey">
              <DraggableItem
                v-show="element.formCodeId != 0"
                :drawing-list="drawingList"
                :element="element"
                :index="index"
                :active-id="activeId"
                :form-conf="formConf" />
              <div v-show="element.formCodeId == 0" style="padding: 10px; padding-bottom: 0">
                {{ element.defaultValue }}
              </div>
            </div>
          </el-form>
          <!--     <div v-if="true" style="padding: 1rem;position:relative;top: 0.5rem;">
                  <el-form ref="elForm" :model="formData" :rules="rules"  label-width="100px"
                     label-position="top">
                     <div style="color: transparent;position: relative;top: 500px;"><span style="color: transparent;position: relative;top: 500px;">1</span></div>
                     <el-form-item label="姓名" prop="userName">
                       <el-input v-model="formData.userName" placeholder="请输入你的姓名" clearable
                         :style="{width: '100%'}"></el-input>
                     </el-form-item>
                     <el-form-item label="手机号" prop="mobile">
                       <el-input v-model="formData.mobile" placeholder="请输入手机号" :maxlength="11" show-word-limit clearable
                         prefix-icon='el-icon-mobile' :style="{width: '100%'}"></el-input>
                     </el-form-item>
                    <el-form-item size="large">
                       <el-button type="primary" @click="submitForm">提交</el-button>
                       <el-button @click="resetForm">重置</el-button>
                     </el-form-item>
                   </el-form>
            </div> -->
          <div style="color: transparent; margin-top: 50px">1</div>
          <div>
            <div v-if="page == pageData.length && page != 1" style="padding: 1rem; position: relative; top: 0.5rem">
              <div @click="dePage" class="formDetailPush">上一页</div>
            </div>
            <div v-if="page == pageData.length && !ifEnd" style="padding: 1rem; position: relative; top: 0.5rem">
              <div @click.stop="fromPush()" class="formDetailPush">确认提交</div>
            </div>
            <div v-if="page == pageData.length && ifEnd" style="padding: 1rem; position: relative; top: 0.5rem">
              <div class="formDetailPush">您已完成填写</div>
            </div>
            <div v-if="page != pageData.length && page == 1" style="padding: 1rem; position: relative; top: 0.5rem">
              <div @click="addPage" class="formDetailPush">下一页</div>
            </div>
            <div
              v-if="page != pageData.length && page != 1"
              style="padding: 1rem; position: relative; top: 0.5rem; display: flex; justify-content: space-between">
              <div @click="dePage" style="width: 45%" class="formDetailPush">上一页</div>
              <div @click="addPage" style="width: 45%" class="formDetailPush">下一页</div>
            </div>
          </div>
        </div>

        <template v-if="ifEnd">
          <div style="text-align: center; margin: 100px 0 10px; color: #2aa515">
            <el-icon-SuccessFilled class="el-icon-SuccessFilled" style="font-size: 150px"></el-icon-SuccessFilled>
            <div style="font-size: 24px; margin-top: 30px; font-weight: 700">您已完成填写</div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>
<script>
import { showDialog, showFailToast } from 'vant'
import 'vant/es/dialog/style'
import 'vant/es/toast/style'
import { getWechatAuthUserInfo, getIP } from '@/utils/index'
import {
  selectInfoToSurvey,
  submitForm,
  insertPieValue,
  isCompleteSurvey,
  siteStas,
} from '@/api/drainageCode/smartForms.js'
import { getProvinceCityTree } from '@/utils/index'
// import render from './generator/render'
import RightPanel from './RightPanel'
import { inputComponents, formConf } from './generator/config'
import { treeToArray } from '@/utils/common'
import { getQueryValue } from '@/utils/index'
import CodeTypeDialog from './CodeTypeDialog'
import DraggableItem from './DraggableItem'
let oldActiveId
let area = undefined

export default {
  props: [
    'FormIdY',
    'id',
    'type',
    'index',
    'surveyName',
    'ifFormDescription',
    'formDescription',
    'ifFormLogo',
    'logoUrl',
    'unionDomId',
  ],
  components: {
    // render,
    RightPanel,
    CodeTypeDialog,
    DraggableItem,
  },
  data() {
    return {
      loading: true,
      Ifcontainer: true,
      ifEnd: false,
      style: 'false',
      formData1: {
        userName: undefined,
        mobile: '',
      },
      rules: {
        userName: [
          {
            required: true,
            message: '请输入你的姓名',
            trigger: 'blur',
          },
        ],
        mobile: [
          {
            required: true,
            message: '请输入手机号',
            trigger: 'blur',
          },
          {
            pattern: /^1(3|4|5|7|8|9)\d{9}$/,
            message: '手机号格式错误',
            trigger: 'blur',
          },
        ],
      },
      //计时数
      TimeNumber: 0,
      //计时器
      TimeNumberF: null,
      //渠道
      dataSource: '默认渠道',
      //开始填写时间
      anTime: '',
      userIp: '', //用户ip
      fromList: {
        fromLogo: '',
        formDescription: '',
        surveyName: '',
      },
      formId: '', //表单Id
      code: '',
      logo: this.lwConfig.LOGO_DARK,
      idGlobal: 100,
      formConf,
      inputComponents,
      labelWidth: 100,
      drawingList: [],
      drawingData: {},
      activeId: '',
      drawerVisible: false,
      formData: {
        userName: '',
        mobile: '',
      },
      dialogVisible: false,
      generateConf: null,
      showFileName: false,
      activeData: [],
      //页数总数据
      pageData: [],
      page: 1,
      unionidN: '',
      openIdN: '',
      nickname: '',
      isMobile: true,
    }
  },
  computed: {
    cpUnionDomId() {
      return this.unionDomId || 'unionDomId1'
    },
  },
  watch: {
    surveyName: {
      handler(val) {
        this.fromList.surveyName = val
      },
    },
    index: {
      handler(val) {
        console.log('indexxxxxxxxxxxxxxxxxx', val)
        if (val == 1) {
          this.fromList.visibility = 0
        } else {
          this.fromList.visibility = 1
        }
      },
    },
    fromLogo: {
      handler(val) {
        this.fromList.fromLogo = val
      },
    },
    formDescription: {
      handler(val) {
        this.fromList.formDescription = val
      },
    },
    // eslint-disable-next-line func-names
    'activeData.label': function (val, oldVal) {
      if (this.activeData.placeholder === undefined || !this.activeData.tag || oldActiveId !== this.activeId) {
        return
      }
      this.activeData.placeholder = this.activeData.placeholder.replace(oldVal, '')
    },
    activeId: {
      handler(val) {
        oldActiveId = val
      },
      immediate: true,
    },
    drawingList: {
      handler(val) {
        this.pageData[this.page - 1] = val
        for (let i = 0; i < this.pageData.length; i++) {
          for (let q = 0; q < this.pageData[i].length; q++) {
            this.pageData[i][q].page = i + 1
            this.pageData[i][q].pageNo = q + 1
            console.log('this.pageData[i][q].defaultValue', this.pageData[i][q].defaultValue)
            if (this.pageData[i][q].formCodeId == 9) {
              this.getProCityListZ(i, q, this.pageData[i][q].defaultValue[2])
            }
            if (this.pageData[i][q].formCodeId == 10) {
              this.formateDate(i, q, this.pageData[i][q].defaultValue)
            }
          }
        }
        try {
          localStorage.setItem('pageData', this.pageData)
        } catch (e) {
          //TODO handle the exception
        }
        this.$emit('toStyles', this.drawingList)
      },
      deep: true,
    },
  },
  mounted() {
    this.isMobile = this._isMobile()
    this.fromList.surveyName = this.surveyName
    this.fromList.visibility = this.index == 1 ? 0 : 1
    this.fromList.fromLogo = this.fromLogo
    this.fromList.formDescription = this.formDescription

    this.dataSource = getQueryValue('dataSource') || this.dataSource
    this.anTime = new Date()
    this.formId = this.FormIdY || getQueryValue('formId')

    this.style = this.id || getQueryValue('id') || 'y'
    if (!this.isMobile && this.style != 'y') {
      this.Ifcontainer = false
    }
    if (this.formId) {
      localStorage.setItem('formId', this.formId)
    } else {
      // localStorage.removeItem('formId')
    }
    if (this.style != 'y' && !this.formId) {
      this.formId = localStorage.getItem('formId')
    }

    this.selectInfoToSurvey()
    this.pageData[this.page - 1] = this.drawingList
    for (let i = 0; i < this.pageData.length; i++) {
      for (let q = 0; q < this.pageData[i].length; q++) {
        this.pageData[i][q].page = i + 1
        this.pageData[i][q].pageNo = q + 1
      }
    }
    // this.$forceUpdate()
  },
  methods: {
    //深拷贝
    deepCopy(obj) {
      var a = JSON.stringify(obj)
      var newobj = JSON.parse(a)
      return newobj
    },
    back() {
      this.$router.go(-1) //返回上一层
    },
    submitForm() {
      let that = this
      this.$refs['elForm'].validate((valid) => {
        if (!valid) return
        that.fromPush()
      })
    },
    //开始填写
    startFillIn() {
      if (this.style != 'y' || this.index != 1) {
        this.fromList.visibility = 1
        // this.$forceUpdate()
      }
    },

    //表单提交
    async fromPush() {
      try {
        this.userIp = this.userIp || (await getIP())
      } catch (error) {
        this.toast('获取ip失败')
        return
      }
      let that = this
      let answer = []
      let pageDatess = that.pageData
      //饼图参数
      let btData = []
      for (let i = 0; i < pageDatess.length; i++) {
        for (let q = 0; q < pageDatess[i].length; q++) {
          let curItem = pageDatess[i][q]
          if (![0, 1].includes(+curItem.formCodeId)) {
            let cloneCurItem = JSON.parse(JSON.stringify(curItem))
            cloneCurItem.questionNumber = answer.length
            answer.push(cloneCurItem)

            if (curItem.formCodeId == 11) {
              this.formData1.userName = curItem.defaultValue // 姓名
            } else if (curItem.formCodeId == 5) {
              this.formData1.mobile = curItem.defaultValue // 手机号
            } else if ([6, 7, 8, 9].includes(+cloneCurItem.formCodeId)) {
              // 下拉选择, 级联选择, 选项组, 省市联动
              cloneCurItem.formId = this.formId
              btData.push(cloneCurItem)

              if (cloneCurItem.formCodeId == 9) {
                cloneCurItem.defaultValue += ''
              } else {
                // let str
                // for (let p = 0; p < cloneCurItem.options.length; p++) {
                //   str = str
                //     ? str + ',' + cloneCurItem.options[p].label
                //     : cloneCurItem.options[p].label

                //   // 此处判断必须全等，0 == [0]
                //   if (cloneCurItem.options[p].value === cloneCurItem.defaultValue) {
                //     cloneCurItem.defaultValue = cloneCurItem.options[p].label
                //     if (Array.isArray(cloneCurItem.defaultValue)) {
                //       let x = ''
                //       for (let i = 0; i < cloneCurItem.defaultValue.length; i++) {
                //         x = x + cloneCurItem.defaultValue[i]
                //       }
                //       cloneCurItem.defaultValue = x
                //     }
                //   }
                // }
                cloneCurItem.options = cloneCurItem.options.map((e) => e.label).join(',')
              }
            }
            if (cloneCurItem.formCodeId == 8 && Array.isArray(cloneCurItem.defaultValue)) {
              if (cloneCurItem.defaultValue.length === 1) {
                cloneCurItem.defaultValue += ''
              } else {
                let defaultValue = cloneCurItem.defaultValue.slice()
                for (let q = 0; q < defaultValue.length; q++) {
                  if (q == 0) {
                    cloneCurItem.defaultValue = defaultValue[q] + ''
                  } else {
                    answer.push(that.deepCopy(cloneCurItem))
                    answer[answer.length - 1].defaultValue = defaultValue[q] + ''
                  }
                }
              }
            }
          }
        }
      }
      try {
        localStorage.setItem('userName', that.formData1.userName)
        localStorage.setItem('mobile', that.formData1.mobile)
      } catch (e) {
        //TODO handle the exception
      }
      console.log('answer', answer)
      let formCodeDict = {
        0: '单行文本',
        2: '单行文本',
        3: '多行文本',
        4: '数字文本',
        5: '手机号',
        6: '下拉选择',
        7: '级联选择',
        8: '选项组',
        9: '省市联动',
        10: '日期时间',
      }
      for (let i = 0; i < answer.length; i++) {
        let curItem = answer[i]
        if (curItem.required) {
          let label = curItem.label.substring(curItem.label.indexOf('.') + 1)
          if (curItem.defaultValue === '' || curItem.defaultValue === undefined || curItem.defaultValue.length === 0) {
            // this.toast('第' + curItem.page + '页,' + label + ',' + '不能为空')
            this.toast(`第${curItem.page}页,${label},${formCodeDict[curItem.formCodeId]}不能为空`)
            return
          }

          if (curItem.formCodeId == 4) {
            if (curItem.max) {
              if (curItem.defaultValue > curItem.max) {
                this.toast('第' + curItem.page + '页,' + label + ',数字文本中数字不能大于' + curItem.max)
                return
              }
            }
            if (curItem.min) {
              if (curItem.defaultValue < curItem.min) {
                this.toast('第' + curItem.page + '页,' + label + ',数字文本中数字不能小于' + curItem.min)
                return
              }
            }
          } else if (curItem.formCodeId == 10) {
            curItem.timeS = this.formateDate(i, curItem.defaultValue, curItem)
          }

          if (curItem.regList && curItem.regList.length != 0) {
            curItem.regList[0].pattern = curItem.regList[0].pattern.substring(1, curItem.regList[0].pattern.length - 2)
            let a = new RegExp(curItem.regList[0].pattern)

            if (!a.test(curItem.defaultValue)) {
              this.toast('第' + curItem.page + '页,' + label + ',' + curItem.regList[0].message)
              return
            }
          }
        }
      }
      let clannelsName = that.fromList.channelsName.split(',')
      let clannelsPath = that.fromList.channelsPath.split(',')
      for (let i = 0; i < clannelsName.length; i++) {
        if (clannelsPath[i] == that.dataSource) {
          that.dataSource = clannelsName[i]
          break
        }
        if (that.clannelsName == that.dataSource && clannelsName[i] != '默认渠道') {
          break
        }
      }
      let data = {
        mobile: that.formData1.mobile,
        name: that.formData1.userName,
        //开始填写时间
        anTime: this.anTime,
        //填写用时
        totalTime: new Date().getTime() - new Date(this.anTime).getTime(),
        ipAddr: this.userIp,
        belongId: this.formId,
        anEffective: 0,
        //数据来源
        dataSource: this.dataSource,
        // 答题数
        quNum: answer.length,
        //答案
        answer: JSON.stringify(answer),
      }
      if (this.style == 'y' || this.style == 'q') {
        this.toast('预览情况下，不能提交')
        return
      }
      if (this.unionidN) {
        data.unionId = this.unionidN
      }
      if (this.openIdN) {
        data.openId = this.openIdN
      }
      this.loading = true
      submitForm(data)
        .then((response) => {
          if (response.code == 200) {
            that.ifEnd = true
            if (btData.length != 0) {
              that.insertPieValue(btData)
            }
          } else {
            this.toast(response.msg)
          }
        })
        .finally(() => {
          this.loading = false
        })
    },
    //时间转换
    formateDate(i, timestamp, answer) {
      if (!answer) {
        return
      }
      let a = new Date(timestamp).getTime()
      const date = new Date(a)
      const Y = date.getFullYear() + '-'
      const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-'
      const D = (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) + '  '
      const h = date.getHours() < 10 ? '0' + date.getHours() : date.getHours()
      const m = date.getMinutes() < 10 ? ':0' + date.getMinutes() : ':' + date.getMinutes()
      const s = date.getSeconds() < 10 ? ':0' + date.getSeconds() : ':' + date.getSeconds()
      let dateString
      if (answer.format == 'YYYY-MM-DD') {
        dateString = Y + M + D
      } else if (answer.format == 'YYYY-MM-DD HH:mm') {
        dateString = Y + M + D + h + m
      } else if (answer.format == 'YYYY-MM-DD HH:mm:ss') {
        dateString = Y + M + D + h + m + s
      }

      // const s = date.getSeconds(); // 秒

      // console.log('dateString', dateString); // > dateString 2021-07-06 14:23
      console.log('dad', dateString)
      return dateString
    },
    // 转换省市区
    async getProCityListZ(i, q, areaCode) {
      if (!areaCode) {
        return
      }
      if (!area) {
        let all = treeToArray(await getProvinceCityTree(), 'children', (e, res, level) => {
          let parent = res.find((el) => el.id == e.parentId)
          e.level = level
          e.treeNames = (parent ? (parent.treeNames || parent.name) + '/' : '') + e.name
        })
        // 提取区级数据
        area = all.filter((e) => e.level == 2)
      }
      if (!area) {
        this.toast('获取省市区数据失败，请稍后再试')
        return
      }
      this.pageData[i][q].ssq = area.find((e) => e.id == areaCode).treeNames
    },
    //储存饼图信息
    insertPieValue(btData) {
      let data = {
        fromId: this.formId,
        answer: JSON.stringify(btData),
        dataSource: this.dataSource,
      }
      insertPieValue(data).then((response) => {
        console.log('提交饼图信息返回值', response)
      })
    },
    //判断是否在微信里，然后下一步
    getAuthorize() {
      let code = getQueryValue('code')
      if (!code) {
        if (this.formId) {
          localStorage.setItem('formId', this.formId)
        } else {
          localStorage.removeItem('formId')
        }
      }
      this.getAccessToken()
    },
    //获取微信用户信息
    getAccessToken() {
      getWechatAuthUserInfo().then((data) => {
        this.unionidN = data.unionId
        this.openIdN = data.openId
        this.nickname = data.nickName
        if (this.nickname) {
          this.formData.userName = this.nickname
        }
        this.siteStas()
        this.isCompleteSurveyF()
        this.formData1.userName = localStorage.getItem('userName')
        this.formData1.mobile = localStorage.getItem('mobile')
        // if (response.code == 200) {
        // } else {
        //   this.toast(response.msg)
        // }
      })
    },
    //判断用户是否填写表单
    isCompleteSurveyF() {
      let data = {
        belongId: this.formId,
        // mobile: this.formData1.mobile,
        openId: this.openIdN,
        dataSource: this.dataSource,
      }
      if (this.fromList.fillingRules == 2) {
        return
      } else if (this.fromList.fillingRules == 1) {
        data.createTime = new Date()
      }

      isCompleteSurvey(data).then((response) => {
        console.log('判断用户是否填写', response)
        if (response.code == 200) {
        } else {
          // this.toast(response.data)
          this.fromList = ''
          showDialog({
            title: '提示',
            message: '当前问卷您已填写完毕，暂时无法填写。',
            confirmButtonText: '我知道了',
          }).then(() => {
            // on close
          })
        }
      })
    },
    _isMobile() {
      let flag = navigator.userAgent.match(
        /(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i,
      )
      return flag
    },
    //获取详情
    selectInfoToSurvey() {
      let that = this
      if (!this.formId) {
        this.loading = false
        return
      }
      selectInfoToSurvey(this.formId).then((response) => {
        if (response.code == 200) {
          this.loading = false
          that.fromList = response.data
          let clannelsName = that.fromList.channelsName.split(',')
          let clannelsPath = that.fromList.channelsPath.split(',')
          console.log('that.dataSource', that.dataSource, clannelsPath)
          for (let i = 0; i < clannelsName.length; i++) {
            if (clannelsPath[i] == that.dataSource) {
              that.dataSource = clannelsName[i]
              break
            }
            if (that.clannelsName == that.dataSource && clannelsName[i] != '默认渠道') {
              break
            }
          }
          if (response.data.timingStart) {
            let timingStart = new Date(response.data.timingStart)
            let newData = new Date()
            if (newData < timingStart) {
              that.fromList.surveyState = 0
            }
          }
          if (response.data.timingEnd) {
            let timingEnd = new Date(response.data.timingEnd)
            let newData = new Date()
            if (newData > timingEnd) {
              that.fromList.surveyState = 3
            }
          }
          let styles = JSON.parse(response.data.styles)
          that.pageData = [[]]
          if (that.style != 'y' && that.style != 'q') {
            if (that.fromList.surveyState == 0) {
              // this.$alert('当前问卷暂未开放回收，暂时无法填写。', '提示', {
              //           confirmButtonText: '我知道了',
              //         });
              showDialog({
                title: '提示',
                message: '当前问卷暂未开放回收，暂时无法填写。',
                confirmButtonText: '我知道了',
              }).then(() => {
                // on close
              })
              return
            } else if (that.fromList.surveyState == 2) {
              // this.$alert('当前问卷已暂停回收，暂时无法填写。', '提示', {
              //           confirmButtonText: '我知道了',
              //         });
              showDialog({
                title: '提示',
                message: '当前问卷已暂停回收，暂时无法填写。',
                confirmButtonText: '我知道了',
              }).then(() => {
                // on close
              })
              return
            } else if (that.fromList.surveyState == 3) {
              // this.$alert('当前问卷已结束回收，无法填写。', '提示', {
              //           confirmButtonText: '我知道了',
              //         });
              showDialog({
                title: '提示',
                message: '当前问卷已结束回收，无法填写。',
                confirmButtonText: '我知道了',
              }).then(() => {
                // on close
              })
              return
            }
          }
          let page = 1
          for (let i = 0; i < styles.length; i++) {
            if (styles[i][0].page == page) {
              that.pageData[i] = styles[i]
            } else {
              // that.pageData.push([]);
              page++
              that.pageData[page - 1] = styles[i]
            }
          }
          console.log('that.pageDataxx', that.pageData)
          that.drawingList = this.pageData[this.page - 1]
          that.$forceUpdate()
          that.activeData = that.drawingList[0]
          // that.pageData=JSON.parse(response.data.styles);
          // 只允许在微信中填写
          if (that.fromList.anAuth == 1) {
            // if (that.isWeiXin()) {
            //   if (that.style == 'y' || that.style == 'q') {
            //     return
            //   }
            //   that.getAuthorize()
            // } else {
            // }
            if (that.style == 'y' || that.style == 'q') {
              return
            }
            that.getAuthorize()
          } else {
            //如果是表单首页
            if (that.fromList.visibility == 1) {
              if (that.style == 'y' || that.style == 'q') {
                return
              }
            }
            this.siteStas()
          }
          return
        } else {
          showDialog(response.msg)
        }
      })
    },
    async siteStas() {
      if (!['y', 'q'].includes(this.style)) {
        //智能表单站点统计 PV
        try {
          this.userIp = this.userIp || (await getIP())
        } catch (error) {
          this.toast('获取ip失败')
          return
        }
        siteStas({
          belongId: this.formId,
          ipAddr: this.userIp,
          dataSource: this.dataSource,
        })
      }
    },
    // isWeiXin() {
    //   var ua = window.navigator.userAgent.toLowerCase()
    //   // ua.indexOf('micromessenger')为真-微信端，如果为假，就是其他浏览器
    //   if (ua.indexOf('micromessenger') > -1) {
    //     return true // 是微信端
    //   } else {
    //     return false
    //   }
    // },

    //上一页
    dePage() {
      this.page--
      this.drawingList = this.pageData[this.page - 1]
    },
    //下一页
    addPage() {
      this.page++
      this.drawingList = this.pageData[this.page - 1]
      that.$forceUpdate()
    },
    toast(message) {
      showFailToast({
        message,
        teleport: '#' + this.cpUnionDomId,
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.form-logo {
  width: 100px;
  height: 100px;
  background-color: #f2f2f2;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.container {
  overflow-y: auto;
  position: relative;
  width: 100%;
  height: 100%;
  // max-height: 100vh;
  background: #fff;
}
.containerPC {
  max-width: 350px;
}

.formDetailPush {
  border-radius: 20px;
  background-color: var(--color);
  text-align: center;
  padding: 13px 30px;
  color: var(--font-white, #fff);
}

::v-deep .form3 .el-scrollbar__wrap {
  padding-bottom: 5px;
}
.container ::v-deep .phone_img .el-form-item__content {
  margin-left: 0px !important;
}

.container ::v-deep .drawing-item > .drawing-item-copy {
  display: none !important;
  z-index: -999 !important;
}
.container ::v-deep .drawing-item > .drawing-item-delete {
  display: none !important;
  z-index: -999 !important;
}
::v-deep .is-closable {
  z-index: 9997 !important;
}
::v-deep .el-form--label-top .el-form-item__label {
  padding: 0 0 5px 0 !important;
}
</style>
