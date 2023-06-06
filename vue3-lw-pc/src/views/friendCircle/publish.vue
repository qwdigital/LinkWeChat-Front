<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form label-width="110px" label-position="right">
          <div class="g-card">
            <el-form-item label="可见客户" required>
              <el-radio-group v-model="form.scopeType">
                <el-radio :label="1">全部客户</el-radio>
                <el-radio :label="0">按条件筛选</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="选择客户标签" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedTagList" :key="key">{{
                unit.name
              }}</el-tag>
              <div>
                <el-button type="primary" plain @click="selectedFn">选择标签</el-button>
              </div>
            </el-form-item>
            <!-- <el-form-item label="添加人" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedUserList" :key="key">{{ unit.name }}</el-tag>
              <div>
                <el-button type="primary" plain @click="onSelectUser">选择添加人</el-button>
              </div>
            </el-form-item> -->
          </div>
          <!-- <FriendCircleContent ref="friendCircleContent" :data="form"></FriendCircleContent> -->
          <AddMaterial
            :moduleType="4"
            @update="onBackStep"
            @submit="submit"
            :otherType="3"
            :showPhone="false"
          ></AddMaterial>

          <div class="g-card">
            <el-form-item label="执行时间：">
              <div class="tips">
                可自由设定该朋友圈任务下发通知的开始时间，如未设置则默认创建时间即开始执行时间
              </div>
              <el-date-picker
                v-model="form.time1"
                type="datetime"
                placeholder="选择年月日时分"
                format="YYYY-MM-DD hh-mm"
              >
              </el-date-picker>
            </el-form-item>
            <el-form-item label="结束时间：" required>
              <div class="tips">
                朋友圈任务可设置截止时间，则未完成的成员不允许再执行本条任务
              </div>
              <el-date-picker
                v-model="form.time2"
                type="datetime"
                placeholder="选择年月日时分"
                format="YYYY-MM-DD hh-mm"
              >
              </el-date-picker>
            </el-form-item>
            <el-form-item label="自动标签：" >
              <div class="tips">
                可根据客户的点赞或评论行为分别打上对应标签
              </div>
            </el-form-item>
          </div>
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
      :defaultValues="selectedTagList"
      @success="submitSelectTag"
    ></SelectTag>
    <SelectUser
      :defaultValues="selectedUserList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"
    ></SelectUser>
  </div>
</template>

<script>
import { gotoPublish } from '@/api/circle'
import AddMaterial from '@/components/ContentCenter/AddMaterial'

export default {
  name: 'publish-detail',
  components: {
    AddMaterial,
    SelectTag: defineAsyncComponent(() => import('@/components/SelectTag')),
    FriendCircleContent: defineAsyncComponent(() => import('@/components/FriendCircleContent')),
  },
  data() {
    return {
      form: {
        scopeType: 1, //可见类型:0:部分可见;1:公开;
        customerTag: '', //客户标签，多个使用逗号隔开
        noAddUser: '', //发送员工，使用逗号隔开
        content: '', //文本框内容
        otherContent: [],
        contentType: '', //图片:image 视频:video 图文链接:link
      },
      // 遮罩层
      loading: false,
      selectedUserList: [],
      dialogVisibleSelectUser: false,
      dialogVisibleSelectTag: false,
      selectedTagList: [],
    }
  },
  mounted() {},
  methods: {
    selectedFn() {
      this.dialogVisibleSelectTag = true
    },
    submitSelectTag(data) {
      console.log(data)
      this.selectedTagList = data
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    selectedUser(users) {
      this.selectedUserList = users
    },
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
      console.log(data)
      this.form.content = data.templateInfo
      if (data.attachments.length !== 0) {
        this.form.contentType = 'link'
        this.form.realType = data.attachments[0].realType
        this.form.materialId = data.attachments[0].materialId
        this.dealType(data.attachments[0])
      } else {
        this.form.otherContent = []
        this.form.contentType = 'text'
      }
      // if (this.$refs.friendCircleContent.validate()) {
      if (this.form.scopeType === 0) {
        this.form.customerTag = this.selectedTagList
          .map((dd) => {
            return dd.tagId
          })
          .join(',')
        this.form.noAddUser = this.selectedUserList
          .map((dd) => {
            return dd.userId
          })
          .join(',')
      }
      gotoPublish(this.form).then((res) => {
        if (res.code === 200) {
          this.msgSuccess('操作成功')
          this.$router.go(-1)
        }
      })
      // }
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
    dealType(data) {
      this.form.otherContent = []
      let arr = {}
      let linkUrl =
        window.document.location.origin + '/mobile/#/metrialDetail?materiaId=' + data.materialId
      switch (data.realType) {
        case 0:
          arr = {
            annexType: 'link',
            annexUrl: data.picUrl,
            other: data.picUrl,
          }
          this.form.otherContent.push(arr)
          break
        case 2:
          arr = {
            annexType: 'link',
            annexUrl: linkUrl,
            other: data.picUrl,
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
        case 3:
          arr = {
            annexType: 'link',
            annexUrl: linkUrl,
            other: this.filPicType(data.fileUrl),
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
        case 4:
          arr = {
            annexType: 'link',
            annexUrl: linkUrl,
            other: data.content,
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
        case 5:
          arr = {
            annexType: 'link',
            annexUrl: linkUrl,
            other: data.fileUrl,
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
        case 9:
          arr = {
            annexType: 'link',
            annexUrl: data.linkUrl,
            other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_TP,
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
        case 12:
          arr = {
            annexType: 'link',
            annexUrl: linkUrl,
            other: data.picUrl ? data.picUrl : window.lwConfig.DEFAULT_H5_ART,
            title: data.title,
          }
          this.form.otherContent.push(arr)
          break
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.tips {
  color: #aaa;
  font-size: 12px;
  line-height: 34px;
}
</style>
