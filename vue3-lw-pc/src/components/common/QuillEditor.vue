<template>
  <div class="quill-wrap" v-loading="uploadLoading">
    <QuillEditor
      v-model:content="content"
      ref="quill"
      @textChange="onEditorChange"
      contentType="html"
      :options="editorOption"></QuillEditor>
    <Upload v-show="false" v-model:fileUrl="imgUrl" type="0" @loadingChange="(val) => (uploadLoading = val)"></Upload>
    <SelectEmoji ref="emoji" @select="insertContent" />
  </div>
</template>
<script>
import { QuillEditor, Quill } from './Quill'
import ImageResize from 'quill-image-resize-module'
Quill.register('modules/ImageResize', ImageResize)
import SelectEmoji from '@/components/SelectEmoji'

export default {
  components: { QuillEditor, SelectEmoji },
  props: {
    modelValue: {
      type: String,
    },
  },
  emits: ['update:modelValue'],
  watch: {
    modelValue: {
      immediate: true,
      handler(val) {
        this.content = val
      },
    },
    imgUrl(val) {
      let quill = this.$refs.quill.getQuill()
      let length = quill.getSelection().index //光标位置
      // 插入图片  图片地址
      quill.insertEmbed(length, 'image', val)
      // 调整光标到最后
      quill.setSelection(length + 1) //光标后移一位
    },
  },
  data() {
    return {
      content: '',
      uploadLoading: false,
      imgUrl: '',
      // 富文本框参数设置
      editorOption: {
        placeholder: '请输入内容',
        debug: 'warn',
        modules: {
          imageResize: {
            // See optional "config" below
            // modules: ['Resize', 'DisplaySize', 'Toolbar'],
          },
          toolbar: {
            container: [
              ['bold', 'italic', 'underline', 'strike'],
              ['blockquote', 'code-block'],
              [{ header: 1 }, { header: 2 }],
              [{ list: 'ordered' }, { list: 'bullet' }],
              [{ script: 'sub' }, { script: 'super' }],
              [{ indent: '-1' }, { indent: '+1' }],
              [{ direction: 'rtl' }],
              [{ size: ['small', false, 'large', 'huge'] }],
              [{ header: [1, 2, 3, 4, 5, 6, false] }],
              [{ color: [] }, { background: [] }],
              [{ font: [] }],
              [{ align: [] }],
              ['clean'],
              ['link', 'image', 'video', 'emoji'],
            ],
            handlers: {
              image: function (value) {
                if (value) {
                  document.querySelector('.quill-wrap .el-upload__input').click()
                } else {
                  this.quill.format('image', false)
                }
              },
            },
          },
        },
      },
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.$refs.quill.$el.nextElementSibling.querySelector('.ql-emoji').appendChild(this.$refs.emoji.$el)
    })
  },
  methods: {
    onEditorChange() {
      this.$emit('update:modelValue', this.content)
    },
    onProgress(percent) {
      this.uploadLoading = percent > 0 && percent < 100
    },
    insertContent(emoji) {
      let quill = this.$refs.quill.getQuill()
      quill.focus()
      let length = quill.getSelection().index //光标位置
      quill.insertText(length, emoji)
      quill.setSelection(length + 2) //光标后移，表情占2位。所以+2
    },
  },
}
</script>
<style lang="scss" scoped>
::v-deep {
  .ql-editor {
    min-height: 400px;
    .ql-container {
      .ql-snow {
        .ql-tooltip {
          left: 0px !important;
        }
      }
    }
  }
  .ql-toolbar {
    .ql-emoji {
      line-height: 1;
      // &::before {
      //   display: inline-block;
      //   content: '😀' !important;
      // }
    }
  }
}
</style>
