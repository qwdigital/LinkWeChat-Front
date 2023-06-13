<template>
  <div>
    <div class="flow-wrap mt10 flex">
      <div class="flow-menu" v-if="!disabled">
        <div class="flow-menu-title">旅程节点</div>
        <div v-for="(menuItem, index) in flowMenuData" :key="index">
          <div class="title mt20">{{ menuItem.name }}</div>
          <ul class="flow-menu-ul node-container">
            <li
              v-for="(nodeItem, unique) in menuItem.list"
              :key="unique"
              :draggable="!!nodeItem.type"
              class="flow-menu-li"
              :style="{ cursor: nodeItem.type ? 'move' : 'no-drop' }"
              @dragstart="dropType = nodeItem.type"
            >
              <div class="flow-menu-icon">
                <svg-icon :icon-class="nodeItem.icon"></svg-icon>
              </div>
              <div>
                {{ nodeItem.name }}
              </div>
            </li>
          </ul>
        </div>
      </div>
      <div class="flow-content">
        <div v-if="disabled" class="fxbw aic">
          <el-date-picker
            v-model="formDialog.branchAwiatAccurateTime"
            type="datetime"
            format="yyyy-MM-dd HH:mm"
            value-format="yyyy-MM-dd HH:mm"
            placeholder="请选择"
          ></el-date-picker>
          <div class="flow-status">
            <div class="line-1">执行成功</div>
            <div class="line-2">执行失败</div>
            <div class="line-3">未执行</div>
          </div>
        </div>
        <div class="flow-section" ref="flowContainer">
          <super-flow
            ref="superFlow"
            :draggable="false"
            :node-list="nodeList"
            :link-list="linkList"
            :graphMenu="graphMenu"
            :link-base-style="linkBaseStyle"
            :link-style="linkStyle"
            :link-desc="linkDesc"
            :linkAddable="false"
            @click.native="move"
          >
            <!-- :node-menu="disabled ? [] : nodeMenu" -->
            <template v-slot:node="{ meta, meta: { id, type } }">
              <!-- <div
                v-if="
                  meta.type === 'start' || meta.type === 'a'
                "
                @contextmenu.prevent.stop="return false;"
                @click="nodeClick(meta.type)"
                :class="['flow-node', meta.type]"
              >
                {{ meta.name }}
              </div> -->
              <div
                v-if="['0', 'empty', '99', '15', '17'].includes(type + '')"
                @contextmenu="contextmenu(type)"
                :class="['flow-node toe', type]"
                @drop="(event) => type == 'empty' && drop(event, id, type)"
              >
                {{ (nodeDataView[type] && nodeDataView[type].name) || meta.branchName }}
              </div>

              <!-- <el-popover
                v-else-if="pageType != 'view'"
                placement="bottom-start"
                trigger="hover"
                :disabled="meta.status != 9"
              >
                <div>请完成组件的设置</div>

              </el-popover> -->
              <div v-else-if="pageType != 'view'" class="flow-node fun-node">
                <i v-if="type != 2" class="el-icon-error cp" @click="removeNode(id)"></i>
                <div class="name">
                  <svg-icon
                    v-if="nodeDataView[type] && nodeDataView[type].icon"
                    :icon-class="nodeDataView[type].icon"
                  ></svg-icon>
                  {{ nodeDataView[type].name }}
                </div>
                <div
                  :class="['placeholder cp', meta.selected && 'selected']"
                  @click="nodeClick(id, type)"
                >
                  <span class="toe">
                    {{ meta.selected || meta.branchName || nodeDataView[type].placeholder }}
                  </span>
                  <i class="el-icon-arrow-right"></i>
                </div>
              </div>

              <el-popover
                v-else
                placement="bottom-start"
                trigger="hover"
                :disabled="!meta.errMsg"
                @show="$set(meta)"
              >
                <el-descriptions v-if="type == 'sms'">
                  <el-descriptions-item label="执行总数">kooriookami</el-descriptions-item>
                </el-descriptions>

                <div v-else-if="meta.data">{{ meta.errMsg }}</div>

                <div
                  slot="reference"
                  class="flow-node fun-node"
                  :class="meta.status == 3 && 'error'"
                  @contextmenu="contextmenu(type)"
                >
                  <div class="name">
                    <svg-icon
                      v-if="nodeDataView[type] && nodeDataView[type].icon"
                      :icon-class="nodeDataView[type].icon"
                    ></svg-icon>
                    {{ nodeDataView[type].name }}
                  </div>
                  <div
                    :class="['placeholder cp', meta.selected && 'selected']"
                    @click="nodeClick(id, type)"
                  >
                    <span class="toe">
                      {{ meta.selected || meta.branchName || nodeDataView[type].placeholder }}
                    </span>
                    <i class="el-icon-arrow-right"></i>
                  </div>
                </div>
              </el-popover>
            </template>
          </super-flow>
        </div>
        <div v-if="!disabled" class="ar mr20 mb10">
          <el-button size="mini" @click="$emit('cancel')">上一步</el-button>
          <el-button size="mini" type="primary" @click="save()">保存</el-button>
          <el-button size="mini" type="primary" @click="save('start')">确定</el-button>
        </div>
      </div>
    </div>

    <!--

      以下为抽屉配置项

      -->
    <el-drawer :visible.sync="dialog.visible" :wrapperClosable="false">
      <div v-if="dialog.visible" slot="title">
        <div class="title">{{ nodeDataView[dialog.type].name }}</div>
        <div class="desc">{{ nodeDataView[dialog.type].desc }}</div>
      </div>
      <el-form
        v-if="dialog.type != 12"
        :model="formDialog"
        :disabled="disabled"
        ref="formDialog"
        :rules="rules"
        label-width="auto"
        size="small"
        label-position="top"
        label-suffix=":"
        v-loading="dialogLoading"
      >
        <!-- 策略人群 -->
        <template v-if="dialog.type === '2'">
          <el-form-item label="人群分组" prop="crowdGroupId">
            <CoRemoteSelect
              key="crowdGroupId"
              :disabled="disabled || disabledexeAudience"
              v-model="formDialog.crowdGroupId"
              :remote-method="request.getClassGroupList"
              :query="{ mediaType: 7 }"
              @change="
                (list) => {
                  formDialog.crowdId && (formDialog.crowdId = '')
                  remoteSelectChange(list, 'crowdGroupName')
                }
              "
            ></CoRemoteSelect>
            <!-- <template v-if="disabledexeAudience">
              {{ (crowdPackList.find((e) => e.id == formDialog.crowdId) || {}).name }}
            </template> -->
            <!-- <el-select v-model="formDialog.crowdId" placeholder="请选择">
              <el-option
                v-for="item in crowdPackList"
                :key="item.id"
                :label="item.name"
                :value="String(item.id)"
              >
              </el-option>
            </el-select> -->
          </el-form-item>
          <el-form-item v-if="formDialog.crowdGroupId" label="策略人群" prop="crowdId">
            <CoRemoteSelect
              key="crowdId"
              :disabled="disabled || disabledexeAudience"
              v-model="formDialog.crowdId"
              :remote-method="request.getCrowdList"
              :query="{ groupId: formDialog.crowdGroupId }"
              @change="
                (list) => {
                  formDialog.crowdNum = list[0].crowdNum
                  remoteSelectChange(list, 'crowdName')
                }
              "
            ></CoRemoteSelect>
          </el-form-item>

          <div class="crowdNum">
            <CountTo
              class="num"
              :start-val="0"
              :end-val="formDialog.crowdNum || 0"
              :duration="2000"
            />
            <div class="mt5">人群规模</div>
          </div>

          <div style="font-size: 10px; color: #999; margin: 10px">
            添加后续节点后，不可修改已选择的人群
          </div>
        </template>

        <!-- 添加/删除员工/领取红包 -->
        <template v-else-if="[3, 4, 8].includes(+dialog.type)">
          <el-form-item prop="staffsId" label="选择员工">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.staffsId"
              multiple
              queryKeywordsKey="userName"
              :remote-method="request.getDeptUserAll"
              :defaultProps="{ id: 'weUserId', name: 'userName' }"
              @change="(list) => remoteSelectChange(list, 'staffsName')"
            ></CoRemoteSelect>
          </el-form-item>
        </template>

        <!-- 进入/退出社群 -->
        <template v-else-if="[5, 6].includes(+dialog.type)">
          <el-form-item label="选择社群" prop="groupsId">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.groupsId"
              multiple
              queryKeywordsKey="groupName"
              :remote-method="request.getGroupList"
              :defaultProps="{ id: 'chatId', name: 'groupName' }"
              @change="(list) => remoteSelectChange(list, 'groupName')"
            ></CoRemoteSelect>
          </el-form-item>
        </template>

        <!-- 朋友圈互动 -->
        <template v-else-if="dialog.type == '19'">
          <el-form-item label="互动类型" prop="friendCircleType">
            <el-checkbox-group v-model="formDialog.friendCircleType" :min="1">
              <el-checkbox
                v-for="(item, key) in { 0: '点赞动态', 1: '评论动态' }"
                :label="key"
                :key="key"
              >
                {{ item }}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>
        </template>

        <!-- 咨询客服 -->
        <template v-else-if="dialog.type === '7'">
          <el-form-item label="选择客服" prop="customerServicesId">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.customerServicesId"
              multiple
              queryKeywordsKey="name"
              :defaultProps="{ id: 'openKfId', name: 'name' }"
              :remote-method="request.getCustomerServiceList"
              @change="(list) => remoteSelectChange(list, 'customerServicesName')"
            ></CoRemoteSelect>
          </el-form-item>
        </template>

        <!-- 填写表单 -->
        <template v-if="dialog.type === '9'">
          <el-form-item label="表单分组" prop="formGroupsId">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.formGroupsId"
              queryKeywordsKey="userName"
              :query="{ mediaType: 11 }"
              :remote-method="request.getClassGroupList"
              @change="
                (list) => {
                  formDialog.formsId && (formDialog.formsId = '')
                  remoteSelectChange(list, 'formGroupsName')
                }
              "
            ></CoRemoteSelect>
          </el-form-item>
          <el-form-item v-if="formDialog.formGroupsId" label="选择表单" prop="formsId">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.formsId"
              queryKeywordsKey="surveyName"
              :remote-method="request.surveyList"
              :query="{ groupId: formDialog.formGroupsId }"
              @change="(list) => remoteSelectChange(list, 'formsName')"
            ></CoRemoteSelect>
          </el-form-item>
        </template>

        <!-- 设置标签 -->
        <template v-else-if="dialog.type === '10'">
          <el-form-item label="选择标签" prop="tags">
            <SelectTag1 :selected.sync="formDialog.tags"></SelectTag1>
          </el-form-item>
        </template>

        <!-- 自动拉群 -->
        <template v-else-if="dialog.type === '11'">
          <el-form-item label="选择群活码" prop="groupCodeId">
            <CoRemoteSelect
              :disabled="disabled"
              v-model="formDialog.groupCodeId"
              queryKeywordsKey="activityName"
              :remote-method="request.getGroupCodeList"
              :defaultProps="{ id: 'id', name: 'activityName' }"
              @change="(list) => remoteSelectChange(list, 'groupCodeName')"
            ></CoRemoteSelect>
          </el-form-item>
          <el-form-item label="加群引导语" prop="groupWelcome">
            <el-input
              type="textarea"
              v-model="formDialog.groupWelcome"
              show-word-limit
              maxlength="200"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
        </template>

        <!-- 结果多分支-->
        <template v-else-if="dialog.type === '16'">
          <el-form-item label="分支名称" prop="branchName">
            <el-input
              v-model="formDialog.branchName"
              show-word-limit
              maxlength="15"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="结果类型" prop="branchResult">
            <el-checkbox-group v-model="formDialog.branchResult">
              <el-checkbox v-for="(item, index) of enumDict.result" :key="index" :label="index">{{
                item
              }}</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
        </template>

        <!-- 复制、随机分支 -->
        <!-- <template v-else-if="['copyBranchParent', 'randomBranchParent'].includes(dialog.type)">
          <el-form-item label="分支数量">
            <el-radio-group v-model="formDialog.branchNum" @change="randomBranchNumChange">
              <template v-for="(item, index) in 10">
                <el-radio v-if="item > 1" :key="index" :label="item">{{ item }}</el-radio>
              </template>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="dialog.type == 'randomBranchParent'" label=" ">
            <el-input-number
              v-for="(item, index) in formDialog.randomBranchPercent"
              :key="index"
              v-model="formDialog.randomBranchPercent[index]"
              :min="1"
              :max="100"
              label="%"
            ></el-input-number>
          </el-form-item>
        </template> -->

        <!-- 时间分支 -->
        <template v-else-if="dialog.type === '14'">
          <el-form-item label="分支名称" prop="branchName">
            <el-input
              v-model="formDialog.branchName"
              show-word-limit
              maxlength="15"
              placeholder="请输入"
            ></el-input>
          </el-form-item>
          <el-form-item label="设置时间" prop="branchTime">
            <div v-for="(item, index) in formDialog.branchTime" :key="index">
              <el-date-picker
                class="mb10"
                v-model="formDialog.branchTime[index]"
                type="datetime"
                format="yyyy-MM-dd HH:mm"
                value-format="yyyy-MM-dd HH:mm"
                :pickerOptions="pickerOptions"
                placeholder="请选择"
              ></el-date-picker>
              <el-button
                type="text"
                class="ml10"
                v-if="index > 0"
                @click="formDialog.branchTime.splice(index, 1)"
                >删除</el-button
              >
            </div>
            <el-button type="text" @click="formDialog.branchTime.push('')">继续添加时间</el-button>
          </el-form-item>
        </template>

        <!-- 等待-->
        <template v-else-if="dialog.type == 18">
          <el-form-item label="时间类型" prop="branchAwiatType">
            <el-select v-model="formDialog.branchAwiatType" placeholder="请选择">
              <el-option label="精确时间" value="0"> </el-option>
              <el-option label="相对时间" value="1"> </el-option>
            </el-select>
          </el-form-item>

          <el-form-item
            label="等待到"
            prop="branchAwiatAccurateTime"
            v-if="formDialog.branchAwiatType == 0"
          >
            <el-date-picker
              v-model="formDialog.branchAwiatAccurateTime"
              type="datetime"
              format="yyyy-MM-dd HH:mm"
              value-format="yyyy-MM-dd HH:mm"
              :pickerOptions="pickerOptions"
              placeholder="请选择"
            ></el-date-picker>
          </el-form-item>

          <el-form-item
            label="上一节点结束后"
            prop="branchAwiatRelativeTime"
            v-else-if="formDialog.branchAwiatType == 1"
          >
            <el-input-number
              v-model="formDialog.branchAwiatRelativeTime"
              min="1"
              placeholder="请输入"
            ></el-input-number>
            <el-select v-model="formDialog.branchAwiatRelativeType" placeholder="请选择">
              <el-option
                v-for="(item, index) of enumDict.relativeTime"
                :key="index"
                :label="item"
                :value="index + ''"
              >
              </el-option>
            </el-select>
          </el-form-item>
        </template>
      </el-form>
      <!-- 群发消息 -->
      <template v-else-if="dialog.type == 12">
        <MessageContent
          ref="messageContent"
          :disabled="disabled"
          style="width: 1100px"
          :showTemplate="false"
          showMorMaterial
          :baseData="formDialog"
          isgroup
          :showStepBtn="false"
          @submit="(form) => Object.assign(formDialog, form)"
        ></MessageContent>
      </template>

      <!-- 发表朋友圈 -->
      <template v-else-if="dialog.type == 13">
        <FriendCircleContent
          ref="friendCircleContent"
          style="width: 1100px"
          :data="formDialog"
        ></FriendCircleContent>
      </template>

      <div class="dialog-btn" v-if="dialog.type == 2 ? !disabledexeAudience : !disabled">
        <el-button @click="dialog.visible = false">取 消</el-button>
        <el-button type="primary" @click="confirm">确 定</el-button>
      </div>
    </el-drawer>
  </div>
</template>
<script>
import { uuid } from '@/utils/index'

import * as api from '@/api/marketStrategy/journey'
import { getCodeCategoryList as getClassGroupList } from '@/api/drainageCode/staff' // 人群分组
import { getList as getCrowdList } from '@/api/marketStrategy/people'
import { getList as getGroupCodeList } from '@/api/drainageCode/group'
import { getList as getCustomerServiceList } from '@/api/drainageCode/customerService'
import { getList as getGroupList } from '@/api/customer/group'
import { surveyList } from '@/api/drainageCode/smartForms'
import { getDeptUserAll } from '@/api/organization'
// 节点大小
const nodeSize = {
  width: 135,
  height: 44,
}

const nodeSizeBig = {
  width: 135,
  height: 88,
}

// 连线长
const lineLength = 200
// 流程图标（中心点）间隔距离
const distance = nodeSize.width + lineLength

const startCoordinate = [0, 0] // 节点左上角坐标

let enumDict = {
  result: ['成功', '失败', '其他'],
  friendCircleType: { 0: '点赞动态', 1: '评论动态' },
  relativeTime: ['分钟', '小时', '日'],
  match: {
    0: '精确匹配',
    1: '不匹配',
    2: '包含',
    3: '不包含',
    4: '为空',
  },
}

let formDialog = {
  status: 9, // 0-未执行 1-正在执行 2-完成 3-失败 9-待完善
  crowdId: '', // 策略人群id
  crowdName: '', // 策略人群
  crowdGroupId: '', // 人群分组id,
  crowdGroupName: '', // 人群分组,
  crowdNum: 0,

  staffsId: '', // 选择员工id，多个逗号分隔：'1232,32323,5232'
  staffsName: '',

  groupsId: '', // 选择社群id，多个逗号分隔
  groupsName: '', // 选择社群id，多个逗号分隔

  customerServicesId: '', // 选择客服id，多个逗号分隔
  customerServicesName: '', // 选择客服id，多个逗号分隔

  friendCircleType: ['0'], // 朋友圈互动类型 0点赞动态,1评论动态

  formsId: '', // 填写表单id
  formsName: '', // 填写表单
  formGroupsId: '', // 表单分组id,
  formGroupsName: '', // 表单分组id,

  tags: [],
  tagsId: '', // 标签id
  tagsName: '', // 标签

  groupCodeId: '', // 群活码id
  groupCodeName: '', // 群活码
  groupWelcome: '', // 加群引导语 最长200

  branchName: '', // 分支名称 最长15
  branchTime: [''], // 时间分支设置时间 多个逗号分隔
  branchResult: ['0'], // 结果分支 0 成功,1 失败, 2 其他

  branchAwiatType: '0', // 延时等待 时间类型 0 精确时间,1 相对时间,
  branchAwiatAccurateTime: '', //精确时间
  branchAwiatRelativeTime: 1, //相对时间 int
  branchAwiatRelativeType: '1', // 相对时间类型  0:分钟, 1:小时,2:日,

  otherContent: [],
  // taskId: '', // 整个任务id
  // taskName: '', // 节点任务名称
  // smsType: 1, // 短信类型 1:营销短信, 2:通知短信
  // template: '', // 短信模版id
  // sendType: 0, // 发送时间 ()  0:立即发送, 1:定时发送
  // sendTimeStart: undefined, // 开始发送时间(毫秒时间戳) eg：2412354634500
  // sendTimeEnd: undefined, // 最晚发送时间(毫秒时间戳) eg：2412354634500
  // sendCeil: 0, // 发送上限
  // smsSignature: '', // 签名选择
  // smsContent: '', // 短信内容
  // smsSplitNum: 0, // 短信配额
  // pushedName: '', // 推送后名称
  // timeType: 0, // 时间类型  0:精确时间, 1:相对时间
  // accurateTime: '', // 精确时间
  // relativeTime: 10, // 相对时间 int
  // relativeType: 2, // 相对时间类型  0:分钟, 1:小时,2:日, 3:周
  // result: [0, 1], // 等待/结果分支 - 执行结果 [0,1] 0:成功, 1:失败
  // branchNum: 2, // 复制、随机分支 - 分支数量
  // randomBranchPercent: [50, 50], // 随机分支 - 各分支所占百分比
  // accounts: [], // 账号选择 eg：['123','2312']
  // timeBranch: [''], // 时间分支 - 时间条件

  // //优惠券
  // couponName: '',
  // couponOrigin: '',
  // couponType: '',
  // coupon: '',
}
export default {
  components: {
    CountTo: () => import('vue-count-to'),
    MessageContent: () => import('@/components/WelcomeContent'),
    FriendCircleContent: () => import('@/components/FriendCircleContent'),
    SelectTag1: () => import('@/components/SelectTag1'),
  },
  props: {
    pageType: {
      type: String,
      default: 'add',
    },
    form: {
      type: Object,
    },
  },
  data() {
    var validateNum = (rule, value, callback) => {
      var type = '^[0-9]*[1-9][0-9]*$'
      var r = new RegExp(type)
      var flag = r.test(value)
      if (value === '') {
        callback(new Error('必填项'))
      } else if (!flag) {
        callback(new Error('请输入正整数'))
      } else {
        callback()
      }
    }
    return {
      getDeptUserAll,
      request: Object.freeze({
        getDeptUserAll,
        getGroupCodeList,
        getGroupList,
        getCustomerServiceList,
        getClassGroupList,
        getCrowdList,
        surveyList,
      }),
      order: 1,
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < new Date().setDate(new Date().getDate() - 1)
        },
      },
      // 节点类型 开始节点-0, 策略人群-2, 添加员工-3, 删除员工-4, 进入社群-5, 退出社群-6,朋友圈互动-19, 咨询客服-7, 领取红包-8, 填写表单-9, 设置标签-10, 自动拉群-11, 群发消息-12, 发表朋友圈-13, 时间分支-14, 时间节点-15, 结果分支-16, 结果节点-17, 延时等待-18, 结束节点-99
      flowMenuData: Object.freeze([
        {
          name: '事件触发',
          list: {
            3: {
              name: '添加员工',
              type: '3',
              icon: 'custom-addUser',
              placeholder: '请选择员工',
              desc: '已选人群中触发了【添加指定员工】事件',
              selectedKey: 'staffsName',
            },
            4: {
              name: '删除员工',
              type: '4',
              icon: 'custom-delUser',
              placeholder: '请选择员工',
              desc: '已选人群中触发了【删除指定员工】事件',
              selectedKey: 'staffsName',
            },
            5: {
              name: '进入社群',
              type: '5',
              icon: 'custom-inGroup',
              placeholder: '请选择社群',
              desc: '已选人群中触发了【进入指定社群】事件',
              selectedKey: 'groupName',
            },
            6: {
              name: '退出社群',
              type: '6',
              icon: 'custom-outGroup',
              placeholder: '请选择社群',
              desc: '已选人群中触发了【退出指定社群】事件',
              selectedKey: 'groupName',
            },
            19: {
              name: '朋友圈互动',
              type: '19',
              icon: 'custom-friendCircle',
              placeholder: '请选择类型',
              desc: '已选人群中触发了【朋友圈互动】事件',
            },
            7: {
              name: '咨询客服',
              type: '7',
              icon: 'custom-customerService',
              placeholder: '请选择客服',
              desc: '已选人群中触发了【咨询指定客服】事件',
              selectedKey: 'customerServicesName',
            },
            8: {
              name: '领取红包',
              type: '8',
              icon: 'custom-redpack',
              placeholder: '请选择员工',
              desc: '已选人群中触发了【领取指定员工红包】事件',
              selectedKey: 'staffsName',
            },
            9: {
              name: '填写表单',
              type: '9',
              icon: 'custom-form',
              placeholder: '请选择表单',
              desc: '已选人群中触发了【填写指定表单】事件',
            },
          },
        },
        {
          name: '企微运营',
          list: {
            10: {
              name: '设置标签',
              type: '10',
              icon: 'custom-tag',
              placeholder: '请选择标签',
              desc: '给已选人群设置指定的标签',
              selectedKey: 'tagsName',
            },
            11: {
              name: '自动拉群',
              type: '11',
              icon: 'custom-autoGroup',
              placeholder: '请选择社群',
              desc: '给已选人群自动发送群活码邀请入群',
              selectedKey: 'groupCodeName',
            },
          },
        },
        {
          name: '营销触达',
          list: {
            12: {
              name: '群发消息',
              type: '12',
              icon: 'custom-send',
              placeholder: '请设置内容',
              desc: '给已选人群群发规定的消息',
              selectedKey: 'content',
            },
            13: {
              name: '发表朋友圈',
              type: '13',
              icon: 'custom-friendCircle1',
              placeholder: '请设置内容',
              desc: '通知已选人群的所属员工发表指定内容朋友圈',
              selectedKey: 'content',
            },
            a: {
              name: '发送短信',
              type: '',
              icon: 'custom-chat',
              placeholder: '请设置时间',
              desc: '请选择员工',
            },
            b1: {
              name: '发送邮件',
              type: '',
              icon: 'custom-email',
              placeholder: '请设置结果',
              desc: '请选择员工',
            },
          },
        },
        {
          name: '流程/分支',
          list: {
            14: {
              name: '时间分支',
              type: '14', // 时间分支 14, 时间节点-15
              icon: 'custom-branchTime',
              placeholder: '请设置时间',
              desc: '按照时间对人群进行自动拆分',
            },
            16: {
              name: '结果分支',
              type: '16', // 结果节点-17
              icon: 'custom-branchRes',
              placeholder: '请设置结果',
              desc: '按照结果对人群进行自动拆分',
            },
            18: {
              name: '延时等待',
              type: '18',
              icon: 'custom-wait',
              placeholder: '请设置时间',
              desc: '等待规定时间后再执行后续节点',
            },
            99: {
              name: '结束旅程',
              type: '99',
              icon: 'custom-branchFinish',
            },
          },
        },
      ]),
      nodeList: [],
      linkList: [],
      enumDict: Object.freeze(enumDict),
      linkBaseStyle: Object.freeze({
        color: '#D8D8D8', //线条颜色
        hover: '#D8D8D8', //线条滑动颜色
        textColor: '#D8D8D8', //线条描述文字颜色
        textHover: '#D8D8D8', //线条描述文字滑动颜色
        font: '14px Arial', //线条描述文字字体设置
        lineWidth: 10,
        dotted: false, //是否是虚线
        lineDash: [2, 3], //虚线时生效
        background: 'rgba(255,255,255,0.6)', //描述文字背景色
      }),
      dropType: '',
      // nodeMenu: [
      //   [
      //     {
      //       label: '删除',
      //       selected: (node, a, b) => {

      //       },
      //     },
      //   ],
      // ],
      graphMenu: [
        [
          {
            label: '全选',
            selected: (graph, coordinate) => {
              graph.selectAll()
            },
          },
        ],
      ],

      dialog: {
        visible: false,
        type: '',
      },
      formDialog,
      rules: Object.freeze({
        crowdGroupId: [{ required: true, message: '必填项', trigger: 'change' }],
        crowdId: [{ required: true, message: '必填项', trigger: 'change' }],
        staffsId: [{ required: true, message: '必填项', trigger: 'change' }],
        groupsId: [{ required: true, message: '必填项', trigger: 'change' }],
        friendCircleType: [
          { required: true, type: 'array', message: '请至少选择一个', trigger: 'change' },
        ],
        customerServicesId: [{ required: true, message: '必填项', trigger: 'change' }],
        formGroupsId: [{ required: true, message: '必填项', trigger: 'change' }],
        formsId: [{ required: true, message: '必填项', trigger: 'change' }],
        // sendCeil: [{ required: true, message: '必填项', validator:validateNum, trigger: 'blur' }],
        // sendCeil: [{ required: true, validator: validateNum, trigger: 'blur' }],

        tags: [{ required: true, message: '必填项', trigger: 'change' }],
        groupCodeId: [{ required: true, message: '必填项', trigger: 'change' }],
        groupWelcome: [{ required: true, message: '必填项', trigger: 'blur' }],
        branchAwiatType: [{ required: true, message: '必填项', trigger: 'change' }],
        branchAwiatAccurateTime: [{ required: true, message: '必填项', trigger: 'change' }],
        branchAwiatRelativeTime: [{ required: true, message: '必填项', trigger: 'blur' }],
        branchName: [{ required: true, message: '必填项', trigger: 'blur' }],
        branchResult: [{ required: true, type: 'array', message: '必填项', trigger: 'change' }],
        branchTime: [{ required: true, type: 'array', message: '必填项', trigger: 'change' }],
        result: [{ required: true, message: '必填项', trigger: 'change' }],
      }),
      // crowdPackList: [],
      // groupCodeList: [],
      // smsTemplateList: [],
      // smsNum: 0, // 剩余短信配额
      // accountList: [],

      //标签分支弹窗相关
      // datasetId: undefined, // 选中的数据集
      // labelTypeList: [], // 数据集列表
      // labelDialogVisible: false, // 选择标签弹窗显隐
      // labelCurrentEdit: {}, // 当前编辑的数据集下的标签
      // labelCurrentEditIndex: false, // 当前选中的tab索引
      // inputValue: '',
      // inputVisible: false,
      // labelForm: {
      //   type: null, // 数据交并集： 0：交集and，1：并集or
      //   matchType: 0,
      //   labelList: [],
      // },
      // labelTabActive: '0', // 当前选中的tab索引,
      // disabledexeAudience: false, // 执行人群是否置灰
      dialogLoading: false,

      nodeDataView: {
        0: {
          type: '0',
          name: '旅程开始',
        },
        2: {
          type: '2',
          name: '策略人群',
          placeholder: '请选择人群',
          desc: '在已有人群中用于选择本条旅程执行的客户范围',
          selectedKey: 'crowdName',
        },
        empty: {
          name: '添加节点',
          type: 'empty',
        },
      },
    }
  },
  mounted() {
    this.flowMenuData.forEach((e) => Object.assign(this.nodeDataView, e.list))
    this.init(this.$route.query.id)
    // this.getCrowdPackList()
    // 默认情况下,数据/元素不能在其他元素中被拖放。对于drop我们必须防止元素的默认处理
    document.addEventListener('dragover', function (event) {
      event.preventDefault()
    })
  },
  computed: {
    disabled() {
      return this.pageType == 'view'
    },
    defaultTime() {
      let date = new Date()
      date.setMinutes(date.getMinutes() - date.getTimezoneOffset() + 60)
      return date.toJSON().substring(11, 19)
    },
  },
  created() {},
  methods: {
    //   将时间戳转为日期
    timestampToTime(timestamp) {
      let date = new Date(timestamp)
      date.setMinutes(date.getMinutes() - date.getTimezoneOffset())
      return date.toJSON().substring(0, 19).replace(/[T]/g, ' ')
    },
    async init(teskId) {
      if (teskId) {
        // 编辑
        let form = this.form
        form || (form = (await api.getDetail(teskId)).data)
        form.nodeList.forEach((e) => (e.meta = JSON.parse(e.meta)))
        // let { data } = await api.getDetail(teskId)
        this.nodeList.push(...form.nodeList)
        console.log(form)
        if (this.pageType != 'view') {
          // 给所有的非结束节点的末枝节点添加空白节点
          let { arr } = this.buildTree(this.nodeList.slice(0))
          arr.forEach((element, index) => {
            if (element.meta.type != '99' && !element.children) {
              // 添加最后的空节点
              let id = uuid('node')
              let empty = {
                id,
                coordinate: [element.coordinate[0] + distance, element.coordinate[1]],
                meta: {
                  id,
                  type: 'empty',
                  pid: element.id,
                },
              }
              this.nodeList.splice(index, 0, empty)
            }
          })
        }
      } else {
        // 新增
        let id = uuid('node')
        let idEmpty = uuid('node')
        this.nodeList = [
          {
            id: 'start',
            coordinate: startCoordinate,
            meta: {
              id: 'start',
              pid: '0',
              type: '0',
              status: 0,
            },
          },
          {
            id,
            coordinate: [startCoordinate[0] + 1 * distance, startCoordinate[1]],
            ...nodeSizeBig,
            meta: {
              id,
              pid: 'start',
              type: '2',
              status: 9,
            },
          },
          {
            id: idEmpty,
            coordinate: [startCoordinate[0] + 2 * distance, startCoordinate[1]],
            meta: {
              id: idEmpty,
              pid: id,
              type: 'empty',
            },
          },
        ]
      }

      // if (this.$route.query.type === 'add' || !this.$route.query.type) {
      //   // 添加最后的空节点
      //   let lastNodeCoordinate = this.nodeList.slice(-1)[0]
      //   let id = uuid('node')
      //   let empty = {
      //     id,
      //     coordinate: [
      //       lastNodeCoordinate.coordinate[0] + distance,
      //       lastNodeCoordinate.coordinate[1],
      //     ],
      //     meta: {
      //       id,
      //       type: 'empty',
      //       pid: lastNodeCoordinate.id,
      //     },
      //   }
      //   this.nodeList.push(empty)
      // } else if (this.$route.query.type == 'view') {
      //   this.nodeList.forEach((element) => {
      //     if (element.meta.type == 'sms') {
      //       element.meta.data &&
      //         element.meta.data.businessId &&
      //         api.getSmsSendResult(element.meta.data.businessId).then((res) => {
      //           if (res.result[0]) {
      //             element.meta._sendSuccessNum = res.result[0].sendSuccessNum
      //             element.meta._sendFailNum = res.result[0].sendFailNum
      //           }
      //         })
      //       element.meta.data &&
      //         element.meta.data.businessId &&
      //         api.getSmsSendDetail(element.meta.data.businessId).then((res) => {
      //           if (res.result.sendTime) {
      //             element.meta._sendTime = res.result.sendTime
      //           }
      //         })
      //     }
      //   })
      // }

      this.reDrawLine()
    },
    linkStyle(link) {
      if (link.meta) {
        let status = link.meta.status
        return {
          // hover: link.meta.status < 2 ? '#D5D5D5' : 'green',
          color: status == 2 ? 'green' : status == 3 ? 'red' : '#D5D5D5',
          dotted: link.meta.status != 3,
        }
      }
    },
    linkDesc(link) {
      return link.meta ? link.meta.desc : ''
    },
    move() {
      // console.log(this.$refs.superFlow)
      this.$refs.superFlow.selectedAll()
    },
    drop(event, id, type) {
      event.preventDefault()

      const newNode = { meta: { type: this.dropType, ...formDialog } }
      // 查找插入当前空节点的位置
      let index = this.nodeList.findIndex((e) => e.id === id)
      let emptyNode = this.nodeList[index]
      let parentNode = this.nodeList.find((e) => e.id === emptyNode.meta.pid)

      // 相邻节点类型不能相同
      if (parentNode.meta.type === newNode.meta.type) {
        this.$message.error('相邻节点类型不能相同')
        return
      }

      // 结果分支16，应该只能接在自动拉群11，群发消息12，延时等待18，短信组件之后，添加在其他组件之后需要提示：“结果分支”不能放在该节点后面
      if (newNode.meta.type == 16 && [11, 12, 18].indexOf(+parentNode.meta.type) == -1) {
        this.$message.error('“ 结果分支 ” 只能放在【自动拉群、群发消息、延时等待】节点后面')
        return
      }

      const coordinate = emptyNode.coordinate.slice()
      newNode.coordinate = coordinate
      // newNode.id = uuid('node')
      Object.assign(newNode, nodeSizeBig)

      newNode.meta.pid = emptyNode.meta.pid || 'start'
      newNode.meta.status === undefined && (newNode.meta.status = 9)
      // 结束旅程节点状态设为0
      newNode.meta.type == 99 && (newNode.meta.status = 0)
      emptyNode.meta.pid = newNode.id = newNode.meta.id = uuid('node')

      this.nodeList.push(newNode)
      this.nodeList.splice(index, 1)

      if ([99].includes(+newNode.meta.type)) {
        // this.nodeList.splice(index, 1)
      } else {
        emptyNode.coordinate[0] = coordinate[0] + distance
        this.nodeList.push(emptyNode)
      }

      this.reDrawLine()
      this.$nextTick(() => {
        this.$refs.flowContainer.scrollLeft += distance * 2
        // console.log(this.$refs.superFlow.toJSON());
      })
    },
    nodeClick(id, type) {
      if (
        type == '2' &&
        this.nodeList[1].meta.crowdId &&
        this.nodeList.filter((e) => e.meta.type != 'empty').length > 2
      ) {
        this.disabledexeAudience = true
      } else {
        this.disabledexeAudience = false
      }
      if (type != 2 && !(this.nodeList[1].meta && this.nodeList[1].meta.crowdId)) {
        this.$message.error('请先设置 " 策略人群 " 数据')
        return
      }
      this.currentEdit = this.nodeList.find((e) => e.id === id)

      this.dialog = {
        visible: true,
        type,
      }
      let curMeta = this.currentEdit.meta
      this.formDialog = JSON.parse(JSON.stringify(curMeta || formDialog))
      this.$nextTick(() => {
        this.$refs.formDialog && this.$refs.formDialog.clearValidate()
        // 群发消息
        if (type == 12) {
          curMeta.welcomeMsg = curMeta.content
          curMeta.materialMsgList =
            curMeta.materialMsgList ||
            this.$refs.messageContent.setEditList(curMeta.attachmentsList)
        }
      })
    },
    remoteSelectChange(list, key) {
      this.formDialog[key] = list.map((e) => e.name)
    },
    async confirm() {
      let validate = true
      let form = this.formDialog
      if (this.dialog.type == 12) {
        // 群发消息
        validate = this.$refs.messageContent.submit()
        if (!validate) {
          return
        }
        form = JSON.parse(JSON.stringify(form))
        form.attachmentsList = this.$refs.messageContent.resetData(form.materialMsgList)
        form.content = form.welcomeMsg
        form.attachmentsList.unshift({
          content: form.welcomeMsg,
          msgType: 'text',
        })
      } else if (this.dialog.type == 13) {
        // 发表朋友圈
        validate = this.$refs.friendCircleContent.validate()
      } else {
        await this.$refs.formDialog.validate()
      }

      if (!validate) {
        return
      }
      form = JSON.parse(JSON.stringify(form))

      if (this.dialog.type === '10') {
        // 标签
        form.tagsId = form.tags.map((e) => e.id)
        form.tagsName = form.tags.map((e) => e.name)
      } else if (this.dialog.type === '18') {
        // 延时等待
        if (form.branchAwiatType == 0) {
          form.selected = '等待到' + form.branchAwiatAccurateTime
        } else {
          form.selected =
            '上一节点结束后' +
            form.branchAwiatRelativeTime +
            enumDict.relativeTime[form.branchAwiatRelativeType]
        }
      } else if (this.dialog.type === '19') {
        // 朋友圈互动
        let arr = []
        form.friendCircleType.forEach((e) => {
          arr.push(enumDict.friendCircleType[e])
        })
        form.selected = arr.join('，')
      }

      let selectedKey = this.nodeDataView[this.dialog.type].selectedKey
      if (selectedKey) {
        let selected = form[selectedKey]
        form.selected = Array.isArray(selected) ? selected.join('，') : selected
      }

      // this.dialog.visible = false
      // 时间分支-14 结果分支-16
      if ([14, 16].includes(+this.dialog.type)) {
        if (this.dialog.type == 14 && form.branchTime.some((e) => !e)) {
          this.$message.error('所有时间都不能为空')
          return
        }
        if (this.currentEdit.meta.status != 9) {
          let isGo = await this.$confirm('此操作将删除后续所有流程节点, 是否继续?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
          })
            .then(() => {
              this.addBranch()
            })
            .catch((err) => {
              console.error(err)
              return false
            })
          if (isGo === false) {
            return
          }
        } else {
          this.addBranch()
        }
      }
      this.nodeList.push()
      this.dialog.visible = false
      Object.assign(this.currentEdit.meta, form, { status: 0 })
      this.reDrawLine()
    },

    addBranch() {
      let arr = []
      let num = 0
      let { id: pid, coordinate } = this.currentEdit
      let form = this.formDialog
      let index = this.nodeList.findIndex((e) => e.id == pid)
      this.nodeList = this.nodeList.slice(0, index + 1)

      // 时间分支-14 结果分支-16
      if (this.dialog.type == 16) {
        num = form.branchResult.length
      } else if (this.dialog.type == 14) {
        num = form.branchTime.length
      }

      let maxY = 0
      for (let i = 0; i < num; i++) {
        let id = uuid('node')
        let item = {
          id,
          coordinate: [coordinate[0] + distance, coordinate[1] + lineLength * i],
          meta: {
            pid,
            status: 0,
            type: { 14: 15, 16: 17 }[this.dialog.type],
          },
        }

        // 名称
        if (this.dialog.type == 16) {
          item.meta.branchResult = form.branchResult[i]
          item.meta.branchName = enumDict.result[form.branchResult[i]]
        } else if (this.dialog.type == 14) {
          item.meta.branchTime = form.branchTime[i]
          item.meta.branchName = form.branchTime[i]

          // let date = new Date(+form.branchTime[i])
          // date.setMinutes(date.getMinutes() - date.getTimezoneOffset()) // toJSON 的时区补偿
          // item.meta.branchTime = date.toJSON().substring(0, 19).replace(/[T]/g, ' ')
          // item.meta.data.timeBranch = [form.timeBranch[i]]
        }

        // 添加最后的空节点
        let idEmpty = uuid('node')
        let empty = {
          id: idEmpty,
          coordinate: [item.coordinate[0] + distance, item.coordinate[1]],
          meta: {
            type: 'empty',
            id: idEmpty,
            pid: item.id,
          },
        }
        // this.nodeList.push(empty);
        arr.push(item, empty)

        if (i == num - 1) {
          maxY = item.coordinate[1]
        }
      }

      // let removeIndex = []
      this.nodeList.forEach((e, i) => {
        // 自动延伸 y 坐标轴上其他节点 y 坐标 ，避免节点重合
        if (coordinate[1] < e.coordinate[1]) {
          e.coordinate[1] += maxY
        }

        // if (e.pid == pid) {
        //   removeIndex.push(i)
        // }
      })
      // 删除其子节点（废弃）
      // removeIndex.reverse().forEach((e) => {
      //   this.nodeList.splice(e, 1)
      // })

      this.nodeList.push(...arr)
      this.reDrawLine()
      this.$nextTick(() => {
        this.$refs.flowContainer.scrollLeft += distance * 2
      })
    },
    // 重绘连线
    reDrawLine() {
      this.linkList = []
      this.nodeList.forEach((item, index) => {
        Object.assign(item, nodeSize)
        // 根据节点生成连线
        let linkItem = {
          id: uuid('link'),
          startId: item.meta.pid,
          endId: item.id,
          startAt: [nodeSize.width, Math.round(nodeSize.height / 2)],
          endAt: [0, 1],
          meta: {
            type: item.meta.type,
            status: item.meta.status,
          },
        }
        this.linkList.push(linkItem)
      })
    },
    // 树转数组
    transTree(tree) {
      let arr = []
      function dg(obj) {
        if (obj.children) {
          arr.push(...obj.children)
          obj.children.forEach((e) => {
            dg(e)
          })
          // delete obj.children
        }
      }
      arr.push(tree)
      dg(tree)
      return arr
    },
    // 数组转树
    buildTree(arr) {
      arr = JSON.parse(JSON.stringify(arr))
      let treeData = {}
      let map = {}
      arr.forEach((e) => {
        map[e.id] = e
      })
      arr.forEach((e) => {
        let parent = map[e.meta.pid]
        if (parent) {
          ;(parent.children || (parent.children = [])).push(e)
          // Object.seal(parent)
        } else {
          treeData = e
        }
      })
      return { treeData, arr }
    },
    save(type) {
      // if (type && this.form.deadline && this.form.deadline < +new Date()) {
      //   this.$message.error('任务结束时间不能小于当前时间')
      //   return
      // }
      let { arr } = this.buildTree(this.nodeList.slice(1))
      // 上面解析完的arr，只有每个分支的最后末枝的节点是没有children属性的
      let noSetNode = arr.find((element) => element.meta.status == 9)
      if (type && noSetNode) {
        this.$message.error(
          '” ' + this.nodeDataView[noSetNode.meta.type].name + ' “ 节点待完善，请检查后重试'
        )
        return
      }
      let noend = arr.some(
        (element) => element.meta.type != '99' && !element.children
        // (element.type != 'end' && element.status == 9) || (!element.children && element.type != 'end')
      )
      if (type && noend) {
        this.$message.error('缺少 " 结束 " 节点')
        return
      }
      // if (!noend && !isWan) {
      //   this.form.status = 1
      // }
      let form = JSON.parse(JSON.stringify(this.form))
      let nodeList = JSON.parse(JSON.stringify(this.nodeList))
      let linkList = JSON.parse(JSON.stringify(this.linkList))

      // 去掉空节点（后端不存）,
      form.nodeList = nodeList.filter((e) => e.meta.type != 'empty')
      form.lineList = linkList.filter((e) => e.meta.type != 'empty')
      form.lineList.forEach((element) => {
        element.meta = JSON.stringify(element.meta)
      })
      form.nodeList.forEach((element) => {
        let curMeta = element.meta
        element.nodeType = curMeta.type
        element.meta = JSON.stringify(curMeta)
        // let meta = curMeta
        // for (const key in meta) {
        //   if (Object.hasOwnProperty.call(meta, key)) {
        //     const element = meta[key]
        //     Array.isArray(element) && (meta[key] = meta[key].join(','))
        //   }
        // }
        // curMeta.data || (curMeta.data = {})
        // curMeta.data.crowdId = this.nodeList[1].meta.data.crowdId
      })
      form.status = type ? 1 : 0
      // let apiTypt = ''
      // if (type) {
      //   form.status = 1
      //   apiTypt = form.id ? 'updateStart' : 'addStart'
      // } else {
      //   form.status = 0
      // apiTypt = form.id ? 'update' : 'add'
      // }

      let loading = this.$loading()
      api[type ? (form.id ? 'update' : 'add') : 'tempSave'](form)
        .then(({ data }) => {
          this.$message.success('操作成功')
          this.$router.back()
          // data && this.init(data)
        })
        .finally(() => {
          loading.close()
        })
    },
    removeNode(id) {
      this.$confirm(
        '是否确认删除该旅程节点？删除后后续节点会同步删除且不可撤销，请谨慎操作',
        '提示',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }
      )
        .then(() => {
          // 删除结束节点自动变为空白节点
          let node = null
          let index = this.nodeList.findIndex((el) => {
            node = el
            return el.id == id
          })
          // if (node.meta.type === 'end') {

          // } else {
          // }
          let { arr: arr1 } = this.buildTree(this.nodeList.slice(1))
          let current = arr1.find((e) => e.id === node.id)
          let removeArr = this.transTree(current)
          removeArr.forEach((e) => {
            let _ind = this.nodeList.findIndex((el) => el.id == e.id)
            _ind > -1 && this.nodeList.splice(_ind, 1)
          })
          // 添加最后的空节点
          let idEmpty = uuid('node')
          let empty = {
            id: idEmpty,
            coordinate: node.coordinate,
            meta: {
              type: 'empty',
              pid: node.meta.pid,
              id: idEmpty,
            },
          }
          this.nodeList.splice(index, 0, empty)
          // 重新绘制
          this.reDrawLine()
        })
        .catch(() => {})
    },
    remove(node, data) {
      this.$confirm('此操作将删除其所有子节点数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          const parent = node.parent
          const children = parent.data.children || parent.data
          const index = children.findIndex((d) => d.labelId === data.labelId)
          children.splice(index, 1)
        })
        .catch((err) => {
          console.log(err)
        })
    },
    // add(node, data) {
    //   let obj = {
    //     type: 0,
    //     labelName: '虚拟节点' + this.order,
    //     matchType: -1,
    //     labelList: [],
    //     children: [],
    //     isFalse: true,
    //   }
    //   console.log(node)
    //   if (!node.data.children) {
    //     node.data.children = []
    //   }
    //   node.data.children.push(obj)
    //   this.order++
    // },
    beforeEnter(current, target, event) {
      console.log(target)
      if (target.data.isFalse && target.level != 1) {
        return true
      } else {
        return false
      }
    },
    // removeLabelTab(name) {
    //   this.$confirm('确定要删除吗？', '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     type: 'warning',
    //   })
    //     .then(() => {
    //       this.formDialog.labelBranch.splice(~~name, 1)
    //       let len = this.formDialog.labelBranch.length
    //       name <= this.labelTabActive &&
    //         this.labelTabActive != 0 &&
    //         (this.labelTabActive = String(~~this.labelTabActive - 1))
    //     })
    //     .catch((err) => {
    //       console.log(err)
    //     })
    // },
    // 右键屏蔽
    contextmenu(type) {
      if (['0', 'empty', '2', '15', '17'].includes(type + '')) {
        event.stopPropagation()
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.flow-wrap {
  height: calc(100vh - 236px);
  .flow-menu {
    width: 280px;
    padding: 0 20px;
    border: 20px solid transparent;
    border-width: 20px 0;
    background: #fff;
    overflow: auto;
    flex: 0 0 auto;
    margin-right: 16px;

    .flow-menu-title {
      font-size: 16px;
      font-weight: 600;
    }
    .title {
      font-size: 14px;
      font-weight: 600;
    }
    .flow-menu-ul {
      display: flex;
      flex-wrap: wrap;
      .flow-menu-li {
        font-size: 12px;
        font-weight: 400;
        text-align: center;
        width: 29%;
        margin: 20px 2% 0;
        color: #666;

        .flow-menu-icon {
          display: inline-block;
          font-size: 25px;
          width: 40px;
          line-height: 40px;
          border-radius: 8px;
          background: #f7f8fa;
          margin: 0 0 10px;
        }
      }
    }
  }
}

.flow-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: #fff;
  border-radius: 0px 4px 4px 0px;
  .flow-status {
    line-height: 20px;
    font-size: 12px;
    [class*='line']::before {
      content: '';
      display: inline-block;
      width: 50px;
      border: 1px solid #21b738;
      border-color: inherit;
      margin: 3px 10px;
    }
    .line-1 {
      border-color: #21b738;
    }
    .line-2 {
      border-color: #d8001b;
    }
    .line-3 {
      border-color: #797979;
    }
  }
  .flow-section {
    height: calc(100% - 68px);
    padding: 30px 0;
    margin: 50px 20px 10px;
    overflow: auto;
  }
  ::v-deep {
    .super-flow__node {
      border: none;
      box-shadow: none;
      background: none;
    }
    &:hover {
      // box-shadow: none;
    }
    .super-flow__line {
      // transition: all 0.3s;
    }
  }

  .flow-node {
    position: relative;
    font-weight: 400;
    color: #666;
    text-align: center;
    line-height: 40px;
    background: #eee;
    border: 2px solid #eee;
    border-radius: 8px;
    &.fun-node {
      transform: translateY(-25%);
      .el-icon-error {
        display: none;
        position: absolute;
        color: #aaa;
        right: -8px;
        top: -8px;
        font-size: 18px;
      }
      &:hover .el-icon-error {
        display: inline-block;
      }
      .placeholder,
      .name {
        background: #fff;
        line-height: 42px;
        padding: 0 5px;
      }
      .placeholder {
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 0 0 8px 8px;
      }

      .name {
        background: transparent;
        .svg-icon {
          font-size: 18px;
          vertical-align: text-bottom;
        }
      }
      .selected {
        color: #0079de;
      }
    }
    &.empty {
      border: 2px dashed #d8d8d8;
      background: #fff;
    }
  }
}

::v-deep {
  .el-drawer {
    width: auto !important;
    min-width: 30%;
  }
  .el-drawer__header {
    margin-bottom: 10px;
    .title {
      color: #333;
      font-size: 16px;
      font-weight: 600;
    }
    .desc {
      color: #999;
      font-size: 14px;
      font-weight: 600;
      margin-top: 8px;
    }
  }
  .el-drawer__body {
    margin: 0 0 55px 20px;
    overflow-x: hidden;

    .crowdNum {
      display: inline-block;
      padding: 10px 20px;
      border: 1px solid #dcdfe6;
      text-align: center;
      margin-left: 10px;
      border-radius: 8px;
      .num {
        font-weight: 600;
        font-size: 30px;
      }
    }

    .label-group {
      max-height: auto;
    }
  }

  .dialog-btn {
    position: absolute;
    bottom: 10px;
  }

  // 禁用样式修改
  .el-input.is-disabled .el-input__inner,
  .el-textarea.is-disabled .el-textarea__inner {
    color: inherit;
    background: transparent;
    // border-color:transparent;
    cursor: auto;
  }
}
.light {
  max-width: 220px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #409eff;
}
.flow-node.error {
  color: #f00;
  // border: 1px solid #f00;
  border-bottom: 3px solid #f00;
  // border-radius: 5px;
}

::v-deep .el-tree-node__content > .el-tree-node__expand-icon {
  display: none;
}

::v-deep.super-flow {
  width: auto;
  overflow: visible;
  ::-webkit-scrollbar {
    display: none;
  }
  & > .select-all__mask {
    z-index: auto;
  }
}
</style>
