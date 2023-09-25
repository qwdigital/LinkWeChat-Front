<template>
  <div class="itemList">
    <div class="content bfc-o">
      <div class="title">{{ weMaterialVo.materialName }}</div>
      <!-- 文章 -->
      <div class="centerStyle" v-if="weMaterialVo.mediaType == 12">
        <el-image class="img-style" fit="contain" :src="weMaterialVo.coverUrl" v-if="weMaterialVo.coverUrl" />
        <svg-icon class="icon-style" icon="article" v-else></svg-icon>
        <div class="contentStyle">{{ weMaterialVo.digest }}</div>
      </div>
      <!-- 视频 -->
      <div class="centerStyle" v-if="weMaterialVo.mediaType == 2">
        <el-image class="img-style" :src="weMaterialVo.coverUrl" />
        <div class="contentStyle">{{ weMaterialVo.digest }}</div>
      </div>
      <!-- 海报 -->
      <div class="centerStyle" v-if="weMaterialVo.mediaType == 5">
        <el-image class="img-style" fit="contain" :src="weMaterialVo.materialUrl" v-if="weMaterialVo.materialUrl" />
        <svg-icon class="icon-style" icon="pic" v-else></svg-icon>
        <div class="contentStyle">{{ weMaterialVo.digest }}</div>
      </div>
      <!-- 文件 -->
      <div v-if="weMaterialVo.mediaType === '3'" style="display: flex">
        <svg-icon
          class="icon-style"
          :icon="weMaterialVo.materialUrl ? filType(weMaterialVo.materialUrl) : ''"
          v-if="weMaterialVo.materialUrl"></svg-icon>
        <span class="contentStyle">{{ weMaterialVo.digest }}</span>
      </div>
    </div>
    <div class="info">
      <div class="flex fr">
        <div v-if="['2', '5', '9'].includes(weMaterialVo.mediaType)" class="preview">
          <a :href="weMaterialVo.materialUrl" target="_blank">预览</a>
        </div>

        <div v-if="weMaterialVo.mediaType === '12'" class="preview" @click="preview(weMaterialVo)">预览</div>
        <a
          target="_blank"
          :href="$previewFile(weMaterialVo.materialUrl)"
          class="preview"
          v-if="weMaterialVo.mediaType == '3'">
          预览
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  },
  methods: {
    // preview(obj) {
    //   if (obj.id !== '0' && obj.id !== '4') {
    //     this.$router.push({
    //       name: 'previewDetail',
    //       query: {
    //         obj: obj,
    //       },
    //     })
    //   }
    // },
    preview(row) {
      // let routeData = this.$router.resolve({
      //   path: '/preview',
      //   query: { obj: encodeURIComponent(JSON.stringify(row)) },
      // })
      // window.open(routeData.href, '_blank')
      window.open(window.lwConfig.PRIVIEW_PATH + row.id + '&otherModle=' + true, '_blank')
    },
    // 处理文件类型
    filType(file) {
      let filecontent = JSON.parse(JSON.stringify(file))
      filecontent = filecontent.split('.')
      let type = filecontent[filecontent.length - 1]
      if (type === 'pdf') {
        return 'pdf'
      } else if (type === 'doc' || type === 'docx') {
        return 'word'
      } else if (type === 'ppt' || type === 'pptx' || type === 'pps' || type === 'pptsx') {
        return 'ppt'
      } else {
        return ''
      }
    },
  },
  props: {
    weMaterialVo: {
      type: Object,
      default: {},
    },
  },
}
</script>

<style lang="scss" scoped>
.preview {
  width: 50px;
  height: 20px;
  font-size: 12px;
  background: var(--bg-white);
  border: 1px solid var(--color);
  border-radius: 10px;
  color: var(--color);
  line-height: 20px;
  text-align: center;
  margin-right: 6px;
}
.title {
  font-weight: 700;
  font-size: 12px;
  color: var(--font-black);
  line-height: 18px;
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 6px;
}
.icon-style {
  width: 40px;
  height: 40px;
}
.itemList {
  width: 60%;
  margin: 10px;
  background-color: var(--bg-black-9);
  padding: 10px;
  border-radius: 4px;
}
.info {
  height: 20px;
  .fr {
    cursor: pointer;
  }
}
.centerStyle {
  display: flex;
  width: 100%;
  justify-content: space-between;
  .contentStyle {
    font-size: 12px;
    color: var(--font-black-7);
    width: calc(100% - 60px);
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    height: 28px;
    margin-top: 20px;
  }
  .img-style {
    width: 60px;
    height: 60px;
  }
}
</style>
