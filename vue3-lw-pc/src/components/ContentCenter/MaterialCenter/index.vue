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
      @close="dialogClose"
    >
      <el-tabs v-model="activeName" @tab-click="tabClick">
        <el-tab-pane
          v-for="(item, index) in paneList"
          :key="index"
          :label="item.label + '(' + item.list.length + ')'"
          :name="item.name"
        >
          <MaPage ref="page" :type="item.type" :isFriends="isFriends" v-slot="{ list }" @listChange="listChange">
            <div v-if="item.type === '0'">
              <div v-if="list && list.length">
                <el-checkbox-group v-model="paneList[picindex].list" class="imgStyle">
                  <div class="imgItem" v-for="(item, index) in list" :key="index" @click="changeBox($event, item)">
                    <div class="checkboxStyle">
                      <el-checkbox
                        :label="item"
                        style="width: 20px; height: 20px;"
                        :checked="item.isCheck"
                      ></el-checkbox>
                      <el-tooltip
                        :content="item.materialName"
                        placement="top"
                        :disabled="item.materialName ? item.materialName.length < 6 : true"
                      >
                        <div class="title ml10">
                          {{ coverContent(item.materialName, 6) }}
                        </div>
                      </el-tooltip>
                    </div>
                    <div class="img" :style="{ 'background-image': 'url(' + item.materialUrl + ')' }"></div>
                  </div>
                </el-checkbox-group>
              </div>
              <div class="emptyStyle" v-else>
                <span>暂无数据</span>
              </div>
            </div>
            <el-table :data="list" ref="multipleTable" @select="handleSelect" @select-all="selectAll" v-else>
              <el-table-column type="selection" width="50" align="center" />
              <el-table-column label="素材" align="left">
                <template #default="{ row }">
                  <PicTitContent :row="row" width="500px" />
                </template>
              </el-table-column>
            </el-table>
          </MaPage>
        </el-tab-pane>
      </el-tabs>
      <template #footer>
        <div class="footer">
          <div>
            已选择
            <span class="footerColor">{{ ids.length }}</span>
            个素材
          </div>
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
  import MaPage from './MaPage'
  import PicTitContent from '@/views/contentCenter/components/PicTitContent'

  export default {
    name: '',
    props: {
      // 控制弹框显隐
      choseDialog: {
        type: Boolean,
        default: false
      },
      talkListLength: {
        type: Number,
        default: 0
      },
      moduleType: {
        type: Number,
        default: null
      },
      // 最多选择几个素材
      maxlength: {
        type: Number,
        default: 9
      },
      // 没有小程序
      noApplets: {
        type: Boolean,
        default: false
      },
      // 朋友圈
      isFriends: {
        type: Boolean,
        default: false
      }
    },
    watch: {
      choseDialog: {
        handler(val) {
          this.dialogVisibel = val
        }
      },
      maxlength: {
        handler(val) {
          console.log(123)
          console.log(val)
          this.maxlength2 = val
        }
      }
    },
    computed: {},
    components: {
      MaPage,
      PicTitContent
    },
    created() {
      this.dealList()
    },
    mounted() {},
    data() {
      return {
        dialogVisibel: false,
        activeName: 'text',
        index: 0,
        picindex: 1,
        paneList: [],
        opened: ['text'],
        ids: [], // 选中数组
        itemArry: [], // 选中数组
        inx: 0,
        maxlength2: 9 // 最大确认数
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
      listChange(list, type) {
        this.paneList = this.paneList.map((item) => {
          if (type === item.type) {
            item.list.forEach((one) => {
              this.ids = this.ids.filter((two) => {
                return two.id !== one.id
              })
            })
            item.list = []
          }
          return item
        })
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
          { list: [], label: '外链', name: 'outChain', type: '19' }
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
      clearPaneList() {
        this.paneList.forEach((item) => {
          item.list = []
        })
      },
      changeBox(event, obj) {
        event.preventDefault()
        let setStatus = true
        if (this.isFriends) {
          // 如果是朋友圈的
          this.maxlength2 = 9
          this.paneList.forEach((item, i) => {
            if (item.list.length > 0 && i !== 0) {
              this.$message.error('仅允许选择一种类型的素材')
              setStatus = false
              return
            }
          })
        }
        if (setStatus) {
          this.ids = []
          this.paneList.forEach((item) => {
            if (item.list && item.list.length) {
              item.list.forEach((item1) => {
                this.ids.push(item1)
              })
            }
          })
          if (
            (this.ids.length + this.talkListLength > this.maxlength2 ||
              this.ids.length + this.talkListLength === this.maxlength2) &&
            !obj.isCheck
          ) {
            this.$message.error('最多新建或选择' + this.maxlength2 + '个素材,已新建' + this.talkListLength + '个素材')
            return
          }
          obj.isCheck = !obj.isCheck
          if (obj.isCheck) {
            this.paneList[this.picindex].list.push(obj)
          } else {
            this.paneList[this.picindex].list = this.paneList[this.picindex].list.filter((list) => {
              return list.id !== obj.id
            })
          }
          this.ids = []
          this.paneList.forEach((item) => {
            if (item.list && item.list.length) {
              item.list.forEach((item1) => {
                this.ids.push(item1)
              })
            }
          })
        }
      },
      centerCancel() {
        this.dialogVisibel = false
        this.$emit('update:choseDialog', this.dialogVisibel)
        this.$refs.multipleTable.forEach((item, i) => {
          item.clearSelection()
        })
        this.clearPaneList()
        this.ids = []
      },
      dialogClose() {
        this.dialogVisibel = false
        this.$emit('update:choseDialog', this.dialogVisibel)
        this.$refs.multipleTable.forEach((item, i) => {
          item.clearSelection()
        })
        this.clearPaneList()
        this.ids = []
      },
      centerSubmit() {
        if (this.ids.length) {
          if (this.isFriends) {
            if (this.ids[0].mediaType === '0') {
              // 朋友圈下的图片,最大数量为9
              this.maxlength2 = 9
            } else {
              this.maxlength2 = 1
            }
          }
          if (this.ids.length + this.talkListLength > this.maxlength2) {
            if (this.isFriends) {
              this.$message.error('除图片素材可选9条数据,其他类型仅可选择一条数据,且只能选择一种类型')
            } else {
              this.$message.error('最多新建或选择' + this.maxlength2 + '个素材')
            }

            return
          } else {
            this.dialogVisibel = false
            this.$emit('itemArry', this.ids, this.maxlength2)
            this.$emit('update:choseDialog', this.dialogVisibel)
            this.$refs.multipleTable.forEach((item) => {
              item.clearSelection()
            })
            this.ids = []
            this.clearPaneList()
          }
        } else {
          this.$message.error('请选择素材!')
        }
      },
      // 单个选择
      handleSelect(select, row) {
        if (this.isFriends) {
          // 如果是朋友圈的
          this.maxlength2 = 1
          this.paneList.forEach((item, i) => {
            if (item.list.length > 0 && i !== +this.index) {
              this.$message.error('仅允许选择一种类型的素材')
              return
            }
          })
          if (this.paneList[this.index].list.length > 0) {
            this.$message.error('除图片素材可选9条数据,其他类型仅可选择一条数据')
          }
        }
        let list = this.paneList[this.index].list
        let falg = false
        if (list.length) {
          list.forEach((obj) => {
            if (obj.id === row.id) {
              // 取消勾选
              falg = true
            }
          })
        }
        if (!falg) {
          this.paneList[this.index].list.push(row)
        } else {
          this.paneList[this.index].list = this.paneList[this.index].list.filter((item) => {
            return item.id != row.id
          })
        }
        this.getIds()
        if (this.ids.length + this.talkListLength > this.maxlength2) {
          this.$nextTick(() => {
            if (this.index) this.$refs.multipleTable[this.inx].toggleRowSelection(row, false)
          })
          if (!this.isFriends) {
            this.$message.error('最多新建或选择' + this.maxlength2 + '个素材,已新建' + this.talkListLength + '个素材')
          }

          this.paneList[this.index].list = this.paneList[this.index].list.filter((item) => {
            return item.id != row.id
          })
          this.getIds()
        }
      },
      selectAll(select) {
        if (this.isFriends) {
          // 如果是朋友圈的
          this.maxlength2 = 1
          // this.paneList.forEach((item, i) => {
          //   if (item.list.length > 0 && i !== +this.index) {
          //     this.$message.error('仅允许选择一种类型的素材')
          //     return
          //   }
          // })
        }
        if (select.length) {
          // 全选
          this.paneList[this.index].list = select
        } else {
          // 取消全选
          this.paneList[this.index].list = []
        }
        this.getIds()
        if (this.ids.length + this.talkListLength > this.maxlength2) {
          select.forEach((item) => {
            this.$refs.multipleTable[this.inx].toggleAllSelection(item, false)
          })
          if (!this.isFriends) {
            this.$message.error('最多新建或选择' + this.maxlength2 + '个素材,已新建' + this.talkListLength + '个素材')
          }

          this.paneList[this.index].list = []
          this.getIds()
        }
      },
      getIds() {
        this.ids = []
        this.paneList.forEach((item) => {
          if (item.list && item.list.length) {
            item.list.forEach((item1) => {
              this.ids.push(item1)
            })
          }
        })
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
        let index = +this.index
        if (index !== 0) {
          this.inx = index - 1
        } else {
          this.inx = index
        }
      }
    }
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
    justify-content: space-between;
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
