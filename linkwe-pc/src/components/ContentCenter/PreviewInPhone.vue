<template>
  <div class="preview">
    <div class="title">{{ name }}</div>
    <div class="content">
      <!-- 欢迎语 -->
      <div class="item" v-if="templateInfo">
        <div class="avatar222"><img src="../../assets/drainageCode/header.png" /></div>
        <div class="msg">
          <div class="word">
            {{ templateInfo }}
            <div v-if="liveUrl" style="margin-top: 10px">
              <p>直播链接:</p>
              {{ liveUrl }}
            </div>
          </div>
        </div>
      </div>
      <div class="item" v-for="(data, key) in list" :key="key">
        <div class="avatar222"><img src="../../assets/drainageCode/header.png" /></div>
        <div class="msg" v-if="data.mediaType === '4'">
          <div class="word">
            <p style="white-space: pre-line">{{ data.content }}</p>
          </div>
        </div>
        <div class="msg" v-if="data.mediaType === '0'">
          <div class="image">
            <img :src="data.materialUrl" />
          </div>
        </div>
        <div class="msg" v-if="data.mediaType === '9'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                {{ data.content }}
              </div>
              <div>
                <img :src="data.coverUrl" v-if="data.coverUrl && data.coverUrl != ''" />
                <svg-icon class="icon-style" iconClass="imgText" v-else></svg-icon>
              </div>
            </div>
          </div>
        </div>
        <div class="msg" v-if="data.mediaType === '11'">
          <div class="miniprogram">
            <div class="mini-header">
              <img src="../../assets/drainageCode/miniprogram-icon.png" alt="" />
              {{ data.materialName }}
            </div>
            <img class="mini-img" :src="data.coverUrl" />
            <div class="mini-footer">
              <img src="../../assets/drainageCode/miniprogram-link.png" />
              小程序
            </div>
          </div>
        </div>
        <!-- 文章 -->
        <div class="msg" v-if="data.mediaType === '12'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                {{ data.digest }}
              </div>
              <div>
                <img :src="data.coverUrl" v-if="data.coverUrl && data.coverUrl != ''" />
                <svg-icon class="icon-style" iconClass="article" v-else></svg-icon>
              </div>
            </div>
          </div>
        </div>
        <!-- 视频 -->
        <div class="msg" v-if="data.mediaType === '2'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                {{ data.digest }}
              </div>
              <div>
                <img :src="data.coverUrl" v-if="data.coverUrl && data.coverUrl != ''" />
                <svg-icon class="icon-style" iconClass="pic" v-else></svg-icon>
              </div>
            </div>
          </div>
        </div>
        <!-- 文件 -->
        <div class="msg" v-if="data.mediaType === '3'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                {{ data.digest }}
              </div>
              <div>
                <svg-icon
                  class="icon-style"
                  :iconClass="data.materialUrl ? filType(data.materialUrl) : ''"
                  v-if="data.materialUrl"></svg-icon>
              </div>
            </div>
          </div>
        </div>
        <!-- 海报 -->
        <div class="msg" v-if="data.mediaType === '5'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                {{ data.digest }}
              </div>
              <div>
                <img :src="data.materialUrl" v-if="data.materialUrl && data.materialUrl != ''" />
                <svg-icon class="icon-style" iconClass="pic" v-else></svg-icon>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="article">
        <p v-html="article"></p>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'preview-client',
  components: {},
  props: {
    name: {
      type: String,
      default: '客户',
    },
    // 文章详情展示
    article: {
      type: String,
      default: null,
    },
    // 内容
    templateInfo: {
      type: String,
      default: null,
    },
    list: {
      type: Array,
      default: () => [],
    },
    // 直播链接
    liveUrl: {
      type: String,
      default: null,
    },
  },
  watch: {
    list: {
      handler(val) {
        // console.log(144, val)
      },
      immediate: true,
    },
  },
  data() {
    return {}
  },
  computed: {},
  created() {},
  mounted() {},
  methods: {
    // 处理文件类型
    filType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return 'pdf'
      } else if (['doc', 'docx'].includes(type)) {
        return 'word'
      } else if (['ppt', 'pptx', 'pps', 'pptsx'].includes(type)) {
        return 'ppt'
      } else {
        return ''
      }
    },
  },
}
</script>
<style lang="scss" scoped>
.icon-style {
  width: 40px;
  height: 40px;
}
.preview {
  margin: 0 auto;
  position: relative;
  width: 300px;
  height: 640px;
  background: url(../../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;
  // margin-top: 20px;

  .title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;

    font-weight: 400;
    width: 60%;
    color: #333333;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    text-align: center;
  }

  .content {
    position: absolute;
    height: 545px;
    width: 280px;
    overflow-y: auto;
    top: 70px;
    left: 50%;
    transform: translateX(-50%);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
    padding: 20px;

    .item {
      font-size: 12px;

      font-weight: 400;
      color: #666666;
      display: flex;
      margin-top: 20px;

      &:first-child {
        margin-top: 0;
      }

      .avatar222 {
        // align-self: center;
        margin-right: 5px;
      }

      .msg {
        position: relative;
        min-height: 26px;
        background: #ffffff;
        box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
        border: 1px solid #e1edfc;
        display: inline-block;
        border-radius: 4px;
        box-sizing: border-box;
        word-break: break-all;
        margin-left: 5px;

        &:before {
          content: ' ';
          display: block;
          position: absolute;
          left: -5px;
          box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
          border-width: 5px;
          border-left: 0;
          width: 0;
          border-style: solid;
          border-color: transparent;
          border-right-color: #fff;
          top: 8px;
          z-index: 888;
        }

        .word {
          padding: 5px 12px;
        }

        .image {
          padding: 12px;

          img {
            width: 94px;
            height: 90px;
          }
        }

        .word-and-image {
          padding: 12px;
          .sub-content {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
            font-size: 12px;

            font-weight: 400;
            color: #999999;
            img {
              height: 40px;
              width: 40px;
            }
          }
        }
        .miniprogram {
          padding: 12px;
          .mini-header {
            display: flex;
            align-items: center;
            img {
              height: 18px;
              width: 18px;
              margin-right: 5px;
            }
          }
          .mini-img {
            margin: 10px 0;
            width: 143px;
            height: 120px;
          }
          .mini-footer {
            display: flex;
            align-items: center;
            img {
              height: 14px;
              width: 14px;
              margin-right: 5px;
            }
          }
        }
      }
    }
  }
}
</style>
