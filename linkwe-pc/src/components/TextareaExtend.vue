// 带 插入 表情/客户昵称 等扩展工具栏的文本内容框
<script>
  export default {
    name: '',
    props: {
      value: '',
      // ['emoji','insertCustomerNickName']
      toolbar: {
        type: Array,
        default: () => ['emoji']
      }
    },
    components: {
      SelectEmoji: () => import('@/components/SelectEmoji')
    },
    data() {
      return {}
    },
    computed: {
      proxyValue: {
        get() {
          return this.value
        },
        set(val) {
          this.$emit('input', val)
        }
      }
    },
    watch: {},
    created() {},
    mounted() {},
    methods: {
      // 插入内容
      insertContent(value) {
        const $textarea = this.$refs.textarea.$el.children[0]
        const content = this.proxyValue || ''
        const textIndex = $textarea.selectionStart
        this.proxyValue = content.slice(0, textIndex) + value + content.slice(textIndex)
      }
    }
  }
</script>

<template>
  <div>
    <el-input ref="textarea" v-model="proxyValue" type="textarea" v-bind="$attrs" v-on="$listeners"></el-input>
    <div class="mt10">
      <SelectEmoji v-if="toolbar.includes('emoji')" @select="insertContent">
        <template v-slot:default="{ emojisArr }">
          <el-button>
            {{ emojisArr[0].emoji }}
          </el-button>
        </template>
      </SelectEmoji>
      <el-button v-if="toolbar.includes('insertCustomerNickName')" @click="insertContent('#客户昵称#')" class="ml10">
        插入客户昵称
      </el-button>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  textarea {
    white-space: pre-wrap; //保留所有空格
  }
</style>
