<template>
  <div>
    <el-steps class="g-card g-pad20" style="margin-top:10px;" :active="currentActive" align-center>
      <el-step title="账号信息"></el-step>
      <el-step title="欢迎语"></el-step>
      <el-step title="接待规则"></el-step>
    </el-steps>
    <div v-show="currentActive === 1">
      <part1 :isEdit="isEdit" :editData="form" @next="getBase"></part1>
    </div>
    <div v-show="currentActive === 2">
      <part2 :isEdit="isEdit" :name='form.name' :avatar="form.avatar" :editData="form" @update="getWecome"></part2>
    </div>
    <div v-show="currentActive === 3">
      <part3 :isEdit="isEdit" :editData="form" :name='form.name' :avatar="form.avatar" :submitLoading="loading" @submit="setSubmit"></part3>
    </div>
  </div>
</template>
<script>
  import Part1 from './part1.vue'
  import Part2 from './part2.vue'
  import Part3 from './part3.vue'
  import { addService, getDetail, editService } from '@/api/drainageCode/customerService.js'
  export default {
    name: 'customer-service-manage-add',
    data () {
      return {
        currentActive: 1,
        form: {},
        isEdit: false,
        id: '',
        loading: false
      }
    },
    components: {
      Part1,
      Part2,
      Part3
    },
    methods: {
      getBase (data) {
        this.form.name = data.name
        this.form.avatar = data.avatar
        this.currentActive = 2
      },
      getWecome (type, data) {
        if (type === 3) {
          this.form.receptionType = data.receptionType
          this.form.splitTime = data.splitTime
          this.form.welcome = data.welcome
        }
        this.currentActive = type
      },
      getDetailFn () {
        getDetail(this.id).then(res => {
          this.form = res.data
           this.form.welcome.forEach(dd => {
            if (dd.workCycle) {
              dd.workCycle = dd.workCycle.split(',')
            }
          })
          this.isEdit = true
        })
      },
      setSubmit (type, data) {
        if (type === 2) {
          this.currentActive = type
        } else {
          this.form.userIdList = data.userIdList
          this.form.allocationWay = data.allocationWay
          this.form.isPriority = data.isPriority
          this.form.receiveLimit = data.receiveLimit
          this.form.queueNotice = data.queueNotice
          this.form.queueNoticeContent = data.queueNoticeContent
          this.form.timeOutNotice = data.timeOutNotice
          this.form.timeOut = data.timeOut
          this.form.timeOutType = data.timeOutType
          this.form.timeOutContent = data.timeOutContent
          this.form.endNotice = data.endNotice
          this.form.endNoticeTime = data.endNoticeTime
          this.form.endTimeType = data.endTimeType
          this.form.endContent = data.endContent
          let tempData = JSON.parse(JSON.stringify(this.form))
          tempData.welcome.forEach(dd => {
            if (dd.workCycle && dd.workCycle.length) {
              dd.workCycle = dd.workCycle.join(',')
            } else {
              dd.workCycle = ''
            }
          })
          this.loading = true
          setTimeout(() =>  {
            this.loading = false
            }, 3000)
          if (this.form.id) {
            editService(tempData).then(res => {
              this.$message.success('操作成功！')
              this.loading = false
              this.$router.go(-1)
            })
          } else {
            addService(this.form).then(res => {
              this.$message.success('操作成功！')
              this.loading = false
              this.$router.go(-1)
            })
          }
        }
      }
    },
    mounted () {

    },
    created () {
      this.id = this.$route.query.id
      if (this.id) {
        this.getDetailFn()
      }
    }
  }
</script>
<style lang="scss" scoped>
  .tab {
    height: 78px;
    background: #fff;
    border-top: 1px solid #f1f1f1;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
  }
</style>
