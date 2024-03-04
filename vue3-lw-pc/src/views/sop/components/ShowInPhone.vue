<template>
  <div class="preview">
    <div class="title">{{ name }}</div>
    <div class="content">
      <div class="item" v-for="(data, key) in sendList" :key="key">
        <div class="avatar222"><img src="../../../assets/drainageCode/header.png" /></div>
        <div class="msg" v-if="data.msgType === '4'">
          <div class="word">
            {{ data.content }}
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '0'">
          <div class="image">
            <img :src="data.materialUrl" />
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '9'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                <!-- {{data.materialUrl}} -->
              </div>
              <div>
                <img src="../../../assets/drainageCode/default_icon.png" />
              </div>
            </div>
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '12'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content">
              <div>
                <!-- {{ data.materialUrl }} -->
              </div>
              <div>
                <img src="../../../assets/drainageCode/default_icon.png" />
              </div>
            </div>
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '2'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content" style="min-width: 100px">
              <div class="digest">
                {{ data.digest }}
              </div>
              <div>
                <video style="height: 40px; width: 40px" :src="data.materialUrl" />
              </div>
            </div>
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '3'">
          <div class="word-and-image">
            <div>
              {{ data.materialName }}
            </div>
            <div class="sub-content" style="min-width: 100px">
              <div class="digest">
                {{ data.digest }}
              </div>
              <div>
                <svg-icon
                  class="svg"
                  :icon="data.materialUrl ? filType(data.materialUrl) : ''"
                  v-if="data.materialUrl"></svg-icon>
              </div>
            </div>
          </div>
        </div>
        <div class="msg" v-if="data.msgType === '11'">
          <div class="miniprogram">
            <div class="mini-header">
              <img src="../../../assets/drainageCode/miniprogram-icon.png" alt="" />
              {{ data.materialName }}
            </div>
            <img class="mini-img" :src="data.coverUrl" />
            <div class="mini-footer">
              <img src="../../../assets/drainageCode/miniprogram-link.png" />
              小程序
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'show-in-phone',
  components: {},
  props: {
    name: {
      type: String,
      default: '小微',
    },
    list: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      sendList: [],
    }
  },
  watch: {
    list: {
      handler(val) {
        if (val && val.length) {
          this.sendList = this.setEditList(val)
        }
      },
      immediate: true,
      deep: true,
    },
  },
  computed: {},
  created() {},
  mounted() {},
  methods: {
    filType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return 'pdf'
      } else if (type === 'doc' || type === 'docx') {
        return 'word'
      } else if (type === 'xls' || type === 'xlsx') {
        return 'excel'
      } else if (type === 'ppt' || type === 'pptx' || type === 'pps' || type === 'pptsx') {
        return 'ppt'
      } else {
        return ''
      }
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'link' && dd.appId) {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '12',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
              digest: dd.appId,
            }
            arr.push(obj)
          } else if (dd.msgType === 'text') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.msgType === 'image') {
            let obj = {
              id: dd.id ? dd.id : '',
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              id: dd.id ? dd.id : '',
              msgType: '9',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'video') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '2',
              digest: dd.description,
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          } else if (dd.msgType === 'file') {
            let ff = {
              id: dd.id ? dd.id : '',
              msgType: '3',
              digest: dd.description,
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
  },
}
</script>
<style lang="scss" scoped>
.svg {
  height: 40px;
  width: 40px;
}
.preview {
  margin: 0 auto;
  position: relative;
  width: 300px;
  height: 640px;
  background: url(../../../assets/drainageCode/preview-bg.png);
  background-repeat: no-repeat;
  background-size: 100% 100%;

  .title {
    position: absolute;
    top: 37px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 14px;

    font-weight: 400;
    color: var(--font-black);
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
      color: var(--font-black-4);
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
        background: var(--bg-white);
        box-shadow: 0px 2px 6px 0px rgba(60, 136, 240, 0.1);
        border: 1px solid var(--color-light-9);
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
          border-right-color: var(--border-white);
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
            color: var(--font-black-6);
            height: 45px;
            .digest {
              line-height: 15px;
              text-overflow: -o-ellipsis-lastline;
              overflow: hidden;
              text-overflow: ellipsis;
              display: -webkit-box;
              -webkit-line-clamp: 3;
              -webkit-box-orient: vertical;
            }
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
