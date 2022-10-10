<template>
  <div style="display: flex;align-items:center;">
    <span class="tag_name" :class="{color1: resource === 1, color2:resource === 2 }">{{resource === 1 ? '@微信':'@企业'}}</span>
    <img class="tag_sex" v-if="sex === 1" width="16" height="16" src="../assets/man.png" />
    <img class="tag_sex" v-else-if='sex === 2' width="16" height="16" src="../assets/woman.png" />
  </div>
</template>
<script>
  export default {
    name: 'show-resource',
    data () {
      return {}
    },
    props: {
      resource: {
        type: Number,
        default: 1 // 1: 微信, 2: 企业
      },
      sex: {
        type: Number,
        default: 1 // 1: 男，2：女
      }
    },
    methods: {
    },
    created () {
    },
  }
</script>
<style lang="less" scoped>
  .tag_name {
    font-size: 12px;
  }
  .color1 {
    color: #00d695;
  }
  .color2 {
    color: #0079de;
  }
  .tag_sex {
    margin-left: 3px;
  }
</style>