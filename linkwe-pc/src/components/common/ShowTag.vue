<template>
  <div>
    <template v-for="(data, key) in list">
      <el-tag v-if="key < 2 && data[keyStr]" :key="key" size="mini">{{ data[keyStr] }}
      </el-tag>
    </template>
    <el-popover trigger="hover" width="200">
      <template v-for="(unit, index) in list">
        <el-tag style="margin: 5px;" :key="index" v-if="index > 1 && unit[keyStr]" size="mini">
          {{ unit[keyStr] }}</el-tag>
      </template>
      <div style="display: inline" slot="reference">
        <el-tag style="margin-top: 5px;" v-if="list.length > 2" size="mini">等{{list.length}}个</el-tag>
      </div>
    </el-popover>
  </div>
</template>
<script>
  export default {
    name: 'show-tag',
    data () {
      return {

      }
    },
    props: {
      keyStr: {
        type: String,
        default: 'name'
      },
      list: {
        type: Array,
        default () {
          return [any];
        },
      }
    },
    methods: {

    },
    created () {

    },

  }
</script>