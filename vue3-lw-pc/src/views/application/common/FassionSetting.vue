<template>
  <div>
    <el-row :gutter="20" type="flex" style="margin-top: 20px;">
      <el-col>
        <div class="g-card">
          <el-form ref="baseForm" :rules="rules" :model="form" label-position="right" label-width="140px">
            <el-form-item label="选择海报:" prop="posterId">
              <el-button v-if="!isDetail" type="primary" icon="el-icon-plus" @click="choseDialog = true">
                {{ form.posterId ? '编辑' : '选择' }}海报
              </el-button>
              <div style="margin-top: 10px;" v-if="form.posterUrl">
                <ul class="el-upload-list el-upload-list--picture-card">
                  <li class="el-upload-list__item is-success">
                    <img style="width: 100%; height: 100%;" :src="form.posterUrl" />
                    <span class="el-upload-list__item-actions" v-if="!isDetail">
                      <span class="el-upload-list__item-delete">
                        <el-icon-delete class="el-icon-delete" @click="handleRemove"></el-icon-delete>
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
                  title="添加员工"
                  :initData="form.addWeUserOrGroupCode.addWeUser"
                  @update="getMember"
                ></SelectMemberVue>
                <div class="sub-des">引导新客户扫码时添加以上任意成员为好友</div>
              </el-form-item>
            </template>
            <template v-if="form.fassionType == 2">
              <el-form-item label="添加客群:" prop="addWeUserOrGroupCode.addGroupCode.chatIdList">
                <template v-for="(item, index) in groupList" :key="index">
                  <el-tag v-if="item.groupName" :key="index">{{ item.groupName }}</el-tag>
                </template>
                <div v-if="!isDetail">
                  <el-button type="primary" icon="el-icon-plus" @click="selectGroupFn">{{ '添加' }}客群</el-button>
                </div>
                <div class="sub-des">最多选择五个客群</div>
              </el-form-item>
              <el-form-item label="群满是否自动建群:">
                <el-switch
                  v-model="form.addWeUserOrGroupCode.addGroupCode.autoCreateRoom"
                  :active-value="1"
                  :inactive-value="0"
                  @change="setChange"
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
            <el-form-item label="任务文案" prop="content" style="margin-right: 200px !important;">
              <div v-if="!isDetail" style="margin-bottom: 10px;">
                <el-button type="primary" @click="welcomVisible = true">从模板库中选择</el-button>
              </div>
              <TextareaExtend
                :disabled="isDetail"
                v-model="form.content"
                :toolbar="isDetail ? [] : ['emoji']"
                maxlength="2000"
                show-word-limit
                placeholder="请输入"
                :autosize="{ minRows: 5, maxRows: 20 }"
                clearable
                :autofocus="false"
              />
            </el-form-item>
            <el-form-item label="活动标题" prop="activeTitle">
              <el-input
                :disabled="isDetail"
                show-word-limit
                maxlength="20"
                v-model="form.activeTitle"
                placeholder="请输入活动标题"
              ></el-input>
            </el-form-item>
            <el-form-item label="活动描述" prop="activeDescr">
              <el-input
                :disabled="isDetail"
                type="textarea"
                show-word-limit
                maxlength="30"
                v-model="form.activeDescr"
                placeholder="请输入活动描述"
              ></el-input>
            </el-form-item>
            <el-form-item label="活动封面" prop="activeCoverType">
              <el-radio-group v-model="form.activeCoverType" :disabled="isDetail" @change="chengeClear">
                <el-radio :label="1">海报缩略图</el-radio>
                <el-radio :label="2">自定义</el-radio>
              </el-radio-group>
              <template v-if="form.activeCoverType == 2">
                <el-form-item prop="activeCoverUrl">
                  <upload
                    :disabled="isDetail"
                    v-model:fileUrl="form.activeCoverUrl"
                    type="0"
                    :maxSize="10"
                    :format="['jpg', 'png']"
                  >
                    <template #tip
                      ><div class="tip">支持JPG、PNG格式，较好的效果为大图 1068*455，小图150*150</div></template
                    >
                  </upload>
                </el-form-item>
              </template>
            </el-form-item>
          </el-form>
        </div>
        <div class="g-footer-sticky" v-if="!isDetail">
          <el-button plain @click="gotoPre">上一步</el-button>
          <el-button type="primary" @click="gotoNext">下一步</el-button>
        </div>
      </el-col>
      <el-col style="flex-basis: 370px;" v-if="!isDetail">
        <div class="g-card" style="height: 100%;">
          <div class="info_title">消息预览</div>
          <PreviewInPhone
            :name="form.fassionType == 1 ? '客户' : '客群'"
            :list="[news]"
            :templateInfo="form.content"
          ></PreviewInPhone>
        </div>
      </el-col>
    </el-row>
    <!-- 选择海报 -->
    <SelectPoster v-model:choseDialog="choseDialog" @itemArry="getItemArry" :moduleType="5"></SelectPoster>
    <el-dialog
      title="选择模板"
      v-model="welcomVisible"
      width="60%"
      append-to-body
      :close-on-click-modal="false"
      v-if="welcomVisible"
    >
      <TemplateLibrary @changeObj="changeObj" />
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="selectModle">确 定</el-button>
          <el-button @click="welcomVisible = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    <select-group v-model:visible="showSelectModal" :defaults="groupList" @submit="setSelectData"></select-group>
  </div>
</template>

<script>
  import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
  import SelectGroup from '@/views/drainageCode/components/SelectGroup.vue'
  import { templateDetail } from '@/api/contentCenter/modleCenter'
  import SelectPoster from '@/views/drainageCode/components/IdentitySelect'
  import SelectMemberVue from './SelectMember.vue'
  import TemplateLibrary from '@/components/ContentCenter/TemplateLibrary'
  import { getPosterInfo } from '@/api/material/poster'
  export default {
    name: 'task-steps-setting',
    components: {
      SelectPoster,
      SelectMemberVue,
      TemplateLibrary,
      SelectGroup,
      PreviewInPhone
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
            },
            addGroupCode: {
              autoCreateRoom: 0, //当群满了后，是否自动新建群。0-否；1-是。 默认为0
              roomBaseName: '', //自动建群的群名前缀，当auto_create_room为1时有效
              roomBaseId: null, //自动建群的群起始序号，当auto_create_room为1时有效
              chatIdList: '',
              groupNames: ''
            }
          },
          content: '',
          activeTitle: '',
          activeDescr: '',
          activeCoverType: 1,
          activeCoverUrl: ''
        },
        rules: {
          posterId: [{ required: true, message: '请选择海报', trigger: 'blur' }],
          'addWeUserOrGroupCode.addGroupCode.chatIdList': [{ required: true, message: '请添加客群', trigger: 'blur' }],
          'addWeUserOrGroupCode.addGroupCode.roomBaseName': [
            { required: true, message: '请输入群名前缀', trigger: 'blur' }
          ],
          'addWeUserOrGroupCode.addGroupCode.roomBaseId': [
            { required: true, message: '请输入群起始序号', trigger: 'blur' }
          ],
          content: [{ required: true, message: '请输入任务文案', trigger: 'blur' }],
          activeTitle: [{ required: true, message: '请输入活动标题', trigger: 'blur' }],
          activeDescr: [{ required: true, message: '请输入活动描述', trigger: 'blur' }],
          activeCoverUrl: [{ required: true, message: '请选择活动封面', trigger: 'blur' }]
        },
        posterObj: {},
        groupList: [],
        showSelectModal: false,
        news: {
          materialName: '',
          digest: '',
          coverUrl: '',
          mediaType: '12'
        }
      }
    },
    watch: {
      baseData: {
        handler(val) {
          this.form = val
          // this.$forceUpdate()
          this.setData()
        },
        immediate: true
      },
      listenChange: {
        handler(val) {
          this.news.digest = val.activeDescr
          this.news.materialName = val.activeTitle
          if (this.form.activeCoverType == 2) {
            this.news.coverUrl = val.activeCoverUrl
          }
        }
      }
    },
    computed: {
      listenChange() {
        const { activeDescr, activeTitle, activeCoverUrl } = this.form
        return { activeDescr, activeTitle, activeCoverUrl }
      }
    },
    methods: {
      chengeClear(e) {
        if (e == 1) {
          this.news.coverUrl = this.posterObj.materialUrl
        } else {
          this.form.activeCoverUrl = ''
          this.news.coverUrl = ''
        }
      },
      setData() {
        this.news.digest = this.form.activeDescr
        this.news.materialName = this.form.activeTitle
        this.news.coverUrl = this.form.activeCoverUrl
        if (this.form.posterId) {
          // getPosterInfo(this.form.posterId).then((res) => {
          this.posterObj.materialUrl = this.form.posterUrl
          if (this.form.activeCoverType == 1) {
            this.news.coverUrl = this.posterObj.materialUrl
          }
          // })
        }
        if (!this.form.addWeUserOrGroupCode) {
          this.form.addWeUserOrGroupCode = {
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
              chatIdList: '',
              groupNames: ''
            }
          }
        }
        if (this.form.fassionType == 2) {
          if (this.form.addWeUserOrGroupCode.addGroupCode && this.form.addWeUserOrGroupCode.addGroupCode.chatIdList) {
            this.groupList = []
            let arr1 = this.form.addWeUserOrGroupCode.addGroupCode.chatIdList.split(',')
            let arr2 = this.form.addWeUserOrGroupCode.addGroupCode.groupNames.split(',')
            arr1.forEach((dd, index) => {
              let obj = {
                chatId: dd,
                groupName: arr2[index]
              }
              this.groupList.push(obj)
            })
          }
        }
      },
      setChange(data) {
        if (data == 0) {
          this.form.addWeUserOrGroupCode.addGroupCode.roomBaseName = ''
          this.form.addWeUserOrGroupCode.addGroupCode.roomBaseId = ''
        }
      },
      gotoNext() {
        this.$refs.baseForm.validate((validate) => {
          if (validate) {
            if (this.form.fassionType == 1) {
              if (this.$refs.selectMember.validateFn()) {
                this.$refs.selectMember.changeFn()
                this.updateData()
                this.$emit('next', 2)
              }
            } else {
              this.updateData()
              this.$emit('next', 2)
            }
          }
        })
      },
      gotoPre() {
        if (this.form.fassionType == 1) {
          this.$refs.selectMember.changeFn()
        }
        this.updateData()
        this.$emit('next', 0)
      },
      updateData() {
        this.$emit('update', this.form)
      },
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
          this.form.addWeUserOrGroupCode.addGroupCode.groupNames = this.groupList
            .map((dd) => {
              return dd.groupName
            })
            .join(',')
          console.log(this.form.addWeUserOrGroupCode.addGroupCode)
        } else {
          this.groupList = []
          this.form.addWeUserOrGroupCode.addGroupCode.chatIdList = ''
          this.form.addWeUserOrGroupCode.addGroupCode.groupNames = ''
        }
        this.updateData()
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
        if (this.form.activeCoverType == 1) {
          this.news.coverUrl = this.posterObj.materialUrl
        }
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
    color: var(--font-black-6);
  }
  .info_title {
    font-size: 16px;
    font-weight: 600;
    color: var(--font-black);
    margin-bottom: 10px;
  }
</style>
