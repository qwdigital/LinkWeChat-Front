<template>
  <div>
    <el-row :gutter="20" type="flex" style="margin-top: 20px;">
      <el-col>
        <div class="g-card">
          <el-form ref="baseForm" :rules="rules" :model="form" label-position="right" label-width="150px">
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
            <template v-if="form.fassionType == 1">
              <el-form-item label="添加员工" required>
                <SelectMemberVue
                  ref="selectMember"
                  :isDetail="isDetail"
                  title="发送范围"
                  :initData="form.addWeUserOrGroupCode.addWeUser"
                  @update="getMember"
                ></SelectMemberVue>
                <div class="sub-des">
                  引导新客户扫码时添加以上任意成员为好友
                </div>
              </el-form-item>
            </template>
            <template v-if="form.fassionType == 2">
              <el-form-item label="添加客群:" prop="chatIdList">
                <template v-for="(item, index) in groupList">
                  <el-tag v-if="item.groupName" size="medium" :key="index">{{ item.groupName }}</el-tag>
                </template>
                <div>
                  <el-button size="mini" type="primary" icon="el-icon-plus" @click="selectGroupFn">
                    {{ '添加' }}客群
                  </el-button>
                </div>
                <div class="sub-des">最多选择五个客群</div>
              </el-form-item>
              <el-form-item label="群满是否自动建群:">
                <el-switch
                  v-model="form.addWeUserOrGroupCode.addGroupCode.autoCreateRoom"
                  :active-value="1"
                  :inactive-value="0"
                ></el-switch>
                <div class="sub-des">默认以第一个群的群主作为新建群的群主</div>
              </el-form-item>
              <el-form-item v-if="form.addWeUserOrGroupCode.addGroupCode.autoCreateRoom" label="">
                <el-card>
                  <el-form-item label="群名前缀:" prop="addWeUserOrGroupCode.addGroupCode.roomBaseName">
                    <el-input
                      show-word-limit
                      maxlength="20"
                      v-model="form.addWeUserOrGroupCode.addGroupCode.roomBaseName"
                      placeholder="请输入群名前缀"
                    ></el-input>
                  </el-form-item>
                  <el-form-item label="群起始序号:" prop="addWeUserOrGroupCode.addGroupCode.roomBaseId">
                    <el-input-number
                      v-model="form.addWeUserOrGroupCode.addGroupCode.roomBaseId"
                      controls-position="right"
                      :min="1"
                    ></el-input-number>
                  </el-form-item>
                </el-card>
              </el-form-item>
            </template>
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
    <select-group :visible.sync="showSelectModal" :defaults="groupList" @submit="setSelectData"></select-group>
  </div>
</template>

<script>
  import SelectGroup from '@/views/drainageCode/components/SelectGroup.vue'
  import { templateDetail } from '@/api/contentCenter/modleCenter'
  import SelectPoster from '@/views/drainageCode/components/IdentitySelect'
  import SelectMemberVue from './SelectMember.vue'
  import TemplateLibrary from '@/components/ContentCenter/TemplateLibrary'

  export default {
    name: 'task-steps-setting',
    components: {
      SelectPoster,
      SelectMemberVue,
      TemplateLibrary,
      SelectGroup
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
          fassionType: 2,
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
            },
            addGroupCode: {
              autoCreateRoom: 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
              roomBaseName: '', //自动建群的群名前缀，当auto_create_room为1时有效
              roomBaseId: null, //自动建群的群起始序号，当auto_create_room为1时有效
              chatIdList: ''
              // groupNames: ''
            }
          },
          content: ''
        },
        rules: {
          chatIdList: [{ required: true, message: '请添加活码客群', trigger: 'blur' }],
          'addWeUserOrGroupCode.addGroupCode.roomBaseName': [
            { required: true, message: '请输入群名前缀', trigger: 'blur' }
          ],
          'addWeUserOrGroupCode.addGroupCode.roomBaseId': [
            { required: true, message: '请输入群起始序号', trigger: 'blur' }
          ]
        },
        posterObj: {},
        groupList: [],
        showSelectModal: false
      }
    },
    watch: {
      baseData: {
        handler(val) {
          this.form = val
          this.setData()
        },
        immediate: true
      },
      'form.content': {
        handler(val) {}
      }
    },
    methods: {
      setData() {},
      selectGroupFn() {
        this.showSelectModal = true
      },
      setSelectData(data) {
        if (data && data.length) {
          this.groupList = data
          this.form.addWeUserOrGroupCode.addGroupCode.chatIdList = this.groupList
            .map((dd) => {
              return dd.chatId
            })
            .join(',')
        }
      },
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

<style lang="scss" scoped>
  .sub-des {
    font-size: 12px;
    font-weight: 400;
    color: #999999;
  }
</style>
