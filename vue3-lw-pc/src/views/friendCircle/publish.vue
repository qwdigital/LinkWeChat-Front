<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form
          label-width="110px"
          label-position="right"
          :model="form"
          :rules="rules"
          ref="ruleForm"
        >
          <div class="g-card">
            <el-form-item label="任务名称：" prop="name">
              <el-input
                v-model="form.name"
                placeholder="请输入任务名称"
                maxlength="20"
                show-word-limit
                :disabled="firendId"
              ></el-input>
            </el-form-item>
            <el-form-item label="发送方式：" prop="sendType">
              <el-radio-group v-model="form.sendType" :disabled="firendId">
                <el-radio :label="0"
                  >企微群发
                  <el-popover placement="top" trigger="hover">
                    <template #reference>
                      <div class="question">
                        <div class="question-content" v-if="!firendId">?</div>
                      </div>
                    </template>
                    <div>
                      员工可一键执行，但同一条朋友圈对相同客户仅会展示第一位成员发送的朋友圈
                    </div>
                  </el-popover></el-radio
                >
                <el-radio :label="2"
                  >成员群发
                  <el-popover placement="top" trigger="hover">
                    <template #reference>
                      <div class="question">
                        <div class="question-content" v-if="!firendId">?</div>
                      </div>
                    </template>
                    <div>需要成员手动发送，但同一条朋友圈对相同客户会展示每个成员发送的朋友圈</div>
                  </el-popover>
                </el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="发送范围：" required @change="scopeTypeChange">
              <el-radio-group v-model="form.scopeType" :disabled="firendId">
                <el-radio :label="0">全部客户</el-radio>
                <el-radio :label="1">按条件筛选</el-radio>
              </el-radio-group>
              <div class="customer-num">
                <span>朋友圈预计可见客户数（不去重）：</span><span>{{ form.customerNum }}</span>
              </div>
              <SelectMember
                ref="selectMember"
                :initData="addWeUser"
                @update="getExecuteData"
                :show="true"
                v-if="form.scopeType === 1"
                :disabled="firendId"
              ></SelectMember>
            </el-form-item>
            <!-- <el-form-item label="选择客户标签" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedTagList" :key="key">{{
                unit.name
              }}</el-tag>
              <div>
                <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
              </div>
            </el-form-item> -->
            <el-form-item label="执行时间：">
              <div class="tips" v-if="!firendId">
                可自由设定该朋友圈任务下发通知的开始时间，如未设置则默认创建时间即开始执行时间
              </div>
              <el-date-picker
                v-model="form.executeTime"
                type="datetime"
                placeholder="选择年月日时分"
                format="YYYY-MM-DD HH:mm"
                v-bind="pickerOptions"
                :disabled="firendId"
              >
              </el-date-picker>
            </el-form-item>
            <el-form-item label="结束时间：" prop="executeEndTime">
              <div class="tips" v-if="!firendId">
                朋友圈任务可设置截止时间，则未完成的成员不允许再执行本条任务
              </div>
              <el-date-picker
                v-model="form.executeEndTime"
                type="datetime"
                placeholder="选择年月日时分"
                format="YYYY-MM-DD HH:mm"
                v-bind="pickerOptions"
                :disabled="firendId"
              >
              </el-date-picker>
            </el-form-item>
            <el-form-item label="自动标签：">
              <div class="tips">可根据客户的点赞或评论行为分别打上对应标签</div>
              <div>点赞自动打标签：</div>
              <div v-if="likeTagList.length">
                <el-tag sizi="mini" v-for="(unit, key) in likeTagList" :key="key">{{
                  unit.name
                }}</el-tag>
              </div>
              <div class="tips" v-if="!likeTagList.length && firendId">未选择标签</div>
              <div v-if="!firendId">
                <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
              </div>
              <div class="mt10">评论自动打标签：</div>
              <div v-if="commentTagList.length">
                <el-tag sizi="mini" v-for="(unit, key) in commentTagList" :key="key">{{
                  unit.name
                }}</el-tag>
              </div>
              <div class="tips" v-if="!commentTagList.length && firendId">未选择标签</div>
              <div v-if="!firendId">
                <el-button type="primary" plain @click="selectedFn2">选择标签</el-button>
              </div>
            </el-form-item>
            <el-form-item label="朋友圈内容：" v-if="[1, 2, 3].includes(firendType)">
              <el-input
                v-model="form.content"
                placeholder="未填写文本内容"
                :disabled="true"
                type="textarea"
                :rows="4"
                v-if="firendType === 1"
              ></el-input>
              <div class="firend-box" v-else>
                <FirendContent :list="friendsList" />
              </div>
            </el-form-item>
          </div>
          <!-- <FriendCircleContent ref="friendCircleContent" :data="form"></FriendCircleContent> -->
          <AddMaterial
            :moduleType="4"
            @update="onBackStep"
            @submit="submit"
            :otherType="3"
            :showPhone="false"
            :detail="firendId !== undefined"
            v-if="!firendId || (firendId && firendType === 1)"
          ></AddMaterial>

          <!-- <el-form-item label-width="0" style="margin-top: 20px; margin-bottom: 0">
            <el-button @click="onBackStep">取消</el-button>
            <el-button type="primary" @click="submit">保存</el-button>
          </el-form-item> -->
        </el-form>
      </el-col>
    </el-row>
    <!-- 选择标签弹窗 -->
    <SelectTag
      v-model:visible="dialogVisibleSelectTag"
      :defaultValues="likeTagList"
      @success="submitSelectTag"
    ></SelectTag>
    <SelectTag
      v-model:visible="dialogVisibleSelectTag2"
      :defaultValues="commentTagList"
      @success="submitSelectTag2"
    ></SelectTag>
    <!-- <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"
    ></SelectUser> -->
  </div>
</template>

<script>
import { addMoments, numMoments, getDetail } from '@/api/circle'
import AddMaterial from '@/components/ContentCenter/AddMaterial'
import SelectMember from './components/SelectMember.vue'
import FirendContent from './components/FirendContent.vue'
import moment from 'moment'

export default {
  name: 'publish-detail',
  components: {
    AddMaterial,
    SelectMember,
    FirendContent,
    SelectTag: defineAsyncComponent(() => import('@/components/SelectTag')),
    FriendCircleContent: defineAsyncComponent(() => import('@/components/FriendCircleContent')),
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 24 * 60 * 60 * 1000
        },
      },
      form: {
        scopeType: 0, // 发送范围: 0全部客户 1按条件筛选
        sendType: 0, // 发送方式: 0企微群发，1成员群发
        // customerTag: '', // 客户标签，多个使用逗号隔开
        // noAddUser: '', // 发送员工，使用逗号隔开
        customerNum: 0, // 朋友圈可见客户数
        executeTime: '', // 执行时间
        executeEndTime: '', // 结束时间
        content: '', //文本框内容
        likeTagIds: [], // 点赞标签集合
        commentTagIds: [], // 评论标签集合
        materialIds: [], // 素材id集合
        // otherContent: [],
        // contentType: '', //图片:image 视频:video 图文链接:link
      },
      // 遮罩层
      loading: false,
      // selectedUserList: [],
      // dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      dialogVisibleSelectTag2: false,
      likeTagList: [],
      commentTagList: [],
      addWeUser: {
        userIds: [],
        deptIds: [],
        posts: [],
        customerTag: [],
      },
      rules: {
        name: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
        sendType: [{ required: true, message: '请选择发送方式', trigger: 'change' }],
        executeEndTime: [
          { type: 'date', required: true, message: '请选择结束时间', trigger: 'change' },
        ],
      },
      firendId: undefined,
      firendType: undefined,
      friendsList: [
        {
          searchValue: null,
          createBy: 'admin',
          createById: '1',
          createTime: '2022-11-15 15:48:31',
          updateBy: 'admin',
          updateById: '1',
          updateTime: '2023-02-06 17:26:08',
          remark: null,
          params: {},
          id: '1592424290681036801',
          categoryId: '1592424015153205248',
          fileName: null,
          moduleType: 1,
          materialUrl: null,
          materialName: '企微',
          content: '企微文本测试',
          digest: null,
          coverUrl: null,
          audioTime: '0',
          backgroundImgUrl: null,
          type: null,
          width: null,
          height: null,
          mediaType: '4',
          otherField: null,
          materialStatus: 0,
          frontOrder: null,
          delFlag: 0,
          linkUrl: null,
          isCheck: false,
          posterSubassembly: null,
          posterQrType: null,
          weMaterialImgAoList: null,
        },
        {
          searchValue: null,
          createBy: 'admin',
          createById: '1',
          createTime: '2022-11-15 16:16:40',
          updateBy: 'admin',
          updateById: '1',
          updateTime: '2022-11-15 16:17:14',
          remark: null,
          params: {},
          id: '1592431373463810050',
          categoryId: '1',
          fileName: null,
          moduleType: 1,
          materialUrl: 'https://baidu.com',
          materialName: '测试图文111',
          content: '11111',
          digest: null,
          coverUrl:
            'https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2022-11-15/t1668500192729-S9m2jF8F58Z7IIky-.jpg',
          audioTime: '0',
          backgroundImgUrl: null,
          type: null,
          width: null,
          height: null,
          mediaType: '9',
          otherField: null,
          materialStatus: 0,
          frontOrder: null,
          delFlag: 0,
          linkUrl: null,
          isCheck: false,
          posterSubassembly: null,
          posterQrType: null,
          weMaterialImgAoList: null,
        },
        {
          searchValue: null,
          createBy: 'admin',
          createById: '1',
          createTime: '2022-11-21 16:43:00',
          updateBy: 'admin',
          updateById: '1',
          updateTime: '2022-11-21 16:43:00',
          remark: null,
          params: {},
          id: '1594612329406877697',
          categoryId: '1',
          fileName: null,
          moduleType: 1,
          materialUrl: null,
          materialName: 'dddd',
          content:
            '<p><img src="https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2022/11/21/84950e1f-55b5-4797-8b90-d260138502ac.jpg"></p>',
          digest: 'dddd',
          coverUrl: null,
          audioTime: '0',
          backgroundImgUrl: null,
          type: null,
          width: null,
          height: null,
          mediaType: '12',
          otherField: null,
          materialStatus: 0,
          frontOrder: null,
          delFlag: 0,
          linkUrl: null,
          isCheck: false,
          posterSubassembly: null,
          posterQrType: null,
          weMaterialImgAoList: null,
        },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2022-11-15 16:09:27',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-01-05 14:59:19',
        //   remark: null,
        //   params: {},
        //   id: '1592429557892255745',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2023-01-05/t1672901951467-mzNiInJA43JG7jYN.png',
        //   materialName: 'noOrder.png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-05-22 10:21:17',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-05-22 10:21:17',
        //   remark: null,
        //   params: {},
        //   id: '1660470855588671489',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://dev.linkwechat.net/fileUpload/afb88b4a-a989-47df-82af-9d285a5cfcb1.png',
        //   materialName: '0-2.png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-30 16:46:07',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-30 16:46:07',
        //   remark: null,
        //   params: {},
        //   id: '1641361146957025281',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://dev.linkwechat.net/fileUpload/dc6e74db-9b36-44db-9558-b67e4b6f5334.jpg',
        //   materialName: '微信图片_20211011135610.jpg',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-30 16:46:07',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-30 16:46:07',
        //   remark: null,
        //   params: {},
        //   id: '1641361147204489218',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://dev.linkwechat.net/fileUpload/b58366f4-7d12-44b5-98e1-b36c2e12d4aa.png',
        //   materialName: '69a262f2-5947-430f-9308-6a493257e6e9.png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-30 16:46:07',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-30 16:46:07',
        //   remark: null,
        //   params: {},
        //   id: '1641361147426787330',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://dev.linkwechat.net/fileUpload/a087f787-5efc-4bce-8980-66e3abc221d4.png',
        //   materialName: '111.png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-23 18:10:17',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-23 18:10:17',
        //   remark: null,
        //   params: {},
        //   id: '1638845612566822913',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://linkwechat.oss-cn-beijing.aliyuncs.com/2023-03-23/t1679566212238-ypDderONucE4Q0vR.jpg',
        //   materialName: '微信图片_20211011135610.jpg',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-14 11:20:57',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-14 11:20:57',
        //   remark: null,
        //   params: {},
        //   id: '1635481109598941185',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2023-03-14/t1678764052148-vGMUfd6TX9Vxr6vs.png',
        //   materialName: 'newred2.png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
        // {
        //   searchValue: null,
        //   createBy: 'admin',
        //   createById: '1',
        //   createTime: '2023-03-03 18:42:04',
        //   updateBy: 'admin',
        //   updateById: '1',
        //   updateTime: '2023-03-03 18:42:04',
        //   remark: null,
        //   params: {},
        //   id: '1631605855105368065',
        //   categoryId: '1',
        //   fileName: null,
        //   moduleType: 1,
        //   materialUrl:
        //     'https://link-wechat-1251309172.cos.ap-nanjing.myqcloud.com/2023-03-03/t1677840116282-sESFp4h9VUZoGFq3.png',
        //   materialName: '卡券 (1).png',
        //   content: null,
        //   digest: null,
        //   coverUrl: null,
        //   audioTime: '0',
        //   backgroundImgUrl: null,
        //   type: null,
        //   width: null,
        //   height: null,
        //   mediaType: '0',
        //   otherField: null,
        //   materialStatus: 0,
        //   frontOrder: null,
        //   delFlag: 0,
        //   linkUrl: null,
        //   isCheck: false,
        //   posterSubassembly: null,
        //   posterQrType: null,
        //   weMaterialImgAoList: null,
        // },
      ],
    }
  },
  mounted() {
    this.firendId = this.$route.query.id
    this.firendType = this.$route.query.type
    // this.firendId = 1
    // this.firendType = 2
    if (this.firendId) {
      // 详情页面
      this.getDetail(this.firendId)
    } else {
      // 新增页面
      let form = {}
      form.scopeType = 0
      this.getNumMoments(form)
    }
  },
  methods: {
    scopeTypeChange(a) {
      if (a.target.value === '0') {
        this.addWeUser = {
          userIds: [],
          deptIds: [],
          posts: [],
          customerTag: [],
        }
      }
      if (['0', '1'].includes(a.target.value)) {
        let form = {
          scopeType: +a.target.value,
        }
        form = Object.assign(form, this.addWeUser)
        this.getNumMoments(form)
      }
    },
    // 获取页面详情
    getDetail(id) {
      getDetail(id)
        .then((res) => {
          console.log(231, res)
        })
        .catch()
    },
    // 获取可见客户数
    getNumMoments(data) {
      numMoments(data)
        .then((res) => {
          if (res.code === 200) {
            this.form.customerNum = res.data
          }
        })
        .catch()
    },
    getExecuteData(data) {
      let form = data
      form.scopeType = 1
      this.getNumMoments(form)
      this.addWeUser = data
    },
    selectedFn() {
      this.dialogVisibleSelectTag = true
    },
    selectedFn2() {
      this.dialogVisibleSelectTag2 = true
    },
    submitSelectTag(data) {
      this.form.likeTagIds = []
      data.forEach((el) => {
        this.form.likeTagIds.push(el.tagId)
      })
      this.likeTagList = data
    },
    submitSelectTag2(data) {
      this.form.commentTagIds = []
      data.forEach((el) => {
        this.form.commentTagIds.push(el.tagId)
      })
      this.commentTagList = data
    },
    // onSelectUser() {
    //   this.dialogVisibleSelectUser = true
    // },
    // selectedUser(users) {
    //   this.selectedUserList = users
    // },
    onInsertMaterial(e) {
      this.form.contentType = e
      this.form.otherContent.push({
        annexType: e,
        annexUrl: '',
        contentError: '',
      })
    },
    onRemoveMaterial(index) {
      this.form.otherContent.splice(index, 1)
      if (!this.form.otherContent.length) {
        this.form.contentType = ''
      }
    },
    // 上一步
    onBackStep() {
      this.$router.go(-1)
    },

    submit(data) {
      this.$refs['ruleForm'].validate((valid) => {
        if (valid) {
          if (this.form.scopeType === 1) {
            if (
              this.addWeUser.userIds.length ||
              this.addWeUser.posts.length ||
              this.addWeUser.deptIds.length ||
              this.addWeUser.customerTag.length
            ) {
              this.form = Object.assign(this.form, this.addWeUser)
            } else {
              this.msgError('请选择按条件筛选时的发送范围！')
              return false
            }
          }
          this.form.materialIds = []
          data.attachments.forEach((item) => {
            this.form.materialIds.push(item.materialId)
          })
          this.form.content = data.templateInfo
          // if (data.attachments.length !== 0) {
          //   this.form.contentType = 'link'
          //   this.form.realType = data.attachments[0].realType
          //   this.form.materialId = data.attachments[0].materialId
          //   this.dealType(data.attachments[0])
          // } else {
          //   this.form.otherContent = []
          //   this.form.contentType = 'text'
          // }
          // // if (this.$refs.friendCircleContent.validate()) {
          // if (this.form.scopeType === 0) {
          //   this.form.customerTag = this.selectedTagList
          //     .map((dd) => {
          //       return dd.tagId
          //     })
          //     .join(',')
          //   this.form.noAddUser = this.selectedUserList
          //     .map((dd) => {
          //       return dd.userId
          //     })
          //     .join(',')
          // }
          if (this.form.executeTime) {
            let time = this.form.executeTime.getTime()
            let time2 = Date.now()
            if (time2 > time) {
              this.msgError('执行时间不可早于当前日期！')
              return false
            }
            this.form.executeTime = moment(this.form.executeTime).format('YYYY-MM-DD HH:mm')
          } else {
            this.form.executeTime = ''
          }
          this.form.executeEndTime = moment(this.form.executeEndTime).format('YYYY-MM-DD HH:mm')
          console.log(304, this.form)
          addMoments(this.form).then((res) => {
            if (res.code === 200) {
              this.msgSuccess('操作成功')
              this.$router.go(-1)
            }
          })
          // }
        } else {
          return false
        }
      })
    },
    filPicType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return window.lwConfig.DEFAULT_H5_PDF
      } else if (['doc', 'docx'].includes(type)) {
        return window.lwConfig.DEFAULT_H5_WORDE
      } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
        return window.lwConfig.DEFAULT_H5_PPT
      } else {
        return ''
      }
    },
    // dealType(data) {
    //   this.form.otherContent = []
    //   let arr = {}
    //   let linkUrl =
    //     window.document.location.origin + '/mobile/#/metrialDetail?materiaId=' + data.materialId
    //   switch (data.realType) {
    //     case 0:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: data.picUrl,
    //         other: data.picUrl,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 2:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.picUrl,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 3:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: this.filPicType(data.fileUrl),
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 4:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.content,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 5:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.fileUrl,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 9:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: data.linkUrl,
    //         other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_TP,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //     case 12:
    //       arr = {
    //         annexType: 'link',
    //         annexUrl: linkUrl,
    //         other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_ART,
    //         title: data.title,
    //       }
    //       this.form.otherContent.push(arr)
    //       break
    //   }
    // },
  },
}
</script>

<style lang="scss" scoped>
.firend-box {
  width: 460px;
  min-height: 100px;
  border: 1px solid #dfe4ed;
  padding: 12px;
}
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 34px;
}
.customer-num {
  span {
    font-size: 12px;
    line-height: 30px;
  }
  span:nth-child(1) {
    color: #aaa;
  }
  span:nth-child(2) {
    color: #07c160;
  }
}
.question {
  display: inline-block;
  width: 16px;
  // overflow: hidden;
  .question-content {
    width: 14px;
    height: 14px;
    border-radius: 16px;
    background-color: #888;
    color: #fff;
    font-size: 12px;
    text-align: center;
    line-height: 14px;
  }
}
</style>
