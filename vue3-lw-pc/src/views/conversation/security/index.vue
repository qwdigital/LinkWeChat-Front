<template>
  <div class="security">
    <el-tabs v-model="activeName">
      <el-tab-pane label="敏感词触发" name="1">
        <sensitive-list />
      </el-tab-pane>
      <el-tab-pane label="敏感词设置" name="2">
        <set-sensitive-word />
      </el-tab-pane>
      <!-- <el-tab-pane label="敏感行为警告" name="3">
        <alarming-sensitive />
      </el-tab-pane> -->
    </el-tabs>
  </div>
</template>
<script>
  // import alarmingSensitive from './alarmingSensitive.vue'
  import sensitiveList from './sensitiveList.vue'
  import setSensitiveWord from './setSensitiveWord'
  export default {
    components: {
      sensitiveList,
      setSensitiveWord,
      // alarmingSensitive
    },
    data () {
      return {
        activeName: '1'
      }
    },
    methods: {
      // handleClick(tab, event) {
      //   console.log(tab, event);
      // }
    }
  }
</script>
