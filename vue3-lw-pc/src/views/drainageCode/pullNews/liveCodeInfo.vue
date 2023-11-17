<template>
  <div>
    <el-row type="flex" justify="space-between">
      <el-col :span="16" class="boxClass left radius">
        <div class="g-card" style="min-height: 1040px">
          <div class="card-title">
            <span>活码信息</span>
            <el-button type="primary" @click="goRouter">编辑</el-button>
          </div>
          <div class="card-content">
            <el-row>
              <el-col :sm="24" :md="16" :lg="14">
                <el-form :model="form" ref="form" label-width="140px">
                  <el-row>
                    <el-col :sm="24" :md="18">
                      <el-form-item label="活码名称:" class="pb20">
                        <el-input
                          v-model="form.name"
                          placeholder="请输入名称"
                          show-word-limit
                          maxlength="15"
                          :disabled="true"></el-input>
                      </el-form-item>
                      <el-form-item label="拉新方式:" class="pb20">
                        <div class="function">
                          <div class="function-item active-item">
                            <!-- {{functionList[form.type - 1].svg}} -->
                            <!-- <svg-icon
                              class="icon-style"
                              :icon="functionList[form.type - 1].svg"
                            ></svg-icon> -->
                            <svg-icon class="icon-style" icon="redBox"></svg-icon>
                            <div>
                              <span>{{ functionList[0].name }}</span>
                              <div class="item-text">{{ functionList[0].content }}</div>
                            </div>
                          </div>
                        </div>
                      </el-form-item>

                      <el-form-item label="添加员工:" prop="chatIdList" class="pb20">
                        <template v-for="(item, index) in dealInfo(form.qrUserInfos)" :key="index">
                          <el-tag v-if="item">
                            {{ item }}
                          </el-tag>
                        </template>
                      </el-form-item>
                      <el-form-item label="添加标签:" class="pb20">
                        <template v-for="(item, index) in dealTag(form.qrTags)" :key="index">
                          <el-tag v-if="item">{{ item }}</el-tag>
                        </template>
                      </el-form-item>
                      <div class="redForm">
                        <!-- table -->
                        <div class="redTitle">选择红包：</div>
                        <el-table :data="dealTable(form.businessData)" v-if="dealTable(form.businessData)" class="mr10">
                          <el-table-column width="300" label="红包" align="center" prop="name">
                            <template #default="{ row }">
                              <div class="red-packet-message">
                                <div class="red-packet-text">
                                  {{ row.name }}
                                </div>
                              </div>
                            </template>
                          </el-table-column>
                          <el-table-column label="红包金额(元)" align="center" prop="money" />
                        </el-table>
                      </div>
                    </el-col>
                  </el-row>
                </el-form>
              </el-col>
            </el-row>
            <!-- <SelectTag
               v-model:visible="showSelectTag"
              type="2"
              :defaultValues="tagList"
              @success="getSelectTag"
            ></SelectTag> -->
          </div>
        </div>
      </el-col>
      <el-col :span="8" style="margin-top: 0">
        <div class="g-card right-card-title">
          <span>活码预览</span>
          <div class="code-wrapper">
            <el-image :src="form.imageUrl" class="code-image" style="width: 160px; height: 200px"></el-image>
            <div class="code-actions">
              <!-- <a :href="form.imageUrl" :download="form.name + '.jpg'"> -->
              <el-button text @click="handleDownload(form.imageUrl, form.name)">下载二维码</el-button>
              <!-- </a> -->
              <el-button id="copyUrl" text :data-clipboard-text="form.linkPath">复制链接</el-button>
            </div>
          </div>
        </div>
        <div class="g-card right-card-title">
          <span>欢迎语预览</span>
          <PreviewInPhone
            :list="dealList(form.qrAttachments)"
            :templateInfo="templateInfo"
            :pullnewsInfo="{ qrType: 1, materialName: dealTable(form.businessData)[0].name }"
            name="新客户" />
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { download } from '@/api/drainageCode/group'
export default {
  components: {
    PreviewInPhone,
  },
  data() {
    return {
      showSelectTag: false,
      templateInfo: '', // 欢迎语
      talkList: [], // 欢迎语附件
      clipboard: null,
      functionList: [
        {
          svg: 'redBox',
          name: '红包拉新',
          content: '给新客户发送红包',
          active: true,
        },
        {
          svg: 'card',
          name: '卡券拉新',
          content: '给新客户发送微信卡券',
          active: false,
        },
      ],
      groupId: null,
      pullnewsInfo: {
        qrType: 1,
        materialName: '',
      },
    }
  },
  props: {
    form: {
      type: Object,
      default: {},
    },
  },
  mounted() {
    this.clipboard = new this.ClipboardJS('#copyUrl')
  },
  unmounted() {
    this.clipboard.destroy()
  },
  methods: {
    dealInfo(list) {
      let infoList = []
      if (list && list.length) {
        list.forEach((item) => {
          switch (item.scopeType) {
            case 1:
              infoList.push(item.userName)
              break
            case 2:
              infoList.push(item.partyName)
              break
            case 3:
              infoList.push(item.position)
              break
          }
        })
      }
      return infoList
    },
    dealTag(list) {
      let tagList = []
      if (list && list.length) {
        list.forEach((item) => {
          tagList.push(item.tagName)
        })
      }
      return tagList
    },
    dealTable(str) {
      let obj = ''
      if (str) {
        obj = JSON.parse(str)
      }

      let list = []
      list.push(obj)
      return list
    },
    dealList(list) {
      let delList = []
      if (list) {
        list.forEach((item) => {
          if (item.msgType === 'text') {
            this.templateInfo = item.content
          } else {
            delList.push(item)
          }
        })
        return this.setAttachments(delList)
      } else {
        return delList
      }
    },
    setAttachments(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              mediaType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'video') {
            let obj = {
              mediaType: '2',
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'file') {
            let obj = {
              mediaType: '3',
              materialUrl: dd.fileUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'text') {
            let obj = {
              mediaType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let obj = {
              mediaType: '9',
              content: dd.content,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              mediaType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.fileUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'news') {
            let ff = {
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
    goRouter() {
      this.$router.push('add?groupCodeId=' + this.$route.query.groupId)
    },
    handleDownload(url, name) {
      let image = new Image()
      image.setAttribute('crossOrigin', 'anonymous')
      image.src = url
      image.onload = () => {
        let canvas = document.createElement('canvas')
        canvas.width = image.width
        canvas.height = image.height
        let ctx = canvas.getContext('2d')
        ctx.drawImage(image, 0, 0, image.width, image.height)
        canvas.toBlob((blob) => {
          let url = URL.createObjectURL(blob)
          let Link = document.createElement('a')
          Link.download = name
          Link.href = url
          Link.click()
          Link.remove()
          // 用完释放URL对象
          URL.revokeObjectURL(url)
        })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.redForm {
  display: flex;
  width: 680px;
  .redTitle {
    text-align: right;
    width: 140px;
    line-height: 32px;
    color: var(--font-black-4);
    // margin-right: 12px;
  }
}
::v-deep {
  .el-input-number.is-without-controls .el-input__inner {
    text-align: left;
  }
}
.pb20 {
  padding-bottom: 30px !important;
}
.function {
  display: flex;
  width: 540px;
  justify-content: space-between;
  .function-item {
    width: 260px;
    height: 76px;
    border-width: 1px;
    border-style: solid;
    border-color: rgba(242, 242, 242, 1);
    border-radius: 5px;
    display: flex;
    padding: 10px;
    padding-top: 6px;
    cursor: pointer;
    .icon-style {
      margin-right: 10px;
      margin-top: 8px;
      font-size: 22px;
    }
    .item-text {
      font-size: 12px;
      color: var(--font-black-7);
      line-height: 24px;
    }
  }
  .active-item {
    border: 1px solid rgba(7, 193, 96, 1);
    background-color: rgba(7, 193, 96, 0.09019607843137255);
  }
}
.code-wrapper {
  text-align: center;
  .code-success,
  .code-text,
  .code-image {
    padding: 20px 0;
  }
}
.boxClass {
  padding: 0 var(--card-margin) 0 0;
  .card-title {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
    span {
      font-size: 16px;
      line-height: 30px;
    }
  }
  .card-content {
    margin-top: 40px;
  }
}
.right-card-title {
  margin-bottom: 20px;
  span {
    font-size: 16px;
    line-height: 30px;
  }
}
.red-packet-message {
  display: inline-block;
  text-align: left;
  width: 175px;
  height: 75px;
  padding: 20px 10px 0 54px;
  color: var(--font-white, #fff);
  line-height: 1.15;
  font-size: 14px;
  font-weight: 500;
  background: url('../../../assets/image/newred1.png') 0 0/100% 100% no-repeat;
  .red-packet-text {
    width: 100%;
    height: 30px;
    overflow: hidden;
    white-space: nowrap; // 强制一行
    text-overflow: ellipsis; // 文字溢出显示省略号
  }
}
</style>
