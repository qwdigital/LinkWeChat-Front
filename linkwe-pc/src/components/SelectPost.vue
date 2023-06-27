<script>
  import { getDeptUserAll } from '@/api/organization'
  export default {
    name: 'SelectPost',
    components: {},
    props: {
      visible: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: '选择岗位'
      },
      // 是否单选
      isSigleSelect: {
        type: Boolean,
        default: false
      },
      // 默认选中
      defaultValues: {
        type: Array,
        default: () => []
      },
      // 禁止选中
      disabledValues: {
        type: Array,
        default: () => []
      },
      destroyOnClose: Boolean
    },
    data() {
      return {
        postList: [],
        selectList: []
      }
    },
    watch: {
      defaultValues: {
        handler(value) {
          this.selectList = value
        },
        immediate: true
      },
      Pvisible(val) {
        this.selectList = this.defaultValues
      }
    },
    computed: {
      Pvisible: {
        get() {
          return this.visible
        },
        set(val) {
          this.$emit('update:visible', val)
        }
      }
    },
    created() {
      getDeptUserAll().then(({ data }) => {
        let arr = data.map((item) => {
          return item.position
        })
        this.postList = Array.from(new Set(arr))
      })
    },
    mounted() {},
    methods: {
      // 确 定
      submit() {
        this.Pvisible = false
        this.$emit('success', [...this.selectList])
      },
      // 取消选择
      cancle(index) {
        this.selectList.splice(index, 1)
      }
    }
  }
</script>
<template>
  <el-dialog :title="title" :visible.sync="Pvisible" :close-on-click-modal="false" :destroy-on-close="destroyOnClose">
    <el-row :gutter="20">
      <el-col :span="12" :xs="24">
        <div class="head-container">
          <el-checkbox-group v-model="selectList">
            <template v-for="(unit, index) in postList">
              <el-checkbox
                style="display: block;"
                :label="unit"
                v-if="unit"
                :key="index"
                :disabled="disabledValues.includes(unit)"
              >
                {{ unit }}
              </el-checkbox>
            </template>
          </el-checkbox-group>
        </div>
      </el-col>
      <el-col :span="12" :xs="24" class="user-list">
        <el-row :gutter="10">选择岗位列表</el-row>
        <el-row v-for="(item, index) in selectList" :key="index">
          <i class="el-icon-user-solid"></i>
          {{ item }}
          <i class="el-icon-minus fr cp" title="取消选择" @click="cancle(index)"></i>
        </el-row>
      </el-col>
    </el-row>
    <div slot="footer">
      <el-button @click="Pvisible = false">取 消</el-button>
      <el-button type="primary" @click="submit">确 定</el-button>
    </div>
  </el-dialog>
</template>

<style lang="scss" scoped>
  .user-list {
    .el-row {
      line-height: 26px;
    }
  }
</style>
