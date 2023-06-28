<template>
  <div class="boot-guide">
    <div class="top">
      <span class="title">
        还差最后一步：设置应用侧边栏。即可完成基础权限配置，使用{{ lwConfig.SYSTEM_NAME }}系统功能啦~
      </span>
      <el-steps class="g-card" style="margin-top: 10px" :active="currentActive" align-center finish-status="success">
        <el-step title="应用:客户画像"></el-step>
        <el-step title="应用:聊天素材"></el-step>
        <el-step title="应用:关键词群"></el-step>
        <el-step title="应用:红包"></el-step>
      </el-steps>
    </div>
    <div class="content-box">
      <div v-for="(list, i) in stepDataList" :key="i" class="content">
        <div v-show="currentActive === i" class="tab">
          <div v-for="(item, index) in list.boxData" :key="index">
            <div class="title-one">
              <span class="left">{{ index + 1 }}、</span>
              <div class="right">
                {{ item.title }}
              </div>
            </div>
            <div class="box">
              <img :src="item.url" alt="" />
            </div>
          </div>
          <div class="title-one">
            <span class="left">{{ list.boxDataTwo.step }}、</span>
            <div class="right">
              <div class="right-text">
                {{ list.boxDataTwo.title1 }}
              </div>
              <div class="right-text">
                输入页面名称：{{ list.boxDataTwo.title2 }}
                <el-button type="primary" @click="handleCopy(list.boxDataTwo.title2)">复制名称</el-button>
              </div>
              <div class="right-text">{{ list.boxDataTwo.title3 }}</div>
              <div class="right-text">
                {{ list.boxDataTwo.title4 }}
                <el-button type="primary" @click="handleCopy(list.boxDataTwo.title4)">复制链接</el-button>
              </div>
            </div>
          </div>
          <div class="box">
            <img :src="list.boxDataTwo.url" alt="" />
          </div>
          <div class="bottom">
            <div class="bottom-content">
              <el-button type="primary" @click="back()" v-if="currentActive > 0">{{ list.buttonData.one }}</el-button>
              <el-button type="primary" @click="next()" v-if="currentActive < 4">{{ list.buttonData.two }}</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { getToken } from '@/utils/auth'
import { noviceGuideInfo } from '@/api/login.js'
export default {
  name: 'customer-service-manage-add',
  data() {
    return {
      currentActive: 0,

      stepDataList: [
        {
          boxData: [
            {
              title: `管理员账号登录企业微信管理后台——进入【应用管理】——点击【${lwConfig.SYSTEM_NAME_MOBILE}】`,
              url: '@/assets/register/guid/customer-portrait-one.png',
            },
            {
              title: `在【${lwConfig.SYSTEM_NAME_MOBILE}】应用内找到“配置到聊天工具栏”功能中的“配置”按钮`,
              url: '@/assets/register/guid/customer-portrait-two.png',
            },
            {
              title: '进入“配置到聊天工具栏”功能页后点击“配置页面”按钮配置路径',
              url: '@/assets/register/guid/customer-portrait-three.png',
            },
          ],
          boxDataTwo: {
            step: 4,
            title1: '配置【客户画像】功能页，请按照以下信息进行填写',
            title2: '客户画像',
            title3: '输入页面内容：选择“自定义”，内容链接为：',
            title4: 'https://×××××××',
            url: '@/assets/register/guid/customer-portrait-four.png',
          },
          buttonData: {
            one: '返回上一步',
            two: '我已配置，进入下一步',
          },
        },
        {
          boxData: [
            {
              title: '在当前页面内点击“继续配置”按钮',
              url: '@/assets/register/guid/chat-material-five.png',
            },
          ],
          boxDataTwo: {
            step: 2,
            title1: '配置【聊天素材】功能页，请按照以下信息进行填写',
            title2: '聊天素材',
            title3: '输入页面内容：选择“自定义”，内容链接为：',
            title4: 'https://×××××××',
            url: '@/assets/register/guid/chat-material-six.png',
          },
          buttonData: {
            one: '返回上一步',
            two: '我已配置，进入下一步',
          },
        },
        {
          boxData: [
            {
              title: '在当前页面内点击“继续配置”按钮',
              url: '@/assets/register/guid/keyword-group-seven.png',
            },
          ],
          boxDataTwo: {
            step: 2,
            title1: '配置【关键词群】功能页，请按照以下信息进行填写',
            title2: '关键词群',
            title3: '输入页面内容：选择“自定义”，内容链接为：',
            title4: 'https://×××××××',
            url: '@/assets/register/guid/keyword-group-eight.png',
          },
          buttonData: {
            one: '返回上一步',
            two: '我已配置，进入下一步',
          },
        },
        {
          boxData: [
            {
              title: '在当前页面内点击“继续配置”按钮',
              url: '@/assets/register/guid/red-envelopes-nine.png',
            },
          ],
          boxDataTwo: {
            step: 2,
            title1: '配置【红包】功能页，请按照以下信息进行填写',
            title2: '红包',
            title3: '输入页面内容：选择“自定义”，内容链接为：',
            title4: 'https://×××××××',
            url: '@/assets/register/guid/red-envelopes-ten.png',
          },
          buttonData: {
            one: '返回上一步',
            two: '配置完成，进入系统',
          },
        },
      ],
    }
  },
  components: {},
  methods: {
    // 复制文本
    handleCopy(text) {
      const input = document.createElement('input')
      input.style.cssText = 'opacity: 0;'
      input.type = 'text'
      input.value = text // 修改文本框的内容
      document.body.appendChild(input)
      input.select() // 选中文本
      document.execCommand('copy') // 执行浏览器复制命令
      this.$message({ message: '复制成功', type: 'success' })
    },
    // 上一步
    back() {
      this.currentActive--
    },
    // 下一步
    next() {
      if (this.currentActive === 3) {
        this.$router.push({
          path: '/',
        })
      } else {
        this.currentActive++
      }
    },
  },
  mounted() {
    let token = getToken()
    noviceGuideInfo(token).then((res) => {
      this.stepDataList[0].boxDataTwo.title2 = res.data.customerPortraitName
      this.stepDataList[0].boxDataTwo.title4 = res.data.customerPortraitUrl
      this.stepDataList[1].boxDataTwo.title2 = res.data.materialName
      this.stepDataList[1].boxDataTwo.title4 = res.data.materialUrl
      this.stepDataList[2].boxDataTwo.title2 = res.data.wordGroupName
      this.stepDataList[2].boxDataTwo.title4 = res.data.wordGroupUrl
      this.stepDataList[3].boxDataTwo.title2 = res.data.redEnvelopesName
      this.stepDataList[3].boxDataTwo.title4 = res.data.redEnvelopesUrl
    })
  },
  created() {},
}
</script>
<style lang="scss" scoped>
svg.svg-icon {
  width: 30px;
  height: 30px;
}
.boot-guide {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.top {
  width: 80%;
  height: 146px;
  border-radius: 4px;
  background: var(--bg-white);
  padding-top: 20px;
  margin-top: 20px;
  margin-bottom: 10px;
  .title {
    margin-left: 120px;
    font-size: 16px;
  }
}
.content-box {
  width: 80%;
  padding: 20px;
  background: var(--bg-white);
  padding-bottom: 60px;
}
.content {
  //   width: 80%;
}
.tab {
  background: var(--bg-white);
  border-top: 1px solid var(--border-black-10);
  border-bottom-left-radius: 4px;
  border-bottom-right-radius: 4px;
  //   margin-top: 10px;
  //   padding: 20px;
  overflow: auto;
  height: calc(100vh - 340px);
  .title-one {
    width: 100%;
    line-height: 40px;
    padding-left: 20px;
    background-color: var(--color-light-10);
    margin-bottom: 20px;
    border-radius: 4px;
    font-size: 16px;
    display: flex;
    .left {
      color: var(--color);
      font-weight: 600;
    }
    .right {
      .el-button {
        margin-left: 10px;
      }
    }
  }
  .box {
    width: 100%;
    // margin-bottom: 20px;
    img {
      width: 100%;
    }
  }
  .bottom {
    .bottom-content {
      position: fixed;
      bottom: 40px;
      left: 60%;
    }
  }
}
</style>
