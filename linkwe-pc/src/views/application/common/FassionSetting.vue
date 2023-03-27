<template>
  <div>
    <el-row :gutter="20" type="flex" style="margin-top: 20px;">
      <el-col>
        <div class="g-card">
          <el-form ref="baseForm" :rules="rules" :model="form" label-position="right" label-width="100px">
            <el-form-item label="选择海报:" prop="posterId">
              <el-button size="mini" type="primary" icon="el-icon-plus" @click="choseDialog = true">
                {{ form.posterId ? '编辑' : '选择' }}海报
              </el-button>
              <div style="margin-top: 10px;" v-if="form.posterUrl">
                <ul class="el-upload-list el-upload-list--picture-card">
                  <li class="el-upload-list__item is-success">
                    <img style="width: 100%; height: 100%;" :src="form.posterUrl" />
                    <span class="el-upload-list__item-actions">
                      <span class="el-upload-list__item-delete">
                        <i class="el-icon-delete" @click="handleRemove"></i>
                      </span>
                    </span>
                  </li>
                </ul>
              </div>
            </el-form-item>
            <el-form-item v-if="form.fassionType == 1" label="添加员工" required>
              <SelectMemberVue
                ref="selectMember"
                :isDetail="isDetail"
                title="发送范围"
                :initData="form.addWeUserOrGroupCode.addWeUser"
                @update="getMember"
              ></SelectMemberVue>
            </el-form-item>
            <el-form-item label="任务文案" required style="margin-right: 200px !important;">
              <div v-if="!isDetail" style="margin-bottom: 10px;">
                <el-button type="primary" @click="welcomVisible = true">从模板库中选择</el-button>
              </div>
              <TextareaExtend
                :disabled="isDetail"
                v-model="form.content"
                :toolbar="isDetail ? [] : ['emoji', 'insertCustomerNickName']"
                maxlength="2000"
                show-word-limit
                placeholder="请输入"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable
                :autofocus="false"
              />
            </el-form-item>
          </el-form>
        </div>
        <div class="g-footer-sticky">
          <el-button plain>上一步</el-button>
          <el-button type="primary">下一步</el-button>
        </div>
      </el-col>
      <el-col style="width: 370px;">
        <div class="g-card" style="height: 100%;">
          <div class="info_title">消息预览</div>
          <!-- <Preview :value="posterUrl"></Preview> -->
        </div>
      </el-col>
    </el-row>
    <!-- 选择海报 -->
    <SelectPoster :choseDialog.sync="choseDialog" @itemArry="getItemArry" :moduleType="5"></SelectPoster>
    <el-dialog
      title="选择模板"
      :visible.sync="welcomVisible"
      width="60%"
      append-to-body
      :close-on-click-modal="false"
      v-if="welcomVisible"
    >
      <TemplateLibrary @changeObj="changeObj" />
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="selectModle">确 定</el-button>
        <el-button @click="welcomVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import { templateDetail } from '@/api/contentCenter/modleCenter'
  import SelectPoster from '@/views/drainageCode/components/IdentitySelect'
  import SelectMemberVue from './SelectMember.vue'
  import TemplateLibrary from '@/components/ContentCenter/TemplateLibrary'

  export default {
    name: 'task-steps-setting',
    components: {
      SelectPoster,
      SelectMemberVue,
      TemplateLibrary
    },
    props: {
      isDetail: {
        type: Boolean,
        default: false
      },
      baseData: {
        type: Object,
        defalult: {}
      }
    },
    data() {
      return {
        welcomVisible: false,
        choseDialog: false,
        form: {
          posterId: '',
          posterUrl: '',
          fassionType: 1,
          addWeUserOrGroupCode: {
            addWeUser: {
              executeUserCondit: {
                change: false,
                weUserIds: []
              },
              executeDeptCondit: {
                change: false,
                deptIds: [],
                posts: []
              }
            }
          },
          content: ''
        },
        rules: {},
        posterObj: {}
      }
    },
    watch: {
      baseData: {
        handler(val) {
          this.setData(val)
        },
        immediate: true
      },
      'form.content': {
        handler(val) {}
      }
    },
    methods: {
      setData() {},
      changeObj(id) {
        if (id) {
          templateDetail(id).then((res) => {
            this.selectObj = res.data
          })
        }
      },
      selectModle() {
        if (this.selectObj) {
          this.welcomVisible = false
          this.form.content = this.selectObj.templateInfo
        } else {
          this.$message.error('请选择模板')
        }
      },
      handleRemove() {
        this.form.posterId = ''
        this.form.posterUrl = ''
      },
      getItemArry(data) {
        this.form.posterUrl = data[0].materialUrl
        this.form.posterId = data[0].id
        this.posterObj = data[0]
      },
      getMember(data) {
        this.form.addWeUserOrGroupCode.addWeUser = data
      }
    }
  }
</script>

<style lang="scss" scoped></style>
