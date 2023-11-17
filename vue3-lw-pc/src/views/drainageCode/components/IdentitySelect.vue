<template>
  <div>
    <!-- 素材中心 -->
    <!-- <div class="g-card" style="padding: 10px"> -->
    <el-dialog
      v-if="dialogVisibel"
      title="选择素材"
      v-model="dialogVisibel"
      width="80%"
      append-to-body
      :close-on-click-modal="false"
      @close="dialogClose">
      <MaPage ref="page" :type="moduleType" v-slot="{ list }">
        <el-table :data="list" ref="multipleTable">
          <el-table-column width="30">
            <template #default="{ row }">
              <el-radio v-model="radio" :label="row"></el-radio>
            </template>
          </el-table-column>
          <el-table-column label="素材" align="left">
            <template #default="{ row }">
              <PicTitContent :row="row" width="500px" />
            </template>
          </el-table-column>
        </el-table>
      </MaPage>
      <template #footer>
        <div class="footer">
          <div>
            <el-button type="primary" @click="centerSubmit">确 定</el-button>
            <el-button @click="centerCancel">取 消</el-button>
          </div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import MaPage from './IdentitySelectBase'
import PicTitContent from '@/views/contentCenter/components/PicTitContent'

export default {
  name: '',
  props: {
    // 控制弹框显隐
    choseDialog: {
      type: Boolean,
      default: false,
    },
    talkListLength: {
      type: Number,
      default: 0,
    },
    moduleType: {
      type: Number,
      default: null,
    },
    // 没有小程序
    noApplets: {
      type: Boolean,
      default: false,
    },
  },
  watch: {
    choseDialog: {
      handler(val) {
        this.dialogVisibel = val
      },
    },
  },
  computed: {},
  components: {
    MaPage,
    PicTitContent,
  },
  created() {
    this.dealList()
  },
  mounted() {},
  data() {
    return {
      radio: {},
      dialogVisibel: false,
      activeName: 'text',
      index: 0,
      picindex: 1,
      paneList: [],
      opened: ['text'],
      ids: [], // 选中数组
      itemArry: [], // 选中数组
    }
  },
  methods: {
    // 超过num个。。。展示
    coverContent(str, num) {
      if (str && str.length > num) {
        str = str.substr(0, num) + '...'
      }
      return str
    },
    dealList() {
      this.paneList = [
        { list: [], label: '文本', name: 'text', type: '4' },
        { list: [], label: '图片', name: 'image', type: '0' },
        { list: [], label: '图文', name: 'imageText', type: '9' },
        { list: [], label: '小程序', name: 'applet', type: '11' },
        { list: [], label: '文章', name: 'article', type: '12' },
        { list: [], label: '视频', name: 'video', type: '2' },
        { list: [], label: '文件', name: 'file', type: '3' },
        { list: [], label: '海报', name: 'poster', type: '5' },
      ]
      this.picindex = 1
      this.activeName = 'text'
      if (this.$route.query.tplType || this.moduleType === 4) {
        // 不包含文本
        this.paneList.shift()
        this.picindex = 0
        this.activeName = 'image'
      }
      if (this.noApplets) {
        // 不包含小程序
        this.paneList = this.paneList.filter((item) => {
          return item.type != '11'
        })
      }
    },
    centerCancel() {
      this.dialogVisibel = false
      this.$emit('update:choseDialog', this.dialogVisibel)
      this.radio = {}
    },
    dialogClose() {
      this.dialogVisibel = false
      this.$emit('update:choseDialog', this.dialogVisibel)
      this.radio = {}
    },
    centerSubmit() {
      this.dialogVisibel = false
      console.log(this.radio)
      this.$emit('itemArry', [this.radio])
      this.$emit('update:choseDialog', this.dialogVisibel)
      this.radio = {}
    },
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
    tabClick(v) {
      this.index = v.index
    },
  },
}
</script>
<style lang="scss" scoped>
.emptyStyle {
  width: 100%;
  // height: 60px;
  text-align: center;
  line-height: 60px;
  color: var(--font-black-6);
  font-size: 13px;
  padding: 40px;
  padding-left: 0px;
}
.footer {
  display: flex;
  justify-content: flex-end;
}
.footerColor {
  font-weight: 500;
  font-size: 18px;
  color: var(--color);
  margin: 0 4px;
}
.twosplice {
  width: 90%; //宽度

  overflow: hidden; //超出文本隐藏

  text-overflow: ellipsis; ///超出部分省略号显示

  display: -webkit-box; //弹性盒模型

  -webkit-box-orient: vertical; //上下垂直

  -webkit-line-clamp: 2; //自定义行数
  font-size: 14px;
  display: block;
}
.title {
  width: 80%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: bold;
  color: var(--font-black-7);
  font-size: 12px;
}
.imgsize {
  width: 60px;
  height: 60px;
  margin-right: 10px;
}
.el-checkbox {
  width: 20px;
  overflow: hidden;
}
.checkboxStyle {
  display: flex;
  justify-content: space-between;
  height: 30px;
  padding: 10px;
  padding-bottom: 0;
}
.imgStyle {
  display: flex;
  flex-wrap: wrap;
  .imgItem {
    width: 18%;
    height: 210px;
    margin-bottom: 20px;
    margin-right: 2%;
    border: 1px solid var(--border-black-9);
    .img {
      width: 100%;
      height: 180px;
      background-repeat: no-repeat;
      background-size: cover;
      background-position: center;
      cursor: pointer;
    }
  }
}
</style>
