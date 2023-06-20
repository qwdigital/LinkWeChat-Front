<template>
  <div v-if="loading">
    <div style="height: 500px; width: 500px" v-loading="loading"></div>
  </div>
  <div v-else>
    <welcome-content
      v-if="show"
      :strType="form.tplType === '3'"
      :isSingle="form.tplType === '3'"
      :showTemplate="false"
      :showMember="form.tplType === '2'"
      :showMorMaterial="true"
      :baseData="materialData"
      @submit="getWelData"></welcome-content>
  </div>
</template>

<script>
import { add, update, getPreview } from '@/api/drainageCode/welcome'
import SelectMaterial from '@/components/SelectMaterial'
import WelcomeContent from '@/components/WelcomeContent.vue'
export default {
  components: {
    SelectMaterial,
    WelcomeContent,
  },
  props: {},
  data() {
    return {
      name: '活码',
      type: '新建',
      materialData: {
        welcomeMsg: '',
        materialMsgList: [],
      },
      dialogVisible: false,
      dialogVisibleSelectMaterial: false,
      form: {
        id: '',
        tplType: '',
        attachments: [],
      },
      // 遮罩层
      loading: false,
      show: false,
    }
  },
  watch: {},
  computed: {},
  created() {
    this.form.id = this.$route.query.id
    if (this.form.id) {
      let data = JSON.parse(localStorage.getItem('obj'))
      this.form = Object.assign(this.form, data)
      this.form.tplType = this.form.tplType.toString()
    } else {
      this.form.tplType = this.$route.query.tplType
    }
    this.name = this.form.tplType === '1' ? '活码' : this.form.tplType === '2' ? '员工' : '入群'
    this.type = this.form.id ? '编辑' : '新建'
    this.$route.meta.title = (this.form.id ? '编辑' : '新建') + '欢迎语'
    this.form.id && this.getData()
  },
  mounted() {
    this.show = true
  },
  methods: {
    getWelData(materialData) {
      let list = this.resetData(materialData.materialMsgList)
      let myObj = {
        // content: materialData.welcomeMsg,
        attachments: [
          {
            content: materialData.welcomeMsg,
            msgType: 'text',
          },
        ],
      }
      if (materialData.userIds) {
        myObj.userIds = materialData.userIds
        myObj.userNames = materialData.userNames
      }
      myObj.attachments.push(...list)
      let data = Object.assign({}, this.form, myObj)
      this.submit(data)
    },
    resetData(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === '0') {
            let obj = {
              msgType: 'image',
              picUrl: dd.materialUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === '8') {
            let ob = {
              msgType: 'link',
              title: dd.materialName,
              linkUrl: dd.materialUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === '9') {
            let ff = {
              msgType: 'miniprogram',
              appId: dd.digest,
              title: dd.materialName,
              picUrl: dd.coverUrl,
              linkUrl: dd.materialUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    getData() {
      getPreview(this.form.id).then(({ data }) => {
        this.materialData = this.form
        // this.materialData.users = []
        // if (this.materialData.userIds) {
        //   let name = this.materialData.userNames.split(',')
        //   this.materialData.userIds.split(',').forEach((ddd, index) => {
        //     let obj = {
        //       useUserId: ddd,
        //       userName: name[index]
        //     }
        //     this.materialData.users.push(obj)
        //   })
        // }
        this.materialData.welcomeMsg = data.attachments ? data.attachments[0].content : ''
        this.materialData.materialMsgList = data.attachments ? this.setEditList(data.attachments) : []
        // this.$forceUpdate()
      })
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === 'image') {
            let obj = {
              msgType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.msgType === 'link') {
            let ob = {
              msgType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            }
            arr.push(ob)
          } else if (dd.msgType === 'miniprogram') {
            let ff = {
              msgType: '9',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            }
            arr.push(ff)
          }
        })
      }
      return arr
    },
    submit(data) {
      this.loading = true
      data.tplType = Number(data.tplType)
      delete data.materialMsgList
      delete data.welcomeMsg
      if (data.id) {
        update(data)
          .then(({ data }) => {
            this.msgSuccess('操作成功')
            this.loading = false
            this.$router.push({
              path: '/content/template/welcome',
              query: {
                type: this.form.tplType.toString(),
              },
            })
          })
          .catch(() => {
            this.loading = false
          })
      } else {
        add(data)
          .then(({ data }) => {
            this.msgSuccess('操作成功')
            this.loading = false
            this.$router.push({
              path: '/content/template/welcome',
              query: {
                type: this.form.tplType.toString(),
              },
            })
          })
          .catch(() => {
            this.loading = false
          })
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.page {
  padding: 30px;
  background: var(--bg-white);
  border-radius: 8px;
}

.form {
  width: 50%;
  max-width: 500px;
}

.filter-wrap {
  justify-content: space-between;
}

.list-wrap {
  flex-wrap: wrap;
}

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: #333;
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: #666666;
  display: flex;
}
</style>
