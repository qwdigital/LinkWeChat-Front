<template>
  <div class="g-card">
    <search-title>
      <template v-slot>
        <el-input :model-value="userNames" readonly @click="dialogVisible = true" placeholder="请选择添加员工" />
      </template>
    </search-title>
    <SelectUser
      v-model:visible="dialogVisible"
      title="组织架构"
      :defaultValues="userArray"
      @success="getSelectUser"
    ></SelectUser>
  </div>
</template>
<script>
  import SearchTitle from '../components/SearchTitle.vue'

  export default {
    data() {
      return {
        manList: [],
        query: {
          pageSize: 10,
          pageNum: 1,
          userIds: ''
        },
        userNames: '',
        dialogVisible: false,
        userArray: []
      }
    },
    components: {
      SearchTitle
    },
    methods: {
      getSelectUser(data) {
        this.userArray = data
        this.userNames = this.userArray
          .map(function (obj, index) {
            return obj.name
          })
          .join(',')
        this.query.userIds = this.userArray
          .map(function (obj, index) {
            return obj.userId
          })
          .join(',')
      }
    },
    created() {}
  }
</script>
