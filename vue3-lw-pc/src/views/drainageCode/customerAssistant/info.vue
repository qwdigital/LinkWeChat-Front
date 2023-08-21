<template>
  <div>
    <div style="margin-top: var(--card-margin);">
      <div class="flex">
        <div style="width: calc(100% - 425px); padding-right: var(--card-margin);">
          <el-form :model="form" :rules="rules" ref="form" label-width="140px">
            <div class="g-card">
              <div style="display: flex; justify-content: space-between;">
                <div class="card-title">
                  基础信息
                </div>
                <div>
                  <el-button
                    type="primary"
                    @click="
                      $router.push({
                        path: 'add',
                        query: {
                          id: id
                        }
                      })
                    "
                  >
                    编辑
                  </el-button>
                  <el-button type="primary" @click="getData()">
                    同步数据
                  </el-button>
                </div>
              </div>

              <el-row>
                <el-col :sm="24" :md="18">
                  <el-form-item label="链接名称:" prop="linkName">
                    <span>{{ form.linkName }}</span>
                  </el-form-item>
                  <el-form-item label="自动通过好友:">
                    <el-switch v-model="form.skipVerify" disabled :active-value="1" :inactive-value="0"></el-switch>
                  </el-form-item>
                  <el-form-item label="新客户标签:">
                    <template v-for="(item, index) in tagList">
                      <el-tag v-if="item.name" :key="index">{{ item.name }}</el-tag>
                    </template>
                  </el-form-item>
                  <el-form-item label="链接员工:" prop="weUserList">
                    <div v-if="userList.length > 0">
                      <el-tag v-for="(item, index) in userList" :key="index">
                        {{ item.name }}
                      </el-tag>
                    </div>
                  </el-form-item>
                </el-col>
              </el-row>
            </div>
            <div class="g-card">
              <div class="card-title">
                链接信息
              </div>
              <el-row>
                <el-col :sm="24" :md="18">
                  <div class="page">
                    <div class="code-wrapper">
                      <el-form label-width="140px" style="display: inline-block;">
                        <el-form-item label="获客链接:">
                          <div style="text-align: left;">
                            {{ form.linkUrl }}
                            <el-button text @click="copyFn(form.linkUrl)">复制</el-button>
                          </div>
                          <div class="sub-des">企微官方的获客长链接，可直接使用</div>
                        </el-form-item>
                        <el-form-item label="获客短链:">
                          <div style="text-align: left;">
                            {{ form.linkShortUrl }}
                            <el-button text @click="copyFn(form.linkShortUrl)">复制</el-button>
                          </div>
                          <div class="sub-des">系统生成的获客短链，满足短链场景</div>
                        </el-form-item>
                      </el-form>
                    </div>
                  </div>
                </el-col>
              </el-row>
            </div>
          </el-form>
        </div>
        <div class="g-card" style="width: 425px; margin-top: 0;">
          <div class="card-title">欢迎语预览</div>
          <PreviewInPhone :list="previewData" :templateInfo="templateInfo"></PreviewInPhone>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import { detail, syncData } from './api.js'
  import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
  export default {
    components: {
      PreviewInPhone
    },
    data() {
      return {
        id: '',
        tagList: [],
        userList: [],
        form: {
          linkName: '',
          tagIds: '',
          tagNames: '',
          skipVerify: 1,
          attachments: [],
          weUserList: '',
          weUserNames: ''
        },
        templateInfo: '',
        attachmentsData: {
          templateInfo: '',
          attachments: []
        },
        previewData: []
      }
    },
    created() {
      if (this.$route.query.id) {
        this.id = this.$route.query.id
        this.getDetail()
      }
    },
    methods: {
      getData() {
        syncData(this.id).then((res) => {
          if (res.code == 200) {
            this.msgSuccess('操作成功')
          }
        })
      },
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
                  tagId: dd
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
                  weUserId: dd
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
                attachments: data
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
                materialUrl: dd.picUrl
              }
              arr.push(obj)
            } else if (dd.msgType === 'video') {
              let obj = {
                id: dd.materialId,
                mediaType: '2',
                materialUrl: dd.fileUrl,
                coverUrl: dd.picUrl,
                digest: dd.description,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'file') {
              let obj = {
                id: dd.materialId,
                mediaType: '3',
                materialUrl: dd.fileUrl,
                digest: dd.description,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'text') {
              let obj = {
                id: dd.materialId,
                mediaType: '4',
                content: dd.content
              }
              arr.push(obj)
            } else if (dd.msgType === 'link') {
              let obj = {
                id: dd.materialId,
                mediaType: '9',
                content: dd.content,
                coverUrl: dd.picUrl,
                materialUrl: dd.linkUrl,
                materialName: dd.title
              }
              arr.push(obj)
            } else if (dd.msgType === 'miniprogram') {
              let ff = {
                id: dd.materialId,
                mediaType: '11',
                digest: dd.appId,
                materialName: dd.title,
                coverUrl: dd.picUrl,
                materialUrl: dd.fileUrl
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
                materialName: dd.title
              }
              arr.push(ff)
            } else if (dd.msgType === 'posters') {
              let obj = {
                id: dd.materialId,
                mediaType: '5',
                materialUrl: dd.fileUrl,
                materialName: dd.title
              }
              arr.push(obj)
            }
          })
        }
        return arr
      }
    }
  }
</script>
<style lang="scss" scoped>
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
  }
  .code-wrapper {
    // text-align: center;

    .code-success,
    .code-text,
    .code-actions {
      padding: 20px 0;
    }
  }
</style>
