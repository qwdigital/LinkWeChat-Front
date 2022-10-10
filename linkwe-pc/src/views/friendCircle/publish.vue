<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top: 10px">
      <el-col>
        <el-form label-width="110px" label-position="right">
          <div class="g-card g-pad20">
            <el-form-item label="可见客户" required>
              <el-radio-group v-model="form.scopeType">
                <el-radio :label="1">全部可见</el-radio>
                <el-radio :label="0">部分可见</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="客户标签" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedTagList" :key="key">{{
                unit.name
              }}</el-tag>
              <div>
                <el-button type="primary" size="mini" plain @click="selectedFn"
                  >选择客户标签</el-button
                >
              </div>
            </el-form-item>
            <el-form-item label="添加人" v-if="form.scopeType === 0">
              <el-tag sizi="mini" v-for="(unit, key) in selectedUserList" :key="key">{{
                unit.name
              }}</el-tag>
              <div>
                <el-button type="primary" size="mini" plain @click="onSelectUser"
                  >选择添加人</el-button
                >
              </div>
            </el-form-item>
          </div>
          <FriendCircleContent ref="friendCircleContent" :data="form"></FriendCircleContent>
          <el-form-item label-width="0" style="margin-top: 20px; margin-bottom: 0">
            <el-button @click="onBackStep">取消</el-button>
            <el-button type="primary" @click="submit">保存</el-button>
          </el-form-item>
        </el-form>
      </el-col>
    </el-row>
    <!-- 选择标签弹窗 -->
    <SelectTag
      :visible.sync="dialogVisibleSelectTag"
      :defaultValues="selectedTagList"
      @success="submitSelectTag"
    >
    </SelectTag>
    <SelectUser
      :defaultValues="selectedUserList"
      :visible.sync="dialogVisibleSelectUser"
      title="选择使用员工"
      @success="selectedUser"
    ></SelectUser>
  </div>
</template>

<script>
import { gotoPublish } from '@/api/circle'

export default {
  name: 'publish-detail',
  components: {
    SelectTag: () => import('@/components/SelectTag'),
    FriendCircleContent: () => import('@/components/FriendCircleContent'),
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

    submit() {
      if (this.$refs.friendCircleContent.validate()) {
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
      }
    },
  },
}
</script>

<style lang="scss" scoped></style>
