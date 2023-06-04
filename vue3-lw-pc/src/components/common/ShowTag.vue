<template>
  <div>
    <template v-for="(data, key) in list" :key="key">
      <el-tag v-if="key < 2 && data[keyStr]" :key="key">{{ data[keyStr] }}</el-tag>
    </template>
    <el-popover trigger="hover" width="200">
      <template v-for="(unit, index) in list" :key="index">
        <el-tag style="margin: 5px" v-if="index > 1 && unit[keyStr]">
          {{ unit[keyStr] }}
        </el-tag>
      </template>
      <template #reference>
        <div style="display: inline">
          <el-tag style="margin-top: 5px" v-if="list.length > 2">等{{ list.length }}个</el-tag>
        </div>
      </template>
    </el-popover>
  </div>
</template>
<script>
export default {
  name: 'show-tag',
  data() {
    return {}
  },
  props: {
    keyStr: {
      type: String,
      default: 'name',
    },
    list: {
      type: Array,
      default() {
        return [any]
      },
    },
  },
  methods: {},
  created() {},
}
</script>
