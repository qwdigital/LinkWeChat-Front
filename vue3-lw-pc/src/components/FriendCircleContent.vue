<script>
export default {
  name: '',
  components: {},
  props: {
    data: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      welcomeMsgError: '',
      limit: [1440, 1080],
      form: {},
    }
  },
  computed: {},
  watch: {
    data: {
      handler(val) {
        this.form = val
      },
      immediate: true,
    },
  },
  created() {},
  mounted() {},
  methods: {
    onInsertMaterial(e) {
      this.form.contentType = e
      this.form.otherContent.push({
        annexType: e,
        annexUrl: '',
        contentError: '',
      })
    },
    onRemoveMaterial(index) {
      this.form.otherContent.splice(index, 1)
      if (!this.form.otherContent.length) {
        this.form.contentType = ''
      }
    },
    validateMaterial() {
      let goto = true
      this.form.otherContent.forEach((dd) => {
        if (!dd.annexUrl) {
          dd.contentError = '内容不能为空'
          goto = false
        } else if (dd.annexType == 'link' && !dd.other) {
          dd.otherError = '封面图片不能为空'
        } else {
          dd.contentError = ''
          dd.otherError = ''
        }
      })
      return goto
    },
    validate() {
      if (!this.form.content) {
        this.welcomeMsgError = '请输入动态内容'
        return
      } else {
        this.welcomeMsgError = ''
      }
      let goto = this.validateMaterial()
      if (goto) {
        this.form.otherContent.forEach((dd) => {
          delete dd.contentError
          delete dd.otherError
          if (dd.annexType === 'link') {
            let reUrl = /(http|https):\/\/([\w.]+\/?)\S*/
            if (!reUrl.test(dd.annexUrl)) {
              goto = false
              dd.contentError = '必须以 http://或 https://开头'
            }
            if (!dd.other) {
              goto = false
              dd.otherError = '请上传封面图片'
            }
          }
        })
        // this.$forceUpdate()
        if (!this.form.otherContent.length) {
          this.form.contentType = 'text'
        }
      }
      if (goto) {
        this.$emit('update:data', this.form)
        return true
      } else {
        return false
      }
    },
  },
}
</script>

<template>
  <el-form label-width="110px" label-position="right">
    <div class="g-card">
      <el-form-item label="动态内容" required style="width: 50%; margin-bottom: 0" :error="welcomeMsgError">
        <el-input
          ref="msgTextarea"
          type="textarea"
          v-model="form.content"
          maxlength="2000"
          show-word-limit
          placeholder="请输入"
          :autosize="{ minRows: 5, maxRows: 20 }"
          clearable />
      </el-form-item>
    </div>

    <!-- 附件 -->
    <div class="g-card" v-for="(item, index) in form.otherContent" :key="index">
      <!-- 图片上传 -->
      <div class="my-cord" v-if="item.annexType == 'image'">
        <div class="operation">
          <div class="algin" @click="onRemoveMaterial(index)">
            <el-icon-delete class="el-icon-delete mr5"></el-icon-delete>
            删除
          </div>
        </div>
        <el-form-item label="图片上传" required :error="item.contentError">
          <upload :maxImgPx="limit" class="image-uploader" v-model:fileUrl="item.annexUrl" type="0"></upload>
        </el-form-item>
      </div>
      <!-- 图文 -->
      <div class="my-cord" v-else-if="item.annexType == 'link'">
        <div class="operation">
          <div class="algin" @click="onRemoveMaterial(index)">
            <el-icon-delete class="el-icon-delete mr5"></el-icon-delete>
            删除
          </div>
        </div>
        <el-form-item label="图文链接" style="width: 50%" required :error="item.contentError">
          <el-input v-model="item.annexUrl" placeholder="请输入图文链接"></el-input>
          <div class="sub-des">仅支持公众号图文链接，且必须以 http://或 https://开头</div>
        </el-form-item>
        <el-form-item label="封面图片" style="width: 50%" required :error="item.otherError">
          <upload class="image-uploader" v-model:fileUrl="item.other" type="0"></upload>
        </el-form-item>
      </div>
      <div class="my-cord" v-else-if="item.annexType == 'video'">
        <div class="operation">
          <div class="algin" @click="onRemoveMaterial(index)">
            <el-icon-delete class="el-icon-delete mr5"></el-icon-delete>
            删除
          </div>
        </div>
        <el-form-item label="视频上传" required :error="item.contentError">
          <upload class="image-uploader" v-model:fileUrl="item.annexUrl" type="2"></upload>
        </el-form-item>
      </div>
    </div>
    <!-- 添加附件 -->
    <div
      class="g-card add-continue"
      v-show="form.otherContent.length <= 8 && form.contentType !== 'video' && form.contentType !== 'link'">
      <el-dropdown style="margin-left: 10px" @command="onInsertMaterial">
        <div style="display: flex; align-items: center">
          <el-icon-CirclePlus class="el-icon-CirclePlus mr5"></el-icon-CirclePlus>
          继续添加附件
        </div>
        <template #dropdown>
          <el-dropdown-menu trigger="click">
            <!-- <el-dropdown-item :command="4">
                  <el-button text>文字</el-button>
                </el-dropdown-item> -->
            <el-dropdown-item v-if="form.contentType === 'image' || form.otherContent.length === 0" :command="'image'">
              <el-button text>图片</el-button>
            </el-dropdown-item>
            <el-dropdown-item v-if="form.otherContent.length === 0" :command="'video'">
              <el-button text>视频</el-button>
            </el-dropdown-item>
            <el-dropdown-item v-if="form.otherContent.length === 0" :command="'link'">
              <el-button text>网页</el-button>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </el-form>
</template>

<style lang="scss" scoped>
::v-deep .image-uploader {
  .uploader-icon {
    width: 120px;
    height: 114px;
    line-height: 114px;
  }
  .upload-img {
    width: 100px;
    height: 94px;
  }
}

.sub-des {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-6);
}

.add-continue {
  cursor: pointer;
  font-size: 14px;

  font-weight: 400;
  color: var(--color);
  display: flex;
  align-items: center;
  justify-content: center;

  &:hover {
    opacity: 0.8;
  }
}

.my-cord {
  position: relative;

  .operation {
    z-index: 100;
    cursor: pointer;
    position: absolute;
    top: 0;
    right: 0;
    font-size: 12px;

    font-weight: 400;
    color: var(--color);
    display: flex;
    align-items: center;

    .algin {
      margin-left: 20px;
      display: flex;
      align-items: center;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
