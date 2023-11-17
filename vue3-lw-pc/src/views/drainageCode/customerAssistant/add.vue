<template>
  <div>
    <div class="g-card">
      <el-steps :active="active" align-center finish-status="success">
        <el-step title="链接配置"></el-step>
        <el-step title="生成链接"></el-step>
      </el-steps>
    </div>
    <div style="margin-top: var(--card-margin)">
      <template v-if="active == 0">
        <div class="flex">
          <div style="width: calc(100% - 425px); padding-right: var(--card-margin)">
            <el-form :model="form" :rules="rules" ref="form" label-width="140px">
              <div class="g-card">
                <div class="card-title">基础信息</div>
                <el-row>
                  <el-col :sm="24" :md="18">
                    <el-form-item label="链接名称" prop="linkName">
                      <el-input
                        v-model="form.linkName"
                        placeholder="请输入链接名称"
                        show-word-limit
                        maxlength="15"></el-input>
                    </el-form-item>
                    <el-form-item label="自动通过好友">
                      <el-switch v-model="form.skipVerify" :active-value="1" :inactive-value="0"></el-switch>
                      <div class="sub-des">开启后，客户添加该企业微信时，无需好友验证，将会自动添加成功</div>
                    </el-form-item>
                    <el-form-item label="新客户标签">
                      <div class="sub-des">添加成功后，该客户将会自动设置以上选择标签</div>
                      <template v-for="(item, index) in tagList">
                        <el-tag v-if="item.name" :key="index">{{ item.name }}</el-tag>
                      </template>
                      <div>
                        <el-button type="primary" icon="el-icon-plus" @click="showSelectTag = true">
                          {{ tagList.length ? '编辑' : '添加' }}标签
                        </el-button>
                      </div>
                    </el-form-item>
                    <el-form-item label="链接员工" prop="weUserList">
                      <div class="sub-des">最多选择100名成员，平均分配</div>
                      <div v-if="userList.length > 0">
                        <el-tag v-for="(item, index) in userList" :key="index">
                          {{ item.name }}
                        </el-tag>
                      </div>
                      <el-button type="primary" icon="el-icon-plus" @click="onSelectUser">
                        {{ userList.length ? '修改' : '选择' }}链接员工
                      </el-button>
                    </el-form-item>
                  </el-col>
                </el-row>
              </div>
              <div class="g-card">
                <div class="card-title">欢迎语配置</div>
                <el-row>
                  <el-col :sm="24" :md="18">
                    <IdentityAttachment
                      @phoneData="getPhoneData"
                      @success="getAttentment"
                      @changeInfo="changeInfo"
                      :baseData="attachmentsData"></IdentityAttachment>
                  </el-col>
                </el-row>
              </div>
            </el-form>
          </div>
          <div class="g-card" style="width: 425px; margin-top: 0">
            <div class="card-title">欢迎语预览</div>
            <PreviewInPhone :list="previewData" :templateInfo="templateInfo"></PreviewInPhone>
          </div>
        </div>
      </template>
      <template v-else>
        <div class="g-card">
          <div class="code-wrapper">
            <div class="code-success">
              <!-- <el-button type="success" icon="el-icon-check" circle></el-button> -->
              <div class="check"><el-icon-Check class="el-icon-check"></el-icon-Check></div>
            </div>
            <div class="code-text">获客链接创建成功，支持复制链接即可使用</div>
            <el-form label-width="140px" style="display: inline-block">
              <el-form-item label="获客链接:">
                <div style="text-align: left">
                  {{ detail.linkUrl }}
                  <el-button text @click="copyFn(detail.linkUrl)">复制</el-button>
                </div>
                <div class="sub-des">企微官方的获客长链接，可直接使用</div>
              </el-form-item>
              <el-form-item label="获客短链:">
                <div style="text-align: left">
                  {{ detail.linkShortUrl }}
                  <el-button text @click="copyFn(detail.linkShortUrl)">复制</el-button>
                </div>
                <div class="sub-des">系统生成的获客短链，满足短链场景</div>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </template>
    </div>
    <div class="g-card ac g-footer-sticky">
      <template v-if="active === 0">
        <el-button @click="$router.back()">取消</el-button>
        <el-button type="primary" v-loading="loading" :disabled="loading" @click="submit">确定</el-button>
      </template>
      <template v-else>
        <el-button type="primary" @click="$router.back()">完成</el-button>
      </template>
    </div>
    <SelectTag v-model:visible="showSelectTag" type="1" :selected="tagList" @success="getSelectTag"></SelectTag>
    <SelectUser
      :defaultValues="userList"
      v-model:visible="dialogVisibleSelectUser"
      title="选择员工"
      :isOnlyLeaf="true"
      @success="selectedUser"></SelectUser>
  </div>
</template>
<script>
import { addItem, detail, editItem } from './api.js'
import IdentityAttachment from '../components/IdentityAttachment.vue'
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'

export default {
  components: {
    IdentityAttachment,
    PreviewInPhone,
  },
  data() {
    return {
      id: '',
      active: 0,
      loading: false,
      tagList: [],
      userList: [],
      showSelectTag: false,
      dialogVisibleSelectUser: false,
      form: {
        linkName: '',
        tagIds: '',
        tagNames: '',
        skipVerify: 1,
        attachments: [],
        weUserList: '',
        weUserNames: '',
      },
      templateInfo: '',
      attachmentsData: {
        templateInfo: '',
        attachments: [],
      },
      previewData: [],
      rules: {
        linkName: [{ required: true, message: '请输入链接名称', trigger: 'blur' }],
        weUserList: [{ required: true, message: '请选择链接员工', trigger: 'blur' }],
      },
      detail: {
        linkUrl: '',
        linkShortUrl: '',
      },
    }
  },
  created() {
    if (this.$route.query.id) {
      this.id = this.$route.query.id
      this.getDetail()
    }
  },
  methods: {
    copyFn(text) {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this.$message({ message: '复制成功', type: 'success' })
    },
    submit() {
      this.$refs['form'].validate((validate) => {
        if (validate) {
          if (!this.templateInfo) {
            this.msgError('欢迎语不能为空！')
            return
          }
          this.loading = true
          if (this.form.attachments == null) {
            this.form.attachments = []
          }
          this.form.attachments.unshift({
            content: this.templateInfo,
            msgType: 'text',
          })
          if (this.id) {
            editItem(this.form)
              .then((res) => {
                if (res.code == 200) {
                  this.msgSuccess('操作成功')
                  this.detail = res.data
                  this.active = 1
                }
                this.loading = false
              })
              .catch(() => {
                this.loading = false
              })
          } else {
            addItem(this.form)
              .then((res) => {
                if (res.code == 200) {
                  this.msgSuccess('操作成功')
                  this.detail = res.data
                  this.active = 1
                }
                this.loading = false
              })
              .catch(() => {
                this.loading = false
              })
          }
        }
      })
    },
    nextFn(id) {
      this.active = 1
      detail(id).then((res) => {
        if (res.code == 200) {
          this.detail = res.data
        }
      })
    },
    onSelectUser() {
      this.dialogVisibleSelectUser = true
    },
    selectedUser(data) {
      if (data.length > 100) {
        this.msgError('最多选择100名成员')
        return
      }
      this.userList = data
      this.form.weUserList = data.map((dd) => dd.weUserId).join(',')
      this.form.weUserNames = data.map((dd) => dd.name).join(',')
    },
    getSelectTag(list) {
      this.tagList = list
      this.form.tagIds = list.map((dd) => dd.tagId).join(',')
      this.form.tagNames = list.map((dd) => dd.name).join(',')
    },
    changeInfo(data) {
      this.templateInfo = data
    },
    getAttentment(data) {
      this.form.attachments = data
    },
    getPhoneData(data) {
      this.previewData = data
    },
    getDetail() {
      detail(this.id).then((res) => {
        if (res.code == 200) {
          this.form = res.data
          if (this.form.tagIds) {
            let id = this.form.tagIds.split(',')
            let name = this.form.tagNames.split(',')
            let arr = []
            id.forEach((dd, index) => {
              arr.push({
                name: name[index],
                tagId: dd,
              })
            })
            this.tagList = arr
          }
          if (this.form.weUserList) {
            let id = this.form.weUserList.split(',')
            let name = this.form.weUserNames.split(',')
            let arr = []
            id.forEach((dd, index) => {
              arr.push({
                name: name[index],
                weUserId: dd,
              })
            })
            this.userList = arr
          }
          if (this.form.linkAttachments) {
            let arr = []
            this.form.linkAttachments.forEach((dd) => {
              if (dd.msgType == 'text') {
                this.templateInfo = dd.content
              } else {
                arr.push(dd)
              }
            })
            let data = this.setAttachments(arr)
            ;(this.attachmentsData = {
              templateInfo: this.templateInfo,
              attachments: data,
            }),
              (this.previewData = data)
          }
        }
      })
    },
    setAttachments(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              id: dd.materialId,
              mediaType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'video') {
            let obj = {
              id: dd.materialId,
              mediaType: '2',
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'file') {
            let obj = {
              id: dd.materialId,
              mediaType: '3',
              materialUrl: dd.fileUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'text') {
            let obj = {
              id: dd.materialId,
              mediaType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let obj = {
              id: dd.materialId,
              mediaType: '9',
              content: dd.content,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              id: dd.materialId,
              mediaType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.fileUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'news') {
            let ff = {
              id: dd.materialId,
              mediaType: '12',
              digest: dd.description,
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              content: dd.content,
              materialName: dd.title,
            }
            arr.push(ff)
          } else if (dd.msgType === 'posters') {
            let obj = {
              id: dd.materialId,
              mediaType: '5',
              materialUrl: dd.fileUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          }
        })
      }
      return arr
    },
  },
}
</script>
<style lang="scss" scoped>
.check {
  height: 40px;
  width: 40px;
  background-color: var(--color);
  color: #fff;
  border-radius: 50%;
  font-size: 20px;
  line-height: 40px;
  margin: 0 auto;
}
.card-title {
  font-size: 16px;
  font-weight: 500;
  color: var(--font-black);
  margin-bottom: 20px;
}
.sub-des {
  font-size: 12px;
  font-weight: 400;
  color: var(--font-black-6);
  text-align: left;
}
.code-wrapper {
  text-align: center;

  .code-success,
  .code-text,
  .code-actions {
    padding: 20px 0;
  }
}
</style>
