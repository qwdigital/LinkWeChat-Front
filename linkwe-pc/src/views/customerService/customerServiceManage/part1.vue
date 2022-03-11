<template>
  <div>
    <el-row :gutter="10" type="flex" style="margin-top:10px;">
      <el-col :span="10">
        <div class="g-card g-pad20">
          <el-form ref="base" :rules="baseRules" :model="base" label-position="right" label-width="100px">
            <el-form-item label="客服名称:" prop="name">
              <el-input v-model="base.name" maxlength="15" show-word-limit clearable></el-input>
            </el-form-item>
            <el-form-item label="客服头像:" prop="avatar">
              <upload class="image-uploader" :fileUrl.sync="base.avatar" type="0"></upload>
              <div class="sub-des">
                建议大小 2M 以内，仅支持 png/jpg 等图片类型
              </div>
            </el-form-item>
            <el-form-item>
              <el-button plain @click="cancelFn">取消</el-button>
              <el-button type="primary" @click="nextStep">下一步</el-button>
            </el-form-item>
          </el-form>
        </div>
      </el-col>
      <el-col :span="14">
        <div class="g-card g-pad20" style="height: 100%">
          形象预览
          <div class="show-content">
            <show-in-phone name="客服消息" def="info" :avator="base.avatar" :call="base.name"></show-in-phone>
            <show-in-phone name="客服详情" def="detail" :avator="base.avatar" :call="base.name"></show-in-phone>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  import ShowInPhone from '../components/ShowInPhonePre.vue'
  export default {
    name: 'customer-service-part1',
    data () {
      return {
        base: {
          name: '',
          avatar: ''
        },
        baseRules: {
          name: [{ required: true, message: '请输入客服名称！', trigger: 'blur' }],
          avatar: [{ required: true, message: '请上传客服头像！', trigger: 'blur' }],
        }
      }
    },
    components: {
      ShowInPhone
    },
    props: {
      isEdit: {
        type: Boolean,
        default: false
      },
      editData: {
        type: Object,
        default: () => {
          return {
            name: '',
            avatar: ''
          }
        }
      }
    },
    watch: {
      isEdit: 'setEdit',
    },
    methods: {
      cancelFn () {
        this.$router.go(-1)
      },
      nextStep () {
        this.$refs['base'].validate(validate => {
          if (validate) {
            this.$emit('next', this.base)
          }
        })
      },
      setEdit () {
        if (this.isEdit) {
          console.log(this.editData)
          this.base.name = this.editData.name
          this.base.avatar = this.editData.avatar
        }
      }
    },
    mounted () {
      console.log(this.isEdit)
    },
    created () {
    }
  }
</script>
<style lang="scss" scoped>
  .show-content {
    margin-top: 20px;
    display: flex;
  }
  .sub-des {
    font-size: 12px;
    font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #999999;
  }
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
</style>